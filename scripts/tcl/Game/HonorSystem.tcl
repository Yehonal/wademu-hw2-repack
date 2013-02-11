# StartTCL: n
#
# Honor System
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
# Description: honor for killing players, leaders and guards, dishonor for killing civilians
#

namespace eval ::Honor {

	# defaults (if you have scripts.conf, use it to change values)
	variable ALLOW_GM_HONOR 1
	variable ALLOWED_MAPS {0 1}
	variable ALLOWED_LOCATIONS {}
	variable PLAYER_RATE 1.0
	variable LEADER_RATE 1.0
	variable GUARD_RATE 0.0
	variable CIVILIAN_RATE 1.0
	variable CIVILIAN_NOAGGRO 0
	variable DECAY_RATE 0.5
	variable MAX_GAIN 400
	variable ENABLE_BALANCING 1
	variable HONOR_LIMIT 65000
	variable RANKINGS_UPDATE 60
	variable RANKINGS_LIMIT 300
	variable SHOW_DEFEATS 0
	variable SHOW_TOTALS 0
	variable HONOR_HALL_RANK 6
	variable WARSONG_OPTION 1
	variable ADDON_VERSION 1.43
	variable ENFORCE_ADDON 1
	variable JAIL_TIME 0
	variable CHECK_LOGIN 2
	variable CHECK_GHOST 1
	variable ENABLE_LOG 1
	variable ENABLE_SAYINGS 0
	variable HONOR_DIR "honor"
	variable USE_SQLDB 1
	variable CONSOLE_INFO default
	variable DEBUG 0

	variable USE_CONF 1
	variable SELF_INTEGRATION 1
	variable MIN_CUSTOM 2.04
	variable MAX_ROWS 8000

	variable VERSION 4.52
	variable NAME [namespace tail [namespace current]]

	variable LeadersArray
	array set LeadersArray {1748 0 2784 0 3516 0 4949 1 3057 1 10181 1}

	variable GuardsArray
	array set GuardsArray {3502 -1 4624 -1 5091 -1 6766 -1 7865 -1 9460 -1 11190 -1 11194 -1 68 0 197 0 234 0 261 0 349 0 464 0 466 0 469 0 487 0 488 0 489 0 490 0 495 0 727 0 754 0 821 0 823 0 826 0 827 0 851 0 853 0 869 0 870 0 874 0 876 0 885 0 886 0 932 0 933 0 934 0 935 0 936 0 999 0 1089 0 1090 0 1245 0 1276 0 1277 0 1278 0 1279 0 1280 0 1281 0 1282 0 1283 0 1329 0 1330 0 1331 0 1332 0 1334 0 1335 0 1336 0 1337 0 1338 0 1340 0 1358 0 1360 0 1379 0 1423 0 1434 0 1437 0 1475 0 1476 0 1479 0 1482 0 1483 0 1642 0 1679 0 1747 0 1750 0 1751 0 1754 0 1756 0 1777 0 1854 0 1959 0 1975 0 1976 0 2041 0 2092 0 2099 0 2105 0 2151 0 2153 0 2361 0 2362 0 2363 0 2378 0 2386 0 2439 0 2466 0 2468 0 2469 0 2506 0 2507 0 2508 0 2509 0 2510 0 2511 0 2512 0 2513 0 2514 0 2515 0 2516 0 2517 0 2518 0 2524 0 2525 0 2526 0 2527 0 2528 0 2608 0 2930 0 3469 0 3571 0 3584 0 3691 0 3836 0 4262 0 4484 0 4921 0 4922 0 4944 0 4961 0 4966 0 4973 0 4979 0 4995 0 5595 0 5683 0 5782 0 6086 0 6087 0 6090 0 6173 0 6182 0 6237 0 6241 0 7009 0 7295 0 7917 0 7937 0 7939 0 7946 0 7949 0 7956 0 8015 0 8055 0 8096 0 8151 0 8310 0 8383 0 9023 0 9095 0 9119 0 10037 0 10300 0 10301 0 10604 0 10606 0 10610 0 10611 0 10696 0 10803 0 10804 0 10805 0 10838 0 11023 0 11699 0 11712 0 11867 0 12160 0 12423 0 12425 0 12427 0 12480 0 12481 0 12580 0 12657 0 12658 0 12778 0 12779 0 12780 0 12785 0 12786 0 12787 0 12996 0 13076 0 13422 0 14041 0 14187 0 14188 0 14363 0 14365 0 14367 0 14378 0 14379 0 14380 0 14394 0 14423 0 14438 0 14439 0 14715 0 14721 0 861 1 862 1 863 1 864 1 865 1 866 1 867 1 868 1 1064 1 1495 1 1496 1 1519 1 1560 1 1735 1 1736 1 1737 1 1738 1 1739 1 1740 1 1741 1 1742 1 1743 1 1744 1 1745 1 1746 1 1978 1 2058 1 2209 1 2210 1 2392 1 2395 1 2396 1 2398 1 2400 1 2405 1 2433 1 2464 1 2621 1 2714 1 2721 1 2733 1 3057 1 3083 1 3084 1 3210 1 3211 1 3212 1 3213 1 3214 1 3215 1 3217 1 3218 1 3219 1 3220 1 3221 1 3222 1 3223 1 3224 1 3296 1 3338 1 3501 1 3732 1 3733 1 3734 1 3735 1 3736 1 3804 1 3806 1 3807 1 3808 1 3849 1 3893 1 4309 1 4310 1 5546 1 5547 1 5624 1 5653 1 5654 1 5699 1 5725 1 5952 1 5953 1 6497 1 6522 1 6785 1 6987 1 7489 1 7730 1 7780 1 7875 1 7975 1 7980 1 8016 1 8147 1 8154 1 8155 1 9118 1 9457 1 9525 1 10036 1 10079 1 10428 1 10537 1 10539 1 10578 1 10612 1 10638 1 10645 1 10646 1 10665 1 10676 1 10682 1 10837 1 10919 1 10954 1 11022 1 11180 1 11196 1 11259 1 11317 1 11624 1 11718 1 11856 1 11857 1 11860 1 11861 1 11877 1 11878 1 12428 1 12576 1 12717 1 12737 1 12816 1 12837 1 12858 1 12867 1 12903 1 13079 1 13397 1 13449 1 13531 1 13536 1 13539 1 13542 1 13545 1 13839 1 14186 1 14304 1 14375 1 14376 1 14377 1 14402 1 14403 1 14404 1 14440 1 14441 1 14442 1 14717 1 14781 1 14859 1 14893 1}

	if { $USE_CONF } { ::Custom::LoadConf }

	namespace eval Hits {}
	namespace eval Attacked {}

	variable Columns "name rating race class level guild hkills dkills defeats addon_ver addon_time activity locale"
	variable LoginScriptEffect

	# get a player's rating
	proc GetRating { player } { GetRatingByName [::GetName $player] }

	# get a player's rank
	proc GetRank { player } { GetRankByName [::GetName $player] }

	# get a player's rank name
	proc GetRankName { player } { GetRankNameByName [::GetName $player] }

	# get a player's rating from his name
	proc GetRatingByName { player_name } { lindex [ReadData $player_name] 0 }

	# get a player's rank from his name
	proc GetRankByName { player_name } { GetRankByRating [GetRatingByName $player_name] }

	# get a player's rank name from his name
	proc GetRankNameByName { player_name } {
		GetRankNameByRankSide [GetRankByName $player_name] [::Custom::GetPlayerSideByRace [GetRaceByName $player_name]]
	}

	# get rank from rating
	proc GetRankByRating { rating } {
		if { $rating <=0     } { return 0 }
		if { $rating < 1000  } { return 1 }
		if { $rating < 5000  } { return 2 }
		if { $rating < 10000 } { return 3 }
		if { $rating < 15000 } { return 4 }
		if { $rating < 20000 } { return 5 }
		if { $rating < 25000 } { return 6 }
		if { $rating < 30000 } { return 7 }
		if { $rating < 35000 } { return 8 }
		if { $rating < 40000 } { return 9 }
		if { $rating < 45000 } { return 10 }
		if { $rating < 50000 } { return 11 }
		if { $rating < 55000 } { return 12 }
		if { $rating < 60000 } { return 13 }
		if { $rating <=65000 } { return 14 }
		return 15
	}

	# get rank name from rank and side
	proc GetRankNameByRankSide { rank {side 0} } {
		lindex [lindex [list [::Texts::Get "alliance_ranks"] [::Texts::Get "horde_ranks"]] $side] $rank
	}

	# get a player's race from his name
	proc GetRaceByName { player_name } { lindex [ReadData $player_name] 1 }

	# get a player's lifetime honorable kills
	proc GetHonorableKills { player } { GetHonorableKillsByName [::GetName $player] }

	# get a player's lifetime dishonorable kills
	proc GetDishonorableKills { player } { GetDishonorableKillsByName [::GetName $player] }

	# get rank progress bar value
	proc GetRankProgress { player } { GetRankProgressByName [::GetName $player] }

	# get a player's lifetime honorable kills from his name
	proc GetHonorableKillsByName { player_name } { lindex [ReadData $player_name] 5 }

	# get a player's lifetime dishonorable kills from his name
	proc GetDishonorableKillsByName { player_name } { lindex [ReadData $player_name] 6 }

	# get last time a player was active (killing or dying)
	proc GetActivityByName { player_name } { lindex [ReadData $player_name] 10 }

	# get rank progress bar value from a player's name
	proc GetRankProgressByName { player_name } {
		set rating [GetRatingByName $player_name]
		set rating_floor [GetRatingByRank [GetRankByName $player_name]]
		set rating_ceil [GetRatingByRank [expr {[GetRankByName $player_name]+1}]]
		if { $rating_ceil > $rating_floor } {
			expr {double($rating-$rating_floor)/($rating_ceil-$rating_floor)}
		} else {
			return 1.
		}
	}

	# get the floor rating for a given rank
	proc GetRatingByRank { rank } {
		switch -- $rank {
			0  { return 0 }
			1  { return 1 }
			2  { return 1000 }
			3  { return 5000 }
			4  { return 10000 }
			5  { return 15000 }
			6  { return 20000 }
			7  { return 25000 }
			8  { return 30000 }
			9  { return 35000 }
			10 { return 40000 }
			11 { return 45000 }
			12 { return 50000 }
			13 { return 55000 }
			14 { return 60000 }
			default { return 65000 }
		}
	}

	# set a player's addon version
	proc SetAddOnVersion { player version } {
		if { ![string is double -strict $version] } { return 0 }
		variable HonorData
		set player_name [::GetName $player]
		set pn [string tolower $player_name]
		set time [clock seconds]
		ReadData $player_name
		set oldtime [lindex $HonorData($pn) 9]
		lset HonorData($pn) 8 $version
		lset HonorData($pn) 9 $time
		if { $time - $oldtime > 60 } {
			WriteData $player_name
		}
		return $version
	}

	# get a player's addon version
	proc GetAddOnVersion { player } {
		variable HonorData
		set player_name [::GetName $player]
		set pn [string tolower $player_name]
		ReadData $player_name
		if { [clock seconds] - [lindex $HonorData($pn) 9] > 86400 * 7 } { return 0 }
		lindex $HonorData($pn) 8
	}

	proc SetSecure { player { secure 1 } } {
		variable Secure
		set Secure($player) $secure
	}

	proc GetSecure { player } {
		variable Secure
		return [expr { [info exists Secure($player)] ? $Secure($player) : 1 }]
	}

