#
# StartTCL: n
#
# ====================================
#
# InstanceLimiter v1.3.1
#
# ====================================
#
# Based on InstanceLimiter v1.2.0 by Rama
#
#


namespace eval ::InstanceLimiter {

	############################################################################
	# SETTINGS
	#
	variable NAME "zInstanceLimiter"
	variable VERSION 1.3.1
	#
	#
	# Disallow mixing of Horde and Alliance players in instances
	variable ONE_SIDE_ONLY 1
	#
	#
	# Prioritize access according to level when an instance is full
	variable PRIORITIZE 1
	#
	#
	variable USE_CONF 1
	variable MIN_CUSTOM 2.04
	############################################################################

	# load conf file if available
	if { $USE_CONF } {
		::Custom::LoadConf $NAME "scripts/conf/zinstancelimiter.conf"
	}

	# INSTANCE-CONTROL
	#
	# 1) Name of the instance
	# 2) Minimum player level
	# 3) Maximum player level
	# 4) Minimum number of players
	# 5) Maximum number of players
	# 6) Position of the entrance
	#
	# map -> { instance_name minlevel maxlevel minplayers maxplayers entrance_pos }
	variable InstanceSettings
	array set InstanceSettings {
		389 { "Ragefire Chasm"    10 255 0 10 "1 1807 -4398 -18" }
		43  { "Wailing Caverns"   11 255 0 10 "1 -810 -2136 92" }
		36  { "The DeadMines"     11 255 0 10 "0 -11081 1559 49" }
		35  { "Stormwind Vault"   20 255 0 10 "0 -8653 606 92" }
		33  { "Shadowfang Keep"   14 255 0 10 "0 -239 1516 76" }
		34  { "The Stockades"     18 255 0 10 "0 -8819 803 99" }
		48  { "Blackfathom Deeps" 17 255 0 10 "1 4068 824 4" }
		47  { "Razorfen Kraul"    21 255 0 10 "1 -4475 -1811 87" }
		90  { "Gnomeregan"        20 255 0 10 "0 -5204 596 412" }
		189 { "Scarlet Monastery" 26 255 0 10 "0 2664 -668 112" }
		129 { "Razorfen Downs"    30 255 0 10 "1 -4381 -1947 88" }
		70  { "Uldaman"           31 255 0 10 "0 -6106 -3299 257" }
		209 { "Zul'Farrak"        43 255 0 10 "1 -6818 -2889 9" }
		349 { "Maraudon"          40 255 0 10 "1 -1405 2816 113" }
		109 { "The Sunken Temple" 50 255 0 10 "0 -10450 -3821 19" }
		230 { "Blackrock Depths"  52 255 0 20 "0 -7583 -1134 262" }
		229 { "Blackrock Spire"   55 255 0 20 "0 -7611 -1221 233" }
		429 { "Dire Maul"         56 255 0 10 "1 -3887 1096 155" }
		289 { "Scholomance"       57 255 0 20 "0 1230 -2588 91" }
		329 { "Stratholme"        57 255 0 20 "0 3361 -3380 145" }
		249 { "Onyxia's Lair"     56 255 2 40 "1 -4678 -3705 47" }
		409 { "Molten Core"       56 255 2 40 "230 1127 -451 -101" }
		469 { "Blackwing Lair"    56 255 3 40 "229 165 -475 117" }
		309 { "Zul'Gurub"         56 255 0 20 "0 -11916 -866 31" }
                533 { "Naxx2"             60 255 4 20 "0 3132 -3731 138" }
                509 { "Ahn Ruins"         59 255 2 20 "1 -8424 1508 32" }
                531 { "Ahn Temple"        59 255 2 20 "1 -8230 2003 129" }
	}

