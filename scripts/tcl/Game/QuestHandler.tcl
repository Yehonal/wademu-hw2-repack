# StartTCL: z 

namespace eval QuestShare {

	package require sqlite3
	sqlite3 Manage_QTDB "saves/qtdb.db"

	if { ![file size "saves/qtdb.db"] } {
		Manage_QTDB eval { CREATE TABLE IF NOT EXISTS `qtdb` ( `playerguid` TEXT, `questid` TEXT, `title` TEXT ) }
		set info "SQLite3 QuestShare database(QTDB) created."
		puts "[clock format [clock seconds] -format %k:%M:%S]:M:$info"
	}
	set loadinfo "Quest Share Script loaded - SQLite3"
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"

	proc ClickOnShareQuest { player cargs } {
		regsub -all -- {\}} $cargs {} cargs 
		regsub -all -- {\{} $cargs {} cargs 

		set CanShare 1
		set PlayerGUID [GetGuid $player]
		set target [GetSelection $player]
		set npc [GetSelection $target]
		set playername [GetName $player]
		set partyname [GetName $target]

		# Condition 1) the player must select the relation (green onion mote unit) to do a quest joint ownership.
		if { $cargs == "TargetIsNotInParty" } { return "$playername is not in party!" }

		# Condition 2) the object which the green onion mote unit is selecting must be the NPC
		set npcid [GetEntry $npc]
		set npcquestscript [GetScpValue "creatures.scp" "creature $npcid" "questscript"]
		if { $npcquestscript != "MasterScript" } { return "$partyname Cannot share this quest given by the NPC" }

		# Condition 3) there must be a possibility of searching the questid from the QTDB of the player.
		set QuestID_QTDB [ Manage_QTDB eval { SELECT `questid` FROM `qtdb` WHERE (`playerguid`=$PlayerGUID AND `title`=$cargs) } ]
		if { $QuestID_QTDB == "" } { return "In QTDB search result agreement contents nil. QTDB error"
		} else { set CanShare 1 }

		# Condition 4) the green onion mote unit accomplishes a corresponding quest and it is not being revealed not must be.
		switch [GetQuestStatus $target $QuestID_QTDB] {
			0 { set CanShare 0 }
			1 { return "$partyname It completed this quest already" }
			2 { set CanShare 0 }
			3 { return "$partyname Already it is in the process of accomplishing this quest." }
			4 { set CanShare 1 }
		}

		# Condition 5) the green onion mote unit must be suitable in requirement important matter of correspondence quests.scp.
		set requirements [join [GetScpValue "quests.scp" "quest $QuestID_QTDB" "requirements"]]
		if { ![MasterScript::CheckReqs $target $requirements] } { return "$partyname This quest is not suitably." }

		# Quest joint ownership
		if { $CanShare } { SendQuestDetails $target $npc $QuestID_QTDB 
			return "$partyname it gives a joint ownership quest contents." }

		return "$partyname It cannot convey a joint ownership quest contents."
	}

	proc QuestInsert { player questid } {
		set PlayerGUID [GetGuid $player]
		set QuestTitle [GetScpValue "quests.scp" "quest $questid" "name"]
		regsub -all -- {\}} $QuestTitle {} QuestTitle
		regsub -all -- {\{} $QuestTitle {} QuestTitle

		if {[Manage_QTDB exists {SELECT 1 FROM `qtdb` WHERE (`playerguid`=$PlayerGUID AND `questid`=$questid) }]} {
			set Read_QTDB [ Manage_QTDB eval { SELECT * FROM `qtdb` WHERE (`playerguid`=$PlayerGUID AND `questid`=$questid) } ]
			Manage_QTDB eval { DELETE FROM `qtdb` WHERE (`playerguid`=$PlayerGUID AND `questid`=$questid) }
			Manage_QTDB eval { INSERT INTO `qtdb` VALUES( $PlayerGUID, $questid, $QuestTitle ) }
		} else {
			Manage_QTDB eval { INSERT INTO `qtdb` VALUES( $PlayerGUID, $questid, $QuestTitle ) }
		} 
		return
	}

	proc QuestDelete { player questid } {
		set PlayerGUID [GetGuid $player]

		if {[Manage_QTDB exists {SELECT 1 FROM `qtdb` WHERE (`playerguid`=$PlayerGUID AND `questid`=$questid) }]} {
			set Read_QTDB [ Manage_QTDB eval { SELECT * FROM `qtdb` WHERE (`playerguid`=$PlayerGUID AND `questid`=$questid) } ]
			Manage_QTDB eval { DELETE FROM `qtdb` WHERE (`playerguid`=$PlayerGUID AND `questid`=$questid) }
		} else {
			Say $player 0 "Error: After quest completing the result agreement nil which searches the DB."
		} 
		return
	}

	Custom::AddCommand "sharequest" "QuestShare::ClickOnShareQuest"
}



namespace eval MasterScript {
    #windsky : here to add reward script
    proc WindskyQuestReward { obj player questid windskyreward } {
        switch $windskyreward {
            addt1 {
                Say $player 0 "I got T1"
                AddItem $player 16806
                AddItem $player 16804
                AddItem $player 16805
                AddItem $player 16810
                AddItem $player 16809
                AddItem $player 16807
                AddItem $player 16808
                AddItem $player 16803
                return
            }
            default { return }
        }
    }
    
    #fixed quest system , if had deliveritem before accepting quest then cannot finish quest , now fixed it
    variable playernameOnquest
    
