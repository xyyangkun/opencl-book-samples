add_executable( Rotate_1088 Rotate.cpp )
target_link_libraries( Rotate_1088 ${OPENCL_LIBRARIES} )

configure_file(Rotate.cl ${CMAKE_CURRENT_BINARY_DIR}/Rotate.cl COPYONLY)
