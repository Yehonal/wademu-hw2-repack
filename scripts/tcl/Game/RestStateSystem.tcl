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
# A lot of code of this program is based on the Lazarus Long's NextGen systems
# He graciously allowed the licensing of this derivated work under the
# above License. This does not imply that the original code nor its
# versions are under the same license as long as they don't include
# code specific from this program. Only this program and derivated work from it
# are subject to the above License. The original code is (c)Lazarus Long
# and you must contact him for licensing details.
#
#
# Name:					ngreststate.tcl
#
# StartDate:		2006-05-14
# Last UpDate:	2006-08-13
#
# Description:	NextGen Reststate System
#
# Author:	AceIndy  <aceindy@gmail.com>
#
#
# This script works together with reststate addon.
# It will modify 200% XP-Rate when rested. 
# You will receive a resting bonus for every 8 hrs spend resting (logged off).
# If not resting at an Inn, you will receive only 25% of that bonus.
# It moves Rested_XP slider on client accordingly
#
# syntax:.reststateconf	create		  								[GMlvl6]  creates ngreststate sql tables
# 				.reststateconf	cleanup	  								[GMlvl6]  cleans up sqllite3 table
# 				.reststateconf	drop	  								  [GMlvl6]  drops ngreststate sql tables
# 				.reststateconf	version	  								[GMlvl6]  shows database version
# 				.reststateconf	info	  									[GMlvl6]  shows help
#					.reststatusreset <selected>								[GMlvl4]  Clears reststate data on selected player
#
# all other actions are dealt with by client's RestStateAddOn
#
#
# History v x.x.x	-Lot of tries, but have to finish AddOn first. 
#         v 1.0.0	-Finished Addon, tcl came pretty easy after; First Public Release
#					v 1.1.0	-Made some last minute changes to SQL updates
# 				v 1.1.1	-Added .reststaterested command
#									-Fixed rested_xp to be integer										
#					 				-Moved restingon/off procedures to resting_check
#										(msg MUST be called from procedure started by client in order to receive it)
#					v 1.1.2 -Added variables HoursPerBubble and MaxRestPct
#									-Fixed Rested XP substraction; Should be double XP when rested (thanks for the tip Academico)
#									-Optimized a bit
#					v 1.1.3 -Found formula for Max_xp = =8*CurrLvl*(45+5*CurrLvl), so max_xp has been removed as argument
#					v 1.1.4 -Found & fixed bug; found out slider not updated when rested_xp=0 and xp update takes place.
#											notified_rested should be cleared after every xp-update
#									-Added Start-bonus as variable
#					v 1.1.5 -Started updating logout-time with XP multiplier (in case client doesn't run AddOn, 
#											RestedXP would be based on last login time)
#									-Removed Logout procedure, not needed anymore
#					v 1.1.6	-Fixed minor typo in reset procedure.
#					v 1.1.7 -Fixed another typo in SQLcommand (thanks Hidden)
#					v 1.1.8 -Added selection check to reset
#					v 1.1.9 -Fixed bug in max_xp update in SQL; causing some people having more then 1.5*max_xp rested.

# Thanks everybody for debugging ,ideas and thinking along!

##################################################
#	namespace eval ngreststate {}
#
#	global setup
#
# Load the required SQLdb module
#
package require SQLdb