    proc MakeDB { } {
        wsps_db eval {CREATE TABLE IF NOT EXISTS `haditemquest` (`playername` TEXT NOT NULL, `questid` INTEGER NOT NULL, `deliveritems` TEXT NOT NULL)}
    }
    
    proc init {} {
        puts "[clock format [clock seconds] -format %k:%M:%S]:M:Initializing MasterScript Fixed System. (C) 2007 windsky "
        package require sqlite3
        sqlite3 wsps_db "saves/wsps.db"
        if { ! [ string length [ wsps_db eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'haditemquest') } ] ] }   {
            MakeDB
            set MasterScript::playernameOnquest ""
            puts "[clock format [clock seconds] -format %k:%M:%S]:M:SQLite3 WSPS database created."
        } else {
            set MasterScript::playernameOnquest [join [ wsps_db eval {SELECT `playername` FROM `haditemquest`} ]]
        }
        #hook
        ::Custom::HookProcAfter "MasterScript::QuestAccept" {
            set deliveritemlist [join [GetScpValue "quests.scp" "quest $questid" "deliveritems"]]
            set playername [GetName $player]
            if { $deliveritemlist != "" } {
                foreach {deliveritem delivercount} $deliveritemlist {
                    if { [ConsumeItem $player $deliveritem 1] ==1 } {
                        wsps_db eval {INSERT INTO `haditemquest` (`playername`, `questid`, `deliveritems`) VALUES ($playername,$questid,$deliveritemlist)}
                        lappend ::MasterScript::playernameOnquest [GetName $player]
                        AddItem $player $deliveritem
                        break
                    }
                }
            }
        }
        #hook
        ::Custom::HookProcAfter "MasterScript::QuestChooseReward" {
            set windskyreward [GetScpValue "quests.scp" "quest $questid" "windskytcl"]
            if { $windskyreward != "" } {    WindskyQuestReward $obj $player $questid $windskyreward }
        }
        #hook
        ::Custom::HookProc "MasterScript::GossipHello" {
            set playername [GetName $player]
            if { [lsearch $::MasterScript::playernameOnquest $playername] != -1 } {
                set questid [join [ wsps_db eval {SELECT `questid` FROM `haditemquest` WHERE (`playername` = $playername)} ]]
                set deliveritemlist [join [ wsps_db eval {SELECT `deliveritems` FROM `haditemquest` WHERE (`playername` = $playername)} ]]
                #Say $player 0 "deliveritemlist : $deliveritemlist; questid : $questid";debug
                foreach {deliveritem count} $deliveritemlist {
                    #Say $player 0 "deliver : $deliveritem; count : $count";debug
                    for { set windskyi 0 } { $windskyi<$count } {incr windskyi} {
                        if { [ConsumeItem $player $deliveritem 1] == 0 } { break }
                    }
                    for { set windskyj 0 } { $windskyj<$windskyi } {incr windskyj} { AddItem $player $deliveritem }
                }
                wsps_db eval {DELETE FROM `haditemquest` WHERE (`playername` = $playername)}
                set MasterScript::playernameOnquest [join [ wsps_db eval {SELECT `playername` FROM `haditemquest`} ]]
            }
        }
        #hook
        ::Custom::HookProc "MasterScript::RequestReward" {
            set deliveritemlist [join [GetScpValue "quests.scp" "quest $questid" "deliveritems"]]
            if { $deliveritemlist == "" } { set deliveritemlist [join [GetScpValue "quests.scp" "quest $questid" "deliver"]] }
            if { $deliveritemlist != "" } {
                set itemcheck 1
                if { [llength $deliveritemlist] == 1 } { lappend deliveritemlist 1 }
                foreach {deliveritem count} $deliveritemlist {
                    for { set windskyi 0 } { $windskyi<$count } {incr windskyi} {
                        if { [ConsumeItem $player $deliveritem 1] == 0 } { break }
                    }
                    for { set windskyj 0 } { $windskyj<$windskyi } {incr windskyj} { AddItem $player $deliveritem }
                    if { $windskyi != $count } {set itemcheck 0;break}
                }
                if { $itemcheck == 0 } {
                    Say $obj 0 [::Texts::Get "The item is not in your bags!"]
                    SendGossipComplete $player
                    return
                }
            }
            set rewmoney [join [GetScpValue "quests.scp" "quest $questid" "reward_gold"]]
            set rewmoneychanged 0
            if { ($rewmoney != "") && ([expr int($rewmoney)]<0) } {
                set rewmoney [expr abs($rewmoney)]
                if {![ ::ChangeMoney $player -$rewmoney ]} {
                    Say $obj 0 [::Texts::Get "Not enough money!"]
                    SendGossipComplete $player
                    return }
                set rewmoneychanged 1
            }
            set reqitem [join [::GetScpValue "quests.scp" "quest $questid" "req_item"]]
            if {[lindex $reqitem 0] != ""} {
                set reqamount [lindex $reqitem 1]
                set reqid [lindex $reqitem 0]
                set itemsection "item $reqid"
                set itemname [join [::GetScpValue "items.scp" $itemsection "name"]]
                if {![ ::ConsumeItem $player $reqid $reqamount ] } {
                    Say $obj 0 [::Texts::Get "You dont have $itemname and $reqamount in your bag!"]
                    SendGossipComplete $player
                    # cannot finish quest , give back money to player
                    if { $rewmoneychanged == 1 } { ::ChangeMoney $player +$rewmoney }
                    return }
            }
            #give back money , because code "SendQuestReward" will decrease player money with value reward_gold
            if { $rewmoneychanged == 1 } { ::ChangeMoney $player +$rewmoney }
        }
    }
    init
}






