startLib(CMCommonIncs)
onceStrict(CMCommonIncs) # Do not recache everything

# Adds common vars and includes to the current cmake

# Common directories
set(CM_DIR_HINTLIB ${CMAKE_CURRENT_LIST_DIR}/../hints)

# Common hint imports
file(READ ${CM_DIR_HINTLIB}/codefiles.hint file)
hintdecipher(${file} "CMFT_SRC_")
file(READ ${CM_DIR_HINTLIB}/headerfiles.hint file)
hintdecipher(${file} "CMFT_HEADER_")
file(READ ${CM_DIR_HINTLIB}/compilefiles.hint file)
hintdecipher(${file} "CMFT_COMPILE_")
file(READ ${CM_DIR_HINTLIB}/libfiles.hint file)
hintdecipher(${file} "CMFT_LIB_")
file(READ ${CM_DIR_HINTLIB}/shaderfiles.hint file)
hintdecipher(${file} "CMFT_SHADER_")
file(READ ${CM_DIR_HINTLIB}/scriptfiles.hint file)
hintdecipher(${file} "CMFT_SCRIPT_")

endLib(CMCommonIncs)