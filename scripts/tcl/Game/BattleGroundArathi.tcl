# StartTCL: z
# BE SURE, THEN ARATHI WILL LOAD AFTER HONOR.tcl!!
namespace eval Battleground {
	variable UsePewexHonor        0
	variable KickFromWaitTime     60
	variable TimeToLeaveBG        1
	variable WinPoints            2000
	variable ItemIDForWinner      20559
	variable ItemIDForLooser      20559
	variable ItemsForWinner       3
	variable ItemsForLooser       1
	variable HonorRate            30
	variable BaseCaptureDist      10
	variable BaseCaptureTimes     10
	variable BaseNeutralTimes     9
	variable MaxInGame            30
	variable MinInTeam            0
	variable MinLevel             15
	variable BaseGuardLootemplate 27000
	variable GuardAutoAttack      1
	variable MessageID            1
	variable FinishMessageSending 1
	variable EvalID               1
	variable EvalQueue            1
	variable GameStatus           1
	variable EveryTimeToLeave     1
	variable AlliesTeamScore      1
	variable HordeTeamScore       1
	variable WinnerTeam           1
	variable CloseGameEnd         0
	variable SaveWhiled
	array set SaveWhiled {
		1 0
		2 0
		3 0
		4 0
	}
	variable WhiledLevel
	array set WhiledLevel {
		1 3
		2 15
		3 30
		4 90
	}
      variable AlliesBaseGuard
	array set AlliesBaseGuard {
		27000 Blacksmith
		27001 Stables
		27002 Farm
		27003 Mill
		27004 Mine
	}
      variable HordeBaseGuard
	array set HordeBaseGuard {
		27010 Blacksmith
		27011 Stables
		27012 Farm
		27013 Mill
		27014 Mine
	}
	variable BasesPos
	array set BasesPos {}
	variable Bases
	array set Bases {
		Blacksmith 0
		Stables    0
		Farm       0
		Mill       0
		Mine       0
	}
	variable InGameList
	array set InGameList {}
	variable WaitingList
	array set WaitingList {}
	variable WaitingQueue
	array set WaitingQueue {} 
}
proc ::Battleground::ShowError { text } {
	if { $text!="" } {
		set file [open "ErrorArathiBG.txt" w+]
		puts $file "ERROR: $text"
		close $file
		exec notepad "ErrorArathiBG.txt" &
		#exit
	}
	
}
proc ::Battleground::SpiritHonor { pname command { value "0" } } {
	
	if { $command=="test" } {
		set test1 [::Honor::GetHonorableKillsByName $pname]
		set test2 [::Honor::GetRankByName $pname]
		set test3 [::Honor::ChangeRatingByName $pname $value 0 "ArathiBG Test Procedure"]
		if { $test1!=1 && $test2!=1 && $test3!=1 } { return 1 } { return 0 }
	}
	if { $command=="getkills" } {
		return [::Honor::GetHonorableKillsByName $pname]
	}
	if { $command=="getrank" } {
		return [::Honor::GetRankByName $pname]
	}
	if { $command=="addhonor" } {
		return [::Honor::ChangeRatingByName $pname $value 0 "Battleground Arathi Basin"]
	}
	
}
if { $::Battleground::UsePewexHonor==0 } {
	if { ![info exists ::Honor::VERSION] } { ::Battleground::ShowError "System Need Spirit Honor System\n if you have Pewex Honor System then change UsePewexHonor=1 in config file..." }
	if { [info procs "::Honor::GetRankByName"]== "" } { ::Battleground::ShowError "System Need Proc To Get Honor Ranks" }
	if { [info procs "::Honor::GetHonorableKillsByName"]== "" } { ::Battleground::ShowError "System Need Proc To Get Honorable Kills" }
	if { [info procs "::Honor::ChangeRatingByName"]== "" } { ::Battleground::ShowError "System Need Proc To Add Honor Points" }
	if { [::Battleground::SpiritHonor "test" "test"]==1 } { ::Battleground::ShowError "SpititHonor System error..." }
} {
	if { ![info exists ::PHonor::VERSION] } { ::Battleground::ShowError "System Need Pewex Honor System" }
	if { ![info exists ::PHonor::HONOR] } { ::Battleground::ShowError "System Need Variable ::PHonor::HONOR From Pewex Honor System" }
}
proc ::Battleground::GetHonorKills { pname } {
	if { $::Battleground::UsePewexHonor==1 } {
		if { ![info exists ::PHonor::HONOR($pname,plus)] } { set ::PHonor::HONOR($pname,plus) 0 }
		return $::PHonor::HONOR($pname,plus)
	} {
		return [::Battleground::SpiritHonor $pname "getkills"]
	}
}
proc ::Battleground::GetHonorRank { pname } {
	if { $::Battleground::UsePewexHonor==1 } {
		if { ![info exists ::PHonor::HONOR($pname,rank)] } { set ::PHonor::HONOR($pname,rank) 0 }
		return $::PHonor::HONOR($pname,rank)
	} {
		return [::Battleground::SpiritHonor $pname "getrank"]
	}
}
proc ::Battleground::AddPlayerHonor { player points } {
	if { $::Battleground::UsePewexHonor==1 } {
		::PHonor::Change $player $points "good"
	} {
		set pname [GetName $player]
		::Battleground::SpiritHonor $pname "addhonor" $points
		::Battleground::AddMessage $player "You Get $points Honor Points" "0.2#1#0.2"
	}
}
proc ::Battleground::GetSide {player} {
        set race [GetRace $player]
        set side 1
        switch $race {
          2 {set side 2}
          5 {set side 2}
          6 {set side 2}
          8 {set side 2}
        }
        return $side
}
proc ::Battleground::GetRaceName {player} {
        set race [GetRace $player]
        switch $race {
          1 {return "Human"}
          2 {return "Orc"}
          3 {return "Dwarf"}
          4 {return "Night Elf"}
          5 {return "Undead"}
          6 {return "Tauren"}
          7 {return "Gnome"}
          8 {return "Night Elf"}
        }
        return ""
}
    