	# trigger_number -> topos
	variable InstancePosition
	array set InstancePosition {
		45 "189 1688.57 1052.42 18.68 1.14"
		78 "36 -16.40 -383.07 61.78 1.86"
		101 "34 54.23 0.28 -18.34 6.26"
		107 "35 -0.91 40.57 -24.23 1.59"
		145 "33 -228.19 2110.56 76.89 1.22"
		228 "43 -163.49 132.95 -73.66 5.83"
		244 "47 1943.00 1544.63 82.00 1.38"
		257 "48 -151.89 106.96 -39.87 4.53"
		286 "70 -226.80 49.09 -46.03 1.39"
		324 "90 -332.22 -2.28 -150.86 2.77"
		442 "129 2592.55 1107.50 51.29 4.74"
		446 "109 -319.24 99.90 -131.85 3.19"
		523 "90 -736.51 2.71 -249.99 3.14"
		610 "189 855.11 1320.76 18.67 0.30"
		612 "189 1608.38 -320.50 18.67 5.97"
		614 "189 254.99 -206.82 18.68 5.76"
		902 "70 -211.23 385.09 -38.72 1.31"
		924 "209 1213.52 841.59 8.93 6.09"
		1466 "230 458.32 26.52 -70.67 4.95"
		1468 "229 78.78 -228.06 49.69 4.77"
		2216 "329 3393.55 -3390.98 143.16 1.56"
		2217 "329 3392.96 -3366.75 142.84 4.70"
		2214 "329 3593.15 -3646.56 138.50 5.33"
		2230 "389 3.81 -14.82 -17.84 4.39"
		2567 "289 196.37 127.05 134.91 6.09"
		2848 "249 30.68 -60.80 -5.27 4.58"
		2886 "409 1093.46 -469.41 -105.70 3.99"
		3133 "349 1019.69 -458.31 -43.43 0.31"
		3134 "349 752.91 -616.53 -33.11 1.37"
		3183 "429 47.63 -155.27 -2.71 6.01"
		3184 "429 -201.11 -328.66 -2.72 5.22"
		3185 "429 16.43 -836.91 -31.19 0.07"
		3186 "429 -64.23 160.13 -3.47 2.99"
		3187 "429 34.35 160.70 -3.47 0.72"
		3189 "429 254.79 -17.09 -2.56 5.25"
		3726 "469 -7674.47 -1108.38 396.65 0.61"
		3930 "309 -11915.75 -1233.41 92.29"
                4055 "533 3005.798096 -3434.379150 293.880798"
                4008 "509 -8429.743164 1512.136475 31.907366"
                4010 "531 -8231.33007813 2010.59997559 129.860992432"
		527  "1 8795.80 969.43 30.20 3.40"
	}

	# trigger_number -> taxinode
	variable TaxiNodeTriggers
	array set TaxiNodeTriggers {
		527 26
		716 27
	}
}


# perform at area trigger
proc ::InstanceLimiter::AreaTrigger { player trigger_number } {
	variable ONE_SIDE_ONLY
	variable PRIORITIZE
	variable InstanceSettings
	variable InstancePosition
	variable TaxiNodeTriggers
	# check for taxi node to explore
	
        if { [info exists TaxiNodeTriggers($trigger_number)] } {
		::TaxiNodeExplorered $player $TaxiNodeTriggers($trigger_number)
	}

	# return if no instance position
	if { ![info exists InstancePosition($trigger_number)] } {
		return
	}

	set tpos $InstancePosition($trigger_number)
	set map [lindex $tpos 0]

	# check for instance settings
	if { [info exists InstanceSettings($map)] } {
		foreach { tname tminlvl tmaxlvl tminplayer tmaxplayer tentrance } $InstanceSettings($map) {}
		set level [::GetLevel $player]

		# too low level
		if { $level < $tminlvl } {
			::Say $player 0 [::Texts::Get "min_level_limit" $tminlvl]
			return
		}

		# too high level
		if { $level > $::WoWEmu::MAX_LEVEL } {
			::Say $player 0 [::Texts::Get "max_level_limit" $::WoWEmu::MAX_LEVEL]
			return
		}

		set insideplayers [::Custom::CountInMap $map]

		# check for side
		if { $ONE_SIDE_ONLY } {
			set side [::Custom::GetPlayerSide $player]
			set sameside_count [::Custom::CountInMap $map $side]
			set otherside_count [expr {$insideplayers - $sameside_count}]

			if { $sameside_count < $otherside_count } {
				set otherside_name [expr {$side ? [::Texts::Get "alliance"] : [::Texts::Get "horde"]}]

				::Say $player 0 [::Texts::Get "other_side_already" $otherside_name]
				return
			}
		}

		# too many players
		if { $insideplayers >= $tmaxplayer && (!$PRIORITIZE || ![FreeSlotForPlayer $player $map]) } {
			::Say $player 0 [::Texts::Get "max_inst_player" $tmaxplayer]
			return
		}
	}

	::Custom::TeleportPos $player $tpos

	# resurrect in instance if dead
	if { $map > 1 && [::GetQFlag $player IsDead] } {
		::Resurrect $player
	}

	set key [string tolower [::GetName $player]]
	if { [info exists ::Custom::OnlinePlayers($key)] } {
		lset ::Custom::OnlinePlayers($key) 4 $map
	}
}


