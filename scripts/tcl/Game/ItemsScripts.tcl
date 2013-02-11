#HW2 fix for   enchanted items Control


#define INVTYPE_CHEST                       5
#define INVTYPE_FEET                        8
#define INVTYPE_WRIST                        9
#define INVTYPE_HAND                        10
#define INVTYPE_SHIELD                    14
#define INVTYPE_CLOAK                        16
#define INVTYPE_2HWEAPON                    17
#define INVTYPE_ROBE                        20
#define INVTYPE_WEAPONMAINHAND            21
#define INVTYPE_WEAPONOFFHAND            22        

namespace eval ::Enchanting {
variable enchants
array set enchants {
13931 9
20008 9
13846 9
13945 9
23802 9
13646 9
7859 9
13501 9
13536 9
23801 9
7428 9
7766 9
7782 9
13661 9
20009 9
20011 9
20010 9
13939 9
13822 9
13622 9
7779 9
7418 9
7457 9
13642 9
13648 9
25086 16
13746 16
25081 16
25082 16
20014 16
13882 16
13522 16
13419 16
13794 16
25083 16
25084 16
20015 16
13635 16
13657 16
7861 16
13421 16
7771 16
7454 16
20025 20
7776 20
20026 20
20028 20
7443 20
13941 20
13640 20
13663 20
7857 20
13538 20
7748 20
13700 20
13607 20
7426 20
7420 20  
13626 20
13858 20
13917 20
13868 10
13841 10
25078 10
13620 10
25074 10
20012 10
20013 10
25079 10
13617 10
13612 10
13948 10
13947 10
25073 10
13698 10
25080 10
25072 10
13815 10
13887 10
13935 8
20023 8
20020 8
13687 8
7867 8
13890 8
20024 8
13637 8
13644 8
7863 8
13836 8
22750 21
22749 21
23800 21
20034 21
13915 21
13898 21
20029 21
13653 21
13655 21
20032 21
23804 21
23803 21
7786 21
23799 21
20031 21
20033 21
21931 21
13943 21
13503 21
7788 21
13693 21
27837 17
13937 17
7793 17
13380 17
20036 17
20035 17
20030 17
13695 17
13529 17
7745 17
13933 14
13905 14
20017 14
13689 14
13464 14
13817 14
20016 14
13485 14
13631 14
13378 14
13659 14
}


 proc ::Enchanting::OnEnchant { from to spellid } {
        variable enchants
          # $from == $to happens when trying to enchant item in trade window
          # anyone has a solution how to enchant others' items except creating new items like frost oil by enchanters?
        if { ($from != $to) } { 
            set name [GetName $from]
            set itemid [GetEntry $to]
            set item_entry [GetEntry $to]
            
            set inventorytype [GetScpValue "items.scp" "item $itemid" "inventorytype"]

# la riga sottostante serve in quanto le chest non vengono considerate, e non sono presenti le two hands nelle formula weapon
if { ($enchants($spellid) == 20 && $inventorytype == 5) } { return }
if { ($enchants($spellid) == 21 && $inventorytype == 17) } { return }
 
# fine   
            if { ! ( ($enchants($spellid) == $inventorytype) || ($enchants($spellid) == 21 && $inventorytype == 22) ) } { 
                set file "logs/enchanting.txt"
                set time [clock format [clock seconds] -format "%Y-%m-%d %H:%M:%S"]
                set id [open $file a+]
                set itemname [GetScpValue "items.scp" "item $itemid" "name"]
                set enchantname [GetScpValue "spellcost.scp" "spell $spellid" "name"]
                puts $id "\[$time\] $name enchanted $itemname ($itemid) with $enchantname ($spellid)"
                close $id
                Say $from 0 "|c00FF0000 Ops, i've just enchanted the wrong item, it should be in my bag now... |r"

 Loot $from $to 34000 1
 AddItem $from $item_entry
 ::WoWEmu::Commands::refresh $from $from
            }
        }
    }
 }



		


# StartTCL: n

namespace eval ItemReqsCheck {
  variable honor_check_enabled 1
  variable side_check_enabled 0
  
