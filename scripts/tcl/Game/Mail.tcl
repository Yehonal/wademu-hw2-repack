#
#
# This program is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
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
#
# This program is partly based on a group of TCL procedures known as the
# Golgorth's Final Mail v1.0. Altought it was started from scratch this program
# inherits their functionality, hence the relationship. Golgorth graciously
# allowed the licensing of this derivated work under the above License. This
# does not imply that the original code nor its versions are under the same
# license as long as they don't include code specific from this program. Only
# this program and derivated work from it are subject to the above License. The
# original code is (c) Golgorth and you must contact him for licensing details.
#
# This program requires interaction with a Lua script known as the Rivera Mail
# client addon, authored by OXOTHuK, who graciously allowed manipulating it and
# licensing of that derivated work under the above License. This does not imply
# that the original code nor its versions are under the same license as long
# as they don't include code specific from the manipulated script. Only the
# manipulated script and derivated work from it are subject to the above
# License. The original code is (c) OXOTHuK and you must contact him for
# licensing details.
#
#
# Name:		ngMail.tcl
#
# Version:	0.9.3
#
# Date:		2006-05-11
#
# Description:	NextGen Mail System
#
# Author:	Lazarus Long <lazarus.long@bigfoot.com>
#
# Changelog:
#
# v0.9.3 (2006-05-11) - The "turn me on" version.
#			Created an option to turn the plugin on and off. Moved
#			support thread location. Corrected a small typo. Fixed
#			the reading of the Debug option from the configuration
#			file.
#
# v0.9.2 (2006-04-13) - The "going nowhere" version.
#			Re-done the documentation to point to the new thread.
#
# v0.9.1 (2006-04-06) -	The "back on track" version.
#			Restored compatibility wuth all versions of the client
#			addon (sorry for the dumb thing made previously).
#
# v0.9.0 (2006-03-28) -	The "no more identification" version.
#			Fixed the dealing with activating DEBUG on the config
#			file. Converted it to use ReadConf from Custom, and
#			Provide and Requires from StartTCL. Receive the item ID
#			instead of its name from the client, due to this, this
#			version is incompatible with client versions prior to
#			1.1.0.
#
# v0.8.3 (2006-03-01) -	The "start-tcl integration" version.
#			Added the needed options to support the new start-tcl
#			scheme, also moved the "scripts/ngmail.conf" to the new
#			"scripts/conf" folder. Changed SQL queries to be case
#			insensitive for player names, thanks to XuTMaH.
#
# v0.8.2 (2006-02-23) -	The "by your command" version.
#			Fixed command processing when spirit's "AddCommand"
#			isn't present/used.
#
# v0.8.1 (2006-02-22) -	The "lets go international" version.
#			Added localization for German by Ramanubis (verified by
#			ZeberRus), Chilian Spanish by EZ-Mouse, Standard
#			Spanish by ZeberRus, French by spirit and Russian by
#			Neo_mat. Thank you all.
#
# v0.8.0 (2006-02-20) -	The "you got mail" version.
#			Tested with both client addons, an it seems to work
#			(of course that with Rivera Mail, the new functions
#			don't, duhhh). Added localization support with the
#			file "scripts/ngmail.conf" and setup the auto init
#			procedures. First public beta.
#
# v0.7.8 (2006-02-19) -	The "use existing facilities" version.
#			Converted the script to use spirit's custom procedures
#			"::Custom::AddCommand" and "::Custom::HookProc" if
#			present (I hope I did it correctly, I'm not sure of the
#			second one). (development version)
#
# v0.7.7 (2006-02-17) -	The "wherever it comes from we deliver" version.
#			Added startup dealing with importing MySQL tables.
#			(development version)
#
# v0.7.6 (2006-02-17) -	The "return to sender" version.
#			Implemented a return to sender option for CoD mails.
#			(development version)
#
# v0.7.5 (2006-02-16) -	The "handle it to spirit" version.
#			Corrected the dealing with the database handle due to a
#			wrong interpretation of the variable linking concept,
#			after spirit called my attention to it. Thank you
#			spirit. (development version)
#
# v0.7.4 (2006-02-14) -	The "charge on delivery revisited" version.
#			Fixed the CoD dealing, now it's Blizz-like, it sends a
#			mail message instead of crediting directly the player.
#			Droped the procedures "cod" and "itosmoney" (pity, this
#			second one was very slick). Once again redid the
#			database format to allow Auction House Invoices in a
#			Blizzard fashion, This implies that I'll have to change
#			"SendMail" once more.  (development version)
#
# v0.7.3 (2006-02-13) -	The "postman changed but mail arrived" version.
#			Created routines to import mail from the existing
#			Golgorth's Final Mail tables (it supports both existing
#			formats, with and without "time_send"). (development
#			version)
#
# v0.7.2 (2006-02-13) -	The "read it once" version.
#			Implemented the timing out of mail in a Blizz-like
#			fashion. The CoD dealing isn't yet Blizz-like, so it
#			still needs to be worked. This gave origin to a new
#			server command "read". (development version)
#
# v0.7.1 (2006-02-12) -	The "back step by step" version.
#			Removed the multipage code from the "get" procedure,
#			since the plugin seems to deal with it. (development
#			version)
#
# v0.7.0 (2006-02-12) -	The "who am I?" version.
#			Created the "serverinfo" procedure and changed the
#			"get" procedure to allow multiple pages to function.
#			(development version)
#
# v0.6.0 (2006-02-11) -	The "slim me down" version.
#			Changed the database format to a slimmer one, had to
#			redo all procedures related. (development version)
#
# v0.5.0 (2006-02-10) -	The "dressed for reharsall" version.
#			OK, I had to redo the date logic to make it acceptable,
#			so "get" and "send" had to be worked. First full script
#			version. (development version)
#
# v0.4.1 (2006-02-09) -	The "keep them sending" version.
#			"send" and "delete" are ready to go. (development
#			version)
#
# v0.4.0 (2006-02-09) -	The "cash and carry" version.
#			"get", "getitem" and "getmoney" are in place.
#			(development version)
#
# v0.3.0 (2006-02-08) -	The "charge on delivery" version.
#			Split the CoD logic to make it easier to check and
#			maintain. (development version)
#
# v0.2.0 (2006-02-08) -	The "fetch Ubu fetch" version.
#			"newmails" is working (I got to see the client about
#			that damn icon). (development version)
#
# v0.1.0 (2006-02-08) -	The "where do we start at?" version.
#			Created the basic layout of the file and started to
#			analyse the Rivera Mail client addon to see what makes
#			it tick. (development version)
#
#


