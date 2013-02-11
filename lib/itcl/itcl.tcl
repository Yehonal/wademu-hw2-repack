#
# itcl.tcl
# ----------------------------------------------------------------------
# Invoked automatically upon startup to customize the interpreter
# for [incr Tcl].
# ----------------------------------------------------------------------
#   AUTHOR:  Michael J. McLennan
#            Bell Labs Innovations for Lucent Technologies
#            mmclennan@lucent.com
#            http://www.tcltk.com/itcl
#
#      RCS:  $Id: itcl.tcl,v 1.5 2002/09/29 19:30:27 davygrvy Exp $
# ----------------------------------------------------------------------
#            Copyright (c) 1993-1998  Lucent Technologies, Inc.
# ======================================================================
# See the file "license.terms" for information on usage and
# redistribution of this file, and for a DISCLAIMER OF ALL WARRANTIES.

proc ::itcl::delete_helper { name args } {
    ::itcl::delete object $name
}

# ----------------------------------------------------------------------
#  USAGE:  local <className> <objName> ?<arg> <arg>...?
#
#  Creates a new object called <objName> in class <className>, passing
#  the remaining <arg>'s to the constructor.  Unlike the usual
#  [incr Tcl] objects, however, an object created by this procedure
#  will be automatically deleted when the local call frame is destroyed.
#  This command is useful for creating objects that should only remain
#  alive until a procedure exits.
# ----------------------------------------------------------------------
proc ::itcl::local {class name args} {
    set ptr [uplevel [list $class $name] $args]
    uplevel [list set itcl-local-$ptr $ptr]
    set cmd [uplevel namespace which -command $ptr]
    uplevel [list trace variable itcl-local-$ptr u \
        "::itcl::delete_helper $cmd"]
    return $ptr
}


