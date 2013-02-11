#Created by mLaPL - mlagrass@op.pl - Pewex Waypoint System v2.0.S  - Pewex Element

namespace eval WaySystem {

	variable VERSION "v2.0.S  no support"
	variable PEWEX_URL "scripts/Pewex"
	variable DB_URL "scripts/Pewex/WaySystem"
	variable WAYS_URL "scripts/Pewex/WaySystem/Ways"
	variable ACT_URL "scripts/Pewex/WaySystem/Act"
	variable SCP_URL "scripts/Pewex/WaySystem/Scp"
	variable DB_FILE "$::WaySystem::DB_URL/way_act.db"
	variable WAY_ID "0"
	variable NEXT_POINT "0"

	if { ![file exists $::WaySystem::DB_FILE] } {
		file mkdir $::WaySystem::PEWEX_URL
		file mkdir $::WaySystem::DB_URL
		file mkdir $::WaySystem::WAYS_URL
		file mkdir $::WaySystem::ACT_URL
		file mkdir $::WaySystem::SCP_URL

		set file [open "$::WaySystem::DB_URL/loaded" w+]
		close $file
	}

	if { [file exists "$::WaySystem::DB_URL/to_delete"] } {
		set file [open "$::WaySystem::DB_URL/to_delete" r]
			set filename [gets $file]
		close $file

		file delete "$::WaySystem::WAYS_URL/$filename.db"
		file delete "$::WaySystem::ACT_URL/$filename.db"
		file delete "$::WaySystem::DB_URL/to_delete"

	}

	package require sqlite3
	sqlite3 way_act "$::WaySystem::DB_FILE"

	way_act eval { CREATE TABLE IF NOT EXISTS `way_act` ( `pos` TEXT, `act` TEXT, `cargs` TEXT, `entry` TEXT, `way_id` TEXT ) }
      
}

proc WaySystem::DelLine { file line } {

	set co $line
	file copy $file "$file.buckup"
	set target [open $file w+]
	set source [open "$file.buckup" r]
	set result ""
	while { [gets $source line]>=0 } {
		if { $line!=$co } { 
			puts $target $line 
		} else {
			set result "OK"
		}
	}
	close $source
	close $target
	file delete "$file.buckup"
	return $result
}

proc WaySystem::Create_DB { player cargs } {

	if { [GetPlevel $player] < 5 } { 
		Say $player 0 "I cant use this command !!!"
		return
	}
	set file [open "$::WaySystem::DB_URL/loaded" w+]
	close $file
	way_act eval { DROP TABLE `way_act` }
      way_act eval { CREATE TABLE IF NOT EXISTS `way_act` ( `pos` TEXT, `act` TEXT, `cargs` TEXT, `entry` TEXT, `way_id` TEXT ) }
      Say $player 0 "WaySystem database reset: OK"
}

proc WaySystem::RandWays { cargs } {

	set numbers [split $cargs "."]	
      set ile [llength $numbers]
	set ktory [expr {rand()}]
      if { $ktory <= 0.5 } { set ktory 0 } else { set ktory 1 }

	return "[lindex $numbers $ktory]"
}
proc WaySystem::ActScript { npc } {

	set pos [GetPos $npc]

	set poss [split $pos " "]
      set x [lindex $poss 1]
      set y [lindex $poss 2]
      set z [lindex $poss 3]
	set pos "$x $y $z"

	way_act eval { CREATE TABLE IF NOT EXISTS `way_act` ( `pos` TEXT, `act` TEXT, `cargs` TEXT, `entry` TEXT, `way_id` TEXT ) }
      
	set act [way_act eval { SELECT `act` FROM `way_act` WHERE ( `pos` LIKE $pos ) }]
	set act [string trim $act "\{\}"]

	if { $act=="" } { return }

	set cargs [way_act eval { SELECT `cargs` FROM `way_act` WHERE ( `pos` LIKE $pos ) }]
	set cargs [string trim $cargs "\{\}"]
	set entry [way_act eval { SELECT `entry` FROM `way_act` WHERE ( `pos` LIKE $pos ) }]
	set entry [string trim $entry "\{\}"]
	set way_id [way_act eval { SELECT `way_id` FROM `way_act` WHERE ( `pos` LIKE $pos ) }]
	set way_id [string trim $way_id "\{\}"]

	#puts "$pos\n$act\n$cargs\n$entry\n$way_id"

	

	if { $act!="" } {

		switch $act {

			"say" {
				Say $npc 0 $cargs
				return
			}

			"cast" {
				CastSpell $npc $npc $cargs
				return
			}

			"over" {
				SetWayPoint $npc $cargs
				return
			}

			"wait" {
				Emote $npc "141"
				#SetWayPoint $npc $cargs
				return
			}

			"emote" {
				set cargs [split $cargs " "]
				#set next [lindex $cargs 0]
				set emote [lindex $cargs 1]
				Emote $npc $emote
				#SetWayPoint $npc $next
				return
			}

			"faction" {
				SetFaction $npc $cargs
				return
			}

			"onlycast" {
			      CastSpell $npc $npc $cargs
				SetWayPoint $npc 0
				return
			}

			"random" {
				set random "[::WaySystem::RandWays $cargs]"
				#puts "Random Way: $random"
				SetWayPoint $npc $random
				return
			}

		}

	}

}

