# Tcl package index file, version 1.1
# This is a modified package index file for Pgtcl on Windows. libpgtcl needs
# libpq, but libpq has to be found on PATH. So this modifies PATH before
# loading libpgtcl, then restores PATH after. This allows you to store
# both libpgtcl.dll and [b]libpq.dll in the package directory.

proc Pgtcl__load_with_path {dir} {
  global env
  set save_path $env(PATH)
  append env(PATH) ";$dir"
  load [file join $dir libpgtcl.dll]
  set env(PATH) $save_path
}
package ifneeded Pgtcl 1.5.2 [list Pgtcl__load_with_path $dir]