	proc Locale { player {locale ""} } {
		if { $locale == "" } { return [GetLocale $player] }
		SetLocale $player $locale
	}

	proc SetLocale { player locale } {
		if { $locale == "" } { return }
		variable HonorData
		set player_name [::GetName $player]
		set pn [string tolower $player_name]
		ReadData $player_name
		if { [string index $locale 2] != "_" } {
			set locale "[string range $locale 0 1]_[string range $locale 2 3]"
		}
		set lang [string tolower [string range $locale 0 1]]
		set country [string toupper [string range $locale 3 4]]
		if { ![string is alpha $lang] || ![string is alpha $country] } {
			return
		}
		set locale $lang
		if { $country != "" } { append locale "_" $country }
		if { [lindex $HonorData($pn) 11] != $locale } {
			lset HonorData($pn) 11 $locale
			WriteData $player_name
		}
		lindex $HonorData($pn) 11
	}

	proc GetLocale { player } {
		variable HonorData
		set player_name [::GetName $player]
		set pn [string tolower $player_name]
		ReadData $player_name
		lindex $HonorData($pn) 11
	}

	# change a player's rating
	proc ChangeRating { player {points 0} {kill_type 0} {comment ""} {limit 1} } {

		CheckAddOnVersion $player

		variable HonorData
		set player_name [::GetName $player]
		set pn [string tolower $player_name]
		ReadData $player_name

		lset HonorData($pn) 1 [::GetRace $player]
		lset HonorData($pn) 2 [::GetClass $player]
		lset HonorData($pn) 3 [::GetLevel $player]
		lset HonorData($pn) 4 [::Custom::GetGuildName $player]

		set oldrank [GetRankByRating [lindex $HonorData($pn) 0]]
		if { [ChangeRatingByName $player_name $points $kill_type $comment $limit] } {
			set newrank [GetRankByRating [lindex $HonorData($pn) 0]]
			if { $oldrank != $newrank } {
				if { $newrank } {
					set rank_name [GetRankName $player]
					set msg [::Texts::Get "say_new_rank" $rank_name]
					set notify [::Texts::Get "new_rank" $rank_name]
				} else {
					set msg [::Texts::Get "say_no_more_rank"]
					set notify [::Texts::Get "no_more_rank"]
				}
				ChatMessage $player $msg
				NotifyRank $player $notify
			}
			return 1
		}
		return 0
	}

	# change a player's rating from his name
	proc ChangeRatingByName { player_name {points 0} {kill_type 0} {comment ""} {limit 1} } {
		variable HONOR_LIMIT
		variable HonorData
		set pn [string tolower $player_name]
		ReadData $player_name

		set player_honor [lindex $HonorData($pn) 0]
		set player_hkills [lindex $HonorData($pn) 5]
		set player_dkills [lindex $HonorData($pn) 6]
		set player_defeats [lindex $HonorData($pn) 7]

		incr player_honor [expr {round($points)}]
		if { $player_honor < 0 } { set player_honor 0 }
		if { $player_honor > $HONOR_LIMIT && $HONOR_LIMIT > 0 && $limit } { set player_honor $HONOR_LIMIT }
		switch -- $kill_type {
			 1 { incr player_hkills }
			-1 { incr player_dkills }
			-2 { incr player_defeats }
		}

		lset HonorData($pn) 0 $player_honor
		lset HonorData($pn) 5 $player_hkills
		lset HonorData($pn) 6 $player_dkills
		lset HonorData($pn) 7 $player_defeats
		lset HonorData($pn) 10 [clock seconds]

		if { [WriteData $player_name] } {
			ClearNames
			if { $comment != "" } { Log $player_name $player_honor $points $comment }
			return 1
		}
		return 0
	}

	# check whether the player's place is allowed for honor
	proc IsInAllowedPlace { player } {
		variable ALLOWED_MAPS
		if { [lsearch $ALLOWED_MAPS [lindex [GetPos $player] 0]] >= 0 || $ALLOWED_MAPS == "*" } { return 1 }
		variable ALLOWED_LOCATIONS
		if { [lsearch $ALLOWED_LOCATIONS [GetLocation $player]] >= 0 } { return 1 }
		return 0
	}

	proc CheckGM { player } {
		if { !$::Honor::ALLOW_GM_HONOR && [::GetPlevel $player] >= 2 } {
			set msg [::Texts::Get "gm_honor_disabled"]
			ChatMessage $player $msg
			Notify $player $msg
			return 1
		}
		return 0
	}

	# read a player's file
	proc ReadData { player_name } {
		if { $player_name == "" } { return 0 }
		variable HonorData
		set pn [string tolower $player_name]
		if { [info exists HonorData($pn)] } {
			return $HonorData($pn)
		} else {
			variable HONOR_DIR
			set player_file "$HONOR_DIR/$player_name"
			if { [file exists $player_file] } {
				set hplayer [open $player_file r]
				set data [gets $hplayer]
				if { [llength $data] > 1 } {
					# new single line format
					foreach [lrange $::Honor::Columns 1 12] [lrange $data 0 11] {}
				} else {
					# old multi line format
					set rating $data
					foreach column [lrange $::Honor::Columns 2 12] {
						set $column [gets $hplayer]
					}
				}
				close $hplayer
				# check data types
				if { ![string is integer -strict $rating] } { set rating 0 }
				if { ![string is integer -strict $race] } { set race 0 }
				if { ![string is integer -strict $class] } { set class 0 }
				if { ![string is integer -strict $level] } { set level 0 }
				if {  [string is integer -strict $guild] } { set guild "" }
				if { ![string is integer -strict $hkills] } { set hkills 0 }
				if { ![string is integer -strict $dkills] } { set dkills 0 }
				if { ![string is integer -strict $defeats] } { set defeats 0 }
				if { ![string is double  -strict $addon_ver] } { set addon_ver 0 }
				if { ![string is integer -strict $addon_time] } { set addon_time 0 }
				if { ![string is integer -strict $activity] } { set activity [clock seconds] }
				if { [string is integer $locale] } { set locale [Texts::Locale] }
			} else {
				set rating 0
				set race 0
				set class 0
				set level 0
				set guild ""
				set hkills 0
				set dkills 0
				set defeats 0
				set addon_ver 0
				set addon_time 0
				set activity [clock seconds]
				set locale [Texts::Locale]
			}
			set HonorData($pn) [list $rating $race $class $level $guild $hkills $dkills $defeats $addon_ver $addon_time $activity $locale]
		}
	}

	# write a player's file
	proc WriteData { player_name } {
		if { $player_name == "" } { return 0 }
		set pn [string tolower $player_name]
		# single line format
		set hplayer [open "$::Honor::HONOR_DIR/$player_name" w]
		puts $hplayer $::Honor::HonorData($pn)
		close $hplayer
		return 1
	}

	# logging
	proc Log { name rating points msg {pos ""} } {
		if { !$::Honor::ENABLE_LOG } { return }
		set log "player=$name rating=$rating points=$points event=\"$msg\""
		if { $pos != "" } { append log " pos=\[[::Custom::RoundPos $pos]\]" }
		::Custom::Log $log "logs/honor.log" 0
	}

	# manual check for logout exploit (when typing .honor check)
	variable CheckPlayersTime 0
	proc CheckPlayers { hitter } {
		variable CheckPlayers
		variable CheckPlayersTime
		set time [clock seconds]

		if { $time - $CheckPlayersTime > 60 } {
			foreach { hitter data } [array get CheckPlayers] {
				if { $time-[lindex $data 1] > 120 } {
					unset CheckPlayers($hitter)
				}
			}
			set CheckPlayersTime $time
		}

		if { ![info exists CheckPlayers($hitter)] } { set CheckPlayers($hitter) [list 1 $time] }
		set count [lindex $CheckPlayers($hitter) 0]
		#set last_time [lindex $CheckPlayers($hitter) 1]
		if { $count < 9 } {
			Custom::IsOnline $hitter 1
			incr count
			set CheckPlayers($hitter) [list $count $time]
		} else {
			#Custom::IsOnline $hitter 0
			return
		}

		set cowards {}
		foreach var [info vars ::Honor::Hits::*] {
			if { [info exists $var($hitter)] } {
				set player [string range 15 end]
				if { [::GetObjectType $player] == 4 } {
					if { ![::Custom::IsOnline $player] && [::GetHealthPCT $player] < 100 } {
						if { ![::CastSpell $player $player 7] } {
							#::CastSpell $hitter $player 5
						}
						CalcRatings $player $hitter
						lappend cowards $player
					}
				} else {
					unset $var
				}
			}
		}
		if { [llength $cowards] } {
			set msg [GetNotification $hitter]
			if { $msg != "" } {
				if { $::Honor::ENABLE_SAYINGS } { return "[join $cowards {, }]" }
				return "HONOR_NOTIFY,[string map "{,} {\\,}" $msg]"
			}
		}
	}

	# automatic check for logout exploit (when the player logins)
	proc CheckLogin { player } {
		foreach { hitter hit } [array get ::Honor::Hits::$player] {
			set ot [::GetObjectType $hitter]
			if { $ot == 3 || $ot == 4 } {
				if { [::Distance $player $hitter] <= 50 } {
					if {
						($ot == 4 && $::Honor::CHECK_LOGIN > 0 && [::Custom::PlayerIsAlive $hitter] && [::Custom::IsOnline $hitter]) ||
						($ot == 3 && $::Honor::CHECK_LOGIN > 1 && [::Custom::NpcIsAlive $hitter])
					} then {
						if { ![::CastSpell $player $player 7] } {
							#::CastSpell $hitter $player 5
						}
						break
					}
				}
			} else {
				unset ::Honor::Hits::${player}($hitter)
			}
		}
	}

	proc OnLogin { to from spellid } {
		set player_name [::GetName $to]
		set pn [string tolower $player_name]

		::Honor::ReadData $player_name
		lset ::Honor::HonorData($pn) 8 0
		::Honor::CheckLogin $to
		set ::Honor::LoginScriptEffect($to) [clock seconds]
	}

	# to be called when a player is being hit, in WoWEmu::DamageReduction
	variable CountHitsClean [clock seconds]
	proc CountHits { player mob } {
		set time [clock seconds]
		if { [info exists ::Honor::Hits::${player}($mob)] } {
			set ::Honor::Hits::${player}($mob) [list [expr {[lindex [set ::Honor::Hits::${player}($mob)] 0]+1}] $time]
		} else { set ::Honor::Hits::${player}($mob) [list 1 $time] }
	}

	# factor for consecutive kills on a player
	proc GetConsecutiveFactor { killer victim } {
		variable ConsecutiveFactor
		set time [clock seconds]
		if { [info exists ConsecutiveFactor($killer,$victim)] && $time-[lindex [set data $ConsecutiveFactor($killer,$victim)] 1] < 86400 } {
			set factor [expr {[lindex $data 0]-.25}]
			if { $factor < 0 } { set factor 0 }
		} else { set factor 1. }
		set ConsecutiveFactor($killer,$victim) [list $factor $time]
		return $factor
	}

	# gain calculation
	proc CalcGain { killer victim } {
		set killer_level [::GetLevel $killer]
		set victim_level [::GetLevel $victim]
		if { [::Custom::IsGreyLevel $victim_level $killer_level] } { return 0 }
		set killer_rank [GetRank $killer]
		set victim_rank [GetRank $victim]
		set lvldiff [expr {$victim_level-$killer_level}]
		set rankbonus [expr {$victim_rank-$killer_rank}]
		if { $rankbonus < 0 } { set rankbonus 0 }
		set points [expr {$victim_level*(1.+$lvldiff*.05+$rankbonus*.5)}]
		if { $points < 0 } { return 0 }
		expr {round($points)}
	}

