\ 4tH library - DC tutor - Copyright 2003,2014 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/boxes.4th                  \ for BOX
include lib/ansfacil.4th               \ for MS
include lib/banners.4th                \ for BANNER
include lib/stmstack.4th               \ for >S, S>
include lib/info.4th                   \ for INFO

defer .stack                           \ the "explain" routine
defer NotFound                         \ how to act on unknown word
                                       \ simply print offending word
(error) value dictionary               \ Define dictionary
1000    value (delay)

: (.dont) 2drop ;
: .number dup dup abs <# #s sign #> ;
: .box .number small box ;
                                       \ this is a modified version of .S
: (.stack)
  >s cr depth dup 0> if  dup
    begin  dup while rot .box >r  1- repeat drop dup
    begin  dup while r> -rot 1- repeat drop
  then drop s> banner cr (delay) ms ;
                                       \ this is a modified INTERPRET
: interpret                            ( --)
  begin                                ( --)
    bl parse-word dup                  ( a n f)
  while
    dictionary 2 string-key row        ( a n x f)
    if                                 ( a n x)
      nip nip cell+ @c execute         ( --)
    else                               ( a n)
      drop 2dup number error?          ( a n n2 f)
      if drop NotFound else nip nip .number .stack then
    then
  repeat                               ( --)
  drop drop                            ( --)
;

\ In this section the exceptions are defined
\ and several routines that handle them

1 constant #UndefName
2 constant #BadVariable

8 constant #variables
#variables array variables

: variable?                            \ is it a valid variable?
  dup #variables 1- invert and         ( n f)
  if #BadVariable throw else cells variables + then
;

\ This is the built-in glossary

