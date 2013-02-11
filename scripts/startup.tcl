#
#
# This file is part of the StartTCL Startup System
#
# StartTCL is (c) 2006 by Lazarus Long <lazarus.long@bigfoot.com>
# StartTCL is (c) 2006 by Spirit <thehiddenspirit@hotmail.com>
#
# StartTCL is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation; either version 2.1 of the License, or (at your option)
# any later version.
#
# StartTCL is distributed in the hope that it will be useful, but WITHOUT ANY
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR
# A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
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
# Name:		startup.tcl / $SCRIPTS_DIR/api/*.tcl / Custom.tcl
#
# Version:	0.9.6
#
# Date:		2006-09-19
#
# Description:  StartTCL Startup System
#
# Authors:	Lazarus Long <lazarus.long@bigfoot.com>
#		Spirit <thehiddenspirit@hotmail.com>
#
# Changelog:
#
# v0.9.6 (2006-09-19) -	The "a bit more than fixing" version.
#			ExtraCommands: removed commands redundant with GmTools.
#			AutoBan: cooldown is reset when entering instances,
#			added an option to kick or jail players	instead of
#			banning, added some spells to cheat list, improved patch
#			compatibility with BAD & team's Spell.dbc. Redesign to
#			only use spell data thanks to ideas from Tha-Doctor and
#			AceIndy. Check for usurped spells. No banning if a spell
#			is cast with the ::CastSpell command.
#			Added "check_grey_level" option for XP Calculation,
#			when disabled it will allow XP from grey level mobs.
#			Changed "melee_spell_casting" into "melee_cast_method"
#			which allows choosing between spell casting in melee
#			range using "On Damage" or "On UnAgro" methods. Added
#			"melee_cast_rate" which allows tuning the casting rate.
#			Added "cast_time_sensivity" option.
#			Custom: New GetMoney procedure, cache from
#			GetCreatureScp is cleared when ".rescp" is used. New
#			GetIntegerValue procedure to retrieve an integer from an
#			scp value using the ".." or "," syntax.
#			AI scripts: updates from Ata & Ellessar with some fixes,
#			spell data moved to an external text file with some
#			extra data used by AutoBan, casting of a dummy spell
#			::AI::NoSpell to allow mobs to correctly unaggro, added
#			Ahn'Qiraj AI scripts thanks to elonar.
#			WoWEmu_CalcXP: fix for some party bug exploit reported
#			by smartwork. MasterScript v3.4 is included.
#			ngChanneling removed, newer versions are now released
#			separately.
#			Mount: Added Peon sleeping and Spirit Healer ghost into
#			MountArray thanks to Neverdie.
#
# v0.9.5 (2006-05-26) - The "let's move on" version.
#			Support for third-party scripts has been dropped
#			(contact the third-party script authors for support).
#			Added localizations for Czech (kupkoid), Dutch
#			(WhiteCrow), Polish (Vlad), Russian (romanZ) and
#			Portuguese. AutoBan has updated spell patch, checking
#			of spell cooldowns, checking for the dummy loot
#			template and new "ban_ip" and "allow_gm" options.
#			Fixed "::Custom::CountInMap", "::Custom::ReadOnline"
#			and "::Custom::DbArray". New procedures
#			"::Custom::AddLegacySpellScript" and
#			"::Custom::IsOnlineByName". New "::AI::ModUnAgro"
#			procedure. Reverted the unaggro distance back to 40
#			yards and several AI small optimizations. Fixed ".pvp
#			leave" and removed "jail" commands from the
#			ExtraCommands.tcl file. Updated MasterScript.tcl to
#			version 3.2.2 (thanks "SmartWork" for allowing us to
#			distribute this newest version first hand) plus with
#			the default_reputation option and the new logging of
#			completed quests and a  check for repeatable quests in
#			"::MasterScript::RequestReward" also moved the load
#			priority of MasterScript to level n. Fixed the internal
#			"::StartTCL::Require" procedure that was reporting the
#			wrong filename when an error occurred while loading.
#			Added the new NextGen Channeling System.
#
# v0.9.4 (2006-05-10) - The "gain it from an elite also" version.
#			Fixed an important bug where no XP was gained against
#			elite mobs.
#
# v0.9.3 (2006-05-10) - The "ready or not" version.
#			GmTools improved with new ".aggro" and ".damage"
#			commands to enabled/disabled aggro and damage.
#			dbconsole is replaced by ngconsole. Mount script
#			included. Loading of UTF-8 with BOM encoded tcl files.
#			Cooldown checked for teleport spells. New aiscripts
#			thanks to Ata & Ellessar. New Custom procedures
#			"DelCommand", "DelSpellScript", "DbArray",
#			"DbArrayValue", "GetKnownPlayers", "CountInMap" and
#			"GetAllOnlineData". Fixed AutoBan reading of config
#			file. A whole bunch of minor fixes to support for third
#			party commands and scripts. Added the most requested
#			"noaggro_leveldiff" option to "start-tcl.conf". Fixed
#			character eating bug in LevelEdit.
#
# v0.9.2 (2006-04-13) - The "not going anywhere" version.
#			Some translation files added. Support for common third
#			party scripts and commands. Some fixes in AI. Addition
#			of a new script AutoBan.tcl, Inclusion of GMTools under
#			the same license as the rest of the pack, Creation of
#			separate files for commonly tweaked scripts and procs
#			"ExtraCommands.tcl.off" and "ExtraScripts.tcl.off"
#			(remove the extension ".off" to activate and comment
#			what you don't want to use). Code speedup and formating
#			and fixed compatibility issues. Fixed GMTools namespace.
#			Addition of some common procedures from UWC, courtesy of
#			Hochelf (thank you). German and French translations.
#			New "::Custom::LogCommand" and a new top level missing
#			command loop "do .. while". New tweaking procedures
#			"::AI::ModAgro", "::WoWEmu::ModDR" and
#			"::WoWEmu::ModXP", so third party authors can make
#			modular scripts easier. Minor changes to third party
#			script "MasterScript.tcl" to allow better integration
#			with the startup sequence. Changed the fishing system
#			to destroy previous bobber when player launches a new
#			one and to get a individualized PeckTime per player.
#
# v0.9.1 (2006-03-29) -	The "cut the head off" version.
#			Updates to WorldLock and AI. Added "-exact" option to
#			::StartTCL::Require. Added configuration controlled
#			logging of GM commands affecting players.
#
# v0.9.0 (2006-03-27) -	The "let's bump the version some more" version.
#			It's way too different to keep at 0.8.x. The AI is now
#			managing cooldowns individually to each NPC and spell.
#			This is hopefully a releasable version since the
#			rewrite started with v0.8.3. Hard to state all the
#			differences, since it practically a rewrite, so treat
#			this as a new version, updates from previous versions
#			should be dealt as new installs.
#
# v0.8.4 (2006-03-26) -	The "let's increment the version" version.
#			Quite some changes have happened. Incrementing the
#			version is the least we could do. Many fixes and
#			improvements, package like facility has been
#			implemented.
#
# v0.8.3 (2006-03-21) -	The "have a look, completely untested, tell me what you
#			think" version.
#			Major rewrite of "startup.tcl", addition of up-to-date
#			TCL API procedures, creation of a configuration file
#			(no more need to edit the startup.tcl ever).
#
# v0.8.2 (2006-03-20) -	The "sort it out" version.
#			Reverted back to "dictionary" sorting since "integer"
#			chokes on levels that start by 0 and are followed by 8
#			or 9 'cause the option assumes they are octal numbers.
#			Included a graphical level editor to the archive to
#			ease level setting. Included WorldLock.tcl back to the
#			pack, READ the instructions or it WILL crash your
#			system.
#
# v0.8.1 (2006-03-15) -	The "space in space" version.
#			Found out a problem with "concat" when the path
#			contains spaces, converted to "lappend".
#
# v0.8.0 (2006-03-15) -	The "ready for prime time" version.
#			Done the documentation explaining how to set
#			it up.
#
# v0.7.2 (2006-03-11) -	The "faster than a speeding bullet" version.
#			Final changes. One important for performance is that
#			the StartTCL information regarding the level to run at
#			must be in the first block of comments at the top of
#			the script, before any non-comment data (excluding
#			empty lines) or else it will be ignored.
#
# v0.7.1 (2006-03-10) -	The "there can be only one" version.
#			If there are two files with identical names only
#			differing in the extension issue a warning.
#
# v0.7.0 (2006-03-10) -	The "one size fits all" version.
#			All scripts are now loaded from the same folder,
#			regardless of being TCL or TBC.
#
# v0.6.6 (2006-03-08) -	The "lets go global" version.
#			Spirit's onboard. It's more than deserved since half
#			the changes are either his suggestions or his code so
#			it's co-authored from now on. Going global for the sort
#			system both TCL and TBC based.
#
# v0.6.5 (2006-03-02) -	The "no dash to separate us" version.
#			Removed the dash "-" from the namespace and script name
#			since it was giving too many trouble.
#
# v0.6.4 (2006-02-28) -	The "less is best" version.
#			Reduced the number of levels by one, since there was no
#			need for 4 start levels.
#
# v0.6.3 (2006-02-26) -	The "new approach" version.
#			OK, I found a weakness by relying only on the filename,
#			so I looked for another approach and BSD systems have
#			it. The file itself contains the information of when it
#			should be loaded, so this is a much more robust method.
#
# v0.6.2 (2006-02-22) -	The "preload bye bye" version.
#			I finaly decided to give up the preloader idea, it was
#			prone to misinterpretations and errors, it's time to go
#			System V all the way, which means that filenames alone
#			decide the order of loading, the rest is decided by
#			convention.
#
# v0.6.1 (2006-02-20) -	The "sort me out" version.
#			Redid the whole idea by case insensitive sorting the
#			filenames, which gives a consistent order across OS
#			versions.
#
# v0.6.0 (2006-02-01) -	The "inform me of errors" version.
#			Included the $errorInfo variable in error messages.
#
# v0.5.0 (2006-01-26) -	The "incremental" version.
#			Changed the way the counters are incremented.
#
# v0.4.0 (2006-01-26) -	The "with license" version.
#			Put it under LGPL, instead of GPL.
#
# v0.3.0 (2006-01-14) -	The "best of both" version.
#			I'm puting back the former behaviour of loading files
#			from the "scripts\pls" into the WoWEmu namespace. To
#			add global directives and/or defines edit/create
#			"scripts/local/preload.tcl".
#
# v0.2.0 (2006-01-14) -	The "better make up your mind" version.
#			I'm still trying to figure out the best way to preload
#			scripts.
#
# v0.1.0 (2006-01-13) -	The "I sure hope I'm doing it right" version.
#			First attempt. This is going to be very generic. I
#			didn't base it in nothing particular, but took ideas
#			from here and there from almost every "startup.tcl" I
#			got my hands on so WDDG, Ecko007, Ramanubis, Spirit,
#			GriffonHeart and Golgorth are just the ones that I
#			remember, most surelly there are others.
#
#


