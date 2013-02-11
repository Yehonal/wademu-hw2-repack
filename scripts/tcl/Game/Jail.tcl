# Start-TCL: n

#
#
#
# This program is (c) 2006 by Aceindy <aceindy@gmail.com>
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
#               <http://www.gnu.org/copyleft/lesser.html>
#
#
# A lot of code of this program is based on the Lazarus Long's ngauction.scl
# who graciously allowed the licensing of this derivated work under the
# above License. This does not imply that the original code nor its
# versions are under the same license as long as they don't include
# code specific from this program. Only this program and derivated work from it
# are subject to the above License. The original code is (c)Lazarus Long
# and you must contact him for licensing details.
#
#
# Name:					ngjail.tcl
#
# StartDate:		2006-04-23
# Last UpDate:	2006-09-15
#
# Description:	NextGen Jailing System
#
# Author:	AceIndy  <aceindy@gmail.com>
#
#
# YOU MUST remove old jail procedure from uwc134 script
# before using this script, delete (or rename) the following procedure
#
# proc ::WoWEmu::Commands::jail {player cargs} {
#				.....
#     	}
#
# from scripts\tc\api\WoWEmu_Commands.tcl
#  (in older versions located in AAAWoWemu.tcl and called proc jail. 
#  THIS IS NOT TESTED on older versions though!!!
#  if you decide to try, let me know if it works)
#
# syntax: .jail for <hrs> <reason>		 				[GMlvl4]  jails selected player 
#					.jail name <name> 									[GMlvl4]  Name of offline player to be jailed at next logon for 24hrs
#					.jail free													[GMlvl4]  free selected player
#					.jail list													[GMlvl4]  lists currently jailed players
#					.jail info													[GMlvl4]  show help
# 				.jailconf	create		  							[GMlvl6]  creates ngjail sql tables
# 				.jailconf	cleanup	  								[GMlvl6]  cleans up sqllite3 table
# 				.jailconf	drop	  								  [GMlvl6]  drops ngjail sql tables
# 				.jailconf	version	  								[GMlvl6]  shows database version
# 				.jailconf	info	  									[GMlvl6]  shows help
# 				.free 															[players] frees player if time is up
#         .isjailed <pname> or <selected>			[GMlvl4]  check if a player is jailed
#
# add to creatures scp
#		[creature 40000]
#		name=Jail Guard
#		questscript=ngJailNPC
#		guild=Jail Manager
#		npcflags=01
#		faction=120
#		level=255
#		maxhealth=200000
#		model=14733
#		equipmodel=0 32603 2 5 2 17 1 0 0 0
#		size=0.5
#		type=7
#
#
# v1.1.9 - Minor change to log message, changed NPC say
#
# v1.1.8 - Finaly Added byname, gives possibility to jail offlines players
#						in fact it marks the player jailed, so during logon it will detect an escape
#						and (re-) jail the player for 24 hrs.
#
# v1.1.7 - Added log file
#
# v1.1.6 - Official released version; no SQLdb changes to come with subsubversions
#				 - Cleared bug when casting teleport spell always ending up in home-inn
#        - Cleaned -up
#					
# v0.1.5 - Found out bindpoint cannot be saved :-/ removed from script
#				 - Intercepted ::SpellEffects::SPELL_EFFECT_TELEPORT_UNITS instead
#				 - Added CHECK_TELEPORT = 1 to variables
#						Will prevent useage of any teleport spell (including heartstone)
#
# v0.1.4 - Added CHECK_LOGIN = 1 / CHECK_RESURRECT =1 options
#        - Added use of [ngJail] conf/scripts.conf options
#				 - Changed IsJailed command; now accepts both typed name and selected player and returns textstring instead of 0/1
#        - Fixed another bug concerning bindpoint when autojailed
# 
# v0.1.3a- Debugged losing bindposition by checking jail status (and retrieve
#             stored bindpos if needed)
#       
#	v0.1.3 - Added jail-check on Login 
#        - .jail list also deletes released people (sort of SQL cleanup)
#				 - Added custom commands
#						::ngjail::JailedBy { tobechecked }
#						::ngjail::Getstoredpos { tobechecked }
# v0.1.2 - Added hooked procedure to prevent teleport when marked jailed in SQLdb
#        - Changed unjail to delete SQL entry instead of marking unjailed
#        - Removed some bugs, thanks to Delfin :-D
#
# v0.1.1 - Bug, Removed argument from .jaildb config help
#        - Removed jail-check from ::jail (player should be jailed anyway)
#        - Redone way text is handled by jail-guard when time is up.
#
# v0.1.0 - Added JailGuard had the idea a long time ,
# 					but easily realised thanks to Rama's zJail!
#				 - Added custom commands 
#						::ngjail::IsJailed { tobechecked }
#						::ngjail::GetTimeLeft { tobechecked }
#						::ngjail::GetReason { tobechecked }	
# v0.0.9 - playername stored in lowercase
#				 - changed variables into procedure arguments so
#          script can now be called with proc 
#           ::ngjail::Jail { tobejailed jailtime reason by } 
#				 - Fixed possibility to be jailed twice 
#        - Bindpoint checked for pos 13 before storing
#				 - Increased needed GMlvl for .jailconf to 6
#        - Added command .isjailed <pname>
#
# v0.0.8 Added 'By <GM> name' to SQL and info
#				 Changed coloring on info string
#
# V0.0.7 Added storing/setiing of BindPoint
#
# v0.0.6 Initial beta release
#