##################################################
#Create namespace ngreststate
#
namespace eval ::ngreststate {
	variable NAME "ngRestState"
	variable MIN_CUSTOM_VERSION "1.95"
# Database version (omited last subversion; only to be changed when database structure changes)
	variable VERSION "1.1.9"
	
# max distance from rest zone (Zzz switches off) 
	variable RESTDISTOFF 20
# check player side in rest zone (0 - off, 1 - on)
	variable RESTSIDECHECK 1
# set number of rest hours needed for every bubble gained
  variable HOURSPERBUBBLE 2
# Set maximum percentage rested to be reached
  variable MAXRESTPCT 1.5
# Give newbies a initial 1000 rested_xp bonus
  variable STARTBONUS 1000
# use \conf\scripts.conf
	variable USE_CONF_FILE 0

# SQLdb handle
	variable handle
	
# Set to 1 to set DEBUG on...
	variable DEBUG 0
	variable s_logprefix "[ clock format [ clock seconds ] -format %k:%M:%S ]:M"
	variable s_logDebug

# Language strings (default =en)
	variable s_lang "default"
	variable c_dbg01 "Entered procedure "
	variable l_hlp01 "NextGen Resting System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6\$s \| %7\$s \| %8\$s \]%1\$c%4\$-12s - Removes wasted space from the database%1\$c%5\$-14s - Drops the tables from sqldb%1\$c%6\$-14s - recreates the tables from scratch%1\$c%7\$-14s - displays the current program version%1\$c%8\$-15s - shows this info"
	variable l_ver01 "NextGen Resting System script is at version %s"
	variable l_dba01 "You are not allowed to use this command!"
	variable l_dba02 "NextGen Resting System (v%s) database"
	variable l_dba03 "Database cleanup done."
	variable l_dba04 "The tables were successfully dropped"
	variable l_dba05 "The tables were successfully updated."
	variable l_dba06 "The tables are already up to date."
	variable l_dba07 "Database tables already exist, if you want to recreate them use%2\$c\"%1\$s\"."
	variable l_dba08 "Done"
	variable l_dba09 "Database tables setup %s."
	variable h_wrk01 "Error in NextGen Resting System."

	if { $USE_CONF_FILE } { Custom::LoadConf }
	
# Below the trigger area's are defined , followed by faction.
# These area's should have SCRIPT=RestState set in areatriggers.scp
   	variable area_trigger
   	array set area_trigger {
     		71 1
     		562 1
     		682 1
     		707 1
     		708 1
     		709 1
     		710 1
     		712 1
     		713 1
     		715 1
     		716 1
     		717 1
     		719 2
     		720 2
     		721 2
     		722 2
     		742 2
     		743 0
     		843 2
     		844 2
     		862 0
     		982 2
     		1022 2
     		1023 0
     		1024 1
     		1025 2
     		1606 2
     		1646 2
     		2266 1
     		2267 2
     		2286 2
     		2287 0
     		2610 2
     		2746 1
	}
}

############################################
# Update position, set reststing=1 and notified_resting=0 in SQL
proc ::ngreststate::AreaTrigger { player trigger_number } {
 	if {[info exists ::ngreststate::area_trigger($trigger_number)]} {
 		if { $trigger_number == 716 } { TaxiNodeExplorered $player 27 }
 		if {$::ngreststate::area_trigger($trigger_number) == 0 || (($::ngreststate::RESTSIDECHECK == "1") && ([Custom::GetPlayerSide $player] == [ expr ($::ngreststate::area_trigger($trigger_number)) - 1]))} {
			set pname [GetName $player]
   		set pos [GetPos $player]
	 		set timenow [clock seconds]
   		set resting [::SQLdb::querySQLdb $::ngreststate::handle "SELECT `resting` FROM `$::ngreststate::NAME` WHERE `name` = '$pname'"]
			set plvl [GetLevel $player]
			set max_xp [expr (8 * $plvl * ( 45 + 5 * $plvl ))]
			if { $resting != 1 } { 
				if { ! [ ::SQLdb::booleanSQLdb $::ngreststate::handle "SELECT name FROM `$::ngreststate::NAME` WHERE `name` = '$pname'" ] } {
					::SQLdb::querySQLdb $::ngreststate::handle "INSERT INTO `$::ngreststate::NAME` (`name`, `logout_time`, `pos`, `max_xp`, `resting`, `notified_resting`) VALUES ('$pname', '$timenow', '$pos', '$max_xp', '1', '0')"
				} else {
					::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `logout_time` = '$timenow', `pos` = '$pos', `max_xp` = '$max_xp', `resting` = '1', `notified_resting` = '0' WHERE `name` = '$pname'"
				}
			}
		}
  }
}

