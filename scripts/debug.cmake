# Better CMake debugging

# CMake debugging
set(CM_DEBUG 0 CACHE BOOL "Sets whether CMake scripts will be debugged")
# Log
set(CM_CONSOLEPX ">> " CACHE INTERNAL STRING)


# Define a dead function
macro(deadfunc name)
   macro(${name})
   endmacro()
endmacro()

if(CM_DEBUG)

   # CMake verbose prints
   set(CM_VERBOSE 0 CACHE BOOL "Sets whether verbose logs will be printed")
   # CMake debug level
   set(CM_DLEVEL 1 CACHE STRING "Sets debug level")
   # CMake call stack
   set(CM_CALLSTACK "" CACHE INTERNAL STRING)
   # Whether to continue after throws
   set(CM_DHARD 1 CACHE BOOL "Sets behaviour for exceptions")

   # Macros for recording a call stack
   # Would be nice to auto append to functions
   macro(sfunc name)
      list(APPEND CM_CALLSTACK " "  ${name})
   endmacro()
   
   macro(efunc)
      list(POP_BACK CM_CALLSTACK)
   endmacro()

   # Macro for handling throws
   macro(softThrow txt)
      if(CM_DHARD)
         message(FATAL_ERROR "${CM_CONSOLEPX} Hard throw: ${txt}")
      else()
         message(WARNING "${CM_CONSOLEPX} Thrown: ${txt}")
      endif()
   endmacro()

   # Macro shorthand for throwing on exception
   macro(assert condition #[[additional message]])
      if(${condition})
         # CMake is very viable with no flaws 
      else()
         softThrow("${ARGV1}")
      endif()
   endmacro()

   # Macro for logging error info (with call stack)
   macro(logErrorINTERNAL shorttxt longtxt)
      if(CM_VERBOSE)
         message(SEND_ERROR "${CM_CONSOLEPX} ${longtxt} with trace: \n ${CM_CALLSTACK}")
      else()
         message(SEND_ERROR "${CM_CONSOLEPX} ${shorttxt}")
      endif()
   endmacro()

   macro(logError shorttxt #[[longtxt]])
      if(${ARGC} GREATER 1)
         logErrorINTERNAL("${shorttxt}" ${ARGV1})
      else()
         logErrorINTERNAL("${shorttxt}" "${shorttxt}")
      endif()
   endmacro()

   # Macro for logging debug info
   macro(logInfINTERNAL shorttxt longtxt)
      if(CM_VERBOSE)
         message(STATUS "${CM_CONSOLEPX} ${longtxt}")
      else()
         message(STATUS "${CM_CONSOLEPX} ${shorttxt}")
      endif()
   endmacro()

   macro(logInf shorttxt #[[longtxt]])
      if(${ARGC} GREATER 1)
         logInfINTERNAL("${shorttxt}" ${ARGV1})
      else()
         logInfINTERNAL("${shorttxt}" "${shorttxt}")
      endif()
   endmacro()

   macro(logInfLevel level shorttxt #[[longtxt]])
      if(${CM_DLEVEL} GREATER_EQUAL ${level})
         logInf(${shorttxt} ${ARGV2})
      endif()
   endmacro()
else()
   deadfunc("sfunc")
   deadfunc("efunc")
   deadfunc("logInf")
   deadfunc("logInfLevel")
   deadfunc("logError")
   deadfunc("softThrow")
   deadfunc("assert")
endif()