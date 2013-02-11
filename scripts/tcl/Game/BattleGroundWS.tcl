# StartTCL: n
#
# Warsong Gulch CTF Battleground Script
#
# This program is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA. You can also consult
# the terms of the license at:
#
#		<http://www.gnu.org/copyleft/lesser.html>
#
# Description: Capture The Flag game on Warsong Gulch Battleground.
#
namespace eval ::Warsong {
	# defaults (if you have scripts.conf, use it to change values)
	variable CAPTURE_LIMIT 3
	variable MIN_PLAYERS 2
	variable MAX_PLAYERS 10
	variable HONOR_RATE 1.0
	variable REPUTATION_RATE 1.0
	variable QUEUE_LEVELS "10 40 60"
	variable POWERUPS_SPAWNTIME 60
	variable ALLOW_MID_GAME_ENTER 1
	variable ALLOW_MID_GAME_EXIT 0
	variable ENABLE_JOIN_COMMAND 1
	variable REMEMBER_RETURN_POS 1
	variable ENEMY_ON_MAP 0
	variable RESURRECTION_DELAY 30
	variable GRAVEYARD_TELEPORT 0
	variable NO_DEATH 0
	variable SPEED_LIMIT 9.0
	variable RED_DOTS_ON_MINIMAP 0
	variable PICK_UP_FLAG_ON_AREA 0
	variable DEBUG 0
	# todo:
	#FLAGS_SPAWNTIME 60		;# spawn time for flags after a capture, 0 = no spawn time
	# obsolete
	#variable GIVE_ON_SELECT 1
	#variable BALANCE_LIMIT 10
	variable USE_CONF 1
	variable SELF_INTEGRATION 1
	variable VERSION 1.02
	if { $USE_CONF } { ::Custom::LoadConf }
	variable FlagCarriers {0 0}
	variable Scores {0 0}
	variable Spectators ""
	variable GotReward ""
	variable SpiritGuides
	variable Open 0
	variable Start 0
	variable GameStartTime 0
	variable GameEndTime 0
	variable GameDuration 0
	# format: Team(<side>) (0 = alliance, 1 = horde)
	variable Team
	set Team(0) ""
	set Team(1) ""
	# format: Queue(<num>,<side>)
	variable Queue
	# replaced by InitQueues
	# Queue1 (for lvl 10-39)
# 	set Queue(1,0) ""
# 	set Queue(1,1) ""
# 	# Queue2 (for lvl 40-60+)
# 	set Queue(2,0) ""
# 	set Queue(2,1) ""
# 	# level requirement for each queue
# 	set Queue(1,level) 10
# 	set Queue(2,level) 40
# 	variable QueueCount [llength [array names Queue "*,level"]]
	proc InitQueues {} {
		variable QUEUE_LEVELS
		variable Queue
		array unset Queue
		variable QueueCount 0
		foreach level $QUEUE_LEVELS {
			incr QueueCount
			foreach side { 0 1 } { set Queue($QueueCount,$side) {}	}
			set Queue($QueueCount,level) $level
		}
	}
	proc IsInQueue { player } {
		set queue ""
		set side [::Custom::GetPlayerSide $player]
		for { set num 1 } { $num <= $::Warsong::QueueCount } { incr num } {
			lappend queue $::Warsong::Queue($num,$side)
		}
		expr {[lsearch [join $queue] $player] >= 0}
	}
	proc CleanQueues { {args ""} } {
		set removed 0
		for { set num 1 } { $num <= $::Warsong::QueueCount } { incr num } {
			foreach side {0 1} {
				set new_queue ""
				foreach player $::Warsong::Queue($num,$side) {
					if { [lsearch $args $player] >= 0 || $args == "*" } {
						incr removed
					} elseif { [IsOnline $player] && ![IsInTeam $player] } {
						lappend new_queue $player
					}
				}
				set ::Warsong::Queue($num,$side) $new_queue
			}
		}
		return $removed
	}
	proc RemoveFromQueue { player } {
		CleanQueues $player
	}
	proc AddToQueue { player } {
		if { ![Honor::CheckAddOnVersion $player] } { return 0 }
		CleanQueues
		set side [::Custom::GetPlayerSide $player]
		if { ![IsInQueue $player] && ![IsInTeam $player] } {
			set level [GetLevel $player]
			for { set num $::Warsong::QueueCount } { $num > 0 && $::Warsong::Queue($num,level) > $level } { incr num -1 } {}
			if { $num } { lappend ::Warsong::Queue($num,$side) $player
			} else { return 0 }
		} else { return 0 }
		TryStartGame
		RunChecks
		return 1
	}
	proc CleanTeams {} {
		foreach side {0 1} {
			foreach player $::Warsong::Team($side) {
				if { ![IsOnline $player] } {
					RemoveFromTeam $player
				}
			}
		}
	}
	proc IsOnline { player } {
		variable LastOnlineCheck
		if { ![info exists LastOnlineCheck($player)] } {
			set LastOnlineCheck($player) 1
		}
		if { [::Custom::IsOnline $player] } {
			set LastOnlineCheck($player) 1
			return 1
		} elseif { $LastOnlineCheck($player) } {
			set LastOnlineCheck($player) 0
			return 1
		}
		return 0
	}
	proc TryStartGame {} {
		CleanTeams
		variable Queue
		variable Team
		variable MIN_PLAYERS
		variable MAX_PLAYERS
		set just_started 0
		if { [IsFree] } {
			EndGame
			# find the longest queue
			set num 1
			set max_length 0
			for { set n 1 } { $n <= $::Warsong::QueueCount } { incr n } {
				set length [llength [concat $::Warsong::Queue($n,0) $::Warsong::Queue($n,1)]]
				if { $length > $max_length } {
					set num $n
					set max_length $length
				}
			}
			# try to start a game with the same number of players in each team
			set q0 $::Warsong::Queue($num,0)
			set q1 $::Warsong::Queue($num,1)
			set l0 [llength $q0]
			set l1 [llength $q1]
			if { $l0 >= $MIN_PLAYERS && $l1 >= $MIN_PLAYERS } {
				ClearScores
				if { $l0 < $l1 } { set limit $l0 } else { set limit $l1 }
				if { $limit > $MAX_PLAYERS } { set limit $MAX_PLAYERS }
				foreach side {0 1} {
					set queue [set q$side]
					for { set i 0 } { $i < $limit } { incr i } {
						set player [lindex $queue $i]
						AddToTeam $player 0 1
					}
					#set ::Warsong::Queue$num$side [lrange $queue $i end]
					set just_started 1
				}
			}
		}
		# add more players from the queues if possible, taking balance into account
		if { $just_started || (![IsFree] && ![GameIsOver] && $::Warsong::ALLOW_MID_GAME_ENTER) } {
			# find which queue corresponds to the current game
			set players [concat $Team(0) $Team(1)]
			set level [GetLevel [lindex $players 0]]
			for { set num $::Warsong::QueueCount } { $num > 1 && $Queue($num,level) > $level } { incr num -1 } {}
			set added_horde 1; set added_alliance 1
			while { $added_horde || $added_alliance } {
				set added_horde 0; set added_alliance 0
				while { [GetBalance] >= 0 && [llength $Queue($num,1)] && [AddToTeam [lindex $Queue($num,1) 0]] } {
					incr added_horde
				}
				while { [GetBalance] <= 0 && [llength $Queue($num,0)] && [AddToTeam [lindex $Queue($num,0) 0]] } {
					incr added_alliance
				}
			}
		}
		variable Scores
		if {
			![GameIsRunning] && [lindex $Scores 0] == 0 && [lindex $Scores 1] == 0 &&
			[llength $Team(0)] >= $MIN_PLAYERS && [llength $Team(1)] >= $MIN_PLAYERS
		} then {
			StartGame
		}
	}
	proc IsFree {} { expr {![llength [concat $::Warsong::Team(0) $::Warsong::Team(1)]]} }
	proc ChatMessage { player msg {force 0} } { if { $::Honor::ENABLE_SAYINGS || $force } { Say $player 0 $msg } }
	# side: 0=alliance, 1=horde
	# sound: 0=flag_taken, 1=flag_returned, 2=flag_captured, 3=victory, 4=warning, 5=enter_queue, 6=through_queue
	proc Notify { player msg {side ""} {sound ""} {show_scores 0} } {
		variable Notify
		variable POICache
		if { $player } {
			set Notify($player) [list $msg $side $sound $show_scores]
			set POICache($player) ""
		} else {
			foreach player [concat $::Warsong::Team(0) $::Warsong::Team(1)] {
				set Notify($player) [list $msg $side $sound $show_scores]
				set POICache($player) ""
			}
		}
	}
	proc NotifyHonor { player msg } {
		variable NotifyHonor
		set NotifyHonor($player) $msg
	}
	proc GetNotification { player } {
		variable Notify
		variable NotifyHonor
		set msg ""
		set side ""
		set sound ""
		set show_scores 0
		if { [info exists Notify($player)] } {
			append msg [lindex $Notify($player) 0]
			set side [lindex $Notify($player) 1]
			set sound [lindex $Notify($player) 2]
			set show_scores [lindex $Notify($player) 3]
			unset Notify($player)
		}
		if { [info exists NotifyHonor($player)] } {
			append msg " " $NotifyHonor($player)
			unset NotifyHonor($player)
		}
		if { $show_scores } { append msg " " [GetScoresString] }
		return [list $msg $side $sound]
	}
	proc OnPlayerDeath { player {killer 0} } {
		if { ![IsInBattleground $player] } { return }
		set side [::Custom::GetPlayerSide $player]
		if { [DropFlag $player] } {
			set opposite_side_name [GetSideName $player 1]
			ChatMessage $player "[::Custom::DyingScream] [::Texts::Get flag_returned $opposite_side_name]"
			Notify 0 [::Texts::Get "player_drop_flag" [GetName $player] $opposite_side_name] $side 1
			Notify $player [::Texts::Get "drop_flag" $opposite_side_name] $side 1
			RunChecks
		}
		if { ($::Warsong::GRAVEYARD_TELEPORT & 1) || $::Warsong::NO_DEATH } {
			GoToGraveyard $player
			Resurrect $player
		}
	}
	proc OnPlayerResurrect { player } {
		if { ![IsInBattleground $player] } { return }
		DropFlag $player
		if { $::Warsong::GRAVEYARD_TELEPORT & 2 } {
			GoToGraveyard $player
		}
	}
	proc GoToGraveyard { player {opposite 0} } { Custom::TeleportPos $player [GetGraveyardPos $player $opposite] }
	proc GoToBase { player {opposite 0} } { Custom::TeleportPos $player [GetBasePos $player $opposite] }
	proc GoToEntrance { player {opposite 0} } { Custom::TeleportPos $player [GetEntrancePos $player $opposite] }
	proc GetGraveyardPos { player {opposite 0} } {
		if { [::Custom::GetPlayerSide $player] == $opposite } {
			set pos "489 1425 1555 343.5"
		} else { set pos "489 1027 1387 341.5" }
		RandPos $pos 5
	}
	proc GetBasePos { player {opposite 0} } {
		if { [::Custom::GetPlayerSide $player] == $opposite } {
			set pos "489 1523 1482 352.1"
		} else {
			set pos "489 933 1434 345.6"
		}
		RandPos $pos
	}
	proc GetEntrancePos { player {opposite 0} } {
		if { [::Custom::GetPlayerSide $player] == $opposite } {
			set pos "1 1435 -1856.5 134"
		} else {
			set pos "1 1034 -2096.5 124"
		}
	}
	proc RandPos { pos {rand 10} } {
		set map [lindex $pos 0]
		set x [expr {[lindex $pos 1]+rand()*2*$rand-$rand}]
		set y [expr {[lindex $pos 2]+rand()*2*$rand-$rand}]
		set z [lindex $pos 3]
		return "$map $x $y $z"
	}
	# not sure what makes game objects use QueryQuest or OnGossip
	proc QueryQuest { obj player qid } {
		OnGossip $obj $player $qid
	}
	# flags
	proc OnGossip { obj player qid } {
		variable PlayerWarns
		set time [clock seconds]
		if { ![info exists PlayerWarns($player)] } { set PlayerWarns($player) 0 }
		if { $time - $PlayerWarns($player) < 5 } { return }
		set PlayerWarns($player) $time
		variable Team
		if { ![IsInTeam $player] } {
			if { ![AddToTeam $player]} {
				ChatMessage $player [::Texts::Get "say_no_team"]
				Notify $player [::Texts::Get "no_team"]
				UpdatePOI
			}
			return
		}
		if { ![GameIsRunning] } {
			if { [GameIsOver] } { set msg [::Texts::Get "game_over"] } else { set msg [::Texts::Get "game_not_started"] }
			append msg " " [GetScoresString]
			ChatMessage $player $msg
			Notify $player $msg
			UpdatePOI
			return
		}
		set side [::Custom::GetPlayerSide $player]
		variable FlagCarriers
		set ourflagcarrier [lindex $FlagCarriers $side]
		set enemyflagcarrier [lindex $FlagCarriers [expr {!$side}]]
		set player_name [::GetName $player]
		if { $qid == [GetCarrySpell $player] } {
			# ally player
			if { [IsCarryingFlag $player] } {
				if { [CanCapture $player] } {
					# capture the enemy flag
					if { [DropFlag $player] } {
						IncrScore $player
						set msg "[::Texts::Get say_flag_captured [GetSideName $player 1]]"
						set victory 0
						if { [GameIsOver] } {
							if { ![GetWinnerSide] } {
								set msg "[::Texts::Get victory_alliance]"
							} else {
								set msg "[::Texts::Get victory_horde]"
							}
							set victory 1
							EndGame
						}
						HonorGain $player $victory
						ChatMessage $player "$msg [GetScoresString]"
						if { $victory } {
							Notify 0 $msg $side 3 1
						} else {
							Notify 0 "[::Texts::Get player_flag_captured $player_name [GetSideName $player 1]]" $side 2 1
							Notify $player "[::Texts::Get flag_captured [GetSideName $player 1]]" $side 2 1
						}
					}
				} else {
					ChatMessage $player [::Texts::Get "say_cant_score" [GetName $ourflagcarrier] [GetSideName $player]]
					Notify $player [::Texts::Get "cant_score" [GetName $ourflagcarrier] [GetSideName $player]]
				}
			} elseif { $ourflagcarrier } {
				# our flag has been picked up by the enemy
				ChatMessage $player [::Texts::Get "flag_taken" [GetName $ourflagcarrier] [GetSideName $player]]
				Notify $player [::Texts::Get "flag_taken" [GetName $ourflagcarrier] [GetSideName $player]]
			} else {
				ChatMessage $player "[::Texts::Get flag_at_base [GetSideName $player]] [GetScoresString]"
				Notify $player "[::Texts::Get flag_at_base [GetSideName $player]]" "" "" 1
			}
		} else {
			# enemy player
			if { $enemyflagcarrier == 0 } {
				# take the enemy flag
				if { [CarryFlag $player] } {
					ChatMessage $player [::Texts::Get "say_flag_picked_up" [GetSideName $player 1]]
					Notify 0 [::Texts::Get "player_flag_picked_up" $player_name [GetSideName $player 1]] $side 0
					Notify $player [::Texts::Get "flag_picked_up" [GetSideName $player 1]] $side 0
				}
			} elseif { $player != $enemyflagcarrier } {
				ChatMessage $player [::Texts::Get "flag_already_taken" [GetName $enemyflagcarrier] [GetSideName $player 1]]
				Notify $player [::Texts::Get "flag_already_taken" [GetName $enemyflagcarrier] [GetSideName $player 1]]
			}
		}
		RunChecks
	}
	if { [::Custom::GetScriptVersion "Honor"] >= 4.03 } {
		proc HonorGain { player {victory 0} } {
			if { [::Custom::GetPlayerSide $player] == 0 } {
				set team $::Warsong::Team(0)
				set basepoints [expr {(60-[GetBalance]/2)*[Honor::GetBalanceFactor $player]}]
			} else {
				set team $::Warsong::Team(1)
				set basepoints [expr {(60+[GetBalance]/2)*[Honor::GetBalanceFactor $player]}]
			}
			if { $basepoints < 2 } { set basepoints 2 }
			foreach p $team {
				if { $p == $player } {
					set points [expr {round($::Warsong::HONOR_RATE*$basepoints*($victory+1.))}]
					if { $points > $::Honor::MAX_GAIN } { set points $::Honor::MAX_GAIN }
					Honor::Notify $p [::Texts::Get "honor_gain" $points]
					Honor::ChangeRating $p $points 1 "captured the [GetSideName $p 1] flag"
					NotifyHonor $p [Honor::GetNotification $p]
				} else {
					set points [expr {round($::Warsong::HONOR_RATE*$basepoints/2.*($victory+1.))}]
					if { $points > $::Honor::MAX_GAIN } { set points $::Honor::MAX_GAIN }
					Honor::Notify $p [::Texts::Get "honor_gain" $points]
					Honor::ChangeRating $p $points 1 "[GetName $player] captured the [GetSideName $p 1] flag"
					NotifyHonor $p [Honor::GetNotification $p]
				}
			}
		}
	} else {
		proc HonorGain { player {victory 0} } {}
		namespace eval Honor { set ENABLE_SAYINGS 0 }
	}
	proc UpdatePOI { } {
		variable POICache
		variable FlagCarriers
		variable Team
		variable Spectators
		set all_players [concat $Team(0) $Team(1) $Spectators]
		foreach player $all_players {
			if { $::Warsong::RED_DOTS_ON_MINIMAP } {
	 			foreach p $all_players {
	 				if { [lsearch $FlagCarriers $p] < 0 } {	NpcPOI $player $p 0
	 				} elseif { $::Warsong::ENEMY_ON_MAP || [::Custom::GetPlayerSide $player]==[::Custom::GetPlayerSide $p] } {
		 				NpcPOI $player $p 1
		 			}
	 			}
			}
			set side [::Custom::GetPlayerSide $player]
			if { [GameIsRunning] } {
				set ourflagcarrier [lindex $FlagCarriers $side]
				set enemyflagcarrier [lindex $FlagCarriers [expr {!$side}]]
				if { $ourflagcarrier } {
					if { $::Warsong::ENEMY_ON_MAP } {
						set pos [GetPos $ourflagcarrier]
						set x [expr {round([lindex $pos 1])}]
						set y [expr {round([lindex $pos 2])}]
						set type [expr {$side ? 1 : 2}]
					} else {
						if { $side == 0 } { foreach {x y type} {1538 1481 2} {} } { foreach {x y type} {918 1434 1} {} }
					}
					set msg [::Texts::Get "flag_taken" [GetName $ourflagcarrier] [GetSideName $player]]
				} elseif { $enemyflagcarrier } {
					if { $player != $enemyflagcarrier } {
						set pos [GetPos $enemyflagcarrier]
						set x [expr {round([lindex $pos 1])}]
						set y [expr {round([lindex $pos 2])}]
						set type [expr {$side ? 2 : 1}]
						set msg [::Texts::Get "flag_taken" [GetName $enemyflagcarrier] [GetSideName $player 1]]
					} else {
						if { $side == 0 } { foreach {x y type} {1538 1481 2} {} } { foreach {x y type} {918 1434 1} {} }
						set msg [::Texts::Get "go_capture_flag" [GetSideName $player 1]]
					}
				} else {
					if { $side == 1 } { foreach {x y type} {1538 1481 2} {} } { foreach {x y type} {918 1434 1} {} }
					set msg [::Texts::Get "go_pick_up_flag" [GetSideName $player 1]]
				}
			} else {
				if { [GameIsOver] } {
					if { ![GetWinnerSide] } {
						foreach {x y type} {1538 1481 2} {}
						set msg [::Texts::Get "victory_alliance"]
					} else {
						foreach {x y type} {918 1434 1} {}
						set msg [::Texts::Get "victory_horde"]
					}
				} else {
					set msg [::Texts::Get "wait_at_base"]
					if { $side == 0 } { foreach {x y type} {1538 1481 2} {} } { foreach {x y type} {918 1434 1} {} }
				}
			}
			if { ![info exists POICache($player)] || $POICache($player) != [list $x $y] } {
				# type: 1=red, 2=blue
				SendPOI $player 2 $x $y $type 1337 "$msg [GetScoresString]"
				#puts "$player $msg"
				set POICache($player) [list $x $y]
			}
		}
	}
	proc IsInBattleground { player } { expr {[lindex [GetPos $player] 0] == 489} }
	variable LastUpdate 0
	proc Update {} {
		set time [clock seconds]
		if { $time-$::Warsong::LastUpdate > 2 } {
			set ::Warsong::LastUpdate $time
			if { $::Warsong::FlagCarriers == "0 0" } { return }
			RunChecks
		}
	}
	proc RunChecks {} {
# 		if { $::Warsong::GIVE_ON_SELECT } {
# 			foreach carrier $::Warsong::FlagCarriers {
# 				if { $carrier } { GiveFlag $carrier [GetSelection $carrier]	}
# 			}
# 		}
		#CheckCarriers
		CheckPlayers
		if { $::Warsong::SPEED_LIMIT } { CheckSpeed }
		UpdatePOI
	}
	if { [::Custom::GetScriptVersion "Speed"] >= 1.20 } {
		proc CheckSpeed {} {
	 		variable FlagCarriers
	 		variable SPEED_LIMIT
			variable Buffs
	 		foreach carrier $FlagCarriers {
	 			if { $carrier } {
		 			set speed [Speed::Check $carrier]
		 			#Say $carrier 0 "speed: $speed"
	 				if {
		 				$speed > $SPEED_LIMIT &&
		 				(![info exists Buffs($carrier,23978)] || [clock seconds] - $Buffs($carrier,23978) >= 15) &&
		 				[DropFlag $carrier]
		 			} then {
		 				set ret_msg [::Texts::Get "flag_returned" [GetSideName $carrier 1]]
		 				ChatMessage $carrier "[::Texts::Get say_too_fast] $ret_msg"
		 				set side [::Custom::GetPlayerSide $carrier]
		 				Notify 0 "[::Texts::Get player_too_fast [GetName $carrier]] $ret_msg" $side 1
		 				Notify $carrier "[::Texts::Get too_fast] $ret_msg" $side 1
	 				}
	 			}
	 		}
		}
	} else { proc CheckSpeed {} {} }
	proc OnStealth { to from spellid } {
		if { [IsCarryingFlag $to] } {
			DropFlag $to
		}
	}
	variable CheckPlayersTime 0
	proc CheckPlayers {} {
		variable CheckPlayersTime
		set time [clock seconds]
		if { $time-$CheckPlayersTime < 90 } { return }
		set CheckPlayersTime $time
		variable LastNotify
		variable Team
		foreach side { 0 1 } {
			foreach player $Team($side) {
				if { $time-$LastNotify($player) > 200 } {
					RemoveFromTeam $player
				}
			}
		}
	}
	# not used (replaced by CheckPlayers)
	variable LastCheckCarriers 0
	proc CheckCarriers {} {
		variable LastCheckCarriers
		set time [clock seconds]
		if { $time-$LastCheckCarriers < 30 } { return }
		set LastCheckCarriers $time
		variable FlagCarriers
		set AllianceFlagCarrier [lindex $FlagCarriers 0]
		set HordeFlagCarrier [lindex $FlagCarriers 1]
		if { $AllianceFlagCarrier == 0 && $HordeFlagCarrier == 0 } { return }
		if { $AllianceFlagCarrier } {
			set af_name [GetName $AllianceFlagCarrier]
			set af_ok 0
		} else {
			set af_ok 1
		}
		if { $HordeFlagCarrier } {
			set hf_name [GetName $HordeFlagCarrier]
			set hf_ok 0
		} else {
			set hf_ok 1
		}
		#if { ![file exists "www/stat.xml"] } { return }
		set handle [open "www/stat.xml"]
		while { [gets $handle line] >= 0 } {
			if { [string match -nocase "*<name>*" $line] } {
				set name [lindex [split $line "<>"] 2]
				if { !$af_ok && $name == $af_name } { set af_ok 1
				} elseif { !$hf_ok && $name == $hf_name } {	set hf_ok 1	}
				if { $af_ok && $hf_ok } { break }
			}
		}
		close $handle
		if { !$af_ok } { RemoveFromTeam $AllianceFlagCarrier }
		if { !$hf_ok } { RemoveFromTeam $HordeFlagCarrier }
	}
	# optional anti-death system
	proc IsLowHealth { player } {
		if { ![IsInBattleground $player] } { return 0 }
		if { [GetHealthPCT $player] > 40 } { return 0 }
		OnPlayerDeath $player
		return 1
	}
	proc IncrScore { player } {
		variable Scores
		set side [::Custom::GetPlayerSide $player]
		lset Scores $side [expr {[lindex $Scores $side]+1}]
	}
	proc ClearScores {} {
		variable Scores; set Scores {0 0}
	}
	proc GetScores {} { variable Scores; return $Scores }
	proc GetScoresString {} { return "[::Texts::Get horde]: [lindex $::Warsong::Scores 1], [::Texts::Get alliance]: [lindex $::Warsong::Scores 0]" }
	proc IsInTeam { player } {
		variable Team
		expr {[lsearch  $Team(0) $player] >= 0 || [lsearch  $Team(1) $player] >= 0}
	}
	proc IsOpen {} { variable Open; return $Open }
	proc OpenBattleground {} { variable Open; set Open 1 }
	proc CloseBattleground {} { variable Open; set Open 0 }
	proc GameIsRunning {} { variable Start; return $Start }
	proc StartGame {} {
		CloseBattleground
		ClearScores
		variable Team
		foreach player [concat $Team(0) $Team(1)] {
			DropFlag $player
			if { [::Custom::PlayerIsAlive $player] } {
				GoToBase $player
			} else {
				GoToGraveyard $player
				AddToResurrect $player
			}
		}
		set ::Warsong::FlagCarriers {0 0}
		set ::Warsong::GotReward ""
		variable Start
		set Start 1
		Notify 0 [::Texts::Get "game_started"] "" 6
		RunChecks
		set ::Warsong::GameStartTime [clock seconds]
	}
	proc EndGame {} {
		variable Start; set Start 0
		set ::Warsong::GameEndTime [clock seconds]
		set ::Warsong::GameDuration [expr {$::Warsong::GameEndTime-$::Warsong::GameStartTime}]
		variable Team
		foreach player [concat $Team(0) $Team(1)] {	GiveReward $player }
	}
	proc GameIsOver {} {
		variable CAPTURE_LIMIT
		if { [lindex [GetScores] 0] >= $CAPTURE_LIMIT || [lindex [GetScores] 1] >= $CAPTURE_LIMIT } {
			return 1
		}
		return 0
	}
	proc HasWon { player } {
		variable CAPTURE_LIMIT
		set side [::Custom::GetPlayerSide $player]
		expr {[lindex [GetScores] $side] >= $CAPTURE_LIMIT && [IsInTeam $player]}
	}
	proc GetWinnerSide {} {
		if { ![GameIsOver] } { return -1 }
		variable CAPTURE_LIMIT
		if { [lindex [GetScores] 0] >= $CAPTURE_LIMIT } { return 0 } else { return 1 }
	}
	proc GetWinnerSideName {} {
		if { ![GameIsOver] } { return }
		variable CAPTURE_LIMIT
		if { [lindex [GetScores] 0] >= $CAPTURE_LIMIT } { return [::Texts::Get "alliance"] } else { return [::Texts::Get "horde"] }
	}
	proc GetRewardItem { player } {
		if { [::Custom::GetPlayerSide $player] == 0 } { return 19213 } { return 19322 }
	}
	proc GiveReward { player } {
		if { [GotReward $player] } { return 0 }
		set itemid [GetRewardItem $player]
		variable GotReward
		if { [::Custom::GetPlayerSide $player] == [GetWinnerSide] } {
			set count 3
		} elseif { $::Warsong::GameDuration >= 600 } {
			set count 1
		} else {
			set count 0
		}
		if { $count } {
			lappend GotReward $player
			for { set i 0 } { $i < $count } { incr i } {
				AddItem $player $itemid
			}
		}
		return $count
	}
	proc GotReward { player } {
		variable GotReward
		expr {[lsearch $GotReward $player] >= 0}
	}
	proc GetBalance {} {
		foreach side {0 1} {
			set levels$side 0
			foreach player $::Warsong::Team($side) { incr levels$side [GetLevel $player] }
		}
		expr {$levels0-$levels1}
	}
	proc AddToTeam { player {no_teleport 0} {no_start 0} } {
		if { ![Honor::CheckAddOnVersion $player] } { return 0 }
		#if { ![IsOpen] } { return 0 }
		variable Team
		if { [GetObjectType $player] != 4 } { return 0 }
		if { [IsInTeam $player] } { return 0 }
		#if { ![IsInBattleground $player] } { return 0 }
		variable MIN_PLAYERS
		variable MAX_PLAYERS
		CleanTeams
		set side [::Custom::GetPlayerSide $player]
		if { [llength $Team($side)] >= $MAX_PLAYERS } { return 0 }
		set ::Warsong::LastNotify($player) [clock seconds]
		if { [IsInQueue $player] } { RemoveFromQueue $player }
		lappend Team($side) $player
		variable POICache
		set POICache($player) ""
		ChatMessage $player [::Texts::Get "say_add_player" [GetTeamName $player]]
		Notify 0 [::Texts::Get "player_add_player" [GetName $player] [GetTeamName $player]] $side 5
		Notify $player [::Texts::Get "add_player" [GetTeamName $player]] $side 5
# 		set just_started 0
# 		if { ![GameIsRunning] } {
# 			if { ([llength $Team(0)]>=$MIN_PLAYERS && [llength $Team(1)]>=$MIN_PLAYERS && abs([GetBalance])<$::Warsong::BALANCE_LIMIT) ||
# 				([llength $Team(0)]>=$MAX_PLAYERS && [llength $Team(1)]>=$MAX_PLAYERS) } {
# 					StartGame
# 					set just_started 1
# 				}
# 		}
		if { ![IsInBattleground $player] && !$no_teleport } {
			if { $::Warsong::REMEMBER_RETURN_POS } { set ::Warsong::ReturnPos($player) [GetPos $player] }
			GoToBase $player
		}
		if { !$no_start } { TryStartGame }
		UpdatePOI
		return 1
	}
	proc RemoveFromTeam { player {no_teleport 0} } {
		variable Team
		DropFlag $player
		if { [IsCarryingFlag $player] } { return 0 }
		if { [GetObjectType $player] != 4 } { return 0 }
		if { ![IsInTeam $player] } {
			if { [IsInBattleground $player] } {
				GoToEntrance $player
				return -1
			}
			return 0
		}
		variable POICache
		array unset POICache $player
		# let's just unset all, it doesn't matter much
		variable PlayerWarns
		array unset PlayerWarns
		variable PowerUps
		array unset PowerUps
		variable Buffs
		array unset Buffs
		array unset ::Warsong::LastNotify $player
		ChatMessage $player [::Texts::Get "say_del_player" [GetTeamName $player]]
		set side [::Custom::GetPlayerSide $player]
		Notify 0 [::Texts::Get "player_del_player" [GetName $player] [GetTeamName $player]] $side 5
		Notify $player [::Texts::Get "del_player" [GetTeamName $player]] $side 5
		set side [::Custom::GetPlayerSide $player]
		set pos [lsearch $Team($side) $player]
		set Team($side) [lreplace $Team($side) $pos $pos]
		SendPOI $player 2 0 0 15 1337 ""
		if { [info exists ::Warsong::ReturnPos($player)] } {
			Custom::TeleportPos $player $::Warsong::ReturnPos($player)
			unset ::Warsong::ReturnPos($player)
		} elseif { [IsInBattleground $player] && !$no_teleport } { GoToEntrance $player }
		TryStartGame
		UpdatePOI
		return 1
	}
	proc GetTeamName { player {opposite 0} } {
		if { [::Custom::GetPlayerSide $player] == $opposite } { return [::Texts::Get "silverwing"] } else { return [::Texts::Get "warsong"] }
	}
	proc GetSideName { player {opposite 0} } {
		if { [::Custom::GetPlayerSide $player] == $opposite } { return [::Texts::Get "alliance"] } else { return [::Texts::Get "horde"] }
	}
	proc GetSideNameBySide { {side 0} } {
		if { $side == 0 } { return [::Texts::Get "alliance"] } else { return [::Texts::Get "horde"] }
	}
	proc GetTeamNameBySide { {side 0} } {
		if { $side == 0 } { return [::Texts::Get "silverwing"] } else { return [::Texts::Get "warsong"] }
	}
	proc CanCapture { player } { expr {[IsCarryingFlag $player] && ![lindex $::Warsong::FlagCarriers [::Custom::GetPlayerSide $player]]} }
	proc IsCarryingFlag { player } { expr {[lsearch $::Warsong::FlagCarriers $player] >= 0} }
	proc DropFlag { player {opposite 0} {update 0} } {
		variable FlagCarriers
		set side [::Custom::GetPlayerSide $player]
		set flag [expr {$side == $opposite}]
		set ok 0
		if { [CastSpell $player $player [GetDropSpell $player $opposite]] && $player==[lindex $FlagCarriers $flag] } {
			lset FlagCarriers $flag 0
			set ok 1
		}
		if { $ok && $update } { UpdatePOI }
		return $ok
	}
	proc CarryFlag { player {opposite 0} {update 0} } {
		if { [IsCarryingFlag $player] } { return 0 }
		variable FlagCarriers
		set ok 0
		set side [::Custom::GetPlayerSide $player]
		set flag [expr {$side == $opposite}]
		if { ![lindex $FlagCarriers $flag] } {
			set ok [CastSpell $player $player [GetCarrySpell $player $opposite]]
			if { $ok } { lset FlagCarriers $flag $player }
		}
		if { $ok && $update } { UpdatePOI }
		return $ok
	}
	proc GetCarrySpell { player {opposite 0} } {
		if { [::Custom::GetPlayerSide $player] == $opposite } { return 23333 } else { return 23335 }
	}
	proc GetDropSpell { player {opposite 0} } { expr {[GetCarrySpell $player $opposite]+1} }
	proc GiveFlag { player selection } {
		if { [IsCarryingFlag $player] } {
			if { [GetObjectType $selection]!=4 || ![GetHealthPCT $selection] || $player==$selection} { return [::Texts::Get "select_player"] }
			set name [GetName $selection]
			set side [::Custom::GetPlayerSide $player]
			if { [::Custom::GetPlayerSide $selection]!=$side || ![IsInTeam $selection] } {
				return [::Texts::Get "player_not_same_team" $name]
			}
			if { [Distance $player $selection] > 5 } { return [::Texts::Get "player_too_far" $name] }
			#if { [GetSelection $selection] != $player } { return "$name must be targeting you" }
			if { [DropFlag $player] && [CarryFlag $selection] } {
				if { $::Honor::ENABLE_SAYINGS } {
					ChatMessage $selection [::Texts::Get "say_got_flag" [GetName $player] [GetSideName $player 1]]
					return [::Texts::Get "give_flag" [GetSideName $player 1] $name]
				} else {
					Notify 0 [::Texts::Get "player_give_flag" [GetName $player] [GetSideName $player 1] $name] $side 0
					Notify $selection [::Texts::Get "got_flag" [GetName $player] [GetSideName $player 1]] $side 0
					Notify $player [::Texts::Get "give_flag" [GetSideName $player 1] $name] $side 0
					RunChecks
				}
			}
		} else {
			return [::Texts::Get "no_flag"]
		}
	}
	variable DeadPlayers
	proc AddToResurrect { player } {
		if { ![GetQFlag $player IsDead] || ![IsInBattleground $player] } { return 0 }
		variable DeadPlayers
		set DeadPlayers($player) [clock seconds]
		return
	}
	proc RequestResurrect { player } {
		if { ![GetQFlag $player IsDead] || ![IsInBattleground $player] } { return 0 }
		variable DeadPlayers
		if { ![info exists DeadPlayers($player)] } { AddToResurrect $player }
		variable RESURRECTION_DELAY
		set delay [expr {$RESURRECTION_DELAY+$DeadPlayers($player)-[clock seconds]}]
		if { $delay > 0 } { return $delay }
		if { [ResurrectPlayer $player] } {
			array unset DeadPlayers $player
			return 0
		}
		return [expr {int($RESURRECTION_DELAY/2)}]
	}
	proc ResurrectPlayer { player } {
		variable SpiritGuides
		set all [array names SpiritGuides]
		foreach npc $all {
			if { [GetObjectType $npc] == 3 && [GetHealthPCT $npc] } {
				if { [Distance $npc $player] <= 50 && [CastSpell $npc $player 24341] } {
					return 1
				}
			} else {
				unset SpiritGuides($npc)
			}
		}
		if { ![llength $all] } {
			set errors {}
			foreach entry {13116 13117} {
				set npcflags [::Custom::GetCreatureScp $entry npcflags]
				if { !($npcflags & 0x02) } { lappend errors "$entry: wrong npcflags" }
				set factions {35 1414 1415}
				set faction [::Custom::GetCreatureScp $entry faction]
				if { [lsearch $factions $faction] < 0 } { lappend errors "$entry: wrong faction" }
				set questscript [::Custom::GetCreatureScp $entry questscript]
				if { $questscript != "Warsong::Spirit" } { lappend errors "$entry: wrong questscript" }
			}
			if { ![llength $errors] } { lappend errors "Missing creatures 13116 and/or 13117" }
			::Custom::Error "Spirit Guides ([join $errors {, }])."
		}
		return 0
	}
	# duplicate detection
	if { [info procs "Commands"] != "" } { Custom::Error "Duplicated loading detected" }
	proc Commands { player cargs } {
		if { $cargs == "" } {
			if { [IsInBattleground $player] } { Update }
			variable FlagCarriers
			set msg [GetScoresString]
			foreach side {0 1} {
				set carrier [lindex $FlagCarriers $side]
				if { $carrier } { append msg "\n" [::Texts::Get "flag_taken" [GetName $carrier] [GetSideNameBySide $side]] }
			}
			if { [IsOpen] } {
				append msg "\n" [::Texts::Get "battleground_open"]
			} else {
				if { ![IsInTeam $player] && ![GameIsRunning] } {
					append msg "\n" [::Texts::Get "battleground_closed"]
				}
			}
			if { ![GameIsRunning] } {
				if { [IsInTeam $player] } {
					if { [GameIsOver] } {
						append msg "\n" [::Texts::Get "game_over"]
						variable GameDuration
						append msg " " "[::Texts::Get duration]: [::Custom::SecondsToTime $GameDuration]"
					} else {
						append msg "\n" [::Texts::Get "game_not_started"]
					}
				}
			} elseif { ![IsInTeam $player] } { append msg "\n" [::Texts::Get "game_running"] }
			return $msg
		} else {
			variable Team
			variable Spectators
			set msg ""
			switch -- [lindex $cargs 0] {
				"_notify" {
					set ::Warsong::LastNotify($player) [clock seconds]
					Update
					set notify [GetNotification $player]
					if { [lindex $notify 0] != "" } {
						return "HONOR_NOTIFY,[string map "{,} {\\,}" [lindex $notify 0]],[lindex $notify 1],[lindex $notify 2]"
					}
				}
				"_repop" {
					GoToGraveyard $player
					AddToResurrect $player
					return "CTF_RESURRECT,$::Warsong::RESURRECTION_DELAY"
				}
				"_resurrect" {
					set delay [RequestResurrect $player]
					if { $delay } {	return "CTF_RESURRECT,$delay" }
				}
				"_leave" {
			 		if { !$::Warsong::ALLOW_MID_GAME_EXIT && [IsInTeam $player] && [GameIsRunning] } {
				 		set msg [::Texts::Get "cant_exit"]
				 		return "HONOR_NOTIFY,[string map "{,} {\\,}" $msg]"
					} else {
						RemoveFromTeam $player
					}
					return
				}
				"drop" {
					if { [DropFlag $player] } {
						set opposite_side_name [GetSideName $player 1]
						set side [::Custom::GetPlayerSide $player]
						Notify 0 [::Texts::Get "player_drop_flag" [GetName $player] $opposite_side_name] $side 1
						Notify $player [::Texts::Get "drop_flag" $opposite_side_name] $side 1
						RunChecks
					}
					return
				}
				"give" {
					return [GiveFlag $player [GetSelection $player]]
				}
				"list" {
					append msg [::Texts::Get "list_players"] ":\n"
					append msg [::Texts::Get "horde_players"] ": "
					set first 1
					foreach p $Team(1) {
						if { $first } { set first 0	} else { append msg ", " }
						append msg [GetName $p]
					}
					append msg " ([::Texts::Get total]: [llength $Team(1)])"
					append msg "\n"
					append msg [::Texts::Get "alliance_players"] ": "
					set first 1
					foreach p $Team(0) {
						if { $first } { set first 0	} else { append msg ", " }
						append msg [GetName $p]
					}
					append msg " ([::Texts::Get total]: [llength $Team(0)])"
					#set balance [GetBalance]
					#append msg "\nBalance = "
					#if { $balance > 0 } { append msg "+" }
					#append msg $balance
					#if { $balance < -10 } { append msg " (need more Alliance players)"
					#} elseif { $balance > 10 } { append msg " (need more Horde players)" }
					return $msg
				}
				"queue" {
					append msg [::Texts::Get "queue_info"] ":\n"
					for { set num 1 } { $num <= $::Warsong::QueueCount } { incr num } {
						for { set side 1 } { $side >= 0 } { incr side -1 } {
							set queue $::Warsong::Queue($num,$side)
							set level $::Warsong::Queue($num,level)
							append msg [::Texts::Get "queue_num" $num $level] " " [GetSideNameBySide $side] ": "
							set first 1
							foreach p $queue {
								if { $first } { set first 0	} else { append msg ", " }
								append msg [GetName $p]
							}
							append msg " ([::Texts::Get total]: [llength $queue])\n"
						}
					}
					return $msg
				}
				"join" {
					if { $::Warsong::ENABLE_JOIN_COMMAND } {
						if { [IsInTeam $player] } { append msg [::Texts::Get "cant_join_queue"]
						} elseif { [AddToQueue $player] } { append msg [::Texts::Get "joined_queue"]
						} else { append msg [::Texts::Get "already_queued"] }
					} else { append msg [::Texts::Get "disabled_command"] }
					return $msg
				}
				"leave" {
					if { $::Warsong::ENABLE_JOIN_COMMAND } {
						if { [RemoveFromQueue $player] } { append msg [::Texts::Get "left_queue"]
						} else { append msg [::Texts::Get "not_queued"] }
					} else { append msg [::Texts::Get "disabled_command"] }
					return $msg
				}
				"open" {
					if { [GetPlevel $player] < 2 } { return [::Texts::Get "not_allowed_command"] }
					OpenBattleground
					return [::Texts::Get "battleground_open"]
				}
				"close" {
					if { [GetPlevel $player] < 2 } { return [::Texts::Get "not_allowed_command"] }
					CloseBattleground
					return [::Texts::Get "battleground_closed"]
				}
				"start" {
					if { [GetPlevel $player] < 2 } { return [::Texts::Get "not_allowed_command"] }
					StartGame
					#RunChecks
					if { ![IsInTeam $player] || $::Honor::ENABLE_SAYINGS } {
						return [::Texts::Get "game_started"]
					}
				}
				"end" {
					EndGame
					return [::Texts::Get "game_ended"]
				}
				"add" {
					if { [GetPlevel $player] < 2 } { return [::Texts::Get "not_allowed_command"] }
					set selection [GetSelection $player]
					if { [GetObjectType $selection] != 4 } { return [::Texts::Get "select_player"] }
					if { [AddToTeam $selection] } {
						append msg [::Texts::Get "player_add_player" [GetName $selection] [GetTeamName $selection]]
					} elseif { ![IsInTeam $selection] } {
						append msg [::Texts::Get "team_error" [GetName $selection] [GetTeamName $selection]]
					}
					append msg "\n" "[::Texts::Get number_players] - [::Texts::Get horde]: [llength $Team(1)], [::Texts::Get alliance]: [llength $Team(0)]"
					return $msg
				}
				"del" {
					if { [GetPlevel $player] < 2 } { return [::Texts::Get "not_allowed_command"] }
					set selection [GetSelection $player]
					if { [GetObjectType $selection] != 4 } { return [::Texts::Get "select_player"] }
					if { [RemoveFromTeam $selection] } {
						append msg [::Texts::Get "player_del_player" [GetName $selection] [GetTeamName $selection]] }
					append msg "\n" "[::Texts::Get number_players] - [::Texts::Get horde]: [llength $Team(1)], [::Texts::Get alliance]: [llength $Team(0)]"
					return $msg
				}
				"spec" {
					if { [GetPlevel $player] < 2 } { return [::Texts::Get "not_allowed_command"] }
					set pos [lsearch $Spectators $player]
					if { $pos < 0 } {
						append msg [::Texts::Get "joined_spectators"]
						lappend Spectators $player
					} else {
						append msg [::Texts::Get "left_spectators"]
						set Spectators [lreplace $Spectators $pos $pos]
					}
					RunChecks
					return $msg
				}
				"clear" {
					if { [GetPlevel $player] < 2 } { return [::Texts::Get "not_allowed_command"] }
					foreach p [concat $Team(0) $Team(1)] { RemoveFromTeam $p }
					set Spectators ""
					ClearScores
					CloseBattleground
					EndGame
					return [::Texts::Get "battleground_cleared"]
				}
				"clearscores" {
					ClearScores
					return [::Texts::Get "scores_cleared"]
				}
				"reload" {
					if { [GetPlevel $player] < 6 } { return [::Texts::Get "not_allowed_command"] }
					if { !$::Warsong::USE_CONF } { return [::Texts::Get "no_config"] }
					if { ![::Custom::LoadConf "Warsong"] } { return [::Texts::Get "config_error"] }
					return [::Texts::Get "config_reloaded"]
				}
				default { # help
					if { [GetPlevel $player] < 2 } {
						append msg "give, list , queue"
						if { $::Warsong::ENABLE_JOIN_COMMAND } { append msg ", join, leave" }
					} else {
						append msg "give, list, queue"
						if { $::Warsong::ENABLE_JOIN_COMMAND } { append msg ", join, leave" }
						append msg "\nadd <[::Texts::Get help_selection]>, del <[::Texts::Get help_selection]>, clear, clearscores, spec, open, close, start, end"
					}
					return $msg
				}
			}
		}
	}
	namespace eval Flag {
		proc OnGossip { obj player qid } {
			::Warsong::OnGossip $obj $player $qid
		}
		proc QueryQuest { obj player qid } {
			OnGossip $obj $player $qid
		}
	}
	namespace eval Area {
		proc AreaTrigger { player id } {
			::Warsong::AreaTrigger $player $id
		}
	}
	#
	# npcs
	#
	namespace eval Vendor {
		proc GossipHello { npc player } {
			set option0 "text 6 \"[::Texts::GetNs Warsong browse_goods]\""
			set option1 "text 0 \"[::Texts::GetNs Warsong reputation_info]\""
			::SendGossip $player $npc $option0 $option1
		}
		proc GossipSelect { npc player option } {
			set repu [::Custom::GetReputationLevel $player $npc]
			set reqrepu [::GetScpValue "creatures.scp" "creature [::GetEntry $npc]" "pvprepu"]
			if { ![string is integer -strict $reqrepu] } { set reqrepu 4 }
			switch -- $option {
				0 {
					if { $repu >= $reqrepu } {
						::VendorList $player $npc
					} else {
						set reqrepuname [lindex [::Texts::GetNs Warsong reputation_levels] [expr {$reqrepu+3}]]
						::SendGossip $player $npc "text 6 \"[::Texts::GetNs Warsong cant_buy $reqrepuname]\""
					}
				}
				1 {
					set repuname [lindex [::Texts::GetNs Warsong reputation_levels] [expr {$repu+3}]]
					::SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong your_reputation $repuname]\""
				}
			}
		}
		proc QuestStatus { npc player } {
			set repu [::Custom::GetReputationLevel $player $npc]
			set reqrepu [::GetScpValue "creatures.scp" "creature [::GetEntry $npc]" "pvprepu"]
			if { ![string is integer -strict $reqrepu] } { set reqrepu 4 }
			if { $repu >= $reqrepu } { return 7 }
			return 0
		}
		proc QuestHello { npc player } { GossipHello $npc $player }
	}
	namespace eval Quest {
		variable Quests {{8291 7873 7872 7871 7788} {8294 7876 7875 7874 7789}}
		variable QuestsLevels {60 50 40 30 20}
		proc GetSide { npc } {
			set faction [::Custom::GetFaction $npc]
			if { $faction == 1514 } {
				return 0
			} elseif { $faction == 1515 } {
				return 1
			}
			::Custom::Error "Creature [::GetEntry $npc] has wrong faction."
			return 0
		}
		proc GossipHello { npc player } {
			variable Quests
			variable QuestsLevels
			set quest_status {}
			#set side [::Custom::GetPlayerSide $player]
			set side [GetSide $npc]
			foreach qid [lindex $Quests $side] {
				set qs [GetQuestStatus $player $qid]
				if { $qs == 1 } {
					# extra check for safety
					set itemid [::Warsong::GetRewardItem $player]
					if { [::ConsumeItem $player $itemid 1] } {
						AddItem $player $itemid
						SendQuestReward $player $npc $qid
					}
					return
				}
				lappend quest_status $qs
			}
			set i 0
			foreach qs $quest_status {
				if { $qs == 3 } {
					if { [Warsong::IsInQueue $player] } {
						set gossip "text 2 \"[::Texts::GetNs Warsong warsong_remove]\""
					} else {
						set gossip "text 2 \"[::Texts::GetNs Warsong warsong_play]\""
					}
					SendGossip $player $npc $gossip
					return
				}
				incr i
			}
			set level [::GetLevel $player]
			set i 0
			foreach qs $quest_status {
				if { $qs == 4 && $level >= [lindex $QuestsLevels $i] } {
					SendQuestDetails $player $npc [lindex $Quests $side $i]
					return
				}
				incr i
			}
		}
		proc GossipSelect { npc player option } {
			if { [::Warsong::AddToQueue $player] } {
				SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong joined_queue]\""
			} elseif { [::Warsong::RemoveFromQueue $player] } {
				SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong left_queue]\""
			}
		}
		proc QuestStatus { npc player } {
			# check if the player already has the requested deliver items
			variable Delivers$player
			if { [info exists Delivers$player] } {
				set delivers [set Delivers$player]
				unset Delivers$player
				foreach { itemid count } $delivers {
					while { $count > 0 } {
						if { [::ConsumeItem $player $itemid $count] } {
							for { set i 0 } { $i < $count } { incr i } {
								AddItem $player $itemid
							}
							return
						}
						incr count -1
					}
				}
			}
			variable Quests
			variable QuestsLevels
			set quest_status {}
			#set side [::Custom::GetPlayerSide $player]
			set side [GetSide $npc]
			foreach qid [lindex $Quests $side] {
				set qs [GetQuestStatus $player $qid]
				if { $qs == 1 } { return 5 }
				lappend quest_status $qs
			}
			set i 0
			foreach qs $quest_status {
				if { $qs == 3 } { return 3 }
				incr i
			}
			set level [::GetLevel $player]
			set i 0
			foreach qs $quest_status {
				if { $qs == 4 && $level >= [lindex $QuestsLevels $i] } { return 4 }
				incr i
			}
			return 1
		}
		proc QuestChooseReward { npc player questid choose } {
			set level [::GetLevel $player]
			if { $level > 60 } { set level 60 }
			AddReputation $player $npc [expr {round($::Warsong::REPUTATION_RATE*$level*(5+rand()))}]
		}
		proc QuestAccept { npc player questid } {
			variable Delivers$player
			# GetScpValue always returns only one key...
			foreach deliver [::GetScpValue "quests.scp" "quest $questid" "deliver"] {
				foreach { itemid count } $deliver {
					lappend Delivers$player $itemid $count
				}
			}
			if { [::Warsong::AddToQueue $player] } {
				SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong joined_queue]\""
			}
		}
		proc QuestHello { npc player } { GossipHello $npc $player }
	}
	namespace eval Battle {
		proc GossipHello { npc player } {
			if { [Warsong::IsInQueue $player] } {
				set option0 "text 2 \"[::Texts::GetNs Warsong warsong_remove]\""
			} else {
				set option0 "text 2 \"[::Texts::GetNs Warsong warsong_play]\""
			}
			::SendGossip $player $npc $option0
		}
		proc GossipSelect { npc player option } {
			if { [::Honor::CheckAddOnVersion $player] } {
				if { [::Warsong::RemoveFromQueue $player] } {
					::SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong warsong_unqueued]\""
				} else {
					if { [::Warsong::IsOpen] && [::Warsong::AddToTeam $player] } {
					} elseif { [::Warsong::AddToQueue $player] } {
						::SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong warsong_queued]\""
					} else {
						::SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong warsong_error]\""
					}
				}
			}
		}
		proc QuestStatus { npc player } { return 7 }
		proc QuestHello { npc player } { GossipHello $npc $player }
	}
	namespace eval Spirit {
		proc GossipHello { npc player } {
			SendGossip $player $npc "text 0 \"[::Texts::GetNs Warsong \"Hello?\"]\""
		}
		proc GossipSelect { npc player option } {
		}
		proc QuestStatus { npc player } {
			::Warsong::Update
			set ::Warsong::SpiritGuides($npc) 1
			return 0
		}
		proc QuestHello { npc player } { GossipHello $npc $player }
	}
	variable QuestScripts
	array set QuestScripts {
		2302 "Battle" 2804 "Battle" 3890 "Battle" 10360  "Battle" 14981  "Battle" 14982 "Battle"\
		20002 "Battle" 20003 "Battle" 51001 "Battle" 51002 "Battle"\
		14733 "Quest" 14781 "Quest"\
		13116 "Spirit" 13117 "Spirit"\
	}
	variable DefaultQuestScript "Vendor"
	foreach proc {GossipHello GossipSelect QuestStatus QuestChooseReward QuestAccept} {
		eval "proc $proc \{ args \} \{
			set npc \[lindex \$args 0\]
			set entry \[::GetEntry \$npc\]
			if \{ \[info exists ::Warsong::QuestScripts(\$entry)\] \} \{
				eval \$::Warsong::QuestScripts(\$entry)::$proc \$args
			\} else \{
				eval \$\{::Warsong::DefaultQuestScript\}::$proc \$args
			\}
		\}"
	}
	proc QuestHello { npc player } {
		GossipHello $npc $player
	}
	proc OnPlayerTeleportSpell { to {from 0} {spellid 0} } {
		if { $::Warsong::ALLOW_MID_GAME_EXIT } {
			if { [IsInTeam $to] } { RemoveFromTeam $to 1 }
		} else {
			if { [IsInTeam $to] } {
				if { [GameIsRunning] } { return 1 }
				RemoveFromTeam $to 1
			}
		}
		return 0
	}
	proc AreaTrigger { player id } {
		set side [::Custom::GetPlayerSide $player]
		switch -- $id {
		 	3671 { ## to alliance exit
		 		if { $side == 0 } {
			 		if { !$::Warsong::ALLOW_MID_GAME_EXIT && [IsInTeam $player] && [GameIsRunning] } {
				 		ChatMessage $player [::Texts::Get "cant_exit"] 1
					} else {
						array unset ::Warsong::ReturnPos $player
						RemoveFromTeam $player
						Teleport $player 1 1429 -1856 134
					}
				} else {
					# don't allow horde players to take this exit
					ChatMessage $player [::Texts::Get "cant_exit_alliance"] 1
				}
			}
			3654 { ## to warsong side
				if { ![Honor::CheckAddOnVersion $player] } { return }
				if { [IsOpen] && [AddToTeam $player 1] || [IsInTeam $player] } {
					Teleport $player 489 1013 1293 345
				} elseif { [AddToQueue $player] } {
					ChatMessage $player [::Texts::Get "say_join_queue"] 1
					#Notify $player "You have joined the queue."
				} elseif { [RemoveFromQueue $player] } {
					ChatMessage $player [::Texts::Get "say_left_queue"] 1
				} else {
					ChatMessage $player [::Texts::Get "closed"] 1
				}
			}
			3669 { ## to horde exit
				if { $side == 1 } {
			 		if { !$::Warsong::ALLOW_MID_GAME_EXIT && [IsInTeam $player] && [GameIsRunning] } {
				 		ChatMessage $player [::Texts::Get "cant_exit"] 1
					} else {
						array unset ::Warsong::ReturnPos $player
						RemoveFromTeam $player
						Teleport $player 1 1034 -2093 125
					}
				} else {
					# don't allow alliance players to take this exit
					ChatMessage $player [::Texts::Get "cant_exit_horde"] 1
				}
			}
			3650 { ## to silverwing side
				if { ![Honor::CheckAddOnVersion $player] } { return }
				if { [IsOpen] && [AddToTeam $player 1] || [IsInTeam $player] } {
					Teleport $player 489 1452 1623 357
				} elseif { [AddToQueue $player] } {
					ChatMessage $player [::Texts::Get "say_join_queue"] 1
					#Notify $player "You have joined the queue."
				} elseif { [RemoveFromQueue $player] } {
					ChatMessage $player [::Texts::Get "say_left_queue"] 1
				} else {
					ChatMessage $player [::Texts::Get "closed"] 1
				}
			}
			3646 { ## alliance flag
				if { $Warsong::PICK_UP_FLAG_ON_AREA } {	OnGossip $player $player 23333 }
			}
			3647 { ## warsong flag
				if { $Warsong::PICK_UP_FLAG_ON_AREA } {	OnGossip $player $player 23335 }
			}
			3686 { Buff $player $id }
			3687 { Buff $player $id }
			3706 { Buff $player $id }
			3708 { Buff $player $id }
			3707 { Buff $player $id }
			3709 { Buff $player $id }
		}
		RunChecks
	}
	# gameobj speed: 179899, food: 179904; berserk; 179905
	proc Buff { player id } {
		if { ![IsInTeam $player] && [IsOpen] } { AddToTeam $player }
		variable POWERUPS_SPAWNTIME
		if { $POWERUPS_SPAWNTIME < 0 } { return }
		variable PlayerWarns
		variable PowerUps
		variable Buffs
		set time [clock seconds]
		if { ![info exists PowerUps($id)] } { set PowerUps($id) 0 }
		if { ![info exists PlayerWarns($player)] } { set PlayerWarns($player) 0 }
		set time_left [expr $POWERUPS_SPAWNTIME-$time+$PowerUps($id)]
		if { $time_left <= 0 } {
			set buff [GetBuffSpell $id]
			CastSpell $player $player $buff
			set Buffs($player,$buff) $time
			set PowerUps($id) $time
			set PlayerWarns($player) $time
		} elseif { $time - $PlayerWarns($player) >= 10 } {
			Notify $player [::Texts::Get "powerup_respawntime" $time_left]
			#UpdatePOI
			set PlayerWarns($player) $time
		}
	}
	proc GetBuffSpell { id } {
		switch -- $id {
			3686 { return 23978 }
			3687 { return 23978 }
			3706 { return 24379 }
			3708 { return 24379 }
			3707 { return 24378 }
			3709 { return 24378 }
		}
	}
	InitQueues
}
# compatibility stuff
namespace eval Illiyana_Moonblaze_14753 {
	proc QuestHello { npc player } { Warsong::QuestHello $npc $player }
	proc GossipHello { npc player } { Warsong::GossipHello $npc $player }
	proc GossipSelect { npc player option } { Warsong::GossipSelect $npc $player $option }
	proc QuestStatus { npc player } { Warsong::QuestStatus $npc $player }
}
namespace eval Kelm_Hargunth_14754 {
	proc QuestHello { npc player } { Warsong::QuestHello $npc $player }
	proc GossipHello { npc player } { Warsong::GossipHello $npc $player }
	proc GossipSelect { npc player option } { Warsong::GossipSelect $npc $player $option }
	proc QuestStatus { npc player } { Warsong::QuestStatus $npc $player }
}
# compatibility with Jammer's namespaces
# gameobjects
namespace eval E2RF {
   proc OnGossip { obj player qid } { Warsong::OnGossip $obj $player $qid }
}
namespace eval E2BF {
	proc OnGossip { obj player qid } { Warsong::OnGossip $obj $player $qid }
}
# creatures
namespace eval E2BM1 {
	proc QuestHello { npc player } { Warsong::QuestHello $npc $player }
	proc GossipHello { npc player } { Warsong::GossipHello $npc $player }
	proc QuestStatus { npc player } { Warsong::QuestStatus $npc $player }
	proc GossipSelect { npc player option } { Warsong::GossipSelect $npc $player $option }
}
namespace eval E2BM2 {
	proc QuestHello { npc player } { Warsong::QuestHello $npc $player }
	proc GossipHello { npc player } { Warsong::GossipHello $npc $player }
	proc QuestStatus { npc player } { Warsong::QuestStatus $npc $player }
	proc GossipSelect { npc player option } { Warsong::GossipSelect $npc $player $option }
}
# areatriggers
namespace eval E2 {
   proc AreaTrigger { player id } { Warsong::AreaTrigger $player $id }
}
# check for missing SPELL_EFFECT_SEND_EVENT
if { [info procs ::SpellEffects::SPELL_EFFECT_SEND_EVENT] == "" } {
    proc ::SpellEffects::SPELL_EFFECT_SEND_EVENT { to from eventid } {
	    #puts "spell effect event $to $from $eventid"
    }
}
namespace eval ::Warsong {
	if { $::Warsong::SELF_INTEGRATION } {
		if { $::Warsong::NO_DEATH } {
			::Custom::HookProc "WoWEmu::DamageReduction" {if { [::Warsong::IsLowHealth $player] } { return 1. }} "Warsong::"
		}
		::Custom::HookProc "WoWEmu::OnPlayerDeath" {::Warsong::OnPlayerDeath $player $killer} "Warsong::"
		::Custom::HookProc "WoWEmu::OnPlayerResurrect" {::Warsong::OnPlayerResurrect $player} "Warsong::"
		::Custom::HookProc "SpellEffects::SPELL_EFFECT_TELEPORT_UNITS" {if { [::Warsong::OnPlayerTeleportSpell $to $from $spellid] } { return }} "Warsong::"
		::Custom::AddCommand "ctf" "::Warsong::Commands"
		::Custom::AddCommand "warsong" "::Warsong::Commands"
		::Custom::AddSpellScript "::Warsong::OnStealth" 1784 1785 1786 1787
	}
	::StartTCL::Provide
}
# testing suff
namespace eval ::Warsong {
	if { $DEBUG } {
		puts "\n[namespace tail [namespace current]]: *** DEBUG MODE ENABLED ***\n"
		# .eval Custom::GetBenchData 1
		foreach proc [lsort [info procs]] {
			#Custom::BenchCmd [namespace current]::$proc 1
			Custom::TraceCmd [namespace current]::$proc 0
		}
	}
}

