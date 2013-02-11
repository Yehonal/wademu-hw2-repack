
# Start-TCL: n
#
#

# StartTCL: c
# 
# Based on MobResist 0.3b by Ellessar 
# Adapted for StartTCL 0.9.x by Spirit 
# Completely self-contained, you just need to patch the spells 
# 

namespace eval MobResist { 

   variable VERSION 0.4 
   variable SAY 1 
   variable DEBUG 0 

   variable CHANCES {0 5 10 20 15} 
   variable ALLOWED_MAPS {0 1 30 209 309 451 489 529} 
   variable ROOT_SPELLS {339 1062 5195 5196 9852 9853} 
   variable RESIST_SPELLS {25 56 101 113 118 408 456 512 692 700 710 745 835 853 949 1090 1725 1776 1777 1833 1834 1968 1969 1970 2070 2094 2139 2637 2878 2497 2498 2499 2500 2501 2502 2503 2504 2505 2506 2647 2854 2880 2937 3109 3143 3260 3263 3271 3355 3542 3609 3618 3635 3636 4167 4168 4169 4246 4962 5101 5106 5164 5165 5198 5211 5249 5484 5530 5531 5567 5588 5589 5627 5648 5649 5703 5726 5727 5782 5951 6213 6215 6253 6271 6304 6358 6432 6435 6524 6533 6537 6580 6607 6664 6716 6728 6730 6749 6754 6770 6772 6798 6869 6894 6927 6945 6982 7144 7184 7267 7670 7761 7803 7922 7950 7961 7964 7967 8040 8064 8122 8124 8208 8242 8312 8346 8377 8399 8643 8646 8672 8739 8817 8893 8901 8902 8983 8994 9005 9032 9159 9179 9256 9454 9458 9484 9485 9823 9827 10234 10308 10326 10794 10852 10856 10888 10890 10955 11020 11297 11428 11430 11444 11650 11820 11876 11922 12023 12024 12098 12242 12252 12355 12461 12494 12509 12521 12747 12798 12809 12824 12825 12826 12890 13005 13099 13119 13138 13235 13327 13360 13608 13902 14030 14308 14309 14821 14823 14870 14902 15056 15252 15269 15283 15398 15471 15474 15535 15593 15609 15618 15655 15660 15753 15822 15878 15970 16045 16096 16104 16310 16451 16469 16508 16566 16600 16727 16790 16798 16869 16922 17011 17286 17293 17308 17333 17398 17500 17507 17624 17691 17743 17928 18093 18103 18373 18430 18546 18647 18657 18658 18795 18798 18812 18953 19128 19134 19185 19229 19364 19410 19482 19636 19641 19780 19872 19970 19971 19972 19973 19974 19975 20066 20253 20276 20277 20310 20511 20548 20549 20614 20615 20654 20663 20669 20683 20699 20861 20989 21152 21167 21173 21331 21916 21990 22127 22289 22415 22561 22592 22692 22707 22744 22787 22800 22915 22994 23103 23171 23186 23269 23279 23310 23312 23364 23414 23447 23454 23694 23775 23973 24004 24110 24152 24170 24335 24360 24375 24594 24600 24647 24648 24664 24671 24686 24690 24754 24778 24883 24919 25043 25056} 

   # fired when a root spell is used 
   proc OnRootSpell { to from spellid } { 
      variable SAY 

      if { [IsInDoors $to] } { 
         BreakRoots $to 
         if { $SAY } { 
            Say $from 0 "OMG!! That spell doesn't work here!!" 
          } 
      } else { 
         OnResistSpell $to $from $spellid 
      } 
   } 

   # fired when a spell that can be resisted is used 
   proc OnResistSpell { to from spellid } { 
      variable DEBUG 
      variable CHANCES 

      # perform resist only on mobs (object type 3) 
      set object_type [GetObjectType $to] 
      if { $object_type != 3 } { return } 

      set mlvl [GetLevel $to] 
      set plvl [GetLevel $from] 
      set dif [expr {$mlvl-$plvl}] 
      if { $dif > 7 } { set dif 7 } elseif { $dif < 1 } { set dif 1 } 

      set elite [Custom::GetElite $to] 
      set rnd [expr {int(rand()*100)}] 
      set chance [lindex $CHANCES $elite] 
      if { ![string is integer -strict $chance] } { set chance 0 } 

      if { $DEBUG } { 
         puts "\n DEBUG: [::Custom::GetName $to], Elite type: $elite, Random: $rnd \n" 
      } 

      if { $rnd <= $dif*10+$chance } { 
         BreakRoots $to 
      } 
   } 