##################################################
#	namespace eval ngjail {}
#
#	global setup
#
# Load the required SQLdb module
#
package require SQLdb
##################################################
#Create namespace ngjail
#
namespace eval ::ngjail {
	variable NAME "ngjail"
	variable VERSION "1.1.9"
	variable MIN_CUSTOM_VERSION "1.95"

	variable USE_CONF_FILE 1
# Variable defaults if Conf\Script.conf not used
	variable CHECK_LOGIN 1
	variable CHECK_RESURRECT 1
	variable CHECK_TELEPORT 1
	variable CHECK_TIME 12000
	variable VERBOSE 0
# leave empty to skip loggin	
	variable LOG_FILE "logs/ngJail.log"


# You can set here the teleport coordinates for the Jail
	variable JAILPOSITION "13 0 0 0"

# SQLdb handle
	variable handle

# Set to 1 to set DEBUG on...
	variable DEBUG 0
	variable s_logprefix "[ clock format [ clock seconds ] -format %k:%M:%S ]:M"
	variable s_logDebug

# Language strings (en)
	variable s_lang "default"
	variable c_dbg01 "Entered procedure "
	variable l_hlp01 "NextGen Jail System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6\$s \| %7\$s \| %8\$s \]%1\$c%4\$-12s - Removes wasted space from the database%1\$c%5\$-14s - Drops the tables from sqldb%1\$c%6\$-14s - recreates the tables from scratch%1\$c%7\$-14s - displays the current program version%1\$c%8\$-15s - shows this info"
	variable l_hlp02 "NextGen Jail system (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \]%1\$c%4\$-13s - Will free you if jailtime is up"
	variable l_hlp03 "NextGen Jail System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6\$s \| %7\$s \| %8\$s \| %9\$s \]%1\$c%4\$-1s <Hrs> <Reason>   - Jails selected player %1\$c%5\$-29s - Frees selected player from jail%1\$c%6\$-29s - Clear Qflag on selected player%1\$c%7\$-31s - Lists currently jailed%1\$c%8\$-1s <Name>        - Offline Player will be jailed at next logon %1\$c%9\$-30s - Shows this info"
	variable l_ver01 "ngJail system script is at version %s"
	variable l_dba01 "You are not allowed to use this command!"
	variable l_dba02 "ngJail system (v%s) database"
	variable l_dba03 "Database cleanup done."
	variable l_dba04 "The tables were successfully dropped"
	variable l_dba05 "The tables were successfully updated."
	variable l_dba06 "The tables are already up to date."
	variable l_dba07 "Database tables already exist, if you want to recreate them use%2\$c\"%1\$s\"."
	variable l_dba08 "done"
	variable l_dba09 "Database tables setup %s."
	variable h_wrk01 "Error in ngJail system."

