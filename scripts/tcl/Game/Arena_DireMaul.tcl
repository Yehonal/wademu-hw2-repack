#
# StartTCL: n
#
# ====================================
#
# Dire Maul PVP Arena script
#
# ====================================
#
# Modified by Delfin
# 01.05.06
#
# Start-TCL 0.9.4 compatible
#


#
# player level 0
#
#
#   PVP needs variable to be set before loading
#      default 1 [open] on startup 
namespace eval ::WoWEmu::Commands {
		variable PVP2_stat 0
}
proc ::WoWEmu::Commands::pvp2 { player cargs } {

	# PVP needs variable to be set before loading default 0 [closed] on startup 
	variable PVP2_stat

	set option [lindex $cargs 0]
	if { [ ::ngjail::IsJailed  [::GetName $player] ] == 1 } {
		 set msg " You are jailed, no pvp for you" 
	} else {
		switch $cargs {
	"close" {
					if { [GetPlevel $player] < 2 } { return "|cFFFFA333You are not allowed to use this command" }
           set PVP2_stat 0
           set msg "\nDire Maul arena is now Closed!!!" 
				}
 	"enter" {
					if { $PVP2_stat == 0 } {
       			set msg "\nDire Maul PVP Arena: \nArena is closed now, please wait unitil an event takes place"
       		} else {
#						if { [GetPlevel $player] < 30 } { return "|cFFFFA333You have to be at least lvl 30" }
       			if { [GetHealthPCT $player] != 100 } {{ return "|cFFFFA333You arent fully healed, heal first, PvP later." } 
     				::Teleport $player 1 -3882.659424 1095.236084 154.787018 }
   				}
   		}
	"leave" {
					if { $PVP2_stat == 0 } {
           	set msg "\nDire Maul PVP Arena: \nArena is closed now, use heartstone to get home!"
           } else {
           	::Custom::GoHome $player
           }
   		}
  "open" {
					if { [GetPlevel $player] < 2 } { return "|cFFFFA333You are not allowed to use this command" }
     		  if { $PVP2_stat == 1 } {
           set msg "\nDire Maul Arena was already opened!"
           } else {
               set PVP2_stat 1 
               set msg "\nDire Maul arena is now Open!!!"
           }
       }
   "info" {
   				set msg "\n Battles take place inside the BATTLE RING only! \nviolators will be jailed! \nPlease report abuses to GM's"
				}
	default {
					if { $PVP2_stat == 0 } {
						set PVPtxt "closed"
					} else { 
						set PVPtxt "open"
					}
					if { [GetPlevel $player] < 2 } {
						set msg "\nDire Maul PVP Arena: \nTo ENTER the pvp arena type .pvp2 enter \nTo LEAVE the pvp arena type .pvp2 leave \nFor information type .pvp2 info\nArena is currently $PVPtxt"
					} else {
						set msg "\nDire Maul PVP Arena: \nTo OPEN the pvp arena type .pvp2 open \nTo CLOSE the pvp arena type .pvp2 close \nFor information type .pvp2 info \nArena is currently $PVPtxt"
					}
			}
		}
	}
}

::Custom::AddCommand {"pvp2" ::WoWEmu::Commands::pvp2 0}