	# ratings calculation, OnPlayerDeath / CalcXP
	proc CalcRatings { victim {killer 0} } {
		if { ![IsInAllowedPlace $victim] } { return }
		set time [clock seconds]

		if { [::GetObjectType $victim] == 4 } {
			# some cleaning
			if { $time - $::Honor::CountHitsClean > 240 } {
				foreach var [info vars ::Honor::Hits::*] {
					foreach { hitter hit } [array get $var] {
						if { $time - [lindex $hit 1] > 300 } {
							unset ${var}($hitter)
						}
					}
				}
				set ::Honor::CountHitsClean $time
			}

			if { $::Honor::PLAYER_RATE } { PlayerKilled $victim $killer }

			unset -nocomplain ::Honor::Hits::$victim

		} else {
			# some cleaning
			if { $time - $::Honor::CountAttackersClean > 240 } {
				foreach var [info vars ::Honor::Attacked::*] {
					foreach { v last_time } [array get $var] {
						if { $time - $last_time > 300 } {
							unset ${var}($v)
						}
					}
				}
				set ::Honor::CountAttackersClean $time
			}

			if { [IsLeader $victim] } {
				if { [CheckGM $killer] } { return }
				if { $::Honor::LEADER_RATE } { LeaderKilled $victim $killer }
			} elseif { [IsGuard $victim] } {
				if { [CheckGM $killer] } { return }
				if { $::Honor::GUARD_RATE } { GuardKilled $victim $killer }
			} elseif { [IsCivilian $victim] } {
				if { [CheckGM $killer] } { return }
				if { $::Honor::CIVILIAN_RATE } { CivilianKilled $victim $killer }
			}

			unset -nocomplain ::Honor::Attacked::$victim

		}
	}

	proc PlayerKilled { player {killer 0} } {
		# killing a player in ghost form?
		if { $::Honor::CHECK_GHOST && ![::Custom::PlayerIsAlive $player] && [::GetObjectType $killer] == 4 } {
			if { ![::CastSpell $killer $killer 7] } {
				#::CastSpell $player $killer 5
			}
			return
		}

		set msg ""

		if { $killer } { CountHits $player $killer }

		#set player_honor [GetRating $player]
		#set player_rank [GetRank $player]
		#set player_level [::GetLevel $player]

		set totalhits 0
		if { ![info exists ::Honor::Hits::$player] } { return }
		foreach { hitter hit } [array get ::Honor::Hits::$player] {
			set hitcount [lindex $hit 0]
			incr totalhits $hitcount

			if {
				[::GetObjectType $hitter] == 4 && [::Distance $player $hitter] <= 75 && [::Custom::PlayerIsAlive $hitter] &&
				[::Custom::GetPlayerSide $hitter] != [::Custom::GetPlayerSide $player] && ![CheckGM $hitter]
			} then {

				#set hitter_honor [GetRating $hitter]
				#set hitter_rank [GetRank $hitter]
				#set hitter_level [::GetLevel $hitter]

				set consecutive_factor [GetConsecutiveFactor $hitter $player]
				set balance_factor [GetBalanceFactor $hitter]
				set gain [CalcGain $hitter $player]
				set points [expr {$gain*$consecutive_factor*$balance_factor*$::Honor::PLAYER_RATE}]

				array set hits [list $hitter [expr {$hitcount*$points}]]
			}
		}

		if { [info exists hits] && [CheckGM $player] } {
			return
		}

		#unset ::Honor::Hits::$player
		set newpoints ""
		set totalpoints 0
		foreach { hitter data } [array get hits] {
			set points [expr {round(double($data)/$totalhits)}]
			if { $points > $::Honor::MAX_GAIN } { set points $::Honor::MAX_GAIN }
			if { $points } {
				incr totalpoints $points
				set hitter_name [::GetName $hitter]
				if { $hitter_name != "" } {
					append msg " ($hitter_name: ${points}[::Texts::Get points_suffix])"
					lappend newpoints [list $hitter $points]
				}
			}
		}
		array unset hits
		if { $totalpoints } {
			#append msg " (total: ${totalpoints}[::Texts::Get points_suffix])"
			set player_name [::GetName $player]

			ChatMessage $player "[::Custom::DyingScream]$msg"
			Notify $player "[::Texts::Get killed]$msg"
			foreach data [lsort -decreasing -integer -index 1 $newpoints] {
				set hitter [lindex $data 0]
				set points [lindex $data 1]
				set name $player_name
				Notify $hitter [::Texts::Get "kill" $name $points]
				ChangeRating $hitter $points 1 "kills $player_name"
			}

			ChangeRating $player 0 -2

			UpdateRankings
			#return $msg
		}
	}

	proc ChatMessage { player msg {force 0} } {
		if { $::Honor::ENABLE_SAYINGS || $force } { Say $player 0 $msg }
	}

	proc Notify { player msg } {
		variable Notify
		if { [info exists Notify($player)] && [llength $Notify($player)] > 20 } {
			set Notify($player) [list "(...)" [lrange $Notify($player) end-19 end]]
		}
		lappend Notify($player) $msg
	}

	proc NotifyRank { player msg } {
		variable NotifyRank
		set NotifyRank($player) $msg
	}

	# get a list of ranked player names (sorted by rating)
	variable RankedPlayerNames ""
	proc GetRankedPlayerNames {} {
		variable RankedPlayerNames
		variable HonorData
		if { $RankedPlayerNames == "" } {
			set table ""
			foreach name [glob -types f -nocomplain -tails -directory $::Honor::HONOR_DIR "*"] {
				ReadData $name
				set pn [string tolower $name]
				if { [lindex $HonorData($pn) 1] != 0 } {
					set rating [lindex $HonorData($pn) 0]
					lappend table [list $rating $name]
				}
			}
			foreach data [lsort -decreasing -integer -index 0 $table] {
				lappend RankedPlayerNames [lindex $data 1]
			}
		}
		return $RankedPlayerNames
	}

	# updated rankings (on the xml file)
	variable UpdateRankingsTime 0
	variable UpdateRankingsNeeded 0
	proc UpdateRankings { {force 0} } {
		set time [clock seconds]
		if { !$force } {
			if { $::Honor::RANKINGS_UPDATE < 0 } { return 0 }
			if { $time - $::Honor::UpdateRankingsTime < $::Honor::RANKINGS_UPDATE } {
				set ::Honor::UpdateRankingsNeeded 1
				return 0
			}
		}
		set ::Honor::UpdateRankingsTime $time
		set ::Honor::UpdateRankingsNeeded 0

		RecalcRatings

		variable SHOW_DEFEATS
		variable SHOW_TOTALS
		variable CIVILIAN_RATE
		variable RANKINGS_LIMIT

		set pos 0
		set limit $RANKINGS_LIMIT
		set names [GetRankedPlayerNames]

		set hxml [open "www/honor.xml" w]

		set header "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<?xml-stylesheet type=\"text/xsl\" href=\"honor.xsl\"?>\n<!-- [GetVersionInfo 0], page updated: [clock format [clock seconds]] -->\n<stats><players><count>[llength $names]</count>"
		if { $SHOW_DEFEATS } { append header "<defeats>1</defeats>" }
		#puts $hxml $header
		append output $header
		foreach name $names {
			incr pos
			foreach [lrange $::Honor::Columns 1 8] [lrange [ReadData $name] 0 7] {}
			if { $pos > $limit } { break }

			set line "<player><pos>$pos</pos><name>[string map {& {}} $name]</name><guild>$guild</guild><level>$level</level><race>$race</race><class>$class</class><kills>$hkills</kills>"
			if { $CIVILIAN_RATE } { append line "<dkills>$dkills</dkills>" }
			if { $SHOW_DEFEATS } { append line "<defeats>$defeats</defeats>" }
			append line "<honor>$rating</honor></player>"
			#puts $hxml $line
			append output "\n" $line
		}
		set footer "</players>"
		if { $SHOW_TOTALS } {
			set totals [GetTotals]
			set total_alliance [lindex $totals 0]
			set total_horde [lindex $totals 1]
			append footer "<total><horde>$total_horde</horde><alliance>$total_alliance</alliance></total>"
		}
		append footer "</stats>"
		#puts $hxml $footer
		append output "\n" $footer
		puts $hxml $output
		close $hxml
		return 1
	}

	# honor decay recalculation / online players check (for addon state updates)
	variable RecalcRatingsTime 0
	variable CheckOnlineTime 0
	proc RecalcRatings {} {
		set time [clock seconds]

		variable RecalcRatingsTime
		if { $time - $RecalcRatingsTime < 86400 } { return }
		set RecalcRatingsTime $time
		variable DECAY_RATE

		foreach player_name [GetRankedPlayerNames] {
			set decay [expr {($time-[GetActivityByName $player_name])/86400.}]
			if { $decay > 1 } {
				set player_honor [GetRatingByName $player_name]
				if { $player_honor > 0 } {
					set points [expr {round($player_honor*$decay*$DECAY_RATE/100.)}]
					if { $points > 0 } {
						ChangeRatingByName $player_name -$points 0 "decay"
					}
				}
			}
		}
	}

	# clear cached data
	proc ClearCache {} {
		variable RankedPlayerNames ""
		variable HonorData
		variable PlayerStandings
		array unset HonorData
		array unset PlayerStandings
	}

	# clear names
	proc ClearNames {} {
		variable RankedPlayerNames ""
		variable PlayerStandings
		array unset PlayerStandings
	}

	proc WrongCommand { player cargs } {
		return [::Texts::Get "wrong_command"]
	}

	# duplicate detection
	if { [info procs "Commands"] != "" } { Custom::Error "Duplicated loading detected" }