proc ::Battleground::GetClassName {player} {
     set class [GetClass $player]
     switch $class {
          1 {return "Warrior"}
          2 {return "Paladin"}
          3 {return "Hunter"}
          4 {return "Rogue"}
          5 {return "Priest"}
          6 {return "unk1"}
          7 {return "Shaman"}
          8 {return "Mage"}
          9 {return "Warlock"}
         10 {return "unk2"}
         11 {return "Druid"}
     }
     return ""
}
proc ::Battleground::GetNumPlayersBySide { pool side } {
		set numPlayers 0
		set players ""
		
		if { $pool == "Play" } {
			set players [array names ::Battleground::InGameList]
		} elseif { $pool == "Wait" } {
			set players [array names ::Battleground::WaitingList]
		} elseif { $pool == "Queue" } {
			set players [array  names ::Battleground::WaitingQueue]
		}
		foreach player $players {
			if { [::Battleground::GetSide $player] == $side } {
				incr numPlayers
			}
		}
		return $numPlayers
	
}
proc ::Battleground::AddMessageAudio { to text color audio } {
		incr ::Battleground::MessageID
		set ::Battleground::MessageQueue($::Battleground::MessageID,to) $to
		set ::Battleground::MessageQueue($::Battleground::MessageID,text) $text
		set ::Battleground::MessageQueue($::Battleground::MessageID,color) $color
		set ::Battleground::MessageQueue($::Battleground::MessageID,audio) $audio
	
}
proc ::Battleground::inWaitingPlay { player } {
		if { [info exists ::Battleground::WaitingList($player)]  } {
			return true
		}
		return false
	
}
proc ::Battleground::AddEval { evalString } {
		incr ::Battleground::EvalID
		set ::Battleground::EvalQueue($::Battleground::EvalID) $evalString
	
}
proc ::Battleground::GetInfoInstance { player cargs } {
		set numHorde [::Battleground::GetNumPlayersBySide "Wait" 2]
		set numAlliance [::Battleground::GetNumPlayersBySide "Wait" 1]
		
		set playHorde [::Battleground::GetNumPlayersBySide "Play" 2]
		set playAlliance [::Battleground::GetNumPlayersBySide "Play" 1]
			
		return "bg_info_inst#Arathi Basin\nCollecting Resource\n1-60 Levels test mode\n$playAlliance alliance and $playHorde hordes in game\n$numAlliance alliance and $numHorde horde wait start\n[array size ::Battleground::WaitingQueue] in queue#1#[array size ::Battleground::WaitingQueue]#$::Battleground::MaxInGame#100"
	
}
proc ::Battleground::leavePlayer { player } {
	::Battleground::Leave $player ""
}
proc ::Battleground::ResourceInfo { player cargs } {
		::Battleground::Whiled
		if { ![::Battleground::inGame $player] } {
			return "bg_info_status#none"
		} {
			return "bg_alsoup#[::Battleground::GetBattlegroundScore]"
		}
}
proc ::Battleground::Leave { player cargs } {
	
		if { [::Battleground::inGame $player] } {
			unset ::Battleground::InGameList($player)
		}
		if { [::Battleground::inQueue $player] } {
			unset ::Battleground::WaitingQueue($player)
		}
		if { [::Battleground::inWaitingPlay $player] } {
			unset ::Battleground::WaitingList($player)
		}
		
		Say $player 0 "@bg@_#status"
	
}
proc ::Battleground::GetBGInfo { player cargs } {
		set wHorde    [::Battleground::GetNumPlayersBySide "Wait" 2]
		set wAlliance [::Battleground::GetNumPlayersBySide "Wait" 1]
		
		set pHorde    [::Battleground::GetNumPlayersBySide "Play" 2]
		set pAlliance [::Battleground::GetNumPlayersBySide "Play" 1]
		
		set qHorde    [::Battleground::GetNumPlayersBySide "Queue" 2]
		set qAlliance [::Battleground::GetNumPlayersBySide "Queue" 1]
		
		set ret "ArathiBG: Minimalnilevel: $::Battleground::MinLevel MinPlayers: [expr { $::Battleground::MinInTeam * 2}] WinResources: $::Battleground::WinPoints\n"
		append ret "In Battleground : |cff40ff40$pAlliance Alliance and $pHorde Horde|r\n"
		append ret "Ready To Play   : |cffffff90$wAlliance Alliance and $wHorde Horde|r\n"
		append ret "In Queue           : |cff7070ff$qAlliance Alliance and $qHorde Horde|r\n"
		
		set Status ""
		if { $::Battleground::GameStatus == 0 } {
			set Status "Battleground Status: Waiting For Players..."
		} elseif { $::Battleground::GameStatus == 1 } {
			set Status "Battleground Status: Process\nAlliance : $::Battleground::AlliesTeamScore\nHorde   : $::Battleground::HordeTeamScore"
		} else {
			set Status "Battleground Status: Finish\nAlliance : $::Battleground::AlliesTeamScore\nHorde   : $::Battleground::HordeTeamScore"
		}
		append ret "\n$Status"
		return $ret
	
}
proc ::Battleground::PostEval {} {
		if { [array size ::Battleground::EvalQueue] == 0 } {
			return
		}
		foreach evstr [lsort -integer [array names ::Battleground::EvalQueue]] {		
			set str $::Battleground::EvalQueue($evstr)
			array unset ::Battleground::EvalQueue $evstr
			eval $str
			break
		}
	
}
proc ::Battleground::addPlayer { player } {
	::Battleground::Join $player ""
}
proc ::Battleground::Enter { player cargs } {
		if { [::Battleground::inWaitingPlay $player]} {
			set pname [GetName $player]
			set ::Battleground::InGameList($player)  [clock seconds]
			unset ::Battleground::WaitingList($player)
			#reset score
			set ::Battleground::PlayersScore($player,capture) 0
			set ::Battleground::PlayersScore($player,defend) 0
			set ::Battleground::PlayersScore($player,kills) 0
			set ::Battleground::PlayersScore($player,deaths) 0
			set ::Battleground::PlayersScore($player,honor) 0
			set ::Battleground::PlayersScore($player,honorkills) 0
			set ::Battleground::PlayersScore($player,enterhonor) [::Battleground::GetHonorKills $pname]
			#Teleport Player to Arathi
			::Battleground::TeleportPlayerToBG $player
			
		}
		Say $player 0 "@bg@_#status"
		::Battleground::CheckGameStatus
		::Battleground::CallResourceUpdate
		::Battleground::ResourceInfo $player $cargs
		return "bg_info_status#active"
	
}
proc ::Battleground::CheckPlayersAlive {} {
		set ttime [clock seconds]
		
		set players [array names ::Battleground::InGameList]
		foreach player $players {
			set location [GetPos $player]
			if { ![info exist ::Battleground::AliveCheck(time,$player)] } {
				set ::Battleground::AliveCheck(time,$player) $ttime
				set ::Battleground::AliveCheck(pos,$player) $location
			} 
		}
		
		set players [array names ::Battleground::WaitingQueue]
		foreach player $players {
			set location [GetPos $player]
			if { ![info exist ::Battleground::AliveCheck(time,$player)] } {
				set ::Battleground::AliveCheck(time,$player) $ttime
				set ::Battleground::AliveCheck(pos,$player) $location
			} 
		}
		
		set players [array names ::Battleground::WaitingList]
		foreach player $players {
			set location [GetPos $player]
			if { ![info exist ::Battleground::AliveCheck(time,$player)] } {
				set ::Battleground::AliveCheck(time,$player) $ttime
				set ::Battleground::AliveCheck(pos,$player) $location
			} 
		}
		
		set players [array names ::AliveCheck pos,*]
		foreach player $players {
			set player [lindex [split $player ","] 1]
			set location [GetPos $player]
			set oldloc $::Battleground::AliveCheck(pos,$player)
			set oldtim $::Battleground::AliveCheck(time,$player)
			if { [expr $ttime - $oldtim] > 300 && $location == $oldloc } {
				puts  "KickFrom BG: [GetName $player]"
				::Battleground::Exit $player ""
			} elseif { $location != $oldloc } {
				set ::Battleground::AliveCheck(time,$player) $ttime
				set ::Battleground::AliveCheck(pos,$player) $location
			}
		}
		
		
		set players [array names ::Battleground::InGameList]
		foreach player $players {
			set location [split [GetPos $player] " "]
			set map [lindex $location 0]
			if { $map != "529"} {
				::Battleground::Exit $player ""
			}
		}
	
}
proc ::Battleground::AddHonor {} {
	set players [array names ::Battleground::InGameList]
	foreach player $players {
		set pname [GetName $player]
		set ::Battleground::PlayersScore($player,honorkills) [expr { [::Battleground::GetHonorKills $pname] - $::Battleground::PlayersScore($player,enterhonor) }]
		set points [expr {$::Battleground::PlayersScore($player,capture) +  ($::Battleground::PlayersScore($player,defend) * 1.5 ) + $::Battleground::PlayersScore($player,honorkills)}]
		set points [expr { ($::Battleground::HonorRate * $points) - ($::Battleground::HonorRate * $::Battleground::PlayersScore($player,deaths) / 3 ) }]
		set points [lindex [split $points "."] 0]
		if { $points > 0 } {
			::Battleground::AddPlayerHonor $player $points
		}
	}
}
proc ::Battleground::TeleportPlayerToBG { player } {
		set side [::Battleground::GetSide $player]
		array set portTo {}
		set portTo(0) "529 1346.657104 1275.490479 -11.579876"
		set portTo(1) "529 1352.564453 1308.615112 -9.539673"
		set portTo(2) "529 1321.670776 1295.590454 -10.538388"
		set portTo(3) "529 1294.064331 1305.799072 -10.762310"
		
		set portTo(10) "529 671.615417 719.786804 -13.737698"
		set portTo(11) "529 666.448914 698.743896 -14.256552"
		set portTo(12) "529 692.166016 711.196289 -15.565860"
		set portTo(13) "529 709.023682 646.810669 -11.060971"
		
		
		set rnd [expr {int(rand()*4)} ]
		
		if { $side == 2 } {
			incr rnd 10
		}
		
		eval "Teleport \$player $portTo($rnd)"
	
}
proc ::Battleground::GetInfoStatus { player cargs } {
		set ret "none"
		# Player in game - return active
		if { [::Battleground::inGame $player] } {
			set ret "active"
		} elseif  { [::Battleground::inQueue $player] } {
			set ret "queued"
		} elseif  { [::Battleground::inWaitingPlay $player] } {
			set numHorde [expr [::Battleground::GetNumPlayersBySide "Wait" 2] + [::Battleground::GetNumPlayersBySide "Play" 2]]
			set numAlliance [expr [::Battleground::GetNumPlayersBySide "Wait" 1] + [::Battleground::GetNumPlayersBySide "Play" 1]]
			
			if { $numAlliance  >= $::Battleground::MinInTeam && $numHorde  >= $::Battleground::MinInTeam } {
				set ret "confirm"
			} else {
				set ret "queued"
			}
		}
		
		set hours [clock format [clock seconds] -format "%H"]
		return "bg_info_status#$ret#0.3"
	
}
proc ::Battleground::Join { player cargs } {
		if { [GetLevel $player]<$::Battleground::MinLevel } { return "You must have minimum $::Battleground::MinLevel Level" }
		if { [::Battleground::inGame $player] } { return }
		puts "[::Custom::LogPrefix]ArathiBG: Join [GetName $player]"
		## Game not started
		if { $::Battleground::GameStatus == 0 }  {
			set half  [expr {$::Battleground::MaxInGame/2}]
			set side [::Battleground::GetSide $player]
			
			set numHorde [expr [::Battleground::GetNumPlayersBySide "Wait" 2] + [::Battleground::GetNumPlayersBySide "Play" 2]]
			set numAlliance [expr [::Battleground::GetNumPlayersBySide "Wait" 1] + [::Battleground::GetNumPlayersBySide "Play" 1]]
			
			if { ($side == 1 && $numAlliance  < $half) || ($side == 2 && $numHorde  < $half) } {
				set ::Battleground::WaitingList($player)  [clock seconds]
				if { [array size ::Battleground::WaitingList] < [expr $::Battleground::MinInTeam*2] } {
					#::Battleground::AddMessage $player "Nedostatecny pocet hracu v battlegroundu, budete upozorneni jakmile hra zacne.." "1#1#0.2"
				}
			} else {
				set ::Battleground::WaitingQueue($player)  [clock seconds]
			} 
		# Game in process
		} elseif { $::Battleground::GameStatus == 1 }  {
			set half  [expr {$::Battleground::MaxInGame/2}]
			set side [::Battleground::GetSide $player]
			
			set numHorde [expr [::Battleground::GetNumPlayersBySide "Wait" 2] + [::Battleground::GetNumPlayersBySide "Play" 2]]
			set numAlliance [expr [::Battleground::GetNumPlayersBySide "Wait" 1] + [::Battleground::GetNumPlayersBySide "Play" 1]]
			
			if { ($side == 1 && $numAlliance  < $half) || ($side == 2 && $numHorde  < $half) } {
				set ::Battleground::WaitingList($player)  [clock seconds]
			} else {
				set ::Battleground::WaitingQueue($player)  [clock seconds]
			}
		} elseif { $::Battleground::GameStatus == 1 }  {
			::Battleground::AddMessage $player "Arathi Basin will be available in [expr 300-([clock seconds] - $::Battleground::EveryTimeToLeave)] sec." "0.2#1#0.2"
			set ::Battleground::WaitingQueue($player)  [clock seconds]
		}
		
		Say $player 0 "@bg@_#status"
	
}
proc ::Battleground::RemovePlayerFromGame { player } {
		array unset ::Battleground::InGameList $player
		array unset ::Battleground::WaitingQueue $player
		array unset ::Battleground::WaitingList $player
		array unset ::Battleground::AliveCheck *,$player
		
		Say $player 0 "@bg@_#status"
		set coord [GetPos $player]
		set coord [split $coord " "]
		set map [lindex $coord 0]
		if { $map == "529" } {
			set ss [GetBindpoint $player]
			set map [lindex $ss 0]
			set x [lindex $ss 1]
			set y [lindex $ss 2]
			set z [lindex $ss 3]
			Teleport $player $map $x $y $z					
		}
	
}
proc ::Battleground::onKill { victim } {
		if { [::Battleground::inGame $victim] } {
			incr ::Battleground::PlayersScore($victim,deaths)
		}
}
proc ::Battleground::inGame { player } {
		if { ![info exists ::Battleground::InGameList($player)] } {
			return false
		}
		return true
}
proc ::Battleground::reloadData { player cargs } {
		## Kick players and start new game 
		set array [array names ::Battleground::Bases]
		foreach index $array {
			set ::Battleground::Bases($index) 0
		}
		
		array unset ::Battleground::PlayersScore *
		array unset ::Battleground::CaptureProcess *
		
		set ::Battleground::AlliesTeamScore 0
		set ::Battleground::HordeTeamScore 0
		set ::Battleground::WinnerTeam 0
		
		array unset ::Battleground::InGameList *
		array unset ::Battleground::WaitingQueue *
		array unset ::Battleground::WaitingList *
		
		set ::Battleground::GameStatus 0
	
}
proc ::Battleground::IncreaseResource {  } {
		if { $::Battleground::GameStatus == 1 } {
			set addAllied 0
			set addHorde  0
			
			set array [array names ::Battleground::Bases]
			foreach index $array {
				if { $::Battleground::Bases($index)  == 1 } {
					incr addAllied 5
				} elseif { $::Battleground::Bases($index)  == 2 } {
					incr addHorde 5
				}
			}
			
			incr ::Battleground::AlliesTeamScore $addAllied
			incr ::Battleground::HordeTeamScore $addHorde
			
			if { $::Battleground::AlliesTeamScore >= $::Battleground::CloseGameEnd  && $::Battleground::AlliesTeamScore <= [expr { $::Battleground::CloseGameEnd + 6 }] } {
				::Battleground::AddMessageAudio 2 " " "1#0.2#0.2" 4
			}
			if { $::Battleground::HordeTeamScore >= $::Battleground::CloseGameEnd  && $::Battleground::HordeTeamScore <= [expr { $::Battleground::CloseGameEnd + 6 }] } {
				::Battleground::AddMessageAudio 1 " " "1#0.2#0.2" 3
			}
			if { $::Battleground::AlliesTeamScore >= $::Battleground::WinPoints } {
				set ::Battleground::AlliesTeamScore $::Battleground::WinPoints
				::Battleground::CheckGameStatus
			}
			if { $::Battleground::HordeTeamScore >= $::Battleground::WinPoints } {
				set ::Battleground::HordeTeamScore $::Battleground::WinPoints
				::Battleground::CheckGameStatus
			}
		}
	
}
proc ::Battleground::Exit { player cargs } {
		::Battleground::RemovePlayerFromGame $player
		return "bg_info_status#none"  
	
}
proc ::Battleground::DeliverMessages {  } {
		
		if { [array size ::Battleground::MessageQueue] == 0 } {
			return
		}
		
		foreach i [array names ::Battleground::MessageQueue *,to] {
			set i [split $i ","]
			set i [lindex $i 0]
			set to 	$::Battleground::MessageQueue($i,to)
			set text 	$::Battleground::MessageQueue($i,text)
			set color 	$::Battleground::MessageQueue($i,color)
			set audio 	$::Battleground::MessageQueue($i,audio)
			
			
			if { $to > 2 } {
				# deliver to single player
				Say $to 0 "@bg@_#msgup#1#$text#$color#$audio"
			} elseif { $to == 2 || $to == 1} {
				# deliver to horde or alliance side
				set players [array names ::Battleground::InGameList]
				foreach player $players {
					if { [::Battleground::GetSide $player] == $to } {
						Say $player 0 "@bg@_#msgup#1#$text#$color#$audio"
					}
				}
			} else {
				#to all
				set players [array names ::Battleground::InGameList]
				foreach player $players {
					Say $player 0 "@bg@_#msgup#1#$text#$color#$audio"
				}
			}
			array unset ::Battleground::MessageQueue $i,*
		}
	
}
proc ::Battleground::CheckCapturing {} {
	
		# check if capturers still there
		foreach { i } {Stables Farm Mill Blacksmith Mine} {
			set aray [array names ::Battleground::CaptureProcess $i,* ]
			foreach index $aray {
				set basename 	[lindex [split $index ","] 0]
				set player 		[lindex [split $index ","] 1]
				set side 		[::Battleground::GetSide $player]
				
				set location [split $::Battleground::BasesPos($basename) " "]
				set x [lindex $location 1]
				set y [lindex $location 2]
				
				set location [split [GetPos $player] " "]
				set x1 [lindex $location 1]
				set y1 [lindex $location 2]
				
				
				set dist [expr [expr sqrt (  {pow(($x1-$x),2)} + {pow(($y1-$y),2)} ) ] ]
				
				if { $dist >= $::Battleground::BaseCaptureDist } {
					::Battleground::AddMessage $player "You leave the capture area." "1#0.2#0.2"
					array unset ::Battleground::CaptureProcess $i,$player
				}
			}
		}
		
		#Check bases
		foreach { i } {Stables Farm Mill Blacksmith Mine} {
			set array [array names ::Battleground::CaptureProcess $i,* ]
			
			set numAlliance 0
			set numHorde 0
			foreach index $array {
				set player 		[lindex [split $index ","] 1]
				set side 		[::Battleground::GetSide $player]
				if { $side == 1 } {
					incr numAlliance 
				} else {
					incr numHorde 
				}
			}
			
			if { $numAlliance == 0 || $numHorde == 0 } {
				foreach index $array {
					set basename 	[lindex [split $index ","] 0]
					set player 		[lindex [split $index ","] 1]
					set side 		[::Battleground::GetSide $player]
					incr ::Battleground::CaptureProcess($i,$player)
					
					set color "0.5#0.5#0.5"
					if { ![info exists ::Battleground::Bases($basename)] } { set ::Battleground::Bases($basename) 0 }
					
					if { $::Battleground::Bases($basename) == 0 && $side == 1} {
						set color "0.5#0.6#0.8"
					} elseif { $::Battleground::Bases($basename) == 0 && $side == 2} {
						set color "0.8#0.6#0.5"
					}
					
					
					#::Battleground::AddMessage $player "$::Battleground::CaptureProcess($i,$player) sec passed." $color
					
					set action ""
					
					if { $::Battleground::CaptureProcess($i,$player) >= $::Battleground::BaseCaptureTimes  } {
							set action "capture"
					} elseif { $::Battleground::CaptureProcess($i,$player) == $::Battleground::BaseNeutralTimes } {
						if { $::Battleground::Bases($basename) == 0 } {
							set action "capture"
						} else {
							set action "neutral"
						}
					}
					
					if { $action == "capture" } {
						set ::Battleground::Bases($basename) $side
						::Battleground::AddMessage $player "You have captured $basename." "0.7#1#0.7"
						if { $side == 1 } {
							::Battleground::AddMessage 1 "$basename under your control." "0.7#0.7#1"
							::Battleground::AddMessageAudio 2 "Alliance captured $basename." "1#0#0" 6
						} else {
							::Battleground::AddMessage 2 "$basename under your control." "0.7#0.7#1"
							::Battleground::AddMessageAudio 1 "Horde captured $basename." "1#0#0" 7
						}
						
						incr ::Battleground::PlayersScore($player,capture)
						array unset ::Battleground::CaptureProcess $i,*
						::Battleground::CallResourceUpdate
						#::Battleground::SetFlag $basename
					} elseif { $action == "neutral" } {
						set ::Battleground::Bases($basename) 0
						incr ::Battleground::PlayersScore($player,defend)
						::Battleground::AddMessage $player "$basename become neutral." "0.7#0.7#0.7"
						::Battleground::CallResourceUpdate
					}
				}
			}
			
		}
		
	
}
proc ::Battleground::CheckForDeadPlayers {} {
		set players [array names ::Battleground::InGameList]
		foreach player $players {
			if { [GetHealthPCT $player] <= 0 } {
				::Battleground::TeleportPlayerToBG $player
				Resurrect $player
				CastSpell $player $player 11631
				
			}
			
		}
	
}
proc ::Battleground::CheckQueue {} {
	
		if { $::Battleground::GameStatus == 0 } {
			set numHorde [expr [::Battleground::GetNumPlayersBySide "Wait" 2] + [::Battleground::GetNumPlayersBySide "Play" 2]]
			set numAlliance [expr [::Battleground::GetNumPlayersBySide "Wait" 1] + [::Battleground::GetNumPlayersBySide "Play" 1]]
			
			if { [expr $numHorde+$numAlliance] < $::Battleground::MaxInGame && [array size ::Battleground::WaitingQueue] > 0 } {
				set half  [expr $::Battleground::MaxInGame/2]
				set players [array names ::Battleground::WaitingQueue]
				
				set count 0
				if { $numAlliance < $half } {
					foreach plr $players {
						if { [::Battleground::GetSide $plr] == 1 } {
							set ::Battleground::WaitingList($plr) [clock seconds]
							unset ::Battleground::WaitingQueue($plr)
							incr count
							if { $count >= [expr  $half - $numAlliance] } {
								break
							}
						}
					}
				}
				
				set count 0
				if { $numHorde < $half } {
					foreach plr $players {
						if { [::Battleground::GetSide $plr] == 2 } {
							set ::Battleground::WaitingList($plr) [clock seconds]
							unset ::Battleground::WaitingQueue($plr)
							incr count
							if { $count >= [expr  $half - $numHorde] } {
								break
							}
						}
					}
				}
			}
			
			if { ($numAlliance  >= $::Battleground::MinInTeam) && ($numHorde  >= $::Battleground::MinInTeam) } {
				set players [array names ::Battleground::WaitingList]
				foreach plr $players {
					Say $plr 0 "@bg@_#status"
				}
				
				if { [array size ::Battleground::InGameList] == 0} {
					set players [array names ::Battleground::WaitingList]
					foreach plr $players {
						set ::Battleground::WaitingList($plr)  [clock seconds]
					}
				}
			}
			return
		} elseif { [array size ::Battleground::InGameList] < $::Battleground::MaxInGame && $::Battleground::GameStatus == 1 &&  [array size ::Battleground::WaitingList] > 0 } {
			set players [array names ::Battleground::WaitingList]
			foreach plr $players {
				Say $plr 0 "@bg@_#status"
			}
			return
		}
	
	
		set numHorde [expr [::Battleground::GetNumPlayersBySide "Wait" 2] + [::Battleground::GetNumPlayersBySide "Play" 2]]
		set numAlliance [expr [::Battleground::GetNumPlayersBySide "Wait" 1] + [::Battleground::GetNumPlayersBySide "Play" 1]]
	
		if { [expr  $numHorde + $numAlliance] < $::Battleground::MaxInGame && $::Battleground::GameStatus != 3 } {
			set half  [expr $::Battleground::MaxInGame/2]
			set players [array names ::Battleground::WaitingQueue]
			foreach player $players {
				if { [::Battleground::GetSide $player] == 1 } {
					if { $numAlliance < $half } {
						::Battleground::Join  $player ""
						unset ::Battleground::WaitingQueue($player)
						puts "Add new alliance player from queue [GetName $player]"
					}
				} else {
					if { $numHorde < $half } {
						::Battleground::Join  $player ""
						unset ::Battleground::WaitingQueue($player)
						puts "Add new horde player from queue [GetName $player]"
					}
				}
			}
		}
	
}
proc ::Battleground::CaptureResource { player resname base } {
		if { ![info exist ::Battleground::CaptureProcess($base,$player)] } {
			set side [::Battleground::GetSide $player]
			if { ![info exists ::Battleground::Bases($base)] } { set ::Battleground::Bases($base) 0 }
			set value $::Battleground::Bases($base)
			if { $side == 1 && $value != 1 } {
				set ::Battleground::CaptureProcess($base,$player) 0
				::Battleground::AddMessage $player "Start capturing $resname." "0.7#0.7#0.7"
				::Battleground::AddMessage 2 "$resname under attack" "1#0#0"
			} elseif { $side == 2 && $value != 2 } {
				set ::Battleground::CaptureProcess($base,$player) 0
				::Battleground::AddMessage $player "Start capturing $resname." "0.7#0.7#0.7"
				::Battleground::AddMessage 1 "$resname under attack" "1#0#0"
			}
			::Battleground::CallResourceUpdate
		}
	
}
proc ::Battleground::CallOpenFinalStat {  } {
		set players [array names ::Battleground::InGameList]
		foreach player $players {
			Say $player 0 "@bg@_#openstat"
		}
	
}
proc ::Battleground::CheckGameStatus {  } {
		switch $::Battleground::GameStatus {
			0 { 
				#We wait for start , need check for start game
				set numHorde 0
				set numAlliance 0
				set players [array names ::Battleground::InGameList]
				foreach player $players {
					if { [::Battleground::GetSide $player] == 1 } {
						incr numAlliance
					}
					if { [::Battleground::GetSide $player] == 2 } {
						incr numHorde
					}
				}
				
				if { [array size ::Battleground::InGameList] > 0 &&  [array size ::Battleground::WaitingList] > 0 } {
					set waitplayers [array names ::Battleground::WaitingList]
					foreach player $waitplayers {
						set wtime [expr {[clock seconds] - $::Battleground::WaitingList($player)}]
						puts "[::Custom::LogPrefix]ArathiBG: [GetName $player] Wait: $wtime"
						if { $wtime > $::Battleground::KickFromWaitTime } {
							::Battleground::Leave $player ""
						}
					}
				}
				
				if { $numHorde < $::Battleground::MinInTeam || $numAlliance < $::Battleground::MinInTeam } {
					#cant start game because not enough players
					set msg "To Start BG: "
					if { $numAlliance < $::Battleground::MinInTeam } {
						append msg " [expr {$::Battleground::MinInTeam - $numAlliance}] Alliance"
					}
					if { $numHorde < $::Battleground::MinInTeam } {
						append msg " [expr {$::Battleground::MinInTeam - $numHorde}] Horde "
					}
					::Battleground::AddMessage 0 $msg "0.7#0.7#0.7"
				} else {
					puts "[::Custom::LogPrefix]ArathiBG: Start Battleground"
					::Battleground::AddMessageAudio 0 "Start Battleground" "0.5#0.9#1.0" 5
					#teleport players to start location
					set players [array names ::Battleground::InGameList]
					foreach player $players {
						::Battleground::TeleportPlayerToBG $player
					}
					set ::Battleground::GameStatus 1
					set close_game_end [expr { $::Battleground::WinPoints - ($::Battleground::WinPoints * 0.1 ) } ]
					set close_game_end [lindex [split $close_game_end "."] 0]
					set ::Battleground::CloseGameEnd $close_game_end
					::Battleground::CallResourceUpdate
				}
			}
			
			1 { 
				#We in game , need check for finish game
				set winner_team 0
				if { $::Battleground::HordeTeamScore >= $::Battleground::WinPoints } {
					set ::Battleground::HordeTeamScore $::Battleground::WinPoints
					set ::Battleground::GameStatus 3
					set ::Battleground::WinnerTeam 2
					::Battleground::AddMessageAudio 2 "Horde Win!!" "0.5#0.9#1.0" 2
					::Battleground::AddMessageAudio 1 "Alliance Loose" "1.0#0.0#0.0" 2
					::Battleground::DeliverMessages
					::Battleground::CallResourceUpdate
					::Battleground::CallOpenFinalStat
					set winner_team 2
				} {
					if { $::Battleground::AlliesTeamScore >= $::Battleground::WinPoints } {
						set ::Battleground::AlliesTeamScore $::Battleground::WinPoints
						set ::Battleground::GameStatus 3
						set ::Battleground::WinnerTeam 1
						::Battleground::AddMessageAudio 2 "Horde Loose" "1.0#0.0#0.0" 1
						::Battleground::AddMessageAudio 1 "Alliance Win!!" "0.5#0.9#1.0" 1
						::Battleground::DeliverMessages
						::Battleground::CallResourceUpdate
						::Battleground::CallOpenFinalStat
						set winner_team 1
					}
				}
				
				if { $winner_team != 0 } {
					set players [array names ::Battleground::InGameList]
					foreach player $players {
						if { [::Battleground::GetSide $player] == $winner_team } {
							for {set a 0} {$a < $::Battleground::ItemsForWinner } {incr a} { AddItem $player $::Battleground::ItemIDForWinner }
						} else {
							for {set a 0} {$a < $::Battleground::ItemsForLooser } {incr a} { AddItem $player $::Battleground::ItemIDForLooser }
						}
					}
					puts "[::Custom::LogPrefix]ArathiBG: Finish Battleground"
					
					# write honor info
					set players [array names ::Battleground::InGameList]
					foreach player $players {
						set pname [GetName $player]
						set ::Battleground::PlayersScore($player,honorkills) [expr { [::Battleground::GetHonorKills $pname] - $::Battleground::PlayersScore($player,enterhonor) }]
						set points [expr {$::Battleground::PlayersScore($player,capture) +  ($::Battleground::PlayersScore($player,defend) * 1.5 ) + $::Battleground::PlayersScore($player,honorkills)}]
						set points [expr { ($::Battleground::HonorRate * $points) - ($::Battleground::HonorRate * $::Battleground::PlayersScore($player,deaths) / 3 ) }]
						set points [lindex [split $points "."] 0]
						if { $points > 0 } {
							::Battleground::AddPlayerHonor $player $points
						}
					}
				}
			}
			
			3 { 
				if { $::Battleground::WinnerTeam == 1 } {
					::Battleground::AddMessage 1 "You have $::Battleground::TimeToLeaveBG min to get your prizes and leave Arati Basin!" "0.5#1#0.5"
					::Battleground::AddMessage 2 "You have $::Battleground::TimeToLeaveBG min to leave Arati Basin!" "1.0#0.5#0.5"
				} elseif { $::Battleground::WinnerTeam == 2 } {
					::Battleground::AddMessage 2 "You have $::Battleground::TimeToLeaveBG min to get your prizes and leave Arati Basin!" "0.5#1#0.5"
					::Battleground::AddMessage 1 "You have $::Battleground::TimeToLeaveBG min to leave Arati Basin!" "1.0#0.5#0.5"
				}
				set ::Battleground::FinishMessageSending 1
				set ::Battleground::EveryTimeToLeave [clock seconds]
				set time_leave [expr { $::Battleground::TimeToLeaveBG * 60 }]
				set ::Battleground::EveryTimeToLeave [clock seconds]
				
				## Kick players and start new game 
				set aray [array names ::Battleground::Bases]
				foreach index $aray {
					set ::Battleground::Bases($index) 0
				}
				
				array unset ::Battleground::PlayersScore *
				array unset ::Battleground::CaptureProcess *
				array unset ::Battleground::AliveCheck *
				array unset ::Battleground::BattlegroundBuffs *
				
				set ::Battleground::AlliesTeamScore 0
				set ::Battleground::HordeTeamScore 0
				set ::Battleground::WinnerTeam 0
				
				set players [array names ::Battleground::InGameList]
				foreach player $players {
					::Battleground::RemovePlayerFromGame $player
				}
				
				set ::Battleground::GameStatus 0
				set ::Battleground::FinishMessageSending 0
				::Battleground::reloadData " " " "
				
			}
			
		}
		
	
}
proc ::Battleground::inQueue { player } {
		if { [info exists ::Battleground::WaitingQueue($player)]  } {
			return true
		}
		return false
	
}
proc ::Battleground::UpdateGameStats { player cargs } {
		set cargs   "shit$cargs"
		set cargs 	[split $cargs "\#"]
		set tabnum	[lindex $cargs 1]
		unset cargs
		set ret "bg_updatestat"
			
		if { $::Battleground::GameStatus == 3 } {
			set hrs [clock format [clock seconds] -format "%H"]
			set min [clock format [clock seconds] -format "%M"]
			set sec [clock format [clock seconds] -format "%S"]
			
			set ret "bg_end#$::Battleground::WinnerTeam#$hrs#$min#$sec#$hrs"
		}
		
		set players [array names ::Battleground::InGameList]
		foreach player $players {
			set side [expr {[::Battleground::GetSide $player] - 1}]
			if { $tabnum == 0 || $tabnum == [expr {$side + 1}] } {
				set racename    [::Battleground::GetRaceName $player]
				set classname   [::Battleground::GetClassName $player]
				set name 	    [GetName $player]
				
				set ::Battleground::PlayersScore($player,honorkills) [expr { [::Battleground::GetHonorKills $name] - $::Battleground::PlayersScore($player,enterhonor) }]
				if { $::Battleground::UsePewexHonor==1 && $::Battleground::GameStatus==3 } { set ::Battleground::PlayersScore($player,honorkills) [expr { $::Battleground::PlayersScore($player,honorkills) - 1 }] }
				if { $side == "0" } { set side "1" } { set side "0" }
				set points [expr {$::Battleground::PlayersScore($player,capture) +  ($::Battleground::PlayersScore($player,defend) * 1.5 ) + $::Battleground::PlayersScore($player,honorkills)}]
				set points [expr { ($::Battleground::HonorRate * $points) - ($::Battleground::HonorRate * $::Battleground::PlayersScore($player,deaths) / 3 ) }]
				set points [lindex [split $points "."] 0]
				if { $points < 0 } { set points 0 }
				
				append ret "\n#$name#$::Battleground::PlayersScore($player,honorkills)#$::Battleground::PlayersScore($player,honorkills)#$::Battleground::PlayersScore($player,deaths)#$points#$side#[::Battleground::GetHonorRank $name]#$racename#$classname#$::Battleground::PlayersScore($player,capture)#$::Battleground::PlayersScore($player,defend)#"
			}
		}
		return $ret
	
}
proc ::Battleground::ToGamePlayers {} {
	set players [array names ::Battleground::WaitingList]
	foreach player $players {
		set ::Battleground::InGameList($player) [clock seconds]
		unset ::Battleground::WaitingList($player)
		break
	}
}
proc ::Battleground::AddMessage { to text color } {
		::Battleground::AddMessageAudio $to $text $color 0
	
}
proc ::Battleground::GetBattlegroundScore {} {
		set Allied 0
		set Horde  0
		
		set aray [array names ::Battleground::Bases]
		foreach basename $aray {
			if { $::Battleground::Bases($basename)  == 1 } {
				incr Allied
			} elseif { $::Battleground::Bases($basename)  == 2 } {
				incr Horde
			}
		}
		return "$Horde#$::Battleground::HordeTeamScore#$Allied#$::Battleground::AlliesTeamScore#$::Battleground::WinPoints#"
}
proc ::Battleground::GetBaseTeam { base } {
	if { $::Battleground::Bases($base) == 1 } { return 1 }
	if { $::Battleground::Bases($base) == 2 } { return 2 }	
	return 0
}
proc ::Battleground::CallResourceUpdate {} {
		set players [array names ::InGameList]
		foreach player $players {
			Say $player 0 "@bg@_#update#1"
		}
	
}
proc ::Battleground::Whiled {} {
		set t [clock seconds]
		###########################################################################################
		set dif [expr {$t - $::Battleground::SaveWhiled(1)}] 
		if { $dif < $::Battleground::WhiledLevel(1) } { } {
		set ::Battleground::SaveWhiled(1) $t
		set times [expr { $dif/$::Battleground::WhiledLevel(1) }]
		set times [lindex [split $times "."] 0]
		## Whiled Level 1 #########################################################################
		if { $::Battleground::GameStatus == 1 } {
			for {set i 0} {$i<$times} {incr i} {
				::Battleground::CheckCapturing
			}
			::Battleground::IncreaseResource
		}
		::Battleground::DeliverMessages
		::Battleground::PostEval
																	}
		###########################################################################################
		set dif [expr {$t - $::Battleground::SaveWhiled(2)}] 
		if { $dif < $::Battleground::WhiledLevel(2) } { } {
		set ::Battleground::SaveWhiled(2) $t
		## Whiled Level 2 #########################################################################
		::Battleground::CheckQueue
																	}
		###########################################################################################
		set dif [expr {$t - $::Battleground::SaveWhiled(3)}] 
		if { $dif < $::Battleground::WhiledLevel(3) } { } {
		set ::Battleground::SaveWhiled(3) $t
		## Whiled Level 3 #########################################################################
		::Battleground::CheckPlayersAlive
																	}
		###########################################################################################
		set dif [expr {$t - $::Battleground::SaveWhiled(4)}] 
		if { $dif < $::Battleground::WhiledLevel(4) } { } {
		set ::Battleground::SaveWhiled(4) $t
		## Whiled Level 4 #########################################################################
		::Battleground::CheckGameStatus
																	}
}
proc ::Battleground::AreaTrigger { player trigger } {
	set pside  [::Custom::GetPlayerSide $player]
	set ingame [::Battleground::inGame $player]
	if { $trigger == 3949 } { 
		if { $pside == 1 } { Teleport $player 0 -817 -3509 73 } { Say $player 0 "I cant..." }
	} {
		if { $trigger == 3954 } { 
			if { $pside == 1 && $ingame == 1 } { Teleport $player 529 633 701 -12 } { Say $player 0 "I cant..." }
		} {
			if { $trigger == 3948 } { 
				if { $pside == 0 } { Teleport $player 0 -1198 -2533 22 } { Say $player 0 "I cant..." }
			} {
				if { $trigger == 3953 } {
					if { $pside == 0 && $ingame == 1 } { Teleport $player 529 1384 1300 -8 } { Say $player 0 "I cant..." }
				}
			}
		}
	}
	if { $ingame == 0 || $::Battleground::GameStatus != 1 || [GetHealthPCT $player] <= 0 } { } {
	set tpos [GetPos $player]
	if { $trigger == 4025 } { set ::Battleground::BasesPos(Blacksmith) $tpos; ::Battleground::CaptureResource $player "Blacksmith" "Blacksmith" } {	
	if { $trigger == 4023 } { set ::Battleground::BasesPos(Stables)    $tpos; ::Battleground::CaptureResource $player "Stables" "Stables" } {	
	if { $trigger == 4026 } { set ::Battleground::BasesPos(Farm)       $tpos; ::Battleground::CaptureResource $player "Farm" "Farm" } {
	if { $trigger == 4029 } { set ::Battleground::BasesPos(Mill)       $tpos; ::Battleground::CaptureResource $player "Lumber Mill" "Mill" } {
	if { $trigger == 4022 } { set ::Battleground::BasesPos(Mine)       $tpos; ::Battleground::CaptureResource $player "Gold Mine" "Mine" } } } } }
	}
}
namespace eval BattlegroundGate {
}
proc ::BattlegroundGate::AreaTrigger { player trigger } {
}
namespace eval BattlegroundBaseGuard {
}
proc ::BattlegroundBaseGuard::QuestStatus { object player } {
	if { $::Battleground::GameStatus != 1 } {
		Loot $player $object 33000 5
		return 0
	}
	set entry    [GetEntry $object]
	if { [info exists ::Battleground::AlliesBaseGuard($entry)] } {
		if { [::Battleground::GetBaseTeam $::Battleground::AlliesBaseGuard($entry)]==1 } {
			CastSpell $object $object 23335
			if { [::Battleground::GetSide $player]==1 } { return 0 } { 
				SetFaction $object 35
				if { $::Battleground::GuardAutoAttack==1 } { CastSpell $object $player 22690; return 0 } { return 0 }
			}
		} { Loot $player $object 33000 5; return 0 }
	} {
		if { [::Battleground::GetBaseTeam $::Battleground::HordeBaseGuard($entry)]==2 } {
			CastSpell $object $object 23333
			if { [::Battleground::GetSide $player]==2 } { return 0 } { 
				SetFaction $object 93
				if { $::Battleground::GuardAutoAttack==1 } { CastSpell $object $player 22690; return 0 } { return 0 }
			}
		} { Loot $player $object 33000 5; return 0 }
	}
	Loot $player $object 33000 5
	return 0
	
}
::Custom::HookProc "::WoWEmu::OnPlayerDeath" { 
	::Battleground::onKill $player
}
::Custom::HookProc "::WoWEmu::Commands::retcl" {
	::Battleground::AddHonor 
}
::Custom::AddCommand {
	"bg_getinfo_inst" ::Battleground::GetInfoInstance 0
	"bg_getinfo_status" ::Battleground::GetInfoStatus 0
	"bg_join" ::Battleground::Join 0
	"bg_leave" ::Battleground::Leave 0
	"bg_enter" ::Battleground::Enter 0
	"bg_updatestat" ::Battleground::UpdateGameStats 0
	"bg_alsoup" ::Battleground::ResourceInfo 0
	"bg_exit" ::Battleground::Exit 0
	"bg_info" ::Battleground::GetBGInfo 0
	"bg_load" ::Battleground::reloadData 5
}
#
# ARATHI BUFF
#
namespace eval ArathiBuff { 
proc QuestChooseReward { obj player questid choose } { 
} 
proc QueryQuest { obj player questid } { 
set sEntry [GetEntry $obj] 
    
    
   set ctime [clock seconds] 
   if { [info exists ::m_pBuffs($player,$sEntry)] } { 
      set lastuse $::m_pBuffs($player,$sEntry) 
      if { [expr $ctime - $lastuse] < 120 } { 
         Battleground::AddMessage $player "You can`t use it now." "0.8#0.5#1" 
         return 
      } 
   } 
    
   set ::m_pBuffs($player,$sEntry) $ctime 
    
   puts "OK [GetEntry $obj]" 
   switch $sEntry { 
      "62003" { CastSpell $player $player 23978 } 
      "62001" { CastSpell $player $player 24379 } 
      "62002" { CastSpell $player $player 24378 } 
   } 
} 
proc QuestAccept { obj player questid } { 
  
} 
proc OnGossip { obj player gossipid } { 
   
} 
} 
puts "Arathi basin by mLa and Boss44 L&L"
