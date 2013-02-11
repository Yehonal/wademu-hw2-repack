# StartTCL: n
#
# Wall System
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
# Description: prevents mobs from aggroing through walls.
#

# main
namespace eval ::Wall {

	variable ENABLED 1

	variable LOAD_BINARY_PPOINTS 1
	variable LOAD_TEXT_PPOINTS 1
	variable INSTANCES_ONLY 0

	variable DELTA 5
	variable PI [expr {acos(-1.)}]
	variable RAD_TO_DEG [expr {180./$PI}]

	variable NAME [namespace tail [namespace current]]
	variable VERSION 0.26
	variable USE_CONF 1
	variable DEBUG 0

	variable CachedPos
	variable CachedPosTime

	variable MinSQLdbVer 0.2.4

	if { $USE_CONF } { ::Custom::LoadConf }
	if { !$ENABLED } {
		namespace delete [namespace current]
		return
	}

	proc LogPrefix {} {
		return "[::Custom::LogPrefix]Wall:"
	}

	# .wall commands
	proc Command { player cargs } {
		variable WallData
		variable DELTA
		set selection [::GetSelection $player]
		set ot [::GetObjectType $selection]

		if { $ot == 3 } {
			set npc_pos [GetRoundPosNoDelay $selection]
			set vic_pos [GetRoundPosNoDelay $player]
			set map [lindex $npc_pos 0]
			foreach { npc_x npc_y npc_z } [lrange $npc_pos 1 3] {}
			foreach { vic_x vic_y vic_z } [lrange $vic_pos 1 3] {}
			set h [GetRoundAngle [CalcAngle $npc_x $npc_y $vic_x $vic_y]]
			set dz [expr {$vic_z-$npc_z}]
			set dist [::Distance $selection $player]
		}

		switch -- $cargs {
			"" {
			}
			"front" {
				if { $ot == 3 } {
					SQLdb_Set $map $npc_x $npc_y $npc_z $h $dz $dist
					array unset WallData $npc_pos,*
				}
			}
			"behind" {
				if { $ot == 3 } {
					SQLdb_Set $map $npc_x $npc_y $npc_z $h $dz [expr {$dist+$DELTA}]
					array unset WallData $npc_pos,*
				}
			}
			"del" {
				if { $ot == 3 } {
					SQLdb_Set $map $npc_x $npc_y $npc_z $h $dz -1
					array unset WallData $npc_pos,*
				}
			}
			"reset" {
				if { [SQLdb_ResetTable] } {
					array unset WallData
					return [::Texts::Get reset]
				}
			}
			"importpp" {
				set count [ImportPP 1]
				if { [info procs ::WoWEmu::Commands::broadcast] == "" } {
					return ".broadcast [::Texts::Get importpp $count]"
				}
				return [::WoWEmu::Commands::broadcast $player [::Texts::Get importpp $count]]
			}
			default {
				return [::Custom::Color [::Texts::Get help] yellow]
			}
		}

		if { $ot == 3 } {
			set name [::Custom::GetNpcName $selection]
			set wall_exists [Exists $selection $player]

			return [expr { $wall_exists ?
				[::Custom::Color [::Texts::Get cant_pass $name] red] :
				[::Custom::Color [::Texts::Get can_pass $name] lime] }]
		} else {
			return [::Custom::Color [::Texts::Get help] yellow]
		}
	}

