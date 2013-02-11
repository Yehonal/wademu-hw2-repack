# Snk Tickets
# Version: 0.2
# Author: Snake
# Contact: admin@uniwow.com
# ------------------------------------------------

namespace eval SnkTickets {

	variable handle

	proc Commands { player cargs } {
		variable handle
		set event [lindex $cargs 0]
		set cargs [lrange $cargs 1 end]
		switch $event {
			"delete" { return [DeleteTicket $player $cargs] }	
			"getinfo" { return [GetTicketInfo $player] }	
			"getlist" { return [GetTicketList $player $cargs] }
			"new" { return [NewTicket $player $cargs] }
			"update" { return [UpdateTicket $player $cargs] }
		}
	}
	
	proc NewTicket { player cargs } {
		variable handle
		set name [GetName $player]
		if { [HasTicket $name] } { return "You already have a ticket." }
		set category [lindex $cargs 0]
		set problem [lrange $cargs 1 end]
		SQLdb::querySQLdb $handle "INSERT INTO `gm_tickets` (`author`, `category`, `problem`) VALUES('[ ::SQLdb::canonizeSQLdb $name ]', '$category', '[ ::SQLdb::canonizeSQLdb [ string trim [ string trim $problem # ] ] ]')"
	}
	
	proc DeleteTicket { player cargs } {
		variable handle
		set name [GetName $player]
		if { [GetPlevel $player] < 1 } {
			if { $cargs != $name } { return "You can't delete other member's ticket." }
			if { ![HasTicket $name] } { return "You don't have an open ticket." }
			SQLdb::querySQLdb $handle "DELETE FROM `gm_tickets` WHERE (`author` = '$name')"
		}
		if { [GetPlevel $player] >= 1 } {
			if { ![HasTicket $cargs] } { return "$cargs doesn't has an open ticket." }
			SQLdb::querySQLdb $handle "DELETE FROM `gm_tickets` WHERE (`author` = '$cargs')"
		}
	}

	proc UpdateTicket { player cargs } {
		variable handle
		set name [GetName $player]
		set problem [string trim $cargs]
		if { ![HasTicket $name] } { return "You don't have an open ticket." }
		SQLdb::querySQLdb $handle "UPDATE `gm_tickets` SET `problem` = '[ ::SQLdb::canonizeSQLdb [ string trim [ string trim $problem # ] ] ]' WHERE (`author` = '$name')"
	}
	
	proc GetTicketInfo { player } {
		variable handle
		set name [GetName $player]
		set plevel [GetPlevel $player]
		if { $plevel >= 1 } { set plevel 1 }
		set open "{"
		set close "}"
		if { ![HasTicket $name] } { return "TICKET_INFO#$plevel#NO_TICKET#0#" }
		set problem [ string trim [ string trim [SQLdb::querySQLdb $handle "SELECT `problem` FROM `gm_tickets` WHERE (`author` = '$name')"] $open ] $close ]
		set category [SQLdb::querySQLdb $handle "SELECT `category` FROM `gm_tickets` WHERE (`author` = '$name')"]
		return "TICKET_INFO#$plevel#$category#$problem#"
	}

	proc GetTicketList { player cargs } {
		if { [GetPlevel $player] < 1 } { return }
		variable handle
		set begin [lindex $cargs 0]
		set limit [lindex $cargs 1]
		set result ""
		set numrow 0
		set end "0"
		set total [SQLdb::querySQLdb $handle "SELECT COUNT(*) FROM `gm_tickets`"]
		set header "T_R\r"
		foreach row [SQLdb::querySQLdb $handle "SELECT * FROM `gm_tickets`"] {
			foreach { entry author category problem } $row {
				incr numrow 1
				if { $numrow == $total } { set end "end" }
				if { $numrow == $limit && $numrow < $total } { set end "send" }
				if { $numrow <= $limit && $numrow >= $begin } {
					append result $header#$author#$category#$problem#$total#$end
				}
			}
		}
		if { $result == "" } { set result "T_R\r##0###end" }
		return $result
	}
	
	proc HasTicket { name } {
		variable handle
		if { [SQLdb::querySQLdb $handle "SELECT `author` FROM `gm_tickets` WHERE (`author` = '$name')"] == "" } {
			return 0
		}
		return 1
	}

	proc handleSQLdb {} {
		if { ![info exists ::SQLdb::nghandle] } {
			set ::SQLdb::nghandle [::SQLdb::openSQLdb]
		}
		return $::SQLdb::nghandle
	}

	proc Init {} {
		variable handle [handleSQLdb]
		
		if { ! [SQLdb::existsSQLdb $handle `gm_tickets`] } {
			SQLdb::querySQLdb $handle "CREATE TABLE `gm_tickets` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `author` TEXT NOT NULL DEFAULT '', `category` TEXT NOT NULL DEFAULT '', `problem` TEXT NOT NULL DEFAULT '')"
		}
	}
	
	SnkTickets::Init
	Custom::AddCommand "ticket" "SnkTickets::Commands"
	
}