# Start-TCL: n

# Simple Roll System for loot sharing (c) 2007 by smartwork
#
# Usage: 
#
# Before going into an instance, the most trustworthy and experienced player
# will be choosen to be the loot master. This player loots EVERYTHING.
# after a boss battle or another bigger fight, the loot master will show 
# all looted items using shift+click at the items. A line like below will 
# appear in chat:
#
# [plate armor][wand][plate gloves]
#
# Now all players who are interessted in one of these items either select a 
# dead NPC or a pet (can be anything) and type:
#
# .roll X
#
# Where X is the number of the shown item, counted from left. So to roll for the
# gloves, one must type: .roll 3
#
# The selected pet or dead NPC will then say a random number from 0 to 99 and
# for which item the player has rolled. The player who gets the highest number
# for an item, wil get the item from the loot master. As the NPC is used as
# neutral "middleman" it is very hard or even impossible to cheat here unless
# the player has GM status. 
#
# You should define additonal rules, like that only classes who can actually
# use the item are allowed to roll for it. Cloth boots with +intellect can 
# be worn by warriors too but the will be more usefull for a caster, therefore
# only casters should be allowed to roll for it. The same applies for items 
# which have a class or race requirement. As the items have been shown
# in chat, all players in the group may ensure this. Furthermore a player 
# should also only roll for an item if he has not aleady the same or a better
# one equipped. Only nobody in the group can use the item because of class
# requirement for example, everboy should be allowed to roll. But it's
# fully up to you, what additional rules of that kind you define.
#
# The roll command can only be used once in a minute to prevent spamming. 
# Keep also an eye at the chat in case the players nevertheless try to
# roll multiple time. All in all this works rather good at my server.
# It may be usefull to increase the npc_corpse_delay in the emu.conf to give
# players more time to loot a corpse before it disappears.
#

proc ::WoWEmu::Commands::CmdRoll {player cargs} {
  set roll_delay 60
  set map [lindex [GetPos $player] 0]
  if {$map < 2} {
    return "Questo comando è utilizzabile esclusivamente in instance!"
  }
  if ![string is integer -strict $cargs] {
    return "Inserisci il numero della posizione dell'oggetto desiderato contando da sinistra"    
  }
  
  set last_rolled [GetQFlagData $player last_rolled]
  if ![string is integer -strict $last_rolled] {set last_rolled 0}
  if {[clock seconds] - $last_rolled < $roll_delay} {
    return "You can only roll once in $roll_delay seconds!"
  }
  
  set pselection [GetSelection $player]
  set link [GetLinkObject $pselection]
  if {[GetObjectType $pselection] != 3 || 
      [GetHealthPCT $pselection] && [GetObjectType $link] != 4} {
    return "Tu devi selezionare un NPC o un pet pet come intermediario per il roll!"      
  }
  
  set rolled [expr int(rand()*100)]
  SetQFlagData $player last_rolled [clock seconds]  
  Say $pselection 0 "[GetName $player] is interessted in item $cargs\
                     and rolls a: $rolled" 
  return "OK: $rolled rolled for item $cargs"
}

::Custom::AddCommand "roll" ::WoWEmu::Commands::CmdRoll 0 
