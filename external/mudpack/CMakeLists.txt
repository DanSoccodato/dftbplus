if(WITH_SP)
  set(sources-f77
    mud3.f
    muh3.f
    mud3ln.f
    mud3pn.f
    mud3sp.f
    mudcom.f)
else()
  set(sources-f77
    dmud3.f
    dmuh3.f
    dmud3ln.f
    dmud3pn.f
    dmud3sp.f
    dmudcom.f)
endif()

add_library(mudpack ${sources-f77})
if(WITH_OMP)
  target_link_libraries(mudpack PUBLIC OpenMP::OpenMP_Fortran)
endif()

if(WITH_API OR BUILD_SHARED_LIBS)
  install(TARGETS mudpack DESTINATION "${CMAKE_INSTALL_LIBDIR}" EXPORT dftbplus-targets)
endif()

list(APPEND PKG_CONFIG_LIBS mudpack)
set(PKG_CONFIG_LIBS "${PKG_CONFIG_LIBS}" PARENT_SCOPE)
