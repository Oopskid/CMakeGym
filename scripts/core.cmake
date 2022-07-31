# Core script to manage CMake'd projects

# Define a dead function
macro(deadfunc name)
   macro(${name})
   endmacro()
endmacro()