offset info-dc
  TAG info-dc "!"
    c" !       CORE                           ( n x ---)" 10 c,
    c" Stores n in the variable at address x." 10 c,
    0 c,

  TAG info-dc "("
    c" (       CORE|FILE                      ( ---)" 10 c,
    c" Syntax: (<space><string>)" 10 c,
    c" Ignore a comment that will be delimited by a right parenthesis." 10 c,
    c" May occur inside or outside a colon-definition. A blank after the" 10 c,
    c" leading parenthesis is required." 10 c,
    0 c,

  TAG info-dc "*"
    c" *       CORE                           ( n1 n2 --- n3)" 10 c,
    c" Leave the product n3 of two numbers n1 and n2." 10 c,
    0 c,

  TAG info-dc "/"
    c" /       CORE                           ( n1 n2 --- n3)" 10 c,
    c" Leaves the quotient n3 of n1/n2." 10 c,
    0 c,

  TAG info-dc "*/"
    c" */      CORE                           ( n1 n2 n3 --- n4)" 10 c,
    c" Leave the ratio n4 = n1*n2/n3." 10 c,
    0 c,

  TAG info-dc "*/mod"
    c" */MOD   CORE                           ( n1 n2 n3 --- n4 n5)" 10 c,
    c" Leave the quotient n5 and remainder n4 of the operation n1*n2/n3."  10 c,
    0 c,

  TAG info-dc "+"
    c" +       CORE                           ( n1 n2 --- n3)" 10 c,
    c" Leave the sum n3 of n1+n2." 10 c,
    0 c,

  TAG info-dc "+!"
    c" +!      CORE                           ( n x ---)" 10 c,
    c" Add n to the value in variable at address x." 10 c,
    0 c,

  TAG info-dc "-"
    c" -       CORE                           ( n1 n2 --- n3)" 10 c,
    c" Leave the difference of n1 - n2 in n3." 10 c,
    0 c,

  TAG info-dc "."
    c" .       CORE                           ( n ---)" 10 c,
    c" Print a number to the current output device, converted according" 10 c,
    c" to the numeric BASE. A trailing blank follows." 10 c,
    0 c,

  TAG info-dc ".R"
    c" .       CORE EXT                       ( n1 n2 ---)" 10 c,
    c" Print the number n1 right aligned in a field whose width is n2 to" 10 c,
    c" the current output device. No following blank is printed." 10 c,
    0 c,

  TAG info-dc ".("
    c" .(      CORE EXT                       ( ---)" 10 c,
    c" Syntax: .(<space><string>)" 10 c,
    c" Compiles string in the String Segment with an execution procedure" 10 c,
    c" to transmit the string to the selected output device." 10 c,
    0 c,

  TAG info-dc "drop"
    c" DROP    CORE                           ( n ---)" 10 c,
    c" Drop the number from the stack." 10 c,
    0 c,

  TAG info-dc "dup"
    c" DUP     CORE                           ( n --- n n)" 10 c,
    c" Duplicate the value on the stack." 10 c,
    0 c,

  TAG info-dc "rot" 
    c" ROT     CORE                           ( n1 n2 n3 --- n2 n3 n1)" 10 c,
    c" Rotate the top three values on the stack, bringing the third to" 10 c,
    c" the top." 10 c,
    0 c,

  TAG info-dc "swap"
    c" SWAP    CORE                           ( n1 n2 --- n2 n1)" 10 c,
    c" Exchange the top two values on the stack." 10 c,
    0 c,

  TAG info-dc "/mod"
    c" /MOD    CORE                          ( n1 n2 --- n3 n4)" 10 c,
    c" Leave the remainder n3 and quotient n4 of n1/n2." 10 c,
    0 c,

  TAG info-dc "over"
    c" OVER    CORE                          ( n1 n2 --- n1 n2 n1)" 10 c,
    c" Copy the second stack value to the top of the stack." 10 c,
    0 c,

  TAG info-dc "@"
    c" @       CORE                          ( x --- n)" 10 c,
    c" Leave the contents n of the variable at address x on the stack." 10 c,
    0 c,

  TAG info-dc "?"
    c" ?       TOOLS                         ( x ---)" 10 c,
    c" Print the value contained in the variable at address x in free" 10 c,
    c" format according to the current BASE." 10 c,
    0 c,

  TAG info-dc "mod"
    c" MOD     CORE                          ( n1 n2 --- n3)" 10 c,
    c" Leave the remainder of n1/n2 with the same sign as n1 in n3." 10 c,
    0 c,

  TAG info-dc "abs"
    c" ABS     CORE                          ( n1 --- n2)" 10 c,
    c" Leave the absolute value of n1 as n2." 10 c,
    0 c,

  TAG info-dc "negate"
    c" NEGATE  CORE                          (  n1 --- -n1)" 10 c,
    c" Leave n1 negated (two's complement)." 10 c,
    0 c,

  TAG info-dc "char"
    c" CHAR    CORE                          ( --- c)" 10 c,
    c" Syntax: CHAR<space><char>" 10 c,
    c" Compiles the ASCII-value of <char> as a literal. At runtime the" 10 c,
    c" value is thrown on the stack." 10 c,
    0 c,

  TAG info-dc "time"
    c" TIME    4TH                           ( --- n)" 10 c,
    c" Returns the number of seconds since January 1st, 1970." 10 c,
    0 c,

  TAG info-dc "variable"
    c" A. B. C. D. E. F. G. H.               ( --- x)" 10 c,
    c" When <name> is executed, it will push the address <x> on" 10 c,
    c" the stack, so that a fetch or store may access this location." 10 c,
    0 c,

  TAG info-dc "invert"
    c" INVERT  CORE                          ( n1 --- n2)" 10 c,
    c" Leave n1's binary complement as n2" 10 c,
    0 c,

  TAG info-dc "min"
    c" MIN     CORE                          ( n1 n2 --- n3)" 10 c,
    c" Leave n3 as the smaller of the two numbers n1 and n2." 10 c,
    0 c,

  TAG info-dc "max"
    c" MAX     CORE                          ( n1 n2 --- n3)" 10 c,
    c" Leave n3 as the greater of the two numbers n1 and n2." 10 c,
    0 c,

  TAG info-dc "or"
    c" OR      CORE                          ( n1 n2 --- n3)" 10 c,
    c" Leave the bitwise logical OR in n3 of the numbers n1 and n2." 10 c,
    0 c,

  TAG info-dc "xor"
    c" XOR     CORE                          ( n1 n2 --- n3)" 10 c,
    c" Leave the bitwise logical XOR of n1 XOR n2 as n3." 10 c,
    0 c,

  TAG info-dc "and"
    c" AND     CORE                          ( n1 n2 --- n3)" 10 c,
    c" Leave the bitwise logical AND of n1 AND n2 as n3." 10 c,
    0 c,

  TAG info-dc "disable"
    c" DISABLE DC                            ( --- -f)" 10 c,
    c" Leaves a false flag for the next word." 10 c,
    0 c,

  TAG info-dc "enable"
    c" ENABLE  DC                            ( --- f)" 10 c,
    c" Leaves a true flag for the next word." 10 c,
    0 c,

  TAG info-dc "explain"
    c" EXPLAIN DC                            ( f ---)" 10 c,
    c" Enables or disables showing extended information on the" 10 c,
    c" words executed and their stack effects. Takes a flag from" 10 c,
    c" the stack." 10 c,
    0 c,

  TAG info-dc "delay"
    c" DELAY   DC                            ( n ---)" 10 c,
    c" Sets the number of seconds execution halts while showing" 10 c,
    c" extended information on words executing and their stack" 10 c,
    c" effects. Minimal 0 seconds, maximal 60 seconds." 10 c,
    0 c,

  TAG info-dc "help"
    c" HELP    DC                            ( ---)" 10 c,
    c" Shows the help page." 10 c,
    0 c,

  TAG info-dc "th"
    c" TH      COMUS                         ( x1 n --- x2)" 10 c,
    c" Used to reference an element in an array of integers. Will return" 10 c,
    c" the address of the n-th element in array x1 as x2. An alias for +." 10 c,
    0 c,

  TAG info-dc "quit"
    c" QUIT    CORE                          ( ---)" 10 c,
    c" Sets the program counter to the end of the program. Effectively" 10 c,
    c" quits execution. BYE and Q are aliases." 10 c,
    0 c,

  TAG info-dc "lshift"
    c" LSHIFT  CORE                          ( n1 n2 --- n3)" 10 c,
    c" Performs a logical bit shift on n1. Specifically, SHIFT shifts a" 10 c,
    c" number a number of bits, specified in n2, using a logical" 10 c,
    c" register shift." 10 c,
    0 c,

  TAG info-dc "rshift"
    c" RSHIFT  CORE                          ( n1 n2 --- n3 )" 10 c,
    c" Perform a logical right shift of n2 bit-places on n1, giving n2." 10 c,
    c" Put zeroes into the most significant bits vacated by the shift" 10 c,
    0 c,

  TAG info-dc "1+"
    c" 1+      CORE                          ( n --- n+1)" 10 c,
    c" Increment n by 1." 10 c,
    0 c,

  TAG info-dc "1-"
    c" 1-      CORE                          ( n --- n-1" 10 c,
    c" Decrement n by 1." 10 c,
    0 c,

  TAG info-dc "2*"
    c" 2*      CORE                          ( n --- n*2)" 10 c,
    c" Multiply n by 2. Performs a left shift." 10 c,
    0 c,

  TAG info-dc "2/"
    c" 2/      CORE                          ( n --- n/2)" 10 c,
    c" Divide n by 2. Performs a right shift." 10 c,
    0 c,

  TAG info-dc "space"
    c" SPACE   CORE                          ( ---)" 10 c,
    c" Transmit an ASCII blank to the current output device." 10 c,
    0 c,

  TAG info-dc "spaces"
    c" SPACES  CORE                          ( n ---)" 10 c,
    c" Transmit n ASCII blanks to the current output device." 10 c,
    0 c,

  TAG info-dc "cr"
    c" CR      CORE                          ( ---)" 10 c,
    c" Transmit a carriage return to the selected output-device. The" 10 c,
    c" actual sequence sent is OS- and stream-dependant." 10 c,
    0 c,

  TAG info-dc "depth"
    c" DEPTH   CORE                          ( --- n)" 10 c,
    c" Returns the number of items on the stack in n, before DEPTH was" 10 c,
    c" executed." 10 c,
    0 c,

  TAG info-dc "emit"
    c" EMIT    CORE                          ( c ---)" 10 c,
    c" Transmit the ASCII character with code n to the selected output" 10 c,
    c" device." 10 c,
    0 c,

  TAG info-dc "base!"
    c" BASE!   DC                            ( n ---)" 10 c,
    c" Sets a variable containing the current number BASE used for input" 10 c,
    c" and output. Minimal 2, maximal 36." 10 c,
    0 c,

  TAG info-dc "decimal"
    c" DECIMAL CORE                          ( ---)" 10 c,
    c" Set the numeric conversion BASE for decimal output at runtime." 10 c,
    0 c,

  TAG info-dc "hex"
    c" HEX     CORE EXT                      ( ---)" 10 c,
    c" Set the numeric conversion BASE for hexadecimal output at" 10 c,
    c" runtime." 10 c,
    0 c,

  TAG info-dc "octal"
    c" OCTAL   DC                            ( ---)" 10 c,
    c" Set the numeric conversion BASE for octal output at runtime." 10 c,
    0 c,

  TAG info-dc "binary"
    c" BINARY  DC                            ( ---)" 10 c,
    c" Set the numeric conversion BASE for binary output at runtime." 10 c,
    0 c,

  TAG info-dc "cell+"
    c" CELL+   CORE                          ( x1 --- x2)" 10 c,
    c" Add the the size of a cell in cells to x1 giving x2." 10 c,
    0 c,

  TAG info-dc "cell-"
    c" CELL-   COMUS                         ( x1 --- x2)" 10 c,
    c" Subtract the the size of a cell in cells to x1 giving x2." 10 c,
    0 c,

  TAG info-dc "cells"
    c" CELLS   CORE                          ( n --- n)" 10 c,
    c" n is the size in cells of n cells." 10 c,
    0 c,

  TAG info-dc "info"
    c" INFO    DC                            ( ---)" 10 c,
    c" Syntax: INFO<space><string>" 10 c,
    c" Shows the glossary information on <string>." 10 c,
    0 c,