	# ".honor" command
	proc Commands { player cargs } {
		if { $::Honor::UpdateRankingsNeeded } { UpdateRankings }
		if { $cargs == "" } {
			CheckAddOnVersion $player
			return "[GetStandingInfoByName [::GetName $player] 1]"
		} else {
			set gm_plevel 4
			set admin_plevel 6
			switch -- [lindex $cargs 0] {
				"_notify" {
					set msg [GetNotification $player]
					if { $msg != "" } { return "HONOR_NOTIFY,[string map "{,} {\\,}" $msg]" }
				}
				"_rank" {
					if { [::GetObjectType [set selection [::GetSelection $player]]] == 4 } {
						return "PVPRANK,[GetUIRankByName [set player_name [::GetName $selection]]],$player_name"
					}
				}
				"_frame" {
					if { $::Honor::ENFORCE_ADDON } { CheckOldAddon }

					if { [llength $cargs] > 1 } {
						# inspect frame
						if { [::GetObjectType [set selection [::GetSelection $player]]] == 4 } {
							set msg "HONOR_INSPECT,[GetUIHonorData [set player_name [::GetName $selection]]],$player_name"
						}
					} else {
						# honor frame
						set msg [GetNotification $player]
						if { $msg != "" } { return "HONOR_NOTIFY,[string map "{,} {\\,}" $msg]" }

						set player_name [::GetName $player]
						set msg "HONOR_UPDATE,[GetUIHonorData $player_name]"
						#set msg "HONOR_UPDATE,"
						#set ver [GetAddOnVersion $player]
						#if { $ver >= 1 || !$ver } { append msg [GetUIHonorData $player_name]
						#} else { append msg [GetUIHonorDataOld $player_name] }
					}
					return $msg
				}
				"_login" {
					if { $::Honor::ENFORCE_ADDON } { CheckOldAddon }

					SetLocale $player [lindex $cargs 2]
					set secure [lindex $cargs 3]

					if { [string tolower $secure] == "insecure" } {
						SetAddOnVersion $player [lindex $cargs 1]
						SetSecure $player 0

						set ::Honor::LoginScriptEffect($player) 0
						set msg [::Texts::Get "addon_insecure" "SpiritHonor"]
						return "HONOR_NOTIFY,[string map "{,} {\\,}" $msg]"
					}

					if { ![info exists ::Honor::LoginScriptEffect($player)] } { return }
					if { [clock seconds] - $::Honor::LoginScriptEffect($player) > 60 } { return }

					unset ::Honor::LoginScriptEffect($player)
					set player_name [::GetName $player]
					SetAddOnVersion $player [lindex $cargs 1]
					SetSecure $player 1

					if { ![CheckAddOnVersion $player 0] } {
						variable ADDON_VERSION
						set ver [GetAddOnVersion $player]
						set ::Honor::LoginScriptEffect($player) 0

						if { $ver > 0 } {
							set msg [::Texts::Get "addon_error" "SpiritHonor v$ADDON_VERSION" "v$ver"]
							return "HONOR_NOTIFY,[string map "{,} {\\,}" $msg]"
						} else {
							ChatMessage $player [::Texts::Get "say_addon_error" "SpiritHonor v$ADDON_VERSION"] 1
						}
					}

					return "HONOR_UPDATE,[GetUIHonorData $player_name]"
				}
				"defense" {
					return [::Defense::Request $player]
				}
				"rankings" {
					set start [lindex $cargs 1]
					if { [string tolower $start] == "update" } {
						if { [::GetPlevel $player] < $gm_plevel } { return [::Texts::Get "not_allowed_command"] }
						if { [UpdateRankings 1] } {
							return [::Texts::Get "rankings_updated"]
						 }
					}
					set end [lindex $cargs 2]
					set msg [GetRankings $start $end]
					#SendGossipComplete $player
					#SendSwitchGossip $player $player 0
					#SendGossip $player [::GetSelection $player] "text 0 \"$msg\""
					return $msg
				}
				"info" {
					if { [llength $cargs] < 2 } {
						set selection [::GetSelection $player]
						if { !$selection } { set selection $player }
						if { [::GetObjectType $selection] != 4 } { return [::Texts::Get "missing_player"] }
						set player_name [::GetName $selection]
					} else { set player_name [lindex $cargs 1] }
					return "[GetStandingInfoByName $player_name]"
				}
				"change" {
					if { [::GetPlevel $player] < $gm_plevel } { return [::Texts::Get "not_allowed_command"] }
					if { [llength $cargs] < 2 } { return [::Texts::Get "missing_points"] }
					if { [llength $cargs] < 3 } {
						set selection [::GetSelection $player]
						if { !$selection } { set selection $player }
						if { [::GetObjectType $selection] != 4 } { return [::Texts::Get "missing_player"] }
						set player_name [::GetName $selection]
					} else {
						set selection 0
						set player_name [lindex $cargs 2]
					}
					set points [lindex $cargs 1]
					if { ![string is integer -strict $points] } {
						return [::Texts::Get "incorrect_points"]
					}
					set giver_name [::GetName $player]
					if { $selection } {
						ChatMessage $selection [::Texts::Get "say_give_player" $giver_name $points]
						Notify $selection [::Texts::Get "give_player" $giver_name $points]
						ChangeRating $selection $points 0 "changed by $giver_name"
					} else { ChangeRatingByName $player_name $points 0 "changed by $giver_name" }
					if { $points } { UpdateRankings 1 }
					set msg [::Texts::Get "change_rating" $player_name [GetRatingByName $player_name]]
					set notify [GetNotification $player]
					if { $notify != "" && !$::Honor::ENABLE_SAYINGS } { set msg "HONOR_NOTIFY,[string map "{,} {\\,}" $notify]" }
					return $msg
				}
				"del" {
					if { [::GetPlevel $player] < $gm_plevel } { return [::Texts::Get "not_allowed_command"] }
					if { [llength $cargs] < 2 } {
						set selection [::GetSelection $player]
						if { !$selection } { set selection $player }
						if { [::GetObjectType $selection] != 4 } { return [::Texts::Get "missing_player"] }
						set player_name [::GetName $selection]
					} else { set player_name [lindex $cargs 1] }
					set ver [GetAddOnVersion $player]
					if { $player_name == "*" } {
						DeleteAllPlayers
						return [::Texts::Get "all_rankings_deleted"]
					} else {
						if { [DeletePlayer $player_name] } {
							SetAddOnVersion $player $ver
							return [::Texts::Get "ranking_deleted" $player_name]
						} else {
							return [::Texts::Get "player_not_ranked" $player_name]
						}
					}
				}
				"reload" {
					if { [::GetPlevel $player] < $gm_plevel } { return [::Texts::Get "not_allowed_command"] }
					if { !$::Honor::USE_CONF } { return [::Texts::Get "no_config"] }
					if { ![::Custom::LoadConf "*"] } { return [::Texts::Get "config_error"] }
					ClearCache
					UpdateRankings 1
					return [::Texts::Get "config_reloaded"]
				}
				"check" {
					return [CheckPlayers $player]
				}
				"sql" {
					if { [::GetPlevel $player] < $gm_plevel } { return [::Texts::Get "not_allowed_command"] }
					set ret ""
					if { [UsingSQLdb] } {
						variable nghandle
						switch -- [lindex $cargs 1] {
							"import" {
								if { [string tolower [lindex $cargs 2]] == "replace" } { set replace 1 } { set replace 0 }
								set ret [::Texts::Get "imported_players" [SQLdb_Import $replace]]
							}
							"export" {
								if { [string tolower [lindex $cargs 2]] == "replace" } { set replace 1 } { set replace 0 }
								set ret [::Texts::Get "exported_players" [SQLdb_Export $replace]]
							}
							"check" {
								if { ![::SQLdb::existsSQLdb $nghandle `honor`] } {
									set ret [::Texts::Get "table_not_exists"]
								} else {
									set condition [SQLdb_ColumnsCondition]
									if { $condition < 0 } {
										set ret [::Texts::Get "table_critical"]
									} elseif { $condition > 0 } {
										set ret [::Texts::Get "table_error"]
									} else {
										set ret [::Texts::Get "table_ok"]
									}
								}
							}
							"repair" {
								if { [SQLdb_CreateTable] } {
									set ret [::Texts::Get "imported_players" [SQLdb_Import $replace]]
								} else {
									set condition [SQLdb_ColumnsCondition]
									if { $condition < 0 } {
										set ret [::Texts::Get "table_critical"]
									} elseif { $condition > 0 } {
										if { [SQLdb_RepairTable] } {
											set ret [::Texts::Get "table_repaired"]
										} else {
											# should never happen if SQLdb_ColumnsCondition works
											set ret [::Texts::Get "table_critical"]
										}
									} else {
										set ret [::Texts::Get "table_ok"]
									}
								}
							}
							"cleanup" {
								::SQLdb::cleanupSQLdb $nghandle
								set ret [::Texts::Get "cleanup_done"]
							}
							"reset" {
								if { [SQLdb_ResetTable] } {
									set ret [::Texts::Get "table_reset"]
								} else {
									set ret [::Texts::Get "table_not_exists"]
								}
							}
							"query" {
								if { [::GetPlevel $player] < $admin_plevel } { return [::Texts::Get "not_allowed_command"] }
								set sql [lrange $cargs 2 end]
								if { [catch { set ret [join [::SQLdb::querySQLdb $nghandle $sql] "\n"] } err] } {
									set ret $err
								} elseif { [string match -nocase "*honor*" $sql] } {
									switch -- [string tolower [lindex $sql 0]] {
										"delete" { ClearNames; UpdateRankings 1 }
										"insert" -
										"replace" -
										"update" { ClearCache; UpdateRankings 1 }
									}
								}
							}
							default {
								set ret "honor sql: import (replace), export (replace), check, repair, cleanup, reset, query <sql_cmd>"
							}
						}
					} else {
						set ret [::Texts::Get "not_using_sqldb"]
					}
					return $ret
				}
				"clean" {
					if { [::GetPlevel $player] < $gm_plevel } { return [::Texts::Get "not_allowed_command"] }
					if { [::Custom::GetScriptVersion "StartTCL"] < "0.9.5" } {
						return [::Texts::Get "starttcl_required"]
					}

					return [::Texts::Get "cleaned_players" [Clean]]
				}
				"version" {
					return [GetVersionInfo [expr {[::GetPlevel $player]<$gm_plevel?0:1}]]
				}
				default {
					## help
					set start [::Texts::Get "help_start"]
					set end [::Texts::Get "help_end"]
					set name [::Texts::Get "help_name"]
					set sel [::Texts::Get "help_selection"]
					set pts [::Texts::Get "help_points"]
					if { [::GetPlevel $player] < 6 } { return "honor: rankings <$start> <$end>, info <$name/$sel>, version" }
					set help "honor: rankings <$start> <$end>, info <$name/$sel>, del <$name/$sel/*>, change <(+-)$pts> <$name/$sel>, clean, reload, version, sql"
					return $help
				}
			}
		}
	}

	# .honor clean
	proc Clean { {player 0} {cargs ""} } {

		set count 0

		if { [UsingSQLdb] } {
			variable nghandle

			foreach row [::SQLdb::querySQLdb $nghandle "SELECT * FROM `honor`"] {
				set name [lindex $row 1]

				if { [::Custom::GetPlayerID $name] } {
					continue
				}

				::SQLdb::querySQLdb $nghandle "DELETE FROM `honor` WHERE (`name` = '[::SQLdb::canonizeSQLdb $name]')"
				incr count
			}

			::SQLdb::cleanupSQLdb $nghandle
		} else {
			variable HONOR_DIR

			foreach name [glob -types f -nocomplain -tails -directory $HONOR_DIR "*"] {
				if { [::Custom::GetPlayerID $name] } {
					continue
				}

				file delete "$HONOR_DIR/$name"
				incr count
			}
		}

		return $count
	}

	proc CheckOldAddon {} {
		set time [clock seconds]

		foreach { p t } [array get ::Honor::LoginScriptEffect] {
			if { [::GetObjectType $p] != 4 } {
				unset ::Honor::LoginScriptEffect($p)
				continue
			}

			if { $time - $t > 30 } {
				if { $::Honor::ENFORCE_ADDON > 1 } {
					if { [GetSecure $p] } {
						 [::Texts::Get "addon_error" "SpiritHonor v$::Honor::ADDON_VERSION" "v[::Honor::GetAddOnVersion $p]"] "Honor System"
					} else {
						 [::Texts::Get "addon_insecure" "SpiritHonor"] "Honor System"
					}
				} 
			}
		}
	}

	proc JailPlayer { player {jail_time 3600} {reason ""} {by ""} } {
		if { [::Custom::GetScriptVersion "ngjail"] >= "0.1.0" } {
			::ngjail::Jail $player $jail_time $reason $by
		} elseif { [::Custom::GetScriptVersion "ngJail"] >= "0.1.0" } {
			::ngJail::Jail $player $jail_time $reason $by
		} elseif { [::Custom::GetScriptVersion "zJail"] >= "1.5.0" } {
			::zJail::JailPlayer $player $jail_time $reason $by
		} elseif { [::Custom::GetScriptVersion "zJail"] >= "1.4.0" } {
			::zJail::JailPlayer $player [expr {$jail_time/60}] $reason
		} elseif { [info procs "::gotisch::jail"] != "" } {
			::gotisch::jail $player $jail_time
		} else {
			::Teleport $player 13 0 0 0
			::Custom::Error "No known jail system available."
		}
	}

