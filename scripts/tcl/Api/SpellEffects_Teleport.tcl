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
# Name:		SpellEffects_Teleport.tcl
#
# Description:	TCL API procedures
#
# Based on original WAD and on contributions from the community, thanks to all.
#
#


#
#	proc ::SpellEffects::SPELL_EFFECT_TELEPORT_UNITS { to from spellid }
#
proc ::SpellEffects::SPELL_EFFECT_TELEPORT_UNITS { to from spellid } {
	variable TeleportTime

	set time [ clock seconds ]
	set cooldown [ expr { [ info exists ::AI::SpellData($spellid) ] ? [ lindex $::AI::SpellData($spellid) 1 ] : 0 } ]

	if { [ info exists TeleportTime($from,$spellid) ] && [ set timeleft [ expr { $cooldown - $time + $TeleportTime($from,$spellid) } ] ] > 0 } {
		::Say $from 0 [ ::Texts::Get "teleport_not_ready" [ ::Custom::SecondsToTime $timeleft ] ]
		return
	}

	set TeleportTime($from,$spellid) $time

	switch -- $spellid {
		31	{ ::Teleport $to 1 -994.248169 -3830.104004 7.0 }
		33	{ ::Teleport $to 0 -13923.823242 1313.069580 6.0 }
		34	{ ::Teleport $to 0 -13828.068359 1299.230347 7.0 }
		35	{ ::Teleport $to 0 -14002.620117 1271.615479 3 }
		427	{ ::Teleport $to 0 2889.91 -811.148 160.332 }
		428	{ ::Teleport $to 0 -11025.184570 1497.860596 43.195259 }
		442	{ ::Teleport $to 0 -8929 -116 83 }
		444	{ ::Teleport $to 0 -11409.933594 1968.416504 10.427084 }
		445	{ ::Teleport $to 0 -10413.885742 -1136.884888 24.128809 }
		446	{ ::Teleport $to 0 -10531.167969 296.656219 30.964926 }
		665	-
		3561	-
		17334	{ ::Teleport $to 0 -8960.140625 516.265686 96.356819 }
		1936	{ ::Teleport $to 0 -6132 384 395.5 }
		3562	-
		3581	-
		17607	{ ::Teleport $to 0 -5032 -819 495 }
		3563	-
		3577	-
		17611	{ ::Teleport $to 0 1819.708374 238.789505 60.532143 }
		3566	-
		3579	-
		17610	{ ::Teleport $to 1 -1391.0 140.0 22.478 }
		3567	-
		3580	-
		17609	{ ::Teleport $to 1 1552.499268 -4420.658691 8.948024 }
		11362	{ ::Teleport $to 90 -330 -2 -151 }
		11409	{ ::Teleport $to 0 -14319.114258 444.477905 23.054321 }
		12509	-
		12510	{ ::Teleport $to 1 4232.007813 -7802.841309 4.689385 }
		3565	-
		3578	-
		17608	{ ::Teleport $to 1 9951.792969 2145.915771 1327.724854 }
		18960	-
		19027	{ ::Teleport $to 1 7980.842285 -2501.763428 487.576508 }
		556	-
		8690	{	::Custom::GoHome $from }
		default { puts "Can't find teleport for spellid=$spellid" }
                
      2369 { GatherSkill $from $to 182 }
      2575 { GatherSkill $from $to 186 }
      2576 { GatherSkill $from $to 186 }
      2577 { GatherSkill $from $to 186 }
      2579 { GatherSkill $from $to 186 }
      3564 { GatherSkill $from $to 186 }
      10248 { GatherSkill $from $to 186 }
      
      2366 { GatherSkill $from $to 182 }
      2368 { GatherSkill $from $to 182 }
      3570 { GatherSkill $from $to 182 }
      11993 { GatherSkill $from $to 182 }
      
      8613 { skinning $from $to }
      8617 { skinning $from $to }
      8618 { skinning $from $to }
      10768 { skinning $from $to }
      
      13262 { disenchant $from $to }
      
      2149 { ProfSkill $from 165 40 55 70 2302 1 0 }  
      2152 { ProfSkill $from 165 30 45 60 2304 1 0 }  
      2153 { ProfSkill $from 165 45 60 75 2303 1 0 }  
      2158 { ProfSkill $from 165 120 135 150 2307 1 0 }  
      2159 { ProfSkill $from 165 105 120 135 2308 1 0 }  
      2160 { ProfSkill $from 165 70 85 100 2300 1 0 }  
      2161 { ProfSkill $from 165 85 100 115 2309 1 0 }  
      2162 { ProfSkill $from 165 90 105 120 2310 1 0 }  
      2163 { ProfSkill $from 165 90 105 120 2311 1 0 }  
      2164 { ProfSkill $from 165 105 120 135 2312 1 0 }  
      2165 { ProfSkill $from 165 115 123 130 2313 1 0 }  
      2166 { ProfSkill $from 165 145 158 170 2314 1 0 }  
      2167 { ProfSkill $from 165 125 138 150 2315 1 0 }  
      2168 { ProfSkill $from 165 135 148 160 2316 1 0 }  
      2169 { ProfSkill $from 165 125 138 150 2317 1 0 }  
      2329 { ProfSkill $from 171 55 75 95 2454 1 0 }  
      2330 { ProfSkill $from 171 55 75 95 118 1 0 }  
      2331 { ProfSkill $from 171 65 85 105 2455 1 0 }  
      2332 { ProfSkill $from 171 70 90 110 2456 1 0 }  
      2333 { ProfSkill $from 171 165 185 205 3390 1 0 }  
      2334 { ProfSkill $from 171 80 100 120 2458 1 0 }  
      2334 { ProfSkill $from 171 80 100 120 2458 1 0 }  
      2335 { ProfSkill $from 171 90 110 130 2459 1 0 }  
      2336 { ProfSkill $from 171 100 120 140 2460 1 0 }  
      2337 { ProfSkill $from 171 85 105 125 858 1 0 }  
      2385 { ProfSkill $from 197 45 58 70 2568 1 0 }  
      2386 { ProfSkill $from 197 90 108 125 2569 1 0 }  
      2387 { ProfSkill $from 197 35 48 60 2570 1 0 }  
      2389 { ProfSkill $from 197 65 83 100 2572 1 0 }  
      2392 { ProfSkill $from 197 65 83 100 2575 1 0 }  
      2393 { ProfSkill $from 197 35 48 60 2576 1 0 }  
      2394 { ProfSkill $from 197 65 83 100 2577 1 0 }  
      2395 { ProfSkill $from 197 95 113 130 2578 1 0 }  
      2396 { ProfSkill $from 197 95 113 130 2579 1 0 }  
      2397 { ProfSkill $from 197 85 103 120 2580 1 0 }  
      2399 { ProfSkill $from 197 110 128 145 2582 1 0 }  
      2401 { ProfSkill $from 197 120 138 155 2583 1 0 }  
      2402 { ProfSkill $from 197 100 118 135 2584 1 0 }  
      2403 { ProfSkill $from 197 130 148 165 2585 1 0 }  
      2406 { ProfSkill $from 197 110 120 130 2587 1 0 }  
      2538 { ProfSkill $from 185 45 65 85 2679 1 0 }  
      2539 { ProfSkill $from 185 50 70 90 2680 1 0 }  
      2540 { ProfSkill $from 185 45 65 85 2681 1 0 }  
      2541 { ProfSkill $from 185 90 110 130 2684 1 0 }  
      2542 { ProfSkill $from 185 90 110 130 724 1 0 }  
      2543 { ProfSkill $from 185 115 135 155 733 1 0 }  
      2544 { ProfSkill $from 185 115 135 155 2683 1 0 }  
      2545 { ProfSkill $from 185 125 145 165 2682 1 0 }  
      2546 { ProfSkill $from 185 120 140 160 2687 1 0 }  
      2547 { ProfSkill $from 185 135 155 175 1082 1 0 }  
      2548 { ProfSkill $from 185 130 150 170 2685 1 0 }  
      2549 { ProfSkill $from 185 140 160 180 1017 3 0 }  
      2657 { ProfSkill $from 186 25 48 70 2840 1 0 }  
      2658 { ProfSkill $from 186 95 105 115 2842 1 0 }  
      2659 { ProfSkill $from 186 50 75 100 2841 2 0 }  
      2660 { ProfSkill $from 164 15 35 55 2862 1 0 }  
      2661 { ProfSkill $from 164 75 95 115 2851 1 0 }  
      2662 { ProfSkill $from 164 50 70 90 2852 1 0 }  
      2663 { ProfSkill $from 164 20 40 60 2853 1 0 }  
      2664 { ProfSkill $from 164 115 128 140 2854 1 0 }  
      2665 { ProfSkill $from 164 65 73 80 2863 1 0 }  
      2666 { ProfSkill $from 164 110 130 150 2857 1 0 }  
      2667 { ProfSkill $from 164 120 140 160 2864 1 0 }  
      2668 { ProfSkill $from 164 145 160 175 2865 1 0 }  
      2670 { ProfSkill $from 164 145 160 175 2866 1 0 }  
      2671 { ProfSkill $from 164 145 160 175 2867 1 0 }  
      2672 { ProfSkill $from 164 150 165 180 2868 1 0 }  
      2673 { ProfSkill $from 164 160 175 190 2869 1 0 }  
      2674 { ProfSkill $from 164 125 133 140 2871 1 0 }  
      2675 { ProfSkill $from 164 175 190 205 2870 1 0 }  
      2737 { ProfSkill $from 164 55 75 95 2844 1 0 }  
      2738 { ProfSkill $from 164 60 80 100 2845 1 0 }  
      2739 { ProfSkill $from 164 65 85 105 2847 1 0 }  
      2740 { ProfSkill $from 164 140 155 170 2848 1 0 }  
      2741 { ProfSkill $from 164 145 160 175 2849 1 0 }  
      2742 { ProfSkill $from 164 150 165 180 2850 1 0 }  
      2795 { ProfSkill $from 185 60 80 100 2888 1 0 }  
      2835 { ProfSkill $from 40 175 200 225 2892 1 0 }  
      2837 { ProfSkill $from 40 215 240 265 2893 1 0 }  
      2881 { ProfSkill $from 165 20 30 40 2318 1 0 }  
      2963 { ProfSkill $from 197 25 38 50 2996 1 0 }  
      2964 { ProfSkill $from 197 90 98 105 2997 1 0 }  
                   
      3115 { ProfSkill $from 164 15 35 55 3239 1 0 }  
      3116 { ProfSkill $from 164 65 73 80 3240 1 0 }  
      3117 { ProfSkill $from 164 125 133 140 3241 1 0 }  
      3170 { ProfSkill $from 171 60 80 100 3382 1 0 }  
      3171 { ProfSkill $from 171 120 140 160 3383 1 0 }  
      3172 { ProfSkill $from 171 135 155 175 3384 1 0 }  
      3173 { ProfSkill $from 171 145 165 185 3385 1 0 }  
      3174 { ProfSkill $from 171 145 165 185 3386 1 0 }  
      3175 { ProfSkill $from 171 275 295 315 3387 1 0 }  
      3176 { ProfSkill $from 171 150 170 190 3388 1 0 }  
      3177 { ProfSkill $from 171 155 175 195 3389 1 0 }  
      3188 { ProfSkill $from 171 175 195 215 3391 1 0 }  
      3230 { ProfSkill $from 171 80 100 120 2457 1 0 }  
      3275 { ProfSkill $from 129 30 45 60 1251 1 0 }  
      3276 { ProfSkill $from 129 50 75 100 2581 1 0 }  
      3277 { ProfSkill $from 129 80 115 150 3530 1 0 }  
      3278 { ProfSkill $from 129 115 150 185 3531 1 0 }  
      3292 { ProfSkill $from 164 135 155 175 3487 1 0 }  
      3293 { ProfSkill $from 164 75 95 115 3488 1 0 }  
      3294 { ProfSkill $from 164 110 130 150 3489 1 0 }  
      3295 { ProfSkill $from 164 155 170 185 3490 1 0 }  
      3296 { ProfSkill $from 164 160 175 190 3491 1 0 }  
      3297 { ProfSkill $from 164 175 190 205 3492 1 0 }  
      3304 { ProfSkill $from 186 50 63 75 3576 1 0 }  
      3307 { ProfSkill $from 186 125 135 150 3575 1 0 }  
      3308 { ProfSkill $from 186 170 178 185 3577 1 0 }  
      3319 { ProfSkill $from 164 60 80 100 3469 1 0 }  
      3320 { ProfSkill $from 164 45 65 85 3470 1 0 }  
      3321 { ProfSkill $from 164 75 95 115 3471 1 0 }  
      3323 { ProfSkill $from 164 80 100 120 3472 1 0 }  
      3324 { ProfSkill $from 164 85 105 125 3473 1 0 }  
      3325 { ProfSkill $from 164 100 120 140 3474 1 0 }  
      3326 { ProfSkill $from 164 75 88 100 3478 1 0 }  
      3328 { ProfSkill $from 164 140 155 170 3480 1 0 }  
      3330 { ProfSkill $from 164 155 170 185 3481 1 0 }  
      3331 { ProfSkill $from 164 160 175 190 3482 1 0 }  
      3333 { ProfSkill $from 164 165 180 195 3483 1 0 }  
      3334 { ProfSkill $from 164 175 190 205 3484 1 0 }  
      3336 { ProfSkill $from 164 180 195 210 3485 1 0 }  
      3337 { ProfSkill $from 164 125 138 150 3486 1 0 }  
      3370 { ProfSkill $from 185 120 140 160 3662 1 0 }  
      3371 { ProfSkill $from 185 100 120 140 3220 2 0 }  
      3372 { ProfSkill $from 185 130 150 170 3663 1 0 }  
      3373 { ProfSkill $from 185 160 180 200 3664 1 0 }  
      3376 { ProfSkill $from 185 170 190 210 3665 1 0 }  
      3377 { ProfSkill $from 185 150 170 190 3666 1 0 }  
      3397 { ProfSkill $from 185 150 170 190 3726 1 0 }  
      3398 { ProfSkill $from 185 175 195 215 3727 1 0 }  
      3399 { ProfSkill $from 185 190 210 230 3728 1 0 }  
      3400 { ProfSkill $from 185 215 235 255 3729 1 0 }  
      3420 { ProfSkill $from 40 125 150 175 3775 1 0 }  
      3421 { ProfSkill $from 40 275 300 325 3776 1 0 }  
      3447 { ProfSkill $from 171 135 155 175 929 1 0 }  
      3448 { ProfSkill $from 171 185 205 225 3823 1 0 }  
      3449 { ProfSkill $from 171 190 210 230 3824 1 0 }  
      3450 { ProfSkill $from 171 195 215 235 3825 1 0 }  
      3451 { ProfSkill $from 171 200 220 240 3826 1 0 }  
      3452 { ProfSkill $from 171 180 200 220 3827 1 0 }  
      3453 { ProfSkill $from 171 215 235 255 3828 1 0 }  
      3454 { ProfSkill $from 171 220 240 260 3829 1 0 }  
      3491 { ProfSkill $from 164 135 150 165 3848 1 0 }  
      3492 { ProfSkill $from 164 185 198 210 3849 1 0 }  
      3493 { ProfSkill $from 164 200 213 225 3850 1 0 }  
      3494 { ProfSkill $from 164 180 193 205 3851 1 0 }  
      3495 { ProfSkill $from 164 195 208 220 3852 1 0 }  
      3496 { ProfSkill $from 164 205 218 230 3853 1 0 }  
      3497 { ProfSkill $from 164 225 238 250 3854 1 0 }  
      3498 { ProfSkill $from 164 210 223 235 3855 1 0 }  
      3500 { ProfSkill $from 164 225 238 250 3856 1 0 }  
      3501 { ProfSkill $from 164 190 203 215 3835 1 0 }  
      3502 { ProfSkill $from 164 195 208 220 3836 1 0 }  
      3503 { ProfSkill $from 164 215 228 240 3837 1 0 }  
      3504 { ProfSkill $from 164 185 198 210 3840 1 0 }  
      3505 { ProfSkill $from 164 200 213 225 3841 1 0 }  
      3506 { ProfSkill $from 164 180 193 205 3842 1 0 }  
      3507 { ProfSkill $from 164 195 208 220 3843 1 0 }  
      3508 { ProfSkill $from 164 205 218 230 3844 1 0 }  
      3511 { ProfSkill $from 164 220 233 245 3845 1 0 }  
      3513 { ProfSkill $from 164 210 223 235 3846 1 0 }  
      3515 { ProfSkill $from 164 225 238 250 3847 1 0 }  
      3569 { ProfSkill $from 186 165 165 165 3859 1 0 }  
      3753 { ProfSkill $from 165 55 70 85 4237 1 0 }  
      3755 { ProfSkill $from 197 70 88 105 4238 1 0 }  
      3756 { ProfSkill $from 165 85 100 115 4239 1 0 }  
      3757 { ProfSkill $from 197 105 123 140 4240 1 0 }  
      3758 { ProfSkill $from 197 120 138 155 4241 1 0 }  
      3759 { ProfSkill $from 165 105 120 135 4242 1 0 }  
      3760 { ProfSkill $from 165 170 180 190 3719 1 0 }  
      3761 { ProfSkill $from 165 115 130 145 4243 1 0 }  
      3762 { ProfSkill $from 165 125 138 150 4244 1 0 }  
      3763 { ProfSkill $from 165 110 125 140 4246 1 0 }  
      3764 { ProfSkill $from 165 170 183 195 4247 1 0 }  
      3765 { ProfSkill $from 165 155 168 180 4248 1 0 }  
      3766 { ProfSkill $from 165 150 163 175 4249 1 0 }  
      3767 { ProfSkill $from 165 145 158 170 4250 1 0 }  
      3768 { ProfSkill $from 165 155 168 180 4251 1 0 }  
      3769 { ProfSkill $from 165 165 178 190 4252 1 0 }  
      3770 { ProfSkill $from 165 160 173 185 4253 1 0 }  
      3771 { ProfSkill $from 165 170 180 190 4254 1 0 }  
      3772 { ProfSkill $from 165 175 185 195 4255 1 0 }  
      3773 { ProfSkill $from 165 195 205 215 4256 1 0 }  
      3774 { ProfSkill $from 165 180 190 200 4257 1 0 }  
      3775 { ProfSkill $from 165 190 200 210 4258 1 0 }  
      3776 { ProfSkill $from 165 200 210 220 4259 1 0 }  
      3777 { ProfSkill $from 165 215 225 235 4260 1 0 }  
      3778 { ProfSkill $from 165 205 215 225 4262 1 0 }  
      3779 { ProfSkill $from 165 220 230 240 4264 1 0 }  
      3780 { ProfSkill $from 165 170 180 190 4265 1 0 }  
      3813 { ProfSkill $from 197 170 185 200 4245 1 0 }  
      3816 { ProfSkill $from 165 55 65 75 4231 1 0 }  
      3817 { ProfSkill $from 165 115 123 130 4233 1 0 }  
      3818 { ProfSkill $from 165 160 165 170 4236 1 0 }  
      3839 { ProfSkill $from 197 135 140 145 4305 1 0 }  
      3840 { ProfSkill $from 197 60 78 95 4307 1 0 }  
      3841 { ProfSkill $from 197 85 103 120 4308 1 0 }  
      3842 { ProfSkill $from 197 95 113 130 4309 1 0 }  
      3843 { ProfSkill $from 197 110 128 145 4310 1 0 }  
      3844 { ProfSkill $from 197 125 143 160 4311 1 0 }  
      3845 { ProfSkill $from 197 105 123 140 4312 1 0 }  
      3847 { ProfSkill $from 197 120 138 155 4313 1 0 }  
      3848 { ProfSkill $from 197 135 153 170 4314 1 0 }  
      3849 { ProfSkill $from 197 145 163 180 4315 1 0 }  
      3850 { ProfSkill $from 197 135 153 170 4316 1 0 }  
      3851 { ProfSkill $from 197 150 168 185 4317 1 0 }  
      3852 { ProfSkill $from 197 150 165 180 4318 1 0 }  
      3854 { ProfSkill $from 197 165 180 195 4319 1 0 }  
      3855 { ProfSkill $from 197 150 168 185 4320 1 0 }  
      3856 { ProfSkill $from 197 160 175 190 4321 1 0 }  
      3857 { ProfSkill $from 197 185 200 215 4322 1 0 }  
      3858 { ProfSkill $from 197 190 205 220 4323 1 0 }  
      3859 { ProfSkill $from 197 170 185 200 4324 1 0 }  
      3860 { ProfSkill $from 197 195 210 225 4325 1 0 }  
      3861 { ProfSkill $from 197 205 220 235 4326 1 0 }  
      3862 { ProfSkill $from 197 220 235 250 4327 1 0 }  
      3863 { ProfSkill $from 197 200 215 230 4328 1 0 }  
      3864 { ProfSkill $from 197 220 235 250 4329 1 0 }  
      3865 { ProfSkill $from 197 180 183 185 4339 1 0 }  
      3866 { ProfSkill $from 197 135 153 170 4330 1 0 }  
      3868 { ProfSkill $from 197 150 168 185 4331 1 0 }  
      3869 { ProfSkill $from 197 145 150 155 4332 1 0 }  
      3870 { ProfSkill $from 197 165 170 175 4333 1 0 }  
      3871 { ProfSkill $from 197 180 185 190 4334 1 0 }  
      3872 { ProfSkill $from 197 195 200 205 4335 1 0 }  
      3873 { ProfSkill $from 197 210 215 220 4336 1 0 }  
      3914 { ProfSkill $from 197 55 73 90 4343 1 0 }  
      3915 { ProfSkill $from 197 35 48 60 4344 1 0 }  
      3918 { ProfSkill $from 202 20 30 40 4357 1 0 }  
      3919 { ProfSkill $from 202 30 45 60 4358 2 0 }  
      3921 { ProfSkill $from 202 20 30 40 2518 1 0 }  
      3922 { ProfSkill $from 202 45 53 60 4359 1 0 }  
      3923 { ProfSkill $from 202 60 75 90 4360 2 0 }  
      3924 { ProfSkill $from 202 80 95 110 4361 1 0 }  
      3925 { ProfSkill $from 202 80 95 110 4362 1 0 }  
      3926 { ProfSkill $from 202 95 110 125 4363 1 0 }  
      3928 { ProfSkill $from 202 105 120 135 4401 1 0 }  
      3929 { ProfSkill $from 202 85 90 95 4364 1 0 }  
      3931 { ProfSkill $from 202 90 98 105 4365 1 2 }  
      3932 { ProfSkill $from 202 115 130 145 4366 1 0 }  
      3933 { ProfSkill $from 202 130 145 160 4367 1 0 }  
      3934 { ProfSkill $from 202 130 145 160 4368 1 0 }  
      3936 { ProfSkill $from 202 130 143 155 4369 1 0 }  
      3937 { ProfSkill $from 202 105 130 155 4370 2 2 }  
      3938 { ProfSkill $from 202 105 130 155 4371 1 0 }  
      3939 { ProfSkill $from 202 145 158 170 4372 1 0 }  
      3940 { ProfSkill $from 202 145 158 170 4373 1 0 }  
      3941 { ProfSkill $from 202 120 145 170 4374 1 2 }  
      3942 { ProfSkill $from 202 125 150 175 4375 1 0 }  
      3944 { ProfSkill $from 202 125 150 175 4376 1 0 }  
      3945 { ProfSkill $from 202 125 135 145 4377 1 0 }  
      3946 { ProfSkill $from 202 125 135 145 4378 1 4 }  
      3949 { ProfSkill $from 202 155 168 180 4379 1 0 }  
      3950 { ProfSkill $from 202 140 165 190 4380 2 2 }  
      3952 { ProfSkill $from 202 165 178 190 4381 1 0 }  
      3953 { ProfSkill $from 202 145 170 195 4382 1 0 }  
      3954 { ProfSkill $from 202 170 183 195 4383 1 0 }  
      3955 { ProfSkill $from 202 175 188 200 4384 1 0 }  
      3956 { ProfSkill $from 202 175 188 200 4385 1 0 }  
      3957 { ProfSkill $from 202 175 185 195 4386 1 0 }  
      3958 { ProfSkill $from 202 160 170 180 4387 1 0 }  
      3959 { ProfSkill $from 202 180 190 200 4388 1 0 }  
      3960 { ProfSkill $from 202 185 195 205 4403 1 0 }  
      3961 { ProfSkill $from 202 170 190 210 4389 1 0 }  
      3962 { ProfSkill $from 202 175 195 215 4390 2 2 }  
      3963 { ProfSkill $from 202 175 195 215 4391 1 0 }  
      3964 { ProfSkill $from 202 200 210 220 3034 1 0 }  
      3965 { ProfSkill $from 202 185 205 225 4392 1 0 }  
      3966 { ProfSkill $from 202 205 215 225 4393 1 0 }  
      3967 { ProfSkill $from 202 190 210 230 4394 2 0 }  
      3968 { ProfSkill $from 202 215 225 235 4395 1 0 }  
      3969 { ProfSkill $from 202 220 230 240 4396 1 0 }  
      3971 { ProfSkill $from 202 220 230 240 4397 1 0 }  
      3972 { ProfSkill $from 202 200 220 240 4398 1 0 }  
      3973 { ProfSkill $from 202 110 125 140 4404 5 0 }  
      3977 { ProfSkill $from 202 90 105 120 4405 1 0 }  
      3978 { ProfSkill $from 202 135 148 160 4406 1 0 }  
      3979 { ProfSkill $from 202 200 210 220 4407 1 0 }  
                   
      4094 { ProfSkill $from 185 215 235 255 4457 1 0 }  
      4096 { ProfSkill $from 165 185 195 205 4455 1 0 }  
      4097 { ProfSkill $from 165 185 195 205 4456 1 0 }  
      4508 { ProfSkill $from 171 80 100 120 4596 1 0 }  
      4942 { ProfSkill $from 171 230 250 270 4623 1 0 }  
      5244 { ProfSkill $from 165 70 85 100 5081 1 0 }  
      6412 { ProfSkill $from 185 50 70 90 5472 1 0 }  
      6413 { ProfSkill $from 185 60 80 100 5473 1 0 }  
      6414 { ProfSkill $from 185 75 95 115 5474 2 0 }  
      6415 { ProfSkill $from 185 90 110 130 5476 2 0 }  
      6416 { ProfSkill $from 185 90 110 130 5477 2 0 }  
      6417 { ProfSkill $from 185 130 150 170 5478 2 0 }  
      6418 { ProfSkill $from 185 140 160 180 5479 2 0 }  
      6419 { ProfSkill $from 185 150 170 190 5480 2 0 }  
      6458 { ProfSkill $from 202 160 173 185 5507 1 0 }  
      6499 { ProfSkill $from 185 90 110 130 5525 1 0 }  
      6500 { ProfSkill $from 185 165 185 205 5527 1 0 }  
      6501 { ProfSkill $from 185 130 150 170 5526 1 0 }  
      6510 { ProfSkill $from 40 170 195 220 5530 3 0 }  
      6517 { ProfSkill $from 164 140 155 170 5540 1 0 }  
      6518 { ProfSkill $from 164 170 185 200 5541 1 0 }  
      6521 { ProfSkill $from 197 115 133 150 5542 1 0 }  
      6617 { ProfSkill $from 171 90 110 130 5631 1 0 }  
      6618 { ProfSkill $from 171 195 215 235 5633 1 0 }  
      6619 { ProfSkill $from 171 150 170 190 5632 1 0 }  
      6624 { ProfSkill $from 171 175 195 215 5634 1 0 }  
      6661 { ProfSkill $from 165 210 220 230 5739 1 0 }  
      6686 { ProfSkill $from 197 95 113 130 5762 1 0 }  
      6688 { ProfSkill $from 197 140 158 175 5763 1 0 }  
      6690 { ProfSkill $from 197 155 170 185 5766 1 0 }  
      6692 { ProfSkill $from 197 170 185 200 5770 1 0 }  
      6693 { ProfSkill $from 197 195 210 225 5764 1 0 }  
      6695 { ProfSkill $from 197 205 220 235 5765 1 0 }  
      6702 { ProfSkill $from 165 120 135 150 5780 1 0 }  
      6703 { ProfSkill $from 165 125 140 155 5781 1 0 }  
      6704 { ProfSkill $from 165 190 200 210 5782 1 0 }  
      6705 { ProfSkill $from 165 210 220 230 5783 1 0 }  
      7126 { ProfSkill $from 165 40 55 70 5957 1 0 }  
      7133 { ProfSkill $from 165 130 143 155 5958 1 0 }  
      7135 { ProfSkill $from 165 140 153 165 5961 1 0 }  
      7147 { ProfSkill $from 165 180 190 200 5962 1 0 }  
      7149 { ProfSkill $from 165 190 200 210 5963 1 0 }  
      7151 { ProfSkill $from 165 195 205 215 5964 1 0 }  
      7153 { ProfSkill $from 165 205 215 225 5965 1 0 }  
      7156 { ProfSkill $from 165 210 220 230 5966 1 0 }  
      7179 { ProfSkill $from 171 120 140 160 5996 1 0 }  
      7181 { ProfSkill $from 171 175 195 215 1710 1 0 }  
      7183 { ProfSkill $from 171 55 75 95 5997 1 0 }  
      7213 { ProfSkill $from 185 215 235 255 6038 1 0 }  
      7221 { ProfSkill $from 164 180 195 210 6042 1 0 }  
      7222 { ProfSkill $from 164 190 203 215 6043 1 0 }  
      7223 { ProfSkill $from 164 210 223 235 6040 1 0 }  
      7224 { ProfSkill $from 164 215 228 240 6041 1 0 }  
      7255 { ProfSkill $from 171 130 150 170 6051 1 0 }  
      7256 { ProfSkill $from 171 160 180 200 6048 1 0 }  
      7257 { ProfSkill $from 171 210 230 250 6049 1 0 }  
      7258 { ProfSkill $from 171 205 225 245 6050 1 0 }  
      7259 { ProfSkill $from 171 210 230 250 6052 1 0 }  
      7408 { ProfSkill $from 164 105 125 145 6214 1 0 }  
      7421 { ProfSkill $from 333 5 8 300 6218 1 0 }  
      7430 { ProfSkill $from 202 70 80 90 6219 1 0 }  
      7623 { ProfSkill $from 197 55 73 90 6238 1 0 }  
      7624 { ProfSkill $from 197 55 73 90 6241 1 0 }  
      7629 { ProfSkill $from 197 80 98 115 6239 1 0 }  
      7630 { ProfSkill $from 197 80 98 115 6240 1 0 }  
      7633 { ProfSkill $from 197 95 113 130 6242 1 0 }  
      7636 { ProfSkill $from 197 115 133 150 6243 1 0 }  
      7639 { ProfSkill $from 197 125 143 160 6263 1 0 }  
      7643 { ProfSkill $from 197 140 158 175 6264 1 0 }  
      7751 { ProfSkill $from 185 45 65 85 6290 1 0 }  
      7752 { ProfSkill $from 185 45 65 85 787 1 0 }  
      7753 { ProfSkill $from 185 90 110 130 4592 1 0 }  
      7754 { ProfSkill $from 185 90 110 130 6316 1 0 }  
      7755 { ProfSkill $from 185 140 160 180 4593 1 0 }  
      7795 { ProfSkill $from 333 130 150 300 6339 1 0 }  
      7817 { ProfSkill $from 164 125 140 155 6350 1 0 }  
      7818 { ProfSkill $from 164 105 108 110 6338 1 0 }  
      7827 { ProfSkill $from 185 90 110 130 5095 1 0 }  
      7828 { ProfSkill $from 185 190 210 230 4594 1 0 }  
      7836 { ProfSkill $from 171 80 90 100 6370 1 0 }  
      7837 { ProfSkill $from 171 150 160 170 6371 1 0 }  
      7841 { ProfSkill $from 171 130 150 170 6372 1 0 }  
      7845 { ProfSkill $from 171 165 185 205 6373 1 0 }  
      7892 { ProfSkill $from 197 145 163 180 6384 1 0 }  
      7893 { ProfSkill $from 197 145 163 180 6385 1 0 }  
      7928 { ProfSkill $from 129 150 180 210 6450 1 0 }  
      7929 { ProfSkill $from 129 180 210 240 6451 1 0 }  
      7934 { ProfSkill $from 129 80 115 150 6452 3 0 }  
      7935 { ProfSkill $from 129 130 165 200 6453 3 0 }  
      7953 { ProfSkill $from 165 120 135 150 6466 1 0 }  
      7954 { ProfSkill $from 165 130 143 155 6467 1 0 }  
      7955 { ProfSkill $from 165 140 153 165 6468 1 0 }  
      8238 { ProfSkill $from 185 125 145 165 6657 1 0 }  
      8240 { ProfSkill $from 171 120 140 160 6662 1 0 }  
      8243 { ProfSkill $from 202 185 205 225 4852 1 0 }  
      8322 { ProfSkill $from 165 115 130 145 6709 1 0 }  
      8334 { ProfSkill $from 202 115 123 130 6712 1 0 }  
      8339 { ProfSkill $from 202 115 123 130 6714 1 2 }  
      8366 { ProfSkill $from 164 110 130 150 6730 1 0 }  
      8367 { ProfSkill $from 164 140 160 180 6731 1 0 }  
      8368 { ProfSkill $from 164 170 185 200 6733 1 0 }  
      8465 { ProfSkill $from 197 65 83 100 6786 1 0 }  
      8467 { ProfSkill $from 197 135 153 170 6787 1 0 }  
      8483 { ProfSkill $from 197 170 175 180 6795 1 0 }  
      8489 { ProfSkill $from 197 185 190 195 6796 1 0 }  
      8604 { ProfSkill $from 185 45 65 85 6888 1 0 }  
      8607 { ProfSkill $from 185 80 100 120 6890 1 0 }  
      8687 { ProfSkill $from 40 165 190 215 6949 1 0 }  
      8691 { ProfSkill $from 40 205 230 255 6950 1 0 }  
      8758 { ProfSkill $from 197 160 175 190 7046 1 0 }  
      8760 { ProfSkill $from 197 155 160 165 7048 1 0 }  
      8762 { ProfSkill $from 197 170 175 180 7050 1 0 }  
      8764 { ProfSkill $from 197 190 205 220 7051 1 0 }  
      8766 { ProfSkill $from 197 195 210 225 7052 1 0 }  
      8768 { ProfSkill $from 164 150 153 155 7071 2 0 }  
      8770 { ProfSkill $from 197 210 225 240 7054 1 0 }  
      8772 { ProfSkill $from 197 195 210 225 7055 1 0 }  
      8774 { ProfSkill $from 197 200 215 230 7057 1 0 }  
      8776 { ProfSkill $from 197 50 68 85 7026 1 0 }  
      8778 { ProfSkill $from 197 160 175 190 7027 1 0 }  
      8780 { ProfSkill $from 197 165 180 195 7047 1 0 }  
      8782 { ProfSkill $from 197 170 185 200 7049 1 0 }  
      8784 { ProfSkill $from 197 185 200 215 7065 1 0 }  
      8786 { ProfSkill $from 197 195 210 225 7053 1 0 }  
      8789 { ProfSkill $from 197 200 215 230 7056 1 0 }  
      8791 { ProfSkill $from 197 205 215 225 7058 1 0 }  
      8793 { ProfSkill $from 197 210 225 240 7059 1 0 }  
      8795 { ProfSkill $from 197 210 225 240 7060 1 0 }  
      8797 { ProfSkill $from 197 215 230 245 7061 1 0 }  
      8799 { ProfSkill $from 197 215 225 235 7062 1 0 }  
      8802 { ProfSkill $from 197 220 235 250 7063 1 0 }  
      8804 { ProfSkill $from 197 225 240 255 7064 1 0 }  
      8880 { ProfSkill $from 164 70 90 110 7166 1 0 }  
      8895 { ProfSkill $from 202 245 255 265 7189 1 0 }  
                   
      9058 { ProfSkill $from 165 40 55 70 7276 1 0 }  
      9059 { ProfSkill $from 165 40 55 70 7277 1 0 }  
      9060 { ProfSkill $from 165 60 75 90 7278 1 0 }  
      9062 { ProfSkill $from 165 60 75 90 7279 1 0 }  
      9064 { ProfSkill $from 165 65 80 95 7280 1 0 }  
      9065 { ProfSkill $from 165 100 115 130 7281 1 0 }  
      9068 { ProfSkill $from 165 125 140 155 7282 1 0 }  
      9070 { ProfSkill $from 165 125 138 150 7283 1 0 }  
      9072 { ProfSkill $from 165 145 158 170 7284 1 0 }  
      9074 { ProfSkill $from 165 145 158 170 7285 1 0 }  
      9145 { ProfSkill $from 165 150 163 175 7348 1 0 }  
      9146 { ProfSkill $from 165 160 173 185 7349 1 0 }  
      9147 { ProfSkill $from 165 160 173 185 7352 1 0 }  
      9148 { ProfSkill $from 165 165 178 190 7358 1 0 }  
      9149 { ProfSkill $from 165 170 183 195 7359 1 0 }  
      9193 { ProfSkill $from 165 170 180 190 7371 1 0 }  
      9194 { ProfSkill $from 165 170 180 190 7372 1 0 }  
      9195 { ProfSkill $from 165 185 195 205 7373 1 0 }  
      9196 { ProfSkill $from 165 195 205 215 7374 1 0 }  
      9197 { ProfSkill $from 165 195 205 215 7375 1 0 }  
      9198 { ProfSkill $from 165 200 210 220 7377 1 0 }  
      9201 { ProfSkill $from 165 205 215 225 7378 1 0 }  
      9202 { ProfSkill $from 165 210 220 230 7386 1 0 }  
      9206 { ProfSkill $from 165 215 225 235 7387 1 0 }  
      9207 { ProfSkill $from 165 220 230 240 7390 1 0 }  
      9208 { ProfSkill $from 165 220 230 240 7391 1 0 }  
      9269 { ProfSkill $from 202 150 163 175 7506 1 0 }  
      9271 { ProfSkill $from 202 150 160 170 6533 3 0 }  
      9273 { ProfSkill $from 202 160 180 200 7148 1 0 }  
      9513 { ProfSkill $from 185 100 120 140 7676 1 0 }  
      9811 { ProfSkill $from 164 185 198 210 7913 1 0 }  
      9813 { ProfSkill $from 164 185 198 210 7914 1 0 }  
      9814 { ProfSkill $from 164 200 213 225 7915 1 0 }  
      9818 { ProfSkill $from 164 205 218 230 7916 1 0 }  
      9820 { ProfSkill $from 164 210 223 235 7917 1 0 }  
      9916 { ProfSkill $from 164 225 238 250 7963 1 0 }  
      9918 { ProfSkill $from 164 200 205 210 7964 1 0 }  
      9920 { ProfSkill $from 164 200 205 210 7966 1 0 }  
      9921 { ProfSkill $from 164 200 205 210 7965 1 0 }  
      9926 { ProfSkill $from 164 225 235 245 7918 1 0 }  
      9928 { ProfSkill $from 164 225 235 245 7919 1 0 }  
      9931 { ProfSkill $from 164 230 240 250 7920 1 0 }  
      9933 { ProfSkill $from 164 230 240 250 7921 1 0 }  
      9935 { ProfSkill $from 164 235 245 255 7922 1 0 }  
      9937 { ProfSkill $from 164 235 245 255 7924 1 0 }  
      9939 { ProfSkill $from 164 235 245 255 7967 1 0 }  
      9942 { ProfSkill $from 164 240 250 260 7925 1 0 }  
      9945 { ProfSkill $from 164 240 250 260 7926 1 0 }  
      9950 { ProfSkill $from 164 240 250 260 7927 1 0 }  
      9952 { ProfSkill $from 164 245 255 265 7928 1 0 }  
      9954 { ProfSkill $from 164 245 255 265 7938 1 0 }  
      9957 { ProfSkill $from 164 250 260 270 7929 1 0 }  
      9959 { ProfSkill $from 164 250 260 270 7930 1 0 }  
      9961 { ProfSkill $from 164 250 260 270 7931 1 0 }  
      9964 { ProfSkill $from 164 255 265 275 7969 1 0 }  
      9966 { ProfSkill $from 164 255 265 275 7932 1 0 }  
      9968 { ProfSkill $from 164 255 265 275 7933 1 0 }  
      9970 { ProfSkill $from 164 255 265 275 7934 1 0 }  
      9972 { ProfSkill $from 164 260 270 280 7935 1 0 }  
      9974 { ProfSkill $from 164 265 275 285 7939 1 0 }  
      9979 { ProfSkill $from 164 265 275 285 7936 1 0 }  
      9980 { ProfSkill $from 164 265 275 285 7937 1 0 }  
      9983 { ProfSkill $from 164 70 90 110 7955 1 0 }  
      9985 { ProfSkill $from 164 155 170 185 7956 1 0 }  
      9986 { ProfSkill $from 164 160 175 190 7957 1 0 }  
      9987 { ProfSkill $from 164 165 180 195 7958 1 0 }  
      9993 { ProfSkill $from 164 235 248 260 7941 1 0 }  
      9995 { ProfSkill $from 164 245 258 270 7942 1 0 }  
      9997 { ProfSkill $from 164 250 263 275 7943 1 0 }  
      10001 { ProfSkill $from 164 255 268 280 7945 1 0 }  
      10003 { ProfSkill $from 164 260 273 285 7954 1 0 }  
      10005 { ProfSkill $from 164 265 278 290 7944 1 0 }  
      10007 { ProfSkill $from 164 270 283 295 7961 1 0 }  
      10009 { ProfSkill $from 164 270 283 295 7946 1 0 }  
      10011 { ProfSkill $from 164 275 288 300 7959 1 0 }  
      10013 { ProfSkill $from 164 280 293 305 7947 1 0 }  
      10015 { ProfSkill $from 164 285 298 310 7960 1 0 }  
      10097 { ProfSkill $from 186 175 175 175 3860 1 0 }  
      10098 { ProfSkill $from 186 230 230 230 6037 1 0 }  
      10482 { ProfSkill $from 165 200 200 200 8172 1 0 }  
      10487 { ProfSkill $from 165 220 230 240 8173 1 0 }  
      10490 { ProfSkill $from 165 220 230 240 8174 1 0 }  
      10499 { ProfSkill $from 165 225 235 245 8175 1 0 }  
      10507 { ProfSkill $from 165 225 235 245 8176 1 0 }  
      10509 { ProfSkill $from 165 225 235 245 8187 1 0 }  
      10511 { ProfSkill $from 165 230 240 250 8189 1 0 }  
      10516 { ProfSkill $from 165 230 240 250 8192 1 0 }  
      10518 { ProfSkill $from 165 230 240 250 8198 1 0 }  
      10520 { ProfSkill $from 165 235 245 255 8200 1 0 }  
      10525 { ProfSkill $from 165 240 250 260 8203 1 0 }  
      10529 { ProfSkill $from 165 240 250 260 8210 1 0 }  
      10531 { ProfSkill $from 165 240 250 260 8201 1 0 }  
      10533 { ProfSkill $from 165 240 250 260 8205 1 0 }  
      10542 { ProfSkill $from 165 245 255 265 8204 1 0 }  
      10544 { ProfSkill $from 165 245 255 265 8211 1 0 }  
      10546 { ProfSkill $from 165 245 255 265 8214 1 0 }  
      10548 { ProfSkill $from 165 250 260 270 8193 1 0 }  
      10550 { ProfSkill $from 165 250 260 270 8195 1 0 }  
      10552 { ProfSkill $from 165 250 260 270 8191 1 0 }  
      10554 { ProfSkill $from 165 255 265 275 8209 1 0 }  
      10556 { ProfSkill $from 165 255 265 275 8185 1 0 }  
      10558 { ProfSkill $from 165 255 265 275 8197 1 0 }  
      10560 { ProfSkill $from 165 260 270 280 8202 1 0 }  
      10562 { ProfSkill $from 165 260 270 280 8216 1 0 }  
      10564 { ProfSkill $from 165 260 270 280 8207 1 0 }  
      10566 { ProfSkill $from 165 265 275 285 8213 1 0 }  
      10568 { ProfSkill $from 165 265 275 285 8206 1 0 }  
      10570 { ProfSkill $from 165 270 280 290 8208 1 0 }  
      10572 { ProfSkill $from 165 270 280 290 8212 1 0 }  
      10574 { ProfSkill $from 165 270 280 290 8215 1 0 }  
      10619 { ProfSkill $from 165 245 255 265 8347 1 0 }  
      10621 { ProfSkill $from 165 245 255 265 8345 1 0 }  
      10630 { ProfSkill $from 165 250 260 270 8346 1 0 }  
      10632 { ProfSkill $from 165 270 280 290 8348 1 0 }  
      10647 { ProfSkill $from 165 270 280 290 8349 1 0 }  
      10650 { ProfSkill $from 165 275 285 295 8367 1 0 }  
      10840 { ProfSkill $from 129 210 240 270 8544 1 0 }  
      10841 { ProfSkill $from 129 240 270 300 8545 1 0 }  
                   
      11341 { ProfSkill $from 40 245 270 295 8926 1 0 }  
      11342 { ProfSkill $from 40 285 310 335 8927 1 0 }  
      11343 { ProfSkill $from 40 325 350 375 8928 1 0 }  
      11357 { ProfSkill $from 40 255 280 305 8984 1 0 }  
      11358 { ProfSkill $from 40 295 320 345 8985 1 0 }  
      11447 { ProfSkill $from 171 190 210 230 8827 1 0 }  
      11448 { ProfSkill $from 171 220 240 260 6149 1 0 }  
      11449 { ProfSkill $from 171 205 225 245 8949 1 0 }  
      11450 { ProfSkill $from 171 215 235 255 8951 1 0 }  
      11451 { ProfSkill $from 171 220 240 260 8956 1 0 }  
      11452 { ProfSkill $from 171 225 245 265 9030 1 0 }  
      11453 { ProfSkill $from 171 225 245 265 9036 1 0 }  
      11456 { ProfSkill $from 171 225 245 265 9061 1 0 }  
      11457 { ProfSkill $from 171 230 250 270 3928 1 0 }  
      11458 { ProfSkill $from 171 240 260 280 9144 1 0 }  
      11459 { ProfSkill $from 171 240 260 280 9149 1 0 }  
      11460 { ProfSkill $from 171 245 265 285 9154 1 0 }  
      11461 { ProfSkill $from 171 250 270 290 9155 1 0 }  
      11464 { ProfSkill $from 171 250 270 290 9172 1 0 }  
      11465 { ProfSkill $from 171 250 270 290 9179 1 0 }  
      11466 { ProfSkill $from 171 255 275 295 9088 1 0 }  
      11467 { ProfSkill $from 171 255 275 295 9187 1 0 }  
      11468 { ProfSkill $from 171 255 275 295 9197 1 0 }  
      11472 { ProfSkill $from 171 260 280 300 9206 1 0 }  
      11473 { ProfSkill $from 171 260 280 300 9210 1 0 }  
      11476 { ProfSkill $from 171 265 285 305 9264 1 0 }  
      11477 { ProfSkill $from 171 265 285 305 9224 1 0 }  
      11478 { ProfSkill $from 171 265 285 305 9233 1 0 }  
      11479 { ProfSkill $from 171 240 260 280 3577 1 0 }  
      11480 { ProfSkill $from 171 240 260 280 6037 1 0 }  
      11643 { ProfSkill $from 164 225 235 245 9366 1 0 }  
      12044 { ProfSkill $from 197 35 48 60 10045 1 0 }  
      12045 { ProfSkill $from 197 50 68 85 10046 1 0 }  
      12046 { ProfSkill $from 197 100 118 135 10047 1 0 }  
      12047 { ProfSkill $from 197 145 163 180 10048 1 0 }  
      12048 { ProfSkill $from 197 220 235 250 9998 1 0 }  
      12049 { ProfSkill $from 197 220 235 250 9999 1 0 }  
      12050 { ProfSkill $from 197 225 240 255 10001 1 0 }  
      12052 { ProfSkill $from 197 225 240 255 10002 1 0 }  
      12053 { ProfSkill $from 197 230 245 260 10003 1 0 }  
      12055 { ProfSkill $from 197 230 245 260 10004 1 0 }  
      12056 { ProfSkill $from 197 230 245 260 10007 1 0 }  
      12059 { ProfSkill $from 197 220 225 230 10008 1 0 }  
      12060 { ProfSkill $from 197 230 245 260 10009 1 0 }  
      12061 { ProfSkill $from 197 220 225 230 10056 1 0 }  
      12062 { ProfSkill $from 197 235 250 265 10010 1 0 }  
      12063 { ProfSkill $from 197 235 250 265 10011 1 0 }  
      12064 { ProfSkill $from 197 225 230 235 10052 1 0 }  
      12065 { ProfSkill $from 197 240 255 270 10050 1 0 }  
      12066 { ProfSkill $from 197 240 255 270 10018 1 0 }  
      12067 { ProfSkill $from 197 240 255 270 10019 1 0 }  
      12068 { ProfSkill $from 197 240 255 270 10020 1 0 }  
      12069 { ProfSkill $from 197 240 255 270 10042 1 0 }  
      12070 { ProfSkill $from 197 240 255 270 10021 1 0 }  
      12071 { ProfSkill $from 197 240 255 270 10023 1 0 }  
      12072 { ProfSkill $from 197 245 260 275 10024 1 0 }  
      12073 { ProfSkill $from 197 245 260 275 10026 1 0 }  
      12074 { ProfSkill $from 197 245 260 275 10027 1 0 }  
      12075 { ProfSkill $from 197 235 240 245 10054 1 0 }  
      12076 { ProfSkill $from 197 250 265 280 10028 1 0 }  
      12077 { ProfSkill $from 197 240 245 250 10053 1 0 }  
      12078 { ProfSkill $from 197 250 265 280 10029 1 0 }  
      12079 { ProfSkill $from 197 250 265 280 10051 1 0 }  
      12080 { ProfSkill $from 197 240 245 250 10055 1 0 }  
      12081 { ProfSkill $from 197 255 270 285 10030 1 0 }  
      12082 { ProfSkill $from 197 255 270 285 10031 1 0 }  
      12083 { ProfSkill $from 197 255 270 285 10032 1 0 }  
      12084 { ProfSkill $from 197 255 270 285 10033 1 0 }  
      12085 { ProfSkill $from 197 245 250 255 10034 1 0 }  
      12086 { ProfSkill $from 197 260 275 290 10025 1 0 }  
      12087 { ProfSkill $from 197 260 275 290 10038 1 0 }  
      12088 { ProfSkill $from 197 260 275 290 10044 1 0 }  
      12089 { ProfSkill $from 197 250 255 260 10035 1 0 }  
      12090 { ProfSkill $from 197 265 280 295 10039 1 0 }  
      12091 { ProfSkill $from 197 255 260 265 10040 1 0 }  
      12092 { ProfSkill $from 197 265 280 295 10041 1 0 }  
      12093 { ProfSkill $from 197 265 280 295 10036 1 0 }  
      12259 { ProfSkill $from 164 180 193 205 10423 1 0 }  
      12260 { ProfSkill $from 164 15 35 55 10421 1 0 }  
      12584 { ProfSkill $from 202 150 170 190 10558 3 0 }  
      12585 { ProfSkill $from 202 175 185 195 10505 1 0 }  
      12586 { ProfSkill $from 202 175 185 195 10507 2 0 }  
      12587 { ProfSkill $from 202 195 205 215 10499 1 0 }  
      12589 { ProfSkill $from 202 195 215 235 10559 1 0 }  
      12590 { ProfSkill $from 202 175 195 215 10498 1 0 }  
      12591 { ProfSkill $from 202 200 220 240 10560 1 0 }  
      12594 { ProfSkill $from 202 225 235 245 10500 1 0 }  
      12595 { ProfSkill $from 202 225 235 245 10508 1 0 }  
      12597 { ProfSkill $from 202 230 240 250 10546 1 0 }  
      12599 { ProfSkill $from 202 215 235 255 10561 1 0 }  
      12603 { ProfSkill $from 202 215 235 255 10514 3 0 }  
      12607 { ProfSkill $from 202 240 250 260 10501 1 0 }  
      12609 { ProfSkill $from 171 220 240 260 10592 1 0 }  
      12614 { ProfSkill $from 202 240 250 260 10510 1 0 }  
      12615 { ProfSkill $from 202 245 255 265 10502 1 0 }  
      12616 { ProfSkill $from 202 245 255 265 10518 1 0 }  
      12617 { ProfSkill $from 202 250 260 270 10506 1 0 }  
      12618 { ProfSkill $from 202 250 260 270 10503 1 0 }  
      12619 { ProfSkill $from 202 235 255 275 10562 4 0 }  
      12620 { ProfSkill $from 202 260 270 280 10548 1 0 }  
      12622 { ProfSkill $from 202 265 275 285 10504 1 0 }  
      12624 { ProfSkill $from 202 270 280 290 10576 1 0 }  
      12715 { ProfSkill $from 202 205 205 205 10644 1 0 }  
      12716 { ProfSkill $from 202 225 235 245 10577 1 0 }  
      12717 { ProfSkill $from 202 225 235 245 10542 1 0 }  
      12718 { ProfSkill $from 202 225 235 245 10543 1 0 }  
      12720 { ProfSkill $from 202 235 245 255 10580 1 0 }  
      12722 { ProfSkill $from 202 240 250 260 10585 1 0 }  
      12754 { ProfSkill $from 202 235 255 275 10586 2 0 }  
      12755 { ProfSkill $from 202 230 250 270 10587 1 0 }  
      12758 { ProfSkill $from 202 265 275 285 10588 1 0 }  
      12759 { ProfSkill $from 202 260 270 280 10645 1 0 }  
      12760 { ProfSkill $from 202 205 225 245 10646 1 0 }  
      12895 { ProfSkill $from 202 205 205 205 10713 1 0 }  
      12897 { ProfSkill $from 202 230 240 250 10545 1 0 }  
      12899 { ProfSkill $from 202 225 235 245 10716 1 0 }  
      12900 { ProfSkill $from 202 205 225 245 10719 1 0 }  
      12902 { ProfSkill $from 202 230 240 250 10720 1 0 }  
      12903 { ProfSkill $from 202 235 245 255 10721 1 0 }  
      12904 { ProfSkill $from 202 240 250 260 10723 1 0 }  
      12905 { ProfSkill $from 202 245 255 265 10724 1 0 }  
      12906 { ProfSkill $from 202 250 260 270 10725 1 0 }  
      12907 { ProfSkill $from 202 255 265 275 10726 1 0 }  
      12908 { ProfSkill $from 202 260 270 280 10727 1 0 }  
      13028 { ProfSkill $from 185 215 235 255 10841 4 0 }  
      13220 { ProfSkill $from 40 185 210 235 10918 1 0 }  
      13228 { ProfSkill $from 40 225 250 275 10920 1 0 }  
      13229 { ProfSkill $from 40 265 290 315 10921 1 0 }  
      13230 { ProfSkill $from 40 305 330 355 10922 1 0 }  
      13628 { ProfSkill $from 333 175 195 300 11130 1 0 }  
      13702 { ProfSkill $from 333 220 240 300 11145 1 0 }  
                   
      14293 { ProfSkill $from 333 75 95 300 11287 1 0 }  
      14379 { ProfSkill $from 164 155 158 160 11128 1 0 }  
      14380 { ProfSkill $from 164 205 208 210 11144 1 0 }  
      14807 { ProfSkill $from 333 110 130 300 11288 1 0 }  
      14809 { ProfSkill $from 333 175 195 300 11289 1 0 }  
      14810 { ProfSkill $from 333 195 215 300 11290 1 0 }  
      14930 { ProfSkill $from 165 245 255 265 8217 1 0 }  
      14932 { ProfSkill $from 165 245 255 265 8218 1 0 }  
      15255 { ProfSkill $from 202 200 220 240 11590 1 0 }  
      15292 { ProfSkill $from 164 285 295 305 11608 1 0 }  
      15293 { ProfSkill $from 164 290 300 310 11606 1 0 }  
      15294 { ProfSkill $from 164 295 305 315 11607 1 0 }  
      15295 { ProfSkill $from 164 300 310 320 11605 1 0 }  
      15296 { ProfSkill $from 164 305 315 325 11604 1 0 }  
      15596 { ProfSkill $from 333 285 305 325 11811 1 0 }  
      15628 { ProfSkill $from 202 205 205 205 11825 1 0 }  
      15833 { ProfSkill $from 171 245 265 285 12190 1 0 }  
      15853 { ProfSkill $from 185 165 185 205 12209 1 0 }  
      15855 { ProfSkill $from 185 215 235 255 12210 1 0 }  
      15856 { ProfSkill $from 185 215 235 255 13851 1 0 }  
      15861 { ProfSkill $from 185 215 235 255 12212 2 0 }  
      15863 { ProfSkill $from 185 215 235 255 12213 1 0 }  
      15865 { ProfSkill $from 185 215 235 255 12214 1 0 }  
      15906 { ProfSkill $from 185 240 260 280 12217 1 0 }  
      15910 { ProfSkill $from 185 240 260 280 12215 2 0 }  
      15915 { ProfSkill $from 185 265 285 305 12216 1 0 }  
      15933 { ProfSkill $from 185 265 285 305 12218 1 0 }  
      15935 { ProfSkill $from 185 45 65 85 12224 1 0 }  
      15972 { ProfSkill $from 164 205 218 230 12259 1 0 }  
      15973 { ProfSkill $from 164 215 228 240 12260 1 0 }  
      16153 { ProfSkill $from 186 250 250 250 12359 1 0 }  
      16639 { ProfSkill $from 164 255 258 260 12644 1 0 }  
      16640 { ProfSkill $from 164 255 258 260 12643 1 0 }  
      16641 { ProfSkill $from 164 255 258 260 12404 1 0 }  
      16642 { ProfSkill $from 164 270 280 290 12405 1 0 }  
      16643 { ProfSkill $from 164 270 280 290 12406 1 0 }  
      16644 { ProfSkill $from 164 275 285 295 12408 1 0 }  
      16645 { ProfSkill $from 164 280 290 300 12416 1 0 }  
      16646 { ProfSkill $from 164 285 295 305 12428 1 0 }  
      16647 { ProfSkill $from 164 285 295 305 12424 1 0 }  
      16648 { ProfSkill $from 164 290 300 310 12415 1 0 }  
      16649 { ProfSkill $from 164 290 300 310 12425 1 0 }  
      16650 { ProfSkill $from 164 290 300 310 12624 1 0 }  
      16651 { ProfSkill $from 164 295 305 315 12645 1 0 }  
      16652 { ProfSkill $from 164 300 310 320 12409 1 0 }  
      16653 { ProfSkill $from 164 300 310 320 12410 1 0 }  
      16654 { ProfSkill $from 164 305 315 325 12418 1 0 }  
      16655 { ProfSkill $from 164 310 320 330 12631 1 0 }  
      16656 { ProfSkill $from 164 310 320 330 12419 1 0 }  
      16657 { ProfSkill $from 164 315 325 335 12426 1 0 }  
      16658 { ProfSkill $from 164 315 325 335 12427 1 0 }  
      16659 { ProfSkill $from 164 315 325 335 12417 1 0 }  
      16660 { ProfSkill $from 164 310 320 330 12625 1 0 }  
      16661 { ProfSkill $from 164 315 325 335 12632 1 0 }  
      16662 { ProfSkill $from 164 320 330 340 12414 1 0 }  
      16663 { ProfSkill $from 164 320 330 340 12422 1 0 }  
      16664 { ProfSkill $from 164 320 330 340 12610 1 0 }  
      16665 { ProfSkill $from 164 320 330 340 12611 1 0 }  
      16667 { ProfSkill $from 164 305 315 325 12628 1 0 }  
      16724 { ProfSkill $from 164 320 330 340 12633 1 0 }  
      16725 { ProfSkill $from 164 320 330 340 12420 1 0 }  
      16726 { ProfSkill $from 164 320 330 340 12612 1 0 }  
      16728 { ProfSkill $from 164 320 330 340 12636 1 0 }  
      16729 { ProfSkill $from 164 320 330 340 12640 1 0 }  
      16730 { ProfSkill $from 164 320 330 340 12429 1 0 }  
      16731 { ProfSkill $from 164 320 330 340 12613 1 0 }  
      16732 { ProfSkill $from 164 320 330 340 12614 1 0 }  
      16741 { ProfSkill $from 164 320 330 340 12639 1 0 }  
      16742 { ProfSkill $from 164 320 330 340 12620 1 0 }  
      16744 { ProfSkill $from 164 320 330 340 12619 1 0 }  
      16745 { ProfSkill $from 164 320 330 340 12618 1 0 }  
      16746 { ProfSkill $from 164 320 330 340 12641 1 0 }  
      16960 { ProfSkill $from 164 285 298 310 12764 1 0 }  
      16965 { ProfSkill $from 164 295 308 320 12769 1 0 }  
      16967 { ProfSkill $from 164 295 308 320 12772 1 0 }  
      16969 { ProfSkill $from 164 300 313 325 12773 1 0 }  
      16970 { ProfSkill $from 164 300 313 325 12774 1 0 }  
      16971 { ProfSkill $from 164 305 318 330 12775 1 0 }  
      16973 { ProfSkill $from 164 305 318 330 12776 1 0 }  
      16978 { ProfSkill $from 164 305 318 330 12777 1 0 }  
      16980 { ProfSkill $from 164 310 323 335 12779 1 0 }  
      16983 { ProfSkill $from 164 310 323 335 12781 1 0 }  
      16984 { ProfSkill $from 164 315 328 340 12792 1 0 }  
      16985 { ProfSkill $from 164 315 328 340 12782 1 0 }  
      16986 { ProfSkill $from 164 325 338 350 12795 1 0 }  
      16987 { ProfSkill $from 164 325 338 350 12802 1 0 }  
      16988 { ProfSkill $from 164 320 330 340 12796 1 0 }  
      16990 { ProfSkill $from 164 320 330 340 12790 1 0 }  
      16991 { ProfSkill $from 164 320 330 340 12798 1 0 }  
      16992 { ProfSkill $from 164 320 330 340 12797 1 0 }  
      16993 { ProfSkill $from 164 320 330 340 12794 1 0 }  
      16994 { ProfSkill $from 164 320 330 340 12784 1 0 }  
      16995 { ProfSkill $from 164 320 330 340 12783 1 0 }  
      17180 { ProfSkill $from 333 250 255 300 12655 1 0 }  
      17181 { ProfSkill $from 333 250 255 300 12810 1 0 }  
      17187 { ProfSkill $from 171 275 283 290 12360 1 0 }  
      17551 { ProfSkill $from 171 250 255 260 13423 1 0 }  
      17552 { ProfSkill $from 171 270 290 310 13442 1 0 }  
      17553 { ProfSkill $from 171 275 295 315 13443 1 0 }  
      17554 { ProfSkill $from 171 280 300 320 13445 1 0 }  
      17555 { ProfSkill $from 171 285 305 325 13447 1 0 }  
      17556 { ProfSkill $from 171 290 310 330 13446 1 0 }  
      17557 { ProfSkill $from 171 290 310 330 13453 1 0 }  
      17559 { ProfSkill $from 171 275 283 290 7078 1 0 }  
      17560 { ProfSkill $from 171 275 283 290 7076 1 0 }  
      17561 { ProfSkill $from 171 275 283 290 7080 1 0 }  
      17562 { ProfSkill $from 171 275 283 290 7082 1 0 }  
      17563 { ProfSkill $from 171 275 283 290 7080 1 0 }  
      17564 { ProfSkill $from 171 275 283 290 12808 1 0 }  
      17565 { ProfSkill $from 171 275 283 290 7076 1 0 }  
      17566 { ProfSkill $from 171 275 283 290 12803 1 0 }  
      17570 { ProfSkill $from 171 295 315 335 13455 1 0 }  
      17571 { ProfSkill $from 171 295 315 335 13452 1 0 }  
      17572 { ProfSkill $from 171 300 320 340 13462 1 0 }  
      17573 { ProfSkill $from 171 300 320 340 13454 1 0 }  
      17574 { ProfSkill $from 171 305 325 345 13457 1 0 }  
      17575 { ProfSkill $from 171 305 325 345 13456 1 0 }  
      17576 { ProfSkill $from 171 305 325 345 13458 1 0 }  
      17577 { ProfSkill $from 171 305 325 345 13461 1 0 }  
      17578 { ProfSkill $from 171 305 325 345 13459 1 0 }  
      17579 { ProfSkill $from 171 305 325 345 13460 1 0 }  
      17580 { ProfSkill $from 171 310 330 350 13444 1 0 }  
      17632 { ProfSkill $from 171 315 323 330 13503 1 0 }  
      17634 { ProfSkill $from 171 315 323 330 13506 1 0 }  
      17635 { ProfSkill $from 171 315 323 330 13510 1 0 }  
      17636 { ProfSkill $from 171 315 323 330 13511 1 0 }  
      17637 { ProfSkill $from 171 315 323 330 13512 1 0 }  
      17638 { ProfSkill $from 171 315 323 330 13513 1 0 }  
                   
      18238 { ProfSkill $from 185 265 285 305 6887 1 0 }  
      18239 { ProfSkill $from 185 265 285 305 13927 1 0 }  
      18240 { ProfSkill $from 185 280 300 320 13928 1 0 }  
      18241 { ProfSkill $from 185 265 285 305 13930 1 0 }  
      18242 { ProfSkill $from 185 280 300 320 13929 1 0 }  
      18243 { ProfSkill $from 185 290 310 330 13931 1 0 }  
      18244 { ProfSkill $from 185 290 310 330 13932 1 0 }  
      18245 { ProfSkill $from 185 315 335 355 13933 1 0 }  
      18246 { ProfSkill $from 185 315 335 355 13934 1 0 }  
      18247 { ProfSkill $from 185 315 335 355 13935 1 0 }  
      18401 { ProfSkill $from 197 255 258 260 14048 1 0 }  
      18402 { ProfSkill $from 197 270 285 300 13856 1 0 }  
      18403 { ProfSkill $from 197 270 285 300 13869 1 0 }  
      18404 { ProfSkill $from 197 270 285 300 13868 1 0 }  
      18405 { ProfSkill $from 197 275 290 305 14046 1 0 }  
      18406 { ProfSkill $from 197 275 290 305 13858 1 0 }  
      18407 { ProfSkill $from 197 275 290 305 13857 1 0 }  
      18408 { ProfSkill $from 197 275 290 305 14042 1 0 }  
      18409 { ProfSkill $from 197 280 295 310 13860 1 0 }  
      18410 { ProfSkill $from 197 280 295 310 14143 1 0 }  
      18411 { ProfSkill $from 197 280 295 310 13870 1 0 }  
      18412 { ProfSkill $from 197 285 300 315 14043 1 0 }  
      18413 { ProfSkill $from 197 285 300 315 14142 1 0 }  
      18414 { ProfSkill $from 197 285 300 315 14100 1 0 }  
      18415 { ProfSkill $from 197 285 300 315 14101 1 0 }  
      18416 { ProfSkill $from 197 290 305 320 14141 1 0 }  
      18417 { ProfSkill $from 197 290 305 320 13863 1 0 }  
      18418 { ProfSkill $from 197 290 305 320 14044 1 0 }  
      18419 { ProfSkill $from 197 290 305 320 14107 1 0 }  
      18420 { ProfSkill $from 197 290 305 320 14103 1 0 }  
      18421 { ProfSkill $from 197 290 305 320 14132 1 0 }  
      18422 { ProfSkill $from 197 290 305 320 14134 1 0 }  
      18423 { ProfSkill $from 197 295 310 325 13864 1 0 }  
      18424 { ProfSkill $from 197 295 310 325 13871 1 0 }  
      18434 { ProfSkill $from 197 295 310 325 14045 1 0 }  
      18436 { ProfSkill $from 197 300 315 330 14136 1 0 }  
      18437 { ProfSkill $from 197 300 315 330 14108 1 0 }  
      18438 { ProfSkill $from 197 300 315 330 13865 1 0 }  
      18439 { ProfSkill $from 197 305 320 335 14104 1 0 }  
      18440 { ProfSkill $from 197 305 320 335 14137 1 0 }  
      18441 { ProfSkill $from 197 305 320 335 14144 1 0 }  
      18442 { ProfSkill $from 197 305 320 335 14111 1 0 }  
      18444 { ProfSkill $from 197 310 325 340 13866 1 0 }  
      18445 { ProfSkill $from 197 315 330 345 14155 1 0 }  
      18446 { ProfSkill $from 197 315 330 345 14128 1 0 }  
      18447 { ProfSkill $from 197 315 330 345 14138 1 0 }  
      18448 { ProfSkill $from 197 315 330 345 14139 1 0 }  
      18449 { ProfSkill $from 197 315 330 345 13867 1 0 }  
      18450 { ProfSkill $from 197 315 330 345 14130 1 0 }  
      18451 { ProfSkill $from 197 315 330 345 14106 1 0 }  
      18452 { ProfSkill $from 197 315 330 345 14140 1 0 }  
      18453 { ProfSkill $from 197 315 330 345 14112 1 0 }  
      18454 { ProfSkill $from 197 315 330 345 14146 1 0 }  
      18455 { ProfSkill $from 197 315 330 345 14156 1 0 }  
      18456 { ProfSkill $from 197 315 330 345 14154 1 0 }  
      18457 { ProfSkill $from 197 315 330 345 14152 1 0 }  
      18458 { ProfSkill $from 197 315 330 345 14153 1 0 }  
      18560 { ProfSkill $from 197 290 305 320 14342 1 0 }  
      18629 { ProfSkill $from 129 260 290 320 14529 1 0 }  
      18630 { ProfSkill $from 129 290 320 350 14530 1 0 }  
      19047 { ProfSkill $from 165 250 255 260 15407 1 0 }  
      19048 { ProfSkill $from 165 275 285 295 15077 1 0 }  
      19049 { ProfSkill $from 165 280 290 300 15083 1 0 }  
      19050 { ProfSkill $from 165 280 290 300 15045 1 0 }  
      19051 { ProfSkill $from 165 285 295 305 15076 1 0 }  
      19052 { ProfSkill $from 165 285 295 305 15084 1 0 }  
      19053 { ProfSkill $from 165 285 295 305 15074 1 0 }  
      19054 { ProfSkill $from 165 320 330 340 15047 1 0 }  
      19055 { ProfSkill $from 165 290 300 310 15091 1 0 }  
      19058 { ProfSkill $from 165 250 260 270 15564 1 0 }  
      19059 { ProfSkill $from 165 290 300 310 15054 1 0 }  
      19060 { ProfSkill $from 165 290 300 310 15046 1 0 }  
      19061 { ProfSkill $from 165 290 300 310 15061 1 0 }  
      19062 { ProfSkill $from 165 290 300 310 15067 1 0 }  
      19063 { ProfSkill $from 165 295 305 315 15073 1 0 }  
      19064 { ProfSkill $from 165 295 305 315 15078 1 0 }  
      19065 { ProfSkill $from 165 295 305 315 15092 1 0 }  
      19066 { ProfSkill $from 165 295 305 315 15071 1 0 }  
      19067 { ProfSkill $from 165 295 305 315 15057 1 0 }  
      19068 { ProfSkill $from 165 295 305 315 15064 1 0 }  
      19070 { ProfSkill $from 165 300 310 320 15082 1 0 }  
      19071 { ProfSkill $from 165 300 310 320 15086 1 0 }  
      19072 { ProfSkill $from 165 300 310 320 15093 1 0 }  
      19073 { ProfSkill $from 165 300 310 320 15072 1 0 }  
      19074 { ProfSkill $from 165 305 315 325 15069 1 0 }  
      19075 { ProfSkill $from 165 305 315 325 15079 1 0 }  
      19076 { ProfSkill $from 165 305 315 325 15053 1 0 }  
      19077 { ProfSkill $from 165 305 315 325 15048 1 0 }  
      19078 { ProfSkill $from 165 305 315 325 15060 1 0 }  
      19079 { ProfSkill $from 165 305 315 325 15056 1 0 }  
      19080 { ProfSkill $from 165 305 315 325 15065 1 0 }  
      19081 { ProfSkill $from 165 310 320 330 15075 1 0 }  
      19082 { ProfSkill $from 165 310 320 330 15094 1 0 }  
      19083 { ProfSkill $from 165 310 320 330 15087 1 0 }  
      19084 { ProfSkill $from 165 310 320 330 15063 1 0 }  
      19085 { ProfSkill $from 165 310 320 330 15050 1 0 }  
      19086 { ProfSkill $from 165 310 320 330 15066 1 0 }  
      19087 { ProfSkill $from 165 315 325 335 15070 1 0 }  
      19088 { ProfSkill $from 165 315 325 335 15080 1 0 }  
      19089 { ProfSkill $from 165 315 325 335 15049 1 0 }  
      19090 { ProfSkill $from 165 315 325 335 15058 1 0 }  
      19091 { ProfSkill $from 165 320 330 340 15095 1 0 }  
      19092 { ProfSkill $from 165 320 330 340 15088 1 0 }  
      19093 { ProfSkill $from 165 320 330 340 15138 1 0 }  
      19094 { ProfSkill $from 165 320 330 340 15051 1 0 }  
      19095 { ProfSkill $from 165 320 330 340 15059 1 0 }  
      19097 { ProfSkill $from 165 320 330 340 15062 1 0 }  
      19098 { ProfSkill $from 165 320 330 340 15085 1 0 }  
      19100 { ProfSkill $from 165 320 330 340 15081 1 0 }  
      19101 { ProfSkill $from 165 320 330 340 15055 1 0 }  
      19102 { ProfSkill $from 165 320 330 340 15090 1 0 }  
      19103 { ProfSkill $from 165 320 330 340 15096 1 0 }  
      19104 { ProfSkill $from 165 320 330 340 15068 1 0 }  
      19106 { ProfSkill $from 165 320 330 340 15141 1 0 }  
      19107 { ProfSkill $from 165 320 330 340 15052 1 0 }  
      19435 { ProfSkill $from 197 295 310 325 15802 1 0 }  
      19567 { ProfSkill $from 202 270 280 290 15846 1 0 }  
      19666 { ProfSkill $from 164 100 110 120 15869 2 0 }  
      19667 { ProfSkill $from 164 150 160 170 15870 2 0 }  
      19668 { ProfSkill $from 164 200 210 220 15871 2 0 }  
      19669 { ProfSkill $from 164 275 280 285 15872 2 0 }  
      19788 { ProfSkill $from 202 250 255 260 15992 1 0 }  
      19790 { ProfSkill $from 202 280 290 300 15993 3 0 }  
      19791 { ProfSkill $from 202 280 290 300 15994 1 0 }  
      19792 { ProfSkill $from 202 280 290 300 15995 1 0 }  
      19793 { ProfSkill $from 202 285 295 305 15996 1 0 }  
      19794 { ProfSkill $from 202 290 300 310 15999 1 0 }  
      19795 { ProfSkill $from 202 295 305 315 16000 1 0 }  
      19796 { ProfSkill $from 202 295 305 315 16004 1 0 }  
      19799 { ProfSkill $from 202 305 315 325 16005 3 0 }  
      19814 { ProfSkill $from 202 295 305 315 16023 1 0 }  
      19815 { ProfSkill $from 202 305 315 325 16006 1 0 }  
      19819 { ProfSkill $from 202 310 320 330 16009 1 0 }  
      19825 { ProfSkill $from 202 310 320 330 16008 1 0 }  
      19830 { ProfSkill $from 202 320 330 340 16022 1 0 }  
      19831 { ProfSkill $from 202 320 330 340 16040 3 0 }  
      19833 { ProfSkill $from 202 320 330 340 16007 1 0 }  
                   
      20051 { ProfSkill $from 333 310 330 350 16207 1 0 }  
      20201 { ProfSkill $from 164 275 280 285 16206 1 0 }  
      20626 { ProfSkill $from 185 265 285 305 16766 2 0 }  
      20648 { ProfSkill $from 165 100 105 110 2319 1 0 }  
      20649 { ProfSkill $from 165 150 155 160 4234 1 0 }  
      20650 { ProfSkill $from 165 200 203 205 4304 1 0 }  
      20848 { ProfSkill $from 197 315 330 345 16980 1 0 }  
      20849 { ProfSkill $from 197 315 330 345 16979 1 0 }  
      20853 { ProfSkill $from 165 315 325 335 16982 1 0 }  
      20854 { ProfSkill $from 165 320 330 340 16983 1 0 }  
      20855 { ProfSkill $from 165 320 330 340 16984 1 0 }  
      20872 { ProfSkill $from 164 315 325 335 16989 1 0 }  
      20873 { ProfSkill $from 164 320 330 340 16988 1 0 }  
      20874 { ProfSkill $from 164 315 325 335 17014 1 0 }  
      20876 { ProfSkill $from 164 320 330 340 17013 1 0 }  
      20890 { ProfSkill $from 164 320 330 340 17015 1 0 }  
      20897 { ProfSkill $from 164 320 330 340 17016 1 0 }  
      20916 { ProfSkill $from 185 215 235 255 8364 1 0 }  
      21143 { ProfSkill $from 185 45 65 85 17197 1 0 }  
      21144 { ProfSkill $from 185 75 95 115 17198 1 0 }  
      21161 { ProfSkill $from 164 325 338 350 17193 1 0 }  
      21175 { ProfSkill $from 185 240 260 280 17222 1 0 }  
      21913 { ProfSkill $from 164 215 228 240 17704 1 0 }  
      21923 { ProfSkill $from 171 210 230 250 17708 1 0 }  
      21940 { ProfSkill $from 202 190 210 230 17716 1 0 }  
      21943 { ProfSkill $from 165 210 220 230 17721 1 0 }  
      21945 { ProfSkill $from 197 200 205 210 17723 1 0 }  
      22331 { ProfSkill $from 165 250 250 250 8170 1 0 }  
      22430 { ProfSkill $from 171 315 323 330 17967 1 0 }  
      22434 { ProfSkill $from 333 320 315 310 17968 1 0 }  
      22480 { ProfSkill $from 185 265 285 305 18045 1 0 }  
      22704 { ProfSkill $from 202 320 330 340 18232 1 0 }  
      22711 { ProfSkill $from 165 210 220 230 18238 1 0 }  
      22727 { ProfSkill $from 165 320 330 340 18251 1 0 }  
      22732 { ProfSkill $from 171 310 320 330 18253 1 0 }  
      22757 { ProfSkill $from 164 300 310 320 18262 1 0 }  
      22759 { ProfSkill $from 197 320 335 350 18263 1 0 }  
      22761 { ProfSkill $from 185 315 335 355 18254 1 0 }  
      22793 { ProfSkill $from 202 320 330 340 18283 1 0 }  
      22795 { ProfSkill $from 202 320 330 340 18282 1 0 }  
      22797 { ProfSkill $from 202 320 330 340 18168 1 0 }  
      22808 { ProfSkill $from 171 230 250 270 18294 1 0 }  
      22813 { ProfSkill $from 197 285 290 295 18258 1 0 }  
      22815 { ProfSkill $from 165 285 290 295 18258 1 0 }  
      22866 { ProfSkill $from 197 315 330 345 18405 1 0 }  
      22867 { ProfSkill $from 197 315 330 345 18407 1 0 }  
      22868 { ProfSkill $from 197 315 330 345 18408 1 0 }  
      22869 { ProfSkill $from 197 315 330 345 18409 1 0 }  
      22870 { ProfSkill $from 197 315 330 345 18413 1 0 }  
      22902 { ProfSkill $from 197 315 330 345 18486 1 0 }  
      22921 { ProfSkill $from 165 320 330 340 18504 1 0 }  
      22922 { ProfSkill $from 165 320 330 340 18506 1 0 }  
      22923 { ProfSkill $from 165 320 330 340 18508 1 0 }  
      22926 { ProfSkill $from 165 320 330 340 18509 1 0 }  
      22927 { ProfSkill $from 165 320 330 340 18510 1 0 }  
      22928 { ProfSkill $from 165 320 330 340 18511 1 0 }  
      23066 { ProfSkill $from 202 150 163 175 9318 3 0 }  
      23068 { ProfSkill $from 202 150 163 175 9313 3 0 }  
      23069 { ProfSkill $from 202 200 210 220 18588 1 0 }  
      23070 { ProfSkill $from 202 250 260 270 18641 2 0 }  
      23071 { ProfSkill $from 202 270 275 280 18631 1 0 }  
      23077 { ProfSkill $from 202 280 290 300 18634 1 0 }  
      23078 { ProfSkill $from 202 285 295 305 18587 1 0 }  
      23079 { ProfSkill $from 202 285 290 295 18637 1 0 }  
      23080 { ProfSkill $from 202 275 285 295 18594 1 0 }  
      23081 { ProfSkill $from 202 310 320 330 18638 1 0 }  
      23082 { ProfSkill $from 202 320 330 340 18639 1 0 }  
      23096 { ProfSkill $from 202 275 280 285 18645 1 0 }  
      23129 { ProfSkill $from 202 260 265 270 18660 1 0 }  
      23486 { ProfSkill $from 202 285 295 305 18984 1 0 }  
      23489 { ProfSkill $from 202 285 295 305 18986 1 0 }
13931       { ProfSkill $from 333 255 275 295 0 0 0 }
20008      { ProfSkill $from 333 275 295 315 0 0 0 }
13846       { ProfSkill $from 333 240 260 280 0 0 0 }
13945       { ProfSkill $from 333 265 283 300 0 0 0 }
23802     { ProfSkill $from 333 70 90 110 0 0 0  }
13646       { ProfSkill $from 333 190 210 230 0 0 0 }
7859        { ProfSkill $from 333 145 93 185 0 0 0 }
13501       { ProfSkill $from 333 155 98 195 0 0 0 }
13536       { ProfSkill $from 333 165 90 205 0 0 0 }
23801      { ProfSkill $from 333 70 90 110 0 0 0  }
7428        { ProfSkill $from 333 80 100 120 0 0 0  }
7766        { ProfSkill $from 333 105 130 145 0 0 0 }
7782        { ProfSkill $from 333 115 135 155 0 0 0 }
13661       { ProfSkill $from 333 200 220 240 0 0 0 }
20009      { ProfSkill $from 333 70 90 110 0 0 0  }
20011      { ProfSkill $from 333 70 90 110 0 0 0  }
20010      { ProfSkill $from 333 70 90 110 0 0 0  }
13939       { ProfSkill $from 333 260 280 300 0 0 0 }
13822       { ProfSkill $from 333 230 250 270 0 0 0 }
13622       { ProfSkill $from 333 175 195 215 0 0 0 }
7779        { ProfSkill $from 333 115 135 155 0 0 0 }
7418        { ProfSkill $from 333 70 90 110 0 0 0  }
7457        { ProfSkill $from 333 100 120 140 0 0 0 }
13642       { ProfSkill $from 333 185 205 225 0 0 0 }
13648       { ProfSkill $from 333 190 210 230 0 0 0 }


25086      { ProfSkill $from 333 70 90 110 0 0 0  }
13746       { ProfSkill $from 333 225 245 265 0 0 0 }
25081      { ProfSkill $from 333 70 90 110 0 0 0  }
25082      { ProfSkill $from 333 70 90 110 0 0 0  }
20014      { ProfSkill $from 333 70 90 110 0 0 0  }
13882       { ProfSkill $from 333 245 90 285 0 0 0 }
13522       { ProfSkill $from 333 160 90 200 0 0 0 }
13419       { ProfSkill $from 333 135 90 175 0 0 0 }
13794       { ProfSkill $from 333 225 90 265 0 0 0 }
25083      { ProfSkill $from 333 70 90 110 0 0 0  }
25084      { ProfSkill $from 333 70 90 110 0 0 0  }
20015      { ProfSkill $from 333 70 90 110 0 0 0  }
13635       { ProfSkill $from 333 175 90 215 0 0 0 }
13657       { ProfSkill $from 333 195 90 235 0 0 0 }
7861        { ProfSkill $from 333 150 90 190 0 0 0 }
13421       { ProfSkill $from 333 140 90 180 0 0 0 }
7771        { ProfSkill $from 333 110 90 150 0 0 0 }
7454        { ProfSkill $from 333 95 90 135 0 0 0  }


20025      { ProfSkill $from 333 70 90 110 0 0 0  }
7776        { ProfSkill $from 333 115 90 155 0 0 0 }
20026      { ProfSkill $from 333 70 90 110 0 0 0  }
20028      { ProfSkill $from 333 70 90 110 0 0 0  }
7443        { ProfSkill $from 333 80 100 120 0 0 0  }
13941       { ProfSkill $from 333 265 285 305 0 0 0 }
13640       { ProfSkill $from 333 180 200 220 0 0 0 }
13663       { ProfSkill $from 333 205 225 245 0 0 0 }
7857        { ProfSkill $from 333 145 165 185 0 0 0 }
13538       { ProfSkill $from 333 165 185 205 0 0 0 }
7748        { ProfSkill $from 333 105 125 145 0 0 0 }
13700       { ProfSkill $from 333 220 240 260 0 0 0 }
13607       { ProfSkill $from 333 170 190 210 0 0 0 }
7426        { ProfSkill $from 333 90 110 130 0 0 0  }
7420        { ProfSkill $from 333 70 90 110 0 0 0  }
13626       { ProfSkill $from 333 175 195 215 0 0 0 }
13858       { ProfSkill $from 333 240 260 280 0 0 0 }
13917       { ProfSkill $from 333 250 270 290 0 0 0 }


13868       { ProfSkill $from 333 245 265 285 0 0 0 }
13841       { ProfSkill $from 333 235 255 275 0 0 0 }
25078       { ProfSkill $from 333 70 90 110 0 0 0 }
13620       { ProfSkill $from 333 170 190 210 0 0 0 }
25074       { ProfSkill $from 333 70 90 110 0 0 0 }
20012       { ProfSkill $from 333 70 90 110 0 0 0 }
20013       { ProfSkill $from 333 70 90 110 0 0 0 }
25079       { ProfSkill $from 333 70 90 110 0 0 0 }
13617       { ProfSkill $from 333 170 190 210 0 0 0 }
13612       { ProfSkill $from 333 170 190 210 0 0 0 }
13948       { ProfSkill $from 333 270 290 310 0 0 0 }
13947       { ProfSkill $from 333 270 290 310 0 0 0 }
25073       { ProfSkill $from 333 70 90 110 0 0 0 }
13698       { ProfSkill $from 333 220 240 260 0 0 0 }
25080       { ProfSkill $from 333 70 90 110 0 0 0 }
25072       { ProfSkill $from 333 70 90 110 0 0 0 }
13815       { ProfSkill $from 333 230 250 270 0 0 0 }
13887       { ProfSkill $from 333 245 265 285 0 0 0 }


13935       { ProfSkill $from 333 255 275 295 0 0 0 }
20023       { ProfSkill $from 333 70 90 110 0 0 0 }
20020       { ProfSkill $from 333 70 90 110 0 0 0 }
13687       { ProfSkill $from 333 210 230 250 0 0 0 }
7867        { ProfSkill $from 333 150 170 190 0 0 0 }
13890       { ProfSkill $from 333 245 265 285 0 0 0 }
20024       { ProfSkill $from 333 70 90 110 0 0 0 }
13637       { ProfSkill $from 333 180 200 220 0 0 0 }
13644       { ProfSkill $from 333 190 210 230 0 0 0 }
7863        { ProfSkill $from 333 150 170 190 0 0 0 }
13836       { ProfSkill $from 333 235 255 275 0 0 0 }


22750       { ProfSkill $from 333 70 90 110 0 0 0 }
22749       { ProfSkill $from 333 70 90 110 0 0 0 }
23800       { ProfSkill $from 333 70 90 110 0 0 0 }
20034       { ProfSkill $from 333 70 90 110 0 0 0 }
13915       { ProfSkill $from 333 250 270 290 0 0 0 }
13898       { ProfSkill $from 333 285 295 325 0 0 0 }
20029       { ProfSkill $from 333 70 90 110 0 0 0 }
13653       { ProfSkill $from 333 195 215 235 0 0 0 }
13655       { ProfSkill $from 333 195 215 235 0 0 0 }
20032       { ProfSkill $from 333 70 90 110 0 0 0 }
23804       { ProfSkill $from 333 70 90 110 0 0 0 }
23803       { ProfSkill $from 333 70 90 110 0 0 0 }
7786        { ProfSkill $from 333 120 140 160 0 0 0 }
23799       { ProfSkill $from 333 70 90 110 0 0 0 }
20031       { ProfSkill $from 333 70 90 110 0 0 0 }
20033       { ProfSkill $from 333 70 90 110 0 0 0 }
21931       { ProfSkill $from 333 70 90 110 0 0 0 }
13943       { ProfSkill $from 333 265 285 305 0 0 0 }
13503       { ProfSkill $from 333 165 185 205 0 0 0 }
7788        { ProfSkill $from 333 120 140 160 0 0 0 }
13693       { ProfSkill $from 333 215 235 255 0 0 0 }


27837       { ProfSkill $from 333 70 90 110 0 0 0 }
13937       { ProfSkill $from 333 260 280 300 0 0 0 }
7793        { ProfSkill $from 333 70 90 110 0 0 0 }
13380       { ProfSkill $from 333 130 150 170 0 0 0 }
20036       { ProfSkill $from 333 70 90 110 0 0 0 }
20035       { ProfSkill $from 333 70 90 110 0 0 0 }
20030       { ProfSkill $from 333 70 90 110 0 0 0 }
13695       { ProfSkill $from 333 220 240 260 0 0 0 }
13529       { ProfSkill $from 333 170 190 210 0 0 0 }
7745        { ProfSkill $from 333 130 150 170 0 0 0 }


13933       { ProfSkill $from 333 255 275 295 0 0 0 }
13905       { ProfSkill $from 333 250 270 290 0 0 0 }
20017       { ProfSkill $from 333 70 90 110 0 0 0 }
13689       { ProfSkill $from 333 215 235 255 0 0 0 }
13464       { ProfSkill $from 333 140 160 180 0 0 0 }
13817       { ProfSkill $from 333 230 250 270 0 0 0 }
20016       { ProfSkill $from 333 70 90 110 0 0 0 }
13485       { ProfSkill $from 333 155 175 195 0 0 0 }
13631       { ProfSkill $from 333 175 195 215 0 0 0 }
13378       { ProfSkill $from 333 130 150 170 0 0 0 }
13659       { ProfSkill $from 333 200 220 240 0 0 0 }
	3911 { ProfRank $from $to 3908 1 197}
	3912 { ProfRank $from $to 3909 2 197}
	3913 { ProfRank $from $to 3910 3 197}
	12181 { ProfRank $from $to 12180 4 197}
	2020 { ProfRank $from $to 2018 1 164}
	2021 { ProfRank $from $to 3100 2 164}	
	3539 { ProfRank $from $to 3538 3 164}
	9786 { ProfRank $from $to 9785 4 164}
	2155 { ProfRank $from $to 2108 1 165}
	2154 { ProfRank $from $to 3104 2 165}
	3812 { ProfRank $from $to 3811 3 165}
	10663 { ProfRank $from $to 10662 4 165}
	2275 { ProfRank $from $to 2259 1 171}
	2280 { ProfRank $from $to 3101 2 171}
	3465 { ProfRank $from $to 3464 3 171}
	11612 { ProfRank $from $to 11611 4 171}
	2372 { ProfRank $from $to 2366 1 182}
	2373 { ProfRank $from $to 2368 2 182}
	3571 { ProfRank $from $to 3570 3 182}
	11994 { ProfRank $from $to 11993 4 182}
	2581 { ProfRank $from $to 2575 1 186}
	2582 { ProfRank $from $to 2576 2 186}
	3568 { ProfRank $from $to 3564 3 186}
	10249 { ProfRank $from $to 10248 4 186}
	4039 { ProfRank $from $to 4036 1 202}
	4040 { ProfRank $from $to 4037 2 202}
	4041 { ProfRank $from $to 4038 3 202}
	12657 { ProfRank $from $to 12656 4 202}
	8615 { ProfRank $from $to 8613 1 393}
	8619 { ProfRank $from $to 8617 2 393}
	8620 { ProfRank $from $to 8618 3 393}
	10769 { ProfRank $from $to 10768 4 393}
	7414 { ProfRank $from $to 7411 1 333}
	7415 { ProfRank $from $to 7412 2 333}
	7416 { ProfRank $from $to 7413 3 333}
	13921 { ProfRank $from $to 13920 4 333}
	3279 { ProfRank $from $to 3273 1 129}
	3280 { ProfRank $from $to 3274 2 129}
	7925 { ProfRank $from $to 7924 3 129}
	10847 { ProfRank $from $to 10846 4 129}
	2551 { ProfRank $from $to 2550 1 185}
	3412 { ProfRank $from $to 3102 2 185}
	19886 { ProfRank $from $to 3413 3 185}
	18261 { ProfRank $from $to 18260 4 185}
	}
}