create .info-dc
  ," !"       "!"        ,
  ," ("       "("        ,
  ," *"       "*"        ,
  ," /"       "/"        ,
  ," */"      "*/"       ,
  ," */mod"   "*/mod"    ,
  ," /mod"    "/mod"     ,
  ," +"       "+"        ,
  ," +!"      "+!"       ,
  ," -"       "-"        ,
  ," ."       "."        ,
  ," .r"      ".r"       ,
  ," .("      ".("       ,
  ," drop"    "drop"     ,
  ," dup"     "dup"      ,
  ," rot"     "rot"      ,
  ," swap"    "swap"     ,
  ," over"    "over"     ,
  ," @"       "@"        ,
  ," ?"       "?"        ,
  ," mod"     "mod"      ,
  ," abs"     "abs"      ,
  ," negate"  "negate"   ,
  ," char"    "char"     ,
  ," [char]"  "char"     ,
  ," time"    "time"     ,
  ," A."      "variable" ,
  ," B."      "variable" ,
  ," C."      "variable" ,
  ," D."      "variable" ,
  ," E."      "variable" ,
  ," F."      "variable" ,
  ," G."      "variable" ,
  ," H."      "variable" ,
  ," invert"  "invert"   ,
  ," min"     "min"      ,
  ," max"     "max"      ,
  ," or"      "or"       ,
  ," xor"     "xor"      ,
  ," and"     "and"      ,
  ," disable" "disable"  ,
  ," enable"  "enable"   ,
  ," explain" "explain"  ,
  ," delay"   "delay"    ,
  ," help"    "help"     ,
  ," th"      "th"       ,
  ," quit"    "quit"     ,
  ," q"       "quit"     ,
  ," bye"     "quit"     ,
  ," 1+"      "1+"       ,
  ," 1-"      "1-"       ,
  ," 2*"      "2*"       ,
  ," 2/"      "2/"       ,
  ," space"   "space"    ,
  ," spaces"  "spaces"   ,
  ," cr"      "cr"       ,
  ," depth"   "depth"    ,
  ," emit"    "emit"     ,
  ," base!"   "base!"    ,
  ," decimal" "decimal"  ,
  ," octal"   "octal"    ,
  ," binary"  "binary"   ,
  ," hex"     "hex"      ,
  ," cells"   "cells"    ,
  ," cell+"   "cell+"    ,
  ," cell-"   "cell-"    ,
  ," info"    "info"     ,
  NULL ,