	proc GetVersionInfo { {full 1} } {
		return "Honor System v$::Honor::VERSION by Spirit, using [expr { $::Honor::UsingSQLdb ? [SQLdb_VersionInfo] : [expr { $full ? "directory \"$::Honor::HONOR_DIR\"" : "honor directory" }] }]"
	}

	proc DeleteAllPlayers {} {
		foreach file [glob -types f -nocomplain "${Honor::HONOR_DIR}/*"] { file delete $file }
		ClearCache
		UpdateRankings 1
	}

	proc DeletePlayer { player_name } {
		set player_file "${Honor::HONOR_DIR}/$player_name"
		if { [file exists $player_file] } {
			file delete $player_file
			set pn [string tolower $player_name]
			array unset ::Honor::HonorData $pn
			ClearNames
			UpdateRankings 1
			return 1
		}
		return 0
	}

	# for the UI, first rank is rank 5
	proc GetUIRankByName { player_name } {
		set rank [GetRankByName $player_name]
		if { $rank } { incr rank 4 }
		return $rank
	}

	# get all honor data from a player's name
	proc GetHonorData { player_name } {
		if { $player_name == "" } { return }
		variable HonorData
		set pn [string tolower $player_name]
		ReadData $player_name
		set sessionHK ""; set sessionDK ""
		set yesterdayHK ""; set yesterdayHonor ""
		set thisweekHK ""; set thisweekHonor ""
		set lastweekHK ""; set lastweekHonor ""; set lastweekStanding [GetStandingNameByName $player_name]
		set lifetimeHK [lindex $HonorData($pn) 5]
		set lifetimeDK [lindex $HonorData($pn) 6]
		set lifetimeRank [lindex $HonorData($pn) 0]
		return [list $sessionHK $sessionDK $yesterdayHK $yesterdayHonor $thisweekHK $thisweekHonor $lastweekHK $lastweekHonor $lastweekStanding $lifetimeHK $lifetimeDK $lifetimeRank]
	}

	# data sent to UI
	proc GetUIHonorData { player_name } {
		return "[join [GetHonorData $player_name] {,}],[GetUIRankByName $player_name],[GetRankProgressByName $player_name]"
	}

	# data sent to UI (for addon before v1.0)
	proc GetUIHonorDataOld { player_name } {
		return "[GetRankByName $player_name],[GetRatingByName $player_name],[GetHonorableKillsByName $player_name],[GetDishonorableKillsByName $player_name],,,,,,,,,[GetStandingNameByName $player_name],[GetRankProgressByName $player_name]"
	}

	proc CheckAddOnVersion { player {say 1} } {
		variable ADDON_VERSION
		if { !$ADDON_VERSION || [GetAddOnVersion $player] >= $ADDON_VERSION } {
			return 1
		}
		ChatMessage $player [::Texts::Get "say_addon_error" "SpiritHonor v$ADDON_VERSION"] $say
		return 0
	}

	# get a player's notification text
	proc GetNotification { player } {
		variable Notify
		variable NotifyRank
		set msg ""
		if { [info exists Notify($player)] } {
			append msg [join $Notify($player) "\n"]
			unset Notify($player)
		}
		if { [info exists NotifyRank($player)] } {
			append msg " " $NotifyRank($player)
			unset NotifyRank($player)
		}
		return $msg
	}

	# get rankings (to be used in the chat frame)
	proc GetRankings { {start 0} {end 0} } {
		if { ![string is integer -strict $start] || !$start } { set start 1 }
		if { ![string is integer -strict $end] || !$end } { set end [expr $start+29] }
		set names [GetRankedPlayerNames]
		set total [llength $names]
		if { $start > $total } { set start $total }
		if { $end > $total } { set end $total }

		set ret "[::Texts::Get rankings] ($start-$end):\n"

		set pos 0
		foreach name $names {
			incr pos
			if { $pos >= $start } {
				set honor [GetRatingByName $name]
				append ret "$pos) $name: ${honor}\n"
			}
			if { $pos >= $end } { break }
		}

		return $ret
	}

	# get ordinal prefix (if any)
	proc GetOrdinalPrefix { {standing 0} } {
		set pref [::Texts::Get "ordinal_prefixes"]
		if { $standing > [llength $pref] } { return [lindex $pref end] }
		lindex $pref [expr {$standing-1}]
	}

	# get ordinal suffix
	proc GetOrdinalSuffix { {standing 0} } {
		set suff [::Texts::Get "ordinal_suffixes"]
		if { $standing > [llength $suff] } { return [lindex $suff end] }
		lindex $suff [expr {$standing-1}]
	}

	# get standing name
	proc GetStandingName { player } { GetStandingNameByName [::GetName $player] }

	# get standing name from player name
	proc GetStandingNameByName { player_name } {
		set standing [GetStandingByName $player_name]
		if { $standing } { set standing [GetOrdinalPrefix $standing]$standing[GetOrdinalSuffix $standing] }
		if { $standing != "" } { append standing " / [llength [GetRankedPlayerNames]]" }
		return $standing
	}

	proc GetStanding { player } { GetStandingByName [::GetName $player] }

	# get a player's standing from his name
	proc GetStandingByName { player_name } {
		variable PlayerStandings
		if { [info exists PlayerStandings($player_name)] } { return $PlayerStandings($player_name) }
		set pos 0
		set player_pos 0
		foreach name [GetRankedPlayerNames] {
			incr pos
			if { [string match -nocase $name $player_name] } { set player_pos $pos; break }
		}
		set PlayerStandings($player_name) $player_pos
	}

	# get a player's standing information from his name
	proc GetStandingInfoByName { player_name {self 0} } {
		set player_pos [GetStandingByName $player_name]
		set rating [GetRatingByName $player_name]
		if { $player_pos && $rating } {
			set rank_name [GetRankNameByName $player_name]
			set pos_name [GetOrdinalPrefix $player_pos]$player_pos[GetOrdinalSuffix $player_pos]
			if { $self } { append ret [::Texts::Get "your_rank" $rank_name $rating $pos_name]
			} else { append ret [::Texts::Get "player_rank" $player_name $rank_name $rating $pos_name] }
		} else {
			if { $self } { set ret [::Texts::Get "no_rank"]
			} else { set ret [::Texts::Get "player_no_rank" $player_name] }
		}
	}

	# get rating totals
	variable GetTotalsTime 0
	proc GetTotals { {from_cache 0} } {
		variable GetTotals
		variable GetTotalsTime
		set time [clock seconds]
		if { $time - $GetTotalsTime > 3600 || !$from_cache } {
			set GetTotalsTime $time
			set total_alliance 0
			set total_horde 0
			foreach name [GetRankedPlayerNames] {
				set player_data [ReadData $name]
				set player_honor [lindex $player_data 0]
				set player_race [lindex $player_data 1]
				if { [::Custom::GetPlayerSideByRace $player_race] == 0 } { incr total_alliance $player_honor
				} else { incr total_horde $player_honor }
			}
			set GetTotals [list $total_alliance $total_horde]
		}
		return $GetTotals
	}

	# get balance factor based on current ratings
	proc GetBalanceFactor { player } {
		if { !$::Honor::ENABLE_BALANCING } { return 1. }
		set max_factor 1.5
		set min_factor [expr {1./$max_factor}]
		set total [GetTotals 1]
		set factor [expr {([lindex $total 0]+1.)/([lindex $total 1]+1.)}]
		if { [::Custom::GetPlayerSide $player] == 0 } { set factor [expr {1./$factor}] }
		if { $factor > $max_factor } { return $max_factor }
		if { $factor < $min_factor } { return $min_factor }
		return $factor
	}

	# count attackers, to be used in AI::CanUnAgro
	variable CountAttackersClean [clock seconds]
	proc CountAttackers { npc victim } {
		set ::Honor::Attacked::${npc}($victim) [clock seconds]
	}

	# when an enemy guard gets killed
	proc GuardKilled { victim killer } {
		set npcside [::Custom::GetNpcSide $victim]
		set hitters ""
		set npchittercount 0

		#if { ![info exists ::Honor::Attacked::$victim] } { return }
		foreach hitter [array names ::Honor::Attacked::$victim] {
			set ot [::GetObjectType $hitter]
			if {
				$ot == 4 && [::Distance $victim $hitter] <= 75 && $npcside == ![::Custom::GetPlayerSide $hitter] &&
				[::Custom::PlayerIsAlive $hitter] && ![CheckGM $hitter]
			} then {
				lappend hitters $hitter
			} elseif { $ot == 3 } {
				incr npchittercount
			}
		}
		#unset ::Honor::Attacked::$victim

		set totalhitters [llength $hitters]
		if { $totalhitters } {

			set victim_level [::GetLevel $victim]
			set elite [::Custom::GetElite $victim]
			if { $elite == 0 || $elite == 4 } { set elite_factor 1 } else { set elite_factor [expr {$elite+1}] }
			set totalpoints [expr {$elite_factor*$victim_level*[GetBalanceFactor [lindex $hitters 0]]*$::Honor::GUARD_RATE}]

			set points [expr {round(double($totalpoints)/($totalhitters+$npchittercount))}]

			if { $points } {
				set msg ""
				set newpoints ""
				foreach hitter $hitters {
					set hitter_name [::GetName $hitter]
					if { $hitter_name != "" && ![::Custom::IsTrivial $victim $hitter] } {
						set hitter_level [::GetLevel $hitter]
						set lvldiff [expr {$victim_level-$hitter_level}]
						set hitter_points [expr {round($points+$points*$lvldiff*.05)}]
						if { $hitter_points > $::Honor::MAX_GAIN } { set hitter_points $::Honor::MAX_GAIN }
						if { $hitter_points > 0 } {
							append msg " ($hitter_name: ${hitter_points}[::Texts::Get points_suffix])"
							lappend newpoints [list $hitter $hitter_points]
						}
					}
				}
				ChatMessage $victim "[::Custom::DyingScream] $msg"
				foreach data [lsort -decreasing -integer -index 1 $newpoints] {
					set hitter [lindex $data 0]
					set points [lindex $data 1]
					set name [::Custom::GetNpcName $victim]
					Notify $hitter [::Texts::Get "kill" $name $points]
					if { $elite_factor > 1 } { set comment "kills the elite guard $name" } else { set comment "kills the guard $name" }
					ChangeRating $hitter $points 1 $comment
				}
				UpdateRankings
				#return $msg
			}
		}
	}

	# when a racial leader is killed
	proc LeaderKilled { victim killer } {
		set npcside [::Custom::GetNpcSide $victim]
		set hitters ""
		set npchittercount 0

		#if { ![info exists ::Honor::Attacked::$victim] } { return }
		foreach hitter [array names ::Honor::Attacked::$victim] {
			set ot [::GetObjectType $hitter]
			if {
				$ot == 4 && [::Distance $victim $hitter] <= 75 && $npcside == ![::Custom::GetPlayerSide $hitter] &&
				[::Custom::PlayerIsAlive $hitter] && ![CheckGM $hitter]
			} then {
				lappend hitters $hitter
			} elseif { $ot == 3 } {
				incr npchittercount
			}
		}
		#unset ::Honor::Attacked::$victim

		set totalhitters [llength $hitters]
		if { $totalhitters } {

			set victim_level [::GetLevel $victim]
			set totalpoints [expr {1000.*[GetBalanceFactor [lindex $hitters 0]]*$::Honor::LEADER_RATE}]

			set points [expr {round(double($totalpoints)/($totalhitters+$npchittercount))}]

			if { $points } {
				set msg ""
				set newpoints ""
				foreach hitter $hitters {
					set hitter_name [::GetName $hitter]
					if { $hitter_name != "" } {
						set hitter_level [::GetLevel $hitter]
						set lvldiff [expr {$victim_level-$hitter_level}]
						set hitter_points [expr {round($points+$points*$lvldiff*.05)}]
						if { $hitter_points > $::Honor::MAX_GAIN } { set hitter_points $::Honor::MAX_GAIN }
						if { $hitter_points > 0 } {
							append msg " ($hitter_name: ${hitter_points}[::Texts::Get points_suffix])"
							lappend newpoints [list $hitter $hitter_points]
						}
					}
				}
				ChatMessage $victim "[::Custom::DyingScream] $msg"
				foreach data [lsort -decreasing -integer -index 1 $newpoints] {
					set hitter [lindex $data 0]
					set points [lindex $data 1]
					set name [::Custom::GetNpcName $victim]
					Notify $hitter [::Texts::Get "kill" $name $points]
					ChangeRating $hitter $points 1 "kills the leader $name"
				}
				UpdateRankings
				#return $msg
			}
		}
	}

	# dishonorable kill on a civilian
	proc CivilianKilled { victim killer } {
		if { ![::Custom::IsTrivial $victim $killer] } { return }
		variable CIVILIAN_RATE
		set killer_level [::GetLevel $killer]
		set victim_level [::GetLevel $victim]
		set lvldiff [expr {$killer_level-$victim_level}]
		set points [expr {round($CIVILIAN_RATE*abs($killer_level*.5+$lvldiff)/[GetBalanceFactor $killer])}]
		if { $points > $::Honor::MAX_GAIN } { set points $::Honor::MAX_GAIN }

		ChatMessage $killer [::Texts::Get "say_civilian_killed" $points]
		Notify $killer [::Texts::Get "civilian_killed" $points]
		ChangeRating $killer -$points -1 "kills the civilian [::Custom::GetNpcName $victim]"
		UpdateRankings
	}


	# check whether an NPC is a cilivian
	proc IsCivilianByEntry { entry } {
		if { ![info exists ::Honor::IsCivilian($entry)] } {
			if { [::Honor::IsGuard $npc] || [::Honor::IsLeader $npc] } {
				set ::Honor::IsCivilian($entry) 0
			} else {
				set npcside [::Custom::GetNpcSide $npc]
				if { $npcside < 0 } {
					set ::Honor::IsCivilian($entry) 0
				} else {
					set npcflags [::GetNpcflags $npc]
					if { ($npcflags & 2) || ($npcflags & 4) || [::Custom::GetCivilian $npc] } {
						set ::Honor::IsCivilian($entry) 1
					} else {
						set ::Honor::IsCivilian($entry) 0
					}
				}
			}
		}
		set ::Honor::IsCivilian($entry)
	}

	eval "proc IsCivilian \{ npc \} \{
		set entry \[::GetEntry \$npc\]
		[info body IsCivilianByEntry]
	\}"


	# check whether an NPC is a racial leader
	proc IsLeaderByEntry { entry } {
		variable LeadersArray
		info exists ::Honor::LeadersArray($entry)
	}

	eval "proc IsLeader \{ npc \} \{
		set entry \[::GetEntry \$npc\]
		[info body IsLeaderByEntry]
	\}"


	# check whether an NPC is a guard
	proc IsGuardByEntry { entry } {
		info exists ::Honor::GuardsArray($entry)
	}

	proc IsGuard { npc } {
		expr {[IsGuardByEntry [::GetEntry $npc]] && [::GetObjectType $npc] == 3}
	}


	# ($flags1 & 0x400000) && ($flags1 & 0x80000)
	# [string match "*048000*" $flags1]
	variable GuardsList {68 197 234 261 464 487 489 490 727 821 823 851 853 869 870 874 876 1064 1089 1090\
		1340 1423 1475 1495 1496 1519 1560 1642 1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746\
		1747 1756 1777 1976 2041 2092 2386 2405 2439 2621 3296 3501 3571 3836 4262 4624 4921 4944 4995 5091 5595 5624 5725\
		6086 6087 6237 6241 6766 6785 7295 7489 7865 7939 7980 8015 8016 9095 10037 11194 12160 12423 12427 12428\
		12480 12481 12580 13839 14714 14717}
	variable NonGuardsList {1949 3150}
	variable NeutralFactions {474 475 854 855 69 637 120 121}
	proc IsGuardEval { entry } {
		if { ![info exists ::Honor::IsGuard($entry)] } {
			if { [lsearch $::Honor::GuardsList $entry] >= 0 } {
				set ::Honor::IsGuard($entry) 1
			} elseif { [lsearch $::Honor::NonGuardsList $entry] >= 0} {
				set ::Honor::IsGuard($entry) 0
			} else {
				set faction [::Custom::GetCreatureScp $entry "faction"]
				set side [::Custom::GetNpcSideByFaction $faction]
				set npcflags [::Custom::GetCreatureScp $entry "npcflags"]
				set flags1 [::Custom::GetCreatureScp $entry "flags1"]
				set elite [::Custom::GetCreatureScp $entry "elite"]
				set civilian [::Custom::GetCreatureScp $entry "civilian"]
				if { $side < 0 } {
					if { [lsearch $::Honor::NeutralFactions $faction] < 0 } {
						set ::Honor::IsGuard($entry) 0
					} elseif {
						($npcflags & 4) || ($npcflags & 8) || ($npcflags & 32) || ($npcflags & 64) ||
						($npcflags & 128) || ($npcflags & 256) || ($npcflags & 512) || ($npcflags >= 1024)
					} then {
						set ::Honor::IsGuard($entry) 0
					} elseif { (($flags1 & 0x400000) || ($flags1 & 0x10000000)) && ($flags1 & 0x80000) && ($elite || !$civilian) } {
						set ::Honor::IsGuard($entry) 2
					} else {
						set ::Honor::IsGuard($entry) 0
					}
				} else {
					if {
						($npcflags & 4) || ($npcflags & 8) || ($npcflags & 32) || ($npcflags & 64) ||
						($npcflags & 128) || ($npcflags & 256) || ($npcflags & 512) || ($npcflags >= 1024)
					} then {
						set ::Honor::IsGuard($entry) 0
					} elseif { (($flags1 & 0x400000) || ($flags1 & 0x10000000)) && ($flags1 & 0x80000) && ($elite || !$civilian) } {
						set ::Honor::IsGuard($entry) 1
					} else {
						set ::Honor::IsGuard($entry) 0
					}
				}
			}
		}
		set ::Honor::IsGuard($entry)
	}


	##
	## Honor reward NPC
	##

	proc QuestHello { npc player } { GossipHello $npc $player }

	proc GossipHello { npc player } {
		set option0 "text 6 \"[::Texts::Get browse_goods]\""
		set option1 "text 0 \"[::Texts::Get ranking_info]\""
		set option2 "text 0 \"[::Texts::Get honor_howto]\""
		::SendGossip $player $npc $option0 $option1 $option2
		::Emote $npc 66
		::Emote $player 66
	}

	proc GossipSelect { npc player option } {

		set honor [::Honor::GetRating $player]
		set rank [::Honor::GetRank $player]
		set reqrank [::GetScpValue "creatures.scp" "creature [::GetEntry $npc]" "pvprank"]
		if { ![string is integer -strict $reqrank] } { set reqrank 14 }

		switch -- $option {
			0 {
				if { $rank >= $reqrank } {
					::VendorList $player $npc
				} else {
					set reqrankname [GetRankNameByRankSide $reqrank [::Custom::GetPlayerSide $player]]
					::SendGossip $player $npc "text 6 \"[::Texts::Get cant_buy $reqrankname]\""
				}
			}
			1 {
				if { $rank } { set msg [GetStandingInfoByName [::GetName $player] 1]
				} else { set msg [::Texts::Get "no_rank"] }
				::SendGossip $player $npc "text 0 \"$msg\""
			}
			2 {
				::SendGossip $player $npc "text 0 \"[::Texts::Get how_to_text]\""
			}
		}
	}
	proc QuestStatus { npc player } {
		set rank [::Honor::GetRank $player]
		set reqrank [::GetScpValue "creatures.scp" "creature [::GetEntry $npc]" "pvprank"]
		if { ![string is integer -strict $reqrank] } { set reqrank 14 }
		if { $rank >= $reqrank } { return 7 }
		return 0
	}

	# honor hall
	proc AreaTrigger { player id } {
		set plevel [::GetPlevel $player]
		set side [::Custom::GetPlayerSide $player]
		set honor [GetRating $player]
		set reqhonor [GetRatingByRank $::Honor::HONOR_HALL_RANK]
		switch -- $id {
			2527 {
				if { $plevel < 4 } {
					if { $side == 0 } {
						Say $player 0 [::Texts::Get "horde_hall"]
						return
					}
					if { $honor < $reqhonor } {
						Say $player 0 [::Texts::Get "cant_enter_hall"]
						return
					}
				}
				Teleport $player 450 221.535934 74.621155 25.720871
			}
			2530 { Teleport $player 1 1633.215820 -4249.346680 54.750847 }
			2532 {
				if { $plevel < 4 } {
					if { $side == 1 } {
						Say $player 0 [::Texts::Get "alliance_hall"]
						return
					}
					if { $honor < $reqhonor } {
						Say $player 0 [::Texts::Get "cant_enter_hall"]
						return
					}
				}
				Teleport $player 449 -0.493064 2.411076 -0.255885
			}
			2534 { Teleport $player 0 -8762.479492 401.799652 103.920998 }
		}
	}


	# obsolete procs
	proc IsRacialLeader { args } { WrongInstall $args "IsRacialLeader" }
	proc HitCount { args } { WrongInstall $args "HitCount" }
	proc WrongInstall { args {proc_name ""} } {
		set msg "Obsolete procedure \"$proc_name\" called!"
		::Custom::Error $msg
		set obj [lindex $args 0]
		if { [::GetObjectType $obj] } { ::Say $obj 0 $msg }
		return 0
	}

	# compatibility with old versions
	proc RegisterDefense { npc {player 0} } { ::Defense::Register $npc }
}


