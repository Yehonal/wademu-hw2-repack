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
#               <http://www.gnu.org/copyleft/lesser.html>
#
#
# This program is based on the reverse engineering of a compiled TCL script
# authored by OXOThuk, who graciously allowed the licensing of this derivated
# work under the above License. This does not imply that the original code
# nor its versions are under the same license as long as they don't include
# code specific from this program. Only this program and derivated work from it
# are subject to the above License. The original code is (c) OXOThuk and you
# must contact him for licensing details.
#
#
# Name:		ngAuction.tcl
#
# Version:	1.0.2
#
# Date:		2006-04-13
#
# Description:	NextGen Auction House System
#
# Author:	Lazarus Long <lazarus.long@bigfoot.com>
#
# Changelog:
#
# v1.0.2 (2006-04-13) -	The "going nowhere" version.
#			Re-done the documentation to point to the new thread.
#
# v1.0.1 (2006-03-28) -	The "minor adjustments" version.
#			I need a new brain. Damn stupid little things made me
#			make a new version. Corrected minor glitches.
#
# v1.0.0 (2006-03-28) -	The "at last we made it" version.
#			Fixed the dealing with activating DEBUG on the config
#			file. Removed the 5 second fuziness when calling the
#			"process" procedure when it is hooked to the procedure
#			"::WoWEmu::Commands". Converted it to use ReadConf from
#			Custom, and Provide and Requires from StartTCL. Added
#			Spanish Standard translation thanks to JOS3. Updated
#			the client addon to avoid the ".auct" bug and added
#			public key signature.
#
# v0.9.9 (2006-03-02) -	The "server friendly" version.
#			As sugested by spirit, moved the hooked function from
#			"::AI::CanUnAgro" to "::WoWEmu::Commands" since it's
#			less heavy on the server and the auction timeout isn't
#			a crucial to the part-of-a-second thing. Added Chilian
#			Spanish translation thanks to EZ-Mouse. Added support
#			for the new StartTCL scheme of loading files.
#
# v0.9.8 (2006-02-20) -	The "who is missing" version.
#			To make the Auction Invoices as Blizz-like as possible
#			I needed to pass along the buyer or seller of the item,
#			hence new (and final) change to "SendMail". Updated
#			again the Russian translation.
#
# v0.9.7 (2006-02-19) -	The "to invoice or not to invoice" version.
#			Redid the "SendMail" procedure to issue Blizzard
#			compatible invoices when connected to ngMail, adapted
#			existing calls to it. Added French translation, thanks
#			to spirit. Added German translation, thanks to
#			Ramanubis. Converted the script to use spirit's custom
#			procedures "::Custom::AddCommand" and
#			"::Custom::HookProc" if present (I hope I did it
#			correctly, I'm not sure of the second one).
#
# v0.9.6 (2006-02-17) -	The "handle it to spirit" version.
#			Corrected the dealing with the database handle due to a
#			wrong interpretation of the variable linking concept,
#			after spirit called my attention to it. Thank you
#			spirit. Corrected a stupid error I introduced in last
#			version, thanks Vasya for reporting and spirit for
#			correcting. Added Russian translation, thanks to
#			Neo_mat for the work. Corrected an error I made in the
#			"readConf" procedure that whould read the config file
#			to the end even if it was already loaded the chosen
#			language.
#
# v0.9.5 (2006-02-13) -	The "let's go international" version.
#			Added the first translation, Hungarian, thanks to
#			merkantizis for the work. Renamed some functions for
#			clarity. Moved the handle to the SQLdb namespace to
#			prepare for multiple plugins using it. Simplified the
#			SQL statements when doing a update. Modified the
#			"readConf" procedure to allow global definitions.
#			Prepared the "SendMail" procedure to work both with
#			Golgorth's Final Mail 1.0 and ngMail.
#
# v0.9.4 (2006-02-08) -	The "check and double check, please..." version.
#			Found a non standard SQL statement in the proc
#			"create_auctiondb" which crashed the plugin for MySQL
#			users when performing an upgrade from a previous
#			version (nobody complained because there was no
#			previous version to compare to). Also created some
#			aliases for commands all starting with ".auction",
#			use ".auction help" for a list.
#
# v0.9.3 (2006-02-07) -	The "babelfish? what babelfish?" version.
#			OK localization is done. A new file with localization
#			strings is part of the plugin "scripts/ngauction.conf".
#			I'm finished! The development cycle for the plugin is
#			near it's end, I'm reserving the remaining revision
#			numbers for unexpected bugs and addition of languages
#			to the pack (I would like Spanish, French and German at
#			least, others are more than welcome), I hope to get to
#			v1.0.0 in a very short time.
#
# v0.9.2 (2006-02-07) -	The "against the rules" version.
#			Well I decided, against my own rules to turn public one
#			of the development versions. I need some more beta
#			testers and since only poor Neos offered you are all
#			going to be forced volunteers. This will fail, it will
#			render your system useless and it won't work. So please
#			stick with the 0.8.x versions.
#
# v0.9.1 (2006-02-06) -	The "hands off" version.
#			Re-made great part of the startup sequence, so now it's
#			not necessary to do anything at all to get the database
#			up and running, it will be detected if it's a first run,
#			an update or a normal run and it will be acted as
#			accordingly. What was disabled, for now was the mail
#			table bug check, since it was giving too many problems.
#
# v0.8.2 (2006-02-05) -	The "time to timeout" version.
#			Removed the timing out setting on the mail database in
#			hope that problems with UWC-RR get solved, but I'm not
#			sure if that's the cause of them. Also updated the
#			CREATE and DROP syntax, and lost the INDEX (it wasn't
#			used anyway). Already existing databases can be updated
#			with ".create_auctiondb update".
#
# v0.8.1 (2006-02-04) -	The "bug hunting we will go..." version.
#			Caught it! I thought it was in the "makebid" procedure
#			but it was in the "process", hence I couldn't find it
#			before. No more stale entries cluttering the tables.
#
# v0.9.0 (2006-02-03) -	The "next generation" version.
#			Converted the script to use the SQLdb facility. Renamed
#			the script from "SQLiteAuction.tcl" to the new name.
#
# v0.8.0 (2006-01-30) -	The "a beast of its own" version.
#			OK, a new beast has born. There are so many changes
#			that I can't remember them all. For starters read all
#			the previous 0.7.x entries to get a grip of things.
#			Other than that I worked a lot the startup sequence and
#			now you have a script which you just drop in your
#			"scripts/tcl" folder (or whatever you call it) and
#			forget about. No configuration, no setting up database,
#			no initializing, no nothing. The "time_send" column in
#			the mail table is automatically created if it
#			doesn't exist, the auction_* tables are created at
#			startup if they don't exist, they are updated, if
#			needed, several speed parameters are set and a
#			integrity check is performed to the database as a whole
#			(another advantage in having all tables in the same
#			database). I don't remember what else, except that the
#			database handle was changed from "auction" to "db3" for
#			future integration both with other plugins and
#			tcl-start (but you don't need to worry with this unless
#			you are a repacker). Oh, and don't forget that the
#			client addon MUST be upgraded.
#
# v0.7.5 (2006-01-29) -	The "almost there" version.
#			All procedures adapted and working! Just have to figure
#			out several return codes, since this new version only
#			has two: AUC_OK and AUC_ERROR, while the other had a
#			bunch of them.
#
# v0.7.4 (2006-01-29) -	The "the bid bid bid bid bid - part 3" version.
#			The logic of the "makebid" procedure keeps defying me.
#			OK, this time I got it finally right, and working with
#			version 0.4.1 (0.4 with my changes) of the client
#			addon.
#
# v0.7.3 (2006-01-29) -	The "cut, cut, cut" version.
#			I'm deleting the "listitems" procedure and it's call
#			from the "work" procedure. For what I can understand it
#			became unnecessary since its functionality was
#			incorporated in the "searchitems" procedure, and I was
#			unable to make the client addon request for it, so here
#			goes...
#
# v0.6.2 (2006-01-29) -	The "one seconds, two second" version.
#			Corrected a small typo in the "SendMail" procedure,
#			thanks to Stiga for pointing it out.
#
# v0.7.2 (2006-01-29) -	The "the only LUA I know is the Moon" version.
#			Got both "createauction" and "owneritems" procedures
#			working. The number of displayed items per page is 8
#			for the "Auctions" and 7 for "Browse" windows, but the
#			client addon assumed 7 for both, so I had to edit the
#			client addon (I don't know shit about LUA so this was
#			gut feeling plain and simple, I'm not sure of it). I
#			believe that my changes didn't break compatibility with
#			other versions, since I think that they will also have
#			a better fit with them, but I'm not sure.
#
# v0.7.1 (2006-01-29) -	The "oh, shit it's working!" version.
#			I got it working for the "searchitems" procedure,
#			except for the "usable" option, which I still don't
#			know what it does. It now has multiple pages and it can
#			be ordered by a bunch of different ways. I don't know
#			shit about LUA, so it's harder, but I think I got the
#			hang of it.
#
# v0.6.1 (2006-01-29) -	The "missing version" version.
#			Forgot to finish the version querying for the procedure
#			"create_auctiondb" and also parsed the string passed to
#			it in case independent form.
#
# v0.7.0 (2006-01-29) -	The "I don't know what I'm doing" version.
#			Got access to version 0.4 of the client plugin and I'm
#			trying to figure out what are the new fields. (internal
#			version. All 0.7.x will be so for me to make it work,
#			if I ever get it working it'll come out as 0.8.0)
#
# v0.6.0 (2006-01-28) -	The "I'm a moron" version.
#			Damn I am a moron. The "GetItemCategory" procedure was
#			bugged by mixing string and integer returns. Also I
#			introduced a early verification against the "items.scp"
#			database and also kept the previous way of checking the
#			database and they were coliding with each other. Fixed,
#			but it may fail in some strange way still, 'cause I'm
#			not yet at ease with that procedure.
#
# v0.5.4 (2006-01-28) -	The "GM friendly" version.
#			Changed the "create_auctiondb" procedure to spit a help
#			screen with the several new options to it, accessed by
#			using ".create_auctiondb help". Also added version info
#			to the script by creating a "version" procedure,
#			accessed by typing ".version_auction" ingame.
#			(internal version)
#
# v0.5.3 (2006-01-28) -	The "revisited the bid bid bid bid bid" version.
#			Changed the "makebid" and "bideritems" procedures to
#			only delete the current player previous bids allowing
#			other players to see their biddings in the "Bid" window
#			of the client plugin. (internal version)
#
# v0.5.2 (2006-01-28) -	The "let's cleanup when accessing" version.
#			Added a call to "process" procedure in the "work" one
#			in case you are running a pacific server where the Agro
#			system is less used (I'm still evaluating the impact of
#			this, so it might change back).
#
# v0.5.1 (2006-01-27) -	The "bid bid bid bid bid" version.
#			Had wrong logic in the "makebid" procedure, corrected
#			it to the fact that the first bidder wasn't taken in
#			account. (internal version)
#
# v0.5.0 (2006-01-27) -	The "let's keep it tight" version.
#			Setup the system to automatically make the changes to
#			"::WoWEmu:Commands", without having to edit the
#			procedure by hand. Ready for beta testing.
#
# v0.4.0 (2006-01-26) -	The "timing, it's all about timing" version.
#			Setup the database initialization and the check for the
#			required SQLite DLL at system startup. Also setup the
#			system to run "process" procedure at system startup and
#			periodically under the Agro system. (internal version)
#
# v0.3.0 (2006-01-26) -	The "shit, I hope I don't make it worse" version.
#			Double checked the conversion of all MySQL access calls
#			to the corresponding SQLite ones, then proceeded to
#			check/test/fix the procedures one by one to make them
#			work, finally moved all the mail code to a separate
#			procedure for both optimization and possibility to
#			allow using other mail systems in the future. The
#			"GetItemCategory" procedure is the part of the code I
#			understood worse and most sure will need to be checked
#			and fixed. I still have the gut feeling that part of
#			the code is missing, but this is what we have to work
#			with. (internal version)
#
# v0.2.0 (2006-01-24) -	The "it has to be their fault" version.
#			Started to optimize several function calls and
#			corrected some small typos in the code, since the
#			previous version didn't work. (internal version)
#
# v0.1.0 (2006-01-23) -	The "it's gonna be too easy" version.
#			Converted all MySQL access calls to the corresponding
#			SQLite ones. (internal version)
#
#