does> [: info-dc ;] is info-entry bl parse rot info ;

\ Here all internal commands are listed
\ and placed inside the dictionary.
\ Checking is done by the routines above.
\ Note: there are aliases!

create explain ' (.dont) , ' (.stack) ,
does> swap 1 min 0 max cells + @c is .stack ;

: help
  ." You can get information on each and every word by entering:" cr cr
  ."   info [word]" cr cr
  ." These are the words supported by DC:" cr cr
  ." +       th       -       *       /        quit   bye   q" cr
  ." .       .r       drop    dup     rot      swap   over  A." cr
  ." B.      C.       D.      E.      F.       G.     H.    !" cr
  ." +!      @        ?       base!   decimal  octal  hex   binary" cr
  ." .(      mod      abs     negate  invert   min    max   or" cr
  ." and     xor      lshift  rshift  depth    cells  1+    cell+" cr
  ." 1-      cell-    space   spaces  2*       2/     emit  char" cr
  ." [char]  time     (       /mod    */       */mod  cr    explain" cr
  ." enable  disable  help    delay   info" cr
;

: +_      + s" +" .stack ;             \ + command
: -_      - s" -" .stack ;             \ - command
: *_      * s" *" .stack ;             \ * command
: /_      / s" /" .stack ;             \ / command
: ._      . s" ." .stack ;             \ . command
: .r_     .r s" .r" .stack ;           \ .r command
: drop_   drop s" drop" .stack ;       \ drop command
: dup_    dup s" dup" .stack ;         \ dup command
: rot_    rot s" rot" .stack ;         \ rot command
: /mod_   /mod s" /mod" .stack ;       \ /mod command
: */_     */ s" */" .stack ;           \ */ command
: */mod_  */mod s" mod" .stack ;       \ */mod command
: swap_   swap s" swap" .stack ;       \ swap command
: over_   over s" over" .stack ;       \ over command
: !_      variable? ! s" !" .stack ;   \ ! command
: +!_     variable? +! s" +!" .stack ; \ +! command
: @_      variable? @ s" @" .stack ;   \ @ command
: ?_      variable? ? s" ?" .stack ;   \ ? command
: mod_    mod s" mod" .stack ;         \ mod command
: abs_    abs s" abs" .stack ;         \ abs command
: negate_ negate s" negate" .stack ;   \ negate command
: invert_ invert s" invert" .stack ;   \ invert command
: min_    min s" min" .stack ;         \ min command
: max_    max s" max" .stack ;         \ max command
: or_     or s" or" .stack ;           \ or command
: xor_    xor s" xor" .stack ;         \ xor command
: and_    and s" and" .stack ;         \ and command
: lshift_ lshift s" lshift" .stack ;   \ lshift command
: rshift_ rshift s" rshift" .stack ;   \ rshift command
: inc     1+ s" 1+" .stack ;           \ inc command
: dec     1- s" 1-" .stack ;           \ dec command
: 2*_     2* s" 2*" .stack ;           \ 2* command
: 2/_     2/ s" 2/" .stack ;           \ 2/ command
: spaces_ spaces s" spaces" .stack ;   \ spaces command
: emit_   emit s" emit" .stack ;       \ emit command
: base!   36 min 2 max base ! s" base!" .stack ; \ base command
: decimal_ decimal s" decimal" .stack ;     \ decimal command
: hex_  hex s" hex" .stack ;           \ hex command
: octal_ octal s" octal" .stack ;      \ octal command
: binary 2 base! s" binary" .stack ;   \ binary command
: depth_ depth s" depth" .stack ;      \ depth command
: bye s" bye" .stack quit  ;           \ quit command
: dummy ;                              \ dummy command
: space_ space s" space" .stack ;      \ space command
: cr_ cr s" cr" .stack ;               \ cr command
: A. 0 s" A." .stack ;                 \ variable A
: B. 1 s" B." .stack ;                 \ variable B
: C. 2 s" C." .stack ;                 \ variable C
: D. 3 s" D." .stack ;                 \ variable D
: E. 4 s" E." .stack ;                 \ variable E
: F. 5 s" F." .stack ;                 \ variable F
: G. 6 s" G." .stack ;                 \ variable G
: H. 7 s" H." .stack ;                 \ variable H
: .(_ 41 parse type s" .(" .stack ;    \ .( command
: (_ 41 parse drop drop s" (" .stack ; \ ( command
: char_ bl parse drop c@ s" char" .stack ;  \ char command
: time_ time s" time" .stack ;         \ time command
: enable 1 ;                           \ enabling command
: disable 0 ;                          \ disabling command
: delay 0 max 60 min 1000 * to (delay) s" delay" .stack ;

create wordlist                        \ dictionary
  ," +"       ' +_       ,
  ," th"      ' +_       ,
  ," -"       ' -_       ,
  ," *"       ' *_       ,
  ," /"       ' /_       ,
  ," quit"    ' bye      ,
  ," bye"     ' bye      ,
  ," q"       ' bye      ,
  ," ."       ' ._       ,
  ," .r"      ' .r_      ,
  ," drop"    ' drop_    ,
  ," dup"     ' dup_     ,
  ," rot"     ' rot_     ,
  ," swap"    ' swap_    ,
  ," over"    ' over_    ,
  ," A."      ' A.       ,
  ," B."      ' B.       ,
  ," C."      ' C.       ,
  ," D."      ' D.       ,
  ," E."      ' E.       ,
  ," F."      ' F.       ,
  ," G."      ' G.       ,
  ," H."      ' H.       ,
  ," !"       ' !_       ,
  ," +!"      ' +!_      ,
  ," @"       ' @_       ,
  ," ?"       ' ?_       ,
  ," base!"   ' base!    ,
  ," decimal" ' decimal_ ,
  ," octal"   ' octal_   ,
  ," hex"     ' hex_     ,
  ," binary"  ' binary   ,
  ," .("      ' .(_      ,
  ," mod"     ' mod_     ,
  ," abs"     ' abs_     ,
  ," negate"  ' negate_  ,
  ," invert"  ' invert_  ,
  ," min"     ' min_     ,
  ," max"     ' max_     ,
  ," or"      ' or_      ,
  ," and"     ' and_     ,
  ," xor"     ' xor_     ,
  ," lshift"  ' lshift_  ,
  ," rshift"  ' rshift_  ,
  ," depth"   ' depth_   ,
  ," cells"   ' dummy    ,
  ," 1+"      ' inc      ,
  ," cell+"   ' inc      ,
  ," 1-"      ' dec      ,
  ," cell-"   ' dec      ,
  ," space"   ' space_   ,
  ," spaces"  ' spaces_  ,
  ," 2*"      ' 2*_      ,
  ," 2/"      ' 2/_      ,
  ," emit"    ' emit_    ,
  ," char"    ' char_    ,
  ," [char]"  ' char_    ,
  ," time"    ' time_    ,
  ," ("       ' (_       ,
  ," /mod"    ' /mod_    ,
  ," */"      ' */_      ,
  ," */mod"   ' */mod_   ,
  ," cr"      ' cr_      ,
  ," explain" ' explain  ,
  ," enable"  ' enable   ,
  ," disable" ' disable  ,
  ," help"    ' help     ,
  ," delay"   ' delay    ,
  ," info"    ' .info-dc ,
  NULL ,

\ Set up the interpreter loop
 wordlist to dictionary                \ assign dictionary
:noname #UndefName throw ; is NotFound \ standard 'abort' word

\ This is the actual DC program. It features only a
\ message handler and a interpretation-loop.
\ The rest is handled by library routines.

create Message
  ," Exception ignored"
  ," Undefined name"
  ," Bad variable"

: ShowMessage                          ( n --)
  0 max Message swap th @c count type space 
;                                      \ print error message

: dc-tutor
  s.clear enable explain
  begin
    ." OK" cr refill drop 
    ['] interpret catch dup
    if ShowMessage else drop then
  again
;

dc-tutor
