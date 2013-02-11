# start-tcl: c

# SmartAI v1.4.1 an object oriented (iTCL) AI Control Script for WoWEmu
#
# This program is (c) 2006, 2007 by smartwork <smart.guy@gmx.de>
#
# This program is free software, you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free
# Software Foundation, either version 2.1 of the License, or (at your option)
# any later version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY, without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more
# details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin St, Fifth Floor, Boston, MA 02110-1301 USA. You can also consult
# the terms of the license at:
#
#		<http://www.gnu.org/copyleft/lesser.html>

##############################################################################
#                               Introduction                                 #
##############################################################################
#
# Requirements
# ------------
#
# To run this script you need to load the itcl 3.3 (or newer) libary as
# package. Furthermore you must give spell 5373 a script effect:
#
# 5373:60=77
#
# The script will only work properly on WoWEmu v0.4735.1.9.
#
# How it works
# ------------
#
# This script is, like MasterScript for quests, a "Master Script" for any AI
# actions. Therefore the behaviour of mobs can be defined in profiles.
#
# There are 3 ways to do that. The most simple method is the classical spells
# key ("spell=" is allowed too) in the creatures.scp as it was supported in
# older AIs too and has proven to be a quick method to give a mob some spells.
# But that way the mob still remains rather dumb although the AI gives all mobs
# without doing anything a basic AI, that means that all stuff in the
# API AI::CanCast is used (if no profile is defined), that guards will help
# each other and also friendly players, that NPCs will not attack players
# which are too high level and that the AI controll will only send as many NPCs
# as needed to defeat the player, that means NPCs that NPC more tend to act as a
# group instead as single individuals. They may even get reinforcements if
# player is unexpectedly going to win a battle. Defense.tcl and the appropriate
# AddOn by Spirit is no longer needed.
#
# Now to the actual profiles. Profiles are defined in the ai.scp which also
# supports includes like the regular scps. But keep in mind that this SCP is
# loaded by the script and will not be reloeaded with .rescp!
#
# A profile contains a number and will be used by the NPC with the same entry
# number. Alternativly you can also add the key "aiprofile=" to the NPC in the
# creatures.scp to give it a different ai profile.
# The profile itself consists currently of tactics, actions and comments.
# In future general parameters may be added. To prevent verbose explanations,
# I'll simply give an example of a caster mob. A caster NPC will try to prevent
# melee and to use its spells from a certain distance.
#
# Example:
#
# [ai 111051]
# name=Caster
# // tacticX=type {actions} {parameters} {comment}
# // params:  pri chrgs adist kdist dur ad tcd tframe health timeout ntac
# tactic0=2 {0 1} {1 0 30 20 0 5 1 0 50 0} {New Tactic: alternating casts}
# tactic1=0 {0 2} {0 0 50 30 0 5 1 0 0 0} {New Tactic: spell + text action}
# // actionX=atype {pri tsel ttype range chrgs dur cdwn tr or na} {spec} {txt}
# action0=0 {0 0 1 30 0 5 6} 133 // fireball rank 1
# action1=0 {0 0 1 30 0 5 6} 116 // frostbolt rank 1
# action2=1 {1 0 0 30 0 4 20 !h50} 0 {Please heal me!} // just some text action
#
# As you see, each line can have a comment and furthermore I've included
# the structure of actions and tactics as comments to increase the readability
# as there is currently still no GUI editor for it. The parameters of tactics
# and actions are described bellow. Bascially a mob can have several tactics
# and each tactics has assigned actions. Furthermore tactics can only be
# activated in a certain time frame, so some tactics may only be available
# if the mob is in combat and others only if it has nothing to do, so if it
# is idle. I recomment to create a file called ai.scp in the scripts directory
# and to put the example there. Note that you must remove the leading comment
# chars (#) and that spell 5373 MUST have a script effect, that means a 77 at
# column 60 (where the first column is 0, like usual for DbcTool by trx).
# Needless to say that you have also to create an NPC with ID 111051 or to
# assign the profile to an existing NPC. It should be not faster than speed=1.2
# and have no greater combat_reach than 3. Don't forget that it must have mana!
# After playing arround with it, use the following descriptions of tactics and
# actions as reference. Note to coders: this is fully object oriented therefore
# you can also add easily new own actions, just see the declartions bellow
# and how the are implemented, especially simple actions like text actions.
#
# New console commands
# --------------------
# aioff - disables the SmartAI, .retcl is needed to reactivated it
# dist - displays distance to selected mob
# gm - turns player in "GhostMode", it will not be attacked then anymore
# focus - returns data about which target the selected NPC currently attacks
# npcaggro <0|1> - enables or disables NPC vs. NPC battles
# swt <number> - activates the tactic with that number of the selected NPC
#

###############################################################################
#                Class descriptions and syntax in the AI.scp                  #
###############################################################################
#
# TNpc:
# =====
#
# This class contains all control properties of an NPC, this means its memory,
# special abilities, AI parameters and some functions to get aware about
# what is happening arround it.
#
# TNpcTactic
# ==========
#
# An NPC has a set of tactics (at least 1), which can get active if their
# requirements are matched. There can only be one active tactic at a time.
# A tactic defines what abilities (=actions) an NPC can currently use and also
# defines its agression behaviour. If no tactic can get active, the NPC will
# either do nothing or go into melee. If several tactics are availabe because
# their requirements are matched, randomly one of those with equal and highest
# priorites is choosen. The lowest priority is 0. A tactic ends if either a
# tactic with a higher priority gets available or the requirements for the
# current tactic are no longer matched. In the last case a next_tactic might
# be defined which is started if it's available. If it's not available, another
# available tactic will be activated in the described way.
#
# There are currently 3 types of tactics: 0 = random, 1 = sequence and 2 = loop
# These types define how the next action of the current active tactic is
# choosen and are pretty self-explaining. If the next action of the active
# tactic is currently not available, the NPC will do nothing until it gets
# ready or it will (depending on tactic properties) go into melee. For type 0
# tactics the next action is only choosen among the currently available actions.
#
# Format of Tactics in SCP files:
#
#   tacticX=<type> {actions} {parameters} {optional text} // optional comment
#
# with empty {} parameters for defaults or the following sequence of options:
#
#   pri chrgs adist kdist dur ad tcd tframe health timeout ntac
#
# where:
#
#   type:    type of tactic, can be 0 = random, 1 = sequence and 2 = loop
#
#   actions: list of action ids which belong to this tactic
#
#   pri:     priority of tactic, can be 0 to 9, defines which tactic is choosen
#            if several are available
#
#   chrgs:   charges, must be number, defines how often the tactic can get
#            per  battle, 0 means no limit
#
#   adist:   aggression radius, unagression radius is 10m to 20% greater
#
#   kdist:   distance to keep from target, NPC will not go in melee but still
#            try to follow its target if this is greater 0, good for ranged
#            NPCs (casters), you may also give them a blink  spell,
#            as there is currently no other way to get away from target
#
#   dur:     duration of tactic in seconds, can also be a range
#            (e.g. 200..300), 0 means no limit, keep in mind that a tactic
#            can be activated before the actual battle starts
#
#   ad:      action delay, can be number or range (e.g. 4..8), defines the
#            minimum time in seconds between two actions, so in case of
#            spell actions, the basic cast speed. If the duration of the last
#            executed action is higher than the delay, the delay will be
#            overriden. So in case of action delay 0, the action or cast speed
#            depends only on the duration that is defined for the actions
#
#   tcd:     tactic cooldown, can also be a range, defines the time in seconds
#            before the tactic can get active again
#
#   tframe:  time frame, can be -4, -3, -2, -1, 0, a positive number or a range,
#            defines when a tactic can be activated and stay active. If the
#            value is a range (x..y), it defines a time frame (in seconds) after
#            battle start. If it is a single number, it has following meanings:
#
#              -4 = like -1, but used by quests, NPC will be unlocked afterwards
#              -3 = tactic can be active at any time
#              -2 = tactic can only be active if NPC is idle
#              -1 = must be activated by another tactic or by SwitchTactic
#               0 = tactic can get active as soon as the NPC gets in battle
#              any postive number: seconds after battle start
#
#            A battle starts if an enemy gets in aggro radius for the first time
#            or if the NPC's health gets below 100%. The battle ends if
#            no CanUnagro is called, no CanAgro returned 1 for at least one
#            minute and if NPC's health is at 100%.
#
#   health:  minimum health, can be number or range, defines the health that the
#            NPC must have to allow this tactic to get and remain active, use
#            the tactic priority to make the mob changing to the desired tactic
#            when its health changes. For greater control use a range here,
#            like 30..40.
#            Note: a single value of 0 or 100 means no health restriction
#
#   timeout: defines after how many seconds of inactivity the tactic is aborted,
#            where inactivity means that no or the next action does not get
#            ready in the given time
#
#   ntac:    next tactic, must be number of an existing tactic or -1 if there
#            is no specific next tactic to activate
#
#   The optional text is said by the NPC when the tactic gets active,
#   it must be put in braces {}
#
# example: tactic1=0 {1 2} {0 0 20 0 0 4 30 0 50 0 -1} {test tactic activated}
#   This tactic is of type random, uses the actions with IDs 1 and 2, has a
#   priority of 0, can be activated unlimited times, has an aggro Distance
#   of 20, no Distance to keep, no duration limit, an action delay of 4 seconds,
#   can be reactivated after 30s after it ends, can be activated at anytime
#   (if possible) but only if the npc's health is at 50% or above, has no
#   timeout, no next tactic and the mob will say "test tactic activated" when
#   the tactic gets active.
#
# TNpcAction
# ==========
#
# This is the abstract base class for any action that an npc can perfom with
# this AI. It handles all basic problems and management like requirements
# check and cooldown update. To scripters: IT CAN NOT BE USED DIRECTLY! You have
# to derive specific actual actions from this class. This is already done here
# for spells, texts, emotes and some other actions.
#
# Format of Actions in SCP files:
#
#  action0=atype {parameters} {special parameters} {optional text} // comment
#  action1=atype {pri tsel ttype range chrgs dur cdwn tr or na} {special} {text}
#
# atype: type of action, can currently be:
#          0 = Spell Action, 1 = Text Action, 2 = Emote Action,
#          3 = Pause Action, 4 = Script Action, 5 = CallForHelp Action,
#          6 = SwitchTactic Action, 7 = NewTarget Action, 8 = Despawn Action,
#          9 = SetFaction Action, 10 = SetWayPoint Action, 11 = Teleport Action
#
# parameters: pri tsel ttype range charges duration cooldown treqs oreqs naction
#
# special parameters: these depend on the specific action type
#
# text (optional): text that the mob will say when performing the action
#
# where:
#
# pri:   action priority, has only effect if type of active tactic is 0 (random)
#
# tsel:  target selector, can be: 0 = random, 1 = nearest, 2 = lowest health,
#        9 = every, defines the how the available targets are selected, so it
#        has no effect if target type is 0 (random) or 1 (focus). For now 3 to 8
#        is reserved for future extensions, like weakest, strongest (in damage
#        and life), most threatful, least threatful)
#
# ttype: target type, can be: 0=self, 1=focus, 2=any_friend, 3=any_enemy,
#                             4=any_neutral, 5=any_mob, 6=link (for pets)
#
# range: effective range of action, must be number or numeric range, in case of
#        a number >= 0, this value is treated as max range, -1 means any range
#
# charges: must be number, how often the action can be used per battle
#
# duration: must be number, time in seconds how long it takes to execute the
#           action, the mob will not perform another action before this,
#           note that spells can be stacked to a certain degree if you don't
#           know their casttime and therefore set the duration to short, the
#           action duration can override the tactic defined action delay
#
# cooldown: must be range or number, defines the time in seconds until the
#           action gets ready again
#
# treqs:    target requirements, optional but must exist if oreqs are defined,
#           is a list of chars followed by specfic arguements, defines the
#           requirements that a target must meet to allow the action to be
#           executed at it
#
# oreqs:    own requirements, optional, like treqs but always checked for the
#           currently processed (attacking) NPC
#
# naction:  must be number, can be omitted or set to -1 if no next action is
#           defined, is used to execute a specific action as next one,
#           independently from current tactic
#
# example1:
#
#   action2=0 {0 0 1 5..30 3 4 8} 18435 {Flame Breath}
#
#   spell action with a priority of 0, target is a "random" player in focus
#   if in range of 5 to 30 with 3 total charges, takes approximately 4 seconds
#   to execute it and has a cooldown of 8 seconds:
#
# example2:
#
# action3=0 {0 2 2 0 5 2 3..4 {fs !h50} h70 -1} 913 {Casting Healing Wave Rank4}
#
#   spell action, target weakest friend (including self, if in range),
#   any range with 5 total charges, needs 2s for execution, has a cooldown of
#   3 to 4 seconds, target must have same faction as the acting npc and its
#   health must due to the not operator (!) be BELOW 50% (note that if there
#   would be no not-operator, the required health would be 50% or above),
#   executed only if the attacking mob has a health of at least 70%
#
# Note: Healing Wave naturally has not an unlimited range, but this will be
#       restricted automatically by the spell parameters, if defined.
#
# TODO:
# - Dialog config able pets, dialog must be initiated via spell effect
# - cooldown-group or actions, seperated from the value(s) with ":"
# - new action requirement: focussed by target
# - Catch errors of erroneous profiles in TNpc::Constructor
# - GetNearbyEnemies may only return the enemies of the most powerful nearby
#   fraction or simply a big nearby hostile boss (if any) instead of all enemies
# - possible temporary transfer of scanner feature to attacking mob
#   until battel ends to prevent distruing error messages because player
#   also casts stuff at the same time where the scanner wants to send its ping
# - verify timeout after target logout
# - recheck .paralyse
# - increase ttl until destroy
# - unaggro every x seconds to update visible player in a CanAggro call
# - Hotspot Action, marks a target as target for the next x (Spell?)Actions,
#    with two hotspot lists per npc, one for friends, one for enemies, every
#    time where a target other than self is processed, a hotspot npc can
#    override this depending on Weight%, so for example if you have healer npc
#    that normally heals the nearest npc and another npc sets itself as a
#    hotspot, the healer npc will now heal the hotspot npc depending on the
#    Weight in %, meaning if the weight is 50, the chance to heal the hotspot
#    instead the regular target will be at 50%. If an enemy player is marked
#    as hotspot, all offensive actions will be directed it for a certain time.
#    There can only be one enemy and one friendly hotpot active per npc, when
#    the hotpot request is sent to nearby friends those with earlier expiring
#    hotpots should be prefered. The new hotspot will override the current
#    active one. There should e a minimum duration where a hotspot remains
#    active and uninterruptable (arround 10s) unless it dies before
#    Parameters: CallRange, FriendLimit (max. num of Friends to call), Seconds,
#                Weight, FriendReqs (optional)
#    Reqs, Seconds
# - new target selector: every (or number) (done)
# - multi target actions: pending targets in executed checken und
#     ggf. erneut execute aufrufen, spellactions sind ja sowieso stacked
# - possibly new target_types: 4=supporter (player who has current focus selected)
#      5=anyplayer 6=anyselector 7=anyintruder
#      selector: player who has selected the current npc, so normaly an
#      attacker
#      intruder: any nearby player in range or npc with SP dist > x
# - new target reqs: time visible, number of nearby friends or enemies