#
#	Start-TCL loading order
#
# StartTCL: n
#


#
#	namespace eval ::ngMail
#
# ::ngMail namespace and variable definitions
#
namespace eval ::ngMail {
	variable NAME "ngMail"
	variable VERSION "0.9.3"

	# Trust me, you do NOT want to set DEBUG on...
	variable DEBUG 0
	variable VERBOSE 0

	variable gm_level 6

	# SQLdb handle
	variable nghandle

	# Time in days before deleting mails
	variable cod_days 3
	variable mail_days 30

	# ngMail variable to turn the plugin on and off
	variable ACTIVE 1

	# ngMail fingerprint to send to the client addon
	variable NGMAIL_ID "MAIL_NGMAIL"

	# Configuration file
	variable conf "scripts/conf/ngmail.conf"

	# Localization settings
	variable LANG "default"

	# Language strings (en)
	variable c_dbg01 "Enter procedure"

	variable l_hlp01 "NextGen Mail System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \]%1\$c%4\$-13s - displays the current program version%1\$c%5\$-15s - shows this info"
	variable l_hlp02 "NextGen Mail System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6\$s \| %7\$s \| %8\$s \| %9\$s \| %10\$s \]%1\$c%4\$-17s - turns the plugin ON%1\$c%5\$-12s - turns the plugin OFF%1\$c%6\$-16s - removes wasted space from the database%1\$c%7\$-15s - recreates the tables from scratch%1\$c%8\$-11s - displays the underlying database API version%1\$c%9\$-13s - displays the current program version%1\$c%10\$-15s - shows this info"

	variable l_swt01 "NextGen Mail System is now %s."
	variable l_swt02 "active"
	variable l_swt03 "inactive"

	variable l_ver01 "NextGen Mail System is at version %s"

	variable l_dba01 "You are not allowed to use this command!"
	variable l_dba02 "NextGen Mail System (v%s) database"
	variable l_dba03 "Database cleanup done."
	variable l_dba04 "re-done"
	variable l_dba05 "The tables were successfully updated."
	variable l_dba06 "The tables are already up to date."
	variable l_dba07 "Database tables already exist, if you want to recreate them use%2\$c\"%1\$s\"."
	variable l_dba08 "done"
	variable l_dba09 "Database tables setup %s."

	variable h_wrk01 "Error in NextGen Mail System."

	variable m_get01 "COD Timed Out: %s"

	variable m_del01 "COD Refused: %s"

	variable m_ret01 "Returned: %s"

	variable c_sen01 "Unexpected error!"
}



#
#	proc ::ngMail::logPrefix { }
#
# Returns a string suitable to add to the console
#
proc ::ngMail::logPrefix { } {
	if { [ string length [ info procs "::Custom::LogPrefix" ] ] } {
		return "[ ::Custom::LogPrefix ]MAIL:"
	}

	return "[ clock format [ clock seconds ] -format %k:%M:%S ]:M:MAIL:"
}


#
#	proc ::ngMail::logDebug { }
#
# Returns a debug string to add to the console
#
proc ::ngMail::logDebug { } {
	return "[ ::ngMail::logPrefix ]DEBUG:"
}


#
#	proc ::ngMail::help { player }
#
# Returns a help screen depending on your level (hand called)
#
# ( add the lines:
#
# "mail_help" -
# "help_mail" { return [ ::ngMail::help $player ] }
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
proc ::ngMail::help { player } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc help{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	if { [ GetPlevel $player ] < $::ngMail::gm_level } {
		return [ format $::ngMail::l_hlp01 10 $VERSION ".mail" "version" "help" ]
	} else {
		return [ format $::ngMail::l_hlp02 10 $VERSION ".mail" "on" "off" "cleanup" "redo" "dbversion" "version" "help" ]
	}
}


