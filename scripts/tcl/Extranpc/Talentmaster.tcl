# Start-TCL: n
#
# Snk Talent Remover
# Vercion: 0.1
# Author: Snake
# Contact: admin@uniwow.com
# ------------------------------------------------
#
# This script lets player remove his talents talking to Talent Master.
#
# ------------------------------------------------
#
#

package require sqlite3
sqlite3 snk "saves/snk.db3"

namespace eval TR {

	variable TalentRemover 1

	proc GossipHello { npc player } {
		if { $TR::TalentRemover != 1 } { Say $npc 0 "Talent Remover is disabled"; return }
		if { [GetLevel $player] < 10 } { Say $npc 0 "You must be level 10+ to remove your talents"; return } 
		SendGossip $player $npc { text 0 "Remove my talents" }
	}
	
	proc GossipSelect { npc player option } {
		set name [GetName $player]
		if { [ string length [ snk eval { SELECT `name` FROM `talents` WHERE (`name` = $name) } ] ] } { UpdateProfile $npc $player; return }
		CreateProfile $npc $player
	}
	
	proc CreateProfile { npc player } {
		variable o
		set name [GetName $player]
		set level [GetLevel $player]
		set date [Custom::DateString]
		set timed 1
		set moneyl [GetTMoney $player]
		set money "$moneyl$o$o"
		if { ![ChangeMoney $player -$money] } {
			Say $npc 0 "You don't have enough money |cff00FF40$moneyl gold"
			SendGossipComplete $player $npc
			return
		}
		snk eval { INSERT INTO `talents` (`name`, `level`, `times`, `money`, `reseted`, `date`) VALUES($name, $level, $timed, $moneyl,"yes", $date) }
		LearnSpell $player 14867
		Say $npc 0 "Your talents have been removed, talk to a gm to get your Talent Points back"
		SendGossipComplete $player $npc
	}

	proc UpdateProfile { npc player } {
		variable o
		set name [GetName $player]
		set level [GetLevel $player]
		set date [Custom::DateString]
		set timed [expr [ snk eval { SELECT `times` FROM `talents` WHERE (`name` = $name) } ]+1 ]
		set moneyl [GetTMoney $player]
		set money "$moneyl$o$o"
		if { ![ChangeMoney $player -$money] } {
			Say $npc 0 "You don't have enough money |cff00FF40$moneyl gold"
			SendGossipComplete $player $npc
			return
		}
		snk eval { UPDATE `talents` SET `level` = $level, `times` = $timed, `date` = $date, `money` = $moneyl, `reseted` = "yes"  WHERE (`name` = $name) }
		LearnSpell $player 14867
		Say $npc 0 "Your talents have been removed, talk to a gm to get your Talent Points back"
		SendGossipComplete $player $npc
	}
	
	proc UpdateTalents { player cargs } {
		set sele [GetSelection $player]
		if { [GetPlevel $player] < 1 } { return "You are not allowed to use this command." }
		if { $sele == 0 || $sele == $player } { return "Select a player." }
		set level [GetLevel $sele]
		set name [GetName $sele]
		if { [ snk eval { SELECT `reseted` FROM `talents` WHERE (`name` = $name) } ] == "no" } { return "$name did not reset his talents." }
		set CP [expr $level-9]
		snk eval { UPDATE `talents` SET `reseted` = "no" WHERE (`name` = $name) }
		Say $sele 0 "I have now $CP Talent Points"
		return ".setcp $CP"
	}

	proc GetTMoney { player } {
		set name [GetName $player]
		if { [ string length [ snk eval { SELECT `name` FROM `talents` WHERE (`name` = $name) } ] ] } {
			set st [expr [ snk eval { SELECT `money` FROM `talents` WHERE (`name` = $name) } ]+5]
			if { $st > 50 } { return 50 }
			return $st
		}
		return 5
	}
	
	proc CreateTables { } {
		if { [ string length [ snk eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'talents') } ] ] } { return }
		snk eval { CREATE TABLE `talents` (`entry` INTEGER PRIMARY KEY AUTOINCREMENT, `name` TEXT NOT NULL DEFAULT '', `level` TEXT NOT NULL DEFAULT '', `times` TEXT NOT NULL DEFAULT '', `money` TEXT NOT NULL DEFAULT '', `reseted` TEXT NOT NULL DEFAULT '', `date` TEXT NOT NULL DEFAULT '') }
		puts "Snk Talent Remover Tables Created"
	}
		
	proc DeleteTables { player cargs } {
		if { ![ string length [ snk eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'talents') } ] ] } { return }
		snk eval { DROP TABLE `talents` }
		snk eval { VACUUM }
		puts "Snk Talent Remover Tables Deleted"
	}

	variable o 00

	Custom::AddCommand "retalent" "TR::UpdateTalents"
	TR::CreateTables
	
}
