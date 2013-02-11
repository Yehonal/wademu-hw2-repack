####################################################################################################################################
 Warsong Gulch Battleground CTF Script by Spirit
####################################################################################################################################

Installation instructions:

- You need to patch your "scripts/spell.dbc" with DBC-Patcher.exe, using "warsong-patch.txt" included in this release.
  This is needed or you won't be able to drop the flags, or some power-ups will not work!

- *** Game Objects ***

Checks your game objects:

[gameobj 179830]
name=Silverwing Flag
questscript=Warsong
type=24
sound1=23383
size=2.5
flags=01
faction=1314
model=5912
sound2=11
sound3=23333
sound4=23390
sound5=1
gtype=2

[gameobj 179831]
name=Warsong Flag
questscript=Warsong
type=24
sound1=23384
size=2.5
model=5913
flags=00
faction=210
sound2=11
sound3=23335
sound4=23389
sound5=1
gtype=2

To set up your flags, you need to manually edit your world.save (see the world.save section below)

Go in game to these area triggers and spawn the power-ups:
.gotrigger 3686 and 3687: .addgo 179871 (Speed)
.gotrigger 3706 and 3708: .addgo 179904 (Restoration)
.gotrigger 3707 and 3709: .addgo 179905 (Berserking)

- *** Creatures ***

Check these NPCs, and make sure they are spawn at their places (in some kind of room near the flags):

[creature 51001] // or 20002
name=Hurlog Horde
questscript=Warsong
flags1=08080066
guild=Warsong Gulch Battlemaster
npcflags=02
attack=1166 1283
bounding_radius=0.4092
combat_reach=3.21
damage=139 213
elite=1
equipmodel=0 30791 2 1 1 17 1 0 0 0
equipmodel=1 19550 2 0 1 13 3 0 0 0
faction=35
level=61
loottemplate=0 0
maxhealth=18448
maxmana=8019
model=15032
money=858
size=1.1
speed=1.95
type=7

[creature 51002] // or 20003
name=Armin Allianz
questscript=Warsong
flags1=08080066
guild=Warsong Gulch Battlemaster
npcflags=02
attack=1166 1283
bounding_radius=0.4092
combat_reach=3.21
damage=139 213
elite=1
faction=35
level=61
maxhealth=18448
maxmana=8019
model=3074
money=858
size=1.1
speed=1.95
type=7

.go 489 925.064209 1458.068481 346.206879, spawn "Hurlog Horde"
.go 489 1528.921997 1456.521851 352.039734, spawn "Armin Allianz"

Also you may need some Spirit Healers (creature 6491) at the graveyards here:
.go 489 1425 1555 343
.go 489 1027 1387 341

- *** Areatriggers ***

Open your "areatriggers.scp" and set "script=Warsong" for the following entries:

3646, 3647 (Flags)
3650, 3654 (Entrances)
3669, 3671 (Exits)
3686, 3687 (Speed Buff)
3706, 3708 (Food Buff)
3707, 3709 (Berserk Buff)

- *** World.save ***

Open your world.save and add this manually at the end. This is important if you want to have clickable flags.
(NuRRi's and Blackstorm's world.save files already have these).

[OBJECT]
GUID=0655160CBC
TYPE=5
ENTRY=179831
MODEL=5913
MAP=489
XYZ=915.808594 1433.732300 346.172150 3.243526
SIZE=2.500000
GTYPE=2
ROTATION=0.000000 0.000000 0.998701 -0.050945

[OBJECT]
GUID=0655160CBD
TYPE=5
ENTRY=179830
MODEL=5912
MAP=489
XYZ=1540.347046 1481.310669 352.634979 6.239818
SIZE=2.500000
GTYPE=2
ROTATION=0.000000 0.000000 0.021682 -0.999765


####################################################################################################################################
 How to play
####################################################################################################################################

To play a game, players have to join a waiting queue by talking to a Honor NPC in Orgrimmar or Stormwind, or getting to the entrance.
While players are in the queue, they can do whatever they want. They will be teleported as soon as a game can be started.
Queue #1 is for players level 10 to 39.
Queue #2 is for players level 40 and above.

When they are in the battleground, players have to go pick up the enemy's flag and bring it to their base, while protecting their own flag.
You can't capture the enemy's flag if the enemy is carrying yours, so you need to kill the flag carrier.
A player can give to a nearby teammate the flag he is carrying by selecting him or using the ".ctf give" command.
The first team to have 3 captured flags wins the game.

There are 3 types of power-ups in the battleground that you can use just by walking up to them.

The winners will have to talk to the battlemaster to get their rewards.
When a game is finished, all players should leave the battleground so another group of players in the queue can start another game.


####################################################################################################################################
 Commands
####################################################################################################################################

GMs:

*** IMPORTANT ***
Since v0.80, everything is automatic. Use add/del open/close start/end commands only if you want to manually operate the battleground.

- .ctf (Display scores, information about who are carrying the flags, manually update the map information)
- .ctf open (Open the battleground, so players can join by going through an entrance or talking to a honor npc)
- .ctf close (Close the battleground, if you don't want more players to join or if you want to add manually only)
- .ctf add (Select a player to add him manually)
- .ctf del (Select a player to delete him manually)
- .ctf list (List of players)
- .ctf queue (Queue information)
- .ctf spec (Add yourself as a spectator, to have the map information and receive event notifications)
- .ctf start (start the game, the battleground will also be closed)
- .ctf end (the game normally ends itself when a team has won, but you can use this command to manually end the game)
- .ctf clear (clear all teams and scores, all current players will be teleported outside of the battleground)
- .ctf help (Help about commands)

Players:

- .ctf (Display scores, information about who are carrying the flags, manually update the map information)
- .ctf list (List of players)
- .ctf queue (Queue information)
- .ctf give (give the flag you are carrying to a teammate)

