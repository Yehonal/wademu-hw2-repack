#
#
# This file is part of the NextGen Buyback System
#
# NextGen Buyback System is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
#
# NextGen Buyback System is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public License as
# published by the Free Software Foundation; either version 2.1 of the License,
# or (at your option) any later version.
#
# NextGen Buyback System is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License
# for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA. You can also consult
# the terms of the license at:
#
#               <http://www.gnu.org/copyleft/lesser.html>
#
#
# Name:		ngBuyback.tcl
#
# Version:	0.8.7
#
# Date:		2006-05-11
#
# Description:	NextGen Buyback System
#
# Author:	Lazarus Long <lazarus.long@bigfoot.com>
#
# Changelog:
#
# v0.8.7 (2006-05-11) -	The "in search of my soul" version.
#			Added an option to turn the plugin on and off. Added an
#			option to ignore soulbound items. Changed the support
#			thread location. Fixed the reading of the Debug option
#			from the configuration file. Fixed an error when hand
#			calling procedure "rebuy".
#
# v0.8.6 (2006-04-13) -	The "too fast trigger for me" version.
#			Found and corrected the sporadic error with the buyback
#			array.
#
# v0.8.5 (2006-04-13) -	The "check everything out" version.
#			Added several boundary checks to catch some errors due
#			to possible exploit attempts.
#
# v0.8.4 (2006-04-12) -	The "simplification is the name of the game" version.
#			Merged "itemcheck" and "sell" in a single procedure.
#			Added logging of suspicious errors.
#
# v0.8.3 (2006-04-11) -	The "keep them comming" version.
#			Even more bugs corrected, now both "itemcheck" and
#			"sell" procedures have parameters verification. Also
#			"itemcheck" only works at selling distances (up to 5
#			yards) now.
#
# v0.8.2 (2006-04-11) -	The "we are in control" version.
#			Corrected more bugs pointed out by "Spirit", all sales
#			are done server-side now.
#
# v0.8.1 (2006-04-10) -	The "proof of fire" version.
#			Corrected several minor bugs pointed out by "Spirit",
#			added French language also thanks to "Spirit".
#
# v0.8.0 (2006-04-10) -	The "let me go" version.
#			Rechecked and fine tunned the communication with the
#			client addon. Added the config file and documentation.
#			Ready for public testing.
#
# v0.7.3 (2006-04-09) -	The "make me compatible" version.
#			Managed to get the client to support both addons. It's
#			ugly when the server is running legacy buyback, but I
#			did my best.
#
# v0.7.2 (2006-04-08) -	The "lets get autism" version.
#			Changed the logon sequence to take advantage of spell
#			836. Cleanup is done only serverside.
#
# v0.7.1 (2006-04-07) -	The "Morgan knowns his logic" version.
#			Fixed a missing point in array_shift logic.
#
# v0.7.0 (2006-04-06) -	The "make me neat" version.
#			Simple housekeeping, to remove the test procedures,
#			comment the script, add DEBUG info and reformat the
#			script.
#
# v0.6.0 (2006-04-05) -	The "conf is always good" version.
#			Added the procedure to read from a config file.
#
# v0.5.0 (2006-04-05) -	The "let's make it a real thing" version.
#			Added the procedures to get versioning, make cleanups
#			and initializing the system.
#
# v0.4.1 (2006-04-04) -	The "I challenge you" version.
#			Included a challenge/response to try to avoid the more
#			simple exploits with this script.
#
# v0.4.0 (2006-04-04) -	The "check and double check" version.
#			All procedures accessed by the client addon now check
#			the parameters they receive to try to reduce eventual
#			exploits resulting from forcing boundaries.
#
# v0.3.1 (2006-04-03) -	The "scratch that" version.
#			Rewrote all procedures from scratch to use this new
#			approach.
#
# v0.3.0 (2006-03-30) -	The "new approach" version.
#			Radically new approach after a suggestion to drop the
#			database method by Spirit. At the very least I'm
#			expecting that the duplicate bug goes away with this
#			new approach.
#
# v0.2.0 (2006-02-21) -	The "damn, that was easy" version.
#			Done. I sure remember it being much harder the first
#			time I did it, either I got smarter (I doubt this very
#			much) or I learned some things along the way.
#
# v0.1.0 (2006-02-21) -	The "lets start over" version.
#			Went back to my old port and started to recreate
#			procedures. (internal version)
#
#


