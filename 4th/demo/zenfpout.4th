\ ******************  DEMONSTRATION  ******************

include lib/zenfloat.4th
include lib/zenans.4th
include lib/fpout.4th
include lib/fpin.4th

CR .( Loading demo words... ) CR
CR .( TEST1  formatted, n decimal places )
CR .( TEST2  compact & right-justified )
CR .( TEST3  display FS. )
CR .( TEST4  display F. )
CR .( TEST5  display G. )
CR .( TEST6  display 8087 non-numbers ) CR
CR .( 'n PLACES' sets decimal places for TEST1. )
CR .( SET-PRECISION sets maximum significant )
CR .( digits displayable. )
CR CR

20 FLOATS ARRAY f-array

: init ( r n -- )  >R  S>FLOAT  R> FLOATS f-array + F! ;

S" 1.23456E-16"  0 init
S" 1.23456E-11"  1 init
S" 1.23456E-7"   2 init
S" 1.23456E-6"   3 init
S" 1.23456E-5"   4 init
S" 1.23456E-4"   5 init
S" 1.23456E-3"   6 init
S" 1.23456E-2"   7 init
S" 1.23456E-1"   8 init
S" 0.E0"         9 init
S" 1.23456E+0"   10 init
S" 1.23456E+1"   11 init
S" 1.23456E+2"   12 init
S" 1.23456E+3"   13 init
S" 1.23456E+4"   14 init
S" 1.23456E+5"   15 init
S" 1.23456E+6"   16 init
S" 1.23456E+7"   17 init
S" 1.23456E+11"  18 init
S" 1.23456E+16"  19 init

: do-it  ( xt -- )
  ( #numbers) 20 0 DO
    f-array ( FALIGNED) I FLOATS +
    OVER >R  F@  CR  R> EXECUTE
  LOOP DROP ;

( 2VARIABLE) 2 ARRAY (dw)
: d.w  ( -- dec.places width )  (dw) 2@ ;
: PLACES ( places -- ) d.w SWAP DROP (dw) 2! ;
: PWIDTH  ( width -- )  d.w DROP SWAP (dw) 2! ;

5 PLACES  19 PWIDTH

: (t1)  ( r -- )
  FDUP d.w FS.R  FDUP d.w F.R  FDUP d.w G.R  d.w FE.R ;

: TEST1  ( -- )
  CR ." TEST1   right-justified, formatted ("
  d.w DROP 0 .R ."  decimal places)" CR
  ['] (t1) do-it  CR ;

: (t2)  ( r -- )
  FDUP -1 d.w NIP FS.R  FDUP -1 d.w NIP F.R
  FDUP -1 d.w NIP G.R        -1 d.w NIP FE.R ;

: TEST2  ( -- )
  CR ." TEST2   right-justified, compact" CR
  ['] (t2) do-it  CR ;

: TEST3  ( -- )
  CR ." TEST3   FS."
  CR ['] FS. do-it  CR ;

: TEST4  ( -- )
  CR ." TEST4   F."
  CR ['] F. do-it  CR ;

: TEST5  ( -- )
  CR ." TEST5   G."
  CR ['] G. do-it  CR ;

: TEST6  ( -- )
  PRECISION >R  1 SET-PRECISION
  CR ." TEST6   8087 non-numbers  PRECISION = 1" CR
  CR 1 S>F 0 S>F F/  FDUP G.
  CR FNEGATE              G.
  CR 0 S>F 0 S>F F/  FDUP G.
  CR FNEGATE              G.
  CR
  R> SET-PRECISION ;

: anykey ( -- )
  cr ." Press ENTER" refill drop
;

: TEST0
  CR ." TEST0   Show REPRESENT bug" CR
  S" 9.9e"  2DUP CR TYPE  ."   0 0 f.r "
  S>FLOAT 0 0 F.R  ."   {should display  10. }" CR ;

6 set-precision

 test0 anykey
 test1 anykey 
 test2 anykey
 test3 anykey
 test4 anykey
 test5 anykey

