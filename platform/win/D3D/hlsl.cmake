startScript(hlsl)
# Provides core HLSL functions

include(${CMGym_DIR}/scripts/fileops.cmake)

set(HLSL_SHADER_GLOBAL_MODEL_MAJOR "5" CACHE STRING "The major version of hlsl shader model")
set(HLSL_SHADER_GLOBAL_MODEL_MINOR "1" CACHE STRING "The minor version of hlsl shader model")
set(HLSL_SHADER_GLOBAL_OPTIMIZATION "2" CACHE STRING "The optimization level of compiled hlsl shaders")
set(HLSL_SHADER_GLOBAL_WORK_DIRECTORY "" CACHE STRING "The default working directory of shaders")
set(HLSL_SHADER_GLOBAL_OUTPUT_DIRECTORY "shaders" CACHE STRING "The default output directory of compiled shaders")
set(HLSL_SHADER_GLOBAL_COPY_DIRECTORY "shaders" CACHE STRING "The default output directory to copy shaders resources to")
set(HLSL_SHADER_GLOBAL_COMPILER "fxc.exe" CACHE STRING "The hlsl compiler to use")

# Known shader types
set(HLSL_TYPE_VERTEX "vs" CACHE INTERNAL STRING) # Vertex
set(HLSL_TYPE_PIXEL "ps" CACHE INTERNAL STRING) # Pixel
set(HLSL_TYPE_COMPUTE "cs" CACHE INTERNAL STRING) # Compute
set(HLSL_TYPE_HULL "hs" CACHE INTERNAL STRING) # Hull
set(HLSL_TYPE_DOMAIN "ds" CACHE INTERNAL STRING) # Domain
set(HLSL_TYPE_GEOMETRY "gs" CACHE INTERNAL STRING) # Geometry
set(HLSL_TYPE_HEADER "lib" CACHE INTERNAL STRING) # Header

macro(defineShaders target type shaders #[[strictlyFormatted]])
   # Defaults to global
   set(HLSL_${target}_SHADER_MODEL "${HLSL_SHADER_GLOBAL_MODEL_MAJOR}_${HLSL_SHADER_GLOBAL_MODEL_MINOR}" CACHE STRING "The shader model used for target ${target}")
   set(HLSL_${target}_WORKDIRECTORY "${HLSL_SHADER_GLOBAL_WORK_DIRECTORY}" CACHE STRING "The working directory for target ${target}")
   set(HLSL_${target}_OUTPUTDIRECTORY "${HLSL_SHADER_GLOBAL_OUTPUT_DIRECTORY}" CACHE STRING "The output directory for compiled shaders of target ${target}")
   set(HLSL_${target}_COPYDIRECTORY "${HLSL_SHADER_GLOBAL_OUTPUT_DIRECTORY}" CACHE STRING "The output directory to copy shader resources to for target ${target}")

   # Shorthands
   set(trueOutputDir "$<TARGET_FILE_DIR:${target}>/${HLSL_${target}_OUTPUTDIRECTORY}")
   set(trueCopyDir "$<TARGET_FILE_DIR:${target}>/${HLSL_${target}_COPYDIRECTORY}")
   set(workDir ${HLSL_${target}_WORKDIRECTORY})

   # Do not compile if strictly formatted (i.e. hlsli)
   set(compileBatch 1)
   if(${ARGC} GREATER 3)
       if(${ARGV3})
          set(compileBatch 0)
       endif()
   endif()

   # Compiled shaders
   foreach(shader ${shaders})
      getPureFilename(${shader} shaderFilename)
      string(REPLACE "${HLSL_${target}_WORKDIRECTORY}" "" shaderRelFile "${shader}")
      getDir(${shaderRelFile} shaderRel)
      # Soft link this shader
      set_property(
            DIRECTORY
            APPEND
            PROPERTY CMAKE_CONFIGURE_DEPENDS "${workDir}/${shaderRelFile}")
      # Formatted
      if(NOT HLSL_${target}_COPYDIRECTORY STREQUAL "")
         add_custom_command(TARGET ${target}
            POST_BUILD
            COMMAND ${CMAKE_COMMAND} 
            ARGS -E copy_if_different "${workDir}/${shaderRelFile}" "${trueCopyDir}/${shaderRelFile}"
            MAIN_DEPENDENCY ${shader}
            COMMENT "HLSL COPY ${shader}"
            WORKING_DIRECTORY ${workDir}
            VERBATIM)
      endif()
      # Compiled
      if(NOT HLSL_${target}_OUTPUTDIRECTORY STREQUAL "" AND compileBatch)
         add_custom_command(TARGET ${target}
            COMMAND ${HLSL_SHADER_GLOBAL_COMPILER} /nologo /E main /T ${type}_${HLSL_${target}_SHADER_MODEL} $<IF:$<CONFIG:DEBUG>,/Od,/O${HLSL_SHADER_GLOBAL_OPTIMIZATION}> /Zi /Fo ${trueOutputDir}/${shaderRel}/${shaderFilename}.cso ${workDir}/${shaderRelFile}
            MAIN_DEPENDENCY ${shader}
            COMMENT "HLSL COMPILE ${shader}"
            WORKING_DIRECTORY ${workDir}
            VERBATIM)
      endif()
   endforeach()
endmacro()

endScript(hlsl)