#
#	Global defines
#
# system-wide default configuration variables
#
variable DEBUG 0
variable VERBOSE 1
variable LANG default


#
#	namespace eval ::StartTCL
#
# startup namespace and variable definitions
#
namespace eval ::StartTCL {
	variable NAME "StartTCL"
	variable VERSION "0.9.6"

	variable AUTHOR "Lazarus Long & Spirit"
	variable HEADER "$NAME v$VERSION\tGNU LGPL V2.1 (c) by $AUTHOR"

	variable timeup [ clock seconds ]

	variable basedir "scripts"
	variable scriptsdirs {}
	variable scripts {}

	variable levels
	array set levels {
		a	100
		b	200
		c	300
		n	500
		z	999
	}

	variable libcount 0
	variable tclcount 0
	variable tbccount 0

	variable errors ""

	variable packages
	variable loading_index 0

	variable use_conf_file 1
	variable conf_file "$basedir/conf/start-tcl.conf"

	# default configuration variables
	variable SKIP_DUPES 0
	variable SCRIPTS_DIR "$basedir/tcl"
}


#
# 	namespace eval ::WoWEmu
# 	namespace eval ::WoWEmu::Commands
# 	namespace eval ::AI
# 	namespace eval ::SpellEffects
#
# TCL API namespaces initialization
#
namespace eval ::WoWEmu {}
namespace eval ::WoWEmu::Commands {}
namespace eval ::AI {}
namespace eval ::SpellEffects {}
proc ProfRank {npc player spell rank prof} {
	switch $prof {
		164 { set flag1 "blacksm" }
		165 { set flag1 "leather" }
		171 { set flag1 "alchemy" }
		182 { set flag1 "herbalism" }
		186 { set flag1 "mining" }
		197 { set flag1 "tailor" }
		202 { set flag1 "engineer" }
		333 { set flag1 "enchant" }
		393 { set flag1 "skinning" }
		129 { set flag1 "firstaid" }
		185 { set flag1 "cooking" } 
		default {set flag1 "nothing" } }
	
	set race [GetRace $player]
	set sk [GetSkill $player $prof]
	if {($prof == 182) && ($race == 6)} {set bonus 15} else { set bonus 0}
	if {($prof == 202) && ($race == 7)} {set bonus2 15} else { set bonus2 0}
	
	if {$rank==1} { if {[GetQFlag $player $flag1] == 0} {
if {([GetQFlag $player prof1] == 0) || ([GetQFlag $player prof2] == 0) || ([GetQFlag $player prof3] == 0) || ([GetQFlag $player prof4] == 0) || ([GetQFlag $player prof5] == 0) || ([GetQFlag $player prof6] == 0) || ([GetQFlag $player prof7] == 0) || ([GetQFlag $player prof8] == 0) || ([GetQFlag $player prof9] == 0) || ([GetQFlag $player prof10] == 0) || ([GetQFlag $player prof11] == 0) || ([GetQFlag $player prof12] == 0) || ([GetQFlag $player prof13] == 0) || ($prof==129) || ($prof==185)} {
					LearnSpell $player $spell
					SetQFlag $player $flag1
					SetQFlag $player "ProfAp$prof"
					if {$sk < 2} { set sk 1}
					SetSkill $player $prof [expr {1+$bonus+$bonus2}] 75
    if {($prof!=129) && ($prof!=185)} {
        if {[GetQFlag $player prof1] == 0} {SetQFlag $player prof1
                } elseif {[GetQFlag $player prof2] == 0} { SetQFlag $player prof2
                } elseif {[GetQFlag $player prof3] == 0} { SetQFlag $player prof3
                } elseif {[GetQFlag $player prof4] == 0} { SetQFlag $player prof4
                } elseif {[GetQFlag $player prof5] == 0} { SetQFlag $player prof5
                } elseif {[GetQFlag $player prof6] == 0} { SetQFlag $player prof6
                } elseif {[GetQFlag $player prof7] == 0} { SetQFlag $player prof7
                } elseif {[GetQFlag $player prof8] == 0} { SetQFlag $player prof8
                } elseif {[GetQFlag $player prof9] == 0} { SetQFlag $player prof9
                } elseif {[GetQFlag $player prof10] == 0} { SetQFlag $player prof10
                } elseif {[GetQFlag $player prof11] == 0} { SetQFlag $player prof11
                } elseif {[GetQFlag $player prof12] == 0} { SetQFlag $player prof12
                } elseif {[GetQFlag $player prof13] == 0} { SetQFlag $player prof13
                    } elseif {[GetQFlag $player prof1] == 14} { SetQFlag $player prof14} }
					Say $npc 0 "Congratulations! You are now an apprentice!"
				} else { Say $npc 0 "You already know max professions, so i cant't teach you"
					 ChangeMoney $player 500
					 SetSkill $player $prof 0 0 }
			} else { Say $npc 0 "You already know this profession" 
				ChangeMoney $player 500 
				SetSkill $player $prof 0 0 }
	} elseif { $rank==2} { if {([GetQFlag $player $flag1] == 1) && ([GetQFlag $player "ProfAp$prof"] == 1) && ([GetQFlag $player "ProfJo$prof"] == 0) && ($sk > 49)} {
					LearnSpell $player $spell
					SetQFlag $player "ProfJo$prof"
					SetSkill $player $prof $sk 150
				} else { Say $npc 0 "You must have 50 skill before i can teach you"
					 ChangeMoney $player 2000 }
	} elseif { $rank==3} { if {([GetQFlag $player $flag1] == 1) && ([GetQFlag $player "ProfJo$prof"] == 1) && ([GetQFlag $player "ProfEx$prof"] == 0) && ($sk > 124)} {
					LearnSpell $player $spell
					SetQFlag $player "ProfEx$prof"
					SetSkill $player $prof $sk 225
				} else { Say $npc 0 "You must have 125 skill before i can teach you"
					 ChangeMoney $player 5000 }						
	} elseif { $rank==4} { if {([GetQFlag $player $flag1] == 1) && ([GetQFlag $player "ProfEx$prof"] == 1) && ([GetQFlag $player "ProfAr$prof"] == 0) && ($sk > 199)} {
					LearnSpell $player $spell
					SetQFlag $player "ProfAr$prof"
					SetSkill $player $prof $sk 300
				} else { Say $npc 0 "You must have 200 skill before i can teach you"
					 ChangeMoney $player 50000 } } }
					 


