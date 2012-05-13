
# (ADD_PCH_RULE  _header_filename _src_list)
# Version 7/26/2010 4:55pm
#
# use this macro before "add_executable"
#
# _header_filename
#	header to make a .gch
#
# _src_list 
#   the variable name (do not use ${..}) which contains a
#     a list of sources (a.cpp b.cpp c.cpp ...)
#  This macro will append a header file to it, then this src_list can be used in
#	"add_executable..."
#
#
# Now a .gch file should be generated and gcc should use it. 
#       	(add -Winvalid-pch to the cpp flags to verify)
#
# make clean should delete the pch file
#
# example : ADD_PCH_RULE(headers.h myprog_SRCS)
MACRO (ADD_PCH_RULE _header_filename _src_list _cflag_list)
	SET(_gch_filename "${_header_filename}.gch")
	LIST(APPEND ${_src_list} ${_gch_filename})
	SET (_args ${CMAKE_CXX_FLAGS})
	LIST(APPEND ${_cflag_list} -include ${_header_filename} -Winvalid-pch)
	LIST(APPEND _args -c ${_header_filename} -o ${_gch_filename})
	GET_DIRECTORY_PROPERTY(DIRINC INCLUDE_DIRECTORIES)
	STRING(TOUPPER ${CMAKE_BUILD_TYPE} BUILDTYPE)
	LIST(APPEND _args ${CMAKE_CXX_FLAGS_${BUILDTYPE}})
	foreach (_inc ${DIRINC})
		LIST(APPEND _args "-I" ${_inc})
	endforeach(_inc ${DIRINC})
	GET_DIRECTORY_PROPERTY(DIRDEF COMPILE_DEFINITIONS)
	foreach (_def ${DIRDEF})
		STRING(REPLACE "\"" "\\\"" _def "${_def}" )
		LIST(APPEND _args -D${_def})
	endforeach(_def ${DIRDEF})
	SEPARATE_ARGUMENTS(_args)
	add_custom_command(OUTPUT ${_gch_filename}
		   COMMAND rm -f ${_gch_filename}
		   COMMAND ${CMAKE_CXX_COMPILER} ${CMAKE_CXX_COMPILER_ARG1} -x c++-header ${_args}
			    DEPENDS ${_header_filename})
ENDMACRO(ADD_PCH_RULE _header_filename _src_list)
