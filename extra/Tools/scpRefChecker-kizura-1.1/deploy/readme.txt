You need:
- JDK 1.5 or later

SCPIntegrityChecker
Inspired by guenex

referental integrity
Problem with SCP files can be, that for example a record
inside "loottemplates.scp" contains a "loot" entry with a
special item, but the item does not exist inside "items.scp".

This program will make sure, that your scp files apply to
the paradigm of referential integrity as used by SQL databases.
(Meaning: If table A references an entry inside table B, then
you may only write an entry inside A, if and only if the entry
inside B exists.)

This tool can be used for any existing SCP files.

Extract it and copy your "scripts" folder to the installation directory.
NOT the contents, copy the whole folder.

http://filebeam.com/c43ecdd0d8ef5da63e54009d1d5207c9

The program also understands #include directives.

Start the program:
refchecker.bat -refCheck loottemplate

-> Will check you loottemplates.scp for errors
This may take some time (on my system about 240 seconds), since loottemplates.scp is
quite large.

To define your own refCheck rules, please edit "refChecker.conf"
See below for details.

gl, hf
kizura

PS
Here is an explanation of the refChecker.conf file:

#
# >> SCPRefChecker 2006-09-28 by kizura // 1.1 (Jambi) <<
#
# lousy.kizura@gmail.com
#
# Copy your "scripts" folder to the installation directory
# (NOT the contents, the whole folder).
#
# Check SCP files for entries, that MUST exist:
#
# Copy your "scripts" folder to the installation directory
# (NOT the contents, the whole folder).
#
# Execute:
# java -jar -refCheck loottemplate
#
# -> Will search "refChecker.conf" for [refCheck loottemplate]
#
#
# FindIn -> specify the SCP file that contains the referenced objects
# FindMarker -> eg [item ...] if you want to check for references to items.scp
# Defines the marker for a new entry
# ConditionFrom -> Check this file
# ConditionMarker -> eg [loottemplate ...] for loottemplates.scp (Marker for a new entry)
# ConditionText -> Find this text, eg "loot=" defines a reference to an item for loottemplates.scp
#