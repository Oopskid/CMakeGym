startScript(fileOps)
# Provides functionality for deciphering files

include(${CMAKE_CURRENT_LIST_DIR}/logic.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/strings.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/debug.cmake)

# Returns exclusive format files of a directory
macro(getDirFiles returnList location fileTypes #[[isRecursive]])
    set(GLOBTYPE GLOB)
    if(${ARGC} GREATER 3)
       if(${ARGV3})
          set(GLOBTYPE GLOB_RECURSE)
       endif()
    endif()

   # Search for each file type in the directory and append to list 
   foreach(FORMAT ${${fileTypes}})
      FILE(${GLOBTYPE} found LIST_DIRECTORIES FALSE RELATIVE ${location} ${location}/*${FORMAT})
      set(${returnList} "${found};${${returnList}}")
   endforeach()
endmacro()

# Returns the directory of a path
macro(getDir path outVar)
   string(REGEX MATCH .*/ ${outVar} ${path})
endmacro()

# Returns text within braces
macro(getBraced text delimfront delimback out)
   set(regexpr "[" ${delimfront} "].*[" ${delimback} "]")
   string(REGEX MATCH ${regexpr} ${out} ${text})
endmacro()

# Deciphers a component of a hint file into values
# TODO: This can be optimized
macro(hintchunk text concerns values)
   string(REGEX REPLACE "[{].*" "" "${concerns}" "${text}")
   string(REGEX REPLACE "[ ,\n\r]" "" "${concerns}" "${${concerns}}")
   string(REGEX REPLACE "\"\"" ";" "${concerns}" "${${concerns}}")
   string(REGEX REPLACE "\"" "" "${concerns}" "${${concerns}}")

   string(REGEX MATCH "[{].*" "${values}" "${text}")
   string(REGEX REPLACE "[}].*" "" "${values}" "${${values}}")
   string(REGEX REPLACE "[{}]" "" "${values}" "${${values}}")
   string(REGEX REPLACE "[\n]" ";" "${values}" "${${values}}")
   string(REGEX REPLACE "[ ,\n\r]" "" "${values}" "${${values}}")
endmacro()

# Appends values from a hint file
function(hintdecipher text prefix)
sfunc(hintdecipher)
   set(VARS_CAUGHT)
   set(VALUES_CAUGHT)
   while(1)
      strexists(text)
      firebreak(out)

      # Process next chunk of values
      hintchunk("${text}" VARS_CAUGHT VALUES_CAUGHT)
      set(END_POS)
      string(FIND "${text}" "}" END_POS)
      if(${END_POS} LESS_EQUAL 0)
         break()
      endif()
      MATH(EXPR END_POS "${END_POS}+1")
      set(LEN_SUB)
      string(LENGTH "${text}" LEN_SUB)
      MATH(EXPR LEN_SUB "${END_POS}-${END_POS}-1")
      # Remove progress from text
      string(SUBSTRING "${text}" ${END_POS} ${LEN_SUB} text)

      # Append values to found variables
      foreach(VAR_I ${VARS_CAUGHT})
         if(NOT DEFINED "${prefix}${VAR_I}")
            set("${prefix}${VAR_I}" CACHE INTERNAL STRING)
         endif()
         set("${prefix}${VAR_I}" "${VALUES_CAUGHT}${${prefix}${VAR_I}}" CACHE INTERNAL STRING)
      endforeach()
   endwhile()
efunc()
endfunction()

endScript(fileOps)