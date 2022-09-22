startScript(depend)
# Dependency tracker, resolver and dictator

# Module types
set(DP_APP "exe" CACHE INTERNAL STRING) # Built app
set(DP_DLIB "dlib" CACHE INTERNAL STRING) # Built dynamic library
set(DP_SLIB "lib" CACHE INTERNAL STRING) # Built static library
set(DP_PACK "pac" CACHE INTERNAL STRING) # Resources (file management)
set(DP_MAKE "mak" CACHE INTERNAL STRING) # Build scripts
set(DP_EXT "ext" CACHE INTERNAL STRING) # External (unused)

# Declares a module which can be used
macro(declare name #[[type deferred=false -more args coming-]])
   set(DEPEND_NAME M_${name})
   
   set(${DEPEND_NAME}_TYPE "${ARGV1}" CACHE INTERNAL STRING) # Denotes type
   set(${DEPEND_NAME}_RY 1 CACHE INTERNAL BOOL) # Flag when built/prepared
   set(${DEPEND_NAME}_DEF 0 CACHE INTERNAL BOOL) # Is deferred? (deferred is inherited from children)

    # Manual deferred
   if(${ARGC} GREATER 2)
      set(${DEPEND_NAME}_DEF ${ARGV2} CACHE INTERNAL BOOL)
      if(${DEPEND_NAME}_DEF)
         set(${DEPEND_NAME}_READY 0 CACHE INTERNAL BOOL) # Cannot be ready if deferred
      endif()
   endif()

endmacro()

# Appends a dependency (or multiple) to a target
macro(appendDepend target name #[...])
   
endmacro()

# Plural wrapper
macro(appendDepends target #[...])
   appendDepend(target ${ARGN})
endmacro()

endScript(depend)