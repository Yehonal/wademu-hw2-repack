# StartTCL: n
#
#
# This file is part of the StartTCL Startup System
#
# StartTCL is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
# StartTCL is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
#
# StartTCL is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
#
# StartTCL is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA. You can also consult
# the terms of the license at:
#
#		<http://www.gnu.org/copyleft/lesser.html>
#
#
# Name:		GmTools.tcl
#
# Description:	GM utility commands using ngconsole or dbconsole
#
# Based on WoWEmu GmTools 1.0.4 by <faerion@eggdrop.org.ru> of which this is a
# derivative work, though fully compatible with. The documentation and
# changelog for the version on which this was originaly derived from can be
# found in a companion document named "gmtools.txt"
#
#


namespace eval ::GmTools {
	variable VERSION 1.1.3

	foreach tool { "ngconsole.exe" "dbconsole.exe" } {
		foreach dir { "." "bin" $::StartTCL::basedir $::StartTCL::SCRIPTS_DIR } {
			if { [ file exists "$dir/$tool" ] } {
				variable ngconsole "$dir/$tool"
				break
			}
		}
		if { [ info exists ngconsole ] } {
			break
		}
	}

	#
	# ngconsole dependent commands
	#
	if { [ info exists ngconsole ] } {
		::Custom::AddCommand {
			"pass" ::GmTools::cPass 0
			"accinfo" ::GmTools::cAccInfo 2
			"chpass" ::GmTools::cChPass 2
			"+ban" ::GmTools::cBan 4
			"+lock" ::GmTools::cLock 4
			"-ban" ::GmTools::cUnBan 4
			"-lock" ::GmTools::cUnLock 4
			"kickban" ::GmTools::cKickBan 4
			"+acc" ::GmTools::cAddAccount 6
			"-acc" ::GmTools::cDelAccount 6
			"acclist" ::GmTools::cAccounts 6
			"banlist" ::GmTools::cBans 6
			"plevel" ::GmTools::cSetPlevel 6
		}
	} else {
		::Custom::Error "ngConsole is not installed"
	}

	#
	# other commands
	#
	::Custom::AddCommand {
		"+qflag" ::GmTools::cSetQFlag 2
		"-qflag" ::GmTools::cClearQFlag 2
		"cast" ::GmTools::cCastSpell 2
		"emote" ::GmTools::cEmote 2
		"go" ::GmTools::cGo 2
		"gospawn" ::GmTools::cGoSpawn 2
		"aggro" ::GmTools::cAggro 4
		"damage" ::GmTools::cDamage 4
		"repu" ::GmTools::cReputation 4
		"untalent" ::GmTools::cUntalent 4
		"eval" ::GmTools::cEval 6
	}

	#
	# hook the needed code for the ".aggro" command
	#
	::Custom::HookProc "::AI::ModAgro" {
		if { [ ::GetQFlag $victim NoAggro ] } {
			return 0
		}
	}

	#
	# hook the needed code for the ".damage" command
	#
	::Custom::HookProc "::WoWEmu::ModDR" {
		if { [ ::GetQFlag $player NoDamage ] } {
			return 1.
		}
	}

	#
	# hook the needed variable for the ".eval" command
	#
	::Custom::HookProc "::WoWEmu::Command" {
		set ::WoWEmu::oargs $args
	}

	::StartTCL::Provide
}


