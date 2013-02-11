Item creator by Daijw 3.0 Delphi Version.

Just generate your item and parse it into items.scp file.
Then .rescp in game and done ! You have new item on your server.

For any help read all tips on labels !
For more help if you need contact me [ click right mouse on itemcreator ]

If you want change language for tips just edit itemcreator.ini file.

Some values program generate even if you didnt choose them like: sheath or ammotype for weapon

Damage is generate autmaticly ADD MORE button is only for adding some more damages then one 
you have setted at creating weapon.


[main]
ItemID=Enter here your item identificator
ItemName=Enter here your item name
class=Choose your Item Class here
subclass=You can choose subclass of your item here if needed
invectorytype=choose where your item should be equipped here if needed
races=Choose here what race can use your item
classes=Choose here what class can use your item
model=Enter here model for your item. You can stole one from item.scp
level=Minimum level that should have player to use your item
buyprice=Price that someone can buy this item for.(1000-OneGold)
sellprice=Price that someone can sell this item for. (1000-OneGold)
material=Material sound that the item makes when moved.Can make atribute not repairable too
Quality=Choose quality of your item
stackable=How many of item can a player carry in the same slots


[addons]
pagematerial=Choose material for your page item
bonding=Choose when item will be bond to person who found it.
skillreq=What skill your item should require for use ? Leave blank for none
skillrank=Minimum proficiency in skill to use item.Leave blank for 0
spellreq=What spell your item should require for use ? Leave blank for none
set=Should this item belongs to any set ? if yes write your set armor here
lang=Language that this item is written in. Disable for all languages.
PVP=PvP Honor rank required to use item.
pagetext=ID of a section id pages.scp, the text for a letter for example.
container=Enter here how many slots should have your container
block=Satistic for shields
durability=Enter here durability of your weapon or armor
maxcount=Maximum number of your item that one can have - Leave blank for unlimited
desc=Description of your item. It is always below your item name

[OnlyExperts]
questscript=The name of a TCL namespace.Function is executed upon RCmouse.
startquest=What quest does this item start ?
extra=Seems to be like secondary model entry (64=Mount for egzample)
lock=Something to do with locked boxes :D
loot=This defines what items will come out

[buttons]
refresh=Clear all data
makeitem=Click to generate your item!
addspell=After you choose all and created item you can add spell to your item here