proc GatherSkill { player obj skill } {
if {[GetQFlag $obj "gathered"] == 0} {
    SetQFlag $obj "gathered"
    set gobj_id [GetEntry $obj]
    set sreq [GetScpValue "gameobjects.scp" "gameobj $gobj_id" "sreq"]
    if { $sreq == "{}" } { set sreq 300 }
    set sk [GetSkill $player $skill]
    set race [GetRace $player]
    if {($skill == 182) && ($race == 6)} {set bonus 15
    } else { set bonus 0 }
        set Dice [expr {rand()*100}]
        if { $sk < $sreq+25 } { set chance 100
        } elseif { $sk < $sreq+50 } { set chance 66
        } elseif { $sk < $sreq+100 } { set chance 33
        } else { set chance 0 }
        if {$chance > $Dice} {
            set sw [expr {$sk-$bonus}]
            if {$sw < 1} {set sw 1}  
            if {[GetQFlag $player "ProfAp$skill"] == 0} { if {$sk < 300} {incr sk} }     
            switch $sw {
                75 { if {[GetQFlag $player "ProfJo$skill"] == 1} {incr sk} }
                150 { if {[GetQFlag $player "ProfEx$skill"] == 1} {incr sk} }
                225 { if {[GetQFlag $player "ProfAr$skill"] == 1} {incr sk} }
                default { if {$sk < 300+$bonus} { incr sk } } }
            SetSkill $player $skill $sk 0 }
        set loottemplate [GetScpValue "gameobjects.scp" "gameobj $gobj_id" "loottemplate"]
        if { $loottemplate != "{}" } { Loot $player $obj $loottemplate 2 }
    
    }
}