	# check database/ppoints to know whether there is a path between an npc and the victim
	proc Exists { npc victim } {
		variable WallData
		set npc_pos [GetRoundPos $npc]
		set vic_pos [GetRoundPos $victim]

		if { [info exists WallData($npc_pos,$vic_pos)] } {
			return $WallData($npc_pos,$vic_pos)
		}

		if { $npc_pos == $vic_pos } {
			return [set WallData($npc_pos,$vic_pos) 0]
		}

		set map [lindex $npc_pos 0]
		foreach { npc_x npc_y npc_z } [lrange $npc_pos 1 3] {}
		foreach { vic_x vic_y vic_z } [lrange $vic_pos 1 3] {}
		set dx [expr {$vic_x-$npc_x}]
		set dy [expr {$vic_y-$npc_y}]
		set dz [expr {$vic_z-$npc_z}]
		set h [GetRoundAngle [CalcAngleD $dx $dy]]
		set dist [::Distance $npc $victim]

		# get from database
		set wall_dist [SQLdb_Get $map $npc_x $npc_y $npc_z $h $dz]
		if { [string is integer -strict $wall_dist] } {
			return [set WallData($npc_pos,$vic_pos) [expr {$wall_dist < 0 || $wall_dist > $dist ? 0 : 1}]]
		}

		if { $dz >= 10 } {
			return [set WallData($npc_pos,$vic_pos) 1]
		}

		# evaluate from ppoints
		variable DELTA
		set z [expr {round(($npc_z*2+$vic_z)/3.)}]
		if { abs($dx) > abs($dy) } {
			set d [expr {$dx<0?-$DELTA:$DELTA}]
			set m [expr {double($d*$dy)/double($dx)}]
			for { set x [expr {$npc_x+$d}]; set y [expr {$npc_y+$m}] } { $x != $vic_x } { incr x $d; set y [expr {$y+$m}] } {
				if { ![PPExists $map $x [expr {round($y)}] $z] } {
					return [set WallData($npc_pos,$vic_pos) 1]
				}
			}
			return [set WallData($npc_pos,$vic_pos) 0]
		} elseif { $dy } {
			set d [expr {$dy<0?-$DELTA:$DELTA}]
			set m [expr {double($d*$dx)/double($dy)}]
			for { set x [expr {$npc_x+$m}]; set y [expr {$npc_y+$d}] } { $y != $vic_y } { set x [expr {$x+$m}]; incr y $d } {
				if { ![PPExists $map [expr {round($x)}] $y $z] } {
					return [set WallData($npc_pos,$vic_pos) 1]
				}
			}
			return [set WallData($npc_pos,$vic_pos) 0]
		} else {
			return [set WallData($npc_pos,$vic_pos) 0]
		}
	}
}

# utilities
namespace eval ::Wall {

	# get an npc or player's cached position with rounded values
	proc GetRoundPos { obj } {
		variable CachedPos
		variable CachedPosTime
		variable DELTA
		set time [clock seconds]
		if { ![info exists CachedPosTime($obj)] || $time - $CachedPosTime($obj) > 2 } {
			set CachedPos($obj) [::GetPos $obj]
			lset CachedPos($obj) 1 [expr {round([lindex $CachedPos($obj) 1]/$DELTA)*$DELTA}]
			lset CachedPos($obj) 2 [expr {round([lindex $CachedPos($obj) 2]/$DELTA)*$DELTA}]
			lset CachedPos($obj) 3 [expr {round([lindex $CachedPos($obj) 3]/$DELTA)*$DELTA}]
			set CachedPosTime($obj) $time
		}
		return $CachedPos($obj)
	}

	proc GetRoundPosNoDelay { obj } {
		variable CachedPos
		variable DELTA
		set CachedPos($obj) [::GetPos $obj]
		lset CachedPos($obj) 1 [expr {round([lindex $CachedPos($obj) 1]/$DELTA)*$DELTA}]
		lset CachedPos($obj) 2 [expr {round([lindex $CachedPos($obj) 2]/$DELTA)*$DELTA}]
		lset CachedPos($obj) 3 [expr {round([lindex $CachedPos($obj) 3]/$DELTA)*$DELTA}]
		return $CachedPos($obj)
	}

	proc GetRoundAngle { h } {
		variable RAD_TO_DEG
		expr {round($h*$RAD_TO_DEG/45)*45%360}
	}


	proc CalcDistanceD { dx dy } {
		expr {round(hypot($dx, $dy))}
	}

	proc CalcAngleD { dx dy } {
		variable PI
		if { $dx == 0 } {
			if { $dy == 0 } {
				return [expr {0.0}]
			} elseif { $dy > 0 } {
				return [expr {$PI/2.}]
			} else {
				return [expr {$PI*3./2.}]
			}
		} elseif { $dy == 0 } {
			if { $dx > 0 } {
				return [expr {0.0}]
			} else {
				return [expr {$PI}]
			}
		} else {
			if { $dx < 0 } {
				return [expr {atan(double($dy)/$dx)+$PI}]
			} elseif { $dy < 0 } {
				return [expr {atan(double($dy)/$dx)+$PI*2.}]
			} else {
				return [expr {atan(double($dy)/$dx)}]
			}
		}
	}

