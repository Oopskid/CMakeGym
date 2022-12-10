include(${CMAKE_CURRENT_LIST_DIR}/modules.cmake)
startScript(gymcore)
# Core script to manage CMake'd projects

# Define a dead function
macro(deadfunc name)
   macro(${name})
   endmacro()
endmacro()

# VS switch
if(CMAKE_GENERATOR MATCHES "Visual Studio")
   set(isVS 1 CACHE INTERNAL BOOL)
else()
   set(isVS 0 CACHE INTERNAL BOOL)
endif()

# Setup a project as the main one
macro(setMain name)
   if(${isVS})
      set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT ${name})
   endif()
endmacro()

endScript(gymcore)

# Post includes
include(${CMAKE_CURRENT_LIST_DIR}/commoninc.cmake)