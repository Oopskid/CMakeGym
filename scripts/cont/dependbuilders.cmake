startScript(dependbuilders)
# Default module builders
include(${CMAKE_CURRENT_LIST_DIR}/dependcommon.cmake)

# App
function(exe_MAKER name)
   set(DEPEND_NAME M_${name})

   clearStamps()
   collectChildStamps(${name})

   if(NOT ${DEPEND_NAME}_RY)
      readyDepend(${name}) # TODO
   endif()

   if(NOT ${DEPEND_NAME}_FIN AND NOT ${DEPEND_NAME}_DEF)
      add_dependencies(${name} "${STAMPS_TOPLEVEL}")
      builtDepend(${name})
   endif()
  
endfunction()

function(exe_STAMP name target)
   stampTopLevel(${name})
endfunction()

# Dynamic library
function(dlib_MAKER name)
   set(DEPEND_NAME M_${name})   

   clearStamps()
   collectChildStamps(${name})

   if(NOT ${DEPEND_NAME}_RY)
      readyDepend(${name}) # TODO
   endif()

   if(NOT ${DEPEND_NAME}_FIN AND NOT ${DEPEND_NAME}_DEF)
      add_dependencies(${name} "${STAMPS_TOPLEVEL}")
      builtDepend(${name})
   endif()
endfunction()
function(dlib_STAMP name target)
   stampTopLevel(${name})
endfunction()

# Static library
function(lib_MAKER name)
   set(DEPEND_NAME M_${name})   

   clearStamps()
   collectChildStamps(${name})

   if(NOT ${DEPEND_NAME}_RY)
      readyDepend(${name}) # TODO
   endif()

   if(NOT ${DEPEND_NAME}_FIN AND NOT ${DEPEND_NAME}_DEF)
      add_dependencies(${name} "${STAMPS_TOPLEVEL}")
      builtDepend(${name})
   endif()
endfunction()
function(lib_STAMP name target)
   stampTopLevel(${name})
endfunction()

# Resources
function(pac_MAKER name)
   set(DEPEND_NAME M_${name})

   clearStamps()
   collectChildStamps(${name})
   # TODO
endfunction()
function(pac_STAMP name target)
endfunction()

# Scripts
function(mak_MAKER name)
   set(DEPEND_NAME M_${name})

   clearStamps()
   collectChildStamps(${name})
   # TODO
endfunction()
function(mak_STAMP name target)
endfunction()

# External (unused)
function(ext_MAKER name)
   set(DEPEND_NAME M_${name})   

   clearStamps()
   collectChildStamps(${name})
   
   # Hmm, todo?
endfunction()
function(ext_STAMP name target)
endfunction()

endScript(dependbuilders)