	eval "proc CalcDistance { x0 y0 x1 y1 } {
		set dx \[expr \{\$x1-\$x0\}\]
		set dy \[expr \{\$y1-\$y0\}\]
		[string trim [info body CalcDistanceD]]
	}"

	eval "proc CalcAngle { x0 y0 x1 y1 } {
		set dx \[expr \{\$x1-\$x0\}\]
		set dy \[expr \{\$y1-\$y0\}\]
		[string trim [info body CalcAngleD]]
	}"
}

# ppoints
namespace eval ::Wall {

	# check for existing ppoints
	proc PPExists { map x y z } {
		variable nghandle
		variable DELTA
		::SQLdb::booleanSQLdb $nghandle "SELECT * FROM `ppoints` WHERE (`map` = $map AND `x` BETWEEN $x-$DELTA AND $x+$DELTA AND `y` BETWEEN $y-$DELTA AND $y+$DELTA AND `z` BETWEEN $z-$DELTA AND $z+$DELTA) LIMIT 1"
	}

	# round ppoints
	proc RoundPP { map x y z } {
		variable DELTA
		set x [expr {round($x/$DELTA)*$DELTA}]
		set y [expr {round($y/$DELTA)*$DELTA}]
		set z [expr {round($z/$DELTA+.5/$DELTA)*$DELTA}]
		return [list $map $x $y $z]
	}

	# import ppoints from binary and/or text files
	proc ImportPP { {force 0} } {
		variable nghandle
		variable INSTANCES_ONLY
		variable LOAD_BINARY_PPOINTS
		variable LOAD_TEXT_PPOINTS

		if { [::SQLdb::existsSQLdb $nghandle `ppoints`] } {
			if { !$force && ![catch { ::SQLdb::booleanSQLdb $nghandle "SELECT `map`, `x`, `y`, `z` FROM `ppoints` LIMIT 1" }] &&
				 [::SQLdb::firstcellSQLdb $nghandle "SELECT count(*) FROM `ppoints`"] } { return }
			::SQLdb::querySQLdb $nghandle "DROP TABLE `ppoints`"
		}

		puts "\n[LogPrefix]Importing ppoints, this can take several minutes..."
		::SQLdb::cleanupSQLdb $nghandle
		::SQLdb::querySQLdb $nghandle "CREATE TABLE `ppoints` (\
			`map` INTEGER NOT NULL DEFAULT 0,\
			`x` INTEGER NOT NULL DEFAULT 0,\
			`y` INTEGER NOT NULL DEFAULT 0,\
			`z` INTEGER NOT NULL DEFAULT 0)"
		set ppoints {}

		if { $LOAD_BINARY_PPOINTS } {
			puts "[LogPrefix]Loading binary ppoints..."
			foreach file [glob -nocomplain "saves/ppoints.*.bin"] {
				set map [lindex [split $file .] end-1]
				if { $INSTANCES_ONLY && $map <= 1 } { continue }
				set h [open $file]
				fconfigure $h -translation binary
				while { [binary scan [read $h 12] fff x y z] } {
					if { [catch { lappend ppoints [RoundPP $map $x $y $z] }] } {
						puts "[LogPrefix]Bad ppoint: $map $x $y $z"
					}
				}
				close $h
			}
		}

		if { $LOAD_TEXT_PPOINTS } {
			foreach file [glob -nocomplain "saves/ppoints.save*"] {
				puts "[LogPrefix]Loading text ppoints ([file tail $file])..."
				set map -1
				set h [open $file]
				while { [gets $h line] >= 0 } {
					if { [string index $line 0] == {[} } {
						set map [lindex [string range $line 1 end-1] 1]
						if { $INSTANCES_ONLY && $map <= 1 } { set map -1 }
					} elseif { $map >= 0 && [string index $line 0] == {P} } {
						foreach { x y z } [string range $line 3 end] {}
						if { [catch { lappend ppoints [RoundPP $map $x $y $z] }] } {
							puts "[LogPrefix]Bad ppoint: $map $x $y $z"
						}
					}
				}
				close $h
				break
			}
		}

		puts "[LogPrefix]Sorting ppoints..."
		set ppoints [join [lsort -dictionary -unique $ppoints]]

		puts "[LogPrefix]Writing to database..."
		transactionSQLdb $nghandle "START TRANSACTION"
		foreach { map x y z } $ppoints {
			::SQLdb::querySQLdb $nghandle "INSERT INTO `ppoints` (`map`, `x`, `y`, `z`) VALUES($map, $x, $y, $z)"
		}
		transactionSQLdb $nghandle "COMMIT"
		unset ppoints

		puts "[LogPrefix]Creating index..."
		::SQLdb::querySQLdb $nghandle "CREATE UNIQUE INDEX `ppoints_index` ON `ppoints` (`map`, `x`, `y`, `z`)"

		set count [::SQLdb::firstcellSQLdb $nghandle "SELECT count(*) FROM `ppoints`"]
		puts "[LogPrefix]$count ppoints imported to database.\n"

		if { $count < 100000 } {
			::Custom::Error "Number of ppoints ($count) may not be high enough for accurate wall estimations."
		}

		return $count
	}
}

# database
namespace eval ::Wall {

