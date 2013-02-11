@echo off
cls
echo About the mounts patch data:
echo The patch tools looks through the world.save file for a specific GUID that
echo represents a person.  Only a single instance of this exists in any game world.
echo That fact and because the data is text, makes this patch easy, as apposed to
echo an EXE/DLL or RAM patch.  The GUID is replace with the new GUID.  This usually
echo involves changing the person from standing to sitting.
echo Next, the now sitting person is placed onto a mount.  The MOUNT entry is
echo placed just after the modified GUID.  The biggest issue, aside from patience,
echo was placing the forced CR between the new GUID and added MOUNT data.
echo Older patchers relied upon XYZ object placement.  This became annoying when
echo world developers would move an object.
echo Also, some world object XYZ's matched SPAWN points.
echo SPAWN points should never me mounted.
echo It wasn't until recently that many bad OBJECTS were removed,
echo leaving each with a unique ID.  This has been tested on NN2 and worked perfect.
echo It was also tested on RR11 world.save...RR11 world save was released after NN2.
echo It destroyed over 8,000 world objects, undocumented as to why,
echo and eliminated over 2 dozen mountable NPC's.
echo If an OBJECT has been eliminated, it simply will bot be updated.
echo The patcher is just a basic G.S.A.R. tool and only performs the search once per entry.

if not exist world.save goto BAD

echo.
pause