proc ProfSkill {player skill dif1 dif2 dif3 item number maxextra} {
  set sk [GetSkill $player $skill]
  set Dice [expr {rand()*100 }]
  set race [GetRace $player]
  if {($skill == 202) && ($race == 7)} {set bonus 15
	} else { set bonus 0 }
  if { $sk < $dif1 } { set chance 100
    } elseif { $sk < $dif2 } { set chance 66
    } elseif { $sk < $dif3 } { set chance 33
    } else { set chance 0 }
  if {$chance > $Dice} {
	set sw [expr {$sk-$bonus}]
	if {$sw < 1} {set sw 1}
         if {[GetQFlag $player "ProfAp$skill"] == 0} { if {$sk < 300} {incr sk} }
          if {($skill==129) || ($skill==185)} { if {$sk < 300} { if {([GetQFlag $player "ProfJo$skill"] == 1) && ([GetQFlag $player "ProfEx$skill"] == 0)  } { incr sk } }
         
         
    } else {
   
	switch $sw {
		75 { if {[GetQFlag $player "ProfJo$skill"] == 1} {incr sk} }
		150 { if {[GetQFlag $player "ProfEx$skill"] == 1} {incr sk} }
		225 { if {[GetQFlag $player "ProfAr$skill"] == 1} {incr sk} }
		default { if {$sk < 300+$bonus} { incr sk } } } }
	SetSkill $player $skill $sk 0 }
  set n [expr $number+floor(rand()*($maxextra+1))]
  for {set x 0} {$x<$n} {incr x} { AddItem $player $item } }



proc addleather { player lvl nr} {
set Dice [expr {rand()*10}]
set Dice2 [expr {rand()*6}]
if { $lvl > 59 } {	set dif 0
			set item1 8171 
			set item2 8171
			set item3 8170
			set item4 8170
} elseif { $lvl > 51 } {
			set dif [expr {$lvl-56}]
			set item1 17012 
			set item2 8171
			set item3 15419 
			set item4 8170
} elseif { $lvl > 41 } {
			set dif [expr {$lvl-46}]
			set item1 8171 
			set item2 8169
			set item3 8170 
			set item4 4304
} elseif { $lvl > 31 } {
			set dif [expr {$lvl-36}]
			set item1 8169 
			set item2 4235
			set item3 4304 
			set item4 4234
} elseif { $lvl > 21 } {
			set dif [expr {$lvl-26}]
		 	set item1 4235 
			set item2 4232
			set item3 4234 
			set item4 2319
} elseif { $lvl > 11 } {
			set dif [expr {$lvl-16}] 
			set item1 4232 
			set item2 783
			set item3 2319 
			set item4 2318
} else {
			set dif [expr {$lvl-6}] 
			set item1 783 
			set item2 2318
			set item3 2934
			set item4 2934 } 
for {set x 0} {$x<$nr} {incr x} { set Dice [expr {rand()*6}]
				set Dice2 [expr {rand()*6}]
				if {$Dice2 > 5} { if {$Dice < $dif} { AddItem $player $item1
						} else { AddItem $player $item2 }
				} elseif { $Dice < $dif } { AddItem $player $item3
				} else { AddItem $player $item4 } }				
}


proc skinleather { player sk lvl req} {
set nr [expr {($sk-$req)/25+1}]
if {$nr > 4} {set nr 4}
addleather $player $lvl $nr
if { $sk < $req+25 } { set chance 100
    } elseif { $sk < $req+50 } { set chance 66
    } elseif { $sk < $req+100 } { set chance 33
    } else { set chance 0 }
set Dice [expr {rand()*100}]
if {$chance > $Dice} {
        
if {[GetQFlag $player "ProfAp393"] == 0} { if {$sk < 300} {incr sk} }
            
	switch $sk {
		75 { if {[GetQFlag $player "ProfJo393"] == 1} {incr sk} }
		150 { if {[GetQFlag $player "ProfEx393"] == 1} {incr sk} }
		225 { if {[GetQFlag $player "ProfAr393"] == 1} {incr sk} }
		default { if {$sk < 300} { incr sk } } }
	SetSkill $player 393 $sk 0 } }
	

proc skinspecial {player sk item1 item2 moblvl reqlvl chance req} {
set Dice [expr {rand()*10}]
set nr [expr {($sk-$req)/25+1}]
if {$nr > 4} {set nr 4}
if {($moblvl < $reqlvl) || ($Dice > $chance)} {addleather $player $moblvl $nr
} else {
	for { set x 0 } { $x < $nr } { incr x } { 
		set Dice [expr {rand()*10}]
		if {$Dice > 8} { AddItem $player $item2 
		} else { AddItem $player $item1 } }
	if { $sk < $req+25 } { set chance 100
	    } elseif { $sk < [expr {$req+50}] } { set chance 66
	    } elseif { $sk < [expr {$req+100}] } { set chance 33
	    } else { set chance 0 }
	set Dice [expr {rand()*100}]
	if {$chance > $Dice} {


                if {[GetQFlag $player "ProfAp393"] == 0} { if {$sk < 300} {incr sk} }
            
		switch $sk {
			75 { if {[GetQFlag $player "ProfJo393"] == 1} {incr sk} }
			150 { if {[GetQFlag $player "ProfEx393"] == 1} {incr sk} }
			225 { if {[GetQFlag $player "ProfAr393"] == 1} {incr sk} }
			default { if {$sk < 300} { incr sk } } }
		SetSkill $player 393 $sk 0 } }
}