# procedures requiring ngconsole
if { [ info exists ::GmTools::ngconsole ] } {

#
#	proc ::GmTools::_ngconsole { command }
#
proc ::GmTools::_ngconsole { command } {
	variable ngconsole
	set r ""
	set fp [ open "| $ngconsole $command" ]

	while { ! [ eof $fp ] } {
		set data ""

		catch {
			set data [ read $fp ]
		}

		append r $data
	}

	catch {
		close $fp
	}

	return $r
}


#
#	proc ::GmTools::gtGetAccountInfo { account }
#
proc ::GmTools::gtGetAccountInfo { account } {
	set r 0
	set status ""
	set data [ _ngconsole "find $account" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		regexp -nocase -- {<id>(.*?)</id>} $data gr id
		regexp -nocase -- {<name>(.*?)</name>} $data gr name
		regexp -nocase -- {<password>(.*?)</password>} $data gr pass
		regexp -nocase -- {<last_ip>(.*?)</last_ip>} $data gr ip
		set chars {}
		regexp -nocase -- {<chars>(.*?)</chars>} $data gr tchars
	       	regsub -all -- \n $tchars {} tchars
        	set tchars [ string map { </char> </char>\n } $tchars ]

		foreach line [ split $tchars \n ] {
			set char ""
			regexp -nocase -- {<char>(.*?)</char>} $line gr char

			if { [ string length $char ] } {
				lappend chars $char
			}
		}

		regexp -nocase -- {<plevel>(.*?)</plevel>} $data gr plevel
		regexp -nocase -- {<banned>(.*?)</banned>} $data gr banned
		regexp -nocase -- {<locked>(.*?)</locked>} $data gr locked
		regexp -nocase -- {<last_access>(.*?)</last_access>} $data gr access
		set r [ list $id $name $pass $ip $chars $plevel $banned $locked $access ]
	}

	return $r
}


#
#	proc ::GmTools::gtSetPassword { account password }
#
proc ::GmTools::gtSetPassword { account password } {
	set r 0; set status ""
	set data [ _ngconsole "password $account $password" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtAddAccount { account password }
#
proc ::GmTools::gtAddAccount { account password } {
	set r 0
	set status ""
	set data [ _ngconsole "add $account $password" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtDelAccount { account }
#
proc ::GmTools::gtDelAccount { account } {
	set r 0
	set status ""
	set data [ _ngconsole "del $account" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtSetPlevel { account plevel }
#
proc ::GmTools::gtSetPlevel { account plevel } {
	set r 0
	set status ""
	set data [ _ngconsole "plevel $account $plevel" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtGetAccount { guid }
#
proc ::GmTools::gtGetAccount { guid } {
	variable AccountArray

	if { [ info exists AccountArray($guid) ] } {
		return $AccountArray($guid)
	}

	set name 0
	set data [ _ngconsole "getacc $guid" ]
	regexp -nocase -- {<name>(.*?)</name>} $data gr name
	set AccountArray($guid) $name

	return $name
}


#
#	proc ::GmTools::gtBan { account }
#
proc ::GmTools::gtBan { account } {
	set r 0
	set status ""
	set data [ _ngconsole "ban $account" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtUnBan { account }
#
proc ::GmTools::gtUnBan { account } {
	set r 0
	set status ""
	set data [ _ngconsole "unban $account" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtLock { account }
#
proc ::GmTools::gtLock { account } {
	set r 0
	set status ""
	set data [ _ngconsole "lock $account" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtUnLock { account }
#
proc ::GmTools::gtUnLock { account } {
	set r 0
	set status ""
	set data [ _ngconsole "unlock $account" ]
	regexp -nocase -- {<status>(.*?)</status>} $data gr status

	if { ! [ string compare $status successfully ] } {
		set r 1
	}

	return $r
}


#
#	proc ::GmTools::gtAccounts {}
#
proc ::GmTools::gtAccounts { {cargs "0 0"} } {
	set r {}
	set data [ _ngconsole "list $cargs" ]
	regsub -all -- "\ " $data {} data

	if { [ regexp -nocase -- {<accounts>(.*?)</accounts>} $data gr data ] } {
	       	regsub -all -- \n $data {} data
        	set data [ string map { </account> </account>\n } $data ]

		 foreach line [ split $data \n ] {
			if { [ string length $line ] } {
				regexp -nocase -- {<name>(.*?)</name>} $line gr name
				regexp -nocase -- {<plevel>(.*?)</plevel>} $line gr plevel
				regexp -nocase -- {<banned>(.*?)</banned>} $line gr banned
				set account [list $name $plevel $banned]
				lappend r $account
			}
		}
	}

	set r [ lsort -ascii $r ]
	return $r
}


#
#	proc ::GmTools::gtBans {}
#
proc ::GmTools::gtBans { {cargs "0 0"} } {
	set r {}
	set data [ _ngconsole "list $cargs" ]
	regsub -all -- "\ " $data {} data

	if { [ regexp -nocase -- {<accounts>(.*?)</accounts>} $data gr data ] } {
	       	regsub -all -- \n $data {} data
        	set data [string map { </account> </account>\n } $data]

		 foreach line [ split $data \n ] {
			if { [ string length $line ] } {
				regexp -nocase -- {<name>(.*?)</name>} $line gr name
				regexp -nocase -- {<plevel>(.*?)</plevel>} $line gr plevel
				regexp -nocase -- {<banned>(.*?)</banned>} $line gr banned
				set account [list $name $plevel $banned]
				if { $banned != 0 } {
					lappend r $account
				}
			}
		}
	}

	set r [ lsort -ascii $r ]
	return $r
}


#
#	proc ::GmTools::gtGossip { player args }
#
proc ::GmTools::gtGossip { player args } {
	set selection [ ::GetSelection $player ]
	if { [ ::GetObjectType $selection ] && [ ::Distance $player $selection ] <= 5 } {
		set target $selection
	} else {
		set target $player
	}
	::SendGossipComplete $player
	::SendSwitchGossip $player $target 0
	eval "::SendGossip ${player} ${target} [ join $args ]"

	set out {}
	foreach arg [ join $args ] {
		lappend out [ lindex $arg 2 ]
	}

	return [ join $out \n ]
}


#
#	proc ::GmTools::cAccounts { player cargs }
#
proc ::GmTools::cAccounts { player cargs } {

	if { $cargs == "" } {
		set cargs "0 100"
	}

	set al [ ::GmTools::gtAccounts $cargs ]
	set count [ llength $al ]
	set ml {}

	foreach account $al {
		foreach { ptext plevel banned } $account {}

		if { $plevel > 0 } {
			set ptext "$ptext (plevel $plevel)"
		}

		if { $banned } {
			set ptext "$ptext |cffff2020BANNED|r"
		}

		set param "\{ text 5 \"$ptext\" \}"
		lappend ml $param
	}

	set ml [ join $ml " " ]
	set header [ ::Texts::Get "accounts_on_server" $count ]
	::GmTools::gtGossip $player "\{ text 0 \"$header\" \} ${ml}"
}


#
#	proc ::GmTools::cBans { player cargs }
#
proc ::GmTools::cBans { player cargs } {

	if { $cargs == "" } {
		set cargs "0 100"
	}

	set bl [ ::GmTools::gtBans $cargs ]
	set count [ llength $bl ]
	set ml {}

	foreach account $bl {
		set ptext [ lindex $account 0 ]
		set param "\{ text 5 \"$ptext\" \}"
		lappend ml $param
	}

	set ml [ join $ml " " ]
	set header [ ::Texts::Get "bans_on_server" $count ]
	::GmTools::gtGossip $player "\{ text 0 \"$header\" \} ${ml}"
}


#
#	proc ::GmTools::cBan { player cargs }
#
proc ::GmTools::cBan { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		set account [ ::GmTools::gtGetAccountInfo [ lindex $cargs 0 ] ]

		if { $account == 0 } {
			return ERROR
		}

	        if { [ ::GmTools::gtGetAccount [ ::GetGuid $player ] ] == [ lindex $account 1 ] } {
	        	return [ ::Texts::Get "can_not_ban_self" ]
	        }

		if { [ ::GetPlevel $player ] <= [ lindex $account 5 ] } {
			return [ ::Texts::Get "plevel_conflict" ]
		}

		set r [ ::GmTools::gtBan [ lindex $account 1 ] ]

		if { $r } {
			return [ ::Texts::Get "banned_account" [ lindex $account 1 ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cDelAccount { player cargs }
#
proc ::GmTools::cDelAccount { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		set account [ ::GmTools::gtGetAccountInfo [ lindex $cargs 0 ] ]

		if { $account==0 } {
			return ERROR
		}

		if { [ ::GmTools::gtGetAccount [ ::GetGuid $player ] ] == [ lindex $account 1 ] } {
			return [ ::Texts::Get "can_not_del_self" ]
		}

		if { [ ::GetPlevel $player ] <= [ lindex $account 5 ] } {
			return [ ::Texts::Get "plevel_conflict" ]
		}

		set r [ ::GmTools::gtDelAccount [ lindex $account 1 ] ]

		if { $r } {
			return [ ::Texts::Get "deleted_account" [ lindex $account 1 ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cAddAccount { player cargs }
#
proc ::GmTools::cAddAccount { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		if { [ ::GmTools::gtGetAccountInfo [ lindex $cargs 0 ] ] != 0 } {
			return [ ::Texts::Get "account_exists" [ string toupper [ lindex $cargs 0 ] ] ]
		}

		set r [ ::GmTools::gtAddAccount [ lindex $cargs 0 ] [ lindex $cargs 1 ] ]

		if { $r } {
			return [ ::Texts::Get "added_account" [ string toupper [ lindex $cargs 0 ] ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cLock { player cargs }
#
proc ::GmTools::cLock { player cargs } {
	set cargs [split $cargs ]

	if { [ llength $cargs ] } {
		set account [ ::GmTools::gtGetAccountInfo [ lindex $cargs 0 ] ]

		if { $account==0 } {
			return ERROR
		}

		if { [ ::GmTools::gtGetAccount [ ::GetGuid $player ] ] == [ lindex $account 1 ] } {
			return [ ::Texts::Get "can_not_lock_self" ]
		}

		if { [ ::GetPlevel $player ] <= [ lindex $account 5 ] } {
			return [ ::Texts::Get "plevel_conflict" ]
		}

		set r [ ::GmTools::gtLock [ lindex $account 1 ] ]

		if { $r } {
			return [ ::Texts::Get "locked_account" [ lindex $account 1 ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cKickBan { player cargs }
#
proc ::GmTools::cKickBan { player cargs } {
	set selection [ ::GetSelection $player ]

	if { [ ::GetObjectType $selection ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	if { $player == $selection } {
        	return [ ::Texts::Get "can_not_ban_self" ]
	}

	if { [ ::GetPlevel $player] <= [ ::GetPlevel $selection ] } {
		return [ ::Texts::Get "plevel_conflict" ]
	}

	set account [ ::GmTools::gtGetAccount [ ::GetGuid $selection ] ]
	set r [ ::GmTools::gtBan $account ]

	if { $r } {
		::KickPlayer $selection
		return [ ::Texts::Get "banned_account" $account ]
	} else {
		return ERROR
	}
}


#
#	proc ::GmTools::cUnBan { player cargs }
#
proc ::GmTools::cUnBan { player cargs } {
	if { [ string length $cargs ] } {
		set account [ lindex [ split $cargs ] 0 ]
		set r [ ::GmTools::gtUnBan $account ]

		if { $r } {
			return [ ::Texts::Get "unbanned_account" [ string toupper $account ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cUnLock { player cargs }
#
proc ::GmTools::cUnLock { player cargs } {
	if { [ string length $cargs ] } {
	        set account [ lindex [ split $cargs ] 0 ]
		set r [ ::GmTools::gtUnLock $account ]

		if { $r } {
			return [ ::Texts::Get "unlocked_account" [ string toupper $account ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cPass { player cargs }
#
proc ::GmTools::cPass { player cargs } {
	if { [ string length $cargs ] } {
		set account [ ::GmTools::gtGetAccount [ ::GetGuid $player ] ]
		set password $cargs
		set r [ ::GmTools::gtSetPassword $account $password ]

		if { $r } {
			return [ ::Texts::Get "changed_password" $account ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cSetPlevel { player cargs }
#
proc ::GmTools::cSetPlevel { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		set account [ ::GmTools::gtGetAccountInfo [ lindex $cargs 0 ] ]
		set plevel [ ::GetPlevel $player ]

		if { $account == 0 } {
			return ERROR
		}

	        if { [ ::GmTools::gtGetAccount [ ::GetGuid $player ] ] == [ lindex $account 1 ] } {
	        	return [ ::Texts::Get "can_not_level_self" ]
	        }

		if { ( $plevel <= [ lindex $account 5 ] ) || ( $plevel <= [ lindex $cargs 1 ] ) } {
			return [ ::Texts::Get "plevel_conflict" ]
		}

		set r [ ::GmTools::gtSetPlevel [ lindex $account 1 ] [ lindex $cargs 1 ] ]

		if { $r } {
			return [ ::Texts::Get "changed_plevel" [ lindex $account 1 ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cChPass { player cargs }
#
proc ::GmTools::cChPass { player cargs } {
	set cargs [split $cargs ]

	if { [ llength $cargs ] } {
		set account [ ::GmTools::gtGetAccountInfo [ lindex $cargs 0 ] ]

		if { $account == 0 } {
			return ERROR
		}

	        if { [ ::GmTools::gtGetAccount [ ::GetGuid $player ] ] != [ lindex $account 1 ] } {
			if { [ ::GetPlevel $player ] <= [ lindex $account 5 ] } {
				return [ ::Texts::Get "plevel_conflict" ]
			}
		}

		set r [::GmTools::gtSetPassword [ lindex $account 1 ] [ lrange [ split $cargs ] 1 end ] ]

		if { $r } {
			return [ ::Texts::Get "changed_password" [ lindex $account 1 ] ]
		} else {
			return ERROR
		}
	}
}


#
#	proc ::GmTools::cAccInfo { player cargs }
#
proc ::GmTools::cAccInfo { player cargs } {
	set account 0
	set cargs [split $cargs ]

	if { [llength $cargs] } {
		set account [ ::GmTools::gtGetAccountInfo [ lindex $cargs 0 ] ]

		if { $account == 0 } {
			return ERROR
		}
	}

	if { $account == 0 } {
		set selection [ ::GetSelection $player ]
		if { [ ::GetObjectType $selection ] != 4 } {
			return [ ::Texts::Get "select_player" ]
		}

		set account [ ::GmTools::gtGetAccountInfo [ ::GmTools::gtGetAccount [ ::GetGuid $selection ] ] ]
	}

	if { $account != 0 } {
		set name [ lindex $account 1 ]
		set plevel [ lindex $account 5 ]
		set chars [ llength [ lindex $account 4 ] ]

		if  { [ lindex $account 6 ] } {
			set banned "|cffff2020YES|r"
		} else {
			set banned "NO"
		}

		if  { [ lindex $account 7 ] } {
			set locked "|cffff2020YES|r"
		} else {
			set locked "NO"
		}

		set last_access [ lindex $account 8 ]

		if { $last_access == "0000-00-00 00:00:00" || $last_access == "01.01.1970" } {
			set last_access "|cffff2020NEVER|r"
		}

		set last_ip [ lindex $account 3 ]

		if { $last_ip == "" || $last_ip == "0.0.0.0" } {
			set last_ip "|cffff2020NONE|r"
		}

		::GmTools::gtGossip $player "\{ text 0 \"Information for account $name\" \}\
				\{ text 5 \"Plevel: $plevel\" \}\
				\{ text 5 \"Chars: $chars\" \}\
				\{ text 5 \"Banned: $banned\" \}\
				\{ text 5 \"Locked: $locked\" \}\
				\{ text 5 \"Last access: $last_access\" \}\
				\{ text 5 \"Last ip: $last_ip\" \}"
	}
}

# end of procedures requiring ngconsole
}


#
#	proc ::GmTools::cSetQFlag { player cargs }
#
proc ::GmTools::cSetQFlag { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		::SetQFlag $player [ lindex $cargs 0 ]
		return OK
	}

	return ERROR
}


#
#	proc ::GmTools::cClearQFlag { player cargs }
#
proc ::GmTools::cClearQFlag { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		::ClearQFlag $player [ lindex $cargs 0 ]
		return OK
	}

	return ERROR
}


#
#	proc ::GmTools::cEval { player cargs }
#
proc ::GmTools::cEval { player cargs } {
	set ::p $player
	set ::s [ ::GetSelection $::p ]
	set ::WoWEmu::oargs [ lrange [ split $::WoWEmu::oargs ] 3 end-1 ]

	if { [ catch { return [ uplevel "#0" eval $::WoWEmu::oargs ] } err ] } {
		return $err
	}
}


#
#	proc ::GmTools::cCastSpell { player cargs }
#
proc ::GmTools::cCastSpell { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		set selection [ ::GetSelection $player]

	        switch [ ::GetObjectType $selection ] {
	        	3 -
	        	4 {
	        		set r [ ::CastSpell $player $selection $cargs ]
	        	}
			default {
				return ERROR
			}
		}

		if { $r } {
			return OK
		} else {
			return ERROR
		}
	}

	return ERROR
}


#
#	proc ::GmTools::cEmote { player cargs }
#
proc ::GmTools::cEmote { player cargs } {
	set cargs [ split $cargs ]

	if { [ llength $cargs ] } {
		set selection [ ::GetSelection $player ]

	        switch [ ::GetObjectType $selection ] {
	        	3 -
	        	4 {
	        		::Emote $selection $cargs
	        	}
			default {
				return ERROR
			}
		}

		return OK
	}

	return ERROR
}


#
#	proc ::GmTools::cGo { player cargs }
#
proc ::GmTools::cGo { player cargs } {
	if { [ llength $cargs ] < 4 } {
		set selection [ ::GetSelection $player ]
		set type [ ::GetObjectType $selection ]

		if { ( $type == 3 || $type == 4 ) } {
			::Custom::TeleportPos $player [ ::GetPos $selection ]
			return OK
		}

		return [ ::Texts::Get "not_enough_parms" ]
	}

	return [ ::WoWEmu::Commands::go $player $cargs ]
}


#
#	proc ::GmTools::cGoSpawn { player cargs }
#
proc ::GmTools::cGoSpawn { player cargs } {
	set selection [ ::GetSelection $player ]

	if { [ ::GetObjectType $selection ] == 3 } {
		set spawn [ ::GetLinkObject $selection ]

		if { $spawn } {
			::Custom::TeleportPos $player [ ::GetPos $spawn ]
			return OK
		}
	}

	return ERROR
}


#
#	proc ::GmTools::cReputation { player cargs }
#
# change reputation towards a selected NPC
#
proc ::GmTools::cReputation { player cargs } {
	set target [ ::GetSelection $player ]

	if { [ ::GetObjectType $target ] != 3 } {
		return [ ::Texts::Get "select_npc" ]
	}

	if { [ string is integer -strict $cargs ] } {
		::AddReputation $player $target $cargs
	}

	return [ ::Texts::Get "reputation_with" [ ::Custom::GetNpcName $target ] [ ::Custom::GetFaction $target ] [ ::GetReputation $player $target ] ]
}


#
#	proc ::GmTools::cUntalent { player cargs }
#
# reset talent points for a selected player
#
proc ::GmTools::cUntalent { player cargs } {
        set target [ ::GetSelection $player ]
        set lvl [::GetLevel $target]
	set spellid 14867 
        set money [expr { $lvl*2000 }]
        set cost [expr {$money-20000}]
        

	switch -- [ string tolower $cargs ] {
		"" {
		}
		"free" {
			set cost 0
		}
		default {
			return [ ::Texts::Get "untalent_help" ]
		}
	}

	if { ! [ llength [ join [ ::GetScpValue "spellcost.scp" "spell $spellid" "delspell" ] ] ] } {
		return [ ::Texts::Get "missing_delspell_keys" $spellid ]
	}

	

	if { [ ::GetObjectType $target ] != 4 } {
		return [ ::Texts::Get "select_player" ]
	}

	set points [ expr { [ ::GetLevel $target ] - 9 } ]

	if { $points < 0 } {
		return [ ::Texts::Get "too_low_level" [ ::GetName $target ] ]
	}

	if { $cost && ! [ ::ChangeMoney $target -$cost ] } {
		return [ ::Texts::Get "not_enough_money" [ ::GetName $target ] $cost ]
	} 
        set argenti [expr {$cost/100 }]
        
	::LearnSpell $target $spellid
	Say $target 0 "|c00FF0000 Il reset dei talenti mi e' costato $argenti silver |r" 
        return [ ::WoWEmu::Commands::setcp $player $points ]
}


#
# logging of commands (this must be called after the procedure definition)
#
::Custom::LogCommand "untalent"


#
#	proc ::GmTools::cAggro { player cargs }
#
# allow a GM to turn aggro on or off
#
proc ::GmTools::cAggro { player cargs } {
	switch -- $cargs {
		"on" {
			::ClearQFlag $player NoAggro
			return [ ::Texts::Get "aggro_on" ]
		}
		"off" {
			::SetQFlag $player NoAggro
			return [ ::Texts::Get "aggro_off" ]
		}
		"help" {
			return [ ::Texts::Get "aggro_help" ]
		}
		default {
			if { [ ::GetQFlag $player NoAggro ] } {
				return [ ::Texts::Get "aggro_off" ]
			} else {
				return [ ::Texts::Get "aggro_on" ]
			}
		}
	}
}


#
#	proc ::GmTools::cDamage { player cargs }
#
# allow a GM to turn damage on or off
#
proc ::GmTools::cDamage { player cargs } {
	switch -- $cargs {
		"on" {
			::ClearQFlag $player NoDamage
			return [ ::Texts::Get "damage_on" ]
		}
		"off" {
			::SetQFlag $player NoDamage
			return [ ::Texts::Get "damage_off" ]
		}
		"help" {
			return [ ::Texts::Get "damage_help" ]
		}
		default {
			if { [ ::GetQFlag $player NoDamage ] } {
				return [ ::Texts::Get "damage_off" ]
			} else {
				return [ ::Texts::Get "damage_on" ]
			}
		}
	}
}


