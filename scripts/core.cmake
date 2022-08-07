include(${CMAKE_CURRENT_LIST_DIR}/modules.cmake)
startScript(gymcore)
# Core script to manage CMake'd projects

# VS switch
if(CMAKE_GENERATOR MATCHES "Visual Studio")
   set(isVS true)
else()
   set(isVS false)
endif()

# Define a dead function
macro(deadfunc name)
   macro(${name})
   endmacro()
endmacro()

# Setup a project as the main one
macro(setMain name)
   if(${isVS})
      set_property(DIRECTORY PROPERTY VS_STARTUP_PROJECT ${name})
   endif()
endmacro()

endScript(gymcore)