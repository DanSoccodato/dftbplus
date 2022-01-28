set(
  sources-fpp
  "ddcosmo_core.F90"
  "ddcosmo_solver.F90"
)

set(fyppdefs)

if(WITH_SP)
  list(APPEND fyppdefs -DSP)
endif()

set(sources-fpp-f90)
foreach(fppsrc IN LISTS sources-fpp)
  string(REGEX REPLACE "\\.F90" ".f90" f90src ${fppsrc})
  add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${f90src}
    COMMAND ${FYPP} ${fyppdefs} ${CMAKE_CURRENT_SOURCE_DIR}/${fppsrc}
      ${CMAKE_CURRENT_BINARY_DIR}/${f90src}
    MAIN_DEPENDENCY ${CMAKE_CURRENT_SOURCE_DIR}/${fppsrc}
    VERBATIM)
  list(APPEND sources-fpp-f90 ${CMAKE_CURRENT_BINARY_DIR}/${f90src})
endforeach()

add_library(
  "ddcosmo_objlib"
  OBJECT
  ${sources-fpp-f90}
)

set_target_properties(
  "ddcosmo_objlib"
  PROPERTIES
  Fortran_MODULE_DIRECTORY "${CMAKE_CURRENT_BINARY_DIR}/include"
)
set_target_properties(
  "ddcosmo_objlib"
  PROPERTIES
  POSITION_INDEPENDENT_CODE "${BUILD_SHARED_LIBS}"
)
target_include_directories(
  "ddcosmo_objlib"
  PUBLIC "${CMAKE_CURRENT_BINARY_DIR}/include"
)
if(WITH_OMP)
  target_link_libraries(
    "ddcosmo_objlib"
    PUBLIC OpenMP::OpenMP_Fortran
  )
endif()