# compatibility stuff
namespace eval ::HonorNPC {
	proc QuestHello { npc player } { ::Honor::QuestHello $npc $player }
	proc GossipHello { npc player } { ::Honor::GossipHello $npc $player }
	proc GossipSelect { npc player option } { ::Honor::GossipSelect $npc $player $option }
	proc QuestStatus { npc player } { ::Honor::QuestStatus $npc $player }
}
namespace eval ::HonorHall {
	proc AreaTrigger { player id } { ::Honor::AreaTrigger $player $id }
}



# support for SQLdb
namespace eval ::Honor {

	variable ColumnsList "`[join $Columns {`, `}]`"

	variable UsingSQLdb 0
	proc UsingSQLdb {} { return $::Honor::UsingSQLdb }


	proc handleSQLdb {} {
		if { ![info exists ::SQLdb::nghandle] } {
			set ::SQLdb::nghandle [::SQLdb::openSQLdb]
		}
		return $::SQLdb::nghandle
	}

	proc timestampSQLdb { {seconds 0} } {
		if { !$seconds } { return "0000-00-00 00:00:00" }
		clock format $seconds -format "%Y-%m-%d %H:%M:%S"
	}

	proc untimestampSQLdb { {timestamp "0000-00-00 00:00:00"} } {
		if { $timestamp == "0000-00-00 00:00:00" } { return 0 }
		clock scan $timestamp
	}


