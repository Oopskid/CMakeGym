startScript(dependcommon)
# Common module types
set(DP_APP "exe" CACHE INTERNAL STRING) # Built app
set(DP_DLIB "dlib" CACHE INTERNAL STRING) # Built dynamic library
set(DP_SLIB "lib" CACHE INTERNAL STRING) # Built static library
set(DP_PACK "pac" CACHE INTERNAL STRING) # Resources (file management)
set(DP_MAKE "mak" CACHE INTERNAL STRING) # Build scripts
set(DP_EXT "ext" CACHE INTERNAL STRING) # External (unused)

# Readies up a module
macro(readyDepend name)
   set(M_${name}_RY 1 CACHE INTERNAL BOOL)
endmacro()

# Clears stamp lists (used for accumulating pledges from dependencies towards their parent)
function(clearStamps)
   set(STAMPS_TOPLEVEL "" CACHE INTERNAL STRING) # Dependency targets satisfying Top-Level status of CMake
endfunction()
# Accumulates pledges from dependencies towards a parent module
function(collectChildStamps name)
   firebreak("DEFINED M_${name}_DS")
   foreach(SUBDEPEND ${M_${name}_DS})
      # Get the child variables
      set(SUBDEPEND_NAME M_${SUBDEPEND})
      set(SUBDEPEND_TYPE ${${SUBDEPEND_NAME}_TYPE})

      # Call the stamper
      set(FN_CALL ${SUBDEPEND_TYPE}_STAMP)
      reflectCall(${FN_CALL} ${name})
   endforeach()
endfunction()

# Claim a target satisfies Top-Level status of CMake
macro(stampTopLevel name)
   set(STAMPS_TOPLEVEL "${name};${STAMPS_TOPLEVEL}" CACHE INTERNAL STRING)
endmacro()

endScript(dependcommon)