#######################################################################
# Test and debug stuff (may be removed soon), scroll down to SETTINGS #
# or scroll even more down to the declartion part if you want to add  #
# actions or get a better understanding of the data structures        #
#######################################################################
variable last_committed 0
variable last_ccms 0
proc LogMob {mobid msg} {
  return

  variable last_committed
  variable last_ccms
  set new_ccms [clock clicks -milliseconds]
  if !$last_ccms {set last_ccms $new_ccms}

  set start [clock clicks -milliseconds]
  set ot [GetObjectType $mobid]
  if {$mobid > 0} {
    switch -- $ot {
      3 {set prefix "\[$mobid\] [GetGuid $mobid] ([GetEntry $mobid]) "}
      4 {set prefix "[GetName $mobid] "}
      default {set prefix "(invalid_id) "}
    }
  } else {set prefix ""}
  set end [clock clicks -milliseconds]

  set prefix "[clock format [clock seconds] -format "%H:%M:%S"]\
             ([expr {[clock clicks -milliseconds] - $last_ccms}]ms,\
              [expr {$end - $start}]ms) $prefix:"

  if {[clock seconds] - $last_committed < 5} {
    ::Custom::Log $prefix$msg "ai_debug.log" 0
  } else {
    set start [clock clicks -milliseconds]
    ::Custom::Log $prefix$msg "ai_debug.log" 1
  	set end [clock clicks -milliseconds]
    set time [expr { $end - $start }]
    ::Custom::Log "committing took $time ms" "ai_debug.log" 0
    set last_committed [clock seconds]
  }
  set last_ccms [clock clicks -milliseconds]
}

proc GetStackTrace {} {
  set depth [info level]
  incr depth -1
  set stack_trace ""
  for {set i 1} {$i < $depth} {incr i} {
   if {$stack_trace != ""} {append stack_trace " --> "}
     append stack_trace "[info level $i]"
  }
  return $stack_trace
}


#############################################################################
##################           MAIN SCRIPT           ##########################
#############################################################################

namespace eval SmartAI {

#============================================================================
#                                 SETTINGS                                  #
#============================================================================

# empty or (very!) low-chance dummy loot, needed for "despawning" mobs
variable DUMMY_LOOT 50020

variable pararef_interval 20; # paralyse refresh intervall
variable default_aggro_dist 20
variable npc_aggro_enabled 1; # default npc aggro setting, can be changed ingame

# tables and constants

# a side contains alist of factions that belongs to it, add new at will,
# the ones for default horde and alliance are taken from custom.tcl by spirit,
# all factions that belong to no specfic side get -1 here too

# 0 = alliance, 1 = horde
array set sides {
  0 {11 12 55 57 64 79 80 84 122 123 124 148 210 371 534 1076 1078 1097 1315\
     1514 1575 1594 1600}

  1 {29 68 71 83 85 98 104 105 106 118 125 126 714 995 1034 1074 1174 1314\
     1515 1595}

  2 {415 73 103}
}

# define which side will aggro which other sides
array set hostile_sides {
  0 {1 2}
  1 {0 2}
  2 {0 1}
}

# guards list, stolen from honor.tcl by Spirit :)
# guards will always call nearby guards of same faction when under heavy attack,
# they will also help attacked players of the same side
variable guard_entries {68 197 234 261 464 487 489 490 727 821 823 851 853 869
  870 874 876 1064 1089 1090 1340 1423 1475 1495 1496 1519 1560 1642 1735 1736
  1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1756 1777 1976 2041
  2092 2386 2405 2439 2621 3296 3501 3571 3836 4262 4624 4921 4944 4995 5091
  5595 5624 5725 6086 6087 6237 6241 6766 6785 7295 7489 7865 7939 7980 8015
  8016 9095 10037 11194 12160 12423 12427 12428 12480 12481 12580 13839 14714
  14717
}
############################################################################
##################             CLASSES                ######################
############################################################################

class TMob {
  # abstract base class, do not use it for creation, use TNpc & TPlayer instead
  protected {
    variable attacker_guids ""
    variable civilian 0
    variable emote_unlock_needed 0
    variable last_activity 0
    variable last_dfc_update 0
    variable last_defeat_chance 0
    variable local_factions ""
    variable nearest_scanner_guid ""
    variable this_mob_entry 0
    variable this_mob_faction 0
    variable this_mob_guid ""
    variable this_mob_id 0
    variable this_mob_name ""
    variable this_mob_side -1

    method SendLocalEnemy {mobobj}
    method UpdateAttackers {}
    method UpdateSide {}
  }
  public {
    variable scanner_enabled 0

    constructor {amobid} {}
    destructor {}
    method Cast {spell {target ""}}
    method Chat {{lang 0} {msg ""}}
    method DistanceTo {target}
    method Emote {emoteid}
    method EmoteState {target emoteid}
    method GetDefeatChance {}
    method GetEntry {}
    method GetHealth {}
    method GetLevel {}
    method GetLocalEnemies {}
    method HasQFlag {flag}
    method IsActive {}
    method IsCivilian {}
    method IsGhost {}
    method GetAttackers {}
    method GetFaction {}
    method GetFocussedMob {} {};           # abstract method
    method GetGuid {}
    method GetLastActivityTime {}
    method GetMobID {}
    method GetName {}
    method GetNearbyEnemies {{range 0}}
    method GetNearbyFriends {{range 0}}
    method GetNearbyMobs {{sides ""}}
    method GetNearbyNeutrals {{range 0}}
    method GetPosition {}
    method GetPowerStats {} {};            # abstract, returns hitpoints, damage
    method GetSide {}
    method NotifyAttacker {mobobj}
    method NotifyFactionEnemy {mobobj faction}
    method NotifySideEnemy {mobobj side}
    method ReadyToScan {}
    method RegisterNearbyMob {mobobj}
    method ScannerPing {from}
    method SetFaction {newfaction}
    method SendScanImpuls {}
    method UpdateMob {}
  }
}

class TPlayer {
  inherit TMob
  protected {
    variable last_map -1
    variable last_map_change 0
    method UpdateSide {}
  }
  public {
    constructor {amobid} {TMob::constructor $amobid} {}
    method GetClass {}
    method GetFocussedMob {}
    method GetQuestStatus {questid}
    method GetRace {}
    method GetSkillLevel {skillid}
    method GetPowerStats {}
    method ReadyToScan {}
    method UpdateMob {}
  }
}

class TNpc {
  inherit TMob
  private {
    variable aggro_dist 0
    variable battle_start_time 0
    variable cached_spell_ids ""
    variable cached_spell_infos ""
    variable cast_complete_time 0
    variable chasing 0
    variable current_kdist 0
    variable default_aggro_dist 0
    variable focussed_guid ""
    variable last_loop_time 0
    variable last_aggroed 0
    variable last_moved 0
    variable last_nbm_update 0
    variable last_tac_check 0
    variable last_paralysed 0
    variable last_pos ""
    variable last_recharge 0
    variable loop_delay 2
    variable nearby_mobs ""
    variable new_aggro_time 0
    variable next_target_guid ""
    variable next_target_ts 0
    variable pending_spells ""
    variable pending_spell_targets ""
    variable spell_cooldowns ""
    variable unpara_count 0
    variable unaggro_dist 0
  }
  protected {
    variable actions ""
    variable average_damage 1
    variable bounding_radius 1
    variable combat_reach 1
    variable melee_range 1
    variable current_tactic ""
    variable elite 0
    variable max_aggroable_level 255
    variable max_hitpoints
    variable paused_until 0
    variable tactics ""
    method ActivateTactic {tactic}
    method ActivateNextTactic {}
    method CheckKeepDist {}
    method GetBestTactics {}
    method GetSpellData {spellid}
    method IsTurnBlocked {};               # not implemented yet
    method ProcessTactic {}
    method ProcessSpellStack {}
    method SetFocus {{mobobj ""}}
    method StartBattle {}
    method StopBattle {}
    method UpdateSide {}
  }
  public {
    constructor {amobid} {TMob::constructor $amobid} {}
    destructor {}
    method CanAggro {player}
    method CanCastSpell {spell {target ""}}
    method CanUnAggro {player}
    method Cast {spell {target ""}}
    method ClearSpellStack {}
    method FocusOutOfRange {}
    method GetActions {}
    method GetBattleStart {}
    method GetCombatReach {}
    method GetCurrentTactic {}
    method GetElite {}
    method GetFocussedMob {}
    method GetLink {}
    method GetNextTarget {}
    method GetPaused {}
    method GetPowerStats {}
    method GetSpellCastTime {spellid}
    method GetSpellRange {spellid}
    method HasTactics {}
    method Idle {}
    method NotifyAttacker {mobobj}
    method NotifyRecharge {mobobj}
    method Pause {{seconds -1}}
    method ScannerPing {from}
    method SetNewTarget {target}
    method SetNextTarget {target}
    method SwitchTactic {tacid}
    method SetWP {wp_id}
    method Unpause {}
  }
}

class TNpcAction {
  private {
    variable action_id 0
    variable last_target_update 0
    variable next_target_guids ""
  }

  protected {
    variable calculating_duration 0
    variable cooldown_time 0
    variable current_duration 0
    variable execution_count 0
    variable multi_executable 1; # see header of IsMultiExecutable
    variable this_npc "";
    variable this_mob_id "";
    variable this_mob_side 0;
    method CheckReqs {target requirements}
 	  method GetNextTarget {}
    method Executed;             # Executed must be called at end of Execute
    method ProcessSpecialArgs {args} {}; # see constructor
    method UpdateNextTarget {}
  }

	public {
    variable charges 0
    variable cooldown 4..8
    variable duration 4
    variable next_action_id -1
    variable own_reqs ""
    variable priority 0
	  variable range 0..30
	  variable target_type 0; # 0=self, 1=focus, 2=any_enemy, 3=any_friend
	  variable target_selector 0; # 0=random, 1=nearest, 2=weakest
    variable target_reqs "";    # target must match these, see CheckReqs
    variable text ""

  	constructor {anpc_object aaction_id args special {name ""}} {}
  	method Execute {} {};   # ABSTRACT method, must finally call Executed!
    method GetActionID {}
    method GetCurrentDuration {}
 	  method IsMultiExecutable {}
	  method IsReady {}
	  method Reset {}
	}
}

class TNpcTactic {
  protected {
    variable actions "";      # list of action objects
    variable current_action_delay 5
    variable current_cooldown 0
    variable current_duration 0
    variable execution_count 0
    variable last_activity 0
    variable last_action_idx -1
    variable next_action ""
    variable paused_until 0
    variable req_battle_state 0
    variable start_time 0
    variable tac_type 0;      # 0 = random, 1 = sequence and 2 = loop
    variable tac_id 0
    variable this_mob_id ""
    variable this_npc ""
  }