	proc SQLdb_Init {} {
		if { ![SQLdb_CheckPackage] } {
			return 0
		}
		variable nghandle [handleSQLdb]
		SQLdb_Register

		if { [SQLdb_CreateTable] } {
			# the table has just been created, let's try to import any data from the honor directory
			SQLdb_Import
		} else {
			# the table already exists, let's check it
			set condition [SQLdb_ColumnsCondition]
			if { $condition > 0 && ![SQLdb_RepairTable] || $condition < 0 } {
				::Custom::Error "The honor table has a critical error! Reset needed."
				#return 0
			}
		}
		SQLdb_RedefineProcs
		return 1
	}

	# register to the SQLdb table
	proc SQLdb_Register {} {
		variable nghandle
		variable NAME
		variable VERSION

		# NAME is the script name (this MUST be consistent across versions)
		# VERSION is the script current version
		if { ! [ ::SQLdb::booleanSQLdb $nghandle "SELECT * FROM `$::SQLdb::NAME` WHERE (`name` = '$NAME') LIMIT 1" ] } {
			# Whatever commands you need to get a first time run
			puts "[::Custom::LogPrefix]$NAME: Current version ($VERSION) is a new installation."
			::SQLdb::querySQLdb $nghandle "INSERT INTO `$::SQLdb::NAME` (`name`, `version`) VALUES('$NAME', '$VERSION')"
		} else {
			set oldver [ ::SQLdb::firstcellSQLdb $nghandle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$NAME') LIMIT 1" ]
			if { [ expr { $oldver > $VERSION } ] } {
				# Whatever commands needed to downgrade
				#error "The current version of $NAME ($VERSION) is older that the previous one ($oldver), downgrade unsupported!"
				puts "[::Custom::LogPrefix]$NAME: Current version ($VERSION) is older than the previous one ($oldver)."
				# If downgrading is allowed it must end with:
				::SQLdb::querySQLdb $nghandle "UPDATE `$SQLdb::NAME` SET `version` = '$VERSION', `previous` = '$oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$NAME')"
			} elseif { [ expr { $oldver < $VERSION } ] } {
				# Whatever command to upgrade
				puts "[::Custom::LogPrefix]$NAME: Current version ($VERSION) is newer than the previous one ($oldver)."
				::SQLdb::querySQLdb $nghandle "UPDATE `$SQLdb::NAME` SET `version` = '$VERSION', `previous` = '$oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$NAME')"
			}
		}
	}

	proc SQLdb_Unregister {} {
		variable nghandle
		variable NAME
		::SQLdb::querySQLdb $nghandle "DELETE FROM `$SQLdb::NAME` WHERE (`name` = '$NAME')"
	}

	proc SQLdb_Uninstall {} {
		SQLdb_Unregister
		SQLdb_DropTable
	}

	proc SQLdb_CheckPackage {} {
		if { [lsearch [package names] "SQLdb"] < 0 } {
			puts "SQLdb is not installed, the option \"use_sqldb\" will be ignored."
			return 0
		}
		package require SQLdb
		return 1
	}

	# return 0 = ok, 1 = error, -1 = fatal error
	proc SQLdb_ColumnsCondition {} {
		variable nghandle
		variable GoodColumns $::Honor::Columns
		variable MissingColumns ""
		variable WrongColumns ""
		catch {
			set found 0
			# get a row for testing
			while { [catch {set rows [::SQLdb::querySQLdb $nghandle "SELECT `[join $GoodColumns {`, `}]` FROM `honor` LIMIT 1"]} err] } {
				if { [string match -nocase "*column*" $err] } {
					set found_col 0
					# don't recover from missing `name` column
					foreach column [lrange $GoodColumns 1 end] {
						if { [string match -nocase "*$column*" $err] } {
							set pos [lsearch $GoodColumns $column]
							set GoodColumns [lreplace $GoodColumns $pos $pos]

							lappend MissingColumns $column
							set found_col 1
							break
						}
					}
					if { $found_col } { continue }
				}
				error $err
			}
			# initialize missing variables with table defaults
			foreach column $MissingColumns {
				if { $column == "guild" } { set $column ""
				} elseif { $column == "addon_time" } { set $column [timestampSQLdb 0]
				} elseif { $column == "activity" } { set $column [timestampSQLdb [clock seconds]]
				} elseif { $column == "locale" } { set $column [Texts::Locale]
				} else { set $column 0 }
			}
			foreach row $rows {
				foreach $GoodColumns $row {
					set found 1
				}
			}
			if { !$found } {
				# table is empty, insert and delete a test row
				::SQLdb::querySQLdb $nghandle "INSERT INTO `honor` (`name`) VALUES('test')"
				foreach row [::SQLdb::querySQLdb $nghandle "SELECT `[join $GoodColumns {`, `}]` FROM `honor` LIMIT 1"] {
					foreach $GoodColumns $row {
					}
				}
				::SQLdb::querySQLdb $nghandle "DELETE FROM `honor` WHERE (`name` = 'test')"
			}
			# check types: name, rating, race, class, level, guild, hkills, dkills, defeats, addon_ver, addon_time, activity, locale
			if { [string is integer $name] } { lappend WrongColumns "name" }
			if { ![string is integer -strict $rating] } { lappend WrongColumns "rating" }
			if { ![string is integer -strict $race] } { lappend WrongColumns "race" }
			if { ![string is integer -strict $class] } { lappend WrongColumns "class" }
			if { ![string is integer -strict $level] } { lappend WrongColumns "level" }
			if { [string is integer -strict $guild] } { lappend WrongColumns "guild" }
			if { ![string is integer -strict $hkills] } { lappend WrongColumns "hkills" }
			if { ![string is integer -strict $dkills] } { lappend WrongColumns "dkills" }
			if { ![string is integer -strict $defeats] } { lappend WrongColumns "defeats" }
			if { ![string is double -strict $addon_ver] } { lappend WrongColumns "addon_ver" }
			if { [string is integer $addon_time] || [catch {set addon_time [untimestampSQLdb $addon_time]}] } {
				lappend WrongColumns "addon_time"
			}
			if { [string is integer $activity] || [catch {set activity [untimestampSQLdb $activity]}] } {
				lappend WrongColumns "activity"
			}
			if { [string is integer -strict $locale] } { lappend WrongColumns "locale" }
		} err
		if { $err != "" } {
			::Custom::Error $err
			return -1
		}
		if { [llength $MissingColumns] || [llength $WrongColumns] } {
			set msg ""
			if { [llength $MissingColumns] } { set msg "missing ([join $MissingColumns ", "])" }
			if { [llength $WrongColumns] } {
				if { $msg != "" } { append msg ", " }
				append msg "wrong ([join $WrongColumns ", "])"
			}
			puts "Honor: Column errors - $msg"
			return 1
		}
		return 0
	}

	# repair/upgrade a table with faulty columns
	proc SQLdb_RepairTable {} {
		variable nghandle
		variable GoodColumns
		variable MissingColumns
		variable WrongColumns
		variable MAX_ROWS
		set renamed 0
		catch {
			set tempdata ""
			# initialize missing variables with defaults
			foreach column $MissingColumns {
				if { $column == "guild" } { set $column ""
				} elseif { $column == "addon_time" } { set $column 0
				} elseif { $column == "activity" } { set $column [clock seconds]
				} elseif { $column == "locale" } { set $column [Texts::Locale]
				} else { set $column 0 }
			}
			foreach row [::SQLdb::querySQLdb $nghandle "SELECT `[join $GoodColumns {`, `}]` FROM `honor` LIMIT $MAX_ROWS"] {
				foreach $GoodColumns $row {
					if { [string is integer $name] } { continue }
					# correct the data
					foreach column $WrongColumns {
						if { $column == "guild" } {	set $column ""
						} elseif { $column == "addon_time" || $column == "activity" } {
							# do nothing
						} elseif { $column == "locale" } { set $column [Texts::Locale]
						} else { set $column 0 }
					}
					if { ![string is integer -strict $addon_time] && [catch {set addon_time [untimestampSQLdb $addon_time]}] } {
						set addon_time 0
					}
					if { ![string is integer -strict $activity] && [catch {set activity [untimestampSQLdb $activity]}] } {
						set activity [clock seconds]
					}
					lappend tempdata [list $name $rating $race $class $level $guild $hkills $dkills $defeats $addon_ver $addon_time $activity $locale]
				}
			}
			set tmpname "honor[::Custom::RandInt 10000 99999]"
			::SQLdb::querySQLdb $nghandle "ALTER TABLE `honor` RENAME TO `$tmpname`"
			set renamed 1
			if { ![SQLdb_CreateTable] } { error "Couldn't create the table"	}
			set tempdata [lsort -unique -index 0 $tempdata]
			foreach row $tempdata {
				foreach $::Honor::Columns $row {
					::SQLdb::querySQLdb $nghandle "INSERT INTO `honor` ($::Honor::ColumnsList) VALUES(\
						'[::SQLdb::canonizeSQLdb $name]', $rating, $race, $class, $level,\
						'[::SQLdb::canonizeSQLdb $guild]', $hkills, $dkills, $defeats,\
						$addon_ver, '[timestampSQLdb $addon_time]', '[timestampSQLdb $activity]', '$locale')"
				}
			}
			::SQLdb::querySQLdb $nghandle "DROP TABLE `$tmpname`"
			set count [llength $tempdata]
			::SQLdb::cleanupSQLdb $nghandle
			puts "Honor: The honor table was successfully repaired ([expr {$count?$count:{no}}] player[expr {$count>1?{s}:{}}] imported)."
		} err
		if { $err != "" } {
			::Custom::Error $err
			if { $renamed } {
				SQLdb_DropTable
				::SQLdb::querySQLdb $nghandle "ALTER TABLE `$tmpname` RENAME TO `honor`"
			}
			puts "Honor: The honor table couldn't be repaired!"
			return 0
		}
		return 1
	}

	proc SQLdb_CreateTable {} {
		variable nghandle
		if { [::SQLdb::existsSQLdb $nghandle `honor`] } { return 0 }
		::SQLdb::querySQLdb $nghandle "CREATE TABLE `honor` (\
			`id` INTEGER PRIMARY KEY AUTO_INCREMENT,
			`name` VARCHAR(31) UNIQUE NOT NULL DEFAULT '',\
			`rating` INTEGER NOT NULL DEFAULT 0,\
			`race` INTEGER NOT NULL DEFAULT 0,\
			`class` INTEGER NOT NULL DEFAULT 0,\
			`level` INTEGER NOT NULL DEFAULT 0,\
			`guild` VARCHAR(63) NOT NULL DEFAULT '',\
			`hkills` INTEGER NOT NULL DEFAULT 0,\
			`dkills` INTEGER NOT NULL DEFAULT 0,\
			`defeats` INTEGER NOT NULL DEFAULT 0,\
			`addon_ver` REAL NOT NULL DEFAULT 0,\
			`addon_time` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00',\
			`activity` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,\
			`locale` VARCHAR(7) NOT NULL DEFAULT 'en')"
		return 1
	}

	proc SQLdb_DropTable {} {
		variable nghandle
		if { [::SQLdb::existsSQLdb $nghandle `honor`] } {
			::SQLdb::querySQLdb $nghandle "DROP TABLE `honor`"
			return 1
		}
		return 0
	}

	proc SQLdb_ResetTable {} {
		variable nghandle
		if { [SQLdb_DropTable] && [SQLdb_CreateTable] } {
			::SQLdb::cleanupSQLdb $nghandle
			ClearCache
			UpdateRankings 1
			return 1
		}
		return 0
	}

	# import data from the honor directory
	proc SQLdb_Import { {replace 0} } {
		if { ![file exists $::Honor::HONOR_DIR] } { return 0 }
		if { !$::Honor::UsingSQLdb } { SQLdb_RedefineProcs }
		variable nghandle
		ClearCache
		set count 0
		foreach name [glob -types f -nocomplain -tails -directory $::Honor::HONOR_DIR "*"] {
			foreach [lrange $::Honor::Columns 1 12] [lrange [ReadDataFromFile $name] 0 11] {}
			set insert  1
			if { [::SQLdb::booleanSQLdb $nghandle "SELECT `race` FROM `honor` WHERE (`name` = '[::SQLdb::canonizeSQLdb $name]') LIMIT 1"] } {
				if { $replace || [::SQLdb::firstcellSQLdb $nghandle "SELECT `race` FROM `honor` WHERE (`name` = '[::SQLdb::canonizeSQLdb $name]') LIMIT 1"] == 0 } {
					::SQLdb::querySQLdb $nghandle "DELETE FROM `honor` WHERE (`name` = '[::SQLdb::canonizeSQLdb $name]')"
				} else { set insert 0 }
			}
			if { $insert } {
				::SQLdb::querySQLdb $nghandle "INSERT INTO `honor` ($::Honor::ColumnsList) VALUES(\
					'[::SQLdb::canonizeSQLdb $name]', $rating, $race, $class, $level,\
					'[::SQLdb::canonizeSQLdb $guild]', $hkills, $dkills, $defeats,\
					$addon_ver, '[timestampSQLdb $addon_time]', '[timestampSQLdb $activity]', '$locale')"
				incr count
			}
		}
		ClearCache
		UpdateRankings 1
		set msg "[expr {$count?$count:{no}}] player[expr {$count>1?{s}:{}}] imported from the directory \"$::Honor::HONOR_DIR\"."
		puts "Honor: $msg"
		return $count
	}

	# export to the honor directory
	proc SQLdb_Export { {replace 0} } {
		if { $::Honor::HONOR_DIR == "" } { return 0 }
		if { ![file exists $::Honor::HONOR_DIR] } { file mkdir $::Honor::HONOR_DIR }
		if { !$::Honor::UsingSQLdb } { SQLdb_RedefineProcs }
		set count 0
		foreach name [GetRankedPlayerNames] {
			if { ![file exists "$::Honor::HONOR_DIR/$name"] || $replace } {
				ReadData $name
				WriteDataToFile $name
				incr count
			}
		}
		set msg "[expr {$count?$count:{no}}] player[expr {$count>1?{s}:{}}] exported to the directory \"$::Honor::HONOR_DIR\"."
		puts "Honor: $msg"
		return $count
	}

	proc SQLdb_RedefineProcs {} {
		if { [info procs "::Honor::ReadDataFromFile"] != "" } { return 0 }
		variable UsingSQLdb 1

		rename ::Honor::ReadData ::Honor::ReadDataFromFile
		proc ::Honor::ReadData { player_name } {
			if { $player_name == "" } { return 0 }
			variable nghandle
			variable HonorData
			set pn [string tolower $player_name]
			if { [info exists HonorData($pn)] } {
				return $HonorData($pn)
			} else {
				set found 0
				foreach row [::SQLdb::querySQLdb $nghandle "SELECT $::Honor::ColumnsList FROM `honor` WHERE (`name` = '[::SQLdb::canonizeSQLdb $player_name]') LIMIT 1"] {
					foreach $::Honor::Columns $row {
						set addon_time [untimestampSQLdb $addon_time]
            			set activity [untimestampSQLdb $activity]
						set found 1
					}
				}
				if { !$found } {
					set rating 0
					set race 0
					set class 0
					set level 0
					set guild ""
					set hkills 0
					set dkills 0
					set defeats 0
					set addon_ver 0
					set addon_time 0
					set activity [clock seconds]
					set locale [Texts::Locale]
					::SQLdb::querySQLdb $nghandle "INSERT INTO `honor` (`name`, `locale`) VALUES(\
						'[::SQLdb::canonizeSQLdb $player_name]', '$locale')"
				}
				set HonorData($pn) [list $rating $race $class $level $guild $hkills $dkills $defeats $addon_ver $addon_time $activity $locale]
			}
		}

		rename ::Honor::WriteData ::Honor::WriteDataToFile
		proc ::Honor::WriteData { player_name } {
			if { $player_name == "" } { return 0 }
			variable nghandle
			set pn [string tolower $player_name]

			foreach [lrange $::Honor::Columns 1 12] [lrange $::Honor::HonorData($pn) 0 11] {}

			::SQLdb::querySQLdb $nghandle "UPDATE `honor` SET\
				`rating` = $rating, `race` = $race, `class` = $class, `level` = $level,\
				`guild` = '[::SQLdb::canonizeSQLdb $guild]', `hkills` = $hkills, `dkills` = $dkills, `defeats` = $defeats,\
				`addon_ver` = $addon_ver, `addon_time` = '[timestampSQLdb $addon_time]', `activity` = '[timestampSQLdb $activity]', `locale` = '$locale'\
				WHERE (`name` = '[::SQLdb::canonizeSQLdb $player_name]')"
			return 1
		}

		rename ::Honor::DeletePlayer ::Honor::DeletePlayerFromFile
		proc ::Honor::DeletePlayer { player_name } {
			variable nghandle
			::SQLdb::querySQLdb $nghandle "DELETE FROM `honor` WHERE (`name` = '[::SQLdb::canonizeSQLdb $player_name]')"
			set pn [string tolower $player_name]
			array unset ::Honor::HonorData $pn
			ClearNames
			UpdateRankings 1
			return 1
		}

		rename ::Honor::DeleteAllPlayers ::Honor::DeleteAllPlayersFromFile
		proc ::Honor::DeleteAllPlayers {} {
			variable nghandle
			::SQLdb::querySQLdb $nghandle "DELETE FROM `honor`"
			#SQLdb_ResetTable
			ClearCache
			UpdateRankings 1
			return 1
		}

		rename ::Honor::GetRankedPlayerNames ::Honor::GetRankedPlayerNamesFromFile
		proc ::Honor::GetRankedPlayerNames {} {
			variable RankedPlayerNames
			variable MAX_ROWS
			if { $RankedPlayerNames == "" } {
				variable nghandle
				set RankedPlayerNames [::SQLdb::querySQLdb $nghandle "SELECT `name` FROM `honor` WHERE (`race` != 0) ORDER BY `rating` DESC LIMIT $MAX_ROWS"]
			}
			return $RankedPlayerNames
		}

		# todo: redefine these procs to update just the needed columns instead of calling WriteData
		# ChangeRating
		# ChangeRatingByName
		# SetLocale
		# SetAddonVersion

		return 1
	}

	# trying to get short version info
	proc SQLdb_VersionInfo { {full 1} } {
		variable nghandle
		return [::SQLdb::versionSQLdb $nghandle]
	}
}



# startup stuff
namespace eval ::Honor {

