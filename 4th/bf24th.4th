\ BrainFuck to 4tH Converter - Copyright 2004,2014 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

78 constant rmargin

include lib/print.4th
include lib/row.4th

create BFop
  char > , ," char+"
  char < , ," char-"
  char + , ," dup c@ 1+ over c!"
  char - , ," dup c@ 1- over c!"
  char . , ," dup c@ emit"
  char , , ," char> over c!"
  char [ , ," begin dup c@ while"
  char ] , ," repeat"
  NULL ,

: Preprocess
  ." ( This file was generated by BF24tH - Copyright 2004, 2014 J.L. Bezemer)" cr
  cr
  ." 10 constant EOL                        \ end of line character" cr
  ." 30000 constant #BFMemory" cr
  ." #BFMemory string BFmemory              \ BF memory" cr
  cr
  ." : char>                                ( t m -- t m c)" cr
  ."   over tib =                           \ check buffer, if needed" cr
  ."   if refill else true then             \ refill the buffer" cr
  ."   if                                   \ if read is successful" cr
  ."     >r dup c@                          \ get character, if not EOL" cr
  ."     if dup char+ r> rot c@ exit then   \ increment pointer, get char" cr
  ."     drop tib r> EOL exit               \ else signal EOL" cr
  ."   then 0                               \ return NULL pointer" cr
  ." ;" cr
  nl
  s" : BF" print
;

: PostProcess bl show [char] ; show cr cr ." tib BFMemory BF" cr ;
: Usage abort" Usage: bf24th bf-source 4th-source" ;
: Read-file pad 1 accept ;

: Process
  pad c@ BFop 2 num-key row if cell+ @c count print else drop then drop
;

include lib/convert.4th