#
#	proc ::ngMail::switcher { player action }
#
# Turns the plugin on/off (hand called)
#
proc ::ngMail::switcher { player action } {
	variable DEBUG
	variable ACTIVE

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc switcher{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	if { ( $player != 0 ) && ( [ GetPlevel $player ] < $::ngMail::gm_level ) } {
		return $::ngMail::l_dba01
	}

	set ACTIVE [ expr { [ string tolower $action ] == "off" ? 0 : 1 } ]
	return [ format $::ngMail::l_swt01 [ expr { $ACTIVE ? $::ngMail::l_swt02 : $::ngMail::l_swt03 } ] ]
}


#
#	proc ::ngMail::version { }
#
# Returns the version info about the plugin (hand called)
#
# ( add the lines:
#
# "mail_version" -
# "version_mail" { return [ ::ngMail::version ] }
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
proc ::ngMail::version { } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc version{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	return [ format $::ngMail::l_ver01 $VERSION ]
}


#
#	proc ::ngMail::db { player cargs }
#
# Setup/cleanup the database (hand called)
#
# ( add the lines:
#
# "try" -
# "create_maildb" { return [ ::ngMail::db $cargs ] }
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
proc ::ngMail::db { player cargs } {
	variable VERSION
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc db{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	if { ( $player != 0 ) && ( [ GetPlevel $player ] < $::ngMail::gm_level ) } {
		return $::ngMail::l_dba01
	}

	set i_maxchar 127
	set s_ret [ format $::ngMail::l_dba02 $VERSION ]

	switch [ string tolower $cargs ] {
		"version" -
		"dbversion" {
			return "$s_ret:\n\n[ ::SQLdb::versionSQLdb $nghandle ]"
		}
		"cleanup" {
			::SQLdb::cleanupSQLdb $nghandle
			return "$s_ret:\n\n$::ngMail::l_dba03"
		}
		"redo" {
			if { [ ::SQLdb::existsSQLdb $nghandle `mail` ] } {
				::SQLdb::querySQLdb $nghandle "DROP TABLE `mail`"
			}

			::SQLdb::cleanupSQLdb $nghandle
			set s_done $::ngMail::l_dba04
		}
		"_upgrade" {
			set mail 0

			if { [ ::SQLdb::existsSQLdb $nghandle `mail` ] } {
				::SQLdb::querySQLdb $nghandle "CREATE TEMPORARY TABLE `mail_t` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `from` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `to` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `subject` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `body` TEXT NOT NULL DEFAULT '', `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `money` INTEGER NOT NULL DEFAULT 0, `item_id` INTEGER NOT NULL DEFAULT 0, `item_icon` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `item_count` INTEGER NOT NULL DEFAULT 0, `cod` INTEGER NOT NULL DEFAULT 0, `read` INTEGER NOT NULL DEFAULT 0, `invoice` INTEGER NOT NULL DEFAULT 0, `deposit` INTEGER NOT NULL DEFAULT 0, `buyout` INTEGER NOT NULL DEFAULT 0, `fee` INTEGER NOT NULL DEFAULT 0)"

				foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `mail`" ] {
					if { [ llength $row ] == 16 } {
						foreach { head from subject money cod time has_item read body id item_name item_icon item_count item_id to date } $row {
							# `id` `from` `to` `subject` `body` `date` `money`
							# `item_id` `item_icon` `item_count` `cod` `read`
							# `invoice` `deposit` `buyout` `fee`
							set item [ string trim [ string trim $has_item # ] ]
							::SQLdb::querySQLdb $nghandle "INSERT INTO `mail_t` (`id`, `from`, `to`, `subject`, `body`, `date`, `money`, `item_id`, `item_icon`, `item_count`, `cod`, `read`) VALUES($id, '[ ::SQLdb::canonizeSQLdb $from ]', '[ ::SQLdb::canonizeSQLdb $to ]', '[ ::SQLdb::canonizeSQLdb [ string trim [ string trim $subject # ] ] ]', '[ ::SQLdb::canonizeSQLdb [ string trim [ string trim $body # ] ] ]', '[ clock format $date -format "%Y-%m-%d %H:%M:%S" ]', [ string trim [ string trim $money # ] ], [ expr { $item ? [ string trim [ string trim $item_id # ] ] : 0 } ], '[ expr { $item ? [ string range $item_icon 17 end ] : "" } ]', [ expr { $item ? [ string trim [ string trim $item_count # ] ] : 0 } ], [ string trim [ string trim $cod # ] ], [ expr { [ string tolower [ string trim [ string trim $read # ] ] ] eq "false" ? 0 : 1 } ])"
						}
					} else {
						foreach { head from subject money cod time has_item read body id item_name item_icon item_count item_id to } $row {
							# `id` `from` `to` `subject` `body` `date` `money`
							# `item_id` `item_icon` `item_count` `cod` `read`
							# `invoice` `deposit` `buyout` `fee`
							set item [ string trim [ string trim $has_item # ] ]
							::SQLdb::querySQLdb $nghandle "INSERT INTO `mail_t` (`id`, `from`, `to`, `subject`, `body`, `money`, `item_id`, `item_icon`, `item_count`, `cod`, `read`) VALUES($id, '[ ::SQLdb::canonizeSQLdb $from ]', '[ ::SQLdb::canonizeSQLdb $to ]', '[ ::SQLdb::canonizeSQLdb [ string trim [ string trim $subject # ] ] ]', '[ ::SQLdb::canonizeSQLdb [ string trim [ string trim $body # ] ] ]', [ string trim [ string trim $money # ] ], [ expr { $item ? [ string trim [ string trim $item_id # ] ] : 0 } ], '[ expr { $item ? [ string range $item_icon 17 end ] : "" } ]', [ expr { $item ? [ string trim [ string trim $item_count # ] ] : 0 } ], [ string trim [ string trim $cod # ] ], 0, [ expr { [ string tolower [ string trim [ string trim $read # ] ] ] eq "false" ? 0 : 1 } ])"
						}
					}
				}

				incr mail
			}

			if { [ ::SQLdb::existsSQLdb $nghandle `mail_get_money` ] } {
				foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `mail_get_money`" ] {
					foreach { id from to money } $row {
						# `id` `from` `to` `subject` `body` `date` `money`
						# `item_id` `item_icon` `item_count` `cod` `read`
						# `invoice` `deposit` `buyout` `fee`
						::SQLdb::querySQLdb $nghandle "INSERT INTO `mail_t` (`from`, `to`, `subject`, `money`, `cod`) VALUES('[ ::SQLdb::canonizeSQLdb $from ]', '[ ::SQLdb::canonizeSQLdb $to ]', 'Converted id=$id', $money, 1)"
					}
				}

				incr mail
			}

			db 0 redo

			if { $mail } {
				::SQLdb::querySQLdb $nghandle "INSERT INTO `mail` SELECT * FROM `mail_t`"
				::SQLdb::querySQLdb $nghandle "DROP TABLE `mail_t`"
				return "$s_ret:\n\n$::ngMail::l_dba05"
			} else {
				return "$s_ret:\n\n$::ngMail::l_dba06"
			}
		}
		"_update" {
			set mail 0

			if { [ ::SQLdb::existsSQLdb $nghandle `mail` ] } {
				::SQLdb::querySQLdb $nghandle "CREATE TEMPORARY TABLE `mail_t` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `from` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `to` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `subject` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `body` TEXT NOT NULL DEFAULT '', `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `money` INTEGER NOT NULL DEFAULT 0, `item_id` INTEGER NOT NULL DEFAULT 0, `item_icon` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `item_count` INTEGER NOT NULL DEFAULT 0, `cod` INTEGER NOT NULL DEFAULT 0, `read` INTEGER NOT NULL DEFAULT 0, `invoice` INTEGER NOT NULL DEFAULT 0, `deposit` INTEGER NOT NULL DEFAULT 0, `buyout` INTEGER NOT NULL DEFAULT 0, `fee` INTEGER NOT NULL DEFAULT 0)"
				::SQLdb::querySQLdb $nghandle "INSERT INTO `mail_t` SELECT * FROM `mail`"
				incr mail
			}

			db 0 redo

			if { $mail } {
				::SQLdb::querySQLdb $nghandle "INSERT INTO `mail` SELECT * FROM `mail_t`"
				::SQLdb::querySQLdb $nghandle "DROP TABLE `mail_t`"
				return "$s_ret:\n\n$::ngMail::l_dba05"
			} else {
				return "$s_ret:\n\n$::ngMail::l_dba06"
			}
		}
		"" {
		}
		default {
			return [ help $player ]
		}
	}

	if { ! [ ::SQLdb::existsSQLdb $nghandle `mail` ] } {
		::SQLdb::querySQLdb $nghandle "CREATE TABLE `mail` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `from` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `to` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `subject` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `body` TEXT NOT NULL DEFAULT '', `date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `money` INTEGER NOT NULL DEFAULT 0, `item_id` INTEGER NOT NULL DEFAULT 0, `item_icon` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `item_count` INTEGER NOT NULL DEFAULT 0, `cod` INTEGER NOT NULL DEFAULT 0, `read` INTEGER NOT NULL DEFAULT 0, `invoice` INTEGER NOT NULL DEFAULT 0, `deposit` INTEGER NOT NULL DEFAULT 0, `buyout` INTEGER NOT NULL DEFAULT 0, `fee` INTEGER NOT NULL DEFAULT 0)"

		if { ! [ info exists s_done ] } {
			set s_done $::ngMail::l_dba08
		}

		append s_ret ":\n\n" [ format $::ngMail::l_dba09 $s_done ]
	} else {
		append s_ret ":\n\n" [ format $::ngMail::l_dba07 ".mail redo" 10 ]
	}

	return $s_ret
}



#
#	proc ::ngMail::work { player command cargs }
#
# Master procedure redirects to the local ones
#
# ( add the lines:
#
# "maildo_delete" { return [ ::ngMail::work $player "delete" $cargs }
# "maildo_get" { return [ ::ngMail::work $player "get" $cargs }
# "maildo_getitem" { return [ ::ngMail::work $player "getitem" $cargs }
# "maildo_getmoney" { return [ ::ngMail::work $player "getmoney" $cargs }
# "maildo_newmails" { return [ ::ngMail::work $player "newmails" $cargs }
# "maildo_read" { return [ ::ngMail::work $player "read" $cargs }
# "maildo_returnmail" { return [ ::ngMail::work $player "returnmail" $cargs }
# "maildo_send" { return [ ::ngMail::work $player "send" $cargs }
# "maildo_serverinfo" { return [ ::ngMail::work $player "serverinfo" $cargs }
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
proc ::ngMail::work { player command cargs } {
	variable DEBUG
	variable ACTIVE

	if { ! $ACTIVE } {
		return
	}

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc work{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
		puts "$s_logDEBUG player=\"$player\" command=\"$command\" cargs=\"$cargs\""
	}

	if { $command == "" } {
		return $::ngMail::h_wrk01
	}

	set cargs [ string trim $cargs ]

	switch $command {
		"newmails" {
			return [ newmails $player ]
		}
		"get" {
			return [ get $player ]
		}
		"getmoney" {
			return [ getmoney $player $cargs ]
		}
		"getitem" {
			return [ getitem $player $cargs ]
		}
		"delete" {
			return [ delete $cargs ]
		}
		"read" {
			return [ read $cargs ]
		}
		"returnmail" {
			return [ returnmail $cargs ]
		}
		"send" {
			return [ send $player $cargs ]
		}
		"serverinfo" {
			return [ serverinfo ]
		}
	}
}


#
#	proc ::ngMail::newmails { player }
#
# Internal procedure to verify the existence of new mail
#
proc ::ngMail::newmails { player } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc newmails{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	return [ expr { [ ::SQLdb::booleanSQLdb $nghandle "SELECT * FROM `mail` WHERE (`to` LIKE '[ ::SQLdb::canonizeSQLdb [ GetName $player ] ]' AND `read` = 0)" ] ? "MAIL_HASNEWMAIL" : "MAIL_NONEWMAILS" } ]
}


#
#	proc ::ngMail::serverinfo { }
#
# Internal procedure to inform the client of what server plugin we are
#
proc ::ngMail::serverinfo { } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc serverinfo{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	return "$::ngMail::NGMAIL_ID\r$::ngMail::VERSION"
}


#
#	proc ::ngMail::get { player }
#
# Internal procedure to get available mail
#
proc ::ngMail::get { player } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc get{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	set pname [ ::SQLdb::canonizeSQLdb [ GetName $player ] ]
	set true "true"
	set false "false"
	set result ""
	set now [ clock seconds ]
	set header "MAIL_SUBJECT\r"
	::SQLdb::booleanSQLdb $nghandle "DELETE FROM `mail` WHERE (`date` < '[ clock format [ expr { $now - ( $::ngMail::mail_days * 24 * 60 * 60 ) } ] -format "%Y-%m-%d %H:%M:%S" ]' AND `to` LIKE '$pname' AND `cod` = 0)"

	foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT `id`, `item_id`, `cod` FROM `mail` WHERE (`date` < '[ clock format [ expr { $now - ( $::ngMail::cod_days * 24 * 60 * 60 ) } ] -format "%Y-%m-%d %H:%M:%S" ]' AND `to` LIKE '$pname' AND `cod` = 1)" ] {
		foreach { id item_id cod } $row {
			# `id` `from` `to` `subject` `body` `date` `money`
			# `item_id` `item_icon` `item_count` `cod` `read`
			# `invoice` `deposit` `buyout` `fee`
			if { $DEBUG } {
				puts "$s_logDEBUG id=\"$id\" item_id=\"$item_id\" cod=\"$cod\""
			}

			if { $item_id && $cod } {
				::SQLdb::booleanSQLdb $nghandle "UPDATE `mail` SET `from` = `to`, `to` = `from`, `subject` = '[ ::SQLdb::canonizeSQLdb [ format $::ngMail::m_get01 [ lindex [ GetScpValue "items.scp" "item $item_id" "name" ] 0 ] ] ]', `body` = '', `money` = 0, `cod` = 0, `read` = 0 WHERE (`id` = $id)"
			} else {
				::SQLdb::booleanSQLdb $nghandle "DELETE FROM `mail` WHERE (`id` = $id)"
			}
		}
	}

	foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `mail` WHERE (`to` LIKE '$pname') ORDER BY `date` DESC" ] {
		foreach { id from to subject body date money item_id item_icon item_count cod read invoice deposit buyout fee } $row {
			# `id` `from` `to` `subject` `body` `date` `money`
			# `item_id` `item_icon` `item_count` `cod` `read`
			# `invoice` `deposit` `buyout` `fee`
			append result $header $from # $subject # [ expr { $cod ? 0 : $money } ] # [ expr { $cod ? $money : 0} ] # [ expr { ( double( [ clock scan $date ] + ( ( $cod ? $::ngMail::cod_days : $::ngMail::mail_days ) * 24 * 60 * 60 ) - $now ) ) / 60 / 60 / 24 } ] # [ expr { ! ( ! $item_id ) } ] # [ expr { $read ? $true : $false } ] # $body # $id # [ expr { $item_id ? "[ lindex [ GetScpValue "items.scp" "item $item_id" "name" ] 0 ]#Interface;Icons;$item_icon#$item_count#$item_id" : "0#0#0#0" } ] # $invoice # $deposit # $buyout # $fee # \n
		}
	}

	if { $DEBUG } {
		puts "$s_logDEBUG result=\"$result\""
	}

	return $result
}


#
#	proc ::ngMail::getmoney { player id }
#
# Internal procedure to retrieve money from a mail message
#
proc ::ngMail::getmoney { player id } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc getmoney{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
		puts "$s_logDEBUG player=\"$player\" id=\"$id\""
	}

	if { [ ChangeMoney $player +[ ::SQLdb::firstcellSQLdb $nghandle "SELECT `money` FROM `mail` WHERE (`id` = $id)" ] ] } {
		::SQLdb::booleanSQLdb $nghandle "UPDATE `mail` SET `money` = 0, `read` = 1 WHERE (`id` = $id)"
	}
}


#
#	proc ::ngMail::getitem { player id }
#
# Internal procedure to retrieve an item from a mail message
#
proc ::ngMail::getitem { player id } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc getitem{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	set stamp 30
	set money [ ::SQLdb::firstcellSQLdb $nghandle "SELECT `money` FROM `mail` WHERE (`id` = $id AND `cod` = 1)" ]
	set money [ expr { [ string length $money ] ? $money : 0 } ]

	if { ! [ ChangeMoney $player -$money ] } {
		return "MAIL_GETITEM_NOMONEY"
	}

	foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT `from`, `item_id`, `item_count`, `cod` FROM `mail` WHERE (`id` = $id)" ] {
		foreach { from item_id item_count cod } $row {
			# `id` `from` `to` `subject` `body` `date` `money`
			# `item_id` `item_icon` `item_count` `cod` `read`
			# `invoice` `deposit` `buyout` `fee`
			if { $DEBUG } {
				puts "$s_logDEBUG from=\"$from\" item_id=\"$item_id\" item_count=\"$item_count\" cod=\"$cod\""
			}

			while { $item_count } {
				AddItem $player $item_id
				incr item_count -1
			}

			::SQLdb::booleanSQLdb $nghandle "UPDATE `mail` SET `money` = 0, `item_id` = 0, `item_count` = 0, [ expr { $cod ? " `cod` = 0," : "" } ] `read` = 1 WHERE (`id` = $id)"

			if { $cod } {
				::SQLdb::booleanSQLdb $nghandle "INSERT INTO `mail` (`from`, `to`, `subject`, `money`, `cod`) VALUES('[ ::SQLdb::canonizeSQLdb [ GetName $player ] ]', '[ ::SQLdb::canonizeSQLdb $from ]', '[ ::SQLdb::canonizeSQLdb [ lindex [ GetScpValue "items.scp" "item $item_id" "name" ] 0 ] ]', [ expr { $money - $stamp } ], $cod)"
				return "MAIL_GETITEM_COD"
			}
		}
	}
}