   # only checks for indoors instances in the current implementation 
   proc IsInDoors { obj } { 
      variable ALLOWED_MAPS 

      set map [lindex [GetPos $obj] 0] 
      if { [lsearch $ALLOWED_MAPS $map] >= 0 } { 
         return 0 
      } 
      return 1 
   } 

   # removes stun, slowing, or immobilizing effect 
   proc BreakRoots { to } { 
      CastSpell $to $to 22890 
   } 

   Custom::AddSpellScript "::MobResist::OnRootSpell" $ROOT_SPELLS 
   Custom::AddSpellScript "::MobResist::OnResistSpell" $RESIST_SPELLS 
}

#
# MobSpeaking.tcl
#

namespace eval mobspeaking {
	proc npcsaywp { npc } {
		set entry [GetEntry $npc]
		set npcname [GetScpValue "creatures.scp" "creature $entry" "name"]
		set file "extra/npcsay/$npcname"
			if { ![file exists "extra/npcsay/$npcname"] } { return 0 }
		set id [open $file r]
		set buff [read $id]
		set l [split $buff \n]
		close $id
		set n [expr {int(rand()* [llength $l])}]
		set line [lindex $l $n]
			if { $line != ""} {
    		Say $npc 0 "$line"
		}
	}
}


::Custom::AddSpellScript "::TyrandeRedeemer::TotemHide" 51008	
::Custom::AddSpellScript "::TyrandeRedeemer::TotemKill" 51002	

	namespace eval TyrandeRedeemer {
	proc TotemHide { to from spellid } {
		
		if { [::GetQFlag $from CastedA] } { return [ ClearQFlag $from CastedA ] }
		::CastSpell $from $from 51002
		::CastSpell $from $from 7
		SetQFlag $from CastedA	
	}
	proc TotemKill { to from spellid } {
		
		if { [::GetQFlag $from CastedB] } { return [ ClearQFlag $from CastedB ] }
		####::CastSpell $from $from 51002
		::CastSpell $from $from 7
		SetQFlag $from CastedB	
	}
	}






