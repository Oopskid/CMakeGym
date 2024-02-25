startScript(win7)

set(CM_USESYMLNK 1 CACHE BOOL "Prefer symbolic links over direct copies")

if(CM_USESYMLNK)
   # Provides the command to copy a source directory fully to a destination
   macro(cmdCopyLargeDir destination source)
      set(cmd ${CMAKE_COMMAND} ARGS -E create_symlink ${source} ${destination})
   endmacro()
else()
   macro(cmdCopyLargeDir destination source)
      set(cmd ${CMAKE_COMMAND} ARGS -E copy_directory_if_different ${source} ${destination})
   endmacro()
endif()

endScript(win7)