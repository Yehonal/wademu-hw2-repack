Note about the option for controlling xp from quests:

If you use the script to control xp from quests, don't forget to ".rescp" after
"quests_noxp.scp" is generated for the first time. Also, all players at the
maximum configured level (which is level 60 by default) have to completely empty
their questlog, or they won't be able to finish quests or get new ones.

It should work with either MasterScript or Neo2003's TCL Pack.

Include lines inside "quests.scp" are not supported yet. If you have includes
other than "#include scripts/quests_noxp.scp", you should disable the
"control_quests" option.

If you use WoWQT, you must disable/remove the include to "quests_noxp.scp" in
your "quests.scp" before using the tool.