#
#	proc ::ngMail::delete { id }
#
# Internal procedure to delete a mail message
#
proc ::ngMail::delete { id } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc delete{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT `item_id`, `cod` FROM `mail` WHERE (`id` = $id)" ] {
		foreach { item_id cod } $row {
			# `id` `from` `to` `subject` `body` `date` `money`
			# `item_id` `item_icon` `item_count` `cod` `read`
			# `invoice` `deposit` `buyout` `fee`
			if { $DEBUG } {
				puts "$s_logDEBUG item_id=\"$item_id\" cod=\"$cod\""
			}

			if { $item_id && $cod } {
				::SQLdb::booleanSQLdb $nghandle "UPDATE `mail` SET `from` = `to`, `to` = `from`, `subject` = '[ ::SQLdb::canonizeSQLdb [ format $::ngMail::m_del01 [ lindex [ GetScpValue "items.scp" "item $item_id" "name" ] 0 ] ] ]', `body` = '', `money` = 0, `cod` = 0, `read` = 0 WHERE (`id` = $id)"
			} else {
				::SQLdb::booleanSQLdb $nghandle "DELETE FROM `mail` WHERE (`id` = $id)"
			}
		}
	}

	return "MAIL_DELETEOK"
}


#
#	proc ::ngMail::read { id }
#
# Internal procedure to mark a mail message as read
#
proc ::ngMail::read { id } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc read{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT `date`, `cod` FROM `mail` WHERE (`id` = $id)" ] {
		foreach { date cod } $row {
			# `id` `from` `to` `subject` `body` `date` `money`
			# `item_id` `item_icon` `item_count` `cod` `read`
			# `invoice` `deposit` `buyout` `fee`
			set diff_secs [ expr { ( $::ngMail::mail_days - $::ngMail::cod_days ) * 60 * 60 * 24 } ]
			set date_secs [ clock scan $date ]
			set curr_secs [ clock seconds ]
			::SQLdb::booleanSQLdb $nghandle "UPDATE `mail` SET `read` = 1, `date` = '[ expr { $cod ? $date : [ expr { ( $curr_secs - $date_secs ) > $diff_secs ? $date : [ clock format [ expr { ( $date_secs - $diff_secs ) < ( $curr_secs - ( $::ngMail::mail_days * 60 * 60 * 24 ) ) ? $curr_secs - $diff_secs : $date_secs - $diff_secs } ] -format "%Y-%m-%d %H:%M:%S" ] } ] } ]' WHERE (`id` = $id)"
		}
	}

	return "MAIL_READOK"
}


