!--------------------------------------------------------------------------------------------------!
!  DFTB+: general package for performing fast atomistic simulations                                !
!  Copyright (C) 2006 - 2022  DFTB+ developers group                                               !
!                                                                                                  !
!  See the LICENSE file for terms of usage and distribution.                                       !
!--------------------------------------------------------------------------------------------------!

!> Reads a spline repulsive from an SK-table and returns its value and its first
!! and second derivatives.
program polyvalue
  use dftbp_common_accuracy, only : dp, lc
  use dftbp_common_globalenv, only : stdOut
  use dftbp_dftb_repulsive_polyrep, only : TPolyRepInp, TPolyRep, TPolyRep_init
  use dftbp_io_message, only : error
  implicit none

  character(lc) :: arg, fname
  logical :: homo
  type(TPolyRepInp) :: polyRepInp
  type(TPolyRep) :: polyRep
  integer :: fp, iostat, ii, npoint
  real(dp), parameter :: rstart = 0.01_dp, dr = 0.01_dp
  real(dp) :: rr, energy, dEnergy, d2Energy, rDummy

  if (command_argument_count() == 0) then
    call error("Wrong number of arguments. Use 'polyvalue -h' to obtain help.")
  end if
  call get_command_argument(1, arg)
  if (arg == "-h" .or. arg == "--help") then
    write(stdout, "(A)") &
        & "Usage: polyvalue  homo | hetero  skfile",&
        & "",&
        & "Reads an SK-file, extracts the polynomial repulsive from it and &
        &prints its value", &
        & "and the first and second derivatives up to the repulsive cutoff. &
        &Output values",&
        & "are given in atomic units with Hartree as energy unit."
    stop
  end if
  if (arg /= "homo" .and. arg /= "hetero") then
    call error("The first argument must be 'homo' or 'hetero'")
  end if
  homo = (arg == "homo")
  if (command_argument_count() /= 2) then
    call error("Missing file name. Use 'polyvalue -h' to obtain help.")
  end if
  call get_command_argument(2, fname)

  open(newunit=fp, file=fname, action="read", status="old", iostat=iostat)
  if (iostat /= 0) then
    call error("Unable to open file '" // trim(fname) // "'")
  end if

  read(fp, *)
  if (homo) then
    read(fp, *)
  end if
  read(fp, *) rDummy, polyRepInp%polyCoeffs, polyRepInp%cutoff, &
      & (rDummy, ii = 11, 20)
  close(fp)

  call TPolyRep_init(polyRep, polyRepInp)
  npoint = floor((polyRepInp%cutoff - rstart) / dr) + 1
  do ii = 0, nPoint
    rr = rStart + real(ii, dp) * dr
    call polyRep%getValue(rr, energy=energy, dEnergy=dEnergy, d2Energy=d2Energy)
    write(stdout, "(4E23.15)") rr, energy, dEnergy, d2Energy
  end do

end program polyvalue