# perform at player login
proc ::InstanceLimiter::OnLogin { to from spellid } {
	variable ONE_SIDE_ONLY
	variable PRIORITIZE
	variable InstanceSettings

	set map [lindex [::GetPos $to] 0]

	if { ![info exists InstanceSettings($map)] } {
		return
	}

	foreach { tname tminlvl tmaxlvl tminplayer tmaxplayer tentrance } $InstanceSettings($map) {}
	set insideplayers [::Custom::CountInMap $map]

	if { $ONE_SIDE_ONLY } {
		set side [::Custom::GetPlayerSide $to]
		set sameside_count [::Custom::CountInMap $map $side]
		set otherside_count [expr {$insideplayers - $sameside_count}]

		if { $sameside_count < $otherside_count } {
			set otherside_name [expr {$side ? [::Texts::Get "alliance"] : [::Texts::Get "horde"]}]

			::Say $to 0 [::Texts::Get "other_side_already" $otherside_name]
			::Custom::TeleportPos $to $tentrance
			return
		}
	}

	if { [ ::Custom::CountInMap $map ] >= $tmaxplayer && (!$PRIORITIZE || ![FreeSlotForPlayer $to $map]) } {
		::Say $to 0 [::Texts::Get "max_inst_player" $tmaxplayer]
		::Custom::TeleportPos $to $tentrance
		return
	}
}


# try to free a slot in an instance
proc ::InstanceLimiter::FreeSlotForPlayer { player map } {
	variable InstanceSettings
	set level [::GetLevel $player]
	set player_data [list "" $level]

	foreach { player_name player_race player_class player_level player_map player_zone } [join [::Custom::GetAllOnlineData]] {
		if { $player_map == $map && $player_level > [lindex $player_data 1] } {
			set player_data [list $player_name $player_level]
		}
	}

	if { [lindex $player_data 1] > $level } {
		set other_player [::Custom::GetPlayerID [lindex $player_data 0]]
		if { $other_player } {
			::Say $other_player 0 [::Texts::Get "slot_taken" [::GetName $player]]
			::Custom::TeleportPos $other_player [lindex $InstanceSettings($map) 5]
			if { [lindex [::GetPos $other_player] 0] == $map } {
				::KickPlayer $other_player
			}
			return 1
		}
	}

	return 0
}


#
# Initialization
#

if { [catch { ::StartTCL::Require Custom $::InstanceLimiter::MIN_CUSTOM } err] } {
	::Custom::Error $err
}

if { ![info exists ::WoWEmu::MAX_LEVEL] } {
	set ::WoWEmu::MAX_LEVEL 60
}

::Custom::AddSpellScript "::InstanceLimiter::OnLogin" 836

::Custom::HookProc "::WoWEmu::CalcXP" {
	set map [lindex [::GetPos $killer] 0]

	if { [info exists ::InstanceLimiter::InstanceSettings($map)] } {
		set minplayers [lindex $::InstanceLimiter::InstanceSettings($map) 3]

		if { $minplayers && [ ::Custom::CountInMap $map ] < $minplayers } {
			::Say $killer 0 [::Texts::Get "not_enough_toplay" $minplayers]
			::Custom::TeleportPos $killer [lindex $::InstanceLimiter::InstanceSettings($map) 5]
			return 0
		}
	}
}

::StartTCL::Provide $::InstanceLimiter::NAME $::InstanceLimiter::VERSION

foreach ns { instancelimiter zInstanceLimiter zinstancelimiter } {
	eval "namespace eval ::${ns} { proc AreaTrigger { player trigger_number } { ::InstanceLimiter::AreaTrigger \$player \$trigger_number } }"
}
unset ns

namespace eval ::UnusedTriggers { proc AreaTrigger { player trigger_number } {} }


# default localization
namespace eval ::InstanceLimiter {
	if { ![::Texts::Exists] } {
		# English
		::Texts::Set en max_inst_player "This instance doesn't support more than %d players."
		::Texts::Set en other_side_already "I can't enter because there's already %s."
		::Texts::Set en min_level_limit "I need to be at least level %d to enter here."
		::Texts::Set en max_level_limit "The maximum level for this instance is %d."
		::Texts::Set en slot_taken "%s has taken my slot!"
		::Texts::Set en alliance "Alliance"
		::Texts::Set en horde "Horde"
	}
}

namespace eval ::WoWEmu {
	if { ![::Texts::Exists not_enough_toplay] } {
		# English
		::Texts::Set en not_enough_toplay "This instance requires a minimum of %d players!"
	}
}