#
#	Start-TCL initialization
#
# StartTCL: n
#


#
#	namespace eval ::ngAuction
#
# Auction House namespace and variable definitions
#
namespace eval ::ngAuction {
	variable NAME "ngAuction"
	variable VERSION "1.0.2"

	# Trust me, you do NOT want to set DEBUG on...
	variable DEBUG 0
	variable VERBOSE 0

	variable auc_time 0
	variable gm_level 6

	# Auction durations
	variable short 1200
	variable medium 4800
	variable long 14400

	# ngMail Invoice related variables
	variable SELLER 1
	variable BUYER 2
	variable BIDDER 3
	variable EXPIRED 4
	variable RUNNING 251

	# SQLdb handle
	variable nghandle

	# Configuration file
	variable conf "scripts/conf/ngauction.conf"

	# Localization settings
	variable LANG "default"

	# Language strings (en)
	variable c_dbg01 "Enter procedure"

	variable h_glo01 "You don't have enough money!"
	variable h_glo02 "Unexpected NextGen Auction House System error in procedure \"%s\"!"

	variable l_hlp01 "NextGen Auction House System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \]%1\$c%4\$-13s - displays the current program version%1\$c%5\$-15s - shows this info"
	variable l_hlp02 "NextGen Auction House System (v%2\$s) - Usage:%1\$c%1\$c%3\$s \[ %4\$s \| %5\$s \| %6\$s \| %7\$s \| %8\$s \]%1\$c%4\$-12s - removes wasted space from the database%1\$c%5\$-15s - recreates the tables from scratch%1\$c%6\$-11s - displays the underlying database API version%1\$c%7\$-13s - displays the current program version%1\$c%8\$-15s - shows this info"

	variable l_ver01 "NextGen Auction House System is at version %s"

	variable l_dba01 "You are not allowed to use this command!"
	variable l_dba02 "NextGen Auction House System (v%s) database"
	variable l_dba03 "Database cleanup done."
	variable l_dba04 "re-done"
	variable l_dba05 "The tables were successfully updated."
	variable l_dba06 "The tables are already up to date."
	variable l_dba07 "Database tables already exist, if you want to recreate them use%2\$c\"%1\$s\"."
	variable l_dba08 "done"
	variable l_dba09 "Database tables setup %s."

	variable h_wrk01 "Error in NextGen Auction House System."

	variable h_cau01 "Auction successfully created!"
	variable c_cau02 "Not enough money?"

	variable c_src01 "WARNING: Selecting the \"Usable Items\" tick won't do anything."
	variable c_src02 "It isn't implemented yet (I don't know what it means, nor"
	variable c_src03 "how to check if it aplies)."

	variable h_mak01 "You cannot bid on your own auctions!"
	variable h_mak02 "You cannot bid below the auction start price!"
	variable h_mak03 "Your bid is unacceptable, the current top bid is already higher!"
	variable h_mak04 "Bid accepted!"

	variable h_buy01 "You are not allowed to buyout your own item!"
	variable h_buy02 "Gold"
	variable h_buy03 "Silver"
	variable h_buy04 "Copper"
	variable h_buy05 "Unexpected Error! The buyout price I've got (%1\$s) and the one in the database (%2\$s) differ!"
	variable h_buy06 "Congratulations! You successfully bought \"%s\"!"

	variable h_can01 "You are not allowed to cancel this auction!"
	variable h_can02 "You have successfully canceled your auction."

	variable c_pro01 "Auction ended and item sold."

	variable m_frm01 "Auction Service"

	variable m_sub01 "Refund Money From Bid"
	variable m_sub02 "Payment For \"%s\" Auction"
	variable m_sub03 "Item \"%s\" Bought In Auction"
	variable m_sub04 "Auction For \"%s\" Canceled"
	variable m_sub05 "Auction For \"%s\" Timed Out"

	variable m_bod01 "Your bid for \"%s\" was overbided, here is your refund. Thank you for using our Auction Service."
	variable m_bod02 "The \"%s\" was bought out, here is your refund. We wish you better luck next time. Thank you for using our Auction Service."
	variable m_bod03 "The \"%s\" was bought out. We are returning your deposit and sending you the buyout value except for a small fee (5%%) that we retain for our services. Thank you for using our Auction Service."
	variable m_bod04 "Congratulations! Your bid bought out \"%s\". Thank you for using our Auction Service."
	variable m_bod05 "The seller cancelled the auction for \"%s\", here is the refund for your bid. Thank you for using our Auction Service."
	variable m_bod06 "You have canceled the auction for \"%s\". Please feel free to place another item for auction at your convenience. Thank you for using our Auction Service."
	variable m_bod07 "We regret to inform you that the auction for \"%s\" has finished but your item was not sold. Thank you for using our Auction Service."
}


#
#	proc ::ngAuction::logPrefix { }
#
# Returns a string suitable to add to the console
#
proc ::ngAuction::logPrefix { } {
	if { [ string length [ info procs "::Custom::LogPrefix" ] ] } {
		return "[ ::Custom::LogPrefix ]AUCTION:"
	}

	return "[ clock format [ clock seconds ] -format %k:%M:%S ]:M:AUCTION:"
}


#
#	proc ::ngAuction::logDebug { }
#
# Returns a debug string to add to the console
#
proc ::ngAuction::logDebug { } {
	return "[ ::ngAuction::logPrefix ]DEBUG:"
}


#
#	proc ::ngAuction::help { player }
#
# Returns a help screen depending on your level (hand called)
#
# ( add the lines:
#
# "auction_help" -
# "help_auction" { return [ ::ngAuction::help $player ] }
#
# inside:
#
# switch [string tolower $command]
#
# in:
#
# namespace eval WoWEmu
#
# inside lx/api/commands.tcl )
#
proc ::ngAuction::help { player } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc help{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	if { [ GetPlevel $player ] < $::ngAuction::gm_level } {
		return [ format $::ngAuction::l_hlp01 10 $VERSION ".auction" "version" "help" ]
	} else {
		return [ format $::ngAuction::l_hlp02 10 $VERSION ".auction" "cleanup" "redo" "dbversion" "version" "help" ]
	}
}


