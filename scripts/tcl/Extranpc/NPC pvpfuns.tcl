# StartTCL: z

namespace eval ::PvPFunScript {
###########################################
# Modifyed by Rama             ############
# PhP-Site by Tha-Doctor       ## v. 2.0 ##
# Based on MrBulkin's script   ############
###########################################
    
    # Version
    variable version 2.0

    # Disable/enable(on/off)
    variable on "on"
    
    # Type of reward (0-money(Need change #),1-item(Need change list),2-buff(Need change list))
    variable reward 1

    # Items for reward
    set item_list "11134 11174 11176 14256 16204 10940 11137 13423 12808 7082 3390 1710 3824 5633 3829 3928 3383 13443 13462 12190 20002 3389 8951 13445 6051 5631 6367 13173 918 15869 12654 13377 18587 12363 1996 12008 1462 15929 5760 5758 5759 20031 21023 8952 8950 13810 18254 20516 16971 13927 13928 13929 7228 16167 18633 1703 9312 9313 9318 9315 9314 13489 13483 9304 21025 13497 13490 12833 19212 19211 19209 19208 12958 3928 12691 14501 14507 1725 4957 8320 9843 10560 12803 7080 7078 7076 4611 7069 7067 7068 7070 9061 18414 14513 14509 18417 14497 14507 14501" 

    # Buffs for reward
    set buff_list "1450 1459 3163"
    set buff [lindex $buff_list [expr {int(rand()*[llength $buff_list])}]]
    
    # Here you can change the folder, that need only for php_site...
    variable headsdb "heads"

    # Here you can change item for Alliance (if you kill Horde)
    variable horde_head 33601
    
    # Here you can change item for Horde (if you kill Alliance)
    variable alli_head 33600
    
    # Here you can set how much heads you must have to become money...
    variable heads_tomoney 10
    
    # Here you can set how much money you become for the heads...
    variable money_forheads 60000
    
    # Here you can set max difference with the Players to become heads...
    variable level_diff 5

###########################################
    set ::SQLdb::handle [ ::SQLdb::openSQLdb ]
    set handle $::SQLdb::handle
}

proc ::PvPFunScript::load { } {
if { $::PvPFunScript::on == "on" } {


Custom::HookProc "::WoWEmu::OnPlayerDeath" {

        set hdif [expr { [ ::GetLevel $killer ] - [ ::GetLevel $player ] } ]
        if { [::GetObjectType $player] == 4 && $hdif > -$::PvPFunScript::level_diff && $hdif < $::PvPFunScript::level_diff } {
        set name [GetName $killer]
        set race [GetRace $killer]
        set class [GetClass $killer]
        set level [GetLevel $killer]
        set ensid [::Custom::GetPlayerSide $player]
        if {![::SQLdb::booleanSQLdb $::PvPFunScript::handle "select name from $::PvPFunScript::headsdb where name='$name'"]} {
                  set query [::SQLdb::querySQLdb $::PvPFunScript::handle "insert into $::PvPFunScript::headsdb values ('$name', '$race', '$class', '$level', 1)"]
                } else {
        set heads [::SQLdb::querySQLdb $::PvPFunScript::handle "select $::PvPFunScript::headsdb from heads where `name`='$name'"]
        set newheads [expr ($heads+1)]
                  set query [::SQLdb::querySQLdb $::PvPFunScript::handle "update $::PvPFunScript::headsdb set level='$level', heads='$newheads' where name='$name'"]
            }
    if {[::Custom::GetPlayerSide $killer] == $ensid } { return }
    if { [::Custom::GetPlayerSide $killer] } { 
    ::AddItem $killer $::PvPFunScript::alli_head
    } else { 
    ::AddItem $killer $::PvPFunScript::horde_head 
    } }

    }
}
}

# originale 
#::SendGossip $player $npc "text 2 \"[::Texts::Get give_heads]\"" "text 0 \"[::Texts::Get exit_option]\""
#

proc ::PvPFunScript::GossipHello { npc player } {
    if { $::PvPFunScript::on == "on" } {
    ::SendGossip $player $npc "text 2 \"[::Texts::Get give_heads]\"" "text 0 \"[::Texts::Get exit_option]\""
    ::Emote $npc 66
    ::Emote $player 66
    } else { ::SendGossipComplete $player }
}

proc ::PvPFunScript::GossipSelect { npc player option } {
if { $::PvPFunScript::on == "on"} {
  if { [ ::Custom::GetPlayerSide $player ] } {
    set itemtogive $::PvPFunScript::alli_head
    set sideask [::Texts::Get alliance]
    } else {
    set itemtogive $::PvPFunScript::horde_head
    set sideask [::Texts::Get horde]
  }
  switch $option {
  0 {
    if { [ ::ConsumeItem $player $itemtogive $::PvPFunScript::heads_tomoney ] } {
        if { $::PvPFunScript::reward == 0 } {
    ::ChangeMoney $player $::PvPFunScript::money_forheads 
        } elseif { $::PvPFunScript::reward == 1 } {
    set item [lindex $::PvPFunScript::item_list [expr {int(rand()*[llength $::PvPFunScript::item_list])}]]
    ::AddItem $player $item 
        } elseif { $::PvPFunScript::reward == 2 } {
    set buff [lindex $::PvPFunScript::buff_list [expr {int(rand()*[llength $::PvPFunScript::buff_list])}]]
    ::CastSpell $npc $player $buff 
        }
    ::SendGossipComplete $player
    } else {
    ::Say $npc 0 [ ::Texts::Get not_enought_heads $sideask ]
    ::SendGossipComplete $player } }
  1 { ::Say $npc 0 [::Texts::Get bye_bye $sideask ]
    ::SendGossipComplete $player }
        }
    }
}

proc ::PvPFunScript::QuestStatus { npc player } {
if { $::PvPFunScript::on == "on" } {
return 5
}
}


proc ::PvPFunScript::CreateDb { } {
if { ! [ ::SQLdb::existsSQLdb $::PvPFunScript::handle `$::PvPFunScript::headsdb` ] } {
::SQLdb::querySQLdb $::PvPFunScript::handle "CREATE TABLE `$::PvPFunScript::headsdb` (`name` varchar(20) NOT NULL default '',`race` int(2) default NULL,`class` int(2) default NULL,`level` int(2) default NULL,`heads` int(4) default NULL,PRIMARY KEY  (`name`)
)"}
}

::PvPFunScript::CreateDb
::PvPFunScript::load
set loadinfo "Hunt Script v$::PvPFunScript::version by Mr.Bulkin & Rama $::PvPFunScript::on"
puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"