	if { $USE_CONF_FILE } { Custom::LoadConf }
}


##################################################
# Jail command
#  .jail <option> [<hrs> <reason>] 
#
proc ::ngjail::DoJail { player cargs } {
	variable DEBUG
	
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc DoJail{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set mode [lindex $cargs 0]
	set sele [::GetSelection $player ]
	set object [ ::GetObjectType $sele ]

	switch $mode {
			"for" {
				if { $sele == "" || $object != 4 } { return "Please select a player" }
				switch [llength $cargs] {
					2 {
						set jailtime [expr [lindex $cargs 1] * 3600 ] 
						set reason  "Ask_GM"
						set by [::GetName $player]
						}
					3 - 4 - 5 - 6 - 7 - 8 - 9 {
						set jailtime [expr [lindex $cargs 1] * 3600 ] 
						set reason  [lrange $cargs 2 end]
						set by [::GetName $player]
						}
					default {
						return [ ::ngjail::help $player ]
						}
				}
						return [::ngjail::Jail $sele $jailtime $reason $by]
			}
			"byname" {
						set pname [lindex $cargs 1]
						set reason  [lrange $cargs 2 end]
					  set PlayerUID [::SQLdb::firstcellSQLdb $::ngjail::handle "SELECT `value` FROM `db_arrays` WHERE (`array` = 'Custom::PlayerID' AND `key` = '$pname')"]
						set jaildate [clock seconds]
						set jailtime 86400 
						if { ! [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname')" ] } {
								::SQLdb::querySQLdb $::ngjail::handle "INSERT INTO `ngjail` (`name`,`PlayerUID`, `jaildate`, `jailtime`, `pos`, `reason`, `jail`) VALUES('$pname','$PlayerUID', '$jaildate', '$jailtime', '', 'To be jailed for 24 hrs at next Logon', 1 )"
							} else {
								::SQLdb::querySQLdb $::ngjail::handle "UPDATE `ngjail` SET `PlayerUID`= '$PlayerUID', `jaildate` = '$jaildate', `jailtime` = '$jailtime', `pos` = '', `reason` = 'To be jailed for 24 hrs at next Logon', `jail` = 1 WHERE (`name` = '$pname')"
							}
						return "[clock format [clock seconds] -format %k:%M:%S] $pname will be jailed for 24 hrs at next logon"
			}
			"free" {
						if { $sele == "" } { set sele [lindex $cargs 2] }
						return [::ngjail::JailFree $sele]
			}
			"list" {
			return [ ::ngjail::jail_list ]
			}
			"reset" {
				ClearQFlag $sele "jailed"
				::SQLdb::querySQLdb $::ngjail::handle "DELETE FROM `ngjail` WHERE ( `name` = '[string tolower $cargs]')"
				return "Jail info cleared"
			}
			"info" -
			"help" -
			default {
				return [ ::ngjail::help $player ]
			}
	}
}

##################################################
# Jail procedure
#  ::ngjail::Jail { tobejailed jailtime reason by }
#   
proc ::ngjail::Jail { tobejailed jailtime reason by } {
	variable DEBUG
	variable JAILPOSITION
	variable LOG_FILE
	
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc Jail{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower [::GetName $tobejailed]]
	set timeleft [format "%.2f" [expr $jailtime/3600.0 ]]
	set pos [ ::GetPos $tobejailed ]
	set jaildate [clock seconds]
	if { ! [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname')" ] } {
		::SQLdb::querySQLdb $::ngjail::handle "INSERT INTO `ngjail` (`name`,`PlayerUID`, `jaildate`, `jailtime`, `pos`, `reason`, `jail`, `by` ) VALUES('$pname','$tobejailed', '$jaildate', '$jailtime', '[ ::SQLdb::canonizeSQLdb $pos ]', '[ ::SQLdb::canonizeSQLdb $reason ]', 1 ,'$by')"
	} else {
		::SQLdb::querySQLdb $::ngjail::handle "UPDATE `ngjail` SET `PlayerUID`= '$tobejailed', `jaildate` = '$jaildate', `jailtime` = '$jailtime', `pos` = '[ ::SQLdb::canonizeSQLdb $pos ]', `reason` = '[ ::SQLdb::canonizeSQLdb $reason ]', `jail` = 1, `by` = '$by' WHERE (`name` = '$pname')"
	}
	::Custom::TeleportPos $tobejailed $JAILPOSITION
	Say $tobejailed 0 "I am Jailed by $by for $timeleft hrs because of $reason."
	set line "$pname has been jailed by $by for $timeleft hrs because of $reason."
	if { $::ngjail::LOG_FILE != "" } { ::Custom::Log $line $::ngjail::LOG_FILE }
	if { $::ngjail::VERBOSE } {puts "[clock format [clock seconds] -format %k:%M:%S]:M:ngJail:$line" }
	return $line
}

##################################################
# Unjail command
#  .free 
#
proc ::ngjail::DoFree { player cargs} {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc DoFree{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower [::GetName $player]]
	set todaysdate [clock seconds]
	if { [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT name FROM `ngjail` WHERE ( `name` = '$pname' )" ] } {
	foreach name_row [ ::SQLdb::querySQLdb $::ngjail::handle "SELECT * FROM `ngjail` WHERE ( `name` = '$pname' )" ] {
		foreach { name PlayerUID jaildate jailtime pos reason jail by } $name_row {
			set timeleft [format "%.2f" [expr ($jaildate - $todaysdate + $jailtime)/3600.0 ]]
			if { $timeleft > 0 } {
					set fin "You are not allowed to leave yet, still $timeleft hrs to go" 
				} else {
					set fin [::ngjail::JailFree $player]
				}
			}
		}
	} else {
		set fin "You are not in jail, try using your heartstone"
	}
	return $fin
}

##################################################
# UnJail procedure
#  ::ngjail::JailFree { tobefreed }
#   
proc ::ngjail::JailFree { tobefreed } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc JailFree{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower [::GetName $tobefreed]]
	if { ! [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname' )" ] } {
 		return "Selected player has not been jailed" 
 	} else {
		foreach name_row [ ::SQLdb::querySQLdb $::ngjail::handle "SELECT * FROM `ngjail` WHERE (`name` = '$pname')" ] {
			foreach { name PlayerUID jaildate jailtime pos reason jail by } $name_row {
			  ::SQLdb::querySQLdb $::ngjail::handle "DELETE FROM `ngjail` WHERE (`name` = '$pname')"
			}
		}
		Say $tobefreed 0 "I have been released from jail :)"
		Teleport $tobefreed [lindex $pos 0] [lindex $pos 1] [lindex $pos 2] [lindex $pos 3]
 		ClearQFlag $tobefreed "jailed"

		# Note: only works if jail located in maparea 13
		if { [ ::GetPos $tobefreed ] == 13 } {
			Say $tobefreed 0 "Teleport error, please relog and use heartstone"
			return "Teleport error, told $pname to relog and use heartstone"
		} else {
			return "[ Custom::Color $pname green ] has been released from jail"
		}
	}
	return "Please select someone first"
}

##################################################
#	proc ::ngjail::Confhelp { player }
#
# Returns a help screen for .jailconf
#
proc ::ngjail::Confhelp { } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc Confhelp{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
  return [ format $::ngjail::l_hlp01 10 $::ngjail::VERSION ".jailconf" "cleanup" "drop" "create" "version" "info" ]
}
##################################################
#	proc ::ngjail::help { player }
#
# Returns a help screen depending on your level (hand called)
#
proc ::ngjail::help { player } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc help{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}

	if { [ ::GetPlevel $player ] < 4 } {
		return [ format $::ngjail::l_hlp02 10 $::ngjail::VERSION ".free" "" ]
	} else {
		return [ format $::ngjail::l_hlp03 10 $::ngjail::VERSION ".jail" "for" "free" "reset" "list" "byname" "info" ]
	}
}


##################################################
#Procedure list currently jailed people
# also re-sync QFlag 'Jailed' and deletes
# umarks people jailed when time reached
proc ::ngjail::jail_list { } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc jail_list{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set ret "[ Custom::Color "Currently Jailed Players:" blue ]"
	set todaysdate [clock seconds]
	foreach name_row [ ::SQLdb::querySQLdb $::ngjail::handle "SELECT * FROM `ngjail` WHERE ( `jail` = 1 )" ] {
		foreach { name PlayerUID jaildate jailtime pos reason jail by } $name_row {
			set timeleft [format "%.2f" [expr ($jaildate - $todaysdate + $jailtime)/3600.0 ]]
			if { $timeleft < 0 } {
				 ::SQLdb::querySQLdb $::ngjail::handle "UPDATE `ngjail` SET `jail` = 0 WHERE (`name` = '$name')"
				 ClearQFlag $name "jailed" 
			} else {
 				append ret "\n[ Custom::Color $name red ] for [ Custom::Color $reason white ] by [ Custom::Color $by green ] left [ Custom::Color $timeleft AQUA ] hours"
			}
		}
	}
	return "$ret"
}
##################################################
#  .IsJailed command
#   check's <player> for jail
#   

proc ::ngjail::CheckJailed { player tobechecked } {
	variable DEBUG
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc Isjailed{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower $tobechecked]
	if {$pname == ""} {
			set sele [::GetSelection $player ]
			set pname [ string tolower [::GetName $sele ]]
	}
	if {$pname == ""} { return "Please type a name, or select a player"}
	if { ! [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname' AND `jail` = 1)" ] } {
		return "Player $pname is not jailed"
	} else {
		set fin "PLAYER [string toupper $pname] SHOULD BE IN JAIL!!"
		return "[ Custom::Color $fin red ]"
	}
}

##################################################
# JailCheck procedure 
#   ::ngjail::IsJailed { tobechecked }
#    returns 1 if jailed. 0 otherwise

proc ::ngjail::IsJailed { tobechecked } {
	variable DEBUG
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc Isjailed{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower $tobechecked]
	if { ! [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname' AND `jail` = 1)" ] } {
		return 0
	} else {
		return 1
	}
}

##################################################
# JailCheck procedure
#  ::ngjail::GetTimeLeft { tobechecked }
#   
proc ::ngjail::GetTimeLeft { tobechecked } {
	variable DEBUG
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc GetTimeLeft{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower $tobechecked]
	set todaysdate [clock seconds]

	if { ! [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT name FROM `ngjail` WHERE (`name` = '$pname' AND `jail` = 1)" ] } {
		return 0
	} else {
		foreach name_row [ ::SQLdb::querySQLdb $::ngjail::handle "SELECT * FROM `ngjail` WHERE (`name` = '$pname')" ] {
			foreach { name PlayerUID jaildate jailtime pos reason jail by } $name_row {
				set timeleft [format "%.2f" [expr ($jaildate - $todaysdate + $jailtime)/3600.0 ]]
			}
		}
		return $timeleft
	}
}
##################################################
# JailCheck procedure
#  ::ngjail::GetReason { tobechecked }
#   
proc ::ngjail::GetReason { tobechecked } {
	variable DEBUG
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc GetReason{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower $tobechecked]
	::SQLdb::firstcellSQLdb $::ngjail::handle "SELECT `reason` FROM `ngjail` WHERE (`name` = '$pname')"
}
##################################################
# JailCheck procedure
#  ::ngjail::JailedBy { tobechecked }
#   
proc ::ngjail::JailedBy { tobechecked } {
	variable DEBUG
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc JailedBy{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower $tobechecked]
	::SQLdb::firstcellSQLdb $::ngjail::handle "SELECT `by` FROM `ngjail` WHERE (`name` = '$pname')"
}
##################################################
# JailCheck procedure
#  ::ngjail::Getstoredpos { tobechecked }
#   
proc ::ngjail::Getstoredpos { tobechecked } {
	variable DEBUG
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc Getstoredpos{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set pname [ string tolower $tobechecked]
	::SQLdb::firstcellSQLdb $::ngjail::handle "SELECT `pos` FROM `ngjail` WHERE (`name` = '$pname')"
}
##########################################################
# Rejail when SQL query positive during Login
#    for check_time seconds (24hrs)
#    

proc ::ngjail::Login { to from spellid } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc Login{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}

	set pname [GetName $from]
	if { [ ::ngjail::IsJailed  $pname ] == 1 &&  [ lindex [ ::GetPos $to ] 0 ] != 	[lindex $::ngjail::JAILPOSITION 0] } {
		::ngjail::Jail $from $::ngjail::CHECK_TIME "Escape detected" "Logon Check"
		set logininfo "Jail Check for $pname: ESCAPE DETETCTED during logon,  re-jailed for 24 hrs."
	} else {
		set logininfo "Jail Check for $pname during logon: not escaped."
	}
	if { $::ngjail::VERBOSE } { puts "[clock format [clock seconds] -format %k:%M:%S]:M:$logininfo" }
}
if { $::ngjail::CHECK_LOGIN } { ::Custom::AddSpellScript "::ngjail::Login" 836 }


##########################################################
# Rejail when SQL query positive during Resurrect
#    for 86400 seconds (24hrs)
#   Hooked procedure !
if { $::ngjail::CHECK_RESURRECT } {
	::Custom::HookProc "::WoWEmu::OnPlayerResurrect" {
		set pname [GetName $player]
		if { [ ::ngjail::IsJailed $pname ] == 1 &&  [ lindex [ ::GetPos $player ] 0 ] != 	[lindex $::ngjail::JAILPOSITION 0] } {
			set pname [GetName $player]
 	 		::ngjail::Jail $player $::ngjail::CHECK_TIME "Escape detected" "Resurrect Check"
			set OnPlayerResurrectinfo "Jail Check for $pname: ESCAPE DETETCTED during resurrect,  re-jailed for 24 hrs."
		} else {
			set OnPlayerResurrectinfo "Jail Check for $pname during resurrect: is not jailed"
		}
			if { $::ngjail::VERBOSE } { puts "[clock format [clock seconds] -format %k:%M:%S]:M:$OnPlayerResurrectinfo" }
	}
}

##########################################################
# Rejail when SQL query positive during Teleport
#    for 86400 seconds (24hrs)
#    Hooked procedure !
if { $::ngjail::CHECK_TELEPORT } {
	::Custom::HookProc "::SpellEffects::SPELL_EFFECT_TELEPORT_UNITS" {
		set pname [GetName $from]
		if { [ ::ngjail::IsJailed $pname ] == 1 &&  [ lindex [ ::GetPos $player ] 0 ] != 	[lindex $::ngjail::JAILPOSITION 0] } {
 	 		::ngjail::Jail $from $::ngjail::CHECK_TIME "Escape detected" "Teleport Check"
			set TeleportCheckinfo "Jail Check for $pname: ESCAPE DETETCTED during teleport,  re-jailed for 24 hrs."
			set spellid 0
		} else {
			set TeleportCheckinfo "Jail Check for $pname during teleport: is not jailed."
		}
			if { $::ngjail::VERBOSE } { puts "[clock format [clock seconds] -format %k:%M:%S]:M:$TeleportCheckinfo" }
	}
}
##################################################
#	proc ::ngjail::db { player cargs }
#
# Manualy maintain the datbase with .jailconf
# 
#
proc ::ngjail::db { player cargs } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc db{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	set i_maxchar 127
	set s_ret [ format $::ngjail::l_dba02 $::ngjail::VERSION ]
	switch [ string tolower $cargs ] {
		"version" -
		"dbversion" {
			return "$s_ret:\n\n[ ::SQLdb::versionSQLdb $::ngjail::handle ]"
		}
		"cleanup" {
			::SQLdb::cleanupSQLdb $::ngjail::handle
			return "$s_ret:\n\n$::ngjail::l_dba03"
		}
		"drop" {
			if { [ ::SQLdb::existsSQLdb $::ngjail::handle `ngjail` ] } {
				::SQLdb::querySQLdb $::ngjail::handle "DROP TABLE `ngjail`"
			}
			::SQLdb::cleanupSQLdb $::ngjail::handle
			set s_done $::ngjail::l_dba04
		}
		"create" {
			set create 0
			if { ! [ ::SQLdb::existsSQLdb $::ngjail::handle `ngjail` ] } {
				::SQLdb::querySQLdb $::ngjail::handle "CREATE TABLE `ngjail` (`name` VARCHAR($i_maxchar) PRIMARY KEY NOT NULL DEFAULT '', `PlayerUID` VARCHAR($i_maxchar), `jaildate` VARCHAR($i_maxchar), `jailtime` VARCHAR($i_maxchar),  `pos` VARCHAR($i_maxchar), `reason` VARCHAR($i_maxchar) NOT NULL DEFAULT 'Autojailed', `jail` INTEGER NOT NULL DEFAULT 0, `by` VARCHAR($i_maxchar) NOT NULL DEFAULT 'Server' )"
				incr create
			}
			if { $create == 0 } {	
				append s_ret ":\n\n" [ format $::ngjail::l_dba07 ".jailconf drop" 10 ]
			} else {
				if { ! [ info exists s_done ] } {
					set s_done $::ngjail::l_dba08
				}
				append s_ret ":\n\n" [ format $::ngjail::l_dba09 $s_done ]
			}
				return $s_ret
		}
		"info" -
		"help" -
		default {
			return [ ::ngjail::Confhelp ]
		}
	}
}

##################################################
#	::ngjail::setSQLdb { } procedure
#
# Internal procedure to set, check and update the SQLdb database 
# if version has changed.
# This procedure runs once during startup or retcl.
#
proc ::ngjail::setSQLdb { } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc setSQLdb{}:"
		puts "$s_logDEBUG $::ngjail::c_dbg01"
	}
	if { ! [ ::SQLdb::booleanSQLdb $::ngjail::handle "SELECT * FROM `$::SQLdb::NAME` WHERE (`name` = '$::ngjail::NAME')" ] } {
		if { [ ::SQLdb::existsSQLdb $::ngjail::handle `ngjail` ] } {
			::ngjail::db 0 drop
			::ngjail::db 0 create
		} else {
			::ngjail::db 0 create
		}
		::SQLdb::querySQLdb $::ngjail::handle "INSERT INTO `$::SQLdb::NAME` (`name`, `version`) VALUES('$::ngjail::NAME', '$::ngjail::VERSION')"
	} else {
		set s_oldver [ ::SQLdb::firstcellSQLdb $::ngjail::handle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$::ngjail::NAME')" ]
		if { [ expr { $s_oldver > $::ngjail::VERSION } ] } {
			if { $DEBUG } {
				return -code error "$s_logDEBUG The current version of $::ngjail::NAME ($::ngjail::VERSION) is older that the previous one ($s_oldver), downgrade unsupported, use .jailconf drop!"
			} else {
				return -code error "$SQLdb::s_logprefix: The current version of $::ngjail::NAME ($::ngjail::VERSION) is older that the previous one ($s_oldver), downgrade unsupported, use .jailconf drop!"
			}
		} elseif { [ expr { $s_oldver < $::ngjail::VERSION } ] } {
			::ngjail::db 0 drop
			::ngjail::db 0 create
			::SQLdb::querySQLdb $::ngjail::handle "UPDATE `$SQLdb::NAME` SET `version` = '$::ngjail::VERSION', `previous` = '$s_oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$::ngjail::NAME')"
		} else {
			::ngjail::db 0 create
		}
	}
}

#################################################
# Initialise ngjail	
#
proc ::ngjail::init {} {
	if { [ info exists "::start-tcl::VERSION" ] } {
		set ngjail::DEBUG $::DEBUG
		set ngjail::s_logprefix $::logPrefix
	}

	variable DEBUG
	variable s_logDebug
	variable handle
	set s_logDebug "$ngjail::s_logprefix:ngjail:DEBUG:"

	if { $DEBUG } {
		set s_logDEBUG "$s_logDebug proc init{}:"
		puts "$s_logDEBUG $ngjail::c_dbg01"
	}

	if { ! [ info exists handle ] } {
		set ::SQLdb::handle [ ::SQLdb::openSQLdb ]
	}
	set handle $::SQLdb::handle
	if { $DEBUG } {
		::SQLdb::traceSQLdb $handle ::ngjail::db_trace
	}
	::ngjail::setSQLdb
	
	if { [ ::Custom::GetScriptVersion "StartTCL" ] >= "0.9.0" } {
		::StartTCL::Require "Custom"
		::StartTCL::Provide
	}

	set loadinfo "Nextgen Jail System v$::ngjail::VERSION by AceIndy loaded - SQLite3"
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"

}

::ngjail::init

#Add commands to WoWEmu (and set gm access lvl)
::Custom::AddCommand {"free" ::ngjail::DoFree 0}
::Custom::AddCommand {"jail" ::ngjail::DoJail 4}
::Custom::AddCommand {"isjailed" ::ngjail::CheckJailed 4}
::Custom::AddCommand {"jailconf" ::ngjail::db 6}





##################################################
# New namespace for NPC 40000
#  ::ngjailNPC::Gossiphello { npc tobechecked }
#
# add to creatures scp
#		[creature 40000]
#		name=Jail Guard
#		questscript=ngJailNPC
#		guild=Jail Manager
#		npcflags=01
#		faction=120
#		level=255
#		maxhealth=200000
#		model=14733
#		equipmodel=0 32603 2 5 2 17 1 0 0 0
#		size=0.5
#		type=7
   
namespace eval ::ngJailNPC {}
proc ::ngJailNPC::GossipHello { npc player } {
	set option0 { text 2 "Why am I put in jail ?" }
	set option1 { text 2 "How much time remains in jail ?" }
	set option2 { text 2 "Who put me in jail ?" }
	::SendGossip $player $npc { npctext 3055 } \ $option0 $option1 $option2
	::Emote $npc 66
	::Emote $player 66
}
proc ::ngJailNPC::GossipSelect { npc player option } {
	set pname [ ::GetName $player ]
	set todaysdate [clock seconds]
	set Timeleft [ ::ngjail::GetTimeLeft $pname ]
	switch $option {
		0 {
				::Say $npc 0 "You were jailed because of [ ::ngjail::GetReason $pname ]"
			}
		1 {
				if { $Timeleft > 0 } {
					::Say $npc 0 "You have $Timeleft hrs remaining in jail"
				} else {
					::Say $npc 0 "You're time is up! To leave type .free"
				}
			}
			2 {
					::Say $npc 0 "You were jailed by [ ::ngjail::JailedBy $pname ]"
				}
		}
	SendGossipComplete $player 
}

proc ::ngJailNPC::QuestStatus { npc player } {
	set reply 2
	return $reply
}