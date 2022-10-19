startScript(dependbuilders)
# Default module builders
include(${CMAKE_CURRENT_LIST_DIR}/dependcommon.cmake)

# App
function(exe_MAKER name)
   clearStamps()
   collectChildStamps(${name})

   add_dependencies(${name} "${STAMPS_TOPLEVEL}")
   readyDepend(${name})
endfunction()

function(exe_STAMP name target)
   stampTopLevel(${name})
endfunction()

# Dynamic library
function(dlib_MAKER name)
   clearStamps()
   collectChildStamps(${name})

   add_dependencies(${name} "${STAMPS_TOPLEVEL}")
   readyDepend(${name})
endfunction()
function(dlib_STAMP name target)
   stampTopLevel(${name})
endfunction()

# Static library
function(lib_MAKER name)
   clearStamps()
   collectChildStamps(${name})

   add_dependencies(${name} "${STAMPS_TOPLEVEL}")
   readyDepend(${name})
endfunction()
function(lib_STAMP name target)
   stampTopLevel(${name})
endfunction()

# Resources
function(pac_MAKER name)
   clearStamps()
   collectChildStamps(${name})

endfunction()
function(pac_STAMP name target)
endfunction()

# Scripts
function(mak_MAKER name)
   clearStamps()
   collectChildStamps(${name})

endfunction()
function(mak_STAMP name target)
endfunction()

# External (unused)
function(ext_MAKER name)
   clearStamps()
   collectChildStamps(${name})

endfunction()
function(ext_STAMP name target)
endfunction()

endScript(dependbuilders)