	proc SQLdb_Get { map x y z h dz } {
		variable nghandle
		::SQLdb::firstcellSQLdb $nghandle "SELECT `distance` FROM `wall` WHERE (`map` = $map AND `x` = $x AND `y` = $y AND `z` = $z AND `h` = $h AND `dz` = $dz) LIMIT 1"
	}

	proc SQLdb_Set { map x y z h dz distance } {
		variable nghandle
		if { [::SQLdb::booleanSQLdb $nghandle "SELECT `distance` FROM `wall` WHERE (`map` = $map AND `x` = $x AND `y` = $y AND `z` = $z AND `h` = $h AND `dz` = $dz) LIMIT 1"] } {
			::SQLdb::querySQLdb $nghandle "UPDATE `wall` SET `distance` = $distance WHERE (`map` = $map AND `x` = $x AND `y` = $y AND `z` = $z AND `h` = $h AND `dz` = $dz)"
		} else {
			::SQLdb::querySQLdb $nghandle "INSERT INTO `wall` (`map`, `x`, `y`, `z`, `h`, `dz`, `distance`) VALUES($map, $x, $y, $z, $h, $dz, $distance)"
		}
		return $distance
	}

	proc SQLdb_Unset { map x y z h dz } {
		variable nghandle
		::SQLdb::querySQLdb $nghandle "DELETE FROM `wall` WHERE (`map` = $map AND `x` = $x AND `y` = $y AND `z` = $z AND `h` = $h AND `dz` = $dz)"
	}

	proc SQLdb_CreateTable {} {
		variable nghandle
		if { ![::SQLdb::existsSQLdb $nghandle `wall`] } {
			::SQLdb::querySQLdb $nghandle "CREATE TABLE `wall` (\
				`map` INTEGER NOT NULL DEFAULT 0,\
				`x` INTEGER NOT NULL DEFAULT 0,\
				`y` INTEGER NOT NULL DEFAULT 0,\
				`z` INTEGER NOT NULL DEFAULT 0,\
				`h` INTEGER NOT NULL DEFAULT 0,\
				`dz` INTEGER NOT NULL DEFAULT 0,\
				`distance` INTEGER NOT NULL DEFAULT 0)"
			::SQLdb::querySQLdb $nghandle "CREATE UNIQUE INDEX `wall_index` ON `wall` (`map`, `x`, `y`, `z`, `h`, `dz`)"
			return 1
		}
		return 0
	}

	proc SQLdb_DropTable {} {
		variable nghandle
		if { [::SQLdb::existsSQLdb $nghandle `wall`] } {
			::SQLdb::querySQLdb $nghandle "DROP TABLE `wall`"
			return 1
		}
		return 0
	}

	proc SQLdb_ResetTable {} {
		variable nghandle
		if { [SQLdb_DropTable] && [SQLdb_CreateTable] } {
			::SQLdb::cleanupSQLdb $nghandle
			return 1
		}
		return 0
	}

