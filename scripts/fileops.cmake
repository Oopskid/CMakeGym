# Provides functionality for deciphering files

# Returns text within braces
macro(getBraced text delimfront delimback out)
   set(regexpr "[" ${delimfront} "].*[" ${delimback} "]")
   string(REGEX MATCH ${regexpr} ${out} ${text})
endmacro()

# Deciphers a component of a hint file into values
# TODO: This can be optimized
macro(hintdecipher text concerns values)
   string(REGEX REPLACE "[{].*" "" ${concerns} ${text})
   string(REGEX REPLACE "[ ,\n\r]" "" ${concerns} ${${concerns}})
   string(REGEX REPLACE "\"\"" " " ${concerns} ${${concerns}})
   string(REGEX REPLACE "\"" "" ${concerns} ${${concerns}})
   
   string(REGEX MATCH "[{].*" ${values} ${text})
   string(REGEX REPLACE "[}].*" "" ${values} ${${values}})
   string(REGEX REPLACE "[{}]" "" ${values} ${${values}})
endmacro()

hintdecipher(" \"c\",\"c++\"\"g\"{{{{{ff\"\"{}}{}{}{}\"\"\"\"{}}}" cc vv)
message(STATUS ${cc})
message(STATUS ${vv})