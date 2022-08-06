include_guard(DIRECTORY)
# Provides basic, common functionality for cmake scripts and modules

set(STEALTH FALSE CACHE INTERNAL BOOL) # Suppresses some visible options

# Common setup for modules
macro(startScript moduleName)
   include_guard(DIRECTORY)
endmacro()

macro(endScript moduleName)
   
endmacro()

# Common setup for projects
macro(startProj projectName #[[version, description, url, languages]])
   include_guard(DIRECTORY)

   # Kill the entire project if not including it has been cached
   set(includeName INCLUDE_${projectName})
   if(DEFINED ${includeName})
      if(NOT ${includeName})
         return()
      endif()
   endif()

   if(NOT ${STEALTH})
      set(${includeName} TRUE CACHE BOOL "Includes project ${projectName} in the build")
   endif()
   
   project(${projectName} ${ARGV1} ${ARGV2} ${ARGV3} ${ARGV4})

   set(INCLUDES "")

endmacro()

macro(endProj projectName)
   
endmacro()

# Linking files to targets
function(addIncludesAuto location fileTypes #[[filterName]])

endfunction()

function(addIncludes location sources #[[filterName]])
   
   set(PREINCLUDES "")
   foreach(SOURCE ${${sources}}) # WHY IS THIS A THING
      set(PREINCLUDES "${location}${SOURCE} ${PREINCLUDES}")
   endforeach()
   logInf("Adding ${PREINCLUDES}to includes")
   set(INCLUDES "${INCLUDES} ${PREINCLUDES}")

   # Manage filter
   if(${ARGC} GREATER 2)
      set(FILTERSLIST "${ARGV2} ${FILTERSLIST}")
      set(FILTER_${ARGV2} "${PREINCLUDES} ${FILTER_${ARGV2}}")
      logInf("(filtered by ${ARGV2})")
   endif()
endfunction()