  array set pvp_ranks {
    0 {Gromarschall Feldmarschall Marschall Rittmeister Feldkommandant\
       {Ritter der Allianz} Krassier Hauptmann Leutnant Fhnrich Feldwebel\
       Landsknecht Fuknecht Gefreiter {Grand Marshal} {Field Marshal} Marshal\
       Commander {Lieutenant Commander} {Knight Champion} {Knight Captain}\
       {Knight Lieutenant} Knight {Sergeant Major} {Master Sergeant} Sergeant\
       Corporal}
    
    1 {{Oberster Kriegsfrst} Kriegsfrst General Sturmreiter Feldherr\
       {Klinge der Horde} Zornbringer Blutgardist Steingardist Rottenmeister\
       Schlachtrufer Waffentrger Grunzer Spher {High Warlord} Warlord General\
       {Lieutenant General} Champion Centurion Legionnaire {Blood Guard}\
       {Stone Guard} {First Sergeant} {Senior Sergeant} Sergeant Grunt Scout}  
  }    
  
  set honor_check_enabled [expr {$honor_check_enabled &&
                 [info procs ::Honor::GetRank] != ""}]  
}

proc ItemReqsCheck::CheckItemReqs {item player} {
  set section "item [::GetEntry $item]"
  
  set qflags [join [GetScpValue items.scp $section qflags]]
  foreach qflag $qflags {
    if ![GetQFlag $player $qflag] {return "Non posso ancora usarlo!"}
  }
  
  set classes [join [GetScpValue items.scp $section classes]]
  if {[string index $classes 0] == "0"} {set classes "0x$classes"}
  if {$classes != "" && [string is integer $classes] && $classes &&
      !(int(pow(2,[GetClass $player]-1)) & $classes)} {
    return "La mia classe non puo' usare questo items!!"
  }

  set races [join [GetScpValue items.scp $section races]]
  if {[string index $races 0] == "0"} {set races "0x$races"}
  if {$races != "" && [string is integer $races] && $races &&
      !(int(pow(2,[GetRace $player]-1)) & $races)} {
    return "Questo non puo' essere usato dalla mia razza!!"
  }
  
  set skill [join [GetScpValue items.scp $section skill]]
  set skillrank [join [GetScpValue items.scp $section skillrank]]
  if {$skill != "" && [string is integer $skill] && $skill &&
      $skillrank != "" && [string is integer $skillrank] && $skillrank &&
      [GetSkill $player $skill] < $skillrank} {
    return "Le mie skill sono troppo basse per questo!!"
  }
  
  if $::ItemReqsCheck::honor_check_enabled {
    set pvprank [join [GetScpValue items.scp $section pvprankreq]]
    if {$pvprank == ""} {
      set pvprank [join [GetScpValue items.scp $section pvprank]]
    }
    if {![string is integer $pvprank]} {set pvprank ""}
  
    # note that the pvprankreq key is not identical with the ranks provided
    # bei spirit honor as there are 4 lower and 1 higher undocumented pvp ranks
    if {$pvprank != "" && $pvprank > [::Honor::GetRank $player] + 4} {
      return "Ho bisogno di un rank honor piu' alto per indossare questo item!"
    }  
  
    # check whether item belongs to same side
    if {$pvprank != "" && $::ItemReqsCheck::side_check_enabled} {
      set hostile_side [expr [lsearch "1 3 4 7" [GetRace $player]] > -1]
      set item_name [join [GetScpValue items.scp $section name]]
      foreach rank $::ItemReqsCheck::pvp_ranks($hostile_side) {
        if {[string first [lindex $rank end] $item_name] > -1} {
          return "Questo e' utilizzabile solo dai nostri nemici!"
        }
      }
    }
  }
  return ""
}
        
proc ItemReqsCheck::OnPutOn {item player spellid} {
     set plevel [ ::GetPlevel $player ]
     if { $plevel < 4 } { 
if {[set msg [CheckItemReqs $item $player]] != ""} {
  Say $player 0 $msg  
  set item_entry [GetEntry $item]
  Loot $player $item 34000 1
  ## ::CastSpell $player $player 7  -> to educate players istead refreshcommand (al posto del comando refresh) ^^
  # not that only bag slots will be used which were free before the item
  # was put on
  AddItem $player $item_entry
  ::WoWEmu::Commands::refresh $from $from
  }  
}

}

::Custom::AddSpellScript "::ItemReqsCheck::OnPutOn" 16722

puts "ItemReqsCheck 1.03 by smartwork loaded."