#
#	StartTCL loading order
#
# StartTCL: n
#


#
#	namespace eval ::ngBuyback
#
# ::ngBuyback namespace and variable definitions
#
namespace eval ::ngBuyback {
	variable NAME "ngBuyback"
	variable VERSION "0.8.7"

	# Trust me, you do NOT want to set DEBUG on...
	variable DEBUG 0
	variable VERBOSE 0

	variable gm_level 4

	# Player data arrays
	variable BuybackDataArray
	variable NPCDataArray
	variable ReBuyLockArray
	variable max_slots 12


	# Client addon event marks and return codes
	variable ERR_QUEST_ITEM "ERR_TRADE_QUEST_ITEM"
	variable ERR_NO_INTEREST "ERR_VENDOR_NOT_INTERESTED"
	variable ERR_TOO_FAR "ERR_VENDOR_TOO_FAR"
	variable ERR_NO_MONEY "ERR_NOT_ENOUGH_MONEY"
	variable ERR_BUYBACK_ERR "MERCHANT_BUYBACK_ERR"
	variable ERR_BUYBACK_OK "MERCHANT_BUYBACK_OK"
	variable TAB_MERCHANT "MERCHANT_MERCHANT_TAB"
	variable TAB_BUYBACK "MERCHANT_BUYBACK_TAB"

	# ngBuyback fingerprint to send to the client addon
	variable NGBUYBACK_ID "MERCHANT_NGBUYBACK"

	# minimum Custom.tcl version required
	variable MIN_CUSTOM_VERSION "1.93"

	# Configuration file
	variable conf "scripts/conf/ngbuyback.conf"

	# ngBuyback variable to turn the plugin on and off
	variable ACTIVE 1

	# Allow soulbound items
	variable SOULBOUND 0

	# Logging facilities
	variable LOG 1
	variable LOG_FILE "logs/ngbuyback.log"

	# Localization settings
	variable LANG "default"

	# Language strings (en)
	variable c_dbg01 "Enter procedure"

	variable c_err01 "Unexpected error in NextGen Buyback System!"

	variable l_hlp01 "NextGen Buyback System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \]%1\$c%4\$-13s - displays the current program version%1\$c%5\$-15s - shows this info"
	variable l_hlp02 "NextGen Buyback System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6$\s \| %7\$s \| %8\$s \]%1\$c%4\$-17s - turns the plugin ON%1\$c%5\$-12s - turns the plugin OFF%1\$c%6\$-12s - resets the buyback data%1\$c%7\$-13s - displays the current program version%1\$c%8\$-15s - shows this info"

	variable l_swt01 "NextGen Buyback System is now %s."
	variable l_swt02 "active"
	variable l_swt03 "inactive"

	variable l_ver01 "NextGen Buyback System is at version %s"

	variable c_fil01 "You can only make a sale at a vendor!"

	variable c_sel01 "Wrong number of parameters received!"
	variable c_sel02 "Wrong type of parameters received!"

	variable l_rst01 "You are not allowed to use this command!"
	variable l_rst02 "The Buyback data is already reset!"
	variable l_rst03 "The Buyback data was successfully reset!"

	variable c_rcf01 "Error in the server files versions! Custom.tcl must be at least version:"

	variable l_leg01 "This server is running the NextGen Buyback System."
	variable l_leg02 "You must install the NextGen Buyback Client Addon!"
}


#
#	proc ::ngBuyback::logPrefix { }
#
# Returns a string suitable to add to the console
#
proc ::ngBuyback::logPrefix { } {
	if { [ string length [ info procs "::Custom::LogPrefix" ] ] } {
		return "[ ::Custom::LogPrefix ]BUYBACK:"
	}

	return "[ clock format [ clock seconds ] -format %k:%M:%S ]:M:BUYBACK:"
}