copy world.save world.dat
echo world.save backed up...
echo.
echo Patching...
gsar -i -o "-sGUID:x3d0106A4" "-rGUID:x3d04904:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d0111E2" "-rGUID:x3d016701:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d013000" "-rGUID:x3d01832A:x0d:x0aMOUNT:x3d14329" world.dat  > NULL
gsar -i -o "-sGUID:x3d0131CC" "-rGUID:x3d017EB3:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d01374D" "-rGUID:x3d07478:x0d:x0aMOUNT:x3d10672" world.dat   > NULL
gsar -i -o "-sGUID:x3d013983" "-rGUID:x3d0344E:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d013C57" "-rGUID:x3d0BE3E:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d0158CB" "-rGUID:x3d0EFD4:x0d:x0aMOUNT:x3d14329" world.dat   > NULL
gsar -i -o "-sGUID:x3d015AFC" "-rGUID:x3d01FCD:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d015DCC" "-rGUID:x3d01AC92:x0d:x0aMOUNT:x3d2409" world.dat   > NULL
gsar -i -o "-sGUID:x3d016775" "-rGUID:x3d0E0AB:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d016BE4" "-rGUID:x3d01214D:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d0170F0" "-rGUID:x3d01D269:x0d:x0aMOUNT:x3d1166" world.dat   > NULL
gsar -i -o "-sGUID:x3d01844A" "-rGUID:x3d0182FD:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d018961" "-rGUID:x3d0196F0:x0d:x0aMOUNT:x3d2409" world.dat   > NULL
gsar -i -o "-sGUID:x3d0190B1" "-rGUID:x3d0E09B:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d019196" "-rGUID:x3d02D6A:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d019517" "-rGUID:x3d01AE05:x0d:x0aMOUNT:x3d10672" world.dat  > NULL
gsar -i -o "-sGUID:x3d01A160" "-rGUID:x3d0116E8:x0d:x0aMOUNT:x3d284" world.dat    > NULL
gsar -i -o "-sGUID:x3d01A2B2" "-rGUID:x3d01AB7:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d01A506" "-rGUID:x3d0DA84:x0d:x0aMOUNT:x3d2409" world.dat    > NULL
gsar -i -o "-sGUID:x3d01B599" "-rGUID:x3d01473F:x0d:x0aMOUNT:x3d1166" world.dat   > NULL
gsar -i -o "-sGUID:x3d01BA8C" "-rGUID:x3d07AB7:x0d:x0aMODEL:x3d4145" world.dat    > NULL
gsar -i -o "-sGUID:x3d01BA8C" "-rGUID:x3d07AB7:x0d:x0aMOUNT:x3d2409" world.dat    > NULL
gsar -i -o "-sGUID:x3d01CAD8" "-rGUID:x3d01BB17:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d01CD9A" "-rGUID:x3d017035:x0d:x0aMOUNT:x3d14329" world.dat  > NULL
gsar -i -o "-sGUID:x3d01D000" "-rGUID:x3d0A09C:x0d:x0aMOUNT:x3d2409" world.dat    > NULL
gsar -i -o "-sGUID:x3d01D092" "-rGUID:x3d017EA7:x0d:x0aMOUNT:x3d14329" world.dat  > NULL
gsar -i -o "-sGUID:x3d03109"  "-rGUID:x3d019A30:x0d:x0aMOUNT:x3d6080" world.dat   > NULL
gsar -i -o "-sGUID:x3d038FC"  "-rGUID:x3d0670E:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d04DA3"  "-rGUID:x3d0E84E:x0d:x0aMOUNT:x3d10672" world.dat   > NULL
gsar -i -o "-sGUID:x3d04DBD"  "-rGUID:x3d05C7A:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d05435"  "-rGUID:x3d0162EE:x0d:x0aMODEL:x3d4145" world.dat   > NULL
gsar -i -o "-sGUID:x3d05435"  "-rGUID:x3d0162EE:x0d:x0aMOUNT:x3d2409" world.dat   > NULL
gsar -i -o "-sGUID:x3d05D3C"  "-rGUID:x3d0E6C0:x0d:x0aMOUNT:x3d10672" world.dat   > NULL
gsar -i -o "-sGUID:x3d06214"  "-rGUID:x3d0C7C7:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d069DB"  "-rGUID:x3d01D576:x0d:x0aMOUNT:x3d1166" world.dat   > NULL
gsar -i -o "-sGUID:x3d075B6"  "-rGUID:x3d01D586:x0d:x0aMOUNT:x3d1166" world.dat   > NULL
gsar -i -o "-sGUID:x3d08652"  "-rGUID:x3d072D5:x0d:x0aMOUNT:x3d2410" world.dat    > NULL
gsar -i -o "-sGUID:x3d08BA7"  "-rGUID:x3d06C0E:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d0A3A5"  "-rGUID:x3d01080A:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d0A5E0"  "-rGUID:x3d0DFD3:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d0B0E5"  "-rGUID:x3d096E9:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d0C53F"  "-rGUID:x3d06C25:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d0CD06"  "-rGUID:x3d01C515:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d0D225"  "-rGUID:x3d0BB3F:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d0D52D"  "-rGUID:x3d0BEC7:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d0D544"  "-rGUID:x3d010D88:x0d:x0aMOUNT:x3d2409" world.dat   > NULL
gsar -i -o "-sGUID:x3d0D857"  "-rGUID:x3d013C41:x0d:x0aMOUNT:x3d6080" world.dat   > NULL
gsar -i -o "-sGUID:x3d0E0D7"  "-rGUID:x3d02EBB:x0d:x0aMOUNT:x3d2786" world.dat    > NULL
gsar -i -o "-sGUID:x3d0E356"  "-rGUID:x3d08BEC:x0d:x0aMOUNT:x3d10720" world.dat   > NULL
gsar -i -o "-sGUID:x3d0E992"  "-rGUID:x3d0557E:x0d:x0aMOUNT:x3d1166" world.dat    > NULL
gsar -i -o "-sGUID:x3d0EB7F"  "-rGUID:x3d01C4AF:x0d:x0aMOUNT:x3d2786" world.dat   > NULL
gsar -i -o "-sGUID:x3d0F01D"  "-rGUID:x3d017F17:x0d:x0aMOUNT:x3d1166" world.dat   > NULL

rename world.save world.bak
rename world.dat world.save

goto EXIT

:BAD
World.save appears to be missing.

:EXIT
echo Patching complete.
pause