  public {
    # see the header at top for more details about the following parameters
    variable action_delay 5
    variable aggro_dist 20
    variable charges 0
    variable cooldown 0;         # time after which tactic can get active again
    variable duration 300 400;   # how long tactic can be active, 0=nolimit
    variable health_range 1 100; # required health of (acting) npc
    variable keep_dist 0
    variable next_tactic_id -1
    variable priority 0
    variable text ""
    variable time_frame 0;
    variable timeout 180; # abort tac if no actions get ready for this time
    variable unaggro_dist 30
    #possible future options: number of friends_in_range, enemy_players_in_range

    constructor {npcobj atacid atype aaobjs {params {}} {txt {}}} {}
    method Activate {}
    method GetActions {}
    method GetReqBattleState {}
    method GetTacID {}
    method GetTacType {}
    method IsAvailable {}
    method PerformNextAction {}
    method Pause {seconds}
    method Reset {}
  }
}

#============================================================================
#                                 Actions                                   #
#============================================================================
class TSpellAction {
  # action type: 0, makes npc casting a spell,
  # special args: spellid, direction (optional, can be st, ss, ts, tt)
  #               direction defaults to "st" (self --> target) of omitted
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  # unfortunately the constructor must be redeclared in each derived class
  # to explicitly "initialize" the inherited constructor because it will be
  # called without any parameters otherwise, but no body needed here
  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public variable spell
  public variable direction "st"
  public method Execute {}
  public method IsReady {}
}

class TTextAction {
  # action type: 1,
  #   lets the npc say the text of the common text param in a specifc language
  # special args: language_id (see defines.scp)
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable language

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TEmoteAction {
  # action type: 2, makes npc performing an emote,
  # special args: emoteid (see defines.scp)
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable emoteid

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TPauseAction {
  # action type: 3, pauses tactic or npc, special args: seconds [target]
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable seconds 0;   # how long the pause should last
  public variable target 0;    # 0 = tactic, 1 = npc

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TScriptAction {
  # action type: 4, calls a TCL proc with npcid and target,
  # special args: fully qualifed name of a TCL proc
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable tcl_proc ""

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TCallForHelpAction {
  # action type: 5, asks a number of friends to attack the action target if
  #   it is  an enemy and its focus if it is a friend
  # Special Params:  CallRange, FriendLimit, FriendReqs (optional)
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable call_range 50
  public variable friend_limit 2
  public variable friend_reqs ""

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TSwitchTacticAction {
  # action type: 6, changes tactic
  # special args: tactic_ID
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable new_tacid ""

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TNewTargetAction {
  # action type: 7, changes focus to action target
  # special args: none (must be {} if a text is added for the action)
  inherit TNpcAction

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TDespawnAction {
  # action type: 8, despawns action target
  # special args: none (must be {} if a text is added for the action)
  inherit TNpcAction

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TSetFactionAction {
  # action type: 9, changes faction
  # special args: faction_id
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable faction_id ""

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TSetWayPointAction {
  # action type: 10, assignes a WP to the NPC
  # special args: wp_id
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable wp_id ""

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

class TTeleportAction {
  # action type: 11, teleports a player to a destination position or the NPC,
  #              if the destination (special arguements) is left empty
  # special args: map x y z
  inherit TNpcAction
  protected method ProcessSpecialArgs {args}

  public variable destination ""

  constructor {anpc_object aaction_id args special {name ""}} {
    TNpcAction::constructor $anpc_object $aaction_id $args $special $name
  } {}
  public method Execute {}
}

############################################################################
###############             IMPLEMENTATION             #####################
############################################################################

# internal constants, no need to change something here
variable charge_spell 22690
variable scan_spell 5373
variable scan_interval 15

# internal variables, no need to change something here
variable enabled 1;   # enables this AI, must and will be shutdown before retcl
variable last_agro_check {0 0}
variable last_update 0
variable last_player ""
variable last_player_id ""
variable last_npc_aggro 0
variable last_scan 0

# arrays:
# $scanner_nbm$side($guid) $timestamp where scanner is a mob ojbect
#
# So every mob which is used as scanner will put itself automatically in
# the global scanners array which contains for all scanner GUIDs their object.
# Furthermore there can be per scanner and side one array of the above format,
# containing all guids that the scanner can see and the time stamps when the
# got lastly pinged. That way scanned mobs which are closed to each other are
# always stored in the scanner mob that has pinged them at last.
#

proc GetMax {alist} {
  # returns the highest value of a range
  set alist [string trim $alist]
  if {$alist == ""} {return 0}
  set idx [string first ".." $alist]
  if {$idx >- 1} {set alist [string replace $alist $idx [expr $idx+1] " "]}

  if {([llength $alist] == 1) || ([lindex $alist 0] > [lindex $alist 1])
  } then {return [lindex $alist 0]
  } else {return [lindex $alist 1]}
}

proc GetMin {alist} {
  # returns the first element of a range (x OR x..y OR {x y})
  set alist [string trim $alist]
  if {$alist == ""} {return 0}
  set idx [string first ".." $alist]
  if {$idx>-1} {set alist [string replace $alist $idx [expr $idx+1] " "]}
  return [lindex $alist 0]
}

proc GetMobObject {amobid} {
  variable active_mobs
  if ![set ot [GetObjectType $amobid]] {return ""}

  set guid [::GetGuid $amobid]
  if [info exists active_mobs($guid)] {
    set result $active_mobs($guid)
  } else {
    switch -- $ot {
      3 {set result "[namespace current]::[TNpc npc$guid $amobid]"}
      4 {set result "[namespace current]::[TPlayer player$guid $amobid]"}
      default {set result ""}
    }
  }
}

proc LoadAiScp {} {
  set prefix "ai"
  set pending_includes "scripts/ai.scp"
  set processed_includes ""

  while {$pending_includes != ""} {
    set cur_file [lindex $pending_includes 0]
    if [file exists $cur_file] {
      set actions ""
      set tactics ""
      set section ""
      set hfile [open $cur_file]
      while {![eof $hfile]} {
        set line [string trim [gets $hfile]]

        set p [string first "//" $line]
        if {$p > -1} {set line [string range $line 0 [expr $p - 1]]}
        if {$line == ""} continue

        set list_line [string tolower [split $line " "]]
        set li0 [lindex $list_line 0]
        set li1 [lindex $list_line 1]

        if {$li0 == "//"} continue

        if {$li0 == "#include"} {
          if { [file exists $li1] &&
              ([lsearch $pending_includes $li1] < 0 ) &&
              ([lsearch $processed_includes $li1] < 0)} {
            lappend pending_includes $li1
          }
          continue
        }

        # check whether new section
        if {($li0 == "\[$prefix") &&
            [set entryid [string range $li1 0 end-1]] != "" &&
            [string is integer $entryid]
        } {
          if {($section != "") && ($actions != "")} {
            set ::SmartAI::Profiles($section) [list $actions $tactics]
          }
          set actions ""
          set tactics ""
          set section $entryid
          continue
        }

        # check wheter valid content
        set p [string first "=" $line]
        if {($p < 1) || ($section == "")} {continue}

        set key [string tolower [string range $line 0 [expr $p - 1]]]
        set value [string trim [string range $line [expr $p + 1] end]]
        if {$value == ""} continue

        set ktype [string range $key 0 5]
        set knum [string range $key 6 end]
        if ![string is integer -strict $knum] continue

        switch -- $ktype {
          action {lappend actions "$knum $value"}
          tactic {lappend tactics "$knum $value"}
        }
      }
      if {($section != "") && ($actions != "")} {
        set ::SmartAI::Profiles($section) [list $actions $tactics]
      }
      close $hfile
    }
    lappend processed_includes $cur_file
    set pending_includes [lreplace $pending_includes 0 0]
  }
}

body TMob::constructor {amobid} {
  set this_mob_guid [::GetGuid $amobid]
  set this_mob_id $amobid
  set ::SmartAI::active_mobs($this_mob_guid) $this
  UpdateSide
}

body TMob::destructor {} {
  LogMob $this_mob_id "destroying object $this"
  foreach side [concat [array names ::SmartAI::sides] -1] {
    array unset ${this}_nbm$side
    array unset ${this}_nbse$side
  }
  foreach locfac $local_factions {
    array unset ${this}_nbfe$locfac
  }
  if $scanner_enabled {unset ::SmartAI::scanners($this_mob_guid)}
  unset ::SmartAI::active_mobs($this_mob_guid)
}

body TMob::Chat {{lang 0} {msg ""}} {
  if {$msg == ""} {
    set msg $lang
    set lang 0
  } elseif ![string is integer -strict $lang] {
    set lang 0
  }
  if {$msg != ""} {::Say $this_mob_id $lang $msg}
}

body TMob::Cast {spell {target ""}} {
  if {$target == ""
  } then {set target_mob_id $this_mob_id
  } else {set target_mob_id [$target GetMobID]}
  ::CastSpell $this_mob_id $target_mob_id $spell
}

body TMob::DistanceTo {target} {
  set target_id [$target GetMobID]
  if !$target_id {
    set stack_trace [GetStackTrace]
    LogMob $this_mob_id "$this: Error in TMob:DistanceTo for $target, invalid id, stack trace: $stack_trace"
    return 10000
  }
  return [::Distance $this_mob_id [$target GetMobID]]
}

body TMob::Emote {emoteid} {
  # emote 10 (dance) prevents "true" emote states from beeing executed"
  if {$emoteid == 10} {set emote_unlock_needed 1}
  ::Emote $this_mob_id $emoteid
}

body TMob::EmoteState {target emoteid} {
  if $emote_unlock_needed {
    ::Emote $this_mob_id 0
    set emote_unlock_needed 0
  }
  ::EmoteState [$target GetMobID] $this_mob_id $emoteid
}

body TMob::GetAttackers {} {
  UpdateAttackers
  set result ""
  foreach guid $attacker_guids {
    lappend result $::SmartAI::active_mobs($guid)
  }
  return $result
}

body TMob::GetDefeatChance {} {
  set focussed [GetFocussedMob]
  if {$focussed == "" && $attacker_guids == ""} {return 0}
  set cs [clock seconds]
  if {$last_defeat_chance && $cs - $last_dfc_update < 6} {
    LogMob $this_mob_id "returning last_defeat_chance (${last_defeat_chance}%), attackers: $attacker_guids, last_dfc_update: $last_dfc_update"
    return $last_defeat_chance
  }
  foreach {myhp mydmg} [GetPowerStats] break
  if {$myhp < 1} {return 100}
  if {$mydmg < 1} {set mydmg 1}

  set hits 0
  set total_attacker_damage 0

  # check whether a possible focussed player also attacks this mob,
  # for melee attacks must have selected the attacked mob, for spells he
  # will normally also attack the selected mob although it is not 100% sure
  if {$focussed == "" || ![$focussed isa ::SmartAI::TPlayer] ||
      [$focussed GetFocussedMob] != $this ||
      [$focussed GetSide] != [GetSide] && ![NotifyAttacker $focussed]} {
    UpdateAttackers
    # ToDO: sometimes (player dead and then (Ghost) out of range?) UpdateAttackers is not
    # called when needed, resulting in errors:
    # example: can't read "::SmartAI::active_mobs(020F9A)": no such element in array
  }

  foreach guid $attacker_guids {
    if ![info exists ::SmartAI::active_mobs($guid)] continue
    set attacker $::SmartAI::active_mobs($guid)
    foreach {hp dmg} [$attacker GetPowerStats] break
    set hits [expr $hits + int(1 + ($hp / $mydmg))]
    set total_attacker_damage [expr $total_attacker_damage + $hits * $dmg]
  }

  if {$total_attacker_damage == 0} {
    set chance 0
  } else {
    set chance [expr round (50 * $total_attacker_damage / $myhp)]
    if {$chance > 100} {set chance 100
    } elseif {$chance < 0} {set chance 0
    } else {set chance [expr round($chance)]}
  }
  set last_dfc_update $cs
  set last_defeat_chance $chance
  LogMob $this_mob_id "returning defeat_chance: $chance% (50 * $total_attacker_damage / $myhp)"
  return $chance
}

body TMob::GetFaction {} {
  return $this_mob_faction
}

body TMob::GetEntry {} {
  return $this_mob_entry
}

body TMob::GetGuid {} {
  return $this_mob_guid
}

body TMob::GetHealth {} {
  return [::GetHealthPCT $this_mob_id]
}

body TMob::GetLastActivityTime {} {
  return $last_activity
}

body TMob::GetLevel {} {
 return [::GetLevel $this_mob_id]
}

body TMob::GetLocalEnemies {} {
  # returns a list of additonal enemies who have attacked a nearby friend
  # but belong to a side or faction which is normally not hostile but neutral
  set result ""
  if {$nearest_scanner_guid != "" &&
      [info exists ::SmartAI::active_mobs($nearest_scanner_guid)]} {

    set scanner $::SmartAI::active_mobs($nearest_scanner_guid)

    if {$this_mob_side < 0
    } then {set local_enemies ${scanner}_nbfe[GetFaction]
    } else {set local_enemies ${scanner}_nbse[GetSide]}

    foreach guid [array names $local_enemies] {
      if ![info exists ::SmartAI::active_mobs($guid)] continue
      set mob $::SmartAI::active_mobs($guid)
      if {![$mob IsActive] || [$mob IsGhost] || [DistanceTo $mob] > 70} continue
      lappend result $mob
    }
  }
  return $result
}

body TMob::GetMobID {} {
  if {[GetObjectType $this_mob_id] == 0 ||
      [::GetGuid $this_mob_id] != $this_mob_guid
  } then {return 0
  } else {return $this_mob_id}
}

body TMob::GetName {} {
  if {$this_mob_name == ""} {set this_mob_name [::Custom::GetName $this_mob_id]}
  return $this_mob_name
}

body TMob::GetNearbyEnemies {{range 0}} {
  variable ::SmartAI::hostile_sides
  if {$this_mob_side < 0
  } then {
      # mobs which belong to no side (-1) only see players as their enemies
      set result [GetNearbyMobs "0 1"]
      set nbe ""
      foreach mob $result {
        if [$mob isa ::SmartAI::TPlayer] {lappend nbe $mob}
      }
      set result $nbe

  } elseif [info exists hostile_sides($this_mob_side)] {
      set result [GetNearbyMobs $hostile_sides($this_mob_side)]

  } else {set result ""}

  # add additonal enemies who have attacked a nearby friend but belong to a
  # side or faction which is normally not hostile but neutral
  set result [concat $result [GetLocalEnemies]]

  if {$range > 0} {
    set nbe ""
    foreach nbm $result {
      if {[DistanceTo $nbm] <= $range} {lappend nbe $nbm}
    }
    set result $nbe
  }

  return $result
}

body TMob::GetNearbyFriends {{range 0}} {
  set result [GetNearbyMobs $this_mob_side]
  if {$this_mob_side < 0} {
    # if mob belongs to no side, return only nearby mobs of same faction
    set nbf ""
    foreach nbm $result {
      if {[$nbm GetFaction] == [GetFaction]} {lappend nbf $nbm}
    }
    set result $nbf
  }
  # if a range is defined, return only friends in this range
  if {$range > 0} {
    set nbf ""
    foreach nbm $result {
      if {[DistanceTo $nbm] <= $range} {lappend nbf $nbm}
    }
    set result $nbf
  }
  return $result
}

body TMob::GetNearbyMobs {{sides ""}} {
  if {$nearest_scanner_guid == "" ||
      ![info exists ::SmartAI::active_mobs($nearest_scanner_guid)]} {
    return ""
  }
  set scanner $::SmartAI::active_mobs($nearest_scanner_guid)

  # special case: a wildcard at the first postion disables extended checks
  # and returns every detected mob in range if the requested side is matched!
  if {[lindex $sides 0] != "*"} {
    set every_mob 0
  } else {
    set every_mob 1
    set sides [lrange $sides 1 end]
  }

  if {$sides == ""} {
    set sides [concat [array names ::SmartAI::sides] -1]
  } else {

  }
  set sides [join $sides]
  set result ""
  foreach side $sides {
    foreach guid [array names ${scanner}_nbm$side] {
      if {$guid == $this_mob_guid ||
          ![info exists ::SmartAI::active_mobs($guid)]} {
        continue
      }
      # mob must also see dead players of same side for ressurection
      set mob $::SmartAI::active_mobs($guid)
      if !$every_mob {
        if {![$mob IsActive] || [DistanceTo $mob] > 70 ||
            ([$mob IsGhost] && ([$mob isa ::SmartAI::TNpc] ||
                                [$mob GetSide] != [GetSide]))
        } continue
      }
      lappend result $mob
    }
  }
  return $result
}

body TMob::GetNearbyNeutrals {{range 0}} {
  set nbm [GetNearbyMobs]
  set nbf [GetNearbyFriends $range]
  set nbe [GetNearbyEnemies $range]

  set result ""
  foreach mob $nbm {
    if {[lsearch $nbf $mob] == -1 && [lsearch $nbe $mob] == -1 &&
        (!$range || [DistanceTo $mob] <= $range)} {
      lappend result $mob
    }
  }
  return $result
}

body TMob::GetPosition {} {
  return [::GetPos $this_mob_id]
}

body TMob::GetSide {} {
  return $this_mob_side
}

body TMob::HasQFlag {flag} {
  return [::GetQFlag $this_mob_id $flag]
}

body TMob::IsActive {} {
  return [expr {[clock seconds] - $last_activity < 121 && [GetMobID]}]
}

body TMob::IsCivilian {} {
  return $civilian
}

body TMob::IsGhost {} {
  set ot [::GetObjectType $this_mob_id]
  if {((($ot == 3) && ([GetHealth] > 0)) || ($ot == 4)) &&
      ![HasQFlag GhostMode] && ![HasQFlag IsDead]
  } {return 0}
  return 1
}

body TMob::NotifyAttacker {mobobj} {
  set guid [$mobobj GetGuid]
  if {[lsearch $attacker_guids $guid] > -1} {
    set result 0
  } else {
    variable ::SmartAI::hostile_sides
    variable ::SmartAI::active_mobs
    UpdateAttackers
    lappend attacker_guids $guid
    SendLocalEnemy $mobobj
    set last_dfc_update 0
    # Chat "Debug: NotifyAttacker [$mobobj GetName] returned 1"
    set result 1
  }
  return $result
}

body TMob::NotifyFactionEnemy {mobobj faction} {
  if {[lsearch $local_factions $faction] == 1} {lappend local_factions $faction}
  set ${this}_nbfe${faction}([$mobobj GetGuid]) [clock seconds]
}

body TMob::NotifySideEnemy {mobobj side} {
  set ${this}_nbse${side}([$mobobj GetGuid]) [clock seconds]
}

body TMob::ReadyToScan {} {
  return [IsActive]
}

body TMob::RegisterNearbyMob {mobobj} {
  if {$mobobj != $this} {set last_activity [clock seconds]}
  set ${this}_nbm[$mobobj GetSide]([$mobobj GetGuid]) [clock seconds]
}

configbody TMob::scanner_enabled {
  if $scanner_enabled {
    set ::SmartAI::scanners($this_mob_guid) $this
    set nearest_scanner_guid [GetGuid]
  } elseif [info exists ::SmartAI::scanners($this_mob_guid)] {
    unset ::SmartAI::scanners($this_mob_guid)
  }
}

body TMob::ScannerPing {from} {
  $from RegisterNearbyMob $this
  set last_activity [clock seconds]
  # Chat "Debug: I got Scanner Ping from [$from GetName]"
  if {[$from GetGuid] != $nearest_scanner_guid &&
      ($nearest_scanner_guid == "" ||
       ![info exists ::SmartAI::active_mobs($nearest_scanner_guid] ||
       [DistanceTo $nearest_scanner_guid] > [DistanceTo $from])
  } {
    set local_enemies [GetLocalEnemies]
    set nearest_scanner_guid [$from GetGuid]
    # announce known local enemies to new scanner
    foreach local_enemy $local_enemies {SendLocalEnemy $local_enemy}
  }
  foreach attacker [GetAttackers] {SendLocalEnemy $attacker}
}

body TMob::SendLocalEnemy {mobobj} {
  # checks and if needed notifys an attacker as local enemy to current scanner
  if {[$mobobj isa ::SmartAI::TNpc] &&
      ($this_mob_side < 0 && [$mobobj GetFaction] == [GetFaction] ||
       $this_mob_side > -1 && [$mobobj GetSide] == [GetSide])} {
    # to prevent chain reactions, allied NPCs must never attack each other
    return
  }
  variable ::SmartAI::hostile_sides
  variable ::SmartAI::active_mobs
  if ![info exists active_mobs($nearest_scanner_guid)] return
  if {$this_mob_side < 0 || ![info exists hostile_sides($this_mob_side)] ||
      [lsearch $hostile_sides($this_mob_side) [$mobobj GetSide]] == -1} {
    set scanner $active_mobs($nearest_scanner_guid)
    if {$this_mob_side < 0
    } then {$scanner NotifyFactionEnemy $mobobj [GetFaction]
    } else {$scanner NotifySideEnemy $mobobj [GetSide]}
  }
}

body TMob::SendScanImpuls {} {
  # this mob will send a special "impuls" which hits all nearby mobs which
  # then will add this mob as their current scanner, so they will see what
  # this mob sees without having to "scan" themselves, note that only mobs
  # (normally only players) which are marked as "scanners" will send such
  # an impuls regulary
  set nearest_scanner_guid $this_mob_guid
  set cs [clock seconds]
  # cleanup namespace global arrays of nearby mobs which belong this mob object
  foreach side [concat [array names ::SmartAI::sides] -1] {
    # check nearby mobs of each side
    foreach nbm_guid [array names ${this}_nbm$side] {
      if {$cs - [set ${this}_nbm${side}($nbm_guid)] > 59} {
        unset ${this}_nbm${side}($nbm_guid)
      }
    }
    # check nearby temporary enemies for each side
    foreach nbse_guid [array names ${this}_nbse$side] {
      if {$cs - [set ${this}_nbse${side}($nbse_guid)] > 59} {
        unset ${this}_nbse${side}($nbse_guid)
      }
    }
  }
  # cleanup temporary local enemies
  foreach faction $local_factions {
    foreach nbfe_guid [array names ${this}_nbfe$faction] {
      if {$cs - [set ${this}_nbfe${faction}($nbfe_guid)] > 59} {
        unset ${this}_nbfe${faction}($nbfe_guid)
      }
    }
  }
  RegisterNearbyMob $this
  Cast $::SmartAI::scan_spell
}

body TMob::SetFaction {newfaction} {
  set this_mob_faction $newfaction
  ::SetFaction $this_mob_id $newfaction
  UpdateSide
}

body TMob::UpdateAttackers {} {
  set new_attackers ""
  foreach guid $attacker_guids {
    if {[info exists ::SmartAI::active_mobs($guid)] &&
        ![[set attacker $::SmartAI::active_mobs($guid)] IsGhost] &&
        [DistanceTo $attacker] <= 60 && [$attacker GetFocussedMob] == $this} {
      lappend new_attackers $guid
    }
  }
  set attacker_guids $new_attackers
}

body TMob::UpdateMob {} {
  set last_activity [clock seconds]
}

body TMob::UpdateSide {} {
  return
}

body TNpc::constructor {amobid} {

  # load creature stats
  set this_mob_entry [::GetEntry $amobid]
  set creature "creature [GetEntry]"
  set civilian [expr {[::Custom::GetCivilian $amobid] &&
                      ![::Custom::GetElite $amobid] &&
                      [lsearch $::SmartAI::guard_entries [GetEntry]] == -1}]

  set section "creature [GetEntry]"
  set max_hitpoints [GetScpValue creatures.scp $section maxhealth]
  if ![string is integer -strict $max_hitpoints] {
    set max_hitpoints [expr [GetLevel] * 80]
  }

  set dmg [join [GetScpValue creatures.scp $section damage]]
  set mindmg [lindex $dmg 0]
  set maxdmg [lindex $dmg 1]
  if ![string is double -strict $mindmg] {
    set mindmg [expr [GetLevel] * 10]
  }
  if {![string is integer -strict $maxdmg] || $mindmg > $maxdmg} {
    set maxdmg $mindmg
  }
  set average_damage [expr round(($mindmg + $maxdmg) / 2)]

  set combat_reach [join [GetScpValue creatures.scp $section combat_reach]]
  if {![string is double -strict $combat_reach]
  } then {set combat_reach 1
  } else {set combat_reach [expr {round($combat_reach)}]}

  set bounding_radius [GetScpValue creatures.scp $section bounding_radius]
  if {![string is double -strict $bounding_radius]
  } then {set bounding_radius 1
  } else {set bounding_radius [expr {round($bounding_radius)}]}

  if {$combat_reach < $bounding_radius} {set combat_reach $bounding_radius}

  set elite [::Custom::GetElite $this_mob_id]
  if ![string is digit -strict $elite] {set elite 0}
  switch -- $elite {
    0 {set loop_delay 2}
    1 {set loop_delay 1}
    2 -
    3 -
    4 {set loop_delay 0; configure -scanner_enabled 1}
    default {set loop_delay 2}
  }

  # max_aggroable_level = level + x with level&x: -5: 1*5, 10: 2*5, 25: 3*5 etc.
  # set max_aggroable_level [expr (4*[GetLevel] + 20) / 3]
  set max_aggroable_level [expr [GetLevel] + ([GetLevel] + 20) / 15 * 5]

  if $elite {
    if {$elite > 1
    } then {set max_aggroable_level 255
    } else {incr max_aggroable_level 10}
  }

  # load AI profile (actions and tactics) if any
  set actlist ""
  set taclist ""
  set profile ""
  set profile_id [join [GetScpValue creatures.scp $creature "aiprofile"]]

  if {[string is integer -strict $profile_id] &&
      [info exists ::SmartAI::Profiles($profile_id)]
  } then {
      set profile $::SmartAI::Profiles($profile_id)
  } elseif [info exists ::SmartAI::Profiles([GetEntry])] {
      set profile $::SmartAI::Profiles([GetEntry])
  }
  if {$profile != ""} {
    set actlist [lindex $profile 0]
    set taclist [lindex $profile 1]
  }

  # try loading actions from creatures.scp if none defined yet
  if {$actlist == ""} {
    set n 0
    set last_num 0
    while {$n < $last_num+2} {
      set action [join [GetScpValue creatures.scp $creature "action$n"]]
      if {$action !=""} {
        lappend actlist "$n $action"
        set last_num $n
      }
      incr n
    }
  }

  # creature actual action objects depending on type
  foreach action $actlist {
    foreach {n action_type ag1 ag2 txt} $action {break}

   	switch -- $action_type {
       0 {set action_constructor ::SmartAI::TSpellAction}
       1 {set action_constructor ::SmartAI::TTextAction}
       2 {set action_constructor ::SmartAI::TEmoteAction}
       3 {set action_constructor ::SmartAI::TPauseAction}
       4 {set action_constructor ::SmartAI::TScriptAction}
       5 {set action_constructor ::SmartAI::TCallForHelpAction}
       6 {set action_constructor ::SmartAI::TSwitchTacticAction}
       7 {set action_constructor ::SmartAI::TNewTargetAction}
       8 {set action_constructor ::SmartAI::TDespawnAction}
       9 {set action_constructor ::SmartAI::TSetFactionAction}
      10 {set action_constructor ::SmartAI::TSetWayPointAction}
      11 {set action_constructor ::SmartAI::TTeleportAction}
      default {set action_constructor ""}
    }
    if {$action_constructor != ""} {
      set actobj [$action_constructor #auto $this $n $ag1 $ag2 $txt]
    }

    # a fully qualified name is required for external use of these objects
    lappend actions "[namespace current]::$actobj"

  }

  # if still no actions are defined, look for the "classical" spell(s) key
  # and auto-generate standard spell actions based on that
  if {$actions == ""} {
    set spells [join [GetScpValue creatures.scp $creature "spell"]]
    if {$spells == ""} {
      set spells [join [GetScpValue creatures.scp $creature "spells"]]
    }
    if {$spells != ""} {
      foreach spellid $spells {
        set num 0
        foreach {ctime cooldown duration range} [GetSpellData $spellid] break
        # args1: pri tsel ttype range charges dur cdwn treqs next_aaction
        set args1 [list 0 0 1 $range 0 $duration $cooldown]
        set args2 $spellid
        set txt ""
        set actobj [::SmartAI::TSpellAction #auto $this $num $args1\
                                            $args2 $txt]
        lappend actions "[namespace current]::$actobj"
      }
    }
  }

  # load and process tactics
  if {$taclist == ""} {
    set num 0
    set last_num 0
    while {$num < $last_num+2} {
      set tac [join [GetScpValue creatures.scp $creature "tactic$num"]]
      if {$tac != ""} {
        lappend taclist "$num $tac"
        set last_num $num
      }
      incr num
    }
  }

  foreach tac $taclist {
    foreach {tacid tactype tac_actions params atext} $tac {break}

    # use only existing actions ids for the new tactic
    set aobjs ""
    foreach actid $tac_actions {
      foreach actobj $actions {
        if {$actid == [$actobj GetActionID]} {
          lappend aobjs $actobj
          break
        }
      }
    }

    set tacobj [::SmartAI::TNpcTactic #auto $this $tacid $tactype $aobjs\
                                      $params $atext]
    lappend tactics [namespace current]::$tacobj
  }

  # if still no tactis are defined but actions exist, create a standard tactic
  # of type random
  if {($tactics == "") && ($actions != "")} {
    set aobjs $actions
    set tacobj [::SmartAI::TNpcTactic #auto $this 0 0 $aobjs]
    lappend tactics $tacobj
  }
  set default_aggro_dist $::SmartAI::default_aggro_dist

  if {$tactics != ""} {
    foreach tactic $tactics {
      if {[$tactic cget -aggro_dist] < $default_aggro_dist} {
        set default_aggro_dist [$tactic cget -aggro_dist]
      }
    }
  }
  #override possible AI scripts if they don't exist or the NPC has an ai-profile
  set aiscript [::Custom::GetCreatureScp $this_mob_entry "aiscript"]
  if {$aiscript != "" } {
    if {$tactics == ""} {
      # if npc has no ai-profile and the aiscript doesn't exist, use default CC
      if {[info procs "::${aiscript}::CanCast" ] == ""} {
        namespace eval ::${aiscript} {
		      proc CanCast {npc victim} {return [::AI::CanCast $npc $victim]}
		    }
		  }
    } else {
      # if an AI-profile exists, the aiscript key is ignored in any case
      namespace eval ::${aiscript} {
		    proc CanCast {npc victim} {return 0}
		  }
		}
  }
  ActivateNextTactic
  UpdateMob
  lappend ::SmartAI::objects $this
}

body TNpc::destructor {} {
  set current_tactic ""
  foreach tactic $tactics {delete object $tactic}
  foreach action $actions {delete object $action}
  if {($last_paralysed > 0) && ([GetObjectType $this_mob_id] == 3)} {
    ::CastSpell $this_mob_id $this_mob_id 8747
  }
  TMob::destructor
}

body TNpc::ActivateTactic {tactic} {
  set current_tactic $tactic
  LogMob $this_mob_id "activating new tactic: $tactic"

  if {$current_tactic != ""} {
    $current_tactic Activate

    if {[$current_tactic GetReqBattleState] > 0 && ![GetBattleStart]} {
      StartBattle
    } elseif {[$current_tactic GetReqBattleState] < 0 && [GetBattleStart]} {
      StopBattle
    }
    set aggro_dist [$current_tactic cget -aggro_dist]
    set unaggro_dist [$current_tactic cget -unaggro_dist]
    set current_kdist [$current_tactic cget -keep_dist]
    set result 1
  } else {
    set aggro_dist $default_aggro_dist
    set unaggro_dist $default_aggro_dist
    if $aggro_dist {incr unaggro_dist 10}
    set current_kdist 0
    set result 0
  }

  if {($current_kdist < 1) && ($last_paralysed > 0)} {
    Cast 8747
    set last_paralysed 0
  }
  return $result
}

body TNpc::ActivateNextTactic {} {
  # initializes and activates next tactic, returns 1 if sucessfull, 0 otherwise
  set next_tactic ""
  if {$current_tactic != ""} {
    set next_tacid [$current_tactic cget -next_tactic_id]
    foreach tactic $tactics {
      if {[$tactic GetTacID] == $next_tacid} {
        if [$tactic IsAvailable] {set next_tactic $tactic}
        break
      }
    }
  }
  if {$next_tactic == ""} {
    set current_tactic ""
    set best_tactics [GetBestTactics]
    if {$best_tactics != ""} {
      set idx [expr {int(rand()*[llength $best_tactics])}]
      set next_tactic [lindex $best_tactics $idx]
    }
  }

  set last_tac_check [clock seconds]
  ActivateTactic $next_tactic
}

body TNpc::CanAggro {mobobj} {
  set cs [clock seconds]
  set last_activity $cs

  if {[IsCivilian] || $paused_until < 0 || $cs < $paused_until ||
      [$mobobj GetLevel] > $max_aggroable_level || ![GetHealth]} {
    return 0
  }

  if {$mobobj == $this} {
    LogMob $this_mob_id "Error for ${this}::CanAggro: Can't attack self!"
    return 0
  }

  # aggro only one target at a time, note that the emu all nearby players
  # either puts in CanAggro or CanUnAggro request, no matter whether the NPC
  # is already attacking a target!

  set result 0
  if {[GetFocussedMob] == "" || $new_aggro_time > 0 && $cs > $new_aggro_time} {
    set result [expr {![$mobobj IsGhost] && ([GetNextTarget] == $mobobj ||
                       [DistanceTo $mobobj] <= $aggro_dist)}]

    # prevent that all mobs attack a nearby enemy mob at the same time
    if {$result && [$mobobj GetDefeatChance] > 79} {
      # LogMob $this_mob_id "aggro rejected: [DistanceTo $mobobj]\
      #  <= $aggro_dist ghost [$mobobj IsGhost] dfc: [$mobobj GetDefeatChance]%"
      set result 0
    }

    set old_dfc [$mobobj GetDefeatChance]
    set helping 0

    if {$result && [GetNextTarget] == $mobobj &&
        [DistanceTo $mobobj] > $aggro_dist &&
        [$mobobj isa ::SmartAI::TPlayer]} {
      set helping 1
    }

    if {$battle_start_time == 0} {
      if {$result || [GetHealth] < 100} {
        StartBattle

        # if mob got attacked but no attacker is known, check for nearby pets,
        # for now just for neutral or hostile NPCs of side 0 or 1
        if !$result {
          set nbmobs [GetNearbyMobs {0 1}]
          set attacker ""
          set attacker_dist 50
          foreach nbmob $nbmobs {
            if {[$nbmob GetSide] != $this_mob_side  &&
                [set dist [DistanceTo $nbmob]] < $attacker_dist} {
              set attacker $nbmob
              set attacker_dist $dist
            }
          }
          if {$attacker != ""} {SetNewTarget $attacker}
        }

      }
    } elseif {$cs - $last_aggroed > 59 && [GetHealth] == 100} {
        StopBattle
    }
    if $result {SetNewTarget $mobobj}

  } elseif {($new_aggro_time == 0) && ($cs - $last_aggroed > 2)} {
    set new_aggro_time [expr $cs + 2]
  }
  if {$cs - $last_loop_time >= 2} ProcessTactic
  return $result
}

body TNpc::CanCastSpell {spell {target ""}} {
  # don't cast any non-paralyse spells during chase if having a keep_dist > 0
  # to prevent blocking of paralyse spells when target gets too close
  if {$chasing && $spell != 23973} {return 0}

  # stack, cooldown and (optional) range check for spell
  if {[lsearch $pending_spells $spell] > -1} {return 0}

  # resurrect spell can be casted at dead players of own side
  if {$target != "" && [DistanceTo $target] > [GetSpellRange $spell] ||
      ([$target IsGhost] && ([$target isa ::SmartAI::TNpc] ||
                             [$target GetSide] != [GetSide]))
  } {
    return 0
  }

  set result 1

  foreach {spellid next_time} $spell_cooldowns {
    if {$spellid == $spell} {
      if {[clock seconds] < $next_time} {set result 0}
      break
    }
  }
  return $result
}

body TNpc::CanUnAggro {mobobj} {
  set cs [clock seconds]
  set last_activity $cs
  set result 0
  if {$paused_until < 0 || $cs < $paused_until} {return 0}

  # process tactic or perform default melee casting if possible
  if {$cs - $last_loop_time >= $loop_delay && ![ProcessTactic] &&
      [info exists ::AI::MELEE_SPELL_CASTING] && $::AI::MELEE_SPELL_CASTING &&
      rand() < 0.2 && [GetHealth]} {

		set aiscript [::Custom::GetCreatureScp $this_mob_entry "aiscript"]
		if {[info procs "::${aiscript}::CanCast"] == "" } {
			set aiscript "AI"
		}
		set spellid [::${aiscript}::CanCast $this_mob_id [$mobobj GetMobID]]
		if $spellid {Cast $spellid $mobobj}
  }

  set dist [DistanceTo $mobobj]
  set mob_is_ghost [$mobobj IsGhost]
  set focussed_mob [GetFocussedMob]

  if {$mobobj == [GetNextTarget]} {
    if {($dist < 20) || $mob_is_ghost} {SetNextTarget ""}
  } else {
    if {($dist >= $unaggro_dist)} {set result 1}
  }
  # check whether ghost or minion of the attacked mob (e.g. pet of player)
  if {!$result && ($mob_is_ghost ||
       [GetLinkObject $this_mob_id] == [$mobobj GetMobID])} {
    set result 1
  }

  # the mob's focus should always be (only) the actual (melee) attacked target
  if $result {
    if {$focussed_mob == $mobobj} {
      # Say $this_mob_id 0 "Unaggroing $mobobj at dist [DistanceTo $mobobj]m"
      SetFocus ""
      set new_aggro_time 0
      set last_aggroed $cs

      UpdateAttackers

      set idx [lsearch $attacker_guids [$mobobj GetGuid]]
      if {$idx > -1} {set attacker_guids [lreplace $attacker_guids $idx $idx]}
      if {$attacker_guids != ""} {
        SetNewTarget $::SmartAI::active_mobs([lindex $attacker_guids 0])
      }

      if {$focussed_guid == ""} {
        # deparalyse self if needed but a bit delayed as a new target may
        # get in range in the next seconds
        if {$last_paralysed > 0} {
          ClearSpellStack
          if {$cast_complete_time < $cs
          } then {set cast_complete_time [expr $cs + 2]
          } else {incr cast_complete_time 2}
          Cast 8747
        }
      }
    } else {
      if [$mobobj isa ::SmartAI::TPlayer] {NotifyAttacker $mobobj}
    }
  } else {
    if {$battle_start_time == 0} {StartBattle}
    if {$focussed_mob == $mobobj} {
       if {$current_kdist == 0 &&
           $cs - $last_recharge > 10 && [GetHealth] > 0 &&
           [DistanceTo $focussed_mob] > $melee_range &&
           ([$focussed_mob isa ::SmartAI::TNpc] || [GetLinkObject $this_mob_id])
        } {
          # Chat "Debug: re-charging [$focussed_mob GetGuid]"
          # $focussed_mob Chat "Debug: Yeah, Charge me!"
          if [$focussed_mob isa ::SmartAI::TNpc] {
            $focussed_mob NotifyRecharge $this
          }
          Cast $::SmartAI::charge_spell $focussed_mob
          # to prevent npc from running back after charging over long dists,
          # pause him for 5s after charging
          if {[DistanceTo $focussed_mob] > 25} {Cast 7950}
          set last_recharge $cs
        }
        set new_aggro_time 0
        set last_aggroed $cs
    } elseif {($focussed_mob == "") ||
              ($new_aggro_time > 0) && ($cs > $new_aggro_time)} {
        SetNewTarget $mobobj
    } else {
       set new_aggro_time [expr $cs + 2]
       if [$mobobj isa ::SmartAI::TPlayer] {NotifyAttacker $mobobj}
    }
    CheckKeepDist
  }
  return $result
}

body TNpc::Cast {spell {target ""}} {
  if {[llength $pending_spells] > 15} then {
    LogMob $this_mob_id "Warning: SpellStack limit reached: $pending_spells"
    return 0
  }

  if {$target == ""
  } then {set target_guid $this_mob_guid
  } else {set target_guid [$target GetGuid]}

  LogMob $this_mob_id "Cast called with $spell for target $target_guid,\
    currently pending_spells: $pending_spells pending_spell_targets:\
    $pending_spell_targets"

  lappend pending_spells $spell
  lappend pending_spell_targets $target_guid
  ProcessSpellStack
}

body TNpc::ClearSpellStack {} {
  set pending_spells ""
  set pending_spell_targets ""
}

body TNpc::CheckKeepDist {} {
  # check for Distance to keep
  if {$current_kdist > 0} {
    if {![FocusOutOfRange]} {
      set chasing 0
      set unpara_count 0
      # "abuse" spell 23973 to "permanently" paralyse the npc, this can only by
      # reverted on expiration of some other paralyse spells and some swimspeed
      # buffs (e.g. 13 and 8747) therefore the npc must explictly be "freed"
      # after end of tactic
      set cs [clock seconds]
      if {$cs - $last_paralysed > $::SmartAI::pararef_interval} {
        # Say $this_mob_id 0 "pausing myself at dist: [Distance $this_mob_id $focussed_mob]"
        Cast 23973
        set last_paralysed [clock seconds]
      }
    } elseif {$unpara_count < 3} {
      # if target gets out of range, try to abort current paralyse,
      # try this again if it for some reason fails for the first time, for
      # example because of currently casting another spell but note that
      # the position check performed here may not be very accurate as the emu
      # seems sometimes to "teleport" the mob directly to the destination
      # position while the client shows a walking animation of the mob,
      # therefore attempt unparalysing only twice
      set chasing 1
      # wait until spell stack is empty as there may be charge spells on it
      # which take the mob close enough to target
      if {$pending_spells == ""} {
        # Say $this_mob_id 0 "Distance: [Distance $this_mob_id $focussed_mob]"
        # Say $this_mob_id 0 "lpara vor: [expr [clock seconds] - $last_paralysed] s"

        set cur_pos [GetPosition]
        if {$cur_pos != $last_pos} {
          set last_moved [clock seconds]
          set last_pos $cur_pos
        }

        if {($last_paralysed > 0) || ([clock seconds] - $last_moved > 5)}  {
          # Say $this_mob_id 0 "[clock format [clock seconds] -format %k:%M:%S]: Using pause breakfree1"
          # "abuse" spell 13 or 8747 to break the paralyse
          Cast 8747
          set last_paralysed 0
          set last_pos ""
          incr unpara_count
        }
      }
    }
  }
}

body TNpc::FocusOutOfRange {} {
  if {$current_tactic == "" || [set focussed_mob [GetFocussedMob]] == "" ||
      $current_kdist == 0 || [DistanceTo $focussed_mob] <= $current_kdist} {
    return 0
  }
  return 1
}

body  TNpc::GetActions {} {
  return $actions
}

body TNpc::GetBattleStart {} {
  return $battle_start_time
}

body TNpc::GetCurrentTactic {} {
  return $current_tactic
}

body TNpc::GetCombatReach {} {
  return $combat_reach
}

body TNpc::GetElite {} {
  return [::Custom::GetElite $this_mob_id]
}

body TNpc::GetFocussedMob {} {
  if {$focussed_guid == "" ||
      ![info exists ::SmartAI::active_mobs($focussed_guid)]
  } then {return ""
  } else {return $::SmartAI::active_mobs($focussed_guid)}
}

body TNpc::GetNextTarget {} {
  if {$next_target_guid == "" || [clock seconds] - $next_target_ts > 180 ||
      ![info exists ::SmartAI::active_mobs($next_target_guid)]
  } then {return [set next_target_guid ""]
  } else {return $::SmartAI::active_mobs($next_target_guid)}
}

body TNpc::GetLink {} {
  return [::SmartAI::GetMobObject [::GetLinkObject $this_mob_id]]
}

body TNpc::GetPaused {} {
  return $paused_until
}

body TNpc::GetPowerStats {} {
  # estimated npc power
  set hitpoints [expr round([GetHealth] / 100.0 * $max_hitpoints)]
  return [list $hitpoints $average_damage]
}

body TNpc::GetSpellCastTime {spellid} {
  foreach {cast_time cooldown duration range} [GetSpellData $spellid] break
  return [expr ceil($cast_time)]
}

body TNpc::GetSpellData {spellid} {
  # returns spell data as list: cast_time cooldown duration range
  if {[set idx [lsearch $cached_spell_ids $spellid]] > -1} {
    set result [lindex $cached_spell_infos $idx]
  } else {
     set result ""     
     if [info exists ::AI::SpellData($spellid)] {
       set spelldata [lrange $::AI::SpellData($spellid) 0 3]       
       foreach value $spelldata {
         set value [expr int(ceil($value))]
         # not possible to cast a spell in 0 seconds...
         if {$result == "" && $value < 1} {set value 1}
         lappend result $value
       }
     }
     if {[llength $result] < 4} {set result {1 15 0 50}}
     
     if {[llength $cached_spell_ids] > 9} {
       set cached_spell_ids [lreplace $cached_spell_ids 0 0]
       set cached_spell_infos [lreplace $cached_spell_infos 0 0]
     }
     lappend cached_spell_ids $spellid
     lappend cached_spell_infos $result
  }
  return $result
}

body TNpc::GetSpellRange {spellid} {
  foreach {cast_time cooldown duration range} [GetSpellData $spellid] break
  return $range
}

body TNpc::HasTactics {} {
  return [expr {$tactics != ""}]
}

body TNpc::Idle {} {
  # if mob has nothing to do, its idle tactic must be processed or if a battle
  # tactic is still active, it must be checked wheter it can be ended
  if {$current_tactic != "" && [clock seconds] - $last_loop_time > 1} {
    if {$battle_start_time && [GetHealth] == 100} {StopBattle}
    ProcessTactic
  }
}

body TNpc::IsTurnBlocked {} {
  return 0
  # if a turn-by-turn link to other NPCs has been established,
  # check whether it is the current NPC's turn or not
  # if {$turn_links == ""} {return 0}
  # set new_turn_links ""
  # foreach guid $turn_links {
   #  if ![info exists active_mobs($guid)] continue
   # set link $active_mobs($guid)
   # if {[DistanceTo $link] > 60 || [$link IsGhost]} continue
   # lappend turn_links $new_turn_links

  # }
  #set turn_links $new_turn_links
}

body TNpc::NotifyAttacker {mobobj} {
  set result [TMob::NotifyAttacker $mobobj]
  if $result {
    set focussed [GetFocussedMob]
    if {$focussed == "" || [$focussed GetFocussedMob] != $this} {
      SetNewTarget $mobobj
    }
  }
  return $result
}

body TNpc::NotifyRecharge {mobobj} {
  # to prevent that NPCs re-charge each other at the same time
  if {$mobobj == [GetFocussedMob]} {
    set last_recharge [clock seconds]
  }
}

body TNpc::ScannerPing {from} {
  TMob::ScannerPing $from
  if ![GetBattleStart] Idle
}

body TNpc::SetFocus {{mobobj ""}} {
  if {$mobobj == ""
  } then {set focussed_guid ""
  } else {set focussed_guid [$mobobj GetGuid]}
}

body TNpc::SetNextTarget {target} {
  if {$target == ""} {
    set next_target_guid ""
  } else {
    set next_target_guid [$target GetGuid]
    set next_target_ts [clock seconds]
  }
}

body TNpc::SwitchTactic {tacid} {
  # enforces the activation of a specific tactic
  foreach tactic $tactics {
    if {[$tactic GetTacID] == $tacid} {
      ActivateTactic $tactic
      return
    }
  }
}

body TNpc::GetBestTactics {} {
  # Returns the list of available tactics that have a higher priority
  # than the current one.
  set highest_tacpri 0
  set avail_tactics ""
  set highest_tactics ""
  foreach tactic $tactics {
    if [$tactic IsAvailable] {
      lappend avail_tactics $tactic
      set tacpri [$tactic cget -priority]
      if {$tacpri > $highest_tacpri} {set highest_tacpri $tacpri}
    }
  }
  if {($current_tactic == "") ||
      ($highest_tacpri > [$current_tactic cget -priority])
  } then {
    foreach tactic $avail_tactics {
      if {[$tactic cget -priority] == $highest_tacpri} {
        lappend highest_tactics $tactic
      }
    }
  }
  return $highest_tactics
}

# npc "main action loop"
body TNpc::ProcessTactic {} {
  set last_loop_time [clock seconds]

  # perform no actions anymore if mob's health is below 1%, there is
  # no way to exactly tell whether a mob is dead or not especially as it still
  # gets aggro events, so if it is below 1% health, it simply will do melee
  # only until it is dead or the battle ends
  if {[GetHealth] == 0} {
    if {($last_paralysed > 0) && ($paused_until == 0)} {
      ClearSpellStack
      set last_paralysed 0
      Cast 8747
    }
    return 1
  }
  ProcessSpellStack

  if {$tactics == ""} {return 0}

  # check wheter a new tactic with higher priority can get active
  if {[clock seconds] - $last_tac_check > 3} {
    set best_tactics [GetBestTactics]

    if {$best_tactics != ""} {
      set idx [expr {int(rand()*[llength $best_tactics])}]
      set tactic [lindex $best_tactics $idx]
      ActivateTactic $tactic
    }
    set last_tac_check [clock seconds]
  }

  set perform_result 0
  if {($current_tactic == "") ||
      (![set perform_result [$current_tactic PerformNextAction]])} {
    if {$current_tactic != ""} {
      puts "debug: perform failed, changing tactic"
      # if the tactic was activated by a quest script, unlock the NPC
      # now that it can continue it's or current task or just move on
      if {[$current_tactic cget -time_frame] == -4} {
        SetQFlagData $this_mob_id locked_until 0
      }
    }
    set perform_result [ActivateNextTactic]
  }
  return 1
}

body TNpc::Pause {{seconds -1}} {
  # eval "::Say $this_mob_id 0 \"pausing...\""
  ClearSpellStack
  Cast 23973
  set paused_until -1
}

body TNpc::ProcessSpellStack {} {
  set cs [clock seconds]
  if {$pending_spells == "" || [clock seconds] < $cast_complete_time ||
      $cs - $::SmartAI::last_retcl < 4} {
    return
  }

  set target ""
  while {$target == "" && $pending_spells != ""} {
    set spell [lindex $pending_spells 0]
    set spell_target [lindex $pending_spell_targets 0]
    set pending_spells [lreplace $pending_spells 0 0]
    set pending_spell_targets [lreplace $pending_spell_targets 0 0]

    if [info exists ::SmartAI::active_mobs($spell_target)] {
      set target $::SmartAI::active_mobs($spell_target)
      foreach {cast_time cdown duration range} [GetSpellData $spell] break
      if {$cast_time < 1} {set cast_time 1}
      set cast_complete_time [expr [clock seconds] + $cast_time + 1]
      lappend spell_cooldowns [list $spell [expr {$cast_complete_time+$cdown}]]
      # puts "[clock format [clock seconds] -format %k:%M:%S]\
      LogMob $this_mob_id "Now Casting: CastSpell $this_mob_id [$target GetMobID] $spell"
      ::CastSpell $this_mob_id [$target GetMobID] $spell
    }
  }
}

body TNpc::SetNewTarget {target} {
  set cs [clock seconds]
  set chasing 0
  set charged 0
  SetFocus $target

  if {$target == ""} {
    set melee_range $combat_reach
  } else {
    if [$target isa ::SmartAI::TPlayer] {
      LogMob $this_mob_id "NewTarget: [::GetName [$target GetMobID]]"
      set melee_range [expr $combat_reach + 1]
    } else {
      set melee_range [expr $combat_reach + [$target GetCombatReach]]
      LogMob $this_mob_id "NewTarget: [$target GetGuid]"
    }

    # to make sure that the current aggroed focus is also the actual attacked
    # melee target, let the mob do a charge at its new focus, unless it was
    # definitly idle in the last time
    if {$cs - $last_aggroed < 30 || $cs - $::SmartAI::last_retcl < 10 ||
        [$target isa ::SmartAI::TNpc] && [$target GetFocussedMob] != $this} {
      Cast $::SmartAI::charge_spell $target
      # Chat "debug: Charging to $target"
      set charged 1
    }

    if {$current_kdist > 0} {
      if {$cs - $last_paralysed > $::SmartAI::pararef_interval} {
        Cast 23973
        set last_paralysed [clock seconds]
      }
      # in case of caster with higher keep dist, blink away from target after
      # charging it to get Distance
      if {$charged && $current_kdist > 19 && [DistanceTo $target] < 30} {
        Cast 21655
      }
    }
    # Chat "DEBUG: telling [$target GetName] that it is attacked by me, [GetName]"
    $target NotifyAttacker $this
  }
  set new_aggro_time 0
  set last_recharge $cs
  set last_aggroed $cs
}

body TNpc::SetWP {wp_id} {
  ::SetWayPoint $this_mob_id $wp_id
}

body TNpc::StartBattle {} {
  set battle_start_time [clock seconds]
  set last_aggroed [clock seconds]; # prevent switching back at once
  if {$current_tactic == "" || [$current_tactic GetReqBattleState] < 0} {
    ActivateNextTactic
  }
}

body TNpc::StopBattle {} {
  set battle_start_time 0
  if {$current_tactic != "" && [$current_tactic GetReqBattleState] > 0}  {
    set current_tacic ""
  }

  if {$current_tactic == "" || [$current_tactic GetActions] == ""
  } then {set locked_actions ""
  } else {set locked_actions [$current_tactic GetActions]}

  foreach action $actions {
    if {[lsearch $locked_actions $action] == -1} {$action Reset}
  }

  foreach tactic $tactics {
    if {$tactic != $current_tactic} {$tactic Reset}
  }
  ClearSpellStack
  if {$current_tactic == ""} ActivateNextTactic
}

body TNpc::Unpause {} {
  # external_free: the actual re-mobilizing will be done external
  # eval "::Say $this_mob_id 0 \"unpausing...\""
  set paused_until 0
  if {!$current_kdist || [FocusOutOfRange]} {Cast 8747}
}

body TNpc::UpdateSide {} {
  if !$this_mob_faction {
    set this_mob_faction [::Custom::GetFaction $this_mob_id]
  }

  if {[set link [::GetLinkObject $this_mob_id]] &&
      [::GetObjectType $link] == 4} {
    # in case of pet, set faction and side to the same of its owner
    set owner [::SmartAI::GetMobObject $link]
    set this_mob_side [$owner GetSide]
    # as player factions are "unreliable" but the pet must have a faction
    # that will not take damage from AoE spells, we simply change the faction
    # the either Stormwind (11) or Orgrimmar (85)
    if {$this_mob_side == 0
    } then {set this_mob_faction 11
    } else {set this_mob_faction 85}
    ::SetFaction $this_mob_id $this_mob_faction
    # Chat "My Side is now $this_mob_side and my faction is $this_mob_faction"
    return
  }

  foreach side [array names ::SmartAI::sides] {
    set faction_list $::SmartAI::sides($side)
    if {[lsearch $faction_list [GetFaction]] > -1} {
      set this_mob_side $side
      break
    }
  }
}

body TNpcAction::constructor {anpc_object aaction_id args special {atext ""}} {

  # Keep this class from being instantiated.
  if {[namespace tail [info class]] == "TNpcAction"} {
   	error "Error: can't create TNpcAction objects - abstract class."
  }

  # Verify that the derived class has implemented the
  # "Execute" method -  this simulates abstract methods
  if {[$this info function "Execute" -body] == ""} {
	  error "Error: method 'Execute' undefined."
  }

  set action_id $aaction_id
  set this_npc $anpc_object
  set this_mob_id [$this_npc GetMobID]
  set this_mob_side [$this_npc GetSide]
  set text $atext

  foreach {priority target_selector target_type range charges duration cooldown
           target_reqs own_reqs next_action_id} $args {
    break
  }

  # target reqs must exists (but can be empty string {} ),
  # if own_reqs are defined otherwise it can be omitted
  if [string is integer -strict $target_reqs] {
    set next_action_id $target_reqs
    set target_reqs ""
    set own_reqs ""
  }

  if {[string is integer -strict $own_reqs] &&
      ![string is integer -strict $next_action_id]} {
    set next_action_id $own_reqs
    set own_reqs ""
  }

  if ![string is integer -strict $duration] {set duration 4}
  if ![string is integer -strict $next_action_id] {set next_action_id -1}

  set minr [::SmartAI::GetMin $range]
  set maxr [::SmartAI::GetMax $range]
  if {$maxr < 0} {set range 0..100} elseif {$minr == $maxr} {set range 0..$maxr}

  ProcessSpecialArgs $special
  # puts "action$action_id of class [info class] created: special was: $special text: $atext "
}

body TNpcAction::CheckReqs { target requirements } {
  # requirements check based on MasterScript, extended for NPC targets
  set tglevel [$target GetLevel]

  if [$target isa ::SmartAI::TPlayer] {
    set tgrace [$target GetRace]
    set tgclass [$target GetClass]
  } else {
    set tgrace -1
    set tgclass -1
  }
  set reqsok 1

  foreach elem $requirements {
    set rtype [string range [string tolower $elem] 0 0]
    if {$rtype == "!"
    } then { set logop "!"
             set rtype [string range $elem 1 1]
             set elem [string range $elem 2 end]
    } else { set logop ""; set elem [string range $elem 1 end] }
    set ps [split $elem |]
    switch -- $rtype {
      c { # class reqs
          if {[lsearch $ps $tgclass]==-1} {set reqsok 0}
        }

      e { # check elite value of target, players are treated as beeing elite 0
          if [$target isa ::SmartAI::TPlayer] {
            set tgelite 0
          } else {set tgelite [$target GetElite]}
          if {[lsearch $ps $tgelite]==-1} {set reqsok 0}
        }

      f { # check faction of target, character "s" (w/o quotes) in requirement
          # means same faction as (this) npc, faction is ignored for players
          set reqsok 1
          if [$target isa ::SmartAI::TNpc] {
            set tgfaction [$target GetFaction]
            if {[lsearch $ps $tgfaction] == -1 &&
                ([lsearch $ps s] == -1 || $tgfaction != [$this_npc GetFaction])
            } {set reqsok 0}
          }
        }

      h { # health reqs, format: h<minhealth>-<maxhealth> OR h<minhealth>
          # so h50 means health of target must have at least 50% health, while
          # !h50 means it must be below 50%
          set reqsok 1
          set health1 ""
          set health2 ""
          foreach {health1 health2} [split $ps -] {break}
          if [string is integer -strict $health1] {
            set tgh [$target GetHealth]
            if {[string is integer -strict $health2]
            } then {set reqsok [expr $tgh >= $health1 && $tgh <= $health2]
            } else {set reqsok [expr $tgh >= $health1]}
          }
        }

      i { # in Range reqs, format: i<range>:<number><e|f|nXXX>
          # where the laster parameter is the type and means friends, enemies,
          # or entries, so i50:10e means that in a range 50 must be at least
          # 10 enemies and !i50:1n10184 means there must be no Onyxia in
          # range of 50m :)
          set reqsok 0
          foreach elem $ps {
            set splitted [split $elem :]
            set rqrng [lindex $splitted 0]
            set tg [lindex $splitted 1]
            set tgn [lindex [split $tg efn] 0]
            if {![string is integer -strict $tgn] ||
                ![string is integer -strict $rqrng]} {
              continue
            }
            set tgtype [string range $tg [string length $tgn] end]
            set nbtargets ""
            switch -- $tgtype {
              e {set nbtargets [$target GetNearbyEnemies $rqrng]}
              f {set nbtargets [$target GetNearbyFriends $rqrng]}
              default {
                if {[string index $tgtype 0] == "n" &&
                    [set tgentry [string range $tgtype 1 end]] != "" &&
                    [string is integer $tgentry]} {
                  set nbm [$target GetNearbyMobs]
                  foreach mob $nbm {
                    if {[$mob GetEntry] == $tgentry &&
                        [$this_npc DistanceTo $mob] <= $rqrng} {
                      lappend nbtargets $mob
                    }
                  }
                }
              }
            }
            set reqsok [expr [llength $nbtargets] >= $tgn]
            if $reqsok break
          }
        }

      l { # level reqs, format: l<minlevel>-<maxlevel> OR l<minlvl>..<maxlvl> OR
          #                     l<minlevel>
          set minlevel ""
          set maxlevel ""
          set tglevel [$target GetLevel]
          if {[string first "-" $ps] > -1} {
            foreach {minlevel maxlevel} [split $ps -] break
          } else {
            foreach {minlevel dummy maxlevel} [split $ps ..] break
          }
          set reqsok [expr {[string is integer -strict $minlevel] &&
                            $tglevel >= $minlevel &&
                            (![string is integer -strict $maxlevel] ||
                             $maxlevel <= $minlevel || $tglevel <= $maxlevel)}]

        }

      n { # check entry of target, character "s" (w/o quotes) in requirement
          # means same entry as (this) npc, 0 means the target must be a player
          if {[$target isa ::SmartAI::TPlayer]
          } then {set tge 0
          } else {set tge [$target GetEntry]}
          if {[lsearch $ps $tge] == -1 &&
              ([lsearch $ps s] == -1 || $tge != [$this_npc GetEntry])
          } {set reqsok 0}
        }

      q { set reqsok 0; # quest reqs
          if [$target isa ::SmartAI::TPlayer] {
            foreach rq $ps {
              # check whether required quest has been completed before and
              # in case of the not operator also whether it has been started
              if [string is integer -strict $rq] {
                if {[$target HasQFlag Q$rq] || [$target HasQFlag q$rq] ||
                    $logop == "!" && [$target GetQuestStatus $rq] < 4} {
                  set reqsok 1
                  break
                }
              } else {
                set reqsok [$target HasQFlag $rq]
                if $reqsok break
              }
            }
          }
        }

      r { # race reqs
          if {[lsearch $ps $tgrace]==-1} {set reqsok 0}
        }

      s { set reqsok 0;  # skill reqs, format: s<skillid>:<slevel>
          if [$target isa ::SmartAI::TPlayer] {
            foreach rs $ps {
              set rsid [lindex [split $rs :] 0]
              set rslvl [lindex [split $rs :] 1]
              if {[$target GetSkillLevel $rsid] >= $rslvl} {
                set reqsok 1
                break
              }
            }
          }
        }
      default { set reqsok 1 }
    }
    set reqsok [expr $logop$reqsok]
    if !$reqsok {break}
  }
  return $reqsok
}

body TNpcAction::GetActionID {} {
  return $action_id
}

body TNpcAction::GetCurrentDuration {} {
  return $current_duration
}

body TNpcAction::GetNextTarget {} {
  if {$next_target_guids == "" || [clock seconds] - $last_target_update > 4 ||
      ![info exists ::SmartAI::active_mobs([lindex $next_target_guids 0])]} {
    UpdateNextTarget
  }
  if {$next_target_guids != ""
  } then {return $::SmartAI::active_mobs([lindex $next_target_guids 0])
  } else {return ""}
}

body TNpcAction::Executed {} {
  # the actual processing must have happened in the derived classes
  set next_target_guids [lrange $next_target_guids 1 end]
  while {$next_target_guids != "" &&
         ![info exists ::SmartAI::active_mobs([lindex $next_target_guids 0])]} {
    set next_target_guids [lrange $next_target_guids 1 end]
  }
  if !$calculating_duration {
    set current_duration 0
    set calculating_duration 1
  }
  incr current_duration $duration

  if {$next_target_guids != ""} {
    # in case of a multi-action, execute the actual action again
    Execute
    return
  }

  if {$text != ""} {::Say $this_mob_id 0 $text}
  set mincd [::SmartAI::GetMin $cooldown]
  set maxcd [::SmartAI::GetMax $cooldown]
  set cooldown_time [expr [clock seconds]+int($mincd+rand()*($maxcd+1-$mincd))]
  incr execution_count
  set calculating_duration 0
}

body TNpcAction::IsMultiExecutable {} {
  # An action is multi-executable if it can be repeatedly executed even if the
  # last action of this type has not been completed yet (duration > 0).
  # So the action must either be able to be executed at once (directly after
  # call, so having no real duration) or because some kind of stacking is done
  # internally like for SpellActions. Change it accordingly in derived classes
  # if needed.
  return $multi_executable
}

body TNpcAction::IsReady {} {
  # returns 1 if action is ready for execution
  set result [expr {[clock seconds] - $cooldown_time >= 0 &&
                    ($charges == 0 || $execution_count < $charges) &&
                    [CheckReqs $this_npc $own_reqs] &&
                    [set next_target [GetNextTarget]] != "" &&
                    [set dist [$this_npc DistanceTo $next_target]] >=
                    [::SmartAI::GetMin $range] &&
                    $dist <= [::SmartAI::GetMax $range]}]
  return $result
}

body TNpcAction::ProcessSpecialArgs {args} {
  # override this in derived classes for special parameter processing, if any
  return
}

body TNpcAction::UpdateNextTarget {} {
  set result ""
  set targets ""
  set focussed [$this_npc GetFocussedMob]

  # get targets depending from target_type: 0=self, 1=focus, 2=friend, 3=enemy
  switch -- $target_type {
    0  { set targets $this_npc }

    1  { set targets [$this_npc GetFocussedMob] }

    default {
      switch -- $target_type {
        2 {set candidates [concat [$this_npc GetNearbyFriends] $this_npc]}
        3 {set candidates [$this_npc GetNearbyEnemies]}
        4 {set candidates [$this_npc GetNearbyNeutrals]}
        5 {set candidates [$this_npc GetNearbyMobs]}
        6 {set candidates [$this_npc GetLink]}
        default {set candidates ""}
      }
      set minr [::SmartAI::GetMin $range]
      set maxr [::SmartAI::GetMax $range]

      foreach candidate $candidates {
        set dist [$this_npc DistanceTo $candidate]
        if {$maxr == 0 || $dist >= $minr && $dist <= $maxr} {
          lappend targets $candidate
        }
      }
    }
  }

  # filter targets by target requirements
  if {$target_reqs != ""} {
    set filtered_targets ""
    foreach target $targets {
      if ![CheckReqs $target $target_reqs] continue
      lappend filtered_targets $target
    }
    set targets $filtered_targets
  }

  # choose final target depending from $target_selector
  set ntargets $targets
  if {[llength $targets] > 1} {
    # priorities: 0=random, 1=nearest, 2=weakest
    switch -- $target_selector {
      1 { # find nearest target except self
          set nearest 9999
          foreach target $targets {
            if {$target == $this} {continue}
            if {[$this_npc DistanceTo $target] < $nearest} {
              set ntargets $target
              set nearest [$this_npc DistanceTo $target]
            }
          }
        }
      2 {
        # find target with lowest health (including self if the case)
        set lowest_health 200
        foreach target $targets {
          if {[$target GetHealth] < $lowest_health} {
            set ntargets $target
            set lowest_health [$target GetHealth]
          }
        }
      }
      9 { # every
          if ![IsMultiExecutable] {
            set idx [expr {int(rand()*[llength $targets])}]
            set ntargets [lindex $targets $idx]
          }
        }
      default {
        set ntargets [lindex $targets [expr {int(rand()*[llength $targets])}]]
      }
    }
  }

  set next_target_guids ""
  foreach target $ntargets {
    lappend next_target_guids [$target GetGuid]
  }
  set last_target_update [clock seconds]
}

body TNpcAction::Reset {} {
  set execution_count 0
  set cooldown_time 0
  set next_target_guid ""
}

body TNpcTactic::constructor {npcobj atacid atype aaobjs {params {}} {txt {}}} {
  # params: pri chrgs adist kdist dur ad tcd tframe health timeout ntac
  #   or {} (defaults used then)
  set this_npc $npcobj
  set this_mob_id [$npcobj GetMobID]
  set tac_id $atacid
  set tac_type $atype
  set actions $aaobjs
  set text $txt

  if {$params == ""} {
    set params "0 0 $::SmartAI::default_aggro_dist 0 0 5..20 0 0 0 0 -1"
  }
  foreach {priority charges aggro_dist keep_dist duration action_delay \
           cooldown time_frame health_range timeout next_tactic_id} $params {
    break
  }

  set fmin [::SmartAI::GetMin $time_frame]
  set fmax [::SmartAI::GetMin $time_frame]
  if {$fmax <= $fmin || $fmax < 0} {set time_frame $fmax}

  # special processing for the idle and always tactics
  if {$fmax < -1} {
    foreach {charges keep_dist health_range} "0 0 0" break
  }

  set unaggro_dist [expr $aggro_dist + round($aggro_dist / 3)]
  if {$unaggro_dist<10} {set unaggro_dist 10}
}

body TNpcTactic::Activate {} {
  set last_action_idx -1
  set paused_until 0
  set mincd [::SmartAI::GetMin $cooldown]
  set maxcd [::SmartAI::GetMax $cooldown]
  set current_cooldown [expr {int($mincd+rand()*($maxcd+1-$mincd))}]

  set current_action_delay 0; # allow mob to perform actions right after start

  set mindur [::SmartAI::GetMin $duration]
  set maxdur [::SmartAI::GetMax $duration]
  set current_duration [expr {int($mindur+rand()*($maxdur+1-$mindur))}]

  set last_activity [clock seconds]
  set start_time [clock seconds]
  if {$text != ""} {Say $this_mob_id 0 $text}
  incr execution_count
  switch -- [::SmartAI::GetMax $time_frame] {
    -4 -
    -3 {set req_battle_state 0}
    -2 {set req_battle_state -1}
    -1 {set req_battle_state [expr [$this_npc GetBattleStart] ? 1 : -1]}
    default {
      set req_battle_state 1
    }
  }
}

body TNpcTactic::GetActions {} {
  return $actions
}

body TNpcTactic::GetReqBattleState {} {
  return $req_battle_state
}

body TNpcTactic::GetTacID {} {
  return $tac_id
}

body TNpcTactic::GetTacType {} {
  return $tac_type
}

body TNpcTactic::IsAvailable {} {
  # A tactic is available if it has not been executed the maximum times, is
  # cooled down, the time frame is matched and the npc has the required health.
  # There are negative values for time frame allowed as follows:
  #   -4 = like -1, but resets locked-flags (for quest scripts)
  #   -3 = tactic can be active at any time
  #   -2 = tactic can only be active if npc is idle
  #   -1 = tactic must be activated by another tactic or by SwitchTactic
  #    0 = tactic can get active as soon as the NPC gets in battle

  if {$charges && $execution_count >= $charges} {return 0}

  # check time frame, see above
  switch -- [set fmax [::SmartAI::GetMax $time_frame]] {
    -2 {if [$this_npc GetBattleStart] {return 0}}
    -4 -
    -1 { # check whether tactic can be activated by the current tactic
         set curnpctac [$this_npc GetCurrentTactic]
         if {$curnpctac == "" || ![$this_npc GetBattleStart] ||
            [$curnpctac cget -next_tactic_id] != [$this GetTacID]
         } then {return 0}
       }

    default {
      if {$fmax >= 0} {
        if ![set bstart [$this_npc GetBattleStart]] {return 0}
        set btime [expr [clock seconds] - $bstart]
        set fmin [::SmartAI::GetMin $time_frame]
        if {$fmin == $fmax} {
          if {$btime < $fmin} {return 0}
        } else {
          if {$btime < $fmin || $btime > $fmax} then {return 0}
        }
      }
    }
  }
  # check tactic cooldown
  if {$last_activity + $current_cooldown > [clock seconds]} {return 0}

  # check health
  set minh [::SmartAI::GetMin $health_range]
  set maxh [::SmartAI::GetMax $health_range]
  set hpct [$this_npc GetHealth]
  if {($hpct < $minh) || (($maxh > $minh) && ($hpct > $maxh))} {
    # puts "health not matched for $this"
    return 0
  }
  return 1
}

body TNpcTactic::Pause {seconds} {
  set paused_until [expr [clock seconds] + $seconds]
}

body TNpcTactic::PerformNextAction {} {
  # Performs next action of a tactic (if possible) and returns:
  #   0: if the tactic has ended and must be changed
  #   1: no action has been exectued but the tactic remains active
  #   2: an action has been executed, the tactic remains active

  # check whether tactic must be aborted (and therefore changed)
  set battle_start [$this_npc GetBattleStart]
  if {[set rbs [GetReqBattleState]]} {
    if {$rbs < 0 && $battle_start || $rbs > 0 && !$battle_start} {
      return 0
    }

    if {[::SmartAI::GetMax $time_frame] > 0} {
      set btime [expr [clock seconds] - $battle_start]
      if {($btime < [::SmartAI::GetMin $time_frame]) ||
          ($btime > [::SmartAI::GetMax $time_frame])
      } then {puts "tacbreak0"; return 0}
    }
  }

  # check whether tactic is paused
  if {[clock seconds] < $paused_until} {return 1}

  # check whether turn-blocked (ToDo)
  # if [$this_npc IsTurnBlocked] {return 1}

  # do nothing if the action delay still prevents it
  if {[clock seconds] - $last_activity < $current_action_delay} {return 1}

  if {($current_duration > 0) &&
      ([clock seconds] - $start_time > $current_duration)} {
    puts "tacbreak1";
    return 0
  }

  if {($timeout > 10) && ([clock seconds] - $last_activity > $timeout)} {
    puts "tacbreak2"
    return 0
  }

  # check health
  set minh [::SmartAI::GetMin $health_range]
  set maxh [::SmartAI::GetMax $health_range]
  set hpct [$this_npc GetHealth]
  if {($hpct < $minh) || (($maxh > $minh) && ($hpct > $maxh))} {
    puts "tacbreak3: $hpct vs $health_range";
    return 0
  }

  set action ""
  set end_tactic 0

  if {$next_action != ""
  } then {if [$next_action IsReady] {set action $next_action}
  } else {
    set next_action_idx -1
    switch -- $tac_type {
      0 -
      4 { # tactic type 0: random, tactic type 4: idle tactic
          # randomly choose one ready action of the highest possible priority
          set last_pri 100

          while {$next_action_idx < 0} {

            # find the next highest priority class
            set highest_pri -1
            set highest_actions ""
            foreach action $actions {
              set pri [$action cget -priority]
              if {$pri < 0} {set pri 0}
              if {($pri > $highest_pri) && ($pri < $last_pri)} {
                set highest_pri $pri
              }
            }

            # if no lower priority is available then abort search
            if {$highest_pri<0} {break};
            set last_pri $highest_pri

            # create list of actions in this priority class
            set highest_actions ""
            foreach action $actions {
              if {[$action cget -priority] == $highest_pri} {
                lappend highest_actions $action
              }
            }

            # randomly check all actions of the currently processed priority
            # class until one ready action is found or all are checked
            while {($next_action_idx < 0) && ($highest_actions != "")} {
              set idx [expr {int(rand()*[llength $highest_actions])}]
              set action [lindex $highest_actions $idx]
              if [$action IsReady] {
                set next_action_idx [lsearch $actions $action]
              } else {
                set highest_actions [lreplace $highest_actions $idx $idx]
              }
            }
          }
        }
      1 { # tactic type 1: sequence
          set nidx [expr $last_action_idx+1]
          if {($nidx < [llength $actions])
          } then {
            set action [lindex $actions $nidx]
            if [$action IsReady] {set next_action_idx $nidx}
          } else {
            set end_tactic 1
          }
        }
      default {
        # tactic type 2: loop
        set action ""

        set nidx [expr $last_action_idx+1]
        if {$actions != ""} {
          if {$nidx >= [llength $actions]} {set nidx 0}
          set action [lindex $actions $nidx]
          if [$action IsReady] {set next_action_idx $nidx}
        }
      }
    }
    if {$next_action_idx == -1} {
      set action ""
    } {
      set action [lindex $actions $next_action_idx]
      set last_action_idx $next_action_idx
    }
  }

  set result 1

  if {$action != ""} {
    $action Execute
    set last_activity [clock seconds]
    set mind [::SmartAI::GetMin $action_delay]
    set maxd [::SmartAI::GetMax $action_delay]
    set current_action_delay [expr {int($mind+rand()*($maxd+1-$mind))}]
    if {$current_action_delay < [$action GetCurrentDuration]} {
      set current_action_delay [$action GetCurrentDuration]
    }
    set next_action ""
    if {[set nid [$action cget -next_action_id]] > -1} {
      foreach maction [$this_npc GetActions] {
        if {[$maction GetActionID] == $nid} {
          set next_action $maction
          break
        }
      }
    }
    set result 2
  } else {
    set end_tactic [expr {$end_tactic || (($timeout > 0) &&
                          ([clock seconds] - $last_activity > $timeout))}]
  }
  if $end_tactic {puts "tacbreak5"; set result 0}
  return $result
}

body TNpcTactic::Reset {} {
  set execution_count 0
}

body TSpellAction::Execute {} {
  set target [GetNextTarget]
  if {$target != ""} {
    switch -- $direction {
      st { $this_npc Cast $spell $target;
           # prevent recharges due to possible active root-spells
           if [$target isa ::SmartAI::TNpc] {$target NotifyRecharge $this_npc}
         }
      ss {$this_npc Cast $spell}
      ts {$target Cast $spell $this_npc}
      tt {$target Cast $spell $target}
    }
    Executed
  }
}

body TSpellAction::IsReady {} {
  if ![TNpcAction::IsReady] {return 0}
  set target [GetNextTarget]
  if {$target == ""} {return 0}
  switch -- $direction {
    st -
    tt {set spell_target $target}
    ss -
    ts {set spell_target $this_npc}
    default {set spell_target ""}
  }
  if {$spell_target == ""} {return 0}

  return [expr {[$this_npc CanCastSpell $spell $spell_target]}]
}

body TSpellAction::ProcessSpecialArgs {args} {
  set args [join $args]
  set spell [lindex $args 0]
  set direction [lindex $args 1]
  if {[lsearch "ss st tt ts" $direction] == -1} {
      set direction "st"
  }
}

body TTextAction::Execute {} {
  $this_npc Chat $language $text
  set old_text $text
  set text ""
  Executed
  set text $old_text
}

body TTextAction::ProcessSpecialArgs {args} {
  # join here because a multi-word string as single argument is put in braces...
  set language [join $args]

  if {[lsearch "0 1 2 3 6 7 8 9 10 11 12 13 14 33" $language] == -1}  {
    set language 0
  }
}

body TEmoteAction::Execute {} {
  # note that emote states normally require a target and only this can see
  # the animation but it seems there are exceptions like emote 10
  set emote_states "12 13 26 27 28 29 30 64 65 68 69 93 133 173 193 214 233\
                    234 333 313 353 373"

  if {[lsearch $emote_states $emoteid] == -1 ||
      [set target [GetNextTarget]] == ""} {
    $this_npc Emote $emoteid
  } else {
    $this_npc EmoteState $target $emoteid
  }
  Executed
}

body TEmoteAction::ProcessSpecialArgs {args} {
  set emoteid $args
}

body TPauseAction::Execute {} {
  if $target == 0 {
    set tactic [$this_npc GetCurrentTactic]
    if {$tactic != ""} {$tactic Pause $seconds}
  } else {
    $this_npc Pause $seconds
  }
  Executed
}

body TPauseAction::ProcessSpecialArgs {args} {
  set seconds [lindex $args 0]
  set target [lindex $args 1]
  if {$target == ""} {set target 0}
}
body TScriptAction::Execute {} {
  if {$tcl_proc != ""} {
    set target [GetNextTarget]
    if [catch {eval $tcl_proc $this_mob_id $target} errorstring] {
      puts ""
      puts "(SmartAI) WARNING: got error processing TCL action $tcl_proc"
      puts "ERROR: $errorstring"
    }
  }
  Executed
}

body TScriptAction::ProcessSpecialArgs {args} {
  set tcl_proc [lindex $args 0]
}

body TSwitchTacticAction::Execute {} {
  # command other npcs to change their tactic
  set target [GetNextTarget]
  if {$target == "" || ![$target isa ::SmartAI::TNpc]} {
    return
  }
  $target SwitchTactic $new_tacid
  Executed
}

body TSwitchTacticAction::ProcessSpecialArgs {args} {
  set new_tacid [lindex $args 0]
  if ![string is integer -strict $new_tacid] {set new_tacid 0}
}

body TCallForHelpAction::Execute {} {
  set target [GetNextTarget]

  # if target is a friend, help to attack its nearest enemy within 20m dist
  if {$target != "" && [$target GetSide] == $this_mob_side} {
    set mindist 21
    set candidate ""
    foreach nbmob [$target GetNearbyEnemies] {
      if {[set dist [$target DistanceTo $nbmob]] < $mindist} {
        set mindist $dist
        set candidate $nbmob
      }
    }
    set target $candidate
  }
  if {$target == ""} {
    Executed
    return
  }

  set nbf ""
  foreach friend [$this_npc GetNearbyFriends] {
    if {[$friend isa ::SmartAI::TNpc] && [CheckReqs $friend $friend_reqs] &&
        ($call_range == 0 || [$this_npc DistanceTo $friend] <= $call_range)
    } then {
      lappend nbf  "[$friend GetBattleStart] $friend"
    }
  }

  # prefer friends that are not already in battle, so put them first
  set nbf [lsort -integer -index 0 $nbf]
  set num 0
  foreach pair $nbf {
    set friend [lindex $pair 1]
    LogMob [$this_npc GetMobID] "Calling friend $friend ($num / $friend_limit)"
    $friend SetNextTarget $target
    incr num
    if {$friend_limit > 0 && $num >= $friend_limit} {break}
  }
  Executed
}

body TCallForHelpAction::ProcessSpecialArgs {args} {
  foreach {call_range friend_limit friend_reqs} $args break
}

body TNewTargetAction::Execute {} {
  if {[set target [GetNextTarget]] != ""} {
    $this_npc SetNewTarget $target
  }
  Executed
}

body TDespawnAction::Execute {} {
  if {[set target [GetNextTarget]] != ""} {
    set template $::SmartAI::DUMMY_LOOT
    # unfortunately we need some player ID for looting, so here the special
    # wildcard parameter is used for GetNearbyMobs
    set nbm [$this_npc GetNearbyMobs "* 0 1"]
    foreach mob $nbm {
      if [$mob isa ::SmartAI::TPlayer] {
        Loot [$mob GetMobID] [$target GetMobID] $template 1
        break
      }
    }
  }
  Executed
}

body TSetFactionAction::Execute {} {
  # change NPC's faction, action type: 9
  set target [GetNextTarget]
  if {$target == "" || ![$target isa ::SmartAI::TNpc]} {
    return
  }

  $target SetFaction $faction_id
  Executed
}

body TSetFactionAction::ProcessSpecialArgs {args} {
  set faction_id [lindex $args 0]
  if ![string is integer -strict $faction_id] {set faction_id 35}
}

body TSetWayPointAction::Execute {} {
  # set a waypoint for an NPC, action type: 10
  set target [GetNextTarget]
  if {$target == "" || ![$target isa ::SmartAI::TNpc]} {
    return
  }
  $target SetWP $wp_id
  Executed
}

body TSetWayPointAction::ProcessSpecialArgs {args} {
  set wp_id [lindex $args 0]
  if ![string is integer -strict $wp_id] {set wp_id ""}
}

body TTeleportAction::Execute {} {
  # teleport a player to a destination position action type: 11
  set target [GetNextTarget]
  if {$target == "" || ![$target isa ::SmartAI::TPlayer]} {
    return
  }
  set tp_dest $destination
  if {[llength $tp_dest] != 4} {set tp_dest [$this_npc GetPosition]}
  eval Teleport [$target GetMobID] $tp_dest
  Executed
}

body TTeleportAction::ProcessSpecialArgs {args} {
  set destination [join $args]
}

body TPlayer::constructor {amobid} {
  configure -scanner_enabled 1
  set this_mob_faction [GetRace]
  if {$this_mob_faction > 6} {incr this_mob_faction}
}

body TPlayer::GetClass {} {
  return [::GetClass $this_mob_id]
}

body TPlayer::GetFocussedMob {} {
  set result ""
  set pselection [GetSelection $this_mob_id]
  if {[lsearch "3 4" [GetObjectType $pselection]] > -1} {
    set selguid [::GetGuid $pselection]
    if [info exists ::SmartAI::active_mobs($selguid)] {
      set result $::SmartAI::active_mobs($selguid)
    }
  }
}

body TPlayer::GetPowerStats {} {
  # estimated player power
  set level [GetLevel]
  if {$level < 60} {
    set max_hitpoints [expr $level * 50]
    set average_damage [expr $level * 5]
  } else {
    set max_hitpoints [expr $level * 100]
    set average_damage [expr $level * 10]
  }
  set hitpoints [expr round([GetHealth] / 100.0 * $max_hitpoints)]
  return [list $hitpoints $average_damage]
}

body TPlayer::GetQuestStatus {questid} {
  return [::GetQuestStatus $this_mob_id $questid]
}

body TPlayer::GetRace {} {
  return [::GetRace $this_mob_id]
}

body TPlayer::GetSkillLevel {skillid} {
  return [::GetSkill $this_mob_id $skillid]
}

body TPlayer::ReadyToScan {} {
  return [expr {[TMob::ReadyToScan] && $last_map_change &&
                [clock seconds] - $last_map_change > 9 }]
}

body TPlayer::UpdateMob {} {
  set map [lindex [GetPosition] 0]
  if {$map != $last_map} {
    set last_map $map
    set last_map_change [clock seconds]
  }
  TMob::UpdateMob
}

body TPlayer::UpdateSide {} {
  set this_mob_side [expr {[lsearch "1 3 4 7" [GetRace]] < 0}]
}

variable mobs ""
proc CanAggro { npc victim } {
  # test (todo): remove this
  if {[lsearch $::SmartAI::mobs $npc] == -1} {
    if {[llength $::SmartAI::mobs] > 4} {
      set ::SmartAI::mobs [lreplace $::SmartAI::mobs 0 0]
    }
    lappend ::SmartAI::mobs $npc
  }
  # end of test

  if $::SmartAI::enabled {
    set start [clock clicks -milliseconds]
    set result 1
    if {[set dist [::Distance $npc $victim]] < 41} {
      set allowed_z_delta [expr ceil($dist / 5.0)]
      set npc_z [lindex [GetPos $npc] end]
      set player_z [lindex [GetPos $victim] end]
      if {abs($player_z - $npc_z) > $allowed_z_delta} {set result 0}
    }
    foreach {npcobj player} [::SmartAI::UpdateActiveMobs $npc $victim] break
    if $result {
      set result [$npcobj CanAggro $player]
	    set end [clock clicks -milliseconds]
  	  set time [expr { $end - $start }]
  	  LogMob 0 "CanAggro returned after $time ms"
  	}
    # puts "[clock format [clock seconds] -format %k:%M:%S]: CanAggro: $npc ([::GetEntry $npc]) vs. [GetName $victim] returns $result"
    return $result
  }
}

proc CanUnAggro { npc victim } {
  if $::SmartAI::enabled {
    set start [clock clicks -milliseconds]
    foreach {npcobj player} [::SmartAI::UpdateActiveMobs $npc $victim] break
    set result [$npcobj CanUnAggro $player]
    # puts "[clock format [clock seconds] -format %k:%M:%S]: CanUnAggro: $npc ([::GetEntry $npc]) vs. [GetName $victim] returns $result"
	  set end [clock clicks -milliseconds]
	  set time [expr { $end - $start }]
	  LogMob 0 "CanUnAggro returned after $time ms"
    return $result
  }
}

proc CanCast {npc victim} {
  # continue with default CanCast only if no SmartAI profile exists for this mob
  set npcobj [::SmartAI::GetMobObject $npc]
  if {$npcobj != "" && [$npcobj HasTactics]} {return 0}
}

proc Shutdown {} {
  # All objects must be deleted before retcl otherwise the emu will crash!
  variable active_mobs
  set ::SmartAI::enabled 0

  foreach guid [array names active_mobs] {
    delete object $active_mobs($guid)
  }
}

proc UpdateActiveMobs {npc_id player_id} {
  # updatesmobs and returns npcobj and playerobj as list
  variable active_mobs
  variable scanners
  variable last_update
  variable last_player
  variable last_player_id
  variable last_scan
  variable last_npc_aggro
  variable scan_interval

  set cs [clock seconds]
  if {$cs != $last_update} {set processed_npcs ""}

  # update list of active npcs, the guid is used for npc objects because in
  # contrast to npc ids, no guid is used twice per server "session",
  # even if it gets available again
  set npc [GetMobObject $npc_id]
  $npc UpdateMob
  lappend result $npc

  if {$player_id == $last_player_id && $cs - $last_update < 2} {
    lappend result $last_player
    return $result
  }

  set player [GetMobObject $player_id]
  $player UpdateMob
  set last_player $player
  set last_player_id $player_id
  lappend result $player

  # send scan impuls from all scanners if not another nearby and more active
  # one has done this already, that way this ai can see what all active
  # players can currently see as all players are scanners by default and there
  # is no reason to process things that can not be seen by anyone :) - but to
  # disturb casting players it is good to allow bosses to be scanners too,
  # so elite 2+ mobs will be scanners by default too, these will be prefered
  if {$::SmartAI::npc_aggro_enabled  && $cs - $last_scan >= $scan_interval} {
    #put all available scanners in an array depending from map
    foreach guid [array names scanners] {
      set scanner $scanners($guid)
      if [$scanner ReadyToScan] {
        set map [lindex [$scanner GetPosition] 0]
        set last_activity [$scanner GetLastActivityTime]
        if {[$scanner isa ::SmartAI::TPlayer]
        } then {lappend player_scanners($map) "$scanner $last_activity"
        } else {lappend npc_scanners($map) "$scanner $last_activity"}
      }
    }
    foreach map [array names player_scanners] {
      if {[info exists npc_scanners($map)]
      } then {set map_scanners [lsort -integer -index 1 $npc_scanners($map)]
      } else {set map_scanners ""}
      set player_scanners($map) [lsort -integer -index 1 $player_scanners($map)]
      set map_scanners [concat $map_scanners $player_scanners($map)]
      while {$map_scanners != ""} {
        set scanner [lindex [lindex $map_scanners 0] 0]
        set new_scanners ""
        foreach element $map_scanners {
          set fellow_scanner [lindex $element 0]
          if {$fellow_scanner == $scanner} continue
          if {[$scanner DistanceTo $fellow_scanner] > 40} {
            lappend new_scanners $element
          }
        }
        set map_scanners $new_scanners
        $scanner SendScanImpuls
      }
    }
    set last_scan $cs
  }

  # process aggro events for npcs vs. npcs
  if {$::SmartAI::npc_aggro_enabled && $cs - $last_npc_aggro > 1} {
    LogMob 0 "npc aggro processing, active mobs: [array names active_mobs]"
    foreach guid [array names active_mobs] {
      set mob $active_mobs($guid)
      if ![$mob IsActive] {
         LogMob 0 "Deleting $mob"
         delete object $mob
         continue
      }
      if ![$mob isa ::SmartAI::TNpc] continue

      set busy [expr {[set focussed [$mob GetFocussedMob]] != ""}]
      if $busy {
        set busy [expr ![$mob CanUnAggro $focussed]]
        if $busy continue
      }

      foreach hostile_mob [$mob GetNearbyEnemies] {
        if ![$hostile_mob isa ::SmartAI::TNpc] continue
        LogMob 0 "Checking CanAggro: $mob vs $hostile_mob\
         (dfc: [$hostile_mob GetDefeatChance])"
        if [set busy [$mob CanAggro $hostile_mob]] break
      }
      if !$busy {$mob Idle}
    }
    set last_npc_aggro $cs
  }
  set last_player $player
  set last_update $cs
  return $result
}

puts "[::Custom::LogPrefix]Loading AI profiles..."

LoadAiScp

# debug
proc DisplayLoadedProfiles {} {
  foreach name [array names ::SmartAI::Profiles] {
    set content $::SmartAI::Profiles($name)
    puts "Profile ($name):"
    puts "  actions:"
    foreach action [lindex $content 0] {
      puts "    $action"
    }
    puts "  tactics:"
    foreach tactic [lindex $content 1] {
      puts "    $tactic"
    }
  }
}
# DisplayLoadedProfiles

###############################################################################
#                           Spell Events                                      #
###############################################################################

proc OnScannerPing {target scanner spellid} {
  set scanner_obj [GetMobObject $scanner]
  set target_obj [GetMobObject $target]
  if {$scanner_obj != "" && $target_obj != ""} {
    $target_obj ScannerPing $scanner_obj
  }
  LogMob 0 "scanner ping: target: [$target_obj GetName] ([$target_obj GetGuid])\
    scanner: [$scanner_obj GetName] ([$scanner_obj GetGuid])"
}

proc OnPlayerLogin {from to spellid} {
  set player [GetMobObject $from]
  $player UpdateMob
  set last_map_change [clock seconds]; #prevent scanning right after login
}

##############################################################################
#                 Implementation of Additional and modified Commands                      #
##############################################################################

# tell the AI the an NPC has been paralysed by a GM
proc CmdGMParalyse {player cargs} {
  set pselection [GetSelection $player]
  if {[GetObjectType $pselection] == 3} {
    if {([set link [GetLinkObject $pselection]] == 0 ||
         [GetObjectType $link] == 4) && $cargs != 2} {
      # manually spawned mobs get automatically paralysed but how to know that?
      # global arrays get deleted on restart and qflags for NPCs will be lost
      # if server is rebooted, so simply no special processing here
      return .paralyse
    }
    set npc [::SmartAI::GetMobObject $pselection]
    if {$npc != ""} {
      set paused_until [$npc GetPaused]
      if {$paused_until < 0} {
        $npc Unpause
        if ![$npc FocusOutOfRange] {return "Object freed!"}
      } else {
        $npc Pause
        return "Paralysed."
      }
    }
  }
}

# a mob in GhostMode will not be attacked by any NPCs
proc CmdGhostMode {player cargs} {
  set pselection [GetSelection $player]
  if {[GetObjectType $pselection] == 4} {
    set player $pselection
  }
  if [GetQFlag $player GhostMode] {
      ClearQFlag $player GhostMode
      return "Ghost mode is now off."
  } else {
      SetQFlag $player GhostMode
      return "Ghost mode is now on."
  }
}

proc CmdDist { player cargs } {
  set pselection [GetSelection $player]
  return "dist is: [Distance $player $pselection]"
}

proc CmdSetFaction {player cargs} {
  set pselection [GetSelection $player]
  if {[GetObjectType $pselection] == 3} {
    set npc [::SmartAI::GetMobObject $pselection]
    if [string is integer -strict $cargs] {
      $npc SetFaction $cargs
    }
  }
}

proc CmdShutdownAI {player cargs} {
  Shutdown
  return "The SmartAI has has been disabled."
}

proc CmdGetFocus {player cargs} {
  set pselection [GetSelection $player]
  if {$pselection == $player} {
    set mob [GetMobObject $pselection]
    foreach attacker [$mob GetAttackers] {
      $attacker Chat "I attack you! My DFC is [$attacker GetDefeatChance]%"
    }
    $mob Chat "My DFC is [$mob GetDefeatChance]%, my pwrstats: [$mob GetPowerStats]"
    return
  }
  if {[set npc [GetMobObject $pselection]] != ""} {
    set fmob [$npc GetFocussedMob]
    if {$fmob != ""} {
      Say $fmob 0 "He attacks ME!"
      set focussed [$fmob GetGuid]
    } else {set focussed nothing}
    $npc Chat "focus: $focussed, tactic: [[$npc GetCurrentTactic] GetTacID]\
               DefeatChance: [$npc GetDefeatChance]%\
               powerstats: [$npc GetPowerStats]"
    foreach attacker [$npc GetAttackers] {
      $attacker Chat "I attack him! (dfc: [$attacker GetDefeatChance]"
    }
    return "OK: $focussed"
  }
  return "bad selection"
}

proc CmdBenchMark {player cargs} {
  variable mobs
  set start [clock clicks -milliseconds]
  LogMob 0 "Benchmark: Testing with [llength $mobs] mobs"
  LogMob 0 "GUID Lookup:"
  foreach mob $mobs {
    LogMob 0 "  GUID of $mob is [GetGuid $mob]"
    LogMob 0 "  GUID of $mob is [GetGuid $mob]"
    LogMob 0 "  GUID of $mob is [::GetGuid $mob]"
  }
  LogMob 0 "Entry Lookup:"
  foreach mob $mobs {
    LogMob 0 "  Entry of $mob is [GetEntry $mob]"
    LogMob 0 "  Entry of $mob is [GetEntry $mob]"
    LogMob 0 "  Entry of $mob is [::GetEntry $mob]"
  }

  LogMob 0 "ObjectType Lookup:"
  foreach mob $mobs {
    LogMob 0 "  ObjectType of $mob is [GetObjectType $mob]"
    LogMob 0 "  ObjectType of $mob is [GetObjectType $mob]"
    LogMob 0 "  ObjectType of $mob is [::GetObjectType $mob]"
  }

  LogMob 0 "Distance Calculation"
  foreach mob $mobs {
    LogMob 0 "  Distance of $mob from you is [Distance $mob $player]"
    LogMob 0 "  Distance of $mob from you is [Distance $mob $player]"
    LogMob 0 "  Distance of $mob from you is [::Distance $mob $player]"
  }
  set end [clock clicks -milliseconds]
	set time [expr { $end - $start }]
  LogMob 0 "Benmark done, total time was: $time ms"
  return "OK, tested with [llength $mobs] mobs ($time ms)"
}

proc CmdNpcAggro {player cargs} {
  set ::SmartAI::npc_aggro_enabled $cargs
  if ![string is integer -strict $cargs] {
    set ::SmartAI::npc_aggro_enabled 0
  }
  if $::SmartAI::npc_aggro_enabled {
    return "OK: npc_aggro is now enabled"
  } {
    return "OK: npc_aggro is now disabled"
  }
}

proc CmdSwitchTactic {player cargs} {
  set pselection [GetSelection $player]
  if {[GetObjectType $pselection] != 3} {
    return "Error: Please select an NPC!"
  }
  set mob [GetMobObject $pselection]
  if {$mob == ""} {
    return "Error: AI-Object not found!"
  }
  if ![string is integer -strict $cargs] {
    return "Error: Please enter a tactic ID to switch to!"
  }

  $mob SwitchTactic $cargs
  return "Ok, switched tactic of [$mob GetName] to $cargs"
}

##############################################################################
#                                 Hooks                                      #
##############################################################################
namespace eval ::Custom {namespace export HookProc AddSpellScript AddCommand}
namespace import ::Custom::HookProc ::Custom::AddSpellScript\
                 ::Custom::AddCommand

AddSpellScript "::SmartAI::OnScannerPing" 5373
AddSpellScript "::SmartAI::OnPlayerLogin" 836

HookProc ::AI::CanUnAgro [info body ::SmartAI::CanUnAggro]
HookProc ::AI::CanAgro [info body ::SmartAI::CanAggro]
HookProc ::AI::CanCast [info body ::SmartAI::CanCast]
HookProc ::WoWEmu::Commands::paralyse [info body ::SmartAI::CmdGMParalyse]
HookProc ::WoWEmu::Commands::retcl ::SmartAI::Shutdown
HookProc ::WoWEmu::Commands::setfaction [info body ::SmartAI::CmdSetFaction]

AddCommand {"aioff" ::SmartAI::CmdShutdownAI 6}
AddCommand {"bm" ::SmartAI::CmdBenchMark 2}
AddCommand {"dist" ::SmartAI::CmdDist 0}
AddCommand {"focus" ::SmartAI::CmdGetFocus 2}
AddCommand {"gm" ::SmartAI::CmdGhostMode 4}
AddCommand {"npcaggro" ::SmartAI::CmdNpcAggro 2}
AddCommand {"swt" ::SmartAI::CmdSwitchTactic 6}

set VERSION 1.4.1
set loadinfo "SmartAI v$VERSION by smartwork loaded"
if { ![info exists ::VERBOSE] || $::VERBOSE > 0 } {
	puts "[clock format [clock seconds] -format %k:%M:%S]:M:$loadinfo"
}
::StartTCL::Provide SmartAI $VERSION

### end of SmartAI
variable last_retcl [clock seconds]
}