#
#	proc ::ngBuyback::logDebug { }
#
# Returns a debug string to add to the console
#
proc ::ngBuyback::logDebug { } {
	return "[ ::ngBuyback::logPrefix ]DEBUG:"
}


#
#	proc ::ngBuyback::help { player }
#
# Returns a help screen depending on your level (hand called)
#
proc ::ngBuyback::help { player } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc help{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	if { [ GetPlevel $player ] < $::ngBuyback::gm_level } {
		return [ format $::ngBuyback::l_hlp01 10 $VERSION ".buyback" "version" "help" ]
	} else {
		return [ format $::ngBuyback::l_hlp02 10 $VERSION ".buyback" "on" "off" "reset" "version" "help" ]
	}
}


#
#	proc ::ngBuyback::switcher { player action }
#
# Turns the plugin on/off (hand called)
#
proc ::ngBuyback::switcher { player action } {
	variable DEBUG
	variable ACTIVE

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc switch{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	if { ( $player != 0 ) && ( [ GetPlevel $player ] < $::ngBuyback::gm_level ) } {
		return $::ngBuyback::l_rst01
	}

	set ACTIVE [ expr { [ string tolower $action ] == "off" ? 0 : 1 } ]
	return [ format $::ngBuyback::l_swt01 [ expr { $ACTIVE ? $::ngBuyback::l_swt02 : $::ngBuyback::l_swt03 } ] ]
}


#
#	proc ::ngBuyback::version { }
#
# Returns the version info about the plugin (hand called)
#
proc ::ngBuyback::version { } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc version{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	return [ format $::ngBuyback::l_ver01 $VERSION ]
}


#
#	proc ::ngBuyback::array_shift { player {position 1} }
#
# Internal procedure to remove a slot from the array, shifting other elements
#
proc ::ngBuyback::array_shift { player {position 1} } {
	variable DEBUG
	variable BuybackDataArray
	variable max_slots

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc array_shift{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	set index [ lsearch -integer -exact $BuybackDataArray $player ]

	if { $index == -1 } {
		unset index
		return
	}

	set arraysize [ array size ::ngBuyback::BuybackDataArray${player} ]

	if { ! $arraysize } {
		unset arraysize
		unset index
		return
	}

	foreach slot [ lsort -integer [ array names ::ngBuyback::BuybackDataArray${player} ] ] {
		if { $DEBUG } {
			puts "$s_logDEBUG player=\"$player\" slot=\"$slot\" position=\"$position\" arraysize=\"$arraysize\""
		}

		if { ( $arraysize == $position ) && ( $position == $slot ) } {
			incr slot -1
			break
		}

		if { $arraysize == 1 } {
			break
		}

		if { $slot < $position } {
			continue
		}

		set ::ngBuyback::BuybackDataArray${player}($slot) [ set ::ngBuyback::BuybackDataArray${player}([ expr { $slot + 1 } ]) ]

		if { ( $slot == $arraysize - 1 ) || ( $slot == $max_slots - 1 ) } {
			break
		}
	}

	unset ::ngBuyback::BuybackDataArray${player}([ expr { $slot + 1 } ])
	set arraysize [ array size ::ngBuyback::BuybackDataArray${player} ]

	if { $DEBUG } {
		set tmparray ""

		foreach slot [ lsort -integer [ array names ::ngBuyback::BuybackDataArray${player} ] ] {
			append tmparray \n "slot=\"" $slot "\" ::ngBuyback::BuybackDataArray${player}($slot)=\"" [ set ::ngBuyback::BuybackDataArray${player}($slot) ] "\""
		}

		puts "$s_logDEBUG arraysize=\"$arraysize\" ::ngBuyback::BuybackDataArray${player}=\"$tmparray\""
		unset tmparray
	}



	if { ! $arraysize } {
		set BuybackDataArray [ lsort -integer -unique [ lreplace $BuybackDataArray $index $index ] ]
	}

	unset index
	unset arraysize
	unset slot
}


#
#	proc ::ngBuyback::reset { player }
#
# Internal procedure to reset the player data array
#
proc ::ngBuyback::reset { player } {
	variable DEBUG
	variable gm_level
	variable BuybackDataArray
	variable NPCDataArray

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc reset{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	if { [ ::GetPlevel $player ] < $::ngBuyback::gm_level } {
		return $::ngBuyback::l_rst01
	}

	if { ! [ info exists BuybackDataArray ] || ! [ llength $BuybackDataArray ] } {
		return $::ngBuyback::l_rst02
	}

	foreach player $BuybackDataArray {
		array unset ::ngBuyback::BuybackDataArray${player}
	}

	array unset NPCDataArray
	unset BuybackDataArray
	return $::ngBuyback::l_rst03
}


#
#	proc ::ngBuyback::serverinfo { }
#
# Internal procedure to inform the client of what server plugin we are
#
proc ::ngBuyback::serverinfo { } {
	variable DEBUG
	variable NGBUYBACK_ID
	variable VERSION

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc serverinfo{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	return "$NGBUYBACK_ID\r$VERSION"
}


#
#	proc ::ngBuyback::filltab { player tab }
#
# Internal procedure to setup the displayed tab
#
proc ::ngBuyback::filltab { player tab } {
	variable DEBUG
	variable LOG
	variable LOG_FILE
	variable BuybackDataArray
	variable ERR_BUYBACK_ERR
	variable TAB_MERCHANT
	variable TAB_BUYBACK
	variable NPCDataArray

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc filltab{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	if { $tab != $TAB_MERCHANT && $tab != $TAB_BUYBACK } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_err01"
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_err01"
	}

	set NPCDataArray($player) [ ::GetSelection $player ]

	if { ! $NPCDataArray($player) } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_fil01"
		}

		if { $LOG } {
			::Custom::Log "[ ::GetName $player ] ($player) @ [ ::GetPos $player ]: $::ngBuyback::c_fil01 (NPC= \"$NPCDataArray($player)\") \[filltab\{\}\]" $LOG_FILE
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_fil01"
	}

	set npctype [ ::GetObjectType $NPCDataArray($player) ]
	set npcflags [ ::GetNpcflags $NPCDataArray($player) ]

	if { $npctype != 3 || ! [ expr { ( $npcflags & 4 ) >> 2 } ] } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_fil01"
		}

		if { $LOG } {
			::Custom::Log "[ ::GetName $player ] ($player) @ [ ::GetPos $player ]: $::ngBuyback::c_fil01 (NPC= \"$NPCDataArray($player)\", NPC type=\"$npctype\", NPC flags=\"$npcflags\") \[filltab\{\}\]" $LOG_FILE
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_fil01"
	}

	if { $DEBUG } {
		puts "$s_logDEBUG npcflags=\"$npcflags\""
	}

	append result $tab

	if { ! [ info exists BuybackDataArray ] || ! [ llength $BuybackDataArray ] } {
		return $result
	}

	set usable_flag 1

	if { [ lsearch -integer -exact $BuybackDataArray $player ] != -1 } {
		foreach slot [ lsort -integer [ array names ::ngBuyback::BuybackDataArray${player} ] ] {
			foreach { item_id item_icon item_count } [ set ::ngBuyback::BuybackDataArray${player}($slot) ] {}

			set max_count [ ::GetScpValue "items.scp" "item $item_id" "stackable" ]
			set item_price [ GetScpValue "items.scp" "item $item_id" "sellprice" ]
			set item_price [ expr { [ string is digit -strict $item_price ] ? $item_price : 0 } ]
			append result \r [ lindex [ ::GetScpValue "items.scp" "item $item_id" "name" ] 0 ] "#" $item_icon "#" [ expr { $item_price * $item_count } ] "#" $item_count "#" [ expr { $item_count == 1 ? [ expr { $max_count == 1 ? 0 : 1 } ] : $max_count } ] "#" $usable_flag
			unset item_id
			unset item_icon
			unset item_count
			unset max_count
			unset item_price
		}
	}

	unset usable_flag
	return $result
}


#
#	proc ::ngBuyback::sell { player iteminfo }
#
# Internal procedure to make the actual sale
#
proc ::ngBuyback::sell { player iteminfo } {
	variable DEBUG
	variable ACTIVE
	variable SOULBOUND
	variable LOG
	variable LOG_FILE
	variable BuybackDataArray
	variable NPCDataArray
	variable max_slots
	variable ERR_QUEST_ITEM
	variable ERR_NO_INTEREST
	variable ERR_TOO_FAR
	variable ERR_BUYBACK_ERR
	variable ERR_BUYBACK_OK

	if { ! $ACTIVE } {
		set iteminfo [ split $iteminfo "#" ]

		foreach { item_id item_icon item_count } $iteminfo {
			set npc [ ::GetSelection $player ]

			if { ! $npc } {
				return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_fil01"
			}

			if { [ ::GetObjectType $npc ] != 3 || ! [ expr { ( [ ::GetNpcflags $npc ] & 4 ) >> 2 } ] } {
				return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_fil01"
			}

			if { [ ::Distance $player $npc ] > 5 } {
				return "$ERR_BUYBACK_ERR\r$ERR_TOO_FAR"
			}

			set item_price [ GetScpValue "items.scp" "item $item_id" "sellprice" ]
			set item_price [ expr { [ string is digit -strict $item_price ] ? $item_price : 0 } ]

			if { [ ::ConsumeItem $player $item_id $item_count ] } {
				if { ! [ ::ChangeMoney $player +[ expr { $item_price * $item_count } ] ] } {
					return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_err01"
				}
			}

			unset item_price
			unset npc
		}

		return $ERR_BUYBACK_OK
	}

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc sell{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	set iteminfo [ split $iteminfo "#" ]

	if { [ llength $iteminfo ] != 3 } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_sel01"
		}

		if { $LOG } {
			::Custom::Log "[ ::GetName $player ] ($player) @ [ ::GetPos $player ]: $s_logDEBUG $::ngBuyback::c_sel01 (ItemInfo= \"$$iteminfo\") \[sell\{\}\]" $LOG_FILE
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_sel01"
	}

	foreach { item_id item_icon item_count } $iteminfo {
		if { $DEBUG } {
			puts "$s_logDEBUG item_id=\"$item_id\" item_icon=\"$item_icon\" item_count=\"$item_count\""
		}

		if { ! [ string is digit -strict $item_id ] || ! [ string is digit -strict $item_count ] } {
			if { $DEBUG } {
				puts "$s_logDEBUG $::ngBuyback::c_sel02"
			}

			if { $LOG } {
				::Custom::Log "[ ::GetName $player ] ($player) @ [ ::GetPos $player ]: $s_logDEBUG $::ngBuyback::c_sel02 (item_id=\"$item_id\", item_icon=\"$item_icon\", item_count=\"$item_count\") \[sell\{\}\]" $LOG_FILE
			}

			return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_sel02"
		}
	}

	if { ! [ info exists NPCDataArray($player) ] } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_fil01"
		}

		if { $LOG } {
			::Custom::Log "[ ::GetName $player ] ($player) @ [ ::GetPos $player ]: $::ngBuyback::c_fil01 \[sell\{\}\]" $LOG_FILE
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_fil01"
	} elseif { ! $NPCDataArray($player) } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_fil01"
		}

		if { $LOG } {
			::Custom::Log "[ ::GetName $player ] ($player) @ [ ::GetPos $player ]: $::ngBuyback::c_fil01 (NPC= \"$NPCDataArray($player)\") \[sell\{\}\]" $LOG_FILE
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_fil01"
	}

	if { $DEBUG } {
		puts "$s_logDEBUG NPCDataArray($player)=\"$NPCDataArray($player)\""
	}

	set npcdist [ ::Distance $player $NPCDataArray($player) ]

	if { $npcdist > 5 } {
		if { $DEBUG } {
			puts "$s_logDEBUG $ERR_TOO_FAR"
		}

		if { $LOG } {
			::Custom::Log "[ ::GetName $player ] ($player) @ [ ::GetPos $player ]: $ERR_TOO_FAR (NPC distance=\"$npcdist\") \[sell\{\}\]" $LOG_FILE
		}

		return "$ERR_BUYBACK_ERR\r$ERR_TOO_FAR"
	}

	unset npcdist
	set allowbonded 1
	set bonded [ ::GetScpValue "items.scp" "item $item_id" "bonding" ]

	if { $bonded == 4 || $bonded == 5 } {
		return $ERR_QUEST_ITEM
	}

	if { [::GetPlevel $player ] < 4 && ! $SOULBOUND && ( $bonded == 1 || $bonded == 2 || $bonded == 3 ) } {
	return [::Texts::Get "You can't put a soulbounded item in buypack, drag it in the vendor window to sell the item"]
	} 

	unset bonded
	set item_price [ GetScpValue "items.scp" "item $item_id" "sellprice" ]
	set item_price [ expr { [ string is digit -strict $item_price ] ? $item_price : 0 } ]

	if { $DEBUG } {
		puts "$s_logDEBUG item_price=\"$item_price\""
	}

	if { $item_price != 0 } {
		if { $allowbonded } {
			set arraysize [ array size ::ngBuyback::BuybackDataArray${player} ]

			if { ! $arraysize } {
				lappend BuybackDataArray $player
				set BuybackDataArray [ lsort -integer -unique $BuybackDataArray ]
			}

			incr arraysize

			if { $arraysize > $max_slots } {
				::ngBuyback::array_shift $player
				incr arraysize -1
			}

			if { $DEBUG } {
				puts "$s_logDEBUG arraysize=\"$arraysize\""
			}
		}

		if { [ ::ConsumeItem $player $item_id $item_count ] } {
			if { ! [ ::ChangeMoney $player +[ expr { $item_price * $item_count } ] ] } {
				return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_err01"
			}

			if { $allowbonded } {
				set ::ngBuyback::BuybackDataArray${player}($arraysize) [ list $item_id $item_icon $item_count ]
			}
		}

		if { $allowbonded } {
			unset arraysize
			unset NPCDataArray($player)
		}

		unset item_id
		unset item_icon
		unset item_count
		unset item_price
		return $ERR_BUYBACK_OK
	}

	unset allowbonded
	unset item_id
	unset item_icon
	unset item_count
	unset item_price
	return $ERR_NO_INTEREST
}


