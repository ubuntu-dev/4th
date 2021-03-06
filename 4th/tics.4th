\ Tiny Integer CLI Spreadsheet - Copyright 2010,2012 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/evaluate.4th               \ for EVALUATE

   6 constant #column                  \ number of columns
  12 constant /column                  \ size of column in characters
  16 constant #row                     \ number of rows
 128 constant /element                 \ maximum size of formula
true constant Multitask?               \ compile for multitasking version?

false to string?                       \ boolean to indicate string
    0 to depth'                        \ for saving stack depth

#column #row * constant #elements      \ number of elements in sheet
#elements /element * constant /elements
                                       \ size of spreadsheet in memory
/elements buffer: element              \ allocate memory for spreadsheet
  does> rot #column * rot 0 max #row 1- min + /element * + ;
                                       \ return address of element ( r c -- a)
: val element count evaluate ;         ( a -- ..)
: clear depth depth' ?do drop loop ;   ( --)
: .string parse /column min 0 parse 2drop true dup to string? ;
                                       ( c -- a n f)
: file?                                ( fam -- h f | -f)
  >r [char] " parse 2dup r> open error? dup 0= >r
  if drop ." Cannot open " type cr else nip nip then r>
;                                      \ print error or return handle
                                       \ print formula of a cell
: .line                                ( row col --)
  over over element count dup          \ copy row/column
  if                                   \ is length greater than zero?
    2>r swap . [char] a + emit ."  = " 2r> type cr
  else                                 \ print the formula, otherwise
    2drop drop drop                    \ drop all values
  then
;
                                       \ print value of a cell
: .cell                                ( .. n --)
  string? if                           \ it is a string?
    swap >r over - 0 max r> if -rot type spaces else spaces type then
    false to string?                   \ drop width and reset boolean
  else                                 \ otherwise determine stack depth
    depth 1- depth' - 0> if .r else spaces then
  then                                 \ and print the value or just spaces
;
                                       \ print the header
: .header                              ( --)
  3 spaces #column 0 do /column 1- spaces i [char] A + emit loop cr
;
                                       \ ** all formula operations **
: _+ + ;                               \ addition
: _- - ;                               \ subtraction
: _* * ;                               \ multiplication
: _/ / ;                               \ division
: _" [char] " .string ;                \ print string left aligned
: _' [char] ' .string 0= ;             \ print string right aligned
: _a 0 val ;                           \ calculate formula in column A
: _b 1 val ;                           \ calculate formula in column B
: _c 2 val ;                           \ calculate formula in column C
: _d 3 val ;                           \ calculate formula in column D
: _e 4 val ;                           \ calculate formula in column E
: _f 5 val ;                           \ calculate formula in column F
                                       \ map words to strings
create calculation
  ," +" ' _+ ,
  ," -" ' _- ,
  ," *" ' _* ,
  ," /" ' _/ ,
  ," a" ' _a ,
  ," b" ' _b ,
  ," c" ' _c ,
  ," d" ' _d ,
  ," e" ' _e ,
  ," f" ' _f ,
  ,| "| ' _" ,
  ," '" ' _' ,
  null ,
                                       \ ** spreadsheet commands **
: a 0 element ;                        \ return address of column A
: b 1 element ;                        \ return address of column B
: c 2 element ;                        \ return address of column C
: d 3 element ;                        \ return address of column D
: e 4 element ;                        \ return address of column E
: f 5 element ;                        \ return address of column F
: _= 0 parse /element 1- min rot place ;
: _? count type cr ;                   ( a --)
: _clear depth . ." items removed " 0 to depth' clear ;
: _copy >r count r> place ;            ( a1 a2 --)
: _erase 0 over place ;                ( a --)
: _move over >r _copy r> _erase ;      ( a1 a2 --)
: bye quit ;                           ( --)

Multitask? [IF]                        \ multitasking version
: _pause pause ;                       \ pause command
[THEN]
                                       \ show the spreadsheet
: show                                 ( --)
  calculation to dictionary            \ set dictionary to formula
  .header #row 0 do                    \ print header
    i 2 .r space                       \ new row, print row number
    #column 0 do depth to depth' j i val /column .cell clear loop cr
  loop                                 \ for each cell, evaluate formula
;                                      \ and calculate value
                                       \ export to tab delimited CSV
: export                               ( --)
  output file? if                      \ open file, if successful
    dup use calculation to dictionary  \ set dictionary to formula
    #row 0 do                          \ new row
      #column 0 do depth to depth' j i val 0 .cell 9 emit clear loop cr
    loop close                         \ for each cell, evaluate formula,
  then                                 \ calculate value and write to file
;
                                       \ save a TICS file
: save                                 ( --)
  output file? if                      \ open file, if successful
    dup use #row 0 do #column 0 do j i .line loop loop close
  then                                 \ write formula to file if not empty
;
                                       \ load a TICS file
: load                                 ( --)
  input file? if                       \ open file, if successful
    dup use                            \ USE file handle
    begin refill while ['] interpret catch if ." Bad formula" cr then repeat
    close                              \ evaluate commands
  then
;
                                       \ show help
: help                                 ( --)
  ." :: Commands" cr
  .|   Load sheet    : load" string"| cr
  .|   Save sheet    : save" string"| cr
  .|   Export sheet  : export" string"| cr
  ."   Show sheet    : ." cr
  ."   Clear stack   : clear" cr
  ."   Show help     : help" cr
  ."   Enter formula : <row> <column> = <formula>" cr
  ."   Copy formula  : <row> <column> <row> <column> copy" cr
  ."   Move formula  : <row> <column> <row> <column> move" cr
  ."   Erase formula : <row> <column> erase" cr
  ."   Show formula  : <row> <column> ?" cr
Multitask? [IF]
  ."   Pause TICS    : pause" cr
[THEN]
  ."   Exit TICS     : exit" cr cr
  ." :: Formula" cr
  ."   <row>         : positive integer" cr
  ."   <column>      : A, B, C etc." cr
  ."   <cell>        : <row> <column>" cr
  ."   <literal>     : any integer" cr
  ."   <primitive>   : <literal> or <cell>" cr
  ."   <operator>    : +, -, * or /" cr
  ."   <term>        : <primitive> <primitive> <operator>" cr
  ."   <expression>  : <term> <term> <operator>" cr
  .|   <string>      : " string" or ' string'| cr
  ."   <formula>     : <string> or <expression>" cr
;
                                       \ map words to strings
create wordlist
 ," ."       ' show ,
 ," a"       ' a ,
 ," b"       ' b ,
 ," c"       ' c ,
 ," d"       ' d ,
 ," e"       ' e ,
 ," f"       ' f ,
 ," ="       ' _= ,
 ," ?"       ' _? ,
 ,| save"|   ' save ,
 ,| load"|   ' load ,
 ,| export"| ' export ,
 ," help"    ' help ,
 ," clear"   ' _clear ,
 ," copy"    ' _copy ,
 ," erase"   ' _erase ,
 ," move"    ' _move ,
 ," bye"     ' bye ,
 ," exit"    ' bye ,
 ," quit"    ' bye ,
Multitask? [IF]
 ," pause"   ' _pause ,                \ special words multitasking version
[THEN]
 null ,

: tics
  begin                                \ show the prompt and get a command
    wordlist to dictionary             \ set the correct dictionary
    ." OK" cr refill drop              \ interpret and issue oops when needed
    ['] interpret catch if ." Oops " then
  again                                \ repeat command loop eternally
;

tics