proc skinning {player mob} {
	set id [GetEntry $mob]
	set lvl [GetLevel $mob]
	set sk [GetSkill $player 393]
	if {$lvl < 10} {set req 1
		} elseif {$lvl<20} {set req [expr {($lvl-10)*10}]
		} else { set req [expr {$lvl*5}]}
	if {$req > 300} { set req 300}
	if { $sk < $req } { Say $player 0 "My skill is too low. I need $req" 
	} else {
		set type [GetObjectType $mob]
		set flag [GetQFlag $mob skinnable]
		set hp [GetHealthPCT $mob]
		if { ($type == 3) && ($flag == 00) && ($hp == 0)} {
			SetFaction $mob 35
			SetQFlag $mob skinnable
			set type [GetCreatureType $mob]
			if { $type == 1 } {
				set type [GetScpValue "creatures.scp" "creature $id" "family"]
				switch $type {
					4  { skinspecial $player $sk 15419 15419 $lvl 52 2 $req}
					21 { skinspecial $player $sk 8167 8167 $lvl 30 3 $req}
					20 { if {$lvl < 49} { skinspecial $player $sk 8154 15408 $lvl 35 3 $req
						} else { skinspecial $player $sk 15408 8154 $lvl 49 3 $req} }
					26 { skinspecial $player $sk 15420 15420 $lvl 45 10 $req}
					default { if {($id > 3629) && ($id < 3638)} { skinspecial $player $sk 6470 6471 $lvl 0 3 $req
						} elseif {($id > 7429) && ($id < 7435)} { skinspecial $player $sk 15422 15422 $lvl 45 2 $req
						} elseif {($id > 6497) && ($id < 6501)} { skinspecial $player $sk 15417 15417 $lvl 45 2 $req
						} elseif {$id == 16030} { AddItem $player 30004
						} else { skinleather $player $sk $lvl $req } } }
			} elseif {$type == 2} {	
				if {(($id > 7434) && ($id < 7438)) || (($id > 10658) && ($id < 10665)) || (($id > 6128) && ($id < 6132))} {
					skinspecial $player $sk 15415 8165 $lvl 40 4 $req
				} elseif { (($id > 10362) && ($id < 10373)) || (($id > 12459) && ($id < 12469)) || (($id > 7039) && ($id < 7050))} {
					skinspecial $player $sk 15416 8165 $lvl 40 4 $req
				} elseif { (($id > 5276) && ($id < 5284)) || (($id > 5718) && ($id < 5723)) || (($id > 12473) && ($id < 12480)) || (($id > 741) && ($id < 747))} {
					skinspecial $player $sk 15412 8165 $lvl 40 4 $req
				} elseif {($id > 1044) && ($id < 1051)} {
					skinspecial $player $sk 15414 8165 $lvl 40 4 $req
				} elseif {($id > 10441) && ($id < 10448)} {
					skinspecial $player $sk 12607 8165 $lvl 40 4 $req
				} else {switch $id {
				740 { skinspecial $player $sk 7392 7392 $lvl 0 4 $req}	
				741 { skinspecial $player $sk 7392 7392 $lvl 0 4 $req}
				441 { skinspecial $player $sk 7286 7286 $lvl 0 4 $req}  
				1042 { skinspecial $player $sk 7287 7287 $lvl 0 4 $req}
				1069 { skinspecial $player $sk 7287 7287 $lvl 0 4 $req}
				1044 { skinspecial $player $sk 7287 7287 $lvl 0 4 $req}
				10814 { skinspecial $player $sk 12607 8165 $lvl 40 5 $req}
				14020 { skinspecial $player $sk 12607 8165 $lvl 40 5 $req}
				default { if {$lvl > 44} { skinspecial $player $sk 8165 8165 $lvl 40 4 $req
						} else { skinleather $player $sk $lvl $req} } } }
			} else { Say $player 0 "I can't skin that" }
		} else { Say $player 0 "I can't skin that" } 
  } 
}

proc AddEnchItem {player item1 q1 item2 item3} {
    set Dice [expr {rand()*$q1}]
    for {set x 1} {$x<$Dice} {incr x} { AddItem $player $item1 }
    AddItem $player $item1
    if {$item2 > 0} { set Dice [expr {rand()*4}]
               if {$Dice < 1} { AddItem $player $item2 } }
    set Dice [expr {rand()*10}]
    if {$Dice < 1} { AddItem $player $item3 }
}

# ATTENZIONE
# Per un corretto funzionamento del disenchanting necessario:
#
# 1) Aggiungere questa linea: 
# "13262 { disenchant $from $to }"
# prima della linea:
# "default { puts "Can't find teleport for spellid=$spellid" }"
# Nel file "SpellEffects_Teleport.tcl" della cartella scripts\tcl\api.
#
# 2) Patchare il file "spell.dbc" lato server con questa patch: 
# "13262:58=5,59=0"
#