#
#	proc ::ngBuyback::rebuy { player slot }
#
# Internal procedure to deal with the buying back of an item
#
proc ::ngBuyback::rebuy { player slot } {
	variable DEBUG
	variable BuybackDataArray
	variable ERR_BUYBACK_ERR
	variable ERR_BUYBACK_OK
	variable ERR_NO_MONEY

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc rebuy{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	if { ! [ string is digit -strict $slot ] } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_err01"
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_err01"
	} elseif { ! $slot || ! [ info exists ::ngBuyback::BuybackDataArray${player}($slot) ] } {
		return $ERR_BUYBACK_OK
	} elseif { $slot < 1 && $slot > 12 || ! [ info exists BuybackDataArray ] || ! [ llength $BuybackDataArray ] } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_err01"
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_err01"
	}

	if { [ lsearch -integer -exact $BuybackDataArray $player ] == -1 } {
		if { $DEBUG } {
			puts "$s_logDEBUG $::ngBuyback::c_err01"
		} else {
			puts "[ ::ngBuyback::logPrefix ] $::ngBuyback::c_err01"
		}

		return "$ERR_BUYBACK_ERR\r$::ngBuyback::c_err01"
	}

	foreach { item_id item_icon item_count } [ set ::ngBuyback::BuybackDataArray${player}($slot) ] {}

	if { $DEBUG } {
		puts "$s_logDEBUG item_id=\"$item_id\", item_icon=\"$item_icon\", item_count=\"$item_count\""
	}

	set item_price [ GetScpValue "items.scp" "item $item_id" "sellprice" ]
	set item_price [ expr { [ string is digit -strict $item_price ] ? $item_price : 0 } ]

	if { ! [ ::ChangeMoney $player -[ expr { $item_price * $item_count } ] ] } {
		return $ERR_NO_MONEY
	}

	::ngBuyback::array_shift $player $slot

	for { set i 0 } { $i < $item_count } { incr i } {
		::AddItem $player $item_id
	}

	unset item_id
	unset item_icon
	unset item_count
	unset item_price
	return $ERR_BUYBACK_OK
}


