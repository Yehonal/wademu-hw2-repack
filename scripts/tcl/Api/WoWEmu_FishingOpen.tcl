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
# Name:		WoWEmu_FishingOpen.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	variable ::WoWEmu::FishingZones
#
variable ::WoWEmu::FishingZones
array set ::WoWEmu::FishingZones {
	1	50
	2	100
	8	225
	9	50
	10	50
	11	150
	12	50
	14	50
	15	225
	16	275
	17	275
	18	50
	28	290
	33	225
	35	225
	37	225
	38	100
	40	100
	43	225
	44	125
	45	200
	47	250
	57	50
	60	50
	61	50
	62	50
	63	50
	64	50
	68	150
	69	125
	71	225
	74	225
	75	225
	76	225
	85	50
	86	50
	87	50
	88	50
	89	50
	92	50
	100	225
	102	225
	104	225
	115	100
	116	225
	117	225
	122	225
	129	225
	130	100
	139	300
	141	50
	146	50
	150	150
	162	50
	163	50
	168	50
	169	50
	172	100
	187	50
	188	50
	193	290
	202	290
	211	50
	221	50
	223	50
	226	100
	227	100
	237	100
	249	280
	256	50
	258	50
	259	50
	265	50
	266	50
	267	150
	271	150
	272	150
	279	200
	284	200
	295	150
	297	225
	298	150
	299	150
	300	225
	301	225
	302	225
	305	100
	306	100
	307	250
	309	100
	310	225
	311	225
	312	225
	314	200
	317	200
	323	100
	324	200
	327	200
	328	200
	331	150
	350	250
	351	250
	353	250
	356	250
	361	250
	363	50
	367	50
	368	50
	373	50
	374	50
	375	300
	382	125
	384	125
	385	125
	386	125
	387	125
	388	125
	391	125
	392	125
	393	50
	401	125
	405	200
	406	135
	414	150
	415	150
	416	150
	418	150
	420	150
	421	150
	422	150
	424	150
	429	150
	433	150
	434	150
	437	150
	441	150
	442	100
	443	100
	445	100
	448	100
	449	100
	452	100
	453	100
	454	100
	456	100
	460	135
	463	275
	464	135
	478	50
	490	275
	493	300
	496	225
	497	225
	501	225
	502	225
	504	225
	508	225
	509	225
	510	225
	511	225
	513	225
	516	225
	517	225
	518	200
	537	250
	538	250
	542	250
	543	250
	556	50
	576	150
	598	200
	602	200
	604	200
	618	300
	636	135
	656	300
	657	225
	702	50
	719	135
	720	135
	797	225
	799	150
	810	50
	814	50
	815	125
	818	50
	878	275
	879	150
	896	150
	917	100
	919	100
	922	100
	923	50
	927	50
	968	250
	977	250
	978	250
	979	250
	983	250
	988	250
	997	125
	998	125
	1001	125
	1002	125
	1008	250
	1017	150
	1018	150
	1020	150
	1021	150
	1022	150
	1023	150
	1024	150
	1025	150
	1039	150
	1056	290
	1097	150
	1099	300
	1101	250
	1102	250
	1106	250
	1112	250
	1116	250
	1117	250
	1119	250
	1120	250
	1121	250
	1126	225
	1136	250
	1156	225
	1176	250
	1222	275
	1227	275
	1228	275
	1229	275
	1230	275
	1231	275
	1234	275
	1256	275
	1296	50
	1297	50
	1336	250
	1337	250
	1338	100
	1339	200
	1477	275
	1519	50
	1557	175
	1577	225
	1578	225
	1581	100
	1617	50
	1638	50
	1662	50
	1681	200
	1682	200
	1684	200
	1701	125
	1738	225
	1739	225
	1740	225
	1760	225
	1762	250
	1764	225
	1765	225
	1767	275
	1770	275
	1777	225
	1778	225
	1780	225
	1797	225
	1798	225
	1883	250
	1884	250
	1939	250
	1940	250
	1942	250
	1977	225
	1997	275
	1998	275
	2017	300
	2077	100
	2078	100
	2079	225
	2097	175
	2100	245
	2158	250
	2246	300
	2256	300
	2270	300
	2272	300
	2277	300
	2279	300
	2298	300
	2302	225
	2317	250
	2318	225
	2321	275
	2322	50
	2323	250
	2324	200
	2325	150
	2326	100
	2364	100
	2365	150
	2398	100
	2399	50
	2400	250
	2401	200
	2402	100
	2403	225
	2405	200
	2408	200
	2457	150
	2477	300
	2481	275
	2521	250
	2522	250
	2558	300
	2562	300
	2597	300
	2618	275
	2619	300
	2620	290
	2624	300
	2631	300
	2797	150
	2837	300
	2897	150
}


#
#	proc ::WoWEmu::FishingOpen { player bobber deep }
#
proc ::WoWEmu::FishingOpen { player bobber deep } {
	variable FishingData
	variable FishingZones

	array unset FishingData $player

	if { [ ::GetQFlag $player openfish ] } {
		::ClearQFlag $player openfish
		set LocNumber [ ::GetLocation $bobber ]
		set ZoneLoot  [ string trim [ expr { $LocNumber + 30000 } ] ]
		set PlayerSkl [ ::GetSkill $player 356 ]

		if { [ info exists FishingZones($LocNumber) ] } {
			set ZoneMaxSkill $FishingZones($LocNumber)
		} else {
			set ZoneMaxSkill 50
			set ZoneLoot 30000
		}

		if { ( $PlayerSkl < $ZoneMaxSkill ) && ( $PlayerSkl < 300 ) } {
			if { $PlayerSkl < ( $ZoneMaxSkill-50 ) } {
				::BreakSpellLink $player
				::FishEscaped $player
				::Loot $player $bobber 33000 5
				return 0
			}

			set Prob [ expr { 1.5 * ( $ZoneMaxSkill - $PlayerSkl ) + 25 } ]
			set Dice [ expr { rand() * 100 } ]

			if { $Dice < $Prob } {
				incr PlayerSkl
				::SetSkill $player 356 $PlayerSkl 300
			}
		}

		::BreakSpellLink $player
		::Loot $player $bobber $ZoneLoot 3
	} else {
		::BreakSpellLink $player
		::FishNotHooked $player
		::Loot $player $bobber 33000 5
		return 0
	}
}

