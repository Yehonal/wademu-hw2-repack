
## Reputation Kill Bonus fix v6- by Knockwurst  (12/01/06)
## ---------------------------------------
## 
##  you must add lines to creatures.scp entries for this to work.
##
## use this format:    
##
## reputation=(creature id) (faction id that gets rep. points) (number of points) (max reputation level points are given at)
## 
## a good entry will look like this:   reputation=635 500 42000 1601 100 42000
##
## (This is for C'thun who gives 500 points for cenarion circle up to exalted, 100 points for brood of nozdormu
## which can be won up to exalted.)
##-------------------------------------------
##
## This also requires that you change 3 lines in your masterscript.tcl for quest spillover to work.
##	
##   replace this :  AddReputation $player $obj $repu
##
##   with this: ::WoWEmu::QuestRepReward $player $obj $repu $questid
##
## (it appears 3 times in the tcl, replace all 3)
##


::Custom::HookProc "::WoWEmu::CalcXP" {

set section "creature [::GetEntry $victim]"

set reputation [join [::GetScpValue "creatures.scp" $section "reputation"]]
if {$reputation != ""} {

			set originalfaction [::GetScpValue "creatures.scp" $section "faction"]
			foreach {faction bonus max} $reputation {
				
				set replevel [::GetReputation $killer $victim] 
		
				if { $replevel < $max } { 
					::SetFaction $victim $faction
					set plevel [::GetLevel $killer]
					set moblevel [::GetLevel $victim]
						    
					if { $plevel > 60 } { set level_limit [ expr { $plevel - 12 } ]
					} elseif { $plevel > 40 } { set level_limit [ expr { $plevel * 4 / 5 } ]
					} else { set level_limit [ expr { $plevel - $plevel / 10 - 4 } ] }
					set greylevel  [ expr $level_limit - 1 ]
					
					if { $moblevel <= $greylevel } { 
					set lvldiff [ expr { $greylevel - $moblevel } ]
					if {$lvldiff < 5 } { 
					set award [ expr { round( $bonus * (($lvldiff - (($lvldiff * $lvldiff) * .2)) / $lvldiff) ) } ]               
					} else { set award [ expr { round($bonus * .2) } ]}
					} else { set award $bonus }
					
					if { [GetRace $killer] == 1 } { set award [ expr { round($award * 1.1)}] }
				        ::AddReputation $killer $victim $award 
					::WoWEmu::RepSpillover $killer $victim $faction $award	
					::SetFaction $victim $originalfaction	
				}	
			}
		}
	}

proc ::WoWEmu::RepSpillover { player obj faction award } {
		
	variable Steamwheedle
	array set Steamwheedle { 120 120 121 120 390 120 854 854 855 854 474 474 475 474 637 637 69 637}
	variable Alliance
	array set Alliance {1600 1600 1594 1600 1097 1600 1076 1600 124 1600 80 1600 79 1600 64 64 23 64 875 64 55 55 1395 55 57 55 122 55 1575 1575 12 1575 1078 1575 148 1575 11 1575 123 1575}
	variable Allianceforces
	array set Allianceforces {1514 1514 1534 1534 1596 1534 1216 1534 1217 1534 1334 1534 777 777 1577 777 1599 777}
	variable Horde
	array set Horde { 126 126 876 126 877 126 1595 1595 1074 1595 29 1595 65 1595 125 1595 1174 1595 85 1595 105 105 995 105 104 105 118 118 71 118 98 118 1134 118 1154 118 68 118 }    
	variable Hordeforces
	array set Hordeforces {1597 1597 1214 1597 1215 1597 1335 1597 1554 1597 412 412 1598 412 1515 1515}
	
	set sreward "120 854 474 637"
	set areward "1600 64 55 1575"
	set afreward "1514 1534 777"
	set hreward "126 1595 105 118"
	set hfreward "1597 412 1515"

	if { [ info exists Steamwheedle($faction) ] } { 
		set spill [ expr { round($award * .5) } ] 
		set parent $Steamwheedle($faction)
		foreach {member} $sreward {
		if {$member != $parent } { 
			::SetFaction $obj $member
			::AddReputation $player $obj $spill 
			}
		}
	} elseif { [ info exists Alliance($faction) ] } { 
		set spill [ expr { round($award * .25) } ] 
		set parent $Alliance($faction)
		foreach {member} $areward {
		if {$member != $parent } { 
			::SetFaction $obj $member
			::AddReputation $player $obj $spill 
			}
		}
	} elseif { [ info exists Allianceforces($faction) ] } { 
		set spill [ expr { round($award * .25) } ] 
		set parent $Allianceforces($faction)
		foreach {member} $afreward {
		if {$member != $parent } { 
			::SetFaction $obj $member
			::AddReputation $player $obj $spill 
			}
		}
	} elseif { [ info exists Horde($faction) ]  } { 
		set spill [ expr { round($award * .25) } ] 
		set parent $Horde($faction)

		foreach {member} $hreward {
		if {$member != $parent } { 
			::SetFaction $obj $member
			::AddReputation $player $obj $spill 
			}
		}
	} elseif { [ info exists Hordeforces($faction) ] } { 
		set spill [ expr { round($award * .25) } ] 
		set parent $Hordeforces($faction)
		foreach {member} $hfreward {
		if {$member != $parent } { 
			::SetFaction $obj $member
			::AddReputation $player $obj $spill 
			}
		}
	}
	::SetFaction $obj $faction
}



proc ::WoWEmu::QuestRepReward { player obj repu questid } {
	
	set section "creature [::GetEntry $obj]"
	set faction [join [::GetScpValue "creatures.scp" $section "faction"]]
	set qlevel [lindex [GetScpValue "quests.scp" "quest $questid" "levels"] 0 0]
	set plevel [::GetLevel $player]
        set level_diff [ expr { $plevel - ($qlevel + 6) } ]
	if {$level_diff >= 5 } {set qaward [ expr { round($repu * .2) } ] }
	if { ($level_diff >= 0) && ($level_diff < 5) } { set qaward [ expr { round( $repu * (($level_diff - (($level_diff * $level_diff) * .2)) / $level_diff) ) } ] } 
        if { $level_diff < 0 } { set qaward $repu }
	if { [GetRace $player] == 1 } { set qaward [ expr { round($qaward * 1.1)}] }
	AddReputation $player $obj $qaward
        ::WoWEmu::RepSpillover $player $obj $faction $qaward 

}





