# Better CMake debugging

include(scripts/core.cmake)

# CMake debugging
set(CM_DEBUG FALSE CACHE BOOL "Sets whether CMake scripts will be debugged")
# CMake verbose prints
set(CM_VERBOSE FALSE CACHE BOOL "Sets whether verbose logs will be printed")
# CMake call stack
set(CM_CALLSTACK "" CACHE INTERNAL STRING)
# Log
set(CM_CONSOLEPX ">> " CACHE INTERNAL STRING FORCE)

if(CM_DEBUG)
   # Macros for recording a call stack
   # Would be nice to auto append to functions
   macro(sfunc name)
      list(APPEND CM_CALLSTACK " "  ${name})
   endmacro()
   
   macro(efunc)
      list(POP_BACK CM_CALLSTACK)
   endmacro()

   #Macro for logging error info (with call stack)
   macro(logErrorINTERNAL shorttxt longtxt)
      if(CM_VERBOSE)
         message(SEND_ERROR ${CM_CONSOLEPX} ${longtxt} " with trace: \n" ${CM_CALLSTACK})
      else()
         message(SEND_ERROR ${CM_CONSOLEPX} ${shorttxt})
      endif()
   endmacro()

   macro(logError shorttxt #[[longtxt]])
      if(${ARGC} GREATER 1)
         logErrorINTERNAL(${shorttxt} ${ARGV1})
      else()
         logErrorINTERNAL(${shorttxt} ${shorttxt})
      endif()
   endmacro()

   # Macro for logging debug info
   macro(logInfINTERNAL shorttxt longtxt)
      if(CM_VERBOSE)
         message(STATUS ${CM_CONSOLEPX} ${longtxt})
      else()
         message(STATUS ${CM_CONSOLEPX} ${shorttxt})
      endif()
   endmacro()

   macro(logInf shorttxt #[[longtxt]])
      if(${ARGC} GREATER 1)
         logInfINTERNAL(${shorttxt} ${ARGV1})
      else()
         logInfINTERNAL(${shorttxt} ${shorttxt})
      endif()
   endmacro()
else()
   deadfunc("sfunc")
   deadfunc("efunc")
   deadfunc("loginf")
   deadfunc("logError")
endif()