proc WaySystem::WaySysCommand { player cargs } {

	if { [GetPlevel $player] < 5 } { 
		Say $player 0 "I cant use this command !!!"
		return
	}

	set args [split $cargs " "]
	if { [llength $args]>0 } { set command [lindex $args 0] } else { set command $cargs }
	
	for {set i 1} {$i<=[llength $args]} {incr i} {
		if { $i==1 } { set cargs "[lindex $args $i]" } else { set cargs "$cargs [lindex $args $i]" }
	}
	if { $command=="" } { set command "help" }

	set pos [GetPos $player]

	set poss [split $pos " "]
	set map [lindex $poss 0]
      set x [lindex $poss 1]
      set y [lindex $poss 2]
      set z [lindex $poss 3]
	set pos "$x $y $z"

	set way_id $::WaySystem::WAY_ID
	set point $::WaySystem::NEXT_POINT
	set next [expr { $point + 1 }]

	if { $command!="set" && $command!="goway" && $command!="newway" && $command!="load" && $command!="unload" && $command!="help" && $command!="reset_db" } {
      	set author [new_way eval { SELECT `author` FROM `new_way` WHERE ( `point` LIKE "0" ) }]	
	}

	switch $command {

		"addmount" {

			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "FindAndMount::Spell", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = $map, `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}
	
			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"addnext" {

			set poss [split $pos " "]
      		set x [lindex $poss 0]
      		set y [lindex $poss 1]
			if { $cargs=="" } { set height 0 } else { set height $cargs }
			set y [expr { $y + $height }] 
      		set z [lindex $poss 2]
			set pos "$x $y $z"
			
			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "none", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}
		
			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}
		
		"addsay" {
			if { $cargs == "" } { return "Write a Text !!!" }

			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "say", $cargs, "0", $way_id)}	
			
			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}
	
			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"addcast" {
			if { $cargs == "" } { return "Write a Spell_ID !!!" }

			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "cast", $cargs, "0", $way_id)}	

			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}

			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"addover" {
			if { $cargs == "" } { return "Write a WayPoint_ID !!!" }

			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "over", $cargs, "0", $way_id)}		
			
			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}

			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"addwait" {

			set wait_c "$next"
			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "wait", $wait_c, "0", $way_id)}	
			
			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}

			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"addemote" {
			if { $cargs == "" } {return "Write a Emote_ID !!!" }

			set emote_c "$next $cargs"
			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "emote", $emote_c, "0", $way_id)}	

			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}

			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"addfaction" {
			if { $cargs == "" } { return "Write a Faction_ID !!!" }

			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "faction", $cargs, "0", $way_id)}

			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}
	
			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"onlycast" {
			if { $cargs == "" } { return "Write a Spell_ID !!!" }

			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "onlycast", $cargs, "0", $way_id)}	
			
			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $next, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}

			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"addrand" {
      		if { [lsearch $cargs "."] == 0 } { return "You must write two WayPoint_ID !!! like this - 1234.4321." }
      		set numerki [split $cargs "."]
      		if { [llength $numerki] <= 1 } { return "You must write two WayPoint_ID !!! like this - 1234.4321." }

			act_way eval {INSERT INTO `act_way` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, "random", $cargs, "0", $way_id)}

			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $way_id, "WaySystem::ActScript", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $next, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}

			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"
		}

		"newway" {

			set args [split $cargs " "]
			set start_point [lindex $args 0]
			if { $start_point=="" } { return "You must write a Start_Point number !!!" }
			set way_id $start_point
			set next [expr { $start_point + 1 }]
			set way_author [lindex $args 1]
			if { $way_author=="" } { return "You must write a Author name !!!" }

			if { [file exists $::WaySystem::WAYS_URL/$way_id.db] } {
			      Say $player 0 "This Start_Point exists. I must select another Start_Point."
				return
			} else {

				set ::WaySystem::WAY_ID $way_id
				set ::WaySystem::NEXT_POINT $next

				if { ![file exists "$::WaySystem::DB_URL/to_delete"] } {
					set file [open "$::WaySystem::DB_URL/to_delete" w+]
						puts $file $way_id
					close $file
				} else {
					Say $player 0 "I must first delete last not ended way ( .wp deleteway )"
					return
				}

				package require sqlite3
				sqlite3 new_way "$::WaySystem::WAYS_URL/$way_id.db"

				package require sqlite3
				sqlite3 act_way "$::WaySystem::ACT_URL/$way_id.db"

				new_way eval { CREATE TABLE IF NOT EXISTS `new_way` ( `point` TEXT, `pos` TEXT, `next` TEXT, `script` TEXT, `way_id` TEXT, `author` TEXT ) }
      			act_way eval { CREATE TABLE IF NOT EXISTS `act_way` ( `pos` TEXT, `act` TEXT, `cargs` TEXT, `entry` TEXT, `way_id` TEXT ) }
      			
                        new_way eval { INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $start_point, $pos, $next, "none", $way_id, $author)}
				new_way eval { INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( "0", "[GetName $player]", $::WaySystem::WAY_ID, $next, $way_id, $way_author)}

				Say $player 0 "Now I can create way.."
			}
			return "== WAY_ID: $way_id =======================\n\[point $start_point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\n"

		}

		"deleteway" {
			Say $player 0 "OK"
			return ".retcl"

		}

		"saveway" {
			if { [file exists "$::WaySystem::DB_URL/to_delete"] } {
				set file [open "$::WaySystem::DB_URL/to_delete" r]
					set filename [gets $file]
				close $file

				file delete "$::WaySystem::DB_URL/to_delete"

				Say $player 0 "Way Saved: start point = $::WaySystem::WAY_ID"
				return ".retcl"
				
			} else {
				Say $player 0 "I must first create Way ( .wp newway ?start_point? ?author_name? )"
				return
			}

		}

		"golast" {
			set last [expr { $::WaySystem::NEXT_POINT - 1 }]
			if { [file exists "$::WaySystem::DB_URL/to_delete"] } {
				set lastpos [new_way eval { SELECT `pos` FROM `new_way` WHERE ( `point` LIKE $last ) }]
				set poss [split $lastpos " "]
				set map [lindex $poss 0]
      			set x [lindex $poss 1]
      			set y [lindex $poss 2]
      			set z [lindex $poss 3]
				Say $player 0 "point $last" 
				Teleport $player $map $x $y $z
				return
			} else {
				Say $player 0 "I must first create Way ( .wp newway ?start_point? ?author_name? )"
				return
			}
			
		}

		"showlast" {
			set last [expr { $::WaySystem::NEXT_POINT - 1 }]
			if { [file exists "$::WaySystem::DB_URL/to_delete"] } {
				set lastpos [new_way eval { SELECT `pos` FROM `new_way` WHERE ( `point` LIKE $last ) }]

				set curPos [split $lastpos " "]

				set x [expr {round([lindex $curPos 1])}]
				set y [expr {round([lindex $curPos 2])}]

				SendPOI $player 3 $x $y 6 1637 "point $last"
				Say $player 0 "Showed in map"
				return
			} else {
				Say $player 0 "I must first create Way ( .wp newway ?start_point? ?author_name? )"
				return
			}
			
		}

		"addloop" {

			set poss [split $pos " "]
      		set x [lindex $poss 0]
      		set y [lindex $poss 1]
			if { $cargs=="" } { set height 0 } else { set height $cargs }
			set y [expr { $y + $height }] 
      		set z [lindex $poss 2]
			set pos "$x $y $z"
			
			new_way eval {INSERT INTO `new_way` (`point`, `pos`, `next`, `script`, `way_id`, `author`) VALUES ( $point, $pos, $way_id, "none", $way_id, $author)}
			new_way eval {UPDATE `new_way` set `point` = "0", `pos` = "[GetName $player]", `next` = $way_id, `script`= $point, `way_id` = $way_id, `author` = $author WHERE (`point` = "0")}
		
			set ::WaySystem::NEXT_POINT $next

			return "== WAY_ID: $way_id =======================\n\[point $point\]\npos=$pos\nnext=$next\nact=$command\n$cargs\n\nNow you set way to loop.. Save way or delete way.."
		}

		"load" {

			set cargs [lindex [split $cargs " "] 0]

			if { $cargs=="" } { return "You must write a Way_ID !!!" }

			if { ![file exists "$::WaySystem::WAYS_URL/$cargs.db"] } { return "ERROR: Cant find file $::WaySystem::WAYS_URL/$cargs.db" }
			if { ![file exists "$::WaySystem::ACT_URL/$cargs.db"] } { return "ERROR: Cant find file $::WaySystem::ACT_URL/$cargs.db" }

			package require sqlite3
			sqlite3 new_way "$::WaySystem::WAYS_URL/$cargs.db"
                  new_way eval { CREATE TABLE IF NOT EXISTS `new_way` ( `point` TEXT, `pos` TEXT, `next` TEXT, `script` TEXT, `way_id` TEXT, `author` TEXT ) }
			#new_way eval { OPEN TABLE `new_way` }

			package require sqlite3
			sqlite3 act_way "$::WaySystem::ACT_URL/$cargs.db"
			act_way eval { CREATE TABLE IF NOT EXISTS `act_way` ( `pos` TEXT, `act` TEXT, `cargs` TEXT, `entry` TEXT, `way_id` TEXT ) }
			#act_way eval { OPEN TABLE `act_way` }

			set last_point [new_way eval { SELECT `script` FROM `new_way` WHERE ( `point` LIKE "0" ) }]
			set first_point [new_way eval { SELECT `next` FROM `new_way` WHERE ( `point` LIKE "0" ) }]
			set author [new_way eval { SELECT `author` FROM `new_way` WHERE ( `point` LIKE "0" ) }]

			if { $first_point!=$cargs } { 
				Say $player 0 "This way is not original.. Cant load.."
				return ".retcl"
			}

			set file "$::WaySystem::SCP_URL/$cargs.scp"
			set file [open $file w+]

			puts $file "///////////////////////////////////////////////////////////"
			puts $file "// Generated by Pewex Waypoint System $::WaySystem::VERSION"
			puts $file "// Way_ID: $cargs"
			puts $file "// Author: $author"		
			puts $file "// Description: Not have"	
			puts $file "///////////////////////////////////////////////////////////\n"

			for { set i $first_point } { $i<=$last_point } { incr i } {

				set point_id "\[point $i\]"

				#THIS LINE READ POSITION TO NEW EXPORT POINT... WORK GOOD
				set pos [new_way eval { SELECT `pos` FROM `new_way` WHERE ( `point` LIKE $i ) }]
				set pos [string trim $pos "\{\}"]
				set point_pos "pos=$pos"

			if { $point_pos!="pos=" } {

				puts $file $point_id
				puts $file $point_pos
				set act ""

				set point_script [new_way eval { SELECT `script` FROM `new_way` WHERE ( `point` LIKE $i ) }]

				set point_id [way_act eval {SELECT `way_id` FROM `way_act` WHERE (`pos` = $pos)}]
				set point_id [string trim $point_id "\{\}"]

				if { $point_script!="none" && $point_script!="" && $point_id!=$first_point } {
		
					set point_script "script=$point_script"
					puts $file $point_script
					
                              #THIS LINEs READ INFORMATIONS FROM ACT_DB.. NOT WORK :(
					set act [act_way eval { SELECT `act` FROM `act_way` WHERE ( `pos` LIKE $pos ) }]
					set act [string trim $act "\{\}"]
					set args [act_way eval { SELECT `cargs` FROM `act_way` WHERE ( `pos` LIKE $pos ) }]
					set args [string trim $args "\{\}."]
					set entry [act_way eval { SELECT `entry` FROM `act_way` WHERE ( `pos` LIKE $pos ) }]
					set entry [string trim $entry "\{\}"]
					set way_id $cargs

					#THIS LINE SHOW READED INFORMATIONS FROM ACT_DB 
					puts "to find in db = $pos\nact = $act\nargs = $args\nentry = $entry\n"
	                        #THIS LINE SAVE TO ANOTHER DB.. DB ACTIONS IN POINTS..
					way_act eval {INSERT INTO `way_act` (`pos`, `act`, `cargs`, `entry`, `way_id`) VALUES ($pos, $act, $args, $entry, $way_id)}	
					

				}
				set point_next [new_way eval { SELECT `next` FROM `new_way` WHERE ( `point` LIKE $i ) }]
				if { $act!="random" } { set point_next "next=$point_next" } else { set point_next "next=$way_id" }
				puts $file $point_next
				puts $file ""
			}

			}

			close $file

			set file "scripts/waypoints.scp"
			set file [open $file a+]
				puts $file "\#include $::WaySystem::SCP_URL/$cargs.scp"
			close $file

			set file [open "$::WaySystem::DB_URL/loaded" a+]
				puts $file "Way_ID=$cargs"
			close $file
			
			Say $player 0 "Now I must reload SCP files"
			return ".retcl"
	
		}

		"unload" {

			set cargs [lindex [split $cargs " "] 0]

			if { $cargs=="" } { return "You must write a Way_ID !!!" }

			set line "Way_ID=$cargs"
			set file "$::WaySystem::DB_URL/loaded"

			if { ![file exists "$::WaySystem::WAYS_URL/$cargs.db"] } { return "ERROR: Cant find file $::WaySystem::WAYS_URL/$cargs.db" }
			if { ![file exists "$::WaySystem::ACT_URL/$cargs.db"] } { return "ERROR: Cant find file $::WaySystem::ACT_URL/$cargs.db" }

			if { [::WaySystem::DelLine $file $line]=="OK" } {
				
				file delete "$::WaySystem::SCP_URL/$cargs.scp"

				package require sqlite3
				sqlite3 new_way "$::WaySystem::WAYS_URL/$cargs.db"
                  	new_way eval { CREATE TABLE IF NOT EXISTS `new_way` ( `point` TEXT, `pos` TEXT, `next` TEXT, `script` TEXT, `way_id` TEXT, `author` TEXT ) }

				set last_point [new_way eval { SELECT `script` FROM `new_way` WHERE ( `point` LIKE "0" ) }]
				set last_point [string trim $last_point "\{\}"]
				set first_point [new_way eval { SELECT `next` FROM `new_way` WHERE ( `point` LIKE "0" ) }]
				set first_point [string trim $first_point "\{\}"]

				for {set i $first_point} {$i<=$last_point} {incr i} {

					set point_pos [new_way eval { SELECT `pos` FROM `new_way` WHERE ( `point` LIKE $i ) }]
				      set point_pos [string trim $point_pos "\{\}"]
					set in_db [way_act eval {SELECT `way_id` FROM `way_act` WHERE (`pos` = $point_pos)}]
					set in_db [string trim $in_db "\{\}"]

					if { $in_db!=$first_point } {
						way_act eval {UPDATE `way_act` set `pos` = "", `act` = "", `cargs` = "", `entry` = "", `way_id` = $first_point WHERE (`way_id` = $first_point)}
					}
				}
				set result [::WaySystem::DelLine "scripts/waypoints.scp" "\#include $::WaySystem::SCP_URL/$cargs.scp"]
				Say $player 0 $result
				return ".retcl"

			}
			
		}

		"set" {
			set cargs [lindex [split $cargs " "] 0]
			set npc [GetSelection $player]
			if { $npc=="0" } { return "SetWayPoint \[$cargs\]: You Not Select NPC" }
			set type [GetObjectType $npc]
			if { $type==4 } { return "SetWayPoint \[$cargs\]: You Cant Set Way For Players" }
			SetWayPoint $npc $cargs
			return "SetWayPoint \[$cargs\]: OK"
		}

		"reset_db" {
			return "[::WaySystem::Create_DB $player 0]"
		}

		"goway" {
			set cargs [lindex [split $cargs " "] 0]
			if { ![file exists "$::WaySystem::WAYS_URL/$cargs.db"] } { return "ERROR: Cant find Way: $cargs" }

			package require sqlite3
			sqlite3 new_way "$::WaySystem::WAYS_URL/$cargs.db"
                  new_way eval { CREATE TABLE IF NOT EXISTS `new_way` ( `point` TEXT, `pos` TEXT, `next` TEXT, `script` TEXT, `way_id` TEXT, `author` TEXT ) }
			set p_pos [new_way eval { SELECT `pos` FROM `new_way` WHERE ( `point` LIKE $cargs ) }]
			set p_pos [string trim $p_pos "\{\}"]
			set poss [split $p_pos " "]
      		set x [lindex $poss 0]
      		set y [lindex $poss 1]
      		set z [lindex $poss 2]
			set map [new_way eval { SELECT `pos` FROM `new_way` WHERE ( `point` LIKE "0" ) }]
			set map [string trim $map "\{\}"]

			Teleport $player $map $x $y $z
			return ".retcl"
		}

		"help" {

			set _info "Pewex Waypoint System $::WaySystem::VERSION by mLaPL - Help:\n\n"

			set _set ".wp set ?point_id? - SetWayPoint Npc\n"
			set _goway ".wp goway ?Way_ID? - Teleport to first point from way..\n"

			set _addsay ".wp addsay ?text? - Npc say text\n"
			set _addcast ".wp addcast ?spell_id? - Npc cast spell for self only\n"
			set _addnext ".wp addnext ?height? or nothing - Npc move to this point ( You can set heigth )\n"
			set _onlycast ".wp onlycast ?spell_id? - Npc cast spell and back to spawn settings. You must after save or delete way\n"
			set _addloop ".wp addloop - Npc move to first waypoint. You must after save or delete way\n"
			set _addfaction ".wp addfaction ?faction_id? - Npc change faction\n"
			set _addwait ".wp addwait - Npc wait 1..2 seconds\n"
			set _addemote ".wp addemote ?emote_id? - Npc show emote 1..2 seconds\n"
			set _addrand ".wp addrand ?point_id.point_id.? - Random way from two ways and SetWayPoint Npc. You must after save or delete way\n"
			set _addover ".wp addover ?point_id? - SetWayPoint Npc. You must after save or delete way\n"

			set _showlast ".wp showlast - Show last point in map\n"
			set _golast ".wp golast - Teleport to last point position\n"

			set _newway ".wp newway ?way_id? ?author_name? - Start new way and add first point\n"
			set _deleteway ".wp deleteway - Delete current edited way\n"
			set _saveway ".wp saveway - Save current edited way\n"
			set _load ".wp load ?way_id? - Create SCP file, add include line to waypoints.scp and add actions to global DB\n"
			set _unload ".wp unload ?way_id? - Delete SCP file, delete include line from waypoints.scp and delete actions from global DB\n"

			set _reset_db ".wp reset_db - Reset global actions DB\n"

			Say $player 0 "|cffffff00$_info-$_set-$_goway-$_addsay-$_addcast-$_addnext-$_onlycast-$_addloop-$_addfaction-$_addwait-$_addemote-$_addrand-$_addover-$_showlast-$_golast-$_newway-$_deleteway-$_saveway-$_load-$_unload-$_reset_db|r"
			Say $player 0 " "
			return
                

                 "helps" {
                      ::Texts::Get "                 

                        wp set ?point_id? - SetWayPoint Npc
			wp goway ?Way_ID? - Teleport to first point from way..

			wp addsay ?text? - Npc say text\n"
			wp addcast ?spell_id? - Npc cast spell for self only
			wp addnext ?height? or nothing - Npc move to this point ( You can set heigth )
			wp onlycast ?spell_id? - Npc cast spell and back to spawn settings. You must after save or delete way
			wp addloop - Npc move to first waypoint. You must after save or delete way
			wp addfaction ?faction_id? - Npc change faction
			wp addwait - Npc wait 1..2 seconds
			wp addemote ?emote_id? - Npc show emote 1..2 seconds
			wp addrand ?point_id.point_id.? - Random way from two ways and SetWayPoint Npc. You must after save or delete way
		        wp addover ?point_id? - SetWayPoint Npc. You must after save or delete way

			wp showlast - Show last point in map
			wp golast - Teleport to last point position

			wp newway ?way_id? ?author_name? - Start new way and add first point
			wp deleteway - Delete current edited way
			wp saveway - Save current edited way
			wp load ?way_id? - Create SCP file, add include line to waypoints.scp and add actions to global DB
			wp unload ?way_id? - Delete SCP file, delete include line from waypoints.scp and delete actions from global DB

			wp reset_db - Reset global actions DB"

  
                }
		}

	}
}
  
::Custom::AddCommand "wp" "::WaySystem::WaySysCommand" 5

set loadinfo "Pewex Waypoint System $::WaySystem::VERSION by mLaPL : Loaded"
puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"