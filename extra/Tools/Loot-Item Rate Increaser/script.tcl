######## config ########
if {$argc != "1"} {puts "Invalid droprate!"; exit}
set drop_rate [lindex $argv 0]
if {[regexp -- {^[\d]+$} $drop_rate] != "1"} {puts "Invalid droprate!"; exit}
######### end  #########


### debug ###
if {![file exists loottemplates.scp]} {puts "loottemplates.scp not found"; exit}
file rename -force loottemplates.scp loottemplates_old.scp
set a [open loottemplates.scp w]; close $a
# end-debug #

set in [open loottemplates_old.scp r+]
set out [open loottemplates.scp r+]
set time [clock seconds]
set lnum "0"

puts "Setting all item loots to $drop_rate, please wait..."
catch {
   foreach {line} [split [read $in] \n] {
   set lnum [expr $lnum + 1]
	if {[string index $line 0] != "\[" && $line != ""} {
		puts $out [lreplace $line 1 1 $drop_rate]
	} else {
		puts $out $line
		if {$line != ""} {puts "found template: $line - changing all drop rates to $drop_rate"}
	}
   }
} error
if {$error == ""} {puts "Done, took [expr [clock seconds] - $time] seconds"} else {puts $error}
close $in
close $out