########### config #############
if {$argc < 1} {puts "Invalid reward_xp rate!"; exit}
set xp_rate [lindex $argv 0]
if {[regexp -- {^[\d]+$} $xp_rate] != "1"} {puts "Invalid reward_xp rate!"; exit}
###########  end   #############
if {![file exists quests.scp]} {puts "quests.scp not found!"; exit}

### debug ###
set temp [open temp.txt w]
# end-debug #

set open [open quests.scp r+]
set lnum "0"
set xp_num "0"

puts "Starting to replace, please wait.."
after 500
catch {
	while {[gets $open line] >= 0} {
	set lnum [expr $lnum + 1]
		if {[string match -nocase reward_xp=* $line]} {
			set xp_num [expr $xp_num + 1]
			set xp [lindex [split $line =] 1]
			puts "Found reward_xp on line $lnum, replaced $xp to [expr $xp * $xp_rate]"
			puts $temp "[lreplace $line 0 0 reward_xp=[expr $xp * $xp_rate]]"
		} else {
			puts $temp $line
		}
	}
close $open
close $temp
} error
if {$error != ""} {
	puts "ERROR: $error"
} else {
	puts "-- Finished, replaced $xp_num rates in $xp_num quests --"
	file rename -force quests.scp quests_old.scp
	file rename -force temp.txt quests.scp
}