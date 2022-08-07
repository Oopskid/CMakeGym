startScript(fileOps)
# Provides functionality for deciphering files

include(${CMAKE_CURRENT_LIST_DIR}/logic.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/strings.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/debug.cmake)

macro(getDirFiles returnList location fileTypes)
   # Search for each file type in the directory and append to list 
   foreach(FORMAT ${${fileTypes}})
      FILE(GLOB found LIST_DIRECTORIES FALSE RELATIVE ${location} ${location}/*${FORMAT})
      set(${returnList} "${found}${${returnList}}")
   endforeach()
endmacro()

#[[
# Returns text within braces
macro(getBraced text delimfront delimback out)
   set(regexpr "[" ${delimfront} "].*[" ${delimback} "]")
   string(REGEX MATCH ${regexpr} ${out} ${text})
endmacro()

# Deciphers a component of a hint file into values
# TODO: This can be optimized
function(hintchunk text concerns values)
   string(REGEX REPLACE "[{].*" "" ${concerns} ${text})
   string(REGEX REPLACE "[ ,\n\r]" "" ${concerns} ${${concerns}})
   string(REGEX REPLACE "\"\"" " " ${concerns} ${${concerns}})
   string(REGEX REPLACE "\"" "" ${concerns} ${${concerns}})
   
   string(REGEX MATCH "[{].*" ${values} ${text})
   string(REGEX REPLACE "[}].*" "" ${values} ${${values}})
   string(REGEX REPLACE "[{}]" "" ${values} ${${values}})
endfunction()

# Appends values from a hint file
function(hintdecipher text prefix)
sfunc(hintdecipher)
   set(VARS_CAUGHT)
   set(VALUES_CAUGHT)
   while(1)
      strexists(text)
      firebreak(out)

      # Process next chunk of values
      logInf(${text} ${text})
      hintchunk(${text} VARS_CAUGHT VALUES_CAUGHT)
      set(END_POS)
      string(FIND ${text} "}" END_POS)
      if(${END_POS} LESS_EQUAL 0)
         break()
      endif()
      MATH(EXPR END_POS "${END_POS}+1")
      set(LEN_SUB)
      string(LENGTH ${text} LEN_SUB)
      MATH(EXPR LEN_SUB "${END_POS}-${END_POS}-1")
      # Remove progress from text
      string(SUBSTRING ${text} ${END_POS} ${LEN_SUB} text)

      # Append values to found variables
      foreach(VAR_I IN LISTS ITEMS bb aa ff)
         if(NOT DEFINED ${prefix}${VAR_I})
            set(${prefix}${VAR_I} CACHE STRING FORCE)
            logInf(${prefix}${VAR_I} ${prefix}${VAR_I})
         endif()
         set(${prefix}${VAR_I} ${VALUES_CAUGHT} CACHE STRING FORCE)
         #logInf(${${prefix}""${VAR_I}} ${${prefix}""${VAR_I}})
      endforeach()
   endwhile()
efunc()
endfunction()


file(READ ${CMAKE_CURRENT_SOURCE_DIR}/hints/codefiles.hint test_fiel)
hintdecipher(${test_fiel} "__")
#logInf(${__bb} ${__bb})
]]

endScript(fileOps)