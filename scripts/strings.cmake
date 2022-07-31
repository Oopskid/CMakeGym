# Many string related functions

# Evaluates to whether a string variable logically exists
macro(strexists str)
   if(NOT ${str} STREQUAL "")
      set(out 1)
   else()
      set(out 0)
   endif()
endmacro()