proc loadsqlite { dir } {
	set oldcwd [ pwd ]
	cd $dir
	load tclsqlite[info sharedlibextension]
	cd $oldcwd
}

package ifneeded sqlite 2.0 [ list loadsqlite $dir ]
