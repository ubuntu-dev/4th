\ 4tH Markov algorithm - Copyright 2011,2012 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ A Markov algorithm is a string rewriting system that uses grammar-like rules
\ to operate on strings of symbols. Markov algorithms have been shown to be
\ Turing-complete, which means that they are suitable as a general model of
\ computation and can represent any mathematical expression from its simple
\ notation. See: http://en.wikipedia.org/wiki/Markov_algorithm

[pragma] casesensitive                 \ we need case sensitive replacements

include lib/replace.4th                \ for REPLACE
include lib/interprt.4th               \ for INTERPRET
include lib/strbuf.4th                 \ for >STR-BUFFER, STR-BUFFER
                                       \ application error messages
  0 enum MKE.NOERRS                    \ no errors
    enum MKE.SYNTAX                    \ syntax error
    enum MKE.RULEFULL                  \ too many rules
    enum MKE.NOEVAL                    \ nothing to evaluate
    enum MKE.NOFNAME                   \ filename missing
constant MKE.NOFILE                    \ cannot open file

struct                                 \ structure for rules
  field: exit:                         \ terminating rule
  field: from:                         \ replace from
  field: to:                           \ replace to
end-struct /rules                      \ size of structure

 1024 constant #rules                  \ maximum number of rules
16384 constant /rules-buffer           \ maximum size of rules buffer
 4096 constant /eval-buffer            \ maximum size of evaluation buffer
    3 constant r#                      \ size of rule number display
                                       \ allocate rules array
#rules /rules * array rules does> swap /rules * + ;
                                       ( n -- x)
0 dup value top value verbose?         \ top of buffer
                                       \ verbose flag
/rules-buffer buffer: rules-buffer     \ allocate rules buffer
 /eval-buffer string  eval-buffer      \ allocate evaluation buffer

create .error                          \ error messages
  ," System failure"
  ," Ok"
  ," Syntax error"
  ," Too many rules"
  ," Nothing to evaluate"
  ," Filename missing"
  ," Cannot open file"                 ( n --)
does> swap -1 max 1+ cells + @c count type cr ;
                                       \ print message only on error
: .error-only catch dup if .error else drop then ;
                                       \ add a rule
: add-rule                             ( a1 n1 f a2 n2 n1 --)
  if                                   \ if left string length non-zero
    top #rules <                       \ if room left in rules array
    if                                 \ add strings to rules buffer
      rules-buffer >str-buffer top rules -> to: !
                               top rules -> exit: !
      rules-buffer >str-buffer top rules -> from: !
      top 1+ to top                    \ increment top of rules array
    else                               \ otherwise signal array full
      MKE.RULEFULL throw
    then
  else
    MKE.SYNTAX throw                   \ otherwise signal syntax error
  then
;
                                       \ enter Markov rules
: >rules                               ( --)
  begin
    refill
  while                                \ while not end-of-file
    tib c@
  while                                \ while not empty line
    [char] " parse-word dup            \ parse all classic rules
    [char] " parse 1- chars + c@ [char] . = swap
    [char] " parse rot add-rule        \ and add them to the array
  repeat
;
                                       \ load a command file
: load-file                            ( a n --)
  input open error?                    \ try to open file
  if
    MKE.NOFILE throw                   \ if failed, signal file error
  else                                 \ otherwise use the file handle
    dup use                            \ and read and interpret the commands
    begin refill while ['] interpret .error-only repeat
    close stdin use                    \ return control to keyboard
  then
;

: clear rules-buffer /rules-buffer str-buffer 0 to top ;
: load" [char] " parse dup if load-file else MKE.NOFNAME throw then ;
: echo" [char] " parse type cr ;       ( --)
: // 0 parse 2drop ;                   ( --)
: (add) [char] = parse rot over 0 parse rot add-rule ;
: add false (add) ;
: add-last true (add) ;
: verbose true to verbose? ;           ( --)
: silent false to verbose? ;           ( --)
: bye quit ;                           \ if verbose print evaluation buffer
: ?print verbose? if r# .r ." : " eval-buffer count type cr else drop then ;
                                       ( n --)
: apply-rule                           ( f1 n1 -- f2 n2 f2)
  >r eval-buffer count                 \ get the evaluation buffer
  r@ rules -> from: @ count            \ add from string
  r@ rules -> to:   @ count replace >r \ get to string
  2drop >string r@ or r> r@ ?print     \ clean up, set flags and print
  r@ rules -> exit: @ if drop drop false r> over else r> swap 0= then
;                                      \ interpret termination flag
                                       \ apply all rules
: apply-rules                          ( -- f)
  false 0 begin dup top < while apply-rule while 1+ repeat drop 0=
;                                      \ return flag if no rules applied
                                       \ set and evaluate buffer
: rewrite                              ( --)
  0 parse dup                          \ is the string of non-zero length?
  if                                   \ if so fill buffer and apply rules
    eval-buffer place begin apply-rules until eval-buffer count type cr
  else                                 \ if not, signal zero length buffer
    MKE.NOEVAL throw
  then
;
                                       \ if non-zero length load command file
: list                                 ( --)
  top 0 ?do                            \ print all rules
    i r# .r ." : "                     \ print file number
    i rules -> from: @ count type ."  -> "
    i rules -> to:   @ count type      \ both from and to strings
    i rules -> exit: @ if ."  (Terminating)" then cr
  loop
;
                                       \ print help
: help                                 ( --)
  ." :: Commands" cr
  ." add string=string    : Add a rule" cr
  ." last string=string   : Add a terminating rule" cr
  ." = string             : Rewrite a string" cr
  .| load" filename"      : Load a command file| cr
  .| echo" string"        : Print string| cr
  ." // string            : Comment" cr
  ." # string             : Comment" cr
  ." rules                : Enter Markov rules" cr
  ." list                 : List rules" cr
  ." clear                : Clear all rules" cr
  ." silent               : Silent mode" cr
  ." verbose              : Verbose mode" cr
  ." exit                 : Exit program" cr
;

create wordlist                        \ dictionary
  ," ="       ' rewrite ,
  ," add"     ' add ,
  ," last"    ' add-last ,
  ,| load"|   ' load" ,
  ,| echo"|   ' echo" ,
  ," //"      ' // ,
  ," #"       ' // ,
  ," clear"   ' clear ,
  ," rules"   ' >rules ,
  ," silent"  ' silent ,
  ," verbose" ' verbose ,
  ," list"    ' list ,
  ," help"    ' help ,
  ," quit"    ' bye ,
  ," exit"    ' bye ,
  ," bye"     ' bye ,
  ," q"       ' bye ,
  NULL ,

wordlist to dictionary                 \ assign wordlist to dictionary
                                       \ main loop
: markov                               ( --)
  clear argn 1 ?do i args ['] load-file .error-only loop
  MKE.NOERRS .error                    \ load any files on command line
  begin                                \ show the prompt
    refill drop                        \ get a command
    ['] interpret catch .error         \ interpret and print messages
  again                                \ repeat command loop eternally
;

markov