	if { [catch { ::StartTCL::Require Custom $MIN_CUSTOM } err] } {
		::Custom::Error $err
	}

	if { ![file exists "www"] } {
		::Custom::Error "Honor:: no \"www\" directory!"
		set ::Honor::RANKINGS_UPDATE -1
	}

	if { ![string is integer -strict $CONSOLE_INFO] } {
		if { ![info exists ::VERBOSE] || $::VERBOSE > 1 } {
			variable CONSOLE_INFO 1
		} else {
			variable CONSOLE_INFO 0
		}
	}

	if { $RANKINGS_LIMIT > 300 } {
		variable RANKINGS_LIMIT 300
	}

	if { $USE_SQLDB && [SQLdb_Init] } {
		if { $CONSOLE_INFO } {
			puts "[::Custom::LogPrefix][GetVersionInfo]"
		}
	} elseif { $HONOR_DIR != "" } {
		if { ![file exists $HONOR_DIR] } { file mkdir $HONOR_DIR }
		if { $CONSOLE_INFO } {
			puts "[::Custom::LogPrefix][GetVersionInfo]"
		}
	} else {
		::Custom::Error "No SQLdb or honor directory!"
	}


	# self script integration
	if { $::Honor::SELF_INTEGRATION } {

		::Custom::HookProc "WoWEmu::CalcReputation" {::Honor::CalcRatings $victim $killer} "Honor::CalcRatings"
		::Custom::HookProc "WoWEmu::OnPlayerDeath" {::Honor::CalcRatings $player $killer} "Honor::CalcRatings"
		::Custom::HookProc "WoWEmu::DamageReduction" [info body ::Honor::CountHits] "Honor::CountHits"
		::Custom::HookProc "AI::CanUnAgro" [info body ::Honor::CountAttackers] "Honor::CountAttackers"

		if { $::Honor::CIVILIAN_NOAGGRO } {
			if { [info procs "::AI::ModAgro"] != "" } {
				# improved performance (needs StartTCL v0.9.2 or higher)
				::Custom::HookProc "::AI::ModAgro" {
					if { [::Honor::IsCivilian $npc] } { return 0 }
				}
			} elseif { [string first {return 1} [info body ::AI::CanAgro]] >= 0 } {
				eval "proc ::AI::CanAgro {[info args ::AI::CanAgro]} {[string map {{return 1} {if { [::Honor::IsCivilian $npc] } { return 0 } { return 1}}} [info body ::AI::CanAgro]]}"
			} else {
				::Custom::HookProc "::AI::CanAgro" {
					if { [::Honor::IsCivilian $npc] } { return 0 }
				}
			}
		}

		if { $::Honor::CHECK_GHOST > 1 && [string first {GetQFlag $player IsDead} [info body ::WoWEmu::DamageReduction]] < 0 } {
			::Custom::HookProc "WoWEmu::DamageReduction" {
				if { [::GetQFlag $player IsDead] } { return 1 }
			}
		}

		# improved login detection (patched spell 836 and StartTCL v0.9.0 or higher needed)
		::Custom::AddSpellScript "::Honor::OnLogin" 836

		::Custom::AddCommand {
			"honor" ::Honor::Commands 0
			"sethonor" ::Honor::WrongCommand 0
			"addhonor" ::Honor::WrongCommand 0
			"reshonor" ::Honor::WrongCommand 0
			"delhonor" ::Honor::WrongCommand 0
			"gethonor" ::Honor::WrongCommand 0
			"getrank" ::Honor::WrongCommand 0
		}
	}


	UpdateRankings 1
	::StartTCL::Provide
}


# testing suff
namespace eval ::Honor {
	if { $DEBUG } {
		puts "\n[namespace tail [namespace current]]: *** DEBUG MODE ENABLED ***\n"
		# .eval Custom::GetBenchData 1
		foreach proc [lsort [info procs]] {
			if { [string match -nocase "*" $proc] } {
				if { [string first "timestamp" $proc] >= 0 } {
					puts "Skipped proc: $proc"
					continue
				}
				#Custom::BenchCmd [namespace current]::$proc 1
				Custom::TraceCmd [namespace current]::$proc 0
			}
		}
	}

}

