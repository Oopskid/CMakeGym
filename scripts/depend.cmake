startScript(depend)
# Dependency tracker, resolver and dictator
include(${CMAKE_CURRENT_LIST_DIR}/debug.cmake)

#Globals
set(MODULE_LIST "" CACHE INTERNAL STRING) # A comprehensive list of all modules (debug and link help)
set(DEPEND_DEFER 1 CACHE BOOL "If modules should be built last") # Should dependencies be deferred or built instantly

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
   
   if(CM_DEBUG)
      assert("NOT DEFINED ${DEPEND_NAME}_TYPE" "Module ${name} already defined!")
      set(${MODULE_LIST} "${name};${MODULE_LIST}") # Add to global list
      set(${DEPEND_NAME}_REFS "0" CACHE INTERNAL STRING) # Times referenced
   endif()   

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

# Appends a dependency to a target
function(appendDepend target name)
   # Append dependency to list
   set(${target}_DS "${name};${${target}_DS}" CACHE INTERNAL STRING)

   if(CM_DEBUG)
      assert("target NOT STREQUAL name" "A module cannot depend on itself")
      math(EXPR ${M_${name}_REFS} "${M_${name}_REFS} + 1" DECIMAL) # Increment reference counter
   endif()

   # Inherit deferred
   if(M_${name}_DEF)
      set(M_${target}_DEF 1 CACHE INTERNAL BOOL)
   endif()
endfunction()

# Appends a dependency (or multiple) to a target
macro(appendDepends target name #[...])
   appendDepend(${target} ${name})
   foreach(ARG ${ARGN})
      appendDepend(${target} ${ARG})
   endforeach()
endmacro()

endScript(depend)