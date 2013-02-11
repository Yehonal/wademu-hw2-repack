# StartTCL: n
#
#
# Name:Hooker.tcl
#
# Description:Fun script (ADULT ONLY)
#
#
# Created by Tha-Doctor
# FileServing Now \/\/0\/\/ Services,
# - The Devolepment On Bugs
#
######################################################################
#
# This script is designd for Fun only not for any addictions on
# sexual level
# If you want to use it for that i will not be the guy to blame.
# Couse i did not make it for that.
# Otherwhise enjoy....
#
######################################################################


namespace eval StripDance {
  proc GossipHello { npc player } {
    set plevel [GetLevel $player]
    set pnamez [GetName $player]
    set SayLine1 { text 1 "Give me a Kiss...for 1 gold" }
    set SayLine2 { text 1 "Dance for me..for 1 gold" }
    set SayLine3 { text 1 "Show ur ass..for 1 gold" }
    set SayLine4 { text 3 "Maybe later sweety...here you are 1 gold" }

    if { $plevel < 18 } {
      Say $npc 0 "Sorry but you got to be 18 minimal $pnamez, to see something of my work..."
      SendGossipComplete $player
    }
    if { $plevel >= 18 } {
      SendGossip $player $npc $SayLine1 $SayLine2 $SayLine3 $SayLine4
      Emote $npc 24
    }

  }
  proc GossipSelect { npc player option } {
    set pnamez [GetName $player]
    set pmoney1 [ChangeMoney $player -10000]
    switch $option {
      0 {
        if {( $pmoney1 == 0 )} {
          Say $npc 0 "Sorry Babe, you got to pay for my services..."
          SendGossipComplete $player
  Emote $npc 25
          return
        }
        if {( $pmoney1 == 1 )} {
          SendGossipComplete $player
          Emote $npc 17
          return
        }
      }
      1 {
        if {( $pmoney1 == 0 )} {
          Say $npc 0 "Sorry Babe, you got to pay for my services..."
          SendGossipComplete $player
  Emote $npc 25
          return
        }
        if {( $pmoney1 == 1 )} {
          SendGossipComplete $player
          Emote $npc 10
          return
        }
      }
      2 {
        if {( $pmoney1 == 0 )} {
          Say $npc 0 "Sorry Babe, you got to pay for my services..."
          SendGossipComplete $player
  Emote $npc 25
          return
        }
        if {( $pmoney1 == 1 )} {
          SendGossipComplete $player
          Emote $npc 14
          return
        }
      }
      3 {
        SendGossipComplete $player
      }
    }
  }
}