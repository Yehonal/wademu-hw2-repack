# Tcl package index file, version 1.0

set tcl_library [pwd]
set env(ITCL_LIBRARY) [pwd]/$dir

# load the DLLs
load [pwd]/$dir/itcl33.dll

# make all new commands known
namespace import itcl::*



