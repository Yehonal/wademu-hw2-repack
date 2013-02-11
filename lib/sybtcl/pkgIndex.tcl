proc loadsybtcl { dir } {
	set oldcwd [ pwd ]
	cd $dir
	load sybtcl30[info sharedlibextension]
	cd $oldcwd
}

package ifneeded sybtcl 3.0 [ list loadsybtcl $dir ]