#
#	proc ::ngAuction::version { }
#
# Returns the version info about the plugin (hand called)
#
# ( add the lines:
#
# "auction_version" -
# "version_auction" { return [ ::ngAuction::version ] }
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
proc ::ngAuction::version { } {
	variable VERSION
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc version{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	return [ format $::ngAuction::l_ver01 $VERSION ]
}


#
#	proc ::ngAuction::db { player cargs }
#
# Setup/cleanup the database (hand called)
#
# ( add the line:
#
# "create_auctiondb" { return [ ::ngAuction::db $cargs ] }
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
proc ::ngAuction::db { player cargs } {
	variable VERSION
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc db{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	if { ( $player != 0 ) && ( [ GetPlevel $player ] < $::ngAuction::gm_level ) } {
		return $::ngAuction::l_dba01
	}

	set i_maxchar 127
	set s_ret [ format $::ngAuction::l_dba02 $VERSION ]

	switch [ string tolower $cargs ] {
		"version" -
		"dbversion" {
			return "$s_ret:\n\n[ ::SQLdb::versionSQLdb $nghandle ]"
		}
		"cleanup" {
			::SQLdb::cleanupSQLdb $nghandle
			return "$s_ret:\n\n$::ngAuction::l_dba03"
		}
		"redo" {
			if { [ ::SQLdb::existsSQLdb $nghandle `auction_items` ] } {
				::SQLdb::querySQLdb $nghandle "DROP TABLE `auction_items`"
			}

			if { [ ::SQLdb::existsSQLdb $nghandle `auction_bids` ] } {
				::SQLdb::querySQLdb $nghandle "DROP TABLE `auction_bids`"
			}

			::SQLdb::cleanupSQLdb $nghandle
			set s_done $::ngAuction::l_dba04
		}
		"_update" {
			set items 0
			set bids 0

			if { [ ::SQLdb::existsSQLdb $nghandle `auction_items` ] } {
				::SQLdb::querySQLdb $nghandle "CREATE TEMPORARY TABLE `auction_items_t` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `seller` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `createtime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `endtime` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00', `item_id` INTEGER NOT NULL DEFAULT 0, `item_name` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `item_icon` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `item_count` INTEGER NOT NULL DEFAULT 0, `item_category` INTEGER NOT NULL DEFAULT 0, `item_quality` INTEGER NOT NULL DEFAULT 0, `duration` INTEGER NOT NULL DEFAULT 0, `start_price` INTEGER NOT NULL DEFAULT 0, `buy_price` INTEGER NOT NULL DEFAULT 0, `item_level` INTEGER NOT NULL DEFAULT 0)"
				::SQLdb::querySQLdb $nghandle "INSERT INTO `auction_items_t` SELECT * FROM `auction_items`"
				incr items
			}

			if { [ ::SQLdb::existsSQLdb $nghandle `auction_bids` ] } {
				::SQLdb::querySQLdb $nghandle "CREATE TEMPORARY TABLE `auction_bids_t` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `bidder` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `auc_id` INTEGER NOT NULL DEFAULT 0, `money` INTEGER NOT NULL DEFAULT 0)"
				::SQLdb::querySQLdb $nghandle "INSERT INTO `auction_bids_t` SELECT * FROM `auction_bids`"
				incr bids
			}

			db 0 redo

			if { $items } {
				::SQLdb::querySQLdb $nghandle "INSERT INTO `auction_items` SELECT * FROM `auction_items_t`"
				::SQLdb::querySQLdb $nghandle "DROP TABLE `auction_items_t`"
			}

			if { $bids } {
				::SQLdb::querySQLdb $nghandle "INSERT INTO `auction_bids` SELECT * FROM `auction_bids_t`"
				::SQLdb::querySQLdb $nghandle "DROP TABLE `auction_bids_t`"
			}

			if { [ expr { $items || $bids } ] } {
				return "$s_ret:\n\n$::ngAuction::l_dba05"
			} else {
				return "$s_ret:\n\n$::ngAuction::l_dba06"
			}
		}
		"" {
		}
		default {
			return [ help $player ]
		}
	}

	set create 0

	if { ! [ ::SQLdb::existsSQLdb $nghandle `auction_items` ] } {
		::SQLdb::querySQLdb $nghandle "CREATE TABLE `auction_items` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `seller` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `createtime` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP, `endtime` TIMESTAMP NOT NULL DEFAULT '0000-00-00 00:00:00', `item_id` INTEGER NOT NULL DEFAULT 0, `item_name` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `item_icon` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `item_count` INTEGER NOT NULL DEFAULT 0, `item_category` INTEGER NOT NULL DEFAULT 0, `item_quality` INTEGER NOT NULL DEFAULT 0, `duration` INTEGER NOT NULL DEFAULT 0, `start_price` INTEGER NOT NULL DEFAULT 0, `buy_price` INTEGER NOT NULL DEFAULT 0, `item_level` INTEGER NOT NULL DEFAULT 0)"
		incr create
	}

	if { ! [ ::SQLdb::existsSQLdb $nghandle `auction_bids` ] } {
		::SQLdb::querySQLdb $nghandle "CREATE TABLE `auction_bids` (`id` INTEGER PRIMARY KEY AUTO_INCREMENT, `bidder` VARCHAR($i_maxchar) NOT NULL DEFAULT '', `auc_id` INTEGER NOT NULL DEFAULT 0, `money` INTEGER NOT NULL DEFAULT 0)"
		incr create
	}

	if { $create == 0 } {
		append s_ret ":\n\n" [ format $::ngAuction::l_dba07 ".auction redo" 10 ]
	} else {
		if { ! [ info exists s_done ] } {
			set s_done $::ngAuction::l_dba08
		}

		append s_ret ":\n\n" [ format $::ngAuction::l_dba09 $s_done ]
	}

	return $s_ret
}


#
#	proc ::ngAuction::work { player cargs largs }
#
# Master procedure redirects to the local ones
#
# ( add the line:
#
# "auc" { return [ ::ngAuction::work $player $cargs $largs ] }
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
proc ::ngAuction::work { player cargs } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc work{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG cargs=\"$cargs\""
	}

	process

	if { $cargs == "" } {
		return $::ngAuction::h_wrk01
	}

	set cargs [ string trim $cargs ]

	switch [ lindex [ split $cargs ] 0 ] {
		"NEW_AUCTION_UPDATE" {
			return [ createauction $player $cargs ]
		}
		"AUCTION_ITEM_LIST_UPDATE_OWNER" {
			return [ owneritems $player $cargs ]
		}
		"AUCTION_ITEM_LIST_UPDATE_SEARCH" {
			return [ searchitems $player $cargs ]
		}
		"AUCTION_ITEM_LIST_UPDATE_BIDDER" {
			return [ bideritems $player $cargs ]
		}
		"AUCTION_ITEM_BID" {
			return [ makebid $player $cargs ]
		}
		"AUCTION_ITEM_BUYOUT" {
			return [ buyout $player $cargs ]
		}
		"AUCTION_ITEM_CANCEL" {
			return [ auccancel $player $cargs ]
		}
	}
}


#
#	proc ::ngAuction::createauction { player largs }
#
# Local procedure to create a new auction in behalf of the player
#
proc ::ngAuction::createauction { player largs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc createauction{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG largs=\"$largs\""
	}

	set pname [ GetName $player ]
	set data [ split $largs "#" ]
	set item_name [ lindex $data 1 ]
	set item_icon [ lindex $data 2 ]
	set item_count [ lindex $data 3 ]
	set item_quality [ lindex $data 4 ]
	set start_price [ lindex $data 5 ]
	set buy_price [ lindex $data 6 ]
	set duration [ lindex $data 7 ]
	set item_id [ Custom::GetID $item_name ]
	set item_level [ GetScpValue "items.scp" "item $item_id" "reqlevel" ]
	set item_level [ expr { [ string is integer $item_level ] ? $item_level : 0 } ]
	set item_category [ GetItemCategory $item_id ]

	if { $item_id != 0 && $item_category != 0 } {
		switch $duration {
			$::ngAuction::short {
				set percentage 0.02
			}
			$::ngAuction::medium {
				set percentage 0.05
			}
			default {
				set percentage 0.1
			}
		}

		set deposit [ expr ( int ( $start_price * double ( $percentage ) + 0.5 ) ) ]

		if { $deposit > 0 } {
			if { ! [ ChangeMoney $player -$deposit ] } {
				return "AUC_ERROR#$::ngAuction::h_glo01"
			}
		}

		if { [ ConsumeItem $player $item_id $item_count ] == 1 } {
			set endtime [ clock format [ expr ( [ clock seconds ] + 3600 * ( $duration / 60 ) ) ] -format "%Y-%m-%d %H:%M:%S" ]
			::SQLdb::querySQLdb $nghandle "INSERT INTO `auction_items` (`seller`, `endtime`, `item_id`, `item_name`, `item_icon`, `item_count`, `item_category`, `item_quality`, `duration`, `start_price`, `buy_price`, `item_level`) VALUES('[ ::SQLdb::canonizeSQLdb $pname ]', '$endtime', $item_id, '[ ::SQLdb::canonizeSQLdb $item_name ]', '[ ::SQLdb::canonizeSQLdb $item_icon ]', $item_count, $item_category, $item_quality, $duration, $start_price, $buy_price, $item_level)"
			return "AUC_OK#$::ngAuction::h_cau01"
		}

		if { $DEBUG } {
			puts "$s_logDEBUG $::ngAuction::c_cau02"
		}
	}

	if { $DEBUG } {
		puts "$s_logDEBUG AUC_ERROR#[ format $::ngAuction::h_glo02 "createauction" ]\n$s_logDEBUG item_id=\"$item_id\" item_category=\"$item_category\""
	}

	return "AUC_ERROR#[ format $::ngAuction::h_glo02 "createauction" ]"
}


#
#	proc ::ngAuction::owneritems { player largs }
#
# Local procedure to list all items a player is auctioning
#
# Note: in the switch $by, "status" should be by bidder, but it's impossible
#
proc ::ngAuction::owneritems { player largs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc owneritems{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG largs=\"$largs\""
	}

	set pname [ GetName $player]
	set data [ split $largs "#" ]
	set by [ lindex $data 1 ]
	set order [ expr { [ lindex $data 2 ] ? "DESC" : "ASC" } ]
	set from [ lindex $data 3 ]
	set now [ clock format [ clock seconds ] -format "%Y-%m-%d %H:%M:%S" ]

	switch $by {
		"quality" {
			set by "item_quality"
		}
		"status" {
			set by "seller"
		}
		"bid" {
			set by "start_price"
		}
		default {
			set by "endtime"
		}
	}

	set ret "AUCTION_ITEM_OWNER:\r[ ::SQLdb::firstcellSQLdb $nghandle "SELECT count(*) FROM `auction_items` WHERE (`seller` = '[ ::SQLdb::canonizeSQLdb $pname ]' AND `endtime` > '$now')" ]\r"

	foreach item_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_items` WHERE (`seller` = '[ ::SQLdb::canonizeSQLdb $pname ]' AND `endtime` > '$now') ORDER BY `$by` $order LIMIT $from,8" ] {
		foreach { id seller createtime endtime item_id item_name item_icon item_count item_category item_quality duration start_price buy_price item_level } $item_row {
		# `id` `seller` `createtime` `endtime` `item_id` `item_name` `item_icon` `item_count`
		# `item_category` `item_quality` `duration` `start_price` `buy_price` `item_level`
			if { $DEBUG } {
				puts "$s_logDEBUG id=\"$id\", seller=\"$seller\", createtime=\"$createtime\", endtime=\"$endtime\", item_id=\"$item_id\", item_name=\"$item_name\", item_icon=\"$item_icon\", item_count=\"$item_count\", item_category=\"$item_category\", item_quality=\"$item_quality\", duration=\"$duration\", start_price=\"$start_price\", buy_price=\"$buy_price\", item_level=\"$item_level\""
			}

			set timeleft [ expr ( ( [ clock scan $endtime ] - [ clock seconds ] ) / 60 ) ]
			set bidder $seller
			set money $start_price

			foreach bid_row [ ::SQLdb::querySQLdb $nghandle "SELECT `bidder`, `money` FROM `auction_bids` WHERE (`auc_id` = $id) ORDER BY `money` DESC LIMIT 1" ] {
				foreach { bidder money } $bid_row {
				# `id` `bidder` `auc_id` `money`
					if { $DEBUG } {
						puts "$s_logDEBUG bidder=\"$bidder\", money=\"$money\""
					}
				}
			}

			append ret "\n#$item_id#$item_name#$item_icon#$item_count#$item_quality#1#$item_level#$start_price#50#$buy_price#$money#$bidder#$timeleft#$id#$pname"
		}
	}

	if { $DEBUG } {
		puts "$s_logDEBUG ret=\"$ret\""
	}

	return "$ret\n"
}


#
#	proc ::ngAuction::searchitems { player largs }
#
# Local procedure to search for auctioned items
#
proc ::ngAuction::searchitems { player largs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc searchitems{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG largs=\"$largs\""
	}

	set data [ split $largs "#" ]
	set category [ lindex $data 1 ]
	set criteria [ lindex $data 2 ]
	set minlevel [ lindex $data 3 ]
	set maxlevel [ lindex $data 4 ]
	set quality [ lindex $data 5 ]
	set usable [ lindex $data 6 ]
	set by [ lindex $data 7 ]
	set order [ expr { [ lindex $data 8 ] ? "DESC" : "ASC" } ]
	set from [ lindex $data 9 ]
	set where "WHERE ("

	if { $category != "NULL" } {
		if { $category == "10" } {
			append where "`item_category` = $category"
		} else {
			append where "`item_category` LIKE '$category%' AND item_category != 10"
		}
	}

	if { $criteria != "NULL" }  {
		if { $where != "WHERE (" } {
			append where " AND "
		}

		append where "`item_name` LIKE '%[ ::SQLdb::canonizeSQLdb $criteria ]%'"
	}

	if { $minlevel != "NULL" } {
		if { $where != "WHERE (" } {
			append where " AND "
		}

		append where "`item_level` >= $minlevel"
	}

	if { $maxlevel != "NULL" } {
		if { $where != "WHERE (" } {
			append where " AND "
		}

		append where "`item_level` <= $maxlevel"
	}

	if { $quality != "NULL\n" && $quality != "-1" } {
		if { $where != "WHERE (" } {
			append where " AND "
		}

		append where "`item_quality` = $quality"
	}

	if { $usable != "NULL" } {
		if { $DEBUG } {
			puts "$s_logDEBUG\n$s_logDEBUG\n$s_logDEBUG\t$::ngAuction::c_src01\n$s_logDEBUG\t$::ngAuction::c_src02\n$s_logDEBUG\t$::ngAuction::c_src03\n$s_logDEBUG\n$s_logDEBUG"
		} elseif { $VERBOSE } {
			puts "[ ::ngAuction::logPrefix ]\n[ ::ngAuction::logPrefix ]\n[ ::ngAuction::logPrefix ]\t$::ngAuction::c_src01\n[ ::ngAuction::logPrefix ]\t$::ngAuction::c_src02\n[ ::ngAuction::logPrefix ]\t$::ngAuction::c_src03\n[ ::ngAuction::logPrefix ]\n[ ::ngAuction::logPrefix ]"
		}
	}

	append where ")"

	if { $where == "WHERE ()" } {
		set where ""
	}

	switch $by {
		"quality" {
			set by "item_quality"
		}
		"level" {
			set by "item_level"
		}
		"status" {
			set by "seller"
		}
		"bid" {
			set by "start_price"
		}
		default {
			set by "endtime"
		}
	}

	set pname [ GetName $player ]
	set ret "AUCTION_ITEM_LIST:\r[ ::SQLdb::firstcellSQLdb $nghandle "SELECT count(*) FROM `auction_items` $where" ]\r"

	foreach item_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_items` $where ORDER BY `$by` $order LIMIT $from,7" ] {
		foreach { id seller createtime endtime item_id item_name item_icon item_count item_category item_quality duration start_price buy_price item_level } $item_row {
		# `id` `seller` `createtime` `endtime` `item_id` `item_name` `item_icon` `item_count`
		# `item_category` `item_quality` `duration` `start_price` `buy_price` `item_level`
			if { $DEBUG } {
				puts "$s_logDEBUG id=\"$id\", seller=\"$seller\", createtime=\"$createtime\", endtime=\"$endtime\", item_id=\"$item_id\", item_name=\"$item_name\", item_icon=\"$item_icon\", item_count=\"$item_count\", item_category=\"$item_category\", item_quality=\"$item_quality\", duration=\"$duration\", start_price=\"$start_price\", buy_price=\"$buy_price\", item_level=\"$item_level\""
			}

			set timeleft [ expr ( ( [ clock scan $endtime ] - [ clock seconds ] ) / 60 ) ]
			set bidder $seller
			set money $start_price

			foreach bid_row [ ::SQLdb::querySQLdb $nghandle "SELECT `bidder`, `money` FROM `auction_bids` WHERE (`auc_id` = $id) ORDER BY `money` DESC LIMIT 1" ] {
				foreach { bidder money } $bid_row {
				# `id` `bidder` `auc_id` `money`
					if { $DEBUG } {
						puts "$s_logDEBUG bidder=\"$bidder\", money=\"$money\""
					}
				}
			}

			append ret "\n#$item_id#$item_name#$item_icon#$item_count#$item_quality#1#$item_level#$start_price#50#$buy_price#$money#$bidder#$timeleft#$id#$seller"
		}
	}

	if { $DEBUG } {
		puts "$s_logDEBUG ret=\"$ret\""
	}

	return "$ret\n"
}


