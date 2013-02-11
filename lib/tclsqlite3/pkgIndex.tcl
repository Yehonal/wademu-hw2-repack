proc loadsqlite3 { dir } {
	set oldcwd [ pwd ]
	cd $dir
	load tclsqlite3[info sharedlibextension]
	cd $oldcwd
}

package ifneeded sqlite3 3.3.5 [ list loadsqlite3 $dir ]
