### StatSystem 1.04
### Author Raverouk
### well this addons remplace the ArmorSpell addons and improve the AgilitySystem addons

### Thank's to spirit for his tcl files :D


###################################
### startup.tcl ###
###################################

please update the addons =)

### please if your find the folder stats in wowemu root directory please delete ###

### delete this lines in startup.tcl ###
global PlayerStat
set PlayerStat [list "0"]

### in the startup.tcl remplace process DamageReduction ###
	proc DamageReduction { player mob armor } {
		if {[Balance::Hit $player $mob] == 1} { return 1.0 }
		set armor [Balance::Armor $player $armor]

		set gmlvl 255
		set maxlvl 60
		set maxdif 8
		set mindif 16
		set moblvl [GetLevel $mob]
		set plrlvl [GetLevel $player]
		set entry [GetEntry $mob]
		set object [GetObjectType $mob]
		set rnd2 [expr {int(rand()*4)}]

		if {$maxlvl < 60} {set maxlvl 60}
		if {$plrlvl >= $gmlvl} {return 1}
		if {$plrlvl > $maxlvl} {set plrlvl $maxlvl}
		if {$moblvl > 99} {set moblvl 99}

		set dif [expr {$plrlvl-$moblvl}]
		set bonus [expr {$dif/500.0}]

		if {$object != 4} {
			set damage_list [join [GetScpValue "creatures.scp" "creature $entry" "damage"]]
			set rnd [expr {int(rand()*2)}]

			if {$damage_list != ""} {
				list $damage_list
				set dmg [lindex $damage_list $rnd]
			} else {
				set dmg 1
			}
			set dr [expr {($armor*1.0)/($armor+400.0+85*$moblvl+($dmg*50))}]
		} else {
			set dr [expr {($armor*1.0)/($armor+400.0+85*$moblvl)}]
		}
		set dr [expr {$dr+$bonus}]

		if {$moblvl >= [expr {$plrlvl + $maxdif}]} {set dr [expr {($dr*1.25)+($plrlvl/200.0)-1+$bonus}]}
		if {$plrlvl >= [expr {$moblvl + $mindif}]} {set dr [expr {($plrlvl/100.0)+($dr*0.25)+0.05+$bonus}]}

		set dr [Balance::Dr $player $mob $dr]
		return $dr
	}
########################################
### copy Stats.tcl to your tcl folder ##
########################################
### add to emu.conf ###
########################################
[client_addon StatSystem]
enabled=1
crc=0C53B3128
pub=cWGGR78UzPGqpqS97Wc960Sn7rEBV94pitddYFXmoRVUVpFf+3QJ/C6TfOdirh8q/eKmAkmG3V6uX7RvHqdhhrCNJeweqabREXqX/XRuIwy/kQgYjKj+WkiL1wUWj8Ji6lMbfQcl9QMZZF47R7Ybkajq3IX9z+5m0uXAN1lw7DU0QSOPeMnqlmOw3bSqjvNnRHyaG6GTWNbRA1nowBuiRju93lBzBMnD8fWjUb5Wcfq7urxfJqwvZ6VESmrSVBd/LdwVcGCg3LX/TeWdHe6y/9MCrwXc+iOZfOYB1FdMLcx/mrO17T/u+c/lG251wsLkUDEBDMPJPPUpbxmkfGnAwA==


########################################
### in the game ###
########################################
type ".stat create" for make sql database
type ".stat redo" for db delete
type ".stat info" to see stats of you or select player

########################################
### edit stats.tcl ###
########################################

	# 1-Enable or 2-Disable

	set enable_enrage 1
	set enable_dodge 1
	set enable_miss 1
	set enable_power 1
	set enable_attack 1

#####################Update#############
0.1 
- add agility to armor values, this only give base agility no bonus or spell 
0.2 
- now agility from items and spells works  
0.2b 
- update from addons (error with .retcl reset the global value) 
- make a counter to fix this 
0.2c 
- update the addons with new event 
0.3 
- fix error with multi characters 
0.4 
- new system (StatSystem) remplace Agility and ArmorSpell Systems 
- added armor 
- improve agility 
- now only need this to fix agility and armor not (AgilitySystem and ArmorSpell) 
0.5
- addons edited to intellect
- chance some values improve armor
0.6
- new process to improve critical chance
- added critical spell with intellect
- added critical melee with agility
- this only work in pvp :S i will try to do for mobs :(
(in critical this only make more damage...and this damage is not show like critical,
the critical calculator is internal i only make more damage with chances of intellect or agility)
0.6a 
-only update for tcl file 
-error with elseif sentence (sorry) :S 
0.6b
-some minor error
-some minor improves
0.7
-new dodge chance for mob and pvp
0.8
-new spell miss chance for pvp and mobs (base in lvl)
0.9
-mobs now make criticals
-enrage system
-sig for addons
1.0
-have strength bonus damage 
-security code and files (stats.log) in stats folder
-check old plugins 
-fix for invalid data 
-reduce memory usage 
-file manager
-reduce call to server
1.01
-minor error
-improve addons
1.02
-fix enrage
-fix plugin
1.03 *internal
1.04
- add secure addons (crc and sig file for server) 
- improve security to .call process for example .call 1000 1000 1000 1000 1000 
- now data is store in sql for latency reduction 
- fixed attack, enrage and power process 
- improve addons 
- improve logs (logs\stats.log) 
- new command .stat create (to make stats dababase) .stat info (to see stats dababase) and .stat redo (to delete the database) 
- option to disable enrage, dodge, miss, power and attack system 
- more balance dr in all process 
- add my damage reduction formula 
- fixed multi .call commands in wowemu console 



