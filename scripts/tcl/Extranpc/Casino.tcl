namespace eval ::nCasino2 {
  # Casino Script © 2006 Cybrax
  #
  # Version 2.0
  variable totbets 0
}


proc ::nCasino2::placebet { pname bval betdate } {
  casino_db eval {INSERT INTO `casinodata` (`name`, `bet`, `date`) VALUES ($pname, $bval, $betdate)}
}

proc ::nCasino2::hasbet { pname betdate } {
  set bet_cnt 0
  set bet_list [ casino_db eval {SELECT `name`, `date` FROM `casinodata` WHERE (`name` = $pname AND `date` = $betdate)} ]
  foreach i $bet_list {
    set bet_cnt  [expr int($bet_cnt)+1]
  }
  if { $bet_cnt == 0 } { return "0" } else { return "1" }
}

proc ::nCasino2::winner { npc betdate } {

  variable winnmb 0
  set now [ clock seconds ]
  set tody [ clock format [ expr { $now } ] -format "%d-%m-%Y" ]
  set bet_dte [ casino_db eval {SELECT date FROM `casinodata` LIMIT 1} ]

  if { $bet_dte == $tody } { return }

  set win_amm [ casino_db eval {SELECT sum(bet) as betv FROM `casinodata` WHERE (`date` = $betdate)} ]
  set bet_cnt [ casino_db eval {SELECT count(`bet`) as betcnt FROM `casinodata` WHERE (`date` = $betdate)} ]

  set winnmb [expr int(rand()*$bet_cnt)+1]

  set currow 0
  set fndwin 0

  set bet_list [ casino_db eval {SELECT `name` FROM `casinodata` WHERE (`date` = $betdate)} ]
  foreach i $bet_list {
    set currow [ expr int($currow)+1 ]
    if { $currow == $winnmb } {
      set winname $i
      set fndwin 1
    }
  }

  if { $fndwin == 1 } {
    set win_bet [ casino_db eval {SELECT `bet` FROM `casinodata` WHERE (`name` = $winname AND `date` = $betdate) LIMIT 1} ]
     ::nCasino2::insertwinner $winname $win_bet $win_amm $betdate
     ::nCasino2::deletebets $betdate
     ::Say $npc 0 "The winner of this jackpot is $winname"
  }    
}

proc ::nCasino2::insertwinner { pname nbet nwin betdate } {
  casino_db eval {INSERT INTO `casinowinner` (`name`, `bet`, 'winamm', `date`) VALUES ($pname, $nbet, $nwin, $betdate)}
}

proc ::nCasino2::deletebets { betdate } {
  casino_db eval {DELETE FROM `casinodata` WHERE (`date` = $betdate)}
}

proc ::nCasino2::deletewinner { pname } {
  casino_db eval {DELETE FROM `casinowinner` WHERE (`name` = $pname)}
}

proc ::nCasino2::collectprice { npc pname player } {

  set payout [ casino_db eval {SELECT sum(winamm) as betcnt FROM `casinowinner` WHERE (`name` = $pname ) } ]

  if { $payout == "{}" } {
    ::Say $npc 0 "you won nothing yet $pname"
  } else {
    set paymoney [ expr int($payout)*10000 ]

  set or_bet [ casino_db eval {SELECT bet FROM `casinodata` WHERE (`name` = $pname ) } ]

  switch $or_bet {
    10 {
    set paymoney [ expr int($paymoney)*2 ]
    }
    100 {
    set paymoney [ expr int($paymoney)*5 ]
    }
   }

    ChangeMoney $player +$paymoney
    ::nCasino2::deletewinner $pname
    ::Say $npc 0 "you won $payout gold $pname"  
  }
}


proc ::nCasino2::QuestStatus { npc player } {
   set reply 7
   return $reply
}

proc ::nCasino2::GossipHello { npc player } {

  set now [ clock seconds ]
  set betdate [ clock format [ expr { $now-86400 } ] -format "%d-%m-%Y" ]
  ::nCasino2::winner $npc $betdate

  set option0 { text 1 "I wanna gamble 1 gold" }
  set option1 { text 1 "I wanna gamble 10 gold" }
  set option2 { text 1 "I wanna gamble 100 gold" }
  set option3 { text 4 "Did i win?" }
  set option4 { text 4 "How much money is in the pot?" }
  set option5 { text 4 "When is the winner announced?" }
  set option6 { text 2 "How does this work?" }
  set option7 { text 0 "Bye cya later" }

  ::SendGossip $player $npc { npctext 340020 } \ $option0 $option1 $option2 $option3 $option4 $option5 $option6 $option7

}