# Rename procedure to avoid changes to areatrigger.scp
# If you get renaming error during load,  remove old system ! 
rename ::ngreststate::AreaTrigger RestState::AreaTrigger

###########################################################################
# Checks if resting; or when resting if leaving restarea
# triggered by client addon timed .reststatecheck
# calls procedures RestingOn/RestingOff
proc ::ngreststate::restingcheck { player cargs } {
	variable DEBUG
	
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc restingcheck{}:"
		puts "$s_logDEBUG $::ngreststate::c_dbg01"
	}

	set pname [GetName $player]
 	set pos [GetPos $player]
 	set x  [lindex $pos 1]
 	set y  [lindex $pos 2]
 	set z  [lindex $pos 3]
	foreach name_row [::SQLdb::querySQLdb $::ngreststate::handle "SELECT `notified_resting`,`pos` FROM `$::ngreststate::NAME` WHERE (`name` = '$pname' and `resting`  = '1')"] {
		foreach { notified_resting pos_rest } $name_row {
			set x_rest  [lindex $pos_rest 1]
			set y_rest  [lindex $pos_rest 2]
			set z_rest  [lindex $pos_rest 3]
  		set distanrest [expr {int(sqrt((($x - $x_rest)*($x - $x_rest)) + (($y - $y_rest)*($y - $y_rest)) + (($z - $z_rest)*($z - $z_rest))))}]
   		if { $distanrest >= $::ngreststate::RESTDISTOFF } {
				::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `notified_resting` = '1', `resting` = '0' WHERE `name` LIKE '$pname'"
				return "RESTING_OFF"
 			} else {
				if { $notified_resting == 0 } {
 					::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `notified_resting` = '1' WHERE `name` LIKE '$pname'"
					return "RESTING_ON"
 				}
			}
		}
	}
}

######################################################################
# .reststatestatus <Max_XP> ,triggered by client  
# responds with reststate <rested_xp>
# updates much needed Max_Xp from client in order to calculate bubbles

proc ::ngreststate::reststatestatus { player cargs } {
	variable DEBUG
	
	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc reststatestatus{}:"
		puts "$s_logDEBUG $::ngreststate::c_dbg01"
	}
	set pname [GetName $player]
	set plvl [GetLevel $player]
 	set max_xp [expr (8 * $plvl * ( 45 + 5 * $plvl ))]
	set pos [GetPos $player]
	if { ! [ ::SQLdb::booleanSQLdb $::ngreststate::handle "SELECT name FROM `$::ngreststate::NAME` WHERE `name` = '$pname'" ] } {
 		set timenow [clock seconds]
		::SQLdb::querySQLdb $::ngreststate::handle "INSERT INTO `$::ngreststate::NAME` (`name`, `pos`,`logout_time`, `max_xp`, `rested_xp` , `notified_rested` ) VALUES ('$pname', '$pos', '$timenow','$max_xp', '1000', '1')"
		return "ERR_EXHAUSTION_NORMAL 0"
	} else {
  	foreach row [::SQLdb::querySQLdb $::ngreststate::handle "SELECT `rested_xp`, `notified_rested` FROM `$::ngreststate::NAME` WHERE (`name` = '$pname')"] {
			foreach { rested_xp notified_rested } $row {
			::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `max_xp` = '$max_xp', `notified_rested` = '1'  WHERE `name` = '$pname'"
			}
		}
 		if { $notified_rested == "0" } {			
   		if { $rested_xp > 0 } {
  			return "ERR_EXHAUSTION_RESTED $rested_xp" 
  		} else {
   			return "ERR_EXHAUSTION_NORMAL 0"
			}
  	}
  }
}

