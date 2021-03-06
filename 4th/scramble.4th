\ Based on a program by Ulrich Hoffmann, Michael Kalus

include lib/choose.4th

: c><                                  ( c-addr1 c-addr2 -- ) \ character exchange
  2dup c@ ( c-addr1 c-addr2 c-addr-1 c2 )
  swap c@ ( c-addr1 c-addr2 c2 c1 )
  rot c! ( c-addr1 c2 )
  swap c! ;

: cshuffle                             ( c-addr n -- ) \ shuffle Durstenfeld/Knuth
  BEGIN 
    dup if dup then
  WHILE ( c-addr i )
    2dup 1- chars + >r
    2dup choose chars + r> c><
    1-
  REPEAT drop ;

: scramble-word2                       ( c-addr len -- ) \ some case handling included.
  dup 4 < IF 2drop exit THEN
  dup 4 = IF over char+ dup char+ c>< 2drop exit THEN
  2 - swap char+ swap cshuffle ;

: scramble                             ( -- )
  ." Enter a sentence: "
  refill drop cr
  BEGIN
    bl parse-word dup
  WHILE ( c-addr len )
   2dup scramble-word2 type space
  REPEAT
  2drop cr ;

scramble