#
#	proc ::ngMail::returnmail { id }
#
# Internal procedure to return a mail message to the sender
#
proc ::ngMail::returnmail { id } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc returnmail{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	foreach row [ ::SQLdb::querySQLdb $nghandle "SELECT `subject`, `cod` FROM `mail` WHERE (`id` = $id)" ] {
		foreach { subject cod } $row {
			# `id` `from` `to` `subject` `body` `date` `money`
			# `item_id` `item_icon` `item_count` `cod` `read`
			# `invoice` `deposit` `buyout` `fee`
			if { $DEBUG } {
				puts "$s_logDEBUG subject=\"$subject\" cod=\"$cod\""
			}

			::SQLdb::booleanSQLdb $nghandle "UPDATE `mail` SET `from` = `to`, `to` = `from`, `subject` = '[ ::SQLdb::canonizeSQLdb [ format $::ngMail::m_ret01 $subject ] ]', [ expr { $cod ? "`money` = 0, `cod` = 0," : "" } ] `read` = 0 WHERE (`id` = $id)"
		}
	}

	return "MAIL_SENTOK"
}


#
#	proc ::ngMail::send { player cargs }
#
# Internal procedure to send a mail message
#
proc ::ngMail::send { player cargs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc send{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	if { [ expr { ! $player || ! [ string length $cargs ] } ] } {
		if { $DEBUG } {
			puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
		}

		return "MAIL_SENTFAIL"
	}

	set pname [ GetName $player ]
	set stamp 30
	set i_texture_path 16

	foreach { item to subject body money item_name item_icon item_count cod } [ split [ string trim [ string trim [ join $cargs ] # ] ] # ] {
		set item_id 0
		set cod [ expr { [ string length $cod ] ? $cod : 0 } ]

		if { $DEBUG } {
			puts "$s_logDEBUG item=\"$item\" to=\"$to\" subject=\"$subject\" body=\"$body\" money=\"$money\" item_name=\"$item_name\" item_icon=\"$item_icon\" item_count=\"$item_count\" cod=\"$cod\""
		}

		if { [ expr { [ string tolower [ string trim $to ] ] eq [ string tolower $pname ] } ] } {
			if { $DEBUG } {
				puts "$s_logDEBUG ERR_MAIL_TO_SELF"
			}

			return "ERR_MAIL_TO_SELF"
		}

		if { ! $cod } {
			if { ! [ ChangeMoney $player -[ expr { $money + $stamp } ] ] } {
				return "MAIL_GETITEM_NOMONEY"
			}
		}

		if { $item } {
			if { [ string is digit -strict $item_name ] } {
				set item_id $item_name
			} else {
				set item_id [ ::Custom::GetID $item_name ]
			}

			set item_icon [ string range $item_icon $i_texture_path end ]

			switch [ GetScpValue "items.scp" "item $item_id" "bonding" ] {
				1 -
				2 -
				3 {
					return "ERR_MAIL_BOUND_ITEM"
				}
				4 -
				5 {
					return "ERR_MAIL_QUEST_ITEM"
				}
			}

			if { ! [ ConsumeItem $player $item_id $item_count ] } {
				return "MAIL_SENTFAIL"
			}
		} elseif { $cod } {
			if { $DEBUG } {
				puts "$s_logDEBUG MAIL_SENTFAIL: item=\"$item\" cod=\"$cod\""
			}

			return "MAIL_SENTFAIL"
		}

		::SQLdb::booleanSQLdb $nghandle "INSERT INTO `mail` (`from`, `to`, `subject`, `body`, `money`, `item_id`, `item_icon`, `item_count`, `cod`) VALUES('[ ::SQLdb::canonizeSQLdb $pname ]', '[ ::SQLdb::canonizeSQLdb [ string trim $to ] ]', '[ ::SQLdb::canonizeSQLdb [ string trim $subject ] ]', '[ ::SQLdb::canonizeSQLdb [ string trim $body ] ]', $money, $item_id, '$item_icon', [ expr { [ string length $item_count ] ? $item_count : 0 } ], $cod)"
		return "MAIL_SENTOK"
	}

	if { $DEBUG } {
		puts "$s_logDEBUG MAIL_SENTFAIL: $::ngMail::c_sen01"
	}

	return "MAIL_SENTFAIL"
}


#
#	proc ::ngMail::db_trace { sql }
#
# Internal procedure to trace the database calls
#
proc ::ngMail::db_trace { sql } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc db_trace{}:"
		puts "$s_logDEBUG $sql"
	}
}


#	proc ::ngMail::setSQLdb { }
#
# Internal procedure to set, check and update the SQLdb database entry
#
proc ::ngMail::setSQLdb { } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc setSQLdb{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	if { ! [ ::SQLdb::booleanSQLdb $nghandle "SELECT * FROM `$::SQLdb::NAME` WHERE (`name` = '$::ngMail::NAME')" ] } {
		if { [ ::SQLdb::existsSQLdb $nghandle `mail` ] } {
			db 0 _finalmail
		} else {
			db 0 ""
		}

		::SQLdb::querySQLdb $nghandle "INSERT INTO `$::SQLdb::NAME` (`name`, `version`) VALUES('$::ngMail::NAME', '$::ngMail::VERSION')"
	} else {
		set s_oldver [ ::SQLdb::firstcellSQLdb $nghandle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$::ngMail::NAME')" ]

		if { [ expr { $s_oldver > $::ngMail::VERSION } ] } {
			if { $DEBUG } {
				return -code error "$s_logDEBUG The current version of $::ngMail::NAME ($::ngMail::VERSION) is older that the previous one ($s_oldver), downgrade unsupported!"
			} else {
				return -code error "$SQLdb::s_logprefix: The current version of $::ngMail::NAME ($::ngMail::VERSION) is older that the previous one ($s_oldver), downgrade unsupported!"
			}
		} elseif { [ expr { $s_oldver < $::ngMail::VERSION } ] } {
			db 0 _update
			::SQLdb::querySQLdb $nghandle "UPDATE `$SQLdb::NAME` SET `version` = '$::ngMail::VERSION', `previous` = '$s_oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$::ngMail::NAME')"
		} else {
			db 0 ""
		}
	}
}


#
#	proc ::ngMail::readConf { config }
#
# Internal procedure to read the configuration file and set the system
#
proc ::ngMail::readConf { config } {
	variable DEBUG
	variable VERBOSE
	variable LANG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc readConf{}:"
		puts "$s_logDEBUG Enter procedure"
	}

	if { [ ::Custom::GetScriptVersion "Custom" ] >= "1.93" } {
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
						"daystokeepmail" {
							if { [ string tolower $value ] != "default" } {
								set ::ngMail::mail_days $value
							}
						}
						"daystokeepcod" {
							if { [ string tolower $value ] != "default" } {
								set ::ngMail::cod_days $value
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
									set s_logDEBUG "[ ::ngMail::logDebug ] proc readConf{}:"
								}
							}
						}
						"pluginactive" {
							set value [ string tolower $value ]

							if { $value == "no" || $value == "off" || $value == "false" } {
								set ::ngMail::ACTIVE 0
							}
						}
						default {
							if { [ info exists ::ngMail::$key ] } {
								if { [ string tolower $value ] != "default" } {
									set ::ngMail::$key $value
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

					if { [ info exists ::ngMail::$key ] } {
						set ::ngMail::$key $value
					}
				}
			}
		}
	} else {
		proc ::ngMail::dropNoise { string } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc dropNoise{}:"
				puts "$s_logDEBUG Enter procedure"
			}

			set string [ string trim $string ]

			set comment [ string first "#" $string ]

			if { $comment != -1 } {
				set string [ string trim [ string range $string 0 [ expr { $comment - 1 } ] ] ]
			}

			set comment [ string first "//" $string ]

			if { $comment != -1 } {
				set string [ string trim [ string range $string 0 [ expr { $comment - 1 } ] ] ]
			}

			return $string
		}

		set section -1
		set lines 0

		if { ! [ file exists $config ] } {
			if { $DEBUG } {
				puts "$s_logDEBUG Configuration file \[$config\] missing, setting defaults and language to English."
			} elseif { $VERBOSE } {
				puts "[ ::ngMail::logPrefix ] Configuration file \[$config\] missing, setting defaults and language to English."
			}
		} else {
			set f_handle [ open $config ]

			while { ! [ eof $f_handle ] } {
				if { ! [ gets $f_handle s_line ] } {
					continue
				}

				incr lines
				set s_line [ dropNoise $s_line ]

				if { ! [ string length $s_line ] } {
					continue
				}

				if { [ string index $s_line 0 ] == "\[" && [ string index $s_line end ] == "\]"} {
					incr section

					if { [ string tolower [ string trim [ string trim $s_line \[\] ] ] ] == "global" } {
						if { $section } {
							close $f_handle

							if { $DEBUG } {
								puts "$s_logDEBUG Section \[GLOBAL\] from \"$config\" is misplaced, it must be the first section in the file, setting defaults and language to English!"
							} elseif { $VERBOSE } {
								puts "[ ::ngMail::logPrefix ] Section \[GLOBAL\] from \"$config\" is misplaced, it must be the first section in the file, setting defaults and language to English!"
							}

							return 0
						}

						while { ! [ eof $f_handle ] } {
							if { ! [ gets $f_handle s_line ] } {
								continue
							}

							incr lines
							set s_line [ dropNoise $s_line ]

							if { ! [ string length $s_line ] } {
								continue
							}

							if { [ string index $s_line 0 ] == "\[" && [ string index $s_line end ] == "\]"} {
								close $f_handle
								set f_handle [ open $config ]
								set lines [ expr { $lines - 1 } ]

								for { set i 0 } { $i < $lines } { incr i } {
									gets $f_handle
								}

								break
							}

							set s_line [ split $s_line "=" ]
							set s_key [ string tolower [ string trim [ lindex $s_line 0 ] ] ]
							set s_value [ string trim [ string trim [ lindex $s_line 1 ] ] \" ]

							if { $DEBUG } {
								puts "$s_logDEBUG s_key=\"$s_key\" s_value=\"$s_value\""
							}

							switch $s_key {
								"lang" {
									set ::ngMail::LANG $s_value
								}
								"daystokeepmail" {
									if { [ string tolower $s_value ] != "default" } {
										set ::ngMail::mail_days $s_value
									}
								}
								"daystokeepcod" {
									if { [ string tolower $s_value ] != "default" } {
										set ::ngMail::cod_days $s_value
									}
								}
								"debug" {
									set s_value [ string tolower $s_value ]

									if { $s_value != "default" } {
										if { $s_value == "yes" || $s_value == "on" || $s_value == "true" || $s_value == 1 } {
											set DEBUG 1
										} elseif { $s_value == "no" || $s_value == "off" || $s_value == "false" || $s_value == 0 } {
											set DEBUG 0
										}

										if { $DEBUG } {
											set s_logDEBUG "[ ::ngMail::logDebug ] proc readConf{}:"
										}
									}
								}
								"pluginactive" {
									set s_value [ string tolower $s_value ]

									if { $s_value == "no" || $s_value == "off" || $s_value == "false" } {
										set ::ngMail::ACTIVE 0
									}
								}
								default {
									if { [ info exists ::ngMail::$s_key ] } {
										if { [ string tolower $s_value ] != "default" } {
											set ::ngMail::$s_key $s_value
										}
									}
								}
							}
						}

						if { [ eof $f_handle ] } {
							close $f_handle

							if { $DEBUG } {
								puts "$s_logDEBUG End of file reached while reading \[GLOBAL\] from \"$config\", setting defaults and language to English!"
							} elseif { $VERBOSE } {
								puts "[ ::ngMail::logPrefix ] End of file reached while reading \[GLOBAL\] from \"$config\", setting defaults and language to English!"
							}

							return 0
						}
					} else {
						if { ! $section } {
							close $f_handle

							if { $DEBUG } {
								puts "$s_logDEBUG Section \[GLOBAL\] from \"$config\" is missing or misplaced, it must be the first section in the file, setting defaults and language to English!"
							} elseif { $VERBOSE } {
								puts "[ ::ngMail::logPrefix ] Section \[GLOBAL\] from \"$config\" is missing or misplaced, it must be the first section in the file, setting defaults and language to English!"
							}

							return 0
						}
					}
				}

				if { [ string tolower $::ngMail::LANG ] == "default" } {
					close $f_handle

					if { $DEBUG } {
						puts "$s_logDEBUG Setting language defaults to English"
					} elseif { $VERBOSE } {
						puts "[ ::ngMail::logPrefix ] Setting language defaults to English"
					}

					return 0
				}

				while { ! [ eof $f_handle ] } {
					if { ! [ gets $f_handle s_line ] } {
						continue
					}

					incr lines
					set s_line [ dropNoise $s_line ]

					if { ! [ string length $s_line ] } {
						continue
					}

					if { [ string index $s_line 0 ] == "\[" && [ string index $s_line end ] == "\]"} {
						if { [ string tolower [ string trim [ string trim $s_line \[\] ] ] ] == [ string tolower $::ngMail::LANG ] } {
							break
						}
					}
				}

				if { [ eof $f_handle ] } {
					close $f_handle

					if { $DEBUG } {
						puts "$s_logDEBUG End of file reached while searching for \[[ string toupper $::ngMail::LANG ]\] from \"$config\", setting language defaults to English!"
					} elseif { $VERBOSE } {
						puts "[ ::ngMail::logPrefix ] End of file reached while searching for \[[ string toupper $::ngMail::LANG ]\] from \"$config\", setting language defaults to English!"
					}

					return 0
				}

				while { ! [ eof $f_handle ] } {
					if { ! [ gets $f_handle s_line ] } {
						continue
					}

					incr lines
					set s_line [ dropNoise $s_line ]

					if { ! [ string length $s_line ] } {
						continue
					}

					if { [ string index $s_line 0 ] == "\[" && [ string index $s_line end ] == "\]"} {
						break
					}

					set s_line [ split $s_line "=" ]
					set s_key [ string tolower [ string trim [ lindex $s_line 0 ] ] ]
					set s_value [ string trim [ string trim [ lindex $s_line 1 ] ] \" ]

					if { $DEBUG } {
						puts "$s_logDEBUG s_key=\"$s_key\" s_value=\"$s_value\""
					}

					if { [ info exists ::ngMail::$s_key ] } {
						set ::ngMail::$s_key $s_value
					}
				}

				break
			}

			close $f_handle
		}
	}
}


