proc loadoratcl { dir } {
	set oldcwd [ pwd ]
	cd $dir
	load oratcl43[info sharedlibextension]
	cd $oldcwd
}

package ifneeded oratcl 4.3 [ list loadoratcl $dir ]
