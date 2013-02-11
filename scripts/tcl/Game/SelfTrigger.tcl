#
# Start-TCL: z
#
# ====================================
#
# Additional Spells & Effects script v2.1 (c) Delfin 
# creds: seatleson, BAD, DayDream
#
# ====================================
#
# 07-10-2006 Reorganised by AceIndy
#
# Start-TCL 0.9.4 compatible
#
# Fully Autonomous
#

##########
#
# defined namespace
#

### Script Namespaces ###
namespace eval ::SelfTrigger {
	StartTCL::Provide

	variable ::SelfTrigger::Spells
	array set ::SelfTrigger::Spells {
	  465	30037
	  643	30039
	 1032	30041
	 1032	30042
	 1130	30058
	 5242	30063
	 6192	30064
	 6673	30062
	 6940	50120
	 7294	30044
	 8233	50128
	 8236	50129
	 8516	50132
	10290	30038
	10291	30040
	10292	30042
	10293	30043
	10298	30045
	10299	30046
	10300	30047
	10301	30048
	10484	50130
	10608	50133
	10610	50134
	11549	30065
	11550	30066
	11551	30067
	12964	50135
	14278	50127
	14323	30059
	14324	30060
	14325	30061
	16361	50131
	16459	18941
	17364	18941
	19506	50109
	19876	30049
	19888	30052
	19891	30055
	19895	30050
	19896	30051
	19897	30053
	19898	30054
	19899	30056
	19900	30057
	20043	50118
	20178	18941
	20190	50119
	20729	50121
	20905	50110
	20906	50111
	23602	50135
	50024	30068
	50025	30069
	50123	20167
	50124	20333
	50125	20334
	50126	20340
	50147	20168
	50148	20350
	50149	20351
	}
}

#
# SelfTrigger
#
	proc ::SelfTrigger::OnCastSelfTrigger { to from spellid } {
		::CastSpell $from $from $::SelfTrigger::Spells($spellid)
		return "done"
	}

#
# Init Procedure
#
proc ::SelfTrigger::Init { } {
	if { [ info exists "::StartTCL::VERSION" ] } {
		::Custom::AddSpellScript "::SelfTrigger::OnCastSelfTrigger" [ array names ::SelfTrigger::Spells ]
	} else {
		# setup the system to deal with these spells as usual
	}
}

::SelfTrigger::Init
