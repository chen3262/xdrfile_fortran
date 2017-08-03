! 2017 Modefied by Si-Han Chen <chen.3262@osu.edu>
! Original XDR Fortran Interface Example Program is developed by James W. Barnett
! See https://github.com/wesbarnett/libgmxfort

program read_trr_prog

    use, intrinsic :: iso_c_binding, only: C_NULL_CHAR, C_PTR, c_f_pointer
    use trr

    implicit none
    character (len=1024) :: fntemp, filename
    real, allocatable :: pos(:,:), vel(:,:), force(:,:)
    integer :: NATOMS, STEP, STAT, i
    real :: box(3,3), lambda, time, box_trans(3,3)
    type(C_PTR) :: xd_c
    type(xdrfile), pointer :: xd
    logical :: ex

    ! Set the file name for C.
    call getarg(1,fntemp)
    filename = trim(fntemp)//C_NULL_CHAR

    inquire(file=trim(filename),exist=ex)

    if (ex .eqv. .false.) then
        write(0,*)
        write(0,'(a)') " Error: "//trim(filename)//" does not exist."
        write(0,*)
        stop
    end if

    STAT = read_trr_natoms(filename,NATOMS)
    allocate(pos(3,NATOMS))
    allocate(vel(3,NATOMS))
    allocate(force(3,NATOMS))

    ! Open the file for reading. Convert C pointer to Fortran pointer.
    xd_c = xdrfile_open(filename,"r")
    call c_f_pointer(xd_c,xd)

    STAT = read_trr(xd,NATOMS,STEP,time,lambda,box_trans,pos,vel,force)

    do while ( STAT == 0 )

        ! C is row-major, whereas Fortran is column major. Hence the following.
        box = transpose(box_trans)

        ! Just an example to show what was read in (Modify this part with your own fortran code)
        write(*,'(a,f12.6,a,i0)') " Time (ps): ", time, "  Step: ", STEP
        write(*,'(a,f12.6,a,i0)') " Lambda: ", lambda, "  No. Atoms: ", NATOMS

        do i=1,NATOMS
        write(*,'(3f8.3,3f8.4,3f8.4)') pos(:,i), vel(:,i), force(:,i)
        end do
        ! This is the same order as found in the GRO format fyi
        write(*,'(3f9.5)') box(1,1), box(2,2), box(3,3)

        STAT = read_trr(xd,NATOMS,STEP,time,lambda,box_trans,pos,vel,force)

    end do

    STAT = xdrfile_close(xd)
    deallocate(pos)
    deallocate(vel)
    deallocate(force)

end program read_trr_prog
