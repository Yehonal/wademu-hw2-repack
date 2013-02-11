# StartTCL: b
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
# Name:		WoWEmu_Command.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::WoWEmu::Command { args }
#
# Modified to allow adding commands from scripts using the method
# "::Custom::AddCommand command proc plevel"
#
proc ::WoWEmu::Command { args } {
	set args [ string map {\} {} \{ {} \] {} \[ {} \$ {} \\ {}} $args ]
	set player [ lindex $args 0 ]
	set command [ string tolower [ lindex $args 1 ] ]
	set cargs [ lrange $args 2 end ]

	if { [ info exists ::WoWEmu::Commands($command) ] } {
		if { [ ::GetPlevel $player ] < [ lindex $::WoWEmu::Commands($command) 1 ] } {
			return [ ::WoWEmu::Commands::WrongPlevel ]
		}

		return [ [ lindex $::WoWEmu::Commands($command) 0 ] $player $cargs ]
	}

	if { [ string index $command 0 ] == "." || $command == ""  } {
		return .$args
	}

	return [ ::WoWEmu::Commands::UnknownCommand $player $command ]
}


#
# Standard commands
#
# Note: Plevel check is hardcoded for these commands (you can only increase)
#
::Custom::AddCommand {
        
       
	"add" ::WoWEmu::Commands::add 4
	"adddyn" ::WoWEmu::Commands::adddyn 6
	"addgo" ::WoWEmu::Commands::addgo 4
	"addnpc" ::WoWEmu::Commands::addnpc 4
	"addspawn" ::WoWEmu::Commands::addspawn 4
	"broadcast" ::WoWEmu::Commands::broadcast 4
	"byte" ::WoWEmu::Commands::byte 6
	"cleanup" ::WoWEmu::Commands::cleanup 6
	"clearqflags" ::WoWEmu::Commands::clearqflags 2
	"clearrep" ::WoWEmu::Commands::clearrep 4
	"come" ::WoWEmu::Commands::come 4
	"del" ::WoWEmu::Commands::del 2
	"delallcorp" ::WoWEmu::Commands::delallcorp 6
	"delspawns" ::WoWEmu::Commands::delspawns 10
	"delspawnsxy" ::WoWEmu::Commands::delspawnsxy 6
	"dismount" ::WoWEmu::Commands::dismount 0
	"exploration" ::WoWEmu::Commands::exploration 4
	"exportchar" ::WoWEmu::Commands::exportchar 6
	"exportspawns" ::WoWEmu::Commands::exportspawns 6
	"exportspawnsxy" ::WoWEmu::Commands::exportspawnsxy 6
	"faction" ::WoWEmu::Commands::faction 2
	"flag1" ::WoWEmu::Commands::flag1 10
	"gflags" ::WoWEmu::Commands::gflags 4
	"go" ::WoWEmu::Commands::go 2
	"goguid" ::WoWEmu::Commands::goguid 2
	"goname" ::WoWEmu::Commands::goname 2
	"gotrigger" ::WoWEmu::Commands::gotrigger 2
	"gtype" ::WoWEmu::Commands::gtype 4
	"help" ::WoWEmu::Commands::help 0
	"importchar" ::WoWEmu::Commands::importchar 6
	"importspawns" ::WoWEmu::Commands::importspawns 6
	"info" ::WoWEmu::Commands::info 2
	"kick" ::WoWEmu::Commands::kick 2
	"kill" ::WoWEmu::Commands::kill 4
	"killallnpc" ::WoWEmu::Commands::killallnpc 4
	"learn" ::WoWEmu::Commands::learn 4
	"learnsk" ::WoWEmu::Commands::learnsk 4
	"listsk" ::WoWEmu::Commands::listsk 2
	"listsp" ::WoWEmu::Commands::listsp 2
	"move" ::WoWEmu::Commands::move 4
	"movelog" ::WoWEmu::Commands::movelog 6
	"namego" ::WoWEmu::Commands::namego 4
	"online" ::WoWEmu::Commands::online 2
	"paralyse" ::WoWEmu::Commands::paralyse 4
	"pingmm" ::WoWEmu::Commands::pingmm 2
	"ppoff" ::WoWEmu::Commands::ppoff 6
	"ppon" ::WoWEmu::Commands::ppon 6
	"rehash" ::WoWEmu::Commands::rehash 6
	"rescp" ::WoWEmu::Commands::rescp 6
	"respawnall" ::WoWEmu::Commands::respawnall 6
	"resurrect" ::WoWEmu::Commands::resurrect 2
	"retcl" ::WoWEmu::Commands::retcl 6
	"rotate" ::WoWEmu::Commands::rotate 4
	"save" ::WoWEmu::Commands::save 6
	"setaura" ::WoWEmu::Commands::setaura 2
	"setcp" ::WoWEmu::Commands::setcp 4
	"setfaction" ::WoWEmu::Commands::setfaction 6
	"setflags" ::WoWEmu::Commands::setflags 4
	"sethp" ::WoWEmu::Commands::sethp 4
	"setlevel" ::WoWEmu::Commands::setlevel 4
	"setmodel" ::WoWEmu::Commands::setmodel 4
	"setnpcflags" ::WoWEmu::Commands::setnpcflags 4
	"setreststate" ::WoWEmu::Commands::setreststate 2
	"setsize" ::WoWEmu::Commands::setsize 4
	"setspawndist" ::WoWEmu::Commands::setspawndist 4
	"setspawngo" ::WoWEmu::Commands::setspawngo 4
	"setspawnnpc" ::WoWEmu::Commands::setspawnnpc 4
	"setspawntime" ::WoWEmu::Commands::setspawntime 4
	"setspeed" ::WoWEmu::Commands::setspeed 4
	"setxp" ::WoWEmu::Commands::setxp 4
	"shutdown" ::WoWEmu::Commands::shutdown 6
	"starttimer" ::WoWEmu::Commands::starttimer 2
	"stoptimer" ::WoWEmu::Commands::stoptimer 2
	"targetgo" ::WoWEmu::Commands::targetgo 4
	"targetlink" ::WoWEmu::Commands::targetlink 4
	"test" ::WoWEmu::Commands::test 6
	"test2" ::WoWEmu::Commands::test2 6
	"turn" ::WoWEmu::Commands::turn 4
	"unlearn" ::WoWEmu::Commands::unlearn 4
	"unlearnsk" ::WoWEmu::Commands::unlearnsk 4
	"where" ::WoWEmu::Commands::where 0

        "healthstone" Commands::HealthStone 0
        "trollblood" Commands::trollblood 0
	"loot" Commands::loot 6
	"guards" Commands::guards 0
	"change" Commands::change 0
	"additem" ::WoWEmu::Commands::additem 4
	"addmoney" ::WoWEmu::Commands::addmoney 4
	"addswp" ::WoWEmu::Commands::addswp 4
	"addtele" ::WoWEmu::Commands::addtele 4
	"addwp" ::WoWEmu::Commands::addwp 4
	"ban" ::WoWEmu::Commands::ban 4
	"bug" ::WoWEmu::Commands::bug 0
	
	"changepassword" ::WoWEmu::Commands::changepassword 6
	"delitem" ::WoWEmu::Commands::delitem 4
	"delmoney" ::WoWEmu::Commands::delmoney 4
	"deltele" ::WoWEmu::Commands::deltele 4
	"dismiss" ::WoWEmu::Commands::dismiss 0
	"endway" ::WoWEmu::Commands::endway 4
	"imit" ::WoWEmu::Commands::imit 4
	"invisible" ::WoWEmu::Commands::invisible 4
	"isgm" ::WoWEmu::Commands::isgm 0
	"langall" ::WoWEmu::Commands::langall 4
	"learnall" ::WoWEmu::Commands::learnall 4
	"listbugs" ::WoWEmu::Commands::listbugs 4
	"listtele" ::WoWEmu::Commands::listtele 4
	"mergewp" ::WoWEmu::Commands::mergewp 4
	
	"problem" ::WoWEmu::Commands::problem 0
	"refresh" ::WoWEmu::Commands::refresh 0
	"setmessage" ::WoWEmu::Commands::setmessage 5
	"setpassword" ::WoWEmu::Commands::setpassword 6
	"setwp" ::WoWEmu::Commands::setwp 6
	"showwp" ::WoWEmu::Commands::showwp 4
	"startway" ::WoWEmu::Commands::startway 4
	"tame" ::WoWEmu::Commands::tame 0
	"tele" ::WoWEmu::Commands::tele 3
	"visible" ::WoWEmu::Commands::visible 4
        "arena" ::WoWEmu::Commands::arena 0
        "getout" ::WoWEmu::Commands::getout 0

        "learnallform" ::WoWEmu::Commands::learnallform 4
        "t2warrior" ::WoWEmu::Commands::t2warrior 4
        "t2paladin" ::WoWEmu::Commands::t2paladin 4
        "t2shaman" ::WoWEmu::Commands::t2shaman 4
        "t2priest" ::WoWEmu::Commands::t2priest 4
        "t2druid" ::WoWEmu::Commands::t2druid 4
        "t2mage" ::WoWEmu::Commands::t2mage 4
        "t2warlock" ::WoWEmu::Commands::t2warlock 4
        "t2hunter" ::WoWEmu::Commands::t2hunter 4
        "t2rogue" ::WoWEmu::Commands::t2rogue 4
        "t3warrior" ::WoWEmu::Commands::t3warrior 4
        "t3druid" ::WoWEmu::Commands::t3druid 4
        "t3hunter" ::WoWEmu::Commands::t3hunter 4
        "t3shaman" ::WoWEmu::Commands::t3shaman 4
        "t3paladin" ::WoWEmu::Commands::t3paladin 4
        "t3warlock" ::WoWEmu::Commands::t3warlock 4
        "t3mage" ::WoWEmu::Commands::t3mage 4
        "t3priest" ::WoWEmu::Commands::t3priest 4
        "t3rogue" ::WoWEmu::Commands::t3rogue 4
        "t1warrior" ::WoWEmu::Commands::t1warrior 4
        "t1paladin" ::WoWEmu::Commands::t1paladin 4
        "t1druid" ::WoWEmu::Commands::t1druid 4
        "t1hunter" ::WoWEmu::Commands::t1hunter 4
        "maxskill" ::WoWEmu::Commands::maxskill 4
        "t1mage" ::WoWEmu::Commands::t1mage 4
        "t1priest" ::WoWEmu::Commands::t1priest 4
        "t1rogue" ::WoWEmu::Commands::t1rogue 4
        "t1shaman" ::WoWEmu::Commands::t1shaman 4
        "t1warlock" ::WoWEmu::Commands::t1warlock 4
        "res" ::WoWEmu::Commands::res 2
	"sd" ::WoWEmu::Commands::sd 4
	"st" ::WoWEmu::Commands::st 4
        "apdruid" ::WoWEmu::Commands::apdruid 4
        "hpdruid" ::WoWEmu::Commands::hpdruid 4
        "hphunter" ::WoWEmu::Commands::hphunter 4
        "aphunter" ::WoWEmu::Commands::aphunter 4
        "hpmage" ::WoWEmu::Commands::hpmage 4
        "apmage" ::WoWEmu::Commands::apmage 4
        "pvpaladin" ::WoWEmu::Commands::pvpaladin 4
        "hppriest" ::WoWEmu::Commands::hppriest 4
        "appriest" ::WoWEmu::Commands::appriest 4
        "hprogue" ::WoWEmu::Commands::hprogue 4
        "aprogue" ::WoWEmu::Commands::aprogue 4
        "pvshaman" ::WoWEmu::Commands::pvshaman 4
        "hpwarlock" ::WoWEmu::Commands::hpwarlock 4
        "apwarlock" ::WoWEmu::Commands::apwarlock 4
        "hpwarrior" ::WoWEmu::Commands::hpwarrior 4
        "apwarrior" ::WoWEmu::Commands::apwarrior 4
        "learnallsp" ::WoWEmu::Commands::learnallsp 4
        "aohelp" ::WoWEmu::Commands::aohelp 0

}

