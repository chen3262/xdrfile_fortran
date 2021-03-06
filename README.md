# xdrfile_fortran

This is a Fortran code to read [GROMACS](http://www.gromacs.org/) trajectory files (.trr). It uses a fortran module, ISO_C_BINDING, to allow the Fortran program to access the C/C++ XTC Library. This modified code is based on the original [XDR Fortran Interface](https://gist.github.com/wesbarnett/9728818) developed by James W. Barnett, which reads compressed trajectory files (.xtc). This code requires the [XTC Libray](http://www.gromacs.org/Developer_Zone/Programming_Guide/XTC_Library) installed on the local machine.

## Requirements
[xdrfile](http://www.gromacs.org/Developer_Zone/Programming_Guide/XTC_Library)>=1.1.4 is required.

## Compilation

After compiling the xdrfile-1.1.4 library on the local machine, cd into this repository. Then:

```bash
gfortran trr-interface.f90 readtrr.f90 -o readtrr.exe -I "path to xdrfile header files" -L "path to xdrfile library" -lxdrfile
```

## Testing

To test your build, do:

```bash
./readtrr.exe 10frames.trr
```

This sample code will frame-by-frame print positions, velocities, and forces of all the atoms in the 10frames.trr on the screen.

## Usage

The sample code servse as a template, where the user can add more features according to the purpose of analysis.