namespace eval WarlockSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 9 } {
set gossipText1 { text 6 "May I offer you some demonic items?" }
} else {
Say $npc 0 "You can not control a demon! Little alone yourself!"
Emote $npc 35
Emote $player 93
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval HunterSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 3 } {
set gossipText1 { text 6 "I have the best Bow strings around and some gun powder" }
} else {
Say $npc 0 "You can't even hold a bow right! We do not bother ourselfs with your worthless kind!"
Emote $npc 35
Emote $player 93
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval MageSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 8 } {
set gossipText1 { text 6 "I show my Magic goods to only Mages!" }
} else {
Say $npc 0 "You have no magic in your blood! Begone before I set you aflame!"
Emote $npc 35
Emote $player 93
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval RogueSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 4 } {
set gossipText1 { text 6 "Sell me your best poison!" }
} else {
Say $npc 0 "The darkside is weak with you! Now move along ######!"
Emote $npc 35
Emote $player 93
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval WarriorSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 1 } {
set gossipText1 { text 6 "Show me your sharpist sword! Shiny Armor would be nice too" }
} else {
Say $npc 0 "I only sell my shiny armor to warriors! Begone pest"
Emote $npc 35
Emote $player 20
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval PaladinSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 2 } {
set gossipText1 { text 6 "Show me your most shineyist srmor and your most heavy hammer" }
} else {
Say $npc 0 "You do not have the holy blessing! Begone before I smite you!"
Emote $npc 35
Emote $player 20
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval DruidSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 11 } {
set gossipText1 { text 6 "Show me the mysitc seeds for the tree of life!" }
} else {
Say $npc 0 "You are not on with nature! Begone before I summon roots!"
Emote $npc 35
Emote $player 20
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval ShamanSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 7 } {
set gossipText1 { text 6 "I want to see your best totems!" }
} else {
Say $npc 0 "You have no shamanestic blood! Shoo before I show you the power of the earth"
Emote $npc 35
Emote $player 20
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval PriestSell {
proc GossipHello { npc player } {
set playerClass [GetClass $player]
if { $playerClass == 5 } {
set gossipText1 { text 6 "I would like to broze your healing books" }
} else {
Say $npc 0 "I say you leave! Before I mind control you!"
Emote $npc 35
Emote $player 20
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

namespace eval GMSell {
proc GossipHello { npc player } {
set playerPlevel [GetPlevel $player]
if { $playerPlevel >= 4 } {
set gossipText1 { text 6 "I need some event rewards can I see what you have?" }
} else {
Say $npc 0 "F**K OFF! I'm not wasteing my time you worthless trash!"
Emote $npc 35
Emote $player 93
return}
SendGossip $player $npc { npctext 33391 } $gossipText1
}
proc GossipSelect { npc player option } {
switch $option {
0 { VendorList $player $npc }
}
}
proc QueryQuest { npc player questid } { }
proc QuestStatus { npc player } {
set reply 0
return $reply}
proc QuestHello { npc player } {
Emote $npc 66}
}

# Start-TCL: n
#





namespace eval Guard { 
   proc is { npc } { 
      set entry [GetEntry $npc] 
      if {($entry == 68) || ($entry == 935) || ($entry == 933) || ($entry == 932) || ($entry == 1423) || ($entry == 2439) || ($entry == 261) || ($entry == 6086) || ($entry == 464) || ($entry == 851) || ($entry == 1495) || ($entry == 1496) || ($entry == 1519) || ($entry == 1642) || ($entry == 1735) || ($entry == 1736) || ($entry == 1737) || ($entry == 1738) || ($entry == 1739) || ($entry == 1740) || ($entry == 1741) || ($entry == 1742) || ($entry == 1743) || ($entry == 1744) || ($entry == 1745) || ($entry == 1746) || ($entry == 1747) || ($entry == 5624) || ($entry == 7980) || ($entry == 3296) || ($entry == 5595) || ($entry == 2092) || ($entry == 727) || ($entry == 3571) || ($entry == 4262) || ($entry == 10037) || ($entry == 2041) || ($entry == 6086) || ($entry == 12160) || ($entry == 8015) || ($entry == 7939) || ($entry == 6087) || ($entry == 3501) || ($entry == 8016)} { return 1 } 
      return 0 
   } 
}



# Script OrgrimmarGrunt.tcl checked by KIRP at 30.06.2005, 21:59
# ###########################################################################
# created by kirp

namespace eval OrgrimmarGruntQS {

proc GossipHello { npc player } {
    ClearQFlag $player tmp1
    ClearQFlag $player tmp2
    SendSwitchGossip $player $npc 1
        SendGossip $player $npc { npctext 2593 } \
                { text 0 "The bank" } \
                { text 0 "The wind rider master" } \
                { text 0 "The guild master" } \
                { text 0 "The inn" } \
                { text 0 "The mailbox" } \
                { text 0 "The auction house" } \
                { text 0 "The zeppelin master" } \
                { text 0 "The weapon master" } \
                { text 0 "The stable master" } \
                { text 0 "Officers' Lounge" } \
                { text 0 "The Battlemaster" }\
                { text 0 "A class trainer" } \
                { text 0 "A profession trainer" }
}

proc GossipSelect { npc player option } {
SendGossipComplete $player
    if {([GetQFlag $player tmp1] == 0) && ([GetQFlag $player tmp2] == 0)} {
    if {$option == 0} {
        SendGossip $player $npc { npctext 2554 }
        SendPOI $player 2 1622 -4376 5 1637 "The Bank"
}
    if {$option == 1} {
        SendGossip $player $npc { npctext 2555 }
        SendPOI $player 2 1677 -4315 5 1637 "The wind rider master"
}
    if {$option == 2} {
        SendGossip $player $npc { npctext 2556 }
        SendPOI $player 2 1575 -4294 3 1637 "The guild master"
}
    if {$option == 3} {
        SendGossip $player $npc { npctext 2557 }
        SendPOI $player 2 1633 -4439 3 1637 "The Inn"
}
    if {$option == 4} {
        SendGossip $player $npc { npctext 2558 }
        SendPOI $player 2 1616 -4392 3 1637 "The mailbox"
}
    if {$option == 5} {
        SendGossip $player $npc { npctext 3075 }
        SendPOI $player 2 1681 -4458 3 1637 "The auction house"
}
    if {$option == 6} {
        SendGossip $player $npc { npctext 3173 }
        SendPOI $player 2 1332 -4649 9 14 "The zeppelin master"
}
    if {$option == 7} {
        SendGossip $player $npc { npctext 4519 }
        SendPOI $player 2 2092 -4824 3 1637 "The weapon master"
}
    if {$option == 8} {
        SendGossip $player $npc { npctext 5974 }
        SendPOI $player 2 2133 -4664 3 1637 "The stable master"
}
    if {$option == 9} {
        SendGossip $player $npc { npctext 7046 }
        SendPOI $player 2 1630 -4263 3 1637 "Officers' Lounge"
}
    if {$option == 10} {
        SendGossip $player $npc { npctext 7048 }
}
    if {$option == 11} {
        SetQFlag $player tmp1
        SendGossip $player $npc { npctext 2599 } \
                    { text 0 "Hunter" } \
                    { text 0 "Mage" } \
                    { text 0 "Priest" } \
                    { text 0 "Rogue" } \
                    { text 0 "Shaman" } \
                    { text 0 "Warlock" } \
                    { text 0 "Warrior" } }

    if {$option == 12} {
        SetQFlag $player tmp2
        SendGossip $player $npc { npctext 2594 } \
                    { text 0 "Alchemy" } \
                    { text 0 "Blacksmithing" } \
                    { text 0 "Cooking" } \
                    { text 0 "Enchanting" } \
                    { text 0 "Engineering" } \
                    { text 0 "First Aid" } \
                    { text 0 "Fishing" } \
                    { text 0 "Herbalism" } \
                    { text 0 "Leatherworking" } \
                    { text 0 "Mining" } \
                    { text 0 "Skinning" } \
                    { text 0 "Tailoring" } }
        ClearGossipSelect $npc $player $options
}

    
    if {([GetQFlag $player tmp1] == 1) && ([GetQFlag $player tmp2] == 0)} {

        if {$option == 0} {
            SendGossip $player $npc { npctext 2559 }
            SendPOI $player 2 2098 -4617 3 1637 "A hunter trainer"
}
        if {$option == 1} {
            SendGossip $player $npc { npctext 2560 }
            SendPOI $player 2 1472 -4221 3 1637 "A mage trainer"
}
        if {$option == 2} {
            SendGossip $player $npc { npctext 2561 }
            SendPOI $player 2 1457 -4181 3 1637 "A priest trainer"
}
        if {$option == 3} {
            SendGossip $player $npc { npctext 2562 }
            SendPOI $player 2 1934 -4221 3 1637 "A shaman trainer"
}
        if {$option == 4} {
            SendGossip $player $npc { npctext 2563 }
            SendPOI $player 2 1774 -4282 3 1637 "A rogue trainer"
}
        if {$option == 5} {
            SendGossip $player $npc { npctext 2564 }
            SendPOI $player 2 1841 -4354 3 1637 "A warlock trainer"
}
        if {$option == 6} {
            SendGossip $player $npc { npctext 2565 }
            SendPOI $player 2 1983 -4795 3 1637 "A warrior trainer"
} 
}


    if {([GetQFlag $player tmp1] == 0) && ([GetQFlag $player tmp2] == 1)} {

        if {$option == 0} {
            SendGossip $player $npc { npctext 2497 }
            SendPOI $player 2 1963 -4468 3 1637 "Alchemy"
}
        if {$option == 1} {
            SendGossip $player $npc { npctext 2499 }
            SendPOI $player 2 2053 -4812 3 1637 "Blacksmithing"
}
        if {$option == 2} {
            SendGossip $player $npc { npctext 2500 }
            SendPOI $player 2 1770 -4486 3 1637 "Cooking"
}
        if {$option == 3} {
            SendGossip $player $npc { npctext 2501 }
            SendPOI $player 2 1916 -4433 3 1637 "Enchanting"
}
        if {$option == 4} {
            SendGossip $player $npc { npctext 2653 }
            SendPOI $player 2 2045 -4745 3 1637 "Engineering"
}
        if {$option == 5} {
            SendGossip $player $npc { npctext 2502 }
            SendPOI $player 2 1484 -4158 3 1637 "First Aid"
}
        if {$option == 6} {
            SendGossip $player $npc { npctext 2503 }
            SendPOI $player 2 1999 -4658 3 1637 "Fishing"
}
        if {$option == 7} {
            SendGossip $player $npc { npctext 2504 }
            SendPOI $player 2 1901 -4460 3 1637 "Herbalism"
}
        if {$option == 8} {
            SendGossip $player $npc { npctext 2513 }
            SendPOI $player 2 1852 -4562 3 1637 "Leatherworking"
}
        if {$option == 9} {
            SendGossip $player $npc { npctext 2515 }
            SendPOI $player 2 2028 -4705 3 1637 "Mining"
}
        if {$option == 10} {
            SendGossip $player $npc { npctext 2516 }
            SendPOI $player 2 1852 -4562 3 1637 "Skinning"
}
        if {($option == 11)} {
            SendGossip $player $npc { npctext 2518 }
            SendPOI $player 2 1810 -4560 3 1637 "Tailoring"
} 
}



        


}

proc QueryQuest { npc player questid } {
}

proc QuestStatus { npc player } {
    return 0
}

proc QuestHello { npc player } {
}

proc QuestSelect { npc player questid } {
}

proc QuestAccept { npc player questid } {
}

proc QuestChooseReward { npc player questid choose  } {
}


}




########################################################
#
# stormwind guard
#
#--------------------------------------------------------
namespace eval Stormwind_Guard {
#--------------------------------------------------------
proc GossipHello { npc player } {
	set gossipText1 { text 1 "The banks" }
	set gossipText2 { text 8 "The Inns" }
	set gossipText3 { text 2 "Gryphon Masters" }
	set gossipText4 { text 6 "The Stable Masters" }
	set gossipText5 { text 3 "Guild Masters" }
	ClearQFlag $player tmp1
	set gossipText6 { text 7 "Class Trainers" }
	ClearQFlag $player tmp2
	set gossipText7 { text 7 "Profession Trainers" }
	SendGossip $player $npc { npctext 33659 } $gossipText1 $gossipText2 $gossipText3 $gossipText4 $gossipText5 $gossipText6 $gossipText7
}
#--------------------------------------------------------
proc GossipSelect { npc player option } {
	if { [GetQFlag $player tmp1] == 1 } {
		switch $option {
			0 { SendGossip $player $npc { npctext 30033 } 
				SendPOI $player 2 -8741 1095 6 1637 "Druid trainer"
			}
			1 { SendGossip $player $npc { npctext 30034 } 
				SendPOI $player 2 -8419 547 6 1637 "Hunter trainer"
			}
			2 { SendGossip $player $npc { npctext 30035 } 
				SendPOI $player 2 -9467 27 6 1637 "Mage trainer"
			}
			3 { SendGossip $player $npc { npctext 30036 } 
				SendPOI $player 2 -9428 109 6 1637 "Paladin trainer"
			}
			4 { SendGossip $player $npc { npctext 30037 } 
				SendPOI $player 2 -9467 27 6 1637 "Priest trainer"
			}
			5 { SendGossip $player $npc { npctext 30038 } 
				SendPOI $player 2 -9467 27 6 1637 "Rogue trainer"
			}
			6 { SendGossip $player $npc { npctext 30039 } 
				SendPOI $player 2 -9467 27 6 1637 "Warlock trainer"
			}
			7 { SendGossip $player $npc { npctext 30040 } 
				SendPOI $player 2 -9461 110 6 1637 "Warrior Trainer"
			}
		}
	}
	if { [GetQFlag $player tmp2] == 1 } {
		switch $option {
			0 { SendGossip $player $npc { npctext 30041 }
				SendPOI $player 2 -9062 153 6 1637 "Alchemy"
			}
			1 { SendGossip $player $npc { npctext 30042 }
				SendPOI $player 2 -9457 88 6 1637 "Blacksmithing"
			}
			2 { SendGossip $player $npc { npctext 30043 }
				SendPOI $player 2 -9467 27 6 1637 "Cooking"
			}
			3 { SendGossip $player $npc { npctext 30044 }
				SendPOI $player 2 -8855 799 6 1637 "Enchanting"
			}
			4 { SendGossip $player $npc { npctext 30045 }
				SendPOI $player 2 -8350 645 6 1637 "Engineering"
			}
			5 { SendGossip $player $npc { npctext 30046 }
				SendPOI $player 2 -9467 27 6 1637 "First aid"
			}
			6 { SendGossip $player $npc { npctext 30047 }
				SendPOI $player 2 -9381 -113 6 1637 "Fishing"
			}
			7 { SendGossip $player $npc { npctext 30048 }
				SendPOI $player 2 -9062 153 6 1637 "Herbalism"
			}
			8 { SendGossip $player $npc { npctext 30049 }
				SendPOI $player 2 -9380 -75 6 1637 "Leatherworking"
			}
			9 { SendGossip $player $npc { npctext 30050 }
				SendPOI $player 2 -8428 689 6 1637 "Mining"
			}
			10 { SendGossip $player $npc { npctext 30051 }
				SendPOI $player 2 -9380 -75 6 1637 "Skinning"
			}
			11 { SendGossip $player $npc { npctext 30052 }
				SendPOI $player 2 -9536 -1217 6 1637 "Tailoring"
			}
		}
	}
	if { ([GetQFlag $player tmp1] == 0) && ([GetQFlag $player tmp2] == 0) } {
		switch $option {
			0 { SendGossip $player $npc { npctext 30028 } 
				SendPOI $player 2 -8925 615 6 1637 "Stormwind Bank"
			}
			1 { SendGossip $player $npc { npctext 30031 } 
				SendPOI $player 2 -9467 27 6 1637 "The Inn"
			}
			2 { SendGossip $player $npc { npctext 30029 } 
				SendPOI $player 2 -8840 488 6 1637 "The Gryphon master"
			}
			3 { SendGossip $player $npc { npctext 30032 } }
			4 { SendGossip $player $npc { npctext 30030 } 
				SendPOI $player 2 -8890 613 6 1637 "Guild Master of Stormwind"
			}
			5 {
				SetQFlag $player tmp1
				set gossipText1 { text 3 "Druid" }
				set gossipText2 { text 3 "Hunter" }
				set gossipText3 { text 3 "Mage" }
				set gossipText4 { text 3 "Paladin" }
				set gossipText5 { text 3 "Priest" }
				set gossipText6 { text 3 "Rogue" }
				set gossipText7 { text 3 "Warlock" }
				set gossipText8 { text 3 "Warrior" }
				SendGossip $player $npc  $gossipText1 $gossipText2 $gossipText3 $gossipText4 $gossipText5 $gossipText6 $gossipText7 $gossipText8
			}
			6 {
				SetQFlag $player tmp2
				set gossipText1 { text 3 "Alchemy" }
				set gossipText2 { text 3 "Blacksmithing" }
				set gossipText3 { text 3 "Cooking" }
				set gossipText4 { text 3 "Enchanting" }
				set gossipText5 { text 3 "Engineering" }
				set gossipText6 { text 3 "First Aid" }
				set gossipText7 { text 3 "Fishing" }
				set gossipText8 { text 3 "Herbalism" }
				set gossipText9 { text 3 "Leatherworking" }
				set gossipText10 { text 3 "Mining" }
				set gossipText11 { text 3 "Skinning" }
				set gossipText12 { text 3 "Tailoring" }
				SendGossip $player $npc  $gossipText1 $gossipText2 $gossipText3 $gossipText4 $gossipText5 $gossipText6 $gossipText7 $gossipText8 $gossipText9 $gossipText10 $gossipText11 $gossipText12
			}
		}
	}
}
#--------------------------------------------------------
proc QueryQuest { npc player questid } {
}
#--------------------------------------------------------
proc QuestStatus { npc player } {
	set reply 7
	::Defense::Register $npc
	return $reply
}
#--------------------------------------------------------
proc QuestHello { npc player } {
}
}