#
#	proc ::ngAuction::bideritems { player largs }
#
# Local procedure to get a list of the items the player is biding
#
# Note: in the switch $by, "status" by bidder, doesn't work as it is
#
proc ::ngAuction::bideritems { player largs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc bideritems{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG largs=\"$largs\""
	}

	set pname [ GetName $player ]
	set data [ split $largs "#" ]
	set by [ lindex $data 1 ]
	set order [ expr { [ lindex $data 2 ] ? "DESC" : "ASC" } ]
	set from [ lindex $data 3 ]

	switch $by {
		"quality" {
			set by "item_quality"
		}
		"level" {
			set by "item_level"
		}
		"buyout" {
			set by "buy_price"
		}
		"status" {
			set by "bidder"
		}
		"bid" {
			set by "money"
		}
		default {
			set by "endtime"
		}
	}

	set ret "AUCTION_ITEM_BIDDER:\r[ ::SQLdb::querySQLdb $nghandle "SELECT count(*) FROM `auction_items`, `auction_bids` WHERE (`auction_bids`.`bidder` = '[ ::SQLdb::canonizeSQLdb $pname ]' AND `auction_bids`.`auc_id` = `auction_items`.`id`)" ]\r"

	foreach item_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_items`, `auction_bids` WHERE (`auction_bids`.`bidder` = '[ ::SQLdb::canonizeSQLdb $pname ]' AND `auction_bids`.`auc_id` = `auction_items`.`id`) GROUP BY `auction_bids`.`auc_id` ORDER BY `$by` $order LIMIT $from,8" ] {
		foreach { id seller createtime endtime item_id item_name item_icon item_count item_category item_quality duration start_price buy_price item_level auction_bids_id bidder auc_id money } $item_row {
		# `id` `seller` `createtime` `endtime` `item_id` `item_name` `item_icon` `item_count`
		# `item_category` `item_quality` `duration` `start_price` `buy_price` `item_level`
		# `auction_bids`.`id` `bidder` `auc_id` `money`
			if { $DEBUG } {
				puts "$s_logDEBUG id=\"$id\", seller=\"$seller\", createtime=\"$createtime\", endtime=\"$endtime\", item_id=\"$item_id\", item_name=\"$item_name\", item_icon=\"$item_icon\", item_count=\"$item_count\", item_category=\"$item_category\", item_quality=\"$item_quality\", duration=\"$duration\", start_price=\"$start_price\", buy_price=\"$buy_price\", item_level=\"$item_level\", auction_bids.id=\"$id\", bidder=\"$bidder\", auc_id=\"$auc_id\", money=\"$money\""
			}

			set timeleft [ expr ( ( [ clock scan $endtime ] - [ clock seconds ] ) / 60 ) ]

			foreach bid_row [ ::SQLdb::querySQLdb $nghandle "SELECT `bidder`, `money` FROM `auction_bids` WHERE (`auc_id` = $auc_id) ORDER BY `money` DESC LIMIT 1" ] {
				foreach { bidder money } $bid_row {
				# `id` `bidder` `auc_id` `money`
					if { $DEBUG } {
						puts "$s_logDEBUG bidder=\"$bidder\" money=\"$money\""
					}
				}
			}

			append ret "\n#$item_id#$item_name#$item_icon#$item_count#$item_quality#1#$item_level#$start_price#50#$buy_price#$money#$bidder#$timeleft#$auc_id#$pname"
		}
	}

	if { $DEBUG } {
		puts "$s_logDEBUG ret=\"$ret\""
	}

	return "$ret\n"
}


#
#	proc ::ngAuction::makebid { player largs }
#
# Local procedure to place a bid on behalf of the player
#
proc ::ngAuction::makebid { player largs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc makebid{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG largs=\"$largs\""
	}

	set pname [ GetName $player ]
	set data [ split $largs "#" ]
	set auc_id [ lindex $data 1 ]
	set bid_money [ lindex $data 2 ]

	foreach item_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_items` WHERE (id = $auc_id)" ] {
		foreach { id seller createtime endtime item_id item_name item_icon item_count item_category item_quality duration start_price buy_price item_level } $item_row {
		# `id` `seller` `createtime` `endtime` `item_id` `item_name` `item_icon` `item_count`
		# `item_category` `item_quality` `duration` `start_price` `buy_price` `item_level`
			set subject $::ngAuction::m_sub01
			set body [ format $::ngAuction::m_bod01 $item_name ]
			set bdel 0

			if { $pname == $seller } {
				if { $DEBUG } {
					puts "$s_logDEBUG AUC_ERROR#$::ngAuction::h_mak01"
				}

				return "AUC_ERROR#$::ngAuction::h_mak01"
			}

			if { [ expr ( $start_price > $bid_money ) ] } {
				if { $DEBUG } {
					puts "$s_logDEBUG AUC_ERROR#$::ngAuction::h_mak02"
				}

				return "AUC_ERROR#$::ngAuction::h_mak02"
			}

			switch $duration {
				$::ngAuction::short {
					set percentage 1.02
				}
				$::ngAuction::medium {
					set percentage 1.05
				}
				default {
					set percentage 1.1
				}
			}

			set deposit [ expr ( int ( $start_price * double ( $percentage ) + 0.5 ) ) ]
			set fee [ expr ( int ( $start_price * double ( 0.05 ) + 0.5 ) ) ]

			foreach bid_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_bids` WHERE (`auc_id` = $auc_id) ORDER BY `money` DESC" ] {
				foreach { id bidder auc_id money } $bid_row {
				# `id` `bidder` `auc_id` `money`
					if { ! $bdel } {
						if { [ expr ( $money >= $bid_money ) ] } {
							return "AUC_ERROR#$::ngAuction::h_mak03"
						}

						if { ! [ ChangeMoney $player -$bid_money ] } {
							return "AUC_ERROR#$::ngAuction::h_glo01"
						}
					}

					if { $pname == $bidder } {
						if { $DEBUG } {
							puts "$s_logDEBUG SendMail $bidder $subject $body $money 0 $item_name \"\" 0 [ expr { $::ngAuction::BIDDER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $pname"
						}

						SendMail $bidder $subject $body $money 0 $item_name "" 0 [ expr { $::ngAuction::BIDDER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $pname
					}

					incr bdel
				}
			}

			if { $bdel } {
				::SQLdb::querySQLdb $nghandle "DELETE FROM `auction_bids` WHERE (`bidder` = '[ ::SQLdb::canonizeSQLdb $pname ]' AND `auc_id` = $auc_id)"
			} else {
				if { ! [ ChangeMoney $player -$bid_money ] } {
					return "AUC_ERROR#$::ngAuction::h_glo01"
				}
			}

			::SQLdb::querySQLdb $nghandle "INSERT INTO `auction_bids` (`bidder`, `auc_id`, `money`) VALUES('[ ::SQLdb::canonizeSQLdb $pname ]', $auc_id, $bid_money)"

			if { $DEBUG } {
				puts "$s_logDEBUG AUC_OK#$::ngAuction::h_mak04"
			}

			return "AUC_OK#$::ngAuction::h_mak04"
		}
	}

	if { $DEBUG } {
		puts "$s_logDEBUG AUC_ERROR#[ format $::ngAuction::h_glo02 "makebid" ]"
	}

	return "AUC_ERROR#[ format $::ngAuction::h_glo02 "makebid" ]"
}


#
#	proc ::ngAuction::buyout { player largs }
#
# Local procedure to alow a player to buyout an item
#
proc ::ngAuction::buyout { player largs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc buyout{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG largs=\"$largs\""
	}

	set pname [ GetName $player ]
	set data [ split $largs "#" ]
	set auc_id [ lindex $data 1 ]
	set buy_money [ lindex $data 2 ]
	set del 0

	foreach item_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_items` WHERE (`id` = $auc_id) LIMIT 1" ] {
		foreach { id seller createtime endtime item_id item_name item_icon item_count item_category item_quality duration start_price buy_price item_level } $item_row {
		# `id` `seller` `createtime` `endtime` `item_id` `item_name` `item_icon` `item_count`
		# `item_category` `item_quality` `duration` `start_price` `buy_price` `item_level`
			set subject $::ngAuction::m_sub01
			set body [ format $::ngAuction::m_bod02 $item_name ]
			set bdel 0


			if { $pname == $seller } {
				return "AUC_ERROR#$::ngAuction::h_buy01"
			}

			if { $buy_price != $buy_money } {
				set s_bp ""
				set s_bm ""
				set bp_gold [ expr { ( $buy_price - ( $buy_price % 10000 ) ) / 10000 } ]
				set bp_silver [ expr { ( ( $buy_price % 10000 ) - ( $buy_price % 10000 ) % 100 ) / 100 } ]
				set bp_copper [ expr { ( $buy_price % 10000 ) % 100 } ]
				set bm_gold [ expr { ( $buy_money - ( $buy_money % 10000 ) ) / 10000 } ]
				set bm_silver [ expr { ( ( $buy_money % 10000 ) - ( $buy_money % 10000 ) % 100 ) / 100 } ]
				set bm_copper [ expr { ( $buy_money % 10000 ) % 100 } ]

				if { $bp_gold } {
					append s_bp $bp_gold " " $::ngAuction::h_buy02
				}

				if { [ string length $s_bp ] } {
					append s_bp ", " $bp_silver " " $::ngAuction::h_buy03
				} elseif { $bp_silver } {
					append s_bp $bp_silver " " $::ngAuction::h_buy03
				}

				if { [ string length $s_bp ] } {
					append s_bp ", " $bp_copper " " $::ngAuction::h_buy04
				} elseif { $bp_copper } {
					append s_bp $bp_copper " " $::ngAuction::h_buy04
				}

				if { $bm_gold } {
					append s_bm $bm_gold " " $::ngAuction::h_buy02
				}

				if { [ string length $s_bm ] } {
					append s_bm ", " $bm_silver " " $::ngAuction::h_buy03
				} elseif { $bm_silver } {
					append s_bm $bm_silver " " $::ngAuction::h_buy03
				}

				if { [ string length $s_bm ] } {
					append s_bm ", " $bm_copper " " $::ngAuction::h_buy04
				} elseif { $bm_copper } {
					append s_bm $bm_copper " " $::ngAuction::h_buy04
				}

				return "AUC_ERROR#[ format $::ngAuction::h_buy05 $s_bm $s_bp ]"
			}

			if { ! [ ChangeMoney $player -$buy_money ] } {
				return "AUC_ERROR#$::ngAuction::h_glo01"
			}

			switch $duration {
				$::ngAuction::short {
					set percentage 1.02
				}
				$::ngAuction::medium {
					set percentage 1.05
				}
				default {
					set percentage 1.1
				}
			}

			set deposit [ expr ( int ( $start_price * double ( $percentage ) + 0.5 ) ) ]
			set fee [ expr ( int ( $buy_money * double ( 0.05 ) + 0.5 ) ) ]

			foreach bid_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_bids` WHERE (`auc_id`= $auc_id)" ] {
				foreach { id bidder auc_id money } $bid_row {
				# `id` `bidder` `auc_id` `money`

					if { $DEBUG } {
						puts "$s_logDEBUG SendMail $bidder $subject $body $money 0 $item_name \"\" 0 [ expr { $::ngAuction::BIDDER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $pname"
					}

					SendMail $bidder $subject $body $money 0 $item_name "" 0 [ expr { $::ngAuction::BIDDER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $pname
					incr bdel
				}
			}

			if { $bdel } {
				::SQLdb::querySQLdb $nghandle "DELETE FROM `auction_bids` WHERE (`auc_id` = $auc_id)"
			}

			set subject [ format $::ngAuction::m_sub02 $item_name ]
			set body [ format $::ngAuction::m_bod03 $item_name ]
			set money [ expr ( $buy_money + $deposit - $fee ) ]

			if { $DEBUG } {
				puts "$s_logDEBUG SendMail $seller $subject $body $money 0 $item_name \"\" 0 [ expr { $::ngAuction::SELLER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $pname"
			}

			SendMail $seller $subject $body $money 0 $item_name "" 0 [ expr { $::ngAuction::SELLER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $pname

			set subject [ format $::ngAuction::m_sub03 $item_name ]
			set body [ format $::ngAuction::m_bod04 $item_name ]

			if { $DEBUG } {
				puts "$s_logDEBUG SendMail $pname $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::BUYER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $seller"
			}

			SendMail $pname $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::BUYER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $seller
			incr del
		}
	}

	if { $del } {
		::SQLdb::querySQLdb $nghandle "DELETE FROM `auction_items` WHERE (`id` = $auc_id)"

		if { $DEBUG } {
			puts "$s_logDEBUG AUC_OK#[ format $::ngAuction::h_buy06 $item_name ]"
		}

		return "AUC_OK#[ format $::ngAuction::h_buy06 $item_name ]"
	}

	if { $DEBUG } {
		puts "$s_logDEBUG AUC_ERROR#[ format $::ngAuction::h_glo02 "buyout" ]"
	}

	return "AUC_ERROR#[ format $::ngAuction::h_glo02 "buyout" ]"
}


#
#	proc ::ngAuction::auccancel { player largs }
#
# Local procedure to cancel a running auction
#
proc ::ngAuction::auccancel { player largs } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc auccancel{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG largs=\"$largs\""
	}

	set pname [ GetName $player ]
	set auc_id [ lindex [ split $largs "#" ] 1 ]
	set del 0

	foreach item_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_items` WHERE (`id` = $auc_id) LIMIT 1" ] {
		foreach { id seller createtime endtime item_id item_name item_icon item_count item_category item_quality duration start_price buy_price item_level } $item_row {
		# `id` `seller` `createtime` `endtime` `item_id` `item_name` `item_icon` `item_count`
		# `item_category` `item_quality` `duration` `start_price` `buy_price` `item_level`
			set subject $::ngAuction::m_sub01
			set body [ format $::ngAuction::m_bod05 $item_name ]
			set bdel 0

			if { $pname != $seller } {
				return "AUC_ERROR#$::ngAuction::h_can01"
			}

			switch $duration {
				$::ngAuction::short {
					set percentage 0.02
				}
				$::ngAuction::medium {
					set percentage 0.05
				}
				default {
					set percentage 0.1
				}
			}

			set deposit [ expr ( int ( $start_price * double ( $percentage ) + 0.5 ) ) ]
			set fee [ expr ( int ( $start_price * double ( 0.05 ) + 0.5 ) ) ]

			foreach bid_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_bids` WHERE (`auc_id`= $auc_id)" ] {
				foreach { id bidder auc_id money } $bid_row {
				# `id` `bidder` `auc_id` `money`

					if { $DEBUG } {
						puts "$s_logDEBUG SendMail $bidder $subject $body $money 0 $item_name \"\" 0 [ expr { $::ngAuction::BIDDER | $::ngAuction::EXPIRED } ] $deposit $buy_price $fee $pname"
					}

					SendMail $bidder $subject $body $money 0 $item_name "" 0 [ expr { $::ngAuction::BIDDER | $::ngAuction::EXPIRED } ] $deposit $buy_price $fee $pname
					incr bdel
				}
			}

			if { $bdel } {
				::SQLdb::querySQLdb $nghandle "DELETE FROM `auction_bids` WHERE (`auc_id` = $auc_id)"
			}

			set subject [ format $::ngAuction::m_sub04 $item_name ]
			set body [ format $::ngAuction::m_bod06 $item_name ]

			if { $DEBUG } {
				puts "$s_logDEBUG SendMail $pname $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::SELLER | $::ngAuction::EXPIRED } ] $deposit $buy_price $fee \"\""
			}

			SendMail $pname $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::SELLER | $::ngAuction::EXPIRED } ] $deposit $buy_price $fee ""
			incr del
		}
	}

	if { $del } {
		::SQLdb::querySQLdb $nghandle "DELETE FROM `auction_items` WHERE (`id` = $auc_id)"

		if { $DEBUG } {
			puts "$s_logDEBUG AUC_OK#You have successfully canceled your auction."
		}

		return "AUC_OK#$::ngAuction::h_can02"
	}

	if { $DEBUG } {
		puts "$s_logDEBUG AUC_ERROR#[ format $::ngAuction::h_glo02 "auccancel" ]"
	}

	return "AUC_ERROR#[ format $::ngAuction::h_glo02 "auccancel" ]"
}


#
#	proc ::ngAuction::process { }
#
# Ongoing procedure to manage the timing out of auctions
#
proc ::ngAuction::process {} {
	variable DEBUG
	variable nghandle
	variable auc_time

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc process{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
		puts "$s_logDEBUG auc_time=\"$auc_time\""
	}

	if { [ clock seconds ] <= [ expr ( $auc_time + 5 ) ] } {
		return 0
	}

	set auc_time [ clock seconds ]
	set now [ clock format $auc_time -format "%Y-%m-%d %H:%M:%S" ]
	set ids {}
	set del 0

	foreach item_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_items` WHERE (`endtime` <= '$now')" ] {
		foreach { id seller createtime endtime item_id item_name item_icon item_count item_category item_quality duration start_price buy_price item_level } $item_row {
		# `id` `seller` `createtime` `endtime` `item_id` `item_name` `item_icon` `item_count`
		# `item_category` `item_quality` `duration` `start_price` `buy_price` `item_level`
			lappend ids $id
			set bdel -1
			set winner ""

			switch $duration {
				$::ngAuction::short {
					set percentage 1.02
				}
				$::ngAuction::medium {
					set percentage 1.05
				}
				default {
					set percentage 1.1
				}
			}

			set deposit [ expr ( int ( $start_price * double ( $percentage ) + 0.5 ) ) ]

			if { $DEBUG } {
				puts "$s_logDEBUG id=\"$id\", seller=\"$seller\", createtime=\"$createtime\", endtime=\"$endtime\", item_id=\"$item_id\", item_name=\"$item_name\", item_icon=\"$item_icon\", item_count=\"$item_count\", item_category=\"$item_category\", item_quality=\"$item_quality\", duration=\"$duration\", start_price=\"$start_price\", buy_price=\"$buy_price\", item_level=\"$item_level\""
			}

			foreach bid_row [ ::SQLdb::querySQLdb $nghandle "SELECT * FROM `auction_bids` WHERE (`auc_id` = $id) ORDER BY `money` DESC" ] {
				foreach { id bidder auc_id money } $bid_row {
				# `id` `bidder` `auc_id` `money`
					if { ! [ string length $winner ] } {
						set subject [ format $::ngAuction::m_sub03 $item_name ]
						set body [ format $::ngAuction::m_bod04 $item_name ]
						set winner $bidder
						set fee [ expr ( int ( $money * double ( 0.05 ) + 0.5 ) ) ]

						if { $DEBUG } {
							puts "$s_logDEBUG SendMail $bidder $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::BUYER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $seller"
						}

						SendMail $bidder $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::BUYER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $seller
						set subject [ format $::ngAuction::m_sub02 $item_name ]
						set body [ format $::ngAuction::m_bod03 $item_name ]
						set money [ expr ( $money + $deposit - $fee ) ]

						if { $DEBUG } {
							puts "$s_logDEBUG SendMail $seller $subject $body $money 0 $item_name \"\" 0 [ expr { $::ngAuction::SELLER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $winner"
						}

						SendMail $seller $subject $body $money 0 $item_name "" 0 [ expr { $::ngAuction::SELLER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $winner
					} else {
						set subject $::ngAuction::m_sub01
						set body [ format $::ngAuction::m_bod02 $item_name ]

						if { $DEBUG } {
							puts "$s_logDEBUG SendMail $bidder $subject $body $money 0 $item_name \"\" 0 [ expr { $::ngAuction::BIDDER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $winner"
						}

						SendMail $bidder $subject $body $money 0 $item_name "" 0 [ expr { $::ngAuction::BIDDER & $::ngAuction::RUNNING } ] $deposit $buy_price $fee $winner
					}

					set bdel $auc_id
				}
			}

			if { $bdel != -1 } {
				::SQLdb::querySQLdb $nghandle "DELETE FROM `auction_bids` WHERE (`auc_id` = $bdel)"

				if { $DEBUG } {
					puts "$s_logDEBUG $::ngAuction::c_pro01"
				}

			} else {
				set subject [ format $::ngAuction::m_sub05 $item_name ]
				set body [ format $::ngAuction::m_bod07 $item_name ]
				set fee [ expr ( int ( $start_price * double ( 0.05 ) + 0.5 ) ) ]

				if { $DEBUG } {
					puts "$s_logDEBUG SendMail $seller $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::SELLER | $::ngAuction::EXPIRED } ] $deposit $buy_price $fee \"\""
				}

				SendMail $seller $subject $body 0 $item_id $item_name $item_icon $item_count [ expr { $::ngAuction::SELLER | $::ngAuction::EXPIRED } ] $deposit $buy_price $fee ""

				if { $DEBUG } {
					puts "$s_logDEBUG Auction ended but item wasn't sold."
				}
			}

			incr del
		}
	}

	if { $del } {
		for { set i 0 } { $i < [ llength $ids ] } { incr i } {
			::SQLdb::querySQLdb $nghandle "DELETE FROM `auction_items` WHERE (`id` = [ lindex $ids $i ])"
		}
	}
}


#
#	proc ::ngAuction::SendMail { to subject body money item_id item_name item_icon item_count invoice deposit buyout fee who }
#
# Local procedure to deal with sending the mail messages
#
proc ::ngAuction::SendMail { to subject body money item_id item_name item_icon item_count invoice deposit buyout fee who } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc SendMail{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	set from $::ngAuction::m_frm01

	if { [ ::SQLdb::booleanSQLdb $nghandle "SELECT * FROM `SQLdb` WHERE (`name` = 'ngMail')" ] || [ namespace exists "::ngMail" ] || [ namespace exists "::Mail" ] } {
		# `id` `from` `to` `subject` `body` `date` `money`
		# `item_id` `item_icon` `item_count` `cod` `read`
		# `invoice` `deposit` `buyout` `fee`
		::SQLdb::querySQLdb $nghandle "INSERT INTO `mail` (`from`, `to`, `subject`, `money`, `item_id`, `item_icon`, `item_count`, `invoice`, `deposit`, `buyout`, `fee`) VALUES('[ ::SQLdb::canonizeSQLdb $who ]', '[ ::SQLdb::canonizeSQLdb $to ]', '[ ::SQLdb::canonizeSQLdb $item_name ]', $money, $item_id, '$item_icon', $item_count, $invoice, $deposit, $buyout, $fee)"
	} else {
		# `head` `from` `subject` `money` `cod` `time` `hasitem` `wasread`
		# `Body` `itmName` `itmTexture` `itmCount` `itmID` `to` `time_send`
		set head "MAIL_SUBJECT \r"
		set subject "#[ ::SQLdb::canonizeSQLdb $subject ]"
		set money "#$money"
		set cod "#0#"
		set time "30"
		set wasread "#False"
		set body "#[ ::SQLdb::canonizeSQLdb $body ]#"

		if { $item_id } {
			set hasitem "#1"
			set itmid "#$item_id#"
			set itmname "#[ ::SQLdb::canonizeSQLdb $item_name ]"
			set itmtexture "#Interface;Icons;[ ::SQLdb::canonizeSQLdb $item_icon ]"
			set itmcount "#$item_count"
		} else {
			set hasitem "#0"
			set itmid "#999#"
			set itmname "#0"
			set itmtexture "#0"
			set itmcount "#0"
		}

		::SQLdb::querySQLdb $nghandle "INSERT INTO `mail` (`head`, `from`, `subject`, `money`, `cod`, `time`, `hasitem`, `wasread`, `Body`, `itmName`, `itmTexture`, `itmCount`, `itmID`, `to`) VALUES('$head', '$from', '$subject', '$money', '$cod', '$time', '$hasitem', '$wasread', '$body', '$itmname', '$itmtexture', '$itmcount', '$itmid', '[ ::SQLdb::canonizeSQLdb $to ]')"
	}
}


#
#	proc ::ngAuction::GetItemCategory { id }
#
# Local procedure to convert from game to auction categories
#
proc ::ngAuction::GetItemCategory { id } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc GetItemCategory{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	set class [ GetScpValue "items.scp" "item $id" "class" ]
	set class [ expr { [ string is integer $class ] ? $class : 10 } ]
	set subclass [ GetScpValue "items.scp" "item $id" "subclass" ]
	set subclass [ expr { [ string is integer $subclass ] ? $subclass : 0 } ]
	set invtype [ GetScpValue "items.scp" "item $id" "inventorytype" ]
	set invtype [ expr { [ string is integer $invtype ] ? $invtype : 0 } ]

	switch $class {
		2 {
			set class 1
		}
		4 {
			set class 2
		}
		1 {
			return 3
		}
		0 {
			return 4
		}
		7 {
			return 5
		}
		6 {
			set class 6
		}
		11 {
			set class 7
		}
		9 {
			set class 8
		}
		5 {
			return 9
		}
		default {
			return 10
		}
	}

	switch $class {
		1 {
			if { $subclass <= 8 } {
				return $class[ expr ( $subclass + 1 ) ]
			}

			switch $subclass {
				13 {
					set subclass 11
				}
				14 {
					set subclass 12
				}
				15 {
					set subclass 13
				}
				16 {
					set subclass 14
				}
				18 {
					set subclass 15
				}
				19 {
					set subclass 16
				}
				20 {
					set subclass 17
				}
			}

			return $class$subclass
		}
		2 {
			incr subclass

			if { int ( $subclass ) == 7 } {
				set subclass 6
			}

			switch $invtype {
				0 {
					return 10
				}
				16 {
					set invtype 13
				}
				19 {
					set invtype 13
				}
				20 {
					set invtype 13
				}
				22 {
					set invtype 17
				}
			}

			return $class$subclass$invtype
		}
		6 {
			return $class[ expr ( $subclass - 1 ) ]
		}
		7 {
			return $class[ expr ( $subclass - 1 ) ]
		}
		8 {
			switch $subclass {
				1 {
					set subclass 2
				}
				2 {
					set subclass 3
				}
				3 {
					set subclass 4
				}
				4 {
					set subclass 5
				}
				5 {
					set subclass 6
				}
				6 {
					set subclass 7
				}
				8 {
					set subclass 9
				}
			}

			return $class$subclass
		}
		default {
			return 10
		}
	}

	if { $DEBUG } {
		puts "$s_logDEBUG class=\"$class\", subclass=\"$subclass\", invtype=\"$invtype\""
	}

	return 10
}


#
#	proc ::ngAuction::db_trace { sql }
#
# Internal procedure to trace the database calls
#
proc ::ngAuction::db_trace { sql } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc db_trace{}:"
		puts "$s_logDEBUG $sql"
	}
}


#	proc ::ngAuction::setSQLdb { }
#
# Internal procedure to set, check and update the SQLdb database entry
#
proc ::ngAuction::setSQLdb { } {
	variable DEBUG
	variable nghandle

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc setSQLdb{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	if { ! [ ::SQLdb::booleanSQLdb $nghandle "SELECT * FROM `$::SQLdb::NAME` WHERE (`name` = '$::ngAuction::NAME')" ] } {
		if { [ ::SQLdb::existsSQLdb $nghandle `auction_items` ] } {
			db 0 _update
		} else {
			db 0 ""
		}

		::SQLdb::querySQLdb $nghandle "INSERT INTO `$::SQLdb::NAME` (`name`, `version`) VALUES('$::ngAuction::NAME', '$::ngAuction::VERSION')"
	} else {
		set s_oldver [ ::SQLdb::firstcellSQLdb $nghandle "SELECT `version` FROM `$SQLdb::NAME` WHERE (`name` = '$::ngAuction::NAME')" ]

		if { [ expr { $s_oldver > $::ngAuction::VERSION } ] } {
			if { $DEBUG } {
				return -code error "$s_logDEBUG The current version of $::ngAuction::NAME ($::ngAuction::VERSION) is older that the previous one ($s_oldver), downgrade unsupported!"
			} else {
				return -code error "$SQLdb::s_logprefix: The current version of $::ngAuction::NAME ($::ngAuction::VERSION) is older that the previous one ($s_oldver), downgrade unsupported!"
			}
		} elseif { [ expr { $s_oldver < $::ngAuction::VERSION } ] } {
			db 0 _update
			::SQLdb::querySQLdb $nghandle "UPDATE `$SQLdb::NAME` SET `version` = '$::ngAuction::VERSION', `previous` = '$s_oldver', `date` = CURRENT_TIMESTAMP WHERE (`name` = '$::ngAuction::NAME')"
		} else {
			db 0 ""
		}
	}
}


#
#	proc ::ngAuction::readConf { config }
#
# Internal procedure to read the configuration file and set the system
#
proc ::ngAuction::readConf { config } {
	variable DEBUG
	variable VERBOSE
	variable LANG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc readConf{}:"
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
						"debug" {
							if { [ string tolower $value ] != "default" } {
								set DEBUG $value

								if { $DEBUG } {
									set s_logDEBUG "[ ::ngAuction::logDebug ] proc readConf{}:"
								}
							}
						}
						default {
							if { [ info exists ::ngAuction::$key ] } {
								if { [ string tolower $value ] != "default" } {
									set ::ngAuction::$key $value
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

					if { [ info exists ::ngAuction::$key ] } {
						set ::ngAuction::$key $value
					}
				}
			}
		}
	} else {
		proc ::ngAuction::dropNoise { string } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngAuction::logDebug ] proc dropNoise{}:"
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
				puts "[ ::ngAuction::logPrefix ] Configuration file \[$config\] missing, setting defaults and language to English."
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
								puts "[ ::ngAuction::logPrefix ] Section \[GLOBAL\] from \"$config\" is misplaced, it must be the first section in the file, setting defaults and language to English!"
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
									set ::ngAuction::LANG $s_value
								}
								"debug" {
									if { [ string tolower $s_value ] != "default" } {
										set DEBUG $s_value

										if { $DEBUG } {
											variable s_logDebug
											set s_logDEBUG "$s_logDebug proc readConf{}:"
										}
									}
								}
								default {
									if { [ info exists ::ngAuction::$s_key ] } {
										if { [ string tolower $s_value ] != "default" } {
											set ::ngAuction::$s_key $s_value
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
								puts "[ ::ngAuction::logPrefix ] End of file reached while reading \[GLOBAL\] from \"$config\", setting defaults and language to English!"
							}

							return 0
						}
					} else {
						if { ! $section } {
							close $f_handle

							if { $DEBUG } {
								puts "$s_logDEBUG Section \[GLOBAL\] from \"$config\" is missing or misplaced, it must be the first section in the file, setting defaults and language to English!"
							} elseif { $VERBOSE } {
								puts "[ ::ngAuction::logPrefix ] Section \[GLOBAL\] from \"$config\" is missing or misplaced, it must be the first section in the file, setting defaults and language to English!"
							}

							return 0
						}
					}
				}

				if { [ string tolower $::ngAuction::LANG ] == "default" } {
					close $f_handle

					if { $DEBUG } {
						puts "$s_logDEBUG Setting language defaults to English"
					} elseif { $VERBOSE } {
						puts "[ ::ngAuction::logPrefix ] Setting language defaults to English"
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
						if { [ string tolower [ string trim [ string trim $s_line \[\] ] ] ] == [ string tolower $::ngAuction::LANG ] } {
							break
						}
					}
				}

				if { [ eof $f_handle ] } {
					close $f_handle

					if { $DEBUG } {
						puts "$s_logDEBUG End of file reached while searching for \[[ string toupper $::ngAuction::LANG ]\] from \"$config\", setting language defaults to English!"
					} elseif { $VERBOSE } {
						puts "[ ::ngAuction::logPrefix ] End of file reached while searching for \[[ string toupper $::ngAuction::LANG ]\] from \"$config\", setting language defaults to English!"
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

					if { [ info exists ::ngAuction::$s_key ] } {
						set ::ngAuction::$s_key $s_value
					}
				}

				break
			}

			close $f_handle
		}
	}
}


