proc loadsqldb { dir } {
	source $dir/sqldb.tbc
}

package ifneeded SQLdb 0.2.4 [ list loadsqldb $dir ]