	proc SQLdb_CheckTable {} {
		variable nghandle
		if { [catch { ::SQLdb::booleanSQLdb $nghandle "SELECT `map`, `x`, `y`, `z`, `h`, `dz`, `distance` FROM `wall` LIMIT 1" } err] } {
			::Custom::Error "`wall` table: $err"
			return 0
		}
		return 1
	}

	proc SQLdb_CheckPackage {} {
		variable MinSQLdbVer

		if { [lsearch [package names] "SQLdb"] < 0 } {
			::Custom::Error "SQLdb is not installed."
			return 0
		}

	 	package require SQLdb

		if { [lindex [lsort [package versions "SQLdb"]] end] < $MinSQLdbVer } {
			::Custom::Error "SQLdb v$MinSQLdbVer or higher is recommended."
		}

		return 1
	}

	proc SQLdb_Init {} {
		if { ![SQLdb_CheckPackage] } {
			proc SQLdb_Get { args } {}
			proc SQLdb_Set { args } {}
			proc SQLdb_ResetTable { args } { return 0 }

			return 0
		}

		if { ![info exists ::SQLdb::s_dbEngine] } {
			set ::SQLdb::s_dbEngine "Unknown"
		}

		variable nghandle [handleSQLdb]
		SQLdb_Register
		SQLdb_CreateTable

		if { ![SQLdb_CheckTable] } {
			SQLdb_ResetTable
			puts "[LogPrefix]`wall` table was reset."
		}
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


	proc transactionSQLdb { nghandle sql } {
		switch -glob -- [string tolower $sql] {
			"start*" -
			"begin*" {
				switch -glob -- $::SQLdb::s_dbEngine {
					"*" {
						::SQLdb::querySQLdb $nghandle "BEGIN"
					}
				}
			}
			"commit" {
				switch -glob -- $::SQLdb::s_dbEngine {
					"*" {
						::SQLdb::querySQLdb $nghandle "COMMIT"
					}
				}
			}
		}
	}

	proc handleSQLdb {} {
		if { ![info exists ::SQLdb::nghandle] } {
			set ::SQLdb::nghandle [::SQLdb::openSQLdb]
		}
		return $::SQLdb::nghandle
	}
}

# default localization
namespace eval ::Wall {
	if { ![::Texts::Exists] } {
		::Texts::Set en help		"Usage: .wall \[ front | behind | del | reset | importpp | help \]"
		::Texts::Set en can_pass	"%s can see you."
		::Texts::Set en cant_pass	"%s cannot see you."
		::Texts::Set en reset		"Wall table was reset."
		::Texts::Set en importpp	"%d ppoints imported."
	}
}

# initialization
namespace eval ::Wall {

	if { ![SQLdb_Init] } {
		::Custom::Error "Wall System requires SQLdb."
		namespace delete [namespace current]
		return
	}

	if { [info procs "::AI::ModAgro"] != "" } {
		# improved performance (needs StartTCL v0.9.2 or higher)
		::Custom::HookProc "::AI::ModAgro" {
			if { [::Wall::Exists $npc $victim] } { return 0 }
		}
	} elseif { [string first {return 1} [info body ::AI::CanAgro]] >= 0 } {
		eval "proc ::AI::CanAgro {[info args ::AI::CanAgro]} {[string map {{return 1} {if { [::Wall::Exists $npc $victim] } { return 0 } { return 1}}} [info body ::AI::CanAgro]]}"
	} else {
		::Custom::HookProc "::AI::CanAgro" {
			if { [::Wall::Exists $npc $victim] } { return 0 }
		}
		puts "\n[LogPrefix]StartTCL v0.9.2 or higher is required for improved performance.\n"
	}

	ImportPP
	::Custom::AddCommand "wall" "Wall::Command" 4

	::StartTCL::Provide

	if { $DEBUG } {
		puts "\n[namespace tail [namespace current]]: *** DEBUG MODE ENABLED ***\n"
		foreach proc [lsort [info procs]] {
			Custom::TraceCmd [namespace current]::$proc 0
		}
		#::Custom::BenchCmd ::Wall::Exists 1
	}
}

