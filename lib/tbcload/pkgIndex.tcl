proc loadtbcload { dir } {
	set oldcwd [ pwd ]
	cd $dir
	load tbcload14[info sharedlibextension]
	cd $oldcwd
}

package ifneeded tbcload 1.4 [ list loadtbcload $dir ]
