# Many boolean related functions

# Breaks if a condition is not true (assert)
macro(firebreak cond)
   if(NOT ${cond})
      break()
   endif()
endmacro()