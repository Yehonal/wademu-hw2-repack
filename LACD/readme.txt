
This is Beebops english version of Lost's Russian release.
As always, and unfortunately, each time LACD is released,
it must be updated to work.
Lost doesn't include user submitted updates typically.
He does do a lot of code work.
My changes allow the program to work on non Russion OS's.
Further, I update the CRC's, Rules and Cheats.
This update includes cheats posted by Z0oMiK.
Sadly, while people are asking for them, no one has
provided me any exe's or crc's for additional clients.

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
             $$$
            $$$$                                  $$
           $$$$ $$     [WoW cheat death]        $$$$
          $$$$ $$$$       [0.7.13]               $$$
         $$$$ $$$ $$                           $$$
        $$$$ $$$   $ $$$$     $$$$     $$$$   $$$
       $$$$ $$$ $$$ $$$$$$  $$$$$$$  $$$$$$$ $$$
        $$$$ $ $$$ $$$  $$ $$$      $$$  $$ $$$
          $$$$    $$$  $$$ $$  $$$ $$$$$$$ $$$
         $$ $$$  $$$  $$$ $$$$$$$ $$$     $$$
        $$$$  $$$ $  $$$   $$$$ $  $$$$    $$$$
  
  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  

Installation:
  Server: 
    1. Extract /Server directory content anywhere you like on your computer.

    2. Adjust emulator and anti-cheat server (may  differ depending on your emulator version) 

       a) wowemu:
          //=====[emu.conf]==========
          [system]
          rs_port=3724 // change this port to any different, 37240, for example
          //=====[emu.conf]==========
          
          //=====[lacd_server.ini]===
          [ws]
          orig_ws_host=_emulator_host_as_set_in_wowemu.key    			
	  orig_ws_port=8085
          ws_port=8086
          [rs]
          orig_rs_host=_emulator_host_as_set_in_ wowemu.key_
          orig_rs_port=_what_you_changed_rs_port_to_in_the_emu.conf_
          // the rest stays unchanged.
          //=====[lacd_server.ini]===

       b) wowwow (these settings suit any server):
          //=====[lacd_server.ini]===
          [ws]
          orig_ws_host=_emulator_host_as_set_in_World.ServerIP_in_Globals.cs_
          orig_ws_port=8085
          ws_port=8086
          [rs]
          orig_rs_host=_emulator_host_as_set_in_World.ServerIP_in_Globals.cs_
          orig_rs_port=3724
          rs_port=4724
          // the rest stays unchanged.
          //=====[lacd_server.ini]===
          Users shall set realmlist server_IP_:4724

       Think over the protection of original ports. You can use firewall. To prevent bypasses, at least close access to the orig_rs_port. Local machine shall have full access.

       P.S. On heavy loaded server you may set DirectConnect=1, it reduces safety, but improves latency as well as total performance. If you set DirectConnect=1, take care to grant outside access to orig_ws_port.

    3. Adjust rules.ini
       See .ini file for description.

  Client: 
    1. Copy all the files from the /Client directory to the WoW root directory.


  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
  Scheme of connections through the CD-server (to clear settings up)

     [DirectConnect=1]                   [DirectConnect=0 (default)]

    [server]           [client]          [server]           [client]
     emulator:        CD-client:         emulator:          CD-client:
     orig_ws_port====ws_client==+    +====orig_rs_port *****ch_client
  +==orig_rs_port ***ch_client  |    | +==orig_ws_port * ***ws_client==+
  |               *             |    | |               * *             |
  |  CD-server:   *             |    | |  CD-server:   * *             |
  |  ch_port*******  wow.exe:   |    | |  ch_port******* *  wow.exe    |
  +==rs_port=========rs_client  |    | +==ws_port*********  ws_client==+
                     ws_client==+    +====rs_port===========rs_client

     * - encrypted channel

   ports allocation (for firewall adjustment)
   emulator: 
     orig_ws_host:orig_ws_port - shall be available from the net
     orig_rs_host:orig_rs_port - shall be available for the local machine
  
   CD-server:
     ch_host:ch_port - shall be available from the net 
     cd_host:cd_port - shall be available from the net
     rs_host:rs_port - shall be available from the net
  
   CD-client:
     ws_client: 10000-20000 - shall be available for the local machine


  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
ChangeLog:

[0.1.1] – First release
+ bvh 1.5.0 
+ speedgear 

[0.1.2] 09.11.2005 – First public release 
+ some connection bugs fixed 

[0.1.3] 14.11.2005 
+ separate config file 

[0.2.0] 15.11.2005 
+ changed action core (a lot of server errors eliminated) 
+ server console 
! client hadn’t been changed yet 

[0.3.0] 17.11.2005 – pre-beta version 
+ absolutely new action core 
+ server logging 
+ client-server connection is encoded 
- WoW data channel is still open, but probably will be encoded later too 
+ dynamic ports allocation 
+ cheats description is in the .ini file 
- you may now add your own cheats as well as reaction on cheat detection – from logging to wow.exe deletion. 
+ client version check (to make updating easier) 
- coming: client auto-updating directly from the server... 
+ client runs WoW right after being launched, not showing self. 

[0.3.2] 17.11.2005 
+ CRC-check for wow.exe 
+ crc.ini with list of “allowed” CRC 

[0.3.3] 18.11.2005 
! window class now may contain any symbols 
! all lines in the cheats.ini are not case-sensitive anymore – i.e. TSearch = tsearch 
+ cheats.ini check goes by specified parameters ONLY 
+ new algorithms of cheat detection 
+ CRC-check of the cheat files 
+ cheat file .exe name check 
+ check of the specified offset DWORD (4 bytes) value. 
+ some new cheat detections added. 
+ additional .dll version check 

[0.3.3a] 18.11.2005 
! bug fixed which allowed to log in with anti-cheat clients of 2.0 and below versions. 
~ client hadn’t been changed. 

[0.3.3b] 18.11.2005 
! HT-related bug is fixed. 
~ client hadn’t been changed. 

[0.3.4] 21.11.2005 
+ CRC-check for anti-cheat client and .dll 
+ auto-update from the server (client shall be placed to the /Client directory or other destination specified in the settings ini-file) 
+ protection from the second WoW.exe launch (not checked) 
+ users number limit (optional) 
! a lot of small bugs fixed 
~ pay attention to the new lacd_server.ini parameters 

[0.4.0] 24.11.2005 
+ full encoding of the data being transferred 
+ client doesn’t log directly to the emulator anymore 
+ separate cheaters log file 
+ rules system in the rules.ini (ban, cheats permission, etc.) 

[0.4.1] 25.11.2005 
! some bugs found during test run are fixed 
+ WDB cleanup option 

[0.4.2] 28.11.2005 
! serious protection breach is closed 
+ optional ws-redirect (being off provides Last IP to emulator, but also turns off the protection from the second WoW.exe launch as well as WoW data channel encoding) 

[0.4.3] 28.11.2005 
+ protection from the second WoW.exe launch is recovered for ws-redirect off-mode 
+ new rules.ini parameter: 
MultiConnect: multiple connections from the same IP permission (doesn’t work when ws-redirect is off, as soon as connects to the emulator directly) 

[0.4.4] 29.11.2005 
+ some more inessential bugs fixed 
! one more protection breach is fixed (credits to z19) 

[0.4.5] 29.11.2005 
~ you won’t believe… just forgot to activate exception handler. 

[0.5.0] 01.12.2005 
+ a lot of stability-related fixes 
+ program threads synchronization (may take ping a bit higher, but shall imrove performance on the HT-processors) 

[0.5.1] 02.12.2005 
- bad news found – client doesn’t work under OS Win9x - will try to fix. 
+ MAC-address check added 
! one more protection breach is fixed (credits to z19 again) 

[0.5.2] 02.12.2005 
+ Win9x client compatibility is recovered 

[0.5.3] 05.12.2005 
+ starting to get data from the packets 
+ account 
+ game client version 
+ orig_*_host addresses don’t have to match emulator address exactly 
+ new cheat [WPE PRO] 

[0.5.4] 05.12.2005 
+ updated client will now have name as specified in the lacd_server.ini client= line (being updated to the version above 0.5.4) 

[0.5.5] 05.12.2005 
+ at last exception message vulnerability is fixed 
+ some exception handler improvements 

[0.5.6] 09.12.2005 
+ fixing vulnerabilities 

[0.5.7] 09.12.2005 
+ fixing vulnerabilities 
+ bug of auto-updating is fixed – though demands manual update to this version 

[0.5.8] 12.12.2005 
+ connecting databases 
~ new lacd_server.ini parameter: DataBase=database.dsn, 
~ if commented – database feature is disabled 
~ database.dsn is set for mySQL using ODBC-driver 
+ lacd_cheats: cheat list. 
+ lacd_cheaters table: cheaters caught. 

[0.5.9] 12.12.2005 
+ one more step fighting against WPE PRO 
+ offset value search is improved 

[0.5.10] 13.12.2005 
+ offset value search is improved, length of value to check is increased to 32 bytes 
+ action=5 option in the cheats.ini: // 5: Disconnection, IP ban. 