##########
#
# defined namespace
#

### Script Namespaces ###
namespace eval ::Trinkets {
	StartTCL::Provide
}

#
# namespace ::Trinkets
#
 proc ::Trinkets::SixDemonBag { to from } {	
	set spell_list "14642 15117 15534 21402 23102 23103 "
	set spellid [lindex $spell_list [expr {int(rand()*[llength $spell_list])}]]
	::CastSpell $from $to $spellid
 }

 proc ::Trinkets::PiccoloOfTheFlamingFire { to from } {
	::Emote $to 10
 }		



#
# Init Procedure
#
proc ::Trinkets::Init { } {
	if { [ info exists "::StartTCL::VERSION" ] } {
		::Custom::AddLegacySpellScript {
			14537 { ::Trinkets::SixDemonBag $to $from }
			17512 { ::Trinkets::PiccoloOfTheFlamingFire $to $from }
		}
	} else {
		# setup the system to deal with these spells as usual
	}
}

::Trinkets::Init

# StartTCL: n
#
# Item Cooldown Script
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
#               <http://www.gnu.org/copyleft/lesser.html>
#
# Name:         ItemCooldown.tcl
#
# Version:      0.20
#
# Date:         2006-06-06
#
# Description:  Cooldown for some item spells
#
# Author:       Spirit <thehiddenspirit@hotmail.com>
#
# Changelog:
#
#
# v0.20 (2006-06-06)
#	Cooldown group, succeed chance for Defibrillate.
#	Thanks to Ata for the suggestion.
#
# v0.11 (2006-05-06)
#	Item procedures for success and failed cases.
#
# v0.10 (2006-05-03)
#	Cooldown for Defibrillate (Goblin Jumper Cables).
#
#

# variables & initialization
namespace eval ::ItemCooldown {

	variable SAY 1

	variable VERSION 0.20
	variable USE_CONF 1

	# spellid { cooldown cooldown_group procedure (options) }
	variable ItemSpellData
	array set ItemSpellData {
		8342 { 1800 1051 Defibrillate 25 }
		22999 { 1800 1051 Defibrillate 50 }
	}

	if { $USE_CONF } { ::Custom::LoadConf }
	::Custom::AddSpellScript "::ItemCooldown::Check" [array names ItemSpellData]

	::StartTCL::Provide
}

# procedures
namespace eval ::ItemCooldown {

	# check whether a player can use a spell by checking for cooldown
	proc Check { to from spellid } {
		variable SAY
		variable LastUsedTime
		variable ItemSpellData
		set time [clock seconds]

		set cooldown [lindex $ItemSpellData($spellid) 0]
		set cooldown_group [lindex $ItemSpellData($spellid) 1]
		set proc [lindex $ItemSpellData($spellid) 2]
		set options [lrange $ItemSpellData($spellid) 3 end]

		if { !$cooldown_group } { set cooldown_group "group$spellid" }
		if { $proc == "" } { set proc "Default" }

		if { ![info exists LastUsedTime($from,$cooldown_group)] || [set timeleft [expr { $cooldown - $time + $LastUsedTime($from,$cooldown_group) }]] < 0 } {
			set can_use 1
			set LastUsedTime($from,$cooldown_group) $time
		} else {
			set can_use 0
			if { $SAY } { ::Say $from 0 [::Texts::Get "cant_use" [::Custom::SecondsToTime $timeleft]] }
		}

		$proc $to $from $spellid $can_use $options
	}

	# default procedure (kills the caster when failed)
	proc Default { to from spellid {can_use 1} {options ""} } {
		if { !$can_use } {
			::CastSpell $from $from 7
		}
	}

	# defibrillate
	proc Defibrillate { to from spellid {can_use 1} {options 0} } {
		variable SAY

		if { !$can_use } {
			return
		}

		# resurrect
		if { rand() * 100 <= $options } {
			::CastSpell $from $to 24341
		} elseif { $SAY } {
			::Say $from 0 [::Texts::Get "item_failed"]
		}
	}
}

# default localization
namespace eval ::ItemCooldown {
	if { ![::Texts::Exists] } {
		::Texts::Set en "cant_use" "This item is not ready yet! [::Custom::Color {Time left: %s} dcdcdc]."
		::Texts::Set en "item_failed" "This item has failed."
	}
}

# end of script
return