#
#	proc ::ngMail::commands { }
#
# Internal procedure to create the commands needed to run the script
#
proc ::ngMail::commands { } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc commands{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	if { [ string length [ info procs "::Custom::AddCommand" ] ] } {
		proc ::ngMail::maildo_delete { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_delete{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "delete" $cargs ]
		}

		proc ::ngMail::maildo_get { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_get{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "get" $cargs ]
		}

		proc ::ngMail::maildo_getitem { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_getitem{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "getitem" $cargs ]
		}

		proc ::ngMail::maildo_getmoney { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_getmoney{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "getmoney" $cargs ]
		}

		proc ::ngMail::maildo_newmails { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_newmails{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "newmails" $cargs ]
		}

		proc ::ngMail::maildo_read { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_read{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "read" $cargs ]
		}

		proc ::ngMail::maildo_returnmail { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_returnmail{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "returnmail" $cargs ]
		}

		proc ::ngMail::maildo_send { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_send{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "send" $cargs ]
		}

		proc ::ngMail::maildo_serverinfo { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc maildo_serverinfo{}:"
				puts "$s_logDEBUG Enter procedure"
				puts "$s_logDEBUG player=\"$player\" cargs=\"$cargs\""
			}

			return [ ::ngMail::work $player "serverinfo" $cargs ]
		}

		proc ::ngMail::mail { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc mail{}:"
				puts "$s_logDEBUG Enter procedure"
			}

			switch [ string tolower [ lindex $cargs 0 ] ] {
				"version" {
					return [ ::ngMail::version ]
				}
				"dbversion" -
				"cleanup" -
				"redo" {
					return [ ::ngMail::db $player $cargs ]
				}
				"on" -
				"off" {
					return [ ::ngMail::switcher $player $cargs ]
				}
				default {
					return [ ::ngMail::help $player ]
				}
			}
		}

		proc ::ngMail::mail_help { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc mail_help{}:"
				puts "$s_logDEBUG Enter procedure"
			}

			return [ ::ngMail::help $player ]
		}

		proc ::ngMail::mail_version { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngMail::logDebug ] proc mail_version{}:"
				puts "$s_logDEBUG Enter procedure"
			}

			return [ ::ngMail::version ]
		}

		::Custom::AddCommand "maildo_delete" "::ngMail::maildo_delete"
		::Custom::AddCommand "maildo_get" "::ngMail::maildo_get"
		::Custom::AddCommand "maildo_getitem" "::ngMail::maildo_getitem"
		::Custom::AddCommand "maildo_getmoney" "::ngMail::maildo_getmoney"
		::Custom::AddCommand "maildo_newmails" "::ngMail::maildo_newmails"
		::Custom::AddCommand "maildo_read" "::ngMail::maildo_read"
		::Custom::AddCommand "maildo_returnmail" "::ngMail::maildo_returnmail"
		::Custom::AddCommand "maildo_send" "::ngMail::maildo_send"
		::Custom::AddCommand "maildo_serverinfo" "::ngMail::maildo_serverinfo"
		::Custom::AddCommand "mail" "::ngMail::mail"
		::Custom::AddCommand "create_maildb" "::ngMail::mail"
		::Custom::AddCommand "try" "::ngMail::mail"
		::Custom::AddCommand "mail_help" "::ngMail::mail_help"
		::Custom::AddCommand "help_mail" "::ngMail::mail_help"
		::Custom::AddCommand "mail_version" "::ngMail::mail_version"
		::Custom::AddCommand "version_mail" "::ngMail::mail_version"
	} else {
		rename ::WoWEmu::Command ::WoWEmu::Command_ngmail

		proc ::WoWEmu::Command { args } {
			regsub -all -- {\}} $args {} largs
			regsub -all -- {\{} $largs {} largs
			regsub -all -- {\]} $largs {} largs
			regsub -all -- {\[} $largs {} largs
			regsub -all -- {\$} $largs {} largs
			regsub -all -- {\\} $largs {} largs
			set player [ lindex $largs 0 ]
			set s_command [ string tolower [ lindex $largs 1 ] ]
			set cargs [ lrange $largs 2 end ]

			switch -glob $s_command {
				"maildo_*" {
					return [ ::ngMail::work $player [ string range $s_command [ expr { [ string first "_" $s_command ] + 1 } ] end ] $cargs ]
				}
				"create_maildb" -
				"try" -
				"mail" {
					switch [ string tolower [ lindex $cargs 0 ] ] {
						"version" {
							return [ ::ngMail::version ]
						}
						"dbversion" -
						"cleanup" -
						"redo" {
							return [ ::ngMail::db $player $cargs ]
						}
						"on" -
						"off" {
							return [ ::ngMail::switcher $player $cargs ]
						}
						default {
							return [ ::ngMail::help $player ]
						}
					}
				}
				"mail_help" -
				"help_mail" {
					return [ ::ngMail::help $player ]
				}
				"mail_version" -
				"version_mail" {
					return [ ::ngMail::version ]
				}
				default {
					return [ ::WoWEmu::Command_ngmail $args ]
				}
			}

			return "Bad command"
		}
	}
}


#
#	proc ::ngMail::init { }
#
# Internal procedure to setup the program
#
proc ::ngMail::init { } {
	variable DEBUG
	variable conf
	variable nghandle
	package require SQLdb

	if { [ info exists "::StartTCL::VERSION" ] } {
		set DEBUG $::DEBUG
		set ::ngMail::VERBOSE $::VERBOSE
		set ::ngMail::LANG $::LANG
	}

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngMail::logDebug ] proc init{}:"
		puts "$s_logDEBUG $::ngMail::c_dbg01"
	}

	if { [ ::Custom::GetScriptVersion "StartTCL" ] >= "0.9.0" } {
		::StartTCL::Require "Custom"
		::StartTCL::Provide $::ngMail::NAME $::ngMail::VERSION
	}

	::ngMail::commands
	::ngMail::readConf $conf

	if { ! [ info exists nghandle ] } {
		set ::SQLdb::nghandle [ ::SQLdb::openSQLdb ]
	}

	set nghandle $::SQLdb::nghandle

	if { $DEBUG } {
		::SQLdb::traceSQLdb $nghandle ::ngMail::db_trace
	}

	::ngMail::setSQLdb
}


#
#	startup time command execution
#
# Run the "init" procedure at server start
#
::ngMail::init