##########################################################
# Update Rested_XP upon login, clear notification
#    
proc ::ngreststate::login { to from spellid } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc login{}:"
		puts "$s_logDEBUG $::ngreststate::c_dbg01"
	}
	set pname [GetName $from]
	set pos [GetPos $from]
	set plvl [GetLevel $from]
 	set timenow [clock seconds]
 	set max_xp [expr (8 * $plvl * ( 45 + 5 * $plvl ))]
	if { ! [ ::SQLdb::booleanSQLdb $::ngreststate::handle "SELECT name FROM `$::ngreststate::NAME` WHERE `name` = '$pname'" ] } {
		::SQLdb::querySQLdb $::ngreststate::handle "INSERT INTO `$::ngreststate::NAME` (`name`,`logout_time`, `pos`, `resting`, `rested_xp`, `max_xp`, `notified_resting`, `notified_rested`) VALUES ('$pname', '$timenow', '$pos', '1', '$::ngreststate::STARTBONUS', '$max_xp', '0', '0')"
	} else {
	  foreach row [::SQLdb::querySQLdb $::ngreststate::handle "SELECT `resting`, `rested_xp`, `logout_time` FROM `$::ngreststate::NAME` WHERE (`name` = '$pname')"] {
			foreach { resting prev_rested_xp logout_time } $row {
  		set rested_xp [expr 0.05 * $max_xp * (($timenow - $logout_time)/(3600 * $::ngreststate::HOURSPERBUBBLE))]
  		if { $resting == "0"} {set rested_xp [expr 0.25 * $rested_xp]}
  		set rested_xp [expr int($rested_xp + $prev_rested_xp)]
  		if {$rested_xp > [expr $::ngreststate::MAXRESTPCT * $max_xp]} {set rested_xp [expr int( $::ngreststate::MAXRESTPCT * $max_xp)]} 
 				::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `max_xp` = '$max_xp', `rested_xp` = '$rested_xp', `logout_time` = '$timenow', `notified_resting` = '0', `notified_rested` = '0' WHERE `name` = '$pname'"
			}
		}
	}
}

##########################################################
# Update rested_xp,  returns multiplication factor
#   (used by hooked XP_modifier )
proc ::ngreststate::updatexp { player xp} {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc updatexp{}:"
	}
	set pname [GetName $player]
 	set plvl [GetLevel $player]
  set pos [GetPos $player]
 	set max_xp [expr (8 * $plvl * ( 45 + 5 * $plvl ))]
 	set timenow [clock seconds]
	if { ! [ ::SQLdb::booleanSQLdb $::ngreststate::handle "SELECT name FROM `$::ngreststate::NAME` WHERE `name` = '$pname'" ] } {
			::SQLdb::querySQLdb $::ngreststate::handle "INSERT INTO `$::ngreststate::NAME` (`name`, `pos`, `rested_xp`, `max_xp`, `resting`, `notified_resting`, `notified_rested`, `logout_time`) VALUES ('$pname', '$pos', '0', '$max_xp', '0', '0', '0', '$timenow')"
	} else {
 	 	set rested_xp [::SQLdb::querySQLdb $::ngreststate::handle "SELECT `rested_xp` FROM `$::ngreststate::NAME` WHERE `name` = '$pname'"]
 		if { $rested_xp > 0 } {
	 		set rested_xp [expr int(($rested_xp - (2 * $xp)))]
	 		if {$rested_xp < 0 } { set rested_xp 0 }
			::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `max_xp` = '$max_xp', `rested_xp` = '$rested_xp', `notified_rested` = '0',`logout_time` = '$timenow' WHERE `name` = '$pname'"
			return 2
  	} else {
			::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `max_xp` = '$max_xp', `rested_xp` = '$rested_xp', `notified_rested` = '0',`logout_time` = '$timenow' WHERE `name` = '$pname'"
		}
  } 
 	return 1
}