#
#	proc ::ngAuction::commands { }
#
# Internal procedure to create the commands needed to run the script
#
proc ::ngAuction::commands { } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc commands{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	if { [ string length [ info procs "::Custom::AddCommand" ] ] } {
		proc ::ngAuction::auction { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngAuction::logDebug ] proc auction{}:"
				puts "$s_logDEBUG Enter procedure"
			}

			switch [ string tolower [ lindex $cargs 0 ] ] {
				"version" {
					return [ ::ngAuction::version ]
				}
				"dbversion" -
				"cleanup" -
				"redo" {
					return [ ::ngAuction::db $player $cargs ]
				}
				default {
					return [ ::ngAuction::help $player ]
				}
			}
		}

		proc ::ngAuction::auction_help { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngAuction::logDebug ] proc auction_help{}:"
				puts "$s_logDEBUG Enter procedure"
			}

			return [ ::ngAuction::help $player ]
		}

		proc ::ngAuction::auction_version { player cargs } {
			variable DEBUG

			if { $DEBUG } {
				set s_logDEBUG "[ ::ngAuction::logDebug ] proc auction_version{}:"
				puts "$s_logDEBUG Enter procedure"
			}

			return [ ::ngAuction::version ]
		}

		::Custom::AddCommand "auc" "::ngAuction::work"
		::Custom::AddCommand "auction" "::ngAuction::auction"
		::Custom::AddCommand "create_auctiondb" "::ngAuction::auction"
		::Custom::AddCommand "auction_help" "::ngAuction::auction_help"
		::Custom::AddCommand "help_auction" "::ngAuction::auction_help"
		::Custom::AddCommand "auction_version" "::ngAuction::auction_version"
		::Custom::AddCommand "version_auction" "::ngAuction::auction_version"
	} else {
		rename ::WoWEmu::Command ::WoWEmu::Command_ngauction

		proc ::WoWEmu::Command { args } {
			regsub -all -- {\}} $args {} largs
			regsub -all -- {\{} $largs {} largs
			regsub -all -- {\]} $largs {} largs
			regsub -all -- {\[} $largs {} largs
			regsub -all -- {\$} $largs {} largs
			regsub -all -- {\\} $largs {} largs
			set player [ lindex $largs 0 ]
			set cargs [ lrange $largs 2 end ]

			switch [ string tolower [ lindex $largs 1 ] ] {
				"auc" {
					return [ ::ngAuction::work $player $cargs ]
				}
				"create_auctiondb" -
				"auction" {
					switch [ string tolower [ lindex $cargs 0 ] ] {
						"version" {
							return [ ::ngAuction::version ]
						}
						"dbversion" -
						"cleanup" -
						"redo" {
							return [ ::ngAuction::db $player $cargs ]
						}
						default {
							return [ ::ngAuction::help $player ]
						}
					}
				}
				"auction_help" -
				"help_auction" {
					return [ ::ngAuction::help $player ]
				}
				"auction_version" -
				"version_auction" {
					return [ ::ngAuction::version ]
				}
				default {
					return [ ::WoWEmu::Command_ngauction $args ]
				}
			}

			return "Bad command"
		}
	}
}