[0.6.0] 14.12.2005 
+ bug with false offset checking handling is fixed 
+ new way of cheat detection 
+ some appearance changes 

[0.6.1] 14.12.2005 
+ thread access rejection bug is fixed 
+ new rules.ini parameters for autoban option (check it!!!) 
+ slight cheat detection module improvements 

[0.6.2] 14.12.2005 
+ Win9x compatibility recovered (not checked, probably still not fully supported) 
+ cheats.ini: easy format dividing, either window class, or procedure file rules are to be set 
+ rules.ini: AllowAutoban bug fixed 

[0.6.3] 16.12.2005 
+ auto-update under Win9x isn’t supported – I don’t know why; rename *.tmp clientside files manually. 
+ server hangings during auto-updates are fixed 
+ cheat detection algorithms improvements 
+ new cheats in the cheats.ini 

[0.6.4] 19.12.2005 
+ protection module improvements – closing old and new breaches 
+ new parameters in the lacd_server.ini for log-files – you may now set separate log file for every day 

[0.6.5] 20.12.2005 
+ one of protection breaches is closed 
+ improved detection of the second WoW.exe 
+ a lot of slight improvements 

[0.6.6] 27.12.2005 
+ protection from bypasses is improved 
+ optional logging (see rules.ini) 
~ new cheats in the cheats.ini 
~ slight improvements 

[0.6.7] 15.01.2006 
+ all known to author bypasses are closed 
+ import table hack detection is disabled 
+ unwanted library system is released – list of dll which shall not be found running 
+ bug fixed which caused immediate client crashing after handshaking under some systems 
~ as usually, a lot of small fixes 

[0.6.8] 27.01.2006 
+ protection system improvements (closing breaches) 
+ does neither demand rights for record, nor block wow.exe 

[0.6.9] 30.01.2006 
+ new feature of HSRedirect and according lacd_server.ini parameter – turns http redirector on. May be used for statistics/registration page. HSRedirect=1 enables [hs] section in the lacd_server.ini, which is to be set like [ws] and [rs]. 
+ new rules.ini parameter: AllowHTTP to allow/reject access to the redirector. 
+ user’s time spent online timer, to enable check LogUsageTime in the lacd_server.ini file. 
+ new method of cheat detection on the client side (slightly decreases client’s processor usage) 
+ suspend-related bypass is closed, fix of two users logging bug is improved. 
+ server now also gets file name, window class and header of any application run by user 

[0.6.10] 31.01.2006 - Bugtest results 
+ some small fixes 
+ new parameter in the lacd_server.ini file: WastedTime

[0.6.11] 17.02.2006
  + Some security fixes while 0.7.0 is under work
  + 0.6.8 & 0.6.10 protection modules are united
  - thread suspension check is turned off

[0.6.12] 26.02.2006
  + win2k3 compatibility fixed

[0.7.0] 16.03.2006 - test 
+ New cheats detecting module 
+ NT-system compatible 
+ New format of cheats.ini 
+ Program to generate sign= in the cheats.ini (GetSign) 

[0.7.1]16.03.2006 - test stage 2 
+ Start bug fixing... 
+ GetSign is corrected

[0.7.2] 20.03.2006 
+ Detection module is almost completed 
+ GetSign fixes 
+ Cheat base is extended (credits to all who helped)

[0.7.3] 30.03.2006
  + Small but still annoying bugs fixed
  + Billing system (test)
  + Account is now showed in logs

[0.7.4] 30.03.2006
  + Bug fixing

[0.7.5] 30.03.2006
  + Bug fixing

[0.7.6] 02.04.2006
  + Bug fixing

[0.7.7] 02.04.2006
  + CompId now checked.
  + action=6 added to cheats.ini
  + allowautoban function added to rules.ini
  ~ major bug fixes
  
[0.7.8] 03.04.2006
  + Introduced synchronization (GetRemoteInfo)

[0.7.9] 03.04.2006
  + Continue synchronization fixing (GetRemoteInfo)
  + Some hack checks added

[0.7.13] 03.04.2006 
  + Bugfixing
  ~ Temp fix for false cheat detection alerts - you can still see 
    red messages saying fake alert detected, but that's not cheat,
    it's nothing more but what it says. 

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
To DO:
  - add-ons auto-updating
  - on-line cheat detection statistics
  - Want to add something? E-mail me: la1328@narod.ru or post on the forum www.1wow.ru

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Credits:

  Warlock, z19, MAIN, Saddy, Hunter, BestCat, WAD and the others :)

  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

If anybody would like to thank author for his work, you can do that via 
WebMoney Transfer system:
  Z314045073097
  E352709666074
  R418396750681

I'll be pleased... 

P.S. Note, that the project still stays free.