##################################################
#	::ngreststate::setSQLdb {} procedure
#
# Internal procedure to set, check and update the SQLdb database 
# if version has changed.
# This procedure runs once during startup or retcl.
#
proc ::ngreststate::setSQLdb {} {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc setSQLdb{}:"
		puts "$s_logDEBUG $::ngreststate::c_dbg01"
	}
	if { ! [ ::SQLdb::booleanSQLdb $::ngreststate::handle "SELECT * FROM `$::SQLdb::NAME` WHERE (`name` = '$::ngreststate::NAME')" ] } {
		if { [ ::SQLdb::existsSQLdb $::ngreststate::handle `$::ngreststate::NAME` ] } {
			::ngreststate::db 0 drop
			::ngreststate::db 0 create
		} else {
			::ngreststate::db 0 create
		}
		::SQLdb::querySQLdb $::ngreststate::handle "INSERT INTO `$::SQLdb::NAME` (`name`, `version`) VALUES('$::ngreststate::NAME', '$::ngreststate::VERSION')"
	} else {
		set s_oldver [ ::SQLdb::firstcellSQLdb $::ngreststate::handle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$::ngreststate::NAME')" ]
		if { [ expr { $s_oldver > $::ngreststate::VERSION } ] } {
			if { $DEBUG } {
				return -code error "$s_logDEBUG The current version of $::ngreststate::NAME ($::ngreststate::VERSION) is older that the previous one ($s_oldver), downgrade unsupported, use .reststateconf drop!"
			} else {
				return -code error "$SQLdb::s_logprefix: The current version of $::ngreststate::NAME ($::ngreststate::VERSION) is older that the previous one ($s_oldver), downgrade unsupported, use .reststateconf drop!"
			}
		} elseif { [ expr { $s_oldver < $::ngreststate::VERSION } ] } {
			::ngreststate::db 0 drop
			::ngreststate::db 0 create
			::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$SQLdb::NAME` SET `version` = '$::ngreststate::VERSION', `previous` = '$s_oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$::ngreststate::NAME')"
		} else {
			::ngreststate::db 0 create
		}
	}
}
##################################################
#	proc ::ngreststate::db { player cargs }
#
# Manualy maintain the datbase with .reststateconf
# 
#
proc ::ngreststate::db { player cargs } {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc db{}:"
		puts "$s_logDEBUG $::ngreststate::c_dbg01"
	}
	set i_maxchar 127
	set s_ret [ format $::ngreststate::l_dba02 $::ngreststate::VERSION ]
	switch [ string tolower $cargs ] {
		"version" -
		"dbversion" {
			return "$s_ret:\n\n[ ::SQLdb::versionSQLdb $::ngreststate::handle ]"
		}
		"cleanup" {
			::SQLdb::cleanupSQLdb $::ngreststate::handle
			return "$s_ret:\n\n$::ngreststate::l_dba03"
		}
		"drop" {
			if { [ ::SQLdb::existsSQLdb $::ngreststate::handle `$::ngreststate::NAME` ] } {
				::SQLdb::querySQLdb $::ngreststate::handle "DROP TABLE `$::ngreststate::NAME`"
			}
			::SQLdb::cleanupSQLdb $::ngreststate::handle
			set s_done $::ngreststate::l_dba04
		}
		"create" {
			set create 0
			if { ! [ ::SQLdb::existsSQLdb $::ngreststate::handle `$::ngreststate::NAME` ] } {
				::SQLdb::querySQLdb $::ngreststate::handle "CREATE TABLE `$::ngreststate::NAME` (`name` VARCHAR($i_maxchar) PRIMARY KEY NOT NULL DEFAULT '', `pos` VARCHAR($i_maxchar)NOT NULL DEFAULT '0 0 0 0', `logout_time` VARCHAR($i_maxchar) NOT NULL DEFAULT '0', `max_xp` INTEGER NOT NULL DEFAULT '0', `rested_xp` INTEGER NOT NULL DEFAULT '0', `resting` binary(1) NOT NULL default '0',`notified_resting` binary(1) NOT NULL default '0',`notified_rested` binary(1) NOT NULL default '0' )"
				incr create
			}
			if { $create == 0 } {	
				append s_ret ":\n\n" [ format $::ngreststate::l_dba07 ".reststateconf drop" 10 ]
			} else {
				if { ! [ info exists s_done ] } {
					set s_done $::ngreststate::l_dba08
				}
				append s_ret ":\n\n" [ format $::ngreststate::l_dba09 $s_done ]
			}
				return $s_ret
		}
		"info" -
		"help" -
		default {
			return [ ::ngreststate::Confhelp ]
		}
	}
}
##################################################
#	proc ::ngreststate::Confhelp { player }
#
# Returns a help screen for .reststateconf
#
proc ::ngreststate::Confhelp {} {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc Confhelp{}:"
		puts "$s_logDEBUG $::ngreststate::c_dbg01"
	}
  return [ format $::ngreststate::l_hlp01 10 $::ngreststate::VERSION ".ngreststateconf" "cleanup" "drop" "create" "version" "info" ]
}

##################################################
#	proc ::ngreststate::reststatereset { player }
#
# Clears current reststate on selected player
#
proc ::ngreststate::reset {player cargs} {
	variable DEBUG

	if { $DEBUG } {
		variable s_logDebug
		set s_logDEBUG "$s_logDebug proc reset{}:"
		puts "$s_logDEBUG $::ngreststate::c_dbg01"
	}
	set sele [::GetSelection $player ]
	if { $sele == "" || $object != 4 } { return "Please select a player" }
	set pname [GetName $sele ]
	set plvl [GetLevel $sele ]
	set pos [GetPos $sele ]
 	set timenow [clock seconds]
 	set max_xp [expr (8 * $plvl * ( 45 + 5 * $plvl ))]
	set object [ ::GetObjectType $sele ]
	if { $sele == "" || $object != 4 } { 
		return "Please select a player first" 
	} else {
  	::SQLdb::querySQLdb $::ngreststate::handle "UPDATE `$::ngreststate::NAME` SET `rested_xp` = '0', `logout_time` = '$timenow', `max_xp` = '$max_xp', `notified_resting` = '0', `notified_rested` = '0' WHERE `name` = '$pname'"
		return "RestState has been cleared for $pname"
	}
}
#################################################
# Initialise ngreststate	
#
proc ::ngreststate::init {} {
	if { [ info exists "::start-tcl::VERSION" ] } {
		set ngreststate::DEBUG $::DEBUG
		set ngreststate::s_logprefix $::logPrefix
	}
	variable DEBUG
	variable s_logDebug
	variable handle
	set s_logDebug "$ngreststate::s_logprefix:ngreststate:DEBUG:"

	if { $DEBUG } {
		set s_logDEBUG "$s_logDebug proc init{}:"
		puts "$s_logDEBUG $ngreststate::c_dbg01"
	}

	if { ! [ info exists handle ] } {
		set ::SQLdb::handle [ ::SQLdb::openSQLdb ]
	}
	set handle $::SQLdb::handle
	if { $DEBUG } {
		::SQLdb::traceSQLdb $handle ::ngreststate::db_trace
	}
	::ngreststate::setSQLdb
	set loadinfo "Nextgen RestState System v$::ngreststate::VERSION by AceIndy loaded - SQLite3"
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"
	
	if { [ ::Custom::GetScriptVersion "StartTCL" ] >= "0.9.0" } {
		::StartTCL::Require "Custom"
		::StartTCL::Provide
	}
}
::ngreststate::init

#Add custom commands to WoWEmu (and set gm access lvl)
::Custom::AddCommand {"reststateconf" ::ngreststate::db 6}
::Custom::AddCommand {"restingcheck" ::ngreststate::restingcheck 0}
::Custom::AddCommand {"reststatestatus" ::ngreststate::reststatestatus 0}
::Custom::AddCommand {"reststatelogoff" ::ngreststate::reststatestatus 0}
::Custom::AddCommand {"reststatusreset" ::ngreststate::reset 4}

##Hook to XP modifier
::Custom::HookProc "::WoWEmu::ModXP" {
	set xp [ expr { $xp * [ ::ngreststate::updatexp $killer $xp ] } ]
}

##Add to Loginscript (must have patched spell 836)
::Custom::AddSpellScript "::ngreststate::login" 836