#
#	proc ::ngAuction::hook { }
#
# Internal procedure to hook the program to allow expiring auctions
#
proc ::ngAuction::hook { } {
	variable DEBUG

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc init{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	if { [ string length [ info procs "::Custom::HookProc" ] ] } {
		if { $::Custom::VERSION >= 1.71 } {
			::Custom::HookProc "::WoWEmu::Command" {
				::ngAuction::process
			} "::ngAuction::" 1
		} else {
			::Custom::HookProc "::AI::CanUnAgro" {
				if { ! ( [ clock seconds ] % 5 ) } {
					::ngAuction::process
				}
			} "::ngAuction::"
		}
	} else {
		rename ::AI::CanUnAgro ::AI::CanUnAgro_ngauction

		proc ::AI::CanUnAgro { npc victim } {
			if { ! ( [ clock seconds ] % 5 ) } {
				::ngAuction::process
			}

			return [ ::AI::CanUnAgro_ngauction $npc $victim ]
		}
	}
}


#
#	proc ::ngAuction::init { }
#
# Internal procedure to setup the program
#
proc ::ngAuction::init { } {
	variable DEBUG
	variable conf
	variable nghandle
	package require SQLdb

	if { [ info exists "::StartTCL::VERSION" ] } {
		set DEBUG $::DEBUG
		set ::ngAuction::VERBOSE $::VERBOSE
		set ::ngAuction::LANG $::LANG
	}

	if { $DEBUG } {
		set s_logDEBUG "[ ::ngAuction::logDebug ] proc init{}:"
		puts "$s_logDEBUG $::ngAuction::c_dbg01"
	}

	if { [ ::Custom::GetScriptVersion "StartTCL" ] >= "0.9.0" } {
		::StartTCL::Require "Custom"
		::StartTCL::Provide $::ngAuction::NAME $::ngAuction::VERSION
	}

	::ngAuction::hook
	::ngAuction::commands
	::ngAuction::readConf $conf

	if { ! [ info exists nghandle ] } {
		set ::SQLdb::nghandle [ ::SQLdb::openSQLdb ]
	}

	set nghandle $::SQLdb::nghandle

	if { $DEBUG } {
		::SQLdb::traceSQLdb $nghandle ::ngAuction::db_trace
	}

	::ngAuction::setSQLdb
	::ngAuction::process
}


#
#	startup time command execution
#
# Run the "init" procedure at server start
#
::ngAuction::init
