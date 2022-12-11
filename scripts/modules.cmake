include_guard(DIRECTORY)
# Provides basic, common functionality for cmake scripts and modules
include(${CMAKE_CURRENT_LIST_DIR}/debug.cmake)

set(STEALTH 0 CACHE INTERNAL BOOL) # Suppresses some visible options
set(CM_AUTO_FILTER 1 CACHE BOOL "Whether to use relative paths to automatically filter sources")

# Strict once only
macro(onceStrict uniqueName)
   # Anti recache
   if(STRICT_${uniqueName}) 
      return()
   endif()
   set(STRICT_${uniqueName} 1 CACHE INTERNAL BOOL)
endmacro()

# Common setup for modules
macro(startScript moduleName)
   include_guard(DIRECTORY)
endmacro()

macro(endScript moduleName)
   
endmacro()

# Common setup/clearing of cached data used for targets
macro(cleanTarget)
   set(INCLUDES "" CACHE INTERNAL STRING)
   set(INCLUDE_DIRS "" CACHE INTERNAL STRING)
   set(FILTERSLIST "" CACHE INTERNAL STRING) # Can cause junk, fault of user
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
      logInfLevel(3 "Starting project ${projectName}")
   endif()
   
   project(${projectName} ${ARGV1} ${ARGV2} ${ARGV3} ${ARGV4})

   cleanTarget()

endmacro()

macro(endProj projectName)
   
endmacro()

# Common setup for libraries (abstract libraries too)
macro(startLib libraryName)
   include_guard(DIRECTORY)

   # Ignore this library scope depending on preference
   set(useName USE_${libraryName})
   if(DEFINED ${useName})
      if(NOT ${useName})
         return()
      endif()
   endif()

   if(NOT ${STEALTH})
      set(${useName} 1 CACHE BOOL "Includes lib ${libraryName} in the build")
      logInfLevel(3 "Starting lib ${libraryName}")
   endif()

   cleanTarget()

endmacro()

macro(endLib libraryName)
   
endmacro()

include(${CMAKE_CURRENT_LIST_DIR}/fileops.cmake)

# Add include directory to list
macro(addIncludeDir dir)
   set(INCLUDE_DIRS "${dir};${INCLUDE_DIRS}" CACHE INTERNAL STRING)
endmacro()

# Appends a filter for sources
macro(addFilter sources filter)
   if(NOT DEFINED FILTER_${filter})
      set(FILTERSLIST "${filter};${FILTERSLIST}" CACHE INTERNAL STRING)
   endif()
   set(FILTER_${filter} "${sources};${FILTER_${filter}}" CACHE INTERNAL STRING)
endmacro()

# Linking files to targets
function(addIncludesAuto location fileTypes #[[filterName]])
   set(FETCHEDFILES "" CACHE INTERNAL STRING)   
   getDirFiles(FETCHEDFILES ${location};${fileTypes} CM_AUTO_FILTER)

   addIncludes(${location}/ FETCHEDFILES ${ARGV2}) # Slightly counterintuitive pathing
endfunction()

function(addIncludes location sources #[[filterName]])
   addIncludeDir(${location})

   # Manage included
   set(PREINCLUDES "")
   foreach(SOURCE ${${sources}}) # WHY IS THIS A THING
      set(PREINCLUDES "${location}${SOURCE};${PREINCLUDES}")
   endforeach()
   logInf("Adding ${PREINCLUDES} to includes" )
   set(INCLUDES "${PREINCLUDES};${INCLUDES}" CACHE INTERNAL STRING)

   # Manage filters
   if(CM_AUTO_FILTER)
      foreach(SOURCE ${${sources}}) # WHY IS THIS A THING
         getDir(${SOURCE} DIR)
         set(DIR ${ARGV2}/${DIR})
         addFilter(${location}${SOURCE} ${DIR})
      endforeach()
      logInf("(auto filtered by ${ARGV2})")
   else()
      if(${ARGC} GREATER 2)
         addFilter(${PREINCLUDES} ${ARGV2})
         logInf("(filtered by ${ARGV2})")
      endif()
   endif()
endfunction()

# Finally, configure the includes
function(bindIncludes target #[[+ flags]])
   target_include_directories(${target} PUBLIC "${INCLUDE_DIRS}")
   set(INCLUDE_DIRS "")

   # Filters
   foreach(FILTER ${FILTERSLIST})
      source_group(${FILTER} FILES ${FILTER_${FILTER}})
      unset(FILTER_${FILTER} CACHE)
   endforeach()
   set(FILTERSLIST "")

endfunction()