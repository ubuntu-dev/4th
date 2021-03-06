\ EXPOUT.F
\
\ Simple exponential output.
\
\ Common or separate floating-point stack.
\
\ Does not support NAN/INF, negative-zero etc.

\ Floating-point pictured numeric output operators


[UNDEFINED] FE.R  [IF]
[UNDEFINED] SIGN. [IF] include lib/fpdot.4th [THEN]

\ Note: If only one of scientific or engineering output
\ is required then RSCALE RSTEP may be hard-coded and
\ the support code removed.

 1 VALUE RSCALE
10 VALUE RSTEP

\ Normalize to range 1.0 <= r < STEPSIZE
: FNORM ( r1 -- |r2| sign exp )
  FDUP F0< >R  FABS
  FDUP F0= 0=
  0  BEGIN  >R WHILE
    FDUP RSTEP S>F F< 0= IF
      RSTEP S>F F/  RSCALE
    ELSE
      FDUP 1 S>F F<
      IF  RSTEP S>F F*  RSCALE NEGATE  ELSE  0 THEN
    THEN  DUP R> +
  REPEAT  R> R> SWAP ;

\ Convert real number r to string c-addr u in exponential
\ notation with n places right of the decimal point.
: (E.) ( r n scale step -- c-addr u )
  TO RSTEP TO RSCALE 0 MAX >R
  FNORM R> SWAP >R >R  IF FNEGATE THEN
  R@ 0 ?DO 10 S>F F* LOOP  FROUND ( make integer)
  FDUP FABS R@ 0 ?DO 10 S>F F/ LOOP  RSTEP S>F F< 0= IF
  ( overflow) RSTEP S>F F/  R> R> RSCALE + >R >R  THEN
  <#.  R>  R>  DUP ABS # #S DROP
  0< IF [CHAR] - ELSE [CHAR] + THEN  HOLD  [CHAR] E HOLD
  >R  FDUP F0< ( sign)  R> SWAP >R >R
  FABS  R> 0 ?DO #. LOOP  [CHAR] . HOLD
  \ or conditionally output decimal point
  \ FABS  R@ 0 ?DO #. LOOP  R> IF  [CHAR] . HOLD  THEN
  #S.  R> SIGN.  #>. ;

\ Convert real number r to string c-addr u in scientific
\ notation with n places right of the decimal point.
: (FS.) ( r n -- c-addr u )  1 10 (E.) ;

\ Display real number r in scientific notation right-
\ justified in a field width u with n places right of
\ the decimal point.
: FS.R ( r n u -- )  >R (FS.) R> OVER - SPACES TYPE ;

\ Convert real number r to string c-addr u in engineering
\ notation with n places right of the decimal point.
: (FE.) ( r n -- c-addr u )  3 1000 (E.) ;

\ Display real number r in engineering notation right-
\ justified in a field width u with n places right of
\ the decimal point.
: FE.R ( r n u -- )  >R (FE.) R> OVER - SPACES TYPE ;
[THEN]
