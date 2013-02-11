####################################################################################################################################
 Mob Talk by Spirit
####################################################################################################################################

This addon allows some hundreds of mobs to talk. It tries to detect the right sound file to play in the mpq files under the right occasion. There can be sounds for aggro, killing, dying, low health and spell casting.
There is no server side script, you just need to allow the addon in emu.conf/addons.conf.

Installation:

* Clients *

- Unzip and install the addon (MobTalk) to "(WoW Directory)\Interface\AddOns\"


* Server *

- Add an entry for MobTalk in "emu.conf" or "addons.conf":

[client_addon MobTalk]
enabled=1
crc=0EDBA10C1
pub=2V7+2WPUz2Bqg/bwjzsay5MCcNcG9oHSEGzyQDKDBzi2lubhSX3Y80tXDy1ukmOXIr429d4/ar5xtIFLRFj/dF0gKjgHVuVCXsyZ3xJYzdjq3Eavy9YsPd/6Y9HVh5MwGaU2JZ6OuBVUD6VqjApyMeAVshDinoJWOT/B4JWQAsbZlSL0nYn9RhZTgwImJBLUsbCY4oPdzqEsu19vM655hHYuVEaoGItsWh0PwHv0fNpKSW7wYApqCNivaAwbdHkktQIaCzqgJwIN6SAlW9IXkc5PXoGAiw+gi6fiSGT/EoRHIF0FmbyL9toYtMCccdggeUGqVJG9rJEWA8dAm/f86w==


Changelog:

v0.51
- The sound tag is now supported for system messages

v0.50
- Support for localized mob names (german and french)
- Invalid capture index error is hopefully fixed

v0.40
- You can make your NPCs talk or make a sound by script with the Say command. Use the special tag "|s<SOUND>|r"
  <SOUND> can be a full path to a sound file in one of the mpq files from the client, or a sound name

v0.30
- Pre aggro sounds

v0.20
- Fixed hearing the aggro sound when someone else is tanking
- More special cases added

v0.10 ( 2006-02 )
- First release
