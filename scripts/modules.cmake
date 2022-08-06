include_guard(DIRECTORY)
# Provides basic, common functionality for cmake scripts and modules

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
   set(${includeName} TRUE CACHE BOOL "Includes project ${projectName} in the build")
   
   project(${projectName} ${ARGV1} ${ARGV2} ${ARGV3} ${ARGV4})

endmacro()

macro(endProj projectName)
   
endmacro()