# StartTCL: n
#

namespace eval ::PetSyStem {
variable pbasedir "data/pets"
variable VERSION 1.2
if { ! [ file exists $pbasedir ] } {file mkdir $pbasedir}
}

proc ::PetSyStem::addonproc { player cargs {spellid 0} } {
	variable pbasedir
	set pname [ ::GetName $player ]
	set plevel [ ::GetLevel $player ]
	set pet [ ::GetSelection $player ]
	set pguid [ ::GetGuid $player ]
	set petid [ ::GetEntry $pet ]
	set petguid [ ::GetLinkObject $pet ]
	if { $player != $petguid } {return [ ::Texts::Get "select_pet" ]}
	set pethp [ ::GetHealthPCT $pet ]
	if { $pethp < 90 } {return [ ::Texts::Get "pet_more_life" ]}
	set pclass [ ::GetClass $player ]
	if { $pclass != 9 && $pclass!= 3 } {return}
	if { ! [ file exists "$pbasedir/$pname" ] } {
		set file "$pbasedir/$pname"
		set id [ open $file w+ ]
		puts $id "0 0 0"
		close $id
	}
	#class hunter##########
	if { $pclass == 3 } {
		set file "$pbasedir/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		foreach { pet1 pet2 pet3 } $list {}
		if { $pet1 == 0 && $pet2 == 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid 0 0"
			puts $id $newlist
			close $id
		}
		if { $pet1 != 0 && $pet2 == 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid $pet1 0"
			puts $id $newlist
			close $id
		}
		if { $pet1 != 0 && $pet2 != 0 && $pet3 == 0 } {
			set id [ open $file w+ ]
			set newlist "$petid $pet2 $pet1"
			puts $id $newlist
			close $id
		}
		if { $pet1 != 0 && $pet2 != 0 && $pet3 != 0 } {return "PET_DISMISS_ERROR_TOO"}
	}
	#class warlock #################
	if { $pclass == 9 } {
		set file "$pbasedir/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		set pet1 [ lindex $list 0 ]
		set id [ open $file w+ ]
		set newlist "$petid"
		puts $id $newlist
		close $id
	}
}

proc ::PetSyStem::addoncallpet { player cargs } {
	variable pbasedir
	set pclass [ ::GetClass $player ]
	set plevel [ ::GetLevel $player ]
	set pname [ ::GetName $player ]
	if { $pclass == 9 } {
		set file "$pbasedir/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		set pet1 [ lindex $list 0 ]
		set id [ open $file r+ ]
		puts $id "0"
		close $id
		if { $pet1 == 416 } {::CastSpell $player $player 23503}
		if { $pet1 == 417 } {::CastSpell $player $player 23500}
		if { $pet1 == 1860 } {::CastSpell $player $player 23501}
		if { $pet1 == 1863 } {::CastSpell $player $player 23502}
		if { $pet1 == 89 } {::CastSpell $player $player 12740}
		if { $pet1 == 8616 } {::CastSpell $player $player 12740}
		if { $pet1 == 14385 } {::CastSpell $player $player 22865}
	}
	if { $pclass == 3 } {
		set file "$pbasedir/$pname"
		set id [ open $file r+ ]
		gets $id list
		close $id
		foreach { pet1  pet2 pet3 } $list {}
		set pet 0
		if { $pet1 != 0 } {
			set pet $pet1
			set pet1 0
		} else {
			if { $pet2 != 0 } {
				set pet $pet2
				set pet2 0
			} else {
				if { $pet3 != 0 } {
				set pet $pet3
				set pet3 0
				}
			}
		}
		set id [ open $file w+ ]
		set newlist "$pet1 $pet2 $pet3"
		puts $id $newlist
		close $id
		set wolf "3823 3824 3825 1258 923 628 118 5449 69 213 299 525 565 704 705 1131 1133 1138 1817 1922 2680 2681 2924 2958 2960 3939 8959 10981 13618 833 834 2727 2728 2729 2730"
		set bear "8956 822 1128 1129 1186 1797 1778 1196 1189 1188 1815 2163 2164 2165 2351 3810 3809 2356 2354 3811 5268 5272 5433 7444"
		set bird "5436 1194 2578 2579 2580 2829 2830 2831 6013"
		set boar "113 524 708 1125 1126 1127 1190 1191 1192 1689 1984 1985 2966 3098 3099 3100 3225 5992 5437"
		set cat "3566 15101 3425 5438 2043 2042 2034 2033 2032 2031 3619 4242 7430 7431 7432 7433 7434 10042 681 682 698 976 1085 3121 2407 2406 2385 2384"
		set crawler "5439 830 831 922 1088 1216 2231 2232 2233 2234 2235 2236 2544 3106 3107 3108 3228 3812 3814 6250 12347"
		set crocolisk "5440 1082 1084 1150 1151 1152 1400 1417 1693 2089 2476 3110 3231 4341 4344 5053"
		set gorilla "5442 1108 1511 1557 2521 6514"
		set raptor "3254 3255 3256 5444 685 686 856 855 1015 1020 4351"
		set scorpid "5445 3124 3125 3126 3127 3226 4139 4140 5422 5423 5424 7078 7405 7803 9691 9695 9698 9701 11735"
		set spider "5446 30 43 217 539 1504 1505 1555 1986 2001 4376 4413 4415 5856 5857 5858 10375 14881"
		foreach x $wolf {
			if { $x == $pet } {
				if { $plevel < 20 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 4946
			}
		}
		foreach x $bear {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7903
			}
		}
		foreach x $bird {
			if { $x == $pet } {
				if { $plevel < 12 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7904
			}
		}
		foreach x $boar {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7905
			}
		}
		foreach x $cat {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7906
			}
		}
		foreach x $crawler {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7907
			}
		}
		foreach x $crocolisk {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7908
			}
		}
		foreach x $gorilla {
			if { $x == $pet } {
				if { $plevel < 50 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7909
			}
		}
		foreach x $raptor {
			if { $x == $pet } {
				if { $plevel < 40 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7910
			}
		}
		foreach x $scorpid {
			if { $x == $pet } {
				if { $plevel < 35 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7911
			}
		}
		foreach x $spider {
			if { $x == $pet } {
				if { $plevel < 30 } {
					return [ ::Texts::Get "pet_ran_away" ]
				}
				::CastSpell $player $player 7912
			}
		}
		if { $pet == 5448 } {::CastSpell $player $player 7915}
		if { $pet == 5443 } {::CastSpell $player $player 7916}
		if { $pet == 4535 } {::CastSpell $player $player 8274}
		if { $pet == 4534 } {::CastSpell $player $player 8276}
	}
}

 ::Custom::AddCommand "pet_petdismiss" "::PetSyStem::addonproc"
 ::Custom::AddCommand "callpet" "::PetSyStem::addoncallpet"