proc disenchant {player item} {
    if {[GetObjectType $item]==1} {
        set id [GetEntry $item]
        set ItemLvl [GetScpValue "items.scp" "gameobj $id" "reqlevel"]
        if {$ItemLvl == "{}"} { set ItemLvl [GetScpValue "items.scp" "gameobj $id" "level"]}
        if {$ItemLvl < 10} {set sreq 1
            } elseif {$ItemLvl<20} {set sreq [expr {($ItemLvl-10)*10}]
            } else { set sreq [expr {$ItemLvl*5}]}
        if {$sreq > 300} { set sreq 300}
        set ItemLvl [expr {($ItemLvl-6)/5}]
        if {$ItemLvl > 9} {set ItemLvl 9}
        if {$ItemLvl < 0} {set ItemLvl 0}
        set sk [GetSkill $player 333]
        set type [GetScpValue "items.scp" "gameobj $id" "class"]
        set quality [GetScpValue "items.scp" "gameobj $id" "quality"]
        if {$quality == "{}"} { set quality 0}
        if {$sreq > $sk} {Say $player 0 "Per disincantare quest'oggetto ho bisogno di una skill pari o superiore a $sreq."
                  return 0}
        if {($type > 1) && ($type < 5) && ($quality > 1)} {
            set t [ConsumeItem $player $id 1]
            if {$t==1} {
                if {$quality==2 && $type==2} { incr ItemLvl 10 
                } elseif {$quality == 3} {incr ItemLvl 20 
                } elseif {$quality > 3} {incr ItemLvl 30}
                ConsumeItem $player $id
                switch $ItemLvl {
                    0 { AddEnchItem $player 10940 4 10938 10978 }
                    1 { AddEnchItem $player 10940 4 10939 10978 }
                    2 { AddEnchItem $player 10940 4 10998 10978 }
                    3 { AddEnchItem $player 11083 4 11082 11084 }
                    4 { AddEnchItem $player 11083 4 11134 11138 }
                    5 { AddEnchItem $player 11137 4 11135 11139 }
                    6 { AddEnchItem $player 11137 4 11174 11177 }
                    7 { AddEnchItem $player 11176 4 11175 11178 }
                    8 { AddEnchItem $player 11176 4 16202 14343 }
                    9 { AddEnchItem $player 16204 4 16203 14344 }
                    10 { AddEnchItem $player 10938 4 10940 10978 }
                    11 { AddEnchItem $player 10939 4 10940 10978 }
                    12 { AddEnchItem $player 10998 4 10940 10978 }
                    13 { AddEnchItem $player 11082 4 11083 11084 }
                    14 { AddEnchItem $player 11134 4 11083 11138 }
                    15 { AddEnchItem $player 11135 4 11137 11139 }
                    16 { AddEnchItem $player 11174 4 11137 11177 }
                    17 { AddEnchItem $player 11175 4 11176 11178 }
                    18 { AddEnchItem $player 16202 4 11176 14343 }
                    19 { AddEnchItem $player 16203 4 16204 14344 }
                    20 { AddEnchItem $player 10978 1 0 10978 }
                    21 { AddEnchItem $player 10978 1 0 10978 }
                    22 { AddEnchItem $player 10978 1 0 10978 }
                    23 { AddEnchItem $player 11084 1 0 11084 }
                    24 { AddEnchItem $player 11138 1 0 11138 }
                    25 { AddEnchItem $player 11139 1 0 11139 }
                    26 { AddEnchItem $player 11177 1 0 11177 }
                    27 { AddEnchItem $player 11178 1 0 11178 }
                    28 { AddEnchItem $player 14343 1 0 14343 }
                    29 { AddEnchItem $player 14344 1 0 14344 }
                    30 { AddEnchItem $player 10978 2 0 10978 }
                    31 { AddEnchItem $player 10978 2 0 10978 }
                    32 { AddEnchItem $player 10978 2 0 11084 }
                    33 { AddEnchItem $player 11084 2 0 11138}
                    34 { AddEnchItem $player 11138 2 0 11139 }
                    35 { AddEnchItem $player 11139 2 0 11177 }
                    36 { AddEnchItem $player 11177 2 0 11178 }
                    37 { AddEnchItem $player 11178 2 0 14343 }
                    38 { AddEnchItem $player 14343 2 0 14344 }
                    39 { AddEnchItem $player 14344 2 0 14344 }
                    }
                set Dice [expr {rand()*100}]
                if { $sk < $sreq+25 } { set chance 100
                    } elseif { $sk < $sreq+50 } { set chance 66
                    } elseif { $sk < $sreq+100 } { set chance 33
                    } else { set chance 0 }
                if {$chance > $Dice} {
                    if {[GetQFlag $player "ProfAp333"] == 0} { if {$sk < 300} {incr sk} }
            
                    switch $sk {
                        75 { if {[GetQFlag $player "ProfJo333"] == 1} {incr sk} }
                        150 { if {[GetQFlag $player "ProfEx333"] == 1} {incr sk} }
                        225 { if {[GetQFlag $player "ProfAr333"] == 1} {incr sk} }
                        default { if {$sk < 300} { incr sk } } }
                SetSkill $player 333 $sk 0 }
            }
        } 
           }
        } 

#
#	namespace eval ::Custom
#
# Custom namespace initialization
#
namespace eval ::Custom {}


#
#	Default configuration variables
#

#
# for the WoWEmu namespace
#
namespace eval ::WoWEmu {
	variable XP_RATES { 1.0 2.0 2.5 3.0 1.5 }
	variable MAX_LEVEL 60
	variable MAX_DISTANCE 75
	variable CHECK_GREY_LEVEL 1
	variable HIGH_LEVEL_DIFF 4
	variable MOB_LOG { 2 3 }
	variable MAX_DAMAGE_REDUCTION 0.75
	variable ALLOW_RESURRECT_PLAYERS 1
	variable ALLOW_PLAYER_DISMOUNT 0
	variable BROADCAST_WITH_NAME 1
	variable LOG_GM 1
}

#
# for the AI namespace
#
namespace eval ::AI {
	variable SPELLDATA_FILE "scripts/spelldata.txt"
	variable AGGRO_DIST 20
	variable MIN_AGGRO_DIST 5
	variable MAX_AGGRO_DIST 30
	variable NOAGGRO_LEVELDIFF {}
	variable UNAGGRO_DIST 75
	variable MELEE_CAST_METHOD 1
	variable MELEE_CAST_RATE 0.05
	variable CAST_TIME_SENSIVITY 5
	variable HUMANOID_SAY 1
}