proc ::nCasino2::GossipSelect { npc player option } {

  set pname [ ::GetName $player ]
  set betval 0
  set now [ clock seconds ]
  set betdate [ clock format [ expr { $now } ] -format "%d-%m-%Y" ]


  switch $option {
    0 { set placedbet [ ::nCasino2::hasbet $pname $betdate ]
    if { $placedbet == 0 } {
          if {[ChangeMoney $player -10000] == 0} {
           Say $npc 0 "You don't have enough money to gamble, get lost!"
           SendGossipComplete $player
           Emote $npc 3
           return
          }
          set betval 1
          ::nCasino2::placebet $pname $betval $betdate
          set ret "Your bet of 1 Gold has been placed $pname"
    } else { set ret "You already placed your bet for today $pname" }
        ::Say $npc 0 "$ret" 22
    }
    1 {    set placedbet [ ::nCasino2::hasbet $pname $betdate ]
    if { $placedbet == 0 } {
          if {[ChangeMoney $player -100000] == 0} {
           Say $npc 0 "You don't have enough money to gamble, get lost!"
           SendGossipComplete $player
           Emote $npc 3
           return
          }
          set betval 10
          ::nCasino2::placebet $pname $betval $betdate
          set ret "Your bet of 10 Gold has been placed $pname"
    } else { set ret "You already placed your bet for today $pname" }
        ::Say $npc 0 "$ret" 22
    }
    2 {    set placedbet [ ::nCasino2::hasbet $pname $betdate ]
    if { $placedbet == 0 } {
          if {[ChangeMoney $player -1000000] == 0} {
           Say $npc 0 "You don't have enough money to gamble, get lost!"
           SendGossipComplete $player
           Emote $npc 3
           return
          }
          set betval 100
          ::nCasino2::placebet $pname $betval $betdate
          set ret "Your bet of 100 Gold has been placed $pname"
    } else { set ret "You already placed your bet for today $pname" }
        ::Say $npc 0 "$ret" 22
    }
    3 {
    ::nCasino2::collectprice $npc $pname $player
    }
    4 { set win_amm [ casino_db eval {SELECT sum(bet) as betv FROM `casinodata` WHERE (`date` = $betdate)} ]
    if { $win_amm == "{}" } { set ret "The jackpot is empty." } else { set ret "The jackpot is at $win_amm gold." }
        ::Say $npc 0 "$ret" 22    }
    5 {
        set tdy [ clock format [ expr { $now } ] -format "%d-%m-%Y %H:%M:%S" ]
        set tom [ clock format [ expr { $now+86400 } ] -format "%d-%m-%Y" ]
        set ret "Today is: $tdy you can check: $tom if you won"
        ::Say $npc 0 "$ret" 22    }
    6 {
        set ret "Whazup you wanna try your luck, place your bet the next day you can see if you won. placing 1 gold=jackpot * 1, 10 gold=jackpot * 2, 100 gold= jakcpot * 5, the jackpot is the sum of all bets."
        ::Say $npc 0 "$ret" 22
    }
    7 { set ret "Ok goodbye"
    }

  }
  ::SendGossipComplete $player $npc

}



proc ::nCasino2::create_casinodb { player cargs } {
  if { [GetPlevel $player] < 5 } { return "You are not allowed to use that!" }
  
  if { $cargs == "wins" } {
    set w_list [ casino_db eval {SELECT * FROM `casinowinner` } ]
    foreach { name bet winamm date } $w_list {
        ::Say $player 0 "Winner: $name ($bet) - $winamm gold."
    }
  return "Database actions complete."
  }

  if { $cargs == "bets" } {

    set w_list [ casino_db eval {SELECT * FROM `casinodata` } ]
    foreach { name bet date } $w_list {
     ::Say $player 0 "$name : $bet."
    }
  return "Database actions complete."  }

  if { $cargs == "clear" } { casino_db eval { DROP TABLE IF NOT EXISTS `casinodata` }
  return "Database actions complete." }


  if { $cargs == "create" } {
    ::nCasino2::MakeDB
    return "Database Created."
  }
  return "Unknown casino command."

}

proc ::nCasino2::MakeDB { } {
  casino_db eval {CREATE TABLE IF NOT EXISTS `casinodata` (`name` TEXT NOT NULL, `bet` INTEGER NOT NULL, `date` TEXT NOT NULL)}
  casino_db eval {CREATE TABLE IF NOT EXISTS `casinowinner` (`name` TEXT NOT NULL, `bet` INTEGER NOT NULL, `winamm` INTEGER NOT NULL, `date` TEXT NOT NULL)}
}

::Custom::AddCommand "casinodb" "::nCasino2::create_casinodb" 5

proc ::nCasino2::Init { } {
  puts "[clock format [clock seconds] -format %k:%M:%S]:M:Initializing 24h Casino. (C) 2006 Cybrax (VisualDreams)"
  package require sqlite3
  sqlite3 casino_db "saves/casino.db"
  if { ! [ string length [ casino_db eval { SELECT `name` FROM `sqlite_master` WHERE (`type` = 'table' AND `tbl_name` = 'casinodata') } ] ] }   {
::nCasino2::MakeDB
    puts "[clock format [clock seconds] -format %k:%M:%S]:M:SQLite3 casino database created."
  }
}

::nCasino2::Init