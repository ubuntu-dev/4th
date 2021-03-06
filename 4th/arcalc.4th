\ FP degrees calculator - Copyright 2010 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/zenfloat.4th
include lib/zenans.4th
include lib/fpin.4th
include lib/fpout.4th
include lib/interprt.4th

: _+ f+ ;
: _- f- ;
: _* f* ;
: _/ f/ ;
: _swap 2swap ;
: _drop 2drop ;
: _over 2over ;
: _dup 2dup ;
: .deg f. ." degs" space ;
: .arcmin 60 0 f* f. ." arcmins" space ;
: .arcsec 3600 0 f* f. ." arcsecs" space ;
: deg ;
: arcmin 60 0 f/ ;
: arcsec 3600 0 f/ ;
: _.( [char] ) parse type ;
: _( [char] ) parse 2drop ;
: _cr cr ;
: _quit quit ;

: help
  ." Arithmetic operations:" cr
  ."   + - / *" cr
  ." Stack operations:" cr
  ."   DROP SWAP OVER DUP" cr
  ." Declarations:" cr
  ."   DEG ARCMIN ARCSEC" cr
  ." Display operations:" cr
  ."   .DEG .ARCMIN .ARCSEC" cr cr
  ." EXAMPLES" cr
  ." ========" cr
  ." Display a string:" cr
  ."   .( This is a string) cr" cr
  ." Convert from degrees to arcmins:" cr
  ."   90 deg .arcmin" cr
  ." Convert degrees and add arcmins:" cr
  ."   20.5 deg 125 arcmin + .arcmin" cr cr
;

create wordlist
  ," +"          ' _+ ,
  ," -"          ' _- ,
  ," *"          ' _* ,
  ," /"          ' _/ ,
  ," swap"       ' _swap ,
  ," drop"       ' _drop ,
  ," over"       ' _over ,
  ," dup"        ' _dup ,
  ," .("         ' _.( ,
  ," ("          ' _( ,
  ," cr"         ' _cr ,
  ," .deg"       ' .deg ,
  ," .arcmin"    ' .arcmin ,
  ," .arcsec"    ' .arcsec ,
  ," deg"        ' deg ,
  ," arcmin"     ' arcmin ,
  ," arcsec"     ' arcsec ,
  ," exit"       ' _quit ,
  ," quit"       ' _quit ,
  ," bye"        ' _quit ,
  ," help"       ' help ,
  NULL ,

wordlist to dictionary                 \ assign wordlist to dictionary

\ The interpreter itself
: arcalc
  begin                                \ show the prompt and get a command
    ." OK" cr refill drop              \ interpret and issue oops when needed
    ['] interpret catch if ." Oops " then
  again                                \ repeat command loop eternally
;

arcalc
