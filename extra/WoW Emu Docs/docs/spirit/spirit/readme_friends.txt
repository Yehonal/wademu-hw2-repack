####################################################################################################################################
 Friends and Ignore Lists by Spirit
####################################################################################################################################

Installation:

* Clients *

- Unzip and install the addon (FriendsList.zip) to "(WoW Directory)\Interface\AddOns\"


* Server *

- Copy "Friends.tcl" to your tcl directory.

- You need "Custom.tcl" from the Honor System.

- Add an entry for FriendsList in "emu.conf" or "addons.conf":

[client_addon FriendsList]
enabled=1
crc=0EDBA10C1
pub=2V7+2WPUz2Bqg/bwjzsay5MCcNcG9oHSEGzyQDKDBzi2lubhSX3Y80tXDy1ukmOXIr429d4/ar5xtIFLRFj/dF0gKjgHVuVCXsyZ3xJYzdjq3Eavy9YsPd/6Y9HVh5MwGaU2JZ6OuBVUD6VqjApyMeAVshDinoJWOT/B4JWQAsbZlSL0nYn9RhZTgwImJBLUsbCY4oPdzqEsu19vM655hHYuVEaoGItsWh0PwHv0fNpKSW7wYApqCNivaAwbdHkktQIaCzqgJwIN6SAlW9IXkc5PXoGAiw+gi6fiSGT/EoRHIF0FmbyL9toYtMCccdggeUGqVJG9rJEWA8dAm/f86w==

  If you enable Chronos, the friends list will occasionally update itself.
  Remember you always need a blank line at the very end of your conf file.


Changelog:

v0.60
- Cumulative bug fixes release
- Fixed a bug with sending commands when the player is AFK.

v0.50
- Online friends detection from who list and chat.
- Support for myAddOns
- First touch to support FriendShare and HoloFriends

v0.22
- Changes in notifications and area display

v0.21
- Server side limit
- Fixed error when changing realm

v0.20
- Full notifications
- Separate lists for different realms / characters
- Compatibility with FriendsFacts, MiniFriends and maybe some others

v0.10 ( 2006-02 )
- Friends list
- Ignore list
- Offline friend details