#
#	proc ::StartTCL::SortFolders { list }
#
# procedure to order a list of folders according to StartTCL rules.
#
proc ::StartTCL::SortFolders { list } {
	return [ lsort -dictionary -increasing $list ]
}


#
#	proc ::StartTCL::SortFiles { list }
#
# procedure to order a list of files according to StartTCL rules.
#
proc ::StartTCL::SortFiles { list } {
	variable levels
	set result {}

	foreach file $list {
		set handle [ open $file ]
		set level "n"
		set pair {}

		while { ! [ eof $handle ] } {
			if { ! [ gets $handle line ] } {
				continue
			}

			set line [ string trim $line ]

			if { [ string length $line ] && [ expr { ! ( ! [ string first "#" $line ] ) } ] } {
				break
			}

			set line [ string trim [ string trim [ string trim [ string trim $line \# ] ] \# ] ]

			if { [ regexp -nocase {start-?tcl *:} $line ] } {
				set level [ string tolower [ string trim [ lindex [ split $line : ] 1 ] ] ]
				break
			}
		}

		close $handle

		if { [ string length $level ] == 3 && [ string is digit $level ] } {
		} elseif { ! ( ! [ llength [ array names levels $level ] ] ) } {
			set level $levels($level)
		} else {
			set level $levels(n)
		}

		lappend pair $level $file
		lappend result $pair
	}

	set result [ lsort -dictionary -increasing -index 1 $result ]

	for { set i 1 } { $i < [ llength $result ] } { incr i } {
		if { ! [ string compare -nocase [ file rootname [ lindex $result [ expr { $i - 1 } ] 1 ] ] [ file rootname [ lindex $result $i 1 ] ] ] } {
			if { $::StartTCL::SKIP_DUPES } {
				set result [ lreplace $result $i $i ]
				incr i -1
			} else {
				if { $::VERBOSE } {
					puts "[ ::Custom::LogPrefix ]WARNING!\n[ ::Custom::LogPrefix ]WARNING! Found \[[ lindex $result [ expr { $i - 1 } ] 1 ]\] and \[[ lindex $result $i 1 ]\],\n[ ::Custom::LogPrefix ]WARNING! this may indicate a duplicate script and render unexpected errors!\n[ ::Custom::LogPrefix ]WARNING!"
				}
			}
		}
	}

	set list {}

	foreach pair [ lsort -dictionary -increasing -index 0 $result ] {
		foreach { order file } $pair {
			lappend list $file
		}
	}

	unset result
	return $list
}


#
#	proc ::StartTCL::Provide { name args }
#
# procedure to simulate the provide facility of the package command
#
proc ::StartTCL::Provide { args } {
	variable packages

	if { $args == "" } {
		set name [ namespace tail [ uplevel namespace current ] ]
		if { $name != "" } {
			if { [ info exists ::${name}::VERSION ] } {
				set version [ set ::${name}::VERSION ]
			} else {
				set version 0
			}
			return [ set packages($name) $version ]
		}
	}

	foreach { name version } [ join $args ] {
		if { $name == "" } {
			continue
		}

		if { $version == "" } {
			set version 0
		}

		set packages($name) $version
	}
}


#
#	proc ::StartTCL::Require { name args }
#
# procedure to simulate the require facility of the package command
#
proc ::StartTCL::Require { args } {
	variable packages

	if { ! [ string first [ lindex $args 0 ] "-exact" ] } {
		set exact 1
		set args [ lrange $args 1 end ]
	} else {
		set exact 0
	}

	set filename [ info script ]

	foreach { name version } [ join $args ] {
		if { $name == "" } {
			continue
		}

		if { $version == "" } {
			set version 0
		}

		if { [ info exists packages($name) ] } {
			if { $exact && $packages($name) != $version || $packages($name) < $version } {
				return -code 1 "$name v$version required but got v$packages($name)."
			}

			continue
		}

		if { $::VERBOSE && $::DEBUG } {
			puts "[ ::Custom::LogPrefix ]\[[ info script ]\] (loading delayed)"
		}

		::StartTCL::LoadScripts $name $version

		info script $filename

		if { [ info exists packages($name) ] } {
			if { $exact && $packages($name) != $version || $packages($name) < $version } {
				return -code 1 "$name v$version required but got v$packages($name)."
			}

			continue
		}

		return -code 1 "$name v$version required but it could not be found."
	}

	return -code 0
}


#
#	proc ::StartTCL::LoadScripts { name version }
#
# procedure to load the scripts (Script files processing)
#
proc ::StartTCL::LoadScripts { {name ""} {version 0} } {
	variable packages
	variable scripts
	variable loading_index

	while { $loading_index < [ llength $scripts ] } {
		set current_index $loading_index
		set script [ lindex $scripts $current_index ]
		incr loading_index

		if { $::DEBUG } {
			uplevel "#0" ::Custom::Source \{$script\}

			if { ! [ string compare -nocase [ file extension $script ] ".tcl" ] } {
				incr ::StartTCL::tclcount
			} else {
				incr ::StartTCL::tbccount
			}

			if { $::VERBOSE } {
				puts "[ ::Custom::LogPrefix ]\[$script\] loaded"
			}

			if { $name != "" } {
				if { [ info exists packages($name) ] } {
					if { $packages($name) < $version } { return -code 1 "$name v$version required but got v$packages($name)" }
					return -code 0
				}
			}
		} else {
			if { [ catch { uplevel "#0" ::Custom::Source \{$script\} } ] } {
				if { $::VERBOSE } {
					puts "[ ::Custom::LogPrefix ]\[$script\] *** LOADING FAILED ***"
				}

				append ::StartTCL::errors "\n[ ::Custom::LogPrefix ]Failed to load the script \[$script\]: $::errorInfo"
			} else {
				if { ! [ string compare -nocase [ file extension $script ] ".tcl" ] } {
					incr ::StartTCL::tclcount
				} else {
					incr ::StartTCL::tbccount
				}

				if { $::VERBOSE } {
					puts "[ ::Custom::LogPrefix ]\[$script\] loaded"
				}

				if { $name != "" } {
					if { [ info exists packages($name) ] } {
						if { $packages($name) < $version } { return -code 1 "$name v$version required but got v$packages($name)" }
						return -code 0
					}
				}
			}
		}
	}

	return -code 0
}


#
# Early definitions of some Custom procedures
#

#
#	proc ::Custom::ReadConf { file }
#
# procedure to read a given configuration file and return a list of list with
# the format {section {key value}}.
#
proc ::Custom::ReadConf { file } {
	if { ! [ file exists $file ] } {
		return
	}

	set conf {}
	set section {}
	set data {}
	set hconfig [ open $file ]

	while { [ gets $hconfig line ] >= 0 } {
		set line [ ::Custom::DropNoise $line ]

		if { [ string index $line 0 ] == "\[" } {
			if { [ llength $data ] } {
				lappend conf $section $data
			}

			set data {}
			set section [ lindex [ split $line {[]} ] 1 ]
		} else {
			set line [ split $line "=" ]
			set key [ string trim [ lindex $line 0 ] ]
			if { [ string is false $key ] } {
				continue
			}

			set value [ string trim [ lindex $line 1 ] ]

			if { [ string index $value 0 ] == "\"" } {
				set value [ string trim [ lindex [ split $value "\"" ] 1 ] ]
			}

			lappend data $key $value
		}
	}

	close $hconfig

	if { [ llength $data ] } {
		lappend conf $section $data
	}

	return $conf
}


#
#	proc ::Custom::DropNoise { string { comment_tags {\# //} } }
#
# procedure to discard comment chars and white space from a given string.
#
proc ::Custom::DropNoise { string { comment_tags {\# //} } } {
	foreach tag $comment_tags {
		set pos [ string first $tag $string ]

		if { $pos >= 0 } {
			set string [ string range $string 0 [ expr { $pos - 1 } ] ]
		}
	}

	return [ string trim $string ]
}


#
#	proc ::Custom::LogPrefix { }
#
# procedure to return a standard WoWEmu console prefix entry.
#
proc ::Custom::LogPrefix { } {
	return "[ clock format [ clock seconds ] -format %k:%M:%S ]:M:"
}


#
#	proc ::StartTCL::LogPrefix { }
#
# procedure to load TCL files encoded in UTF-8 with BOM
#
proc ::Custom::Source { filename } {
	info script $filename

	set handle [ open $filename ]
	set data [ read $handle ]
	close $handle

	if { ! [ string is ascii [ string index $data 0 ] ] } {
		uplevel eval \{[ string range $data 1 end ]\}
	} else {
		uplevel eval \{$data\}
	}
}


namespace eval ::StartTCL {
	#
	# Loading variables from configuration file
	#
	if { $::StartTCL::use_conf_file } {
		foreach { section data } [ ::Custom::ReadConf $::StartTCL::conf_file ] {
			if { [ string match -nocase $section "Global" ] } {
				set section ::
			} else {
				foreach ns [ namespace children :: ] {
					if { [ string tolower $ns ] == [ string tolower "::$section" ] } {
						set section $ns
						unset ns
						break
					}
				}
			}

			if { ! [ namespace exists $section ] } { continue }

			foreach { key value } $data {
				set ${section}::[ string toupper $key ] $value
			}
		}
	}
}

#
# Header
#
if { $::VERBOSE } {
	puts "[ ::Custom::LogPrefix ]\n[ ::Custom::LogPrefix ]\t$::StartTCL::HEADER\n[ ::Custom::LogPrefix ]"
}


#
# Helper libraries (DLLs)
#
if { $::VERBOSE } {
	puts "[ ::Custom::LogPrefix ]Loading helper libraries (DLLs)"
}

foreach dir [ ::StartTCL::SortFolders [ glob -nocomplain -type d lib/* ] ] {
	if { $::VERBOSE } {
		puts "[ ::Custom::LogPrefix ]Processing folder \[$dir\]"
	}

	if { $::DEBUG } {
		source $dir/pkgIndex.tcl
		incr ::StartTCL::libcount
	} else {
		if { [ catch { source $dir/pkgIndex.tcl } ] } {
			append ::StartTCL::errors "\n[ ::Custom::LogPrefix ] Failed to process the loader script in \[$dir\]: $errorInfo"
		} else {
			incr ::StartTCL::libcount
		}
	}
}


#
# Second level scripts
#
if { $::VERBOSE } {
	puts "[ ::Custom::LogPrefix ]Loading second level scripts"
}


#
# Script files acquiring
#
lappend ::StartTCL::scriptdirs $::StartTCL::SCRIPTS_DIR

foreach dir [ glob -nocomplain -type d $::StartTCL::SCRIPTS_DIR/* ] {
	lappend ::StartTCL::scriptdirs $dir
}

foreach dir $::StartTCL::scriptdirs {
	foreach script [ glob -nocomplain "$dir/*.tcl" "$dir/*.tbc" ] {
		lappend ::StartTCL::scripts $script
	}
}


#
# Provide StartTCL
#
::StartTCL::Provide $::StartTCL::NAME $::StartTCL::VERSION


#
# Script files processing
#
set ::StartTCL::scripts [ ::StartTCL::SortFiles $::StartTCL::scripts ]
::StartTCL::LoadScripts


#
# Done
#
if { $::StartTCL::errors != "" } {
	return "ERROR(S): $::StartTCL::errors"
} else {
	if { $::VERBOSE } {
		return "Startup sequence done.\n[ ::Custom::LogPrefix ]\n[ ::Custom::LogPrefix ]Loaded:\n[ ::Custom::LogPrefix ]\t$::StartTCL::libcount helper libraries\n[ ::Custom::LogPrefix ]\t$::StartTCL::tclcount TCL scripts\n[ ::Custom::LogPrefix ]\t$::StartTCL::tbccount pre-compiled (TBC) scripts\n[ ::Custom::LogPrefix ]"
	} else {
		return "Startup sequence done (TCL count: $::StartTCL::tclcount, TBC count: $::StartTCL::tbccount)."
	}
}

