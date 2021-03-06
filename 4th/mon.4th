\ 4tH monitor - Copyright 2007,2012 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/ansblock.4th               \ must be loaded first!
include lib/evaluate.4th               \ for EVALUATE and LOAD
include lib/anscore.4th                \ for 2OVER
include lib/stack.4th                  \ for the user stack
                                       \ words handled by host program
  0 enum JLOAD                         \ LOAD"
    enum JCOMP                         \ COMPILE"
    enum JPAUSE                        \ PAUSE
    enum JRUN                          \ RUN
    enum JAWAKE                        \ AWAKE
    enum JSLEEP                        \ SLEEP
    enum JKILL                         \ KILL
    enum JTASKS                        \ TASKS
    enum JSAVE                         \ SAVE"
    enum JWRITE                        \ WRITE"
    enum JSTAT                         \ STATUS
    enum JHALT                         \ HALT
    enum JBOOT                         \ BOOT
    enum JPID                          \ TASK
constant JSEE                          \ SEE

128 string taskname                    \ transfers filename to host program
 64 array  stk                         \ user stack

create pairs?                          \ handles IF THEN conditionals
  ," if"    1 ,
  ," then" -1 ,                        \ evaluate nesting level
  NULL ,                               ( n1 a n2 -- n3 a n2 n3)
does>
  2 string-key row if cell+ @c >r rot r> + else drop rot then dup >r -rot r>
;

\ Utility words
: label                                ( --)
  begin                                ( --)
    bl parse-word dup                  ( a n f)
  while                                ( a n)
    2dup s" ::" compare                ( a n f)
  while                                ( a n)
    2drop                              ( --)
  repeat 2drop                         ( --)
;

: >label                               ( a n --)
   begin                               ( a1 n1)
     label bl parse-word dup           ( a1 n1 a2 n2 f)
   while                               ( a1 n1 a2 n2)
     2over 2over compare               ( a1 n1 a2 n2 f)
   while                               ( a1 n1 a2 n2)
     2drop                             ( a1 n1)
   repeat 2drop 2drop                  ( --)
;

: init-block open-blockfile 0 load ;   ( a n --)
: boot argn 0 ?do i args ['] init-block catch if ." I/O error" cr then loop ;
: nest? begin bl parse-word dup while pairs? while 2drop repeat 2drop dup ;
: script? source drop tib <> ;         ( -- f)
: >u stk >a ;                          ( n --)
: u> stk a> ;                          ( -- n)
: >host >u pause ;                     ( n --)
: 2>host swap >u >host ;               ( n1 n2 --)
: s>host taskname dup >u [char] " parse rot place >host ;

\ The words supported by the interpreter
: _+ + ;
: _- - ;
: _* * ;
: _/ / ;
: _.( [char] ) parse type ;
: _( [char] ) parse 2drop ;
: _cr cr ;
: _. . ;
: _dup dup ;
: _rot rot ;
: _swap swap ;
: _over over ;
: _drop drop ;
: _running 1 ;
: _sleeping 0 ;
: _done 2 ;
: _= = ;
: _not 0= ;
: _load JLOAD s>host u> ;
: _compile JCOMP s>host u> ;
: _save >u JSAVE s>host ;
: _write >u JWRITE s>host ;
: _see swap >u JSEE 2>host ;
: _pause JPAUSE >host ;
: _boot JBOOT >host ;
: _task JPID >host u> ;
: _halt JHALT >host ;
: _pauses 0 ?do _pause loop ;
: _run JRUN 2>host ;
: _awake JAWAKE 2>host ;
: _sleep JSLEEP 2>host ;
: _kill JKILL 2>host ;
: _status JSTAT 2>host u> ;
: _tasks JTASKS >host ;
: _bload script? if load else drop then ;
: _script [char] " parse script? if 2drop else init-block then ;
: _if 0= if 1 begin nest? while refill 0= until drop then ;
: _then ;
: _:: bl parse-word 2drop ;
: _goto bl parse-word 0 >in ! >label ;

\ The dictionary of the interpreter
create wordlist
  ," +"          ' _+ ,
  ," -"          ' _- ,
  ," *"          ' _* ,
  ," /"          ' _/ ,
  ," .("         ' _.( ,
  ," ("          ' _( ,
  ," cr"         ' _cr ,
  ," ."          ' _. ,
  ," if"         ' _if ,
  ," then"       ' _then ,
  ," ::"         ' _:: ,
  ," goto"       ' _goto ,
  ," not"        ' _not ,
  ," ="          ' _= ,
  ," dup"        ' _dup ,
  ," rot"        ' _rot ,
  ," swap"       ' _swap ,
  ," over"       ' _over ,
  ," drop"       ' _drop ,
  ,| load"|      ' _load ,
  ,| compile"|   ' _compile ,
  ,| save"|      ' _save ,
  ,| write"|     ' _write ,
  ,| script"|    ' _script ,
  ," load"       ' _bload ,
  ," see"        ' _see ,
  ," status"     ' _status ,
  ," running"    ' _running ,
  ," sleeping"   ' _sleeping ,
  ," done"       ' _done ,
  ," pause"      ' _pause ,
  ," pauses"     ' _pauses ,
  ," run"        ' _run ,
  ," awake"      ' _awake ,
  ," sleep"      ' _sleep ,
  ," kill"       ' _kill ,
  ," halt"       ' _halt ,
  ," boot"       ' _boot ,
  ," task"       ' _task ,
  ," tasks"      ' _tasks ,
  NULL ,

wordlist to dictionary                 \ assign wordlist to dictionary

\ The interpreter itself
: mon
  stk dup stack out ! boot             \ setup user stack and boot files
  begin                                \ show the prompt and get a command
    ." OK" cr refill drop              \ interpret and issue oops when needed
    ['] interpret catch if ." Oops " then
  again                                \ repeat command loop eternally
;

mon
