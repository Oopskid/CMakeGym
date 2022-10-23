startScript(depend)
# Dependency tracker, resolver and dictator
include(${CMAKE_CURRENT_LIST_DIR}/core.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/debug.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/logic.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cont/dependbuilders.cmake)

#Globals
set(MODULE_LIST "" CACHE INTERNAL STRING) # A comprehensive list of all modules (debug and link help)
set(CM_DEPEND_DEFER 0 CACHE BOOL "If modules should be built last") # Should dependencies be deferred or built instantly

# Declares a module which can be used
function(declare name #[[type deferred=false built=false -more args coming-]])
   set(DEPEND_NAME M_${name})
   
   logInfLevel(2 "New module ${name}")
   if(CM_DEBUG)
      assert("NOT DEFINED ${DEPEND_NAME}_TYPE" "Module ${name} already defined!")
      set(${MODULE_LIST} "${name};${MODULE_LIST}") # Add to global list
      set(${DEPEND_NAME}_REFS "0" CACHE INTERNAL STRING) # Times referenced
   endif()

   set(${DEPEND_NAME}_TYPE "${ARGV1}" CACHE INTERNAL STRING) # Denotes type
   set(${DEPEND_NAME}_RY 1 CACHE INTERNAL BOOL) # Flag when ready to be consumed by other modules
   set(${DEPEND_NAME}_FIN 0 CACHE INTERNAL BOOL) # Flag when actually built
   set(${DEPEND_NAME}_DEF ${CM_DEPEND_DEFER} CACHE INTERNAL BOOL) # Is deferred? (deferred is inherited from children)

    # Manual deferred
   if(${ARGC} GREATER 2)
      set(${DEPEND_NAME}_DEF ${ARGV2} CACHE INTERNAL BOOL)
      if(${DEPEND_NAME}_DEF)
         set(${DEPEND_NAME}_RY 0 CACHE INTERNAL BOOL) # Cannot be ready if deferred
      endif()
   endif()
   # Manual built
   if(${ARGC} GREATER 3)
      # Must be ready to be built
      if(${DEPEND_NAME}_RY)
         set(${DEPEND_NAME}_FIN ${ARGV3} CACHE INTERNAL BOOL)
      endif()
   endif()
endfunction()

# Appends a dependency to a target
function(appendDepend target name #[[...]])
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
macro(appendDepends target name #[[...]])
   appendDepend(${target} ${name})
   foreach(ARG ${ARGN})
      appendDepend(${target} ${ARG})
   endforeach()
endmacro()

# Make a dependency now
function(makeDepend name)
   set(DEPEND_NAME M_${name})
   set(DEPEND_TYPE ${${DEPEND_NAME}_TYPE})
   set(FN_CALL ${DEPEND_TYPE}_MAKER)

   # --Prebuild--
   # Check dependencies, build each if required
   foreach(SUBDEPEND ${${name}_DS})
      set(SUBDEPEND_NAME M_${SUBDEPEND})
      if(DEFINED ${SUBDEPEND_NAME})
         # Exists
         if(NOT ${SUBDEPEND_NAME}_RY)
            # Requires build
            makeDepend(${SUBDEPEND})
            # Validate
            assert("${SUBDEPEND_NAME}_RY" "Module ${SUBDEPEND} was not built for parent ${name}")
         endif()
      endif()
   endforeach()

   # --Call the builder--
   reflectCall(${FN_CALL} ${name})

   # --Post build--
   # Validation
   assert("${DEPEND_NAME}_RY" "Module ${name} was not built successfully")

endif()

endScript(depend)