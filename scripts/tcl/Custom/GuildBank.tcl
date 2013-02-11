# StartTCL: n
#Created by mLaPL - mlapeel@gmail.com - Pewex GuildBank System v1.0 - Pewex Element
#Multilanguage system by Luciolis - info@abitcomputer.com
#Language - EN PL FR SE DE RO CZ ES

namespace eval ::GuildBank {

	variable VERSION "v1.0"
	variable PAWEX_URL "scripts/Pewex"
	variable DB_URL "$PAWEX_URL/GuildBank"
	variable DB_FILE "$PAWEX_URL/GuildBank/bank.db"
	variable BACKUP_URL "$PAWEX_URL/GuildBank/BackUp"
	variable BACKUP_FILE "$PAWEX_URL/GuildBank/BackUp/backup.db"

	variable BON_TYPES "1 2 3 4"

	variable ADD_CASH "0 1 2 3 4 5 6 7 8 9"
	variable GET_CASH "0 1"
	variable ADD_ITEM "0 1 2 3 4 5 6 7 8 9"
	variable GET_ITEM "0 1 2"
	variable DROP_ITEM "0 1 2"

	variable USE_CONF_FILE 0
	variable BACKUP_TIME ""

	if { $USE_CONF_FILE } { ::Custom::LoadConf }
	
	file mkdir $PAWEX_URL
	file mkdir $DB_URL
	file mkdir $BACKUP_URL

	if { [file exists "$BACKUP_URL/retcl.txt"] } {
		file delete "$BACKUP_URL/retcl.txt"
	} elseif { [file exists "$BACKUP_URL/last_save.txt"] } {
		set file [open "$BACKUP_URL/last_save.txt" r+]
		set time [gets $file]
		close $file

	if { [file exists "$BACKUP_FILE\_$time"] } {
		if { [file exists $DB_FILE] } { file delete $DB_FILE }
			file copy "$::GuildBank::BACKUP_FILE\_$time" $DB_FILE
		}
	}

	package require sqlite3
	sqlite3 bank $DB_FILE
	bank eval { CREATE TABLE IF NOT EXISTS `bank` ( `guild` TEXT, `cash` TEXT, `items` TEXT, `admin` TEXT ) }
}

proc GuildBank::retcl { player } {

	if { [GetPlevel $player]>5 } {

	set file [open "$::GuildBank::BACKUP_URL/retcl.txt" w+]
	set $file "retcl"
	close $file

	}

}

proc GuildBank::CheckGuild { player } {

set pguild "[::GuildBank::GetGuildName $player]"
set gcash "[bank eval { SELECT `cash` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
set gitems "[bank eval { SELECT `items` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
set gitems [string trim $gitems "\{\}\[\]"]

if { $gcash=="" && $gitems=="" } {

bank eval {INSERT INTO `bank` (`guild`, `cash`, `items`) VALUES ( $pguild, "0", "")}
return

}

}

proc GuildBank::ItemBonding { item_id } {

	set bonding [GetScpValue "items.scp" "item $item_id" "bonding"]
	set bonding [string trim $bonding "\{\}\[\]"]
	set result ""

	if { $bonding=="" } { return "0" }

	set bond_type [split $::GuildBank::BON_TYPES " "]

	for {set i 0} {$i<=[llength $bond_type]} {incr i} {
		if { $bonding==[lindex $bond_type $i] } { set result 1 }
	}
	
	return $result
}


proc GuildBank::GetGuildName { player } {

	set guid [GetGuid $player]
	set file [open "saves/guilds.save"]
	set result ""
	set guild ""
	set member ""
	while { [gets $file line] >= 0 } {
      	set line [split $line "="]
		switch [lindex $line 0] {
			"NAME" { set guild [lindex $line 1] }
			"MEMBER" { set member [lindex [lindex $line 1] 0] }
		}
		if { $guild!="" } {
			if { $member==$guid } { 
				set result $guild
				break
			}
		}
	}
	close $file
      return $result
	#return "Bombay"
}

proc GuildBank::GetGuildRank { player } {

	set pguild [::GuildBank::GetGuildName $player]

	if { $pguild=="" } { return }

	set guid [GetGuid $player]
	set file [open "saves/guilds.save"]
	set guild ""
	set member ""
	while { [gets $file line] >= 0 } {
      	set line [split $line "="]
		switch [lindex $line 0] {
			"NAME" { set guild [lindex $line 1] }
			"MEMBER" { 
				set member [lindex [lindex $line 1] 0] 
				set rank [lindex [lindex $line 1] 1] 
			}
		}
		if { $guild!="" } {
			if { $member==$guid && $pguild==$guild } { 
				close $file
				return $rank
			}
		}
	}
	close $file
      return
	#return "0"
}


proc GuildBank::AddCash { player cargs } { 

	::GuildBank::CheckGuild $player

	if { $cargs=="" } { return }

	set pguild "[::GuildBank::GetGuildName $player]"


	if { $pguild=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "notmember"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}
	
	set grank [::GuildBank::GetGuildRank $player]
	
	if { [lsearch $::GuildBank::ADD_CASH $grank]<0 } {
		::Honor::Notify $player [::Custom::Color [Texts::Get "noperm"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set cargs [split $cargs "."]
	set cargs [lindex $cargs 0]
	set carg $cargs
	set cargs [expr { $cargs*10000}]
	if { $cargs<0 } { set cargs [expr { $cargs * -1 }] }
	set ile "-$cargs"

	if { [ChangeMoney $player $ile]!=1 } { 
		::Honor::Notify $player [::Custom::Color "You Not Have Cash" "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set ncash "0"
	set gcash "[bank eval { SELECT `cash` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	if { $gcash=="" } {
		bank eval {INSERT INTO `bank` (`guild`, `cash`, `items`) VALUES ( $pguild, $cargs, "")}
		::Honor::Notify $player [::Custom::Color [Texts::Get "addgold" $carg] "GREEN"]

	      return [::Honor::Commands $player "_notify"]
	} else {
		set ncash [expr { $gcash + $cargs }]
		bank eval {UPDATE `bank` set `cash` = $ncash WHERE ( `guild` = $pguild ) }
		::Honor::Notify $player [::Custom::Color [Texts::Get "addgold" $carg] "GREEN"]

	      return [::Honor::Commands $player "_notify"]

	}

}

proc GuildBank::GetCash { player cargs } { 

	::GuildBank::CheckGuild $player

	if { $cargs=="" } { return }

	set pguild "[::GuildBank::GetGuildName $player]"

	set cargs [split $cargs "."]
	set cargs [lindex $cargs 0]
	set carg $cargs
	set cargs [expr { $cargs*10000}]
	if { $cargs<0 } { set cargs [expr { $cargs * -1 }] }
	if { $pguild=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "notmember"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set grank [::GuildBank::GetGuildRank $player]
	
	if { [lsearch $::GuildBank::GET_CASH $grank]<0 } {
		::Honor::Notify $player [::Custom::Color [Texts::Get "noperm"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set ncash "0"
	set gcash "[bank eval { SELECT `cash` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"

      if { $gcash!="" } {
		set ncash [expr { $gcash - $cargs}]
      } else { 
		bank eval {INSERT INTO `bank` (`guild`, `cash`, `items`) VALUES ( $pguild, "0", "")}
		::Honor::Notify $player [::Custom::Color [Texts::Get "nogold" $carg] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	if { $ncash>=0 } { 
      	set ile "+$cargs"
		if { [ChangeMoney $player $ile]!=1 } { 
			::Honor::Notify $player "Error" 
			return [::Honor::Commands $player "_notify"]
		} else {
			bank eval {UPDATE `bank` set `cash` = $ncash WHERE ( `guild` = $pguild ) }
			::Honor::Notify $player [::Custom::Color [Texts::Get "getgold" $carg] "GREEN"]

	            return [::Honor::Commands $player "_notify"]
		}
	} else { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "nogold" $carg] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

}

proc GuildBank::AddItemm { player cargs } { 

	::GuildBank::CheckGuild $player

	if { $cargs=="" } { return }

      set pguild "[::GuildBank::GetGuildName $player]"

	if { $pguild=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "notmember"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set grank [::GuildBank::GetGuildRank $player]
	
	if { [lsearch $::GuildBank::ADD_ITEM $grank]<0 } {
		::Honor::Notify $player [::Custom::Color [Texts::Get "noperm"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set cargs [string trim $cargs "\{\}\[\]"]
      set cargs [split $cargs "."]
	set item [lindex $cargs 1]
	set ile [lindex $cargs 0]
	if { $ile=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "amount"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}
	set cargs "$item-$ile"
	set gcash "[bank eval { SELECT `cash` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	set gitems "[bank eval { SELECT `items` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	set gitems [string trim $gitems "\{\}\[\]"]

	set item_id [split $item ":"]
	set item_id [lindex $item_id 1]
	if { [::GuildBank::ItemBonding $item_id]=="1" } { 
		set result [Custom::Color [Texts::Get "soul_item"] "RED"] 

		::Honor::Notify $player $result

	      return [::Honor::Commands $player "_notify"]
	}
	set nitem_id $item_id
	puts "$gitems\n$gcash"
	
	if { $gitems=="" && $gcash!="" } {
				set nile 0
				for {set t 0} {$t<$ile} {incr t} {
						
						if { [ConsumeItem $player $item_id 1]=="1" } { 

						set nile [expr { $nile + 1 }]
						set result [Custom::Color [Texts::Get "additem"] "GREEN"]

						}
				}

		set items "$item-$nile."
		puts $items
		bank eval {UPDATE `bank` set `items` = $items WHERE ( `guild` = $pguild ) }
		::Honor::Notify $player $result
	      return [::Honor::Commands $player "_notify"]
	} else {
            set byl 0
		set nitems ""
		set ggitems [split $gitems "."]
		for {set i 0} {$i<=[llength $ggitems]} {incr i} {

			set gitemm [split [lindex $ggitems $i] "-"]
			set gitem "[lindex $gitemm 0]"
			set gile [lindex $gitemm 1]
			set nile $gile
			if { $gitem==$item } {
				set byl 1
				set item_id [split $item ":"]
				set item_id [lindex $item_id 1]
				set result [Custom::Color "" "GREEN"]
				for {set t 0} {$t<$ile} {incr t} {
						
						if { [ConsumeItem $player $item_id 1]=="1" } { 

						set nile [expr { $nile + 1 }]
						set result [Custom::Color [Texts::Get "additem"] "GREEN"]

						}
				
				}
				if { $gitem!=" " && $gitem!="" && $nile>0 && $nile!="" } { set nitems "$nitems$gitem-$nile." }
				
			} else {

				if { $gitem!=" " && $gitem!="" && $gile>0 && $gile!="" } { set nitems "$nitems$gitem-$gile." }
			
			}
		}

		if { $byl=="0" } { 

				set nile 0
				for {set t 0} {$t<$ile} {incr t} {
						
						if { [ConsumeItem $player $nitem_id 1]=="1" } { 

						set nile [expr { $nile + 1 }]
						set result [Custom::Color [Texts::Get "additem"] "GREEN"]

						}
				}

		if { $item!=" " && $item!="" && $ile>0 && $ile!="" } { set nitems "$nitems$item-$nile." }
		bank eval {UPDATE `bank` set `items` = $nitems WHERE ( `guild` = $pguild ) }
		
		set result [Custom::Color [Texts::Get "additem"] "GREEN"]

		}

	}


		bank eval {UPDATE `bank` set `items` = $nitems WHERE ( `guild` = $pguild ) }
		::Honor::Notify $player [::Custom::Color $result "YELLOW"]

	      return [::Honor::Commands $player "_notify"]

}


proc GuildBank::GetItem { player cargs } { 

	::GuildBank::CheckGuild $player

	if { $cargs=="" } { return }

      set pguild "[::GuildBank::GetGuildName $player]"

	if { $pguild=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "notmember"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set grank [::GuildBank::GetGuildRank $player]
	
	if { [lsearch $::GuildBank::GET_ITEM $grank]<0 } {
		::Honor::Notify $player [::Custom::Color [Texts::Get "noperm"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set cargs [string trim $cargs "\{\}\[\]"]
      set cargs [split $cargs "."]
	set item [lindex $cargs 2]
	set ile [lindex $cargs 1]
	if { $ile=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "amount"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}
	set avslots [lindex $cargs 0]
	set cargs "$item-$ile"

	set gitems "[bank eval { SELECT `items` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	set gitems [string trim $gitems "\{\}"]

	set gitems [split $gitems "."]
	set nitems ""
	set result ""
	set result [Custom::Color [Texts::Get "noitem"] "RED"]
	for {set i 0} {$i<=[llength $gitems]} {incr i} {

		set gitemm [split [lindex $gitems $i] "-"]
		set gitem "[lindex $gitemm 0]"
		set gile [lindex $gitemm 1]
		#puts "$gitem==$item"
		set nile $gile
		if { $gitem==$item } {
			if { $ile<=$gile } {
				set item_id [split $item ":"]
				set item_id [lindex $item_id 1]
				#puts "item_id=$item_id"
				for {set t 0} {$t<$ile} {incr t} {
					if { $avslots>=1 } { 
						AddItem $player $item_id
						set nile [expr { $nile - 1}]
						set avslots [expr { $avslots - 1 }]
					} 
				}
				if { $nile>0 } { set nitems "$nitems$gitem-$nile." }
				set result [Custom::Color [Texts::Get "getitem"] "GREEN"]
			} else {

				if { $gitem!="" } { set nitems "$nitems$gitem-$gile." }
				

			}


		} else {

			if { $gitem!="" } { set nitems "$nitems$gitem-$gile." }

		}

	}

	bank eval {UPDATE `bank` set `items` = $nitems WHERE ( `guild` = $pguild ) }
	::Honor::Notify $player $result

	return [::Honor::Commands $player "_notify"]


}

proc GuildBank::DropItem { player cargs } { 

	::GuildBank::CheckGuild $player

	if { $cargs=="" } { return }

      set pguild "[::GuildBank::GetGuildName $player]"

	if { $pguild=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "notmember"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set grank [::GuildBank::GetGuildRank $player]
	
	if { [lsearch $::GuildBank::DROP_ITEM $grank]<0 } {
		::Honor::Notify $player [::Custom::Color [Texts::Get "noperm"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set cargs [string trim $cargs "\{\}\[\]"]
      set cargs [split $cargs "."]
	set item [lindex $cargs 1]
	set ile [lindex $cargs 0]
	if { $ile=="" } { 
		::Honor::Notify $player [::Custom::Color "You Must Write Amount " "RED"]

		return [::Honor::Commands $player "_notify"]
	}
	set avslots [lindex $cargs 0]
	set cargs "$item-$ile"

	set gitems "[bank eval { SELECT `items` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	set gitems [string trim $gitems "\{\}"]

	set gitems [split $gitems "."]
	set nitems ""
	set result ""
	set result [Custom::Color [Texts::Get "noitem"] "RED"]
	for {set i 0} {$i<=[llength $gitems]} {incr i} {

		set gitemm [split [lindex $gitems $i] "-"]
		set gitem "[lindex $gitemm 0]"
		set gile [lindex $gitemm 1]
		puts "$gitem==$item"
		if { $gitem==$item } {

				set result [Custom::Color [Texts::Get "delitem"] "GREEN"]

		} else {

			if { $gitem!="" } { set nitems "$nitems$gitem-$gile." }

		}

	}

	bank eval {UPDATE `bank` set `items` = $nitems WHERE ( `guild` = $pguild ) }
	::Honor::Notify $player $result

	return [::Honor::Commands $player "_notify"]


}

proc GuildBank::ShowCash { player cargs } { 

	::GuildBank::CheckGuild $player

      set pguild "[::GuildBank::GetGuildName $player]"

	if { $pguild=="" } { 
		return [Texts::Get "notmember"]
	}
	set gcash "[bank eval { SELECT `cash` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	set gcash [expr { $gcash/10000}]

	
	return [Texts::Get "cash" $gcash]

}

proc GuildBank::ShowItems { player cargs } { 

	::GuildBank::CheckGuild $player

      set pguild "[::GuildBank::GetGuildName $player]"

	if { $pguild=="" } { 
		::Honor::Notify $player [::Custom::Color [Texts::Get "notmember"] "RED"]

		return [::Honor::Commands $player "_notify"]
	}

	set gcash "[bank eval { SELECT `cash` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	set gcash [expr { $gcash/10000}]
	set gitems "[bank eval { SELECT `items` FROM `bank` WHERE ( `guild` LIKE $pguild ) }]"
	set gitems [string trim $gitems "\{\}"]

	set gitems [split $gitems "."]

	set result ""

	for {set i 0} {$i<=[llength $gitems]} {incr i} {
		#puts [lindex $gitems $i]
		set itemm [split [lindex $gitems $i] "-"]
		set item "[lindex $itemm 0]"
		set ile [lindex $itemm 1]
		if { $item!="" } {
		set result "$result$ile - $item\n"
		}
	}
	
	return "Items In GuildBank:\n$result"

}

proc GuildBank::Backup { player cargs } {
	
	set time "[clock format [clock seconds] -format %k:%M:%S]"
	set time [split $time ":"]
	set hour [lindex $time 0]
	set min [lindex $time 1]
	set sec [lindex $time 2]
	set time "$hour\_$min\_$sec"

	if { $::GuildBank::BACKUP_TIME!=$hour || [GetPlevel $player]>=5 } {

		set loadinfo "Saving banks..."
		puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"

		set ::GuildBank::BACKUP_TIME $hour

		if { [file exists $::GuildBank::DB_FILE] } {

#			if { [file exists $::GuildBank::BACKUP_FILE] } {
				if { ![file exists "$::GuildBank::BACKUP_FILE]\_$time"] } {
					file delete "$::GuildBank::BACKUP_FILE\_$time"
					#file copy $::GuildBank::DB_FILE $::GuildBank::BACKUP_FILE
					#file delete "$::GuildBank::BACKUP_FILE"
					file copy $::GuildBank::DB_FILE "$::GuildBank::BACKUP_FILE\_$time"
				} else {
					file copy $::GuildBank::DB_FILE $::GuildBank::BACKUP_FILE
					#file delete "$::GuildBank::BACKUP_FILE"
					file copy $::GuildBank::DB_FILE "$::GuildBank::BACKUP_FILE\_$time"
				}
#			}

			set file [open "$::GuildBank::BACKUP_URL/last_save.txt" w+]
			puts $file $time
			close $file

			set loadinfo "done."
			puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"

		} else {

			set loadinfo "Cannot find GuildBank DataBase... ERROR"
			puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"

		}
	
		
	}

}

::Custom::AddCommand "bank_addcash" "::GuildBank::AddCash" 0
::Custom::AddCommand "bank_getcash" "::GuildBank::GetCash" 0
::Custom::AddCommand "bank_additem" "::GuildBank::AddItemm" 0
::Custom::AddCommand "bank_getitem" "::GuildBank::GetItem" 0
::Custom::AddCommand "bank_dropitem" "::GuildBank::DropItem" 0
::Custom::AddCommand "bank_showitem" "::GuildBank::ShowItems" 0
::Custom::AddCommand "bank_showcash" "::GuildBank::ShowCash" 0

::Custom::AddCommand "worldsaved" "::GuildBank::Backup" 0

::Custom::HookProc "::WoWEmu::Commands::retcl" { ::GuildBank::retcl $player }