#
#	proc ::ngBuyback::cleanup { player }
#
# Internal procedure to clean the player data
#
proc ::ngBuyback::cleanup { player } {
	variable DEBUG
	variable BuybackDataArray
	variable NPCDataArray
	variable ChallengeDataArray

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc cleanup{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	if { ! [ info exists BuybackDataArray ] || ! [ llength $BuybackDataArray ] } {
		return
	}

	set index [ lsearch -integer -exact $BuybackDataArray $player ]

	if { $index != -1 } {
		array unset ::ngBuyback::BuybackDataArray${player}
		array unset ChallengeDataArray $player
		array unset NPCDataArray $player
		set BuybackDataArray [ lsort -integer -unique [ lreplace $BuybackDataArray $index $index ] ]
	}

	unset index
	return
}


#
#	proc ::ngBuyback::onlogin { }
#
# Internal procedure to run at player login
#
proc ::ngBuyback::onlogin { to from spellid } {
	variable DEBUG
	variable ACTIVE

	if { ! $ACTIVE } {
		return
	}

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc onlogin{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	::ngBuyback::cleanup $from
}


#
#	proc ::ngBuyback::process { player cargs }
#
# Master procedure redirects to the local ones
#
# ( add the line:
#
# "buyback" { return [ ::ngBuyback::process $player $cargs }
#
# inside:
#
# switch [string tolower $command]
#
# in:
#
# namespace eval WoWEmu
#
# inside tcl/commands.tcl )
#
proc ::ngBuyback::process { player cargs } {
	variable DEBUG
	variable ACTIVE

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc process{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
		puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
	}

	set cargs [ string trim $cargs ]
	set option [ string tolower [ lindex $cargs 0 ] ]

	switch $option {
		"sell" {
			return [ ::ngBuyback::sell $player [ lindex $cargs 1 ] ]
		}
		"on" -
		"off" {
			return [ ::ngBuyback::switcher $player $cargs ]
		}
		"version" {
			return [ ::ngBuyback::version ]
		}
		"help" -
		"" {
			return [ ::ngBuyback::help $player ]
		}
	}

	if { ! $ACTIVE } {
		return
	}

	switch $option {
		"serverinfo" {
			return [ ::ngBuyback::serverinfo ]
		}
		"filltab" {
			return [ ::ngBuyback::filltab $player [ lindex $cargs 1 ] ]
		}
		"rebuy" {
			return [ ::ngBuyback::rebuy $player [ lindex $cargs 1 ] ]
		}
		"reset" {
			return [ ::ngBuyback::reset $player ]
		}
		default {
			return $::ngBuyback::c_err01
		}
	}
}


#
#	proc ::ngBuyback::readConf { config }
#
# Internal procedure to read the configuration file and set the system
#
proc ::ngBuyback::readConf { config } {
	variable DEBUG
	variable MIN_CUSTOM_VERSION
	variable LANG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc readConf{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	foreach { section data } [ ::Custom::ReadConf $config ] {
		if { [ string tolower $section ] == "global" } {
			foreach { key value } $data {
				set key [ string tolower $key ]

				switch $key {
					"lang" {
						if { [ string tolower $value ] != "default" } {
							set LANG $value
						}
					}
					"log" {
						if { [ string tolower $value ] != "default" } {
							set LOG $value
						}
					}
					"logfile" {
						if { [ string tolower $value ] != "default" } {
							set LOG_FILE $value
						}
					}
					"debug" {
						set value [ string tolower $value ]

						if { $value != "default" } {
							if { $value == "yes" || $value == "on" || $value == "true" || $value == 1 } {
								set DEBUG 1
							} elseif { $value == "no" || $value == "off" || $value == "false" || $value == 0 } {
								set DEBUG 0
							}

							if { $DEBUG } {
								set s_logDEBUG "[ ::ngBuyback::logDebug ] proc readConf{}:"
							}
						}
					}
					"soulbound" {
						set value [ string tolower $value ]

						if { $value == "no" || $value == "off" || $value == "false" || $value == 0 } {
							set ::ngBuyback::SOULBOUND 0
						}
					}
					"pluginactive" {
						set value [ string tolower $value ]

						if { $value == "no" || $value == "off" || $value == "false" || $value == 0 } {
							set ::ngBuyback::ACTIVE 0
						}
					}
					default {
						if { [ info exists ::ngBuyback::$key ] } {
							if { [ string tolower $value ] != "default" } {
								set ::ngBuyback::$key $value
							}
						}
					}
				}
			}
		}

		set LANG [ expr { [ string tolower $LANG ] == "default" ? "en" : $LANG } ]

		if { [ string tolower $section ] == [ string tolower $LANG ] } {
			foreach { key value } $data {
				set key [ string tolower $key ]

				if { [ info exists ::ngBuyback::$key ] } {
					set ::ngBuyback::$key $value
				}
			}
		}
	}
}


#
#	proc ::ngBuyback::legacy { player cargs }
#
# Internal procedure to reply to legacy Buyback System clients
#
proc ::ngBuyback::legacy { player cargs } {
	variable DEBUG
	variable ACTIVE

	if { ! $ACTIVE } {
		return
	}

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc legacy{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	return [ format "%s\n%s\n\n" $::ngBuyback::l_leg01 $::ngBuyback::l_leg02 ]
}


#
#	proc ::ngBuyback::commands { }
#
# Internal procedure to create the commands needed to run the script
#
proc ::ngBuyback::commands { } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc commands{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	::Custom::AddCommand "buyback" ::ngBuyback::process

	::Custom::AddCommand {
		"getbackitem" ::ngBuyback::legacy 0
		"getbinditem" ::ngBuyback::legacy 0
		"sellitem" ::ngBuyback::legacy 0
		"buybackitem" ::ngBuyback::legacy 0
		"create_buybackdb" ::ngBuyback::legacy 0
		"version_buyback" ::ngBuyback::legacy 0
	}
}


#
#	proc ::ngBuyback::init { }
#
# Internal procedure to setup the program
#
proc ::ngBuyback::init { } {
	variable DEBUG
	variable MIN_CUSTOM_VERSION
	variable conf

	if { [ info exists "::StartTCL::VERSION" ] } {
		set DEBUG $::DEBUG
		set ::ngBuyback::VERBOSE $::VERBOSE
		set ::ngBuyback::LANG $::LANG
	}

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngBuyback::logDebug ] proc init{}:"
		puts "$s_logDEBUG $::ngBuyback::c_dbg01"
	}

	if { [ ::Custom::GetScriptVersion "StartTCL" ] >= "0.9.0" } {
		::StartTCL::Require "Custom" $MIN_CUSTOM_VERSION
		::StartTCL::Provide $::ngBuyback::NAME $::ngBuyback::VERSION
	}

	if { [ ::Custom::GetScriptVersion "Custom" ] < $MIN_CUSTOM_VERSION } {
		if { $DEBUG } {
			return -code error [ format "%s %s %s" $s_logDEBUG $::ngBuyback::c_rcf01 $MIN_CUSTOM_VERSION ]
		} else {
			return -code error [ format "%s %s %s" [ ::ngBuyback::logPrefix ] $::ngBuyback::c_rcf01 $MIN_CUSTOM_VERSION ]
		}
	}

	::ngBuyback::commands
	::ngBuyback::readConf $conf
	::Custom::AddSpellScript "::ngBuyback::onlogin" 836
}


#
#	startup time command execution
#
# Run the "init" procedure at server start
#
::ngBuyback::init
