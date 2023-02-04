startScript(hlsl)
// Provides core HLSL functions

include(${CMAKE_CURRENT_LIST_DIR}/fileops.cmake)

set(HLSL_TARGET_DIR_GLOBAL "shaders" CACHE STRING "The default relative path to copy shaders resources to" FORCE)

set(HLSL_SHADER_GLOBAL_MODEL_MAJOR "5" CACHE STRING "The major version of hlsl shader model")
set(HLSL_SHADER_GLOBAL_MODEL_MINOR "1" CACHE STRING "The minor version of hlsl shader model")
set(HLSL_SHADER_GLOBAL_WORK_DIRECTORY "" CACHE STRING "The default working directory of shaders")
set(HLSL_SHADER_GLOBAL_OUTPUT_DIRECTORY "" CACHE STRING "The default output directory of compiled shaders")
set(HLSL_SHADER_GLOBAL_COMPILER "fxc.exe" CACHE STRING "The hlsl compiler to use")

# Known shader types
set(HLSL_TYPE_VERTEX "vs" CACHE INTERNAL STRING) # Vertex
set(HLSL_TYPE_PIXEL "ps" CACHE INTERNAL STRING) # Pixel
set(HLSL_TYPE_COMPUTE "cs" CACHE INTERNAL STRING) # Compute
set(HLSL_TYPE_HULL "hs" CACHE INTERNAL STRING) # Hull
set(HLSL_TYPE_DOMAIN "ds" CACHE INTERNAL STRING) # Domain
set(HLSL_TYPE_GEOMETRY "gs" CACHE INTERNAL STRING) # Geometry

macro(defineShaders target type shaders)
   # Defaults to global
   set(HLSL_${target}_SHADER_MODEL "${HLSL_SHADER_GLOBAL_MODEL_MAJOR}_${HLSL_SHADER_GLOBAL_MODEL_MINOR}" CACHE STRING "The shader model used for target ${target}")
   set(HLSL_${target}_WORKDIRECTORY "${HLSL_SHADER_GLOBAL_WORK_DIRECTORY}" CACHE STRING "The working directory for target ${target}")
   set(HLSL_${target}_OUTPUTDIRECTORY "${HLSL_SHADER_GLOBAL_OUTPUT_DIRECTORY}" CACHE STRING "The output directory for compiled shaders of target ${target}")

   foreach(shader "${shaders}")
      getPureFilename(${shader} shaderFilename)
      add_custom_command(TARGET ${target}
         COMMAND ${HLSL_SHADER_GLOBAL_COMPILER} /nologo /Emain /T${type}_${HLSL_${target}_SHADER_MODEL} $<IF:$<CONFIG:DEBUG>,/Od,/O1> /Zi /Fo ${HLSL_${target}_OUTPUTDIRECTORY}/${shaderFilename}.cso /Fd ${HLSL_${target}_OUTPUTDIRECTORY}/${shaderFilename}.pdb ${shader}
         MAIN_DEPENDENCY ${shader}
         COMMENT "HLSL ${shader}"
         WORKING_DIRECTORY ${HLSL_${target}_WORKDIRECTORY}
         VERBATIM)
   endforeach()
endmacro()

endScript(hlsl)