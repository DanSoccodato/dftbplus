set(curdir ${CMAKE_CURRENT_SOURCE_DIR})

if(WITH_SP)
set(sources-fpp
  ${curdir}/sp_capi.F90
  ${curdir}/dftbplus.F90
  ${curdir}/hsdapi.F90
  ${curdir}/mmapi.F90
  ${curdir}/qdepextpotgenc.F90)
else()
set(sources-fpp
  ${curdir}/capi.F90
  ${curdir}/dftbplus.F90
  ${curdir}/hsdapi.F90
  ${curdir}/mmapi.F90
  ${curdir}/qdepextpotgenc.F90)
endif()

set(ALL-SOURCES-FPP ${ALL-SOURCES-FPP} ${sources-fpp} PARENT_SCOPE)
