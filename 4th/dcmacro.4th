\ Calculator with "Forth-like" macros with code from dc.4th (4/4/011).
\ Words are defined on one line (64). There is no reason why definitions
\ cannot span multiple lines if buffer space is allocated for such. 
\ The key primatives are:
\    n zload   -- will evaluate user defined word n
\ n2 n #load   -- will evaluate user defined word n for n2 times
\    n %load   -- will continue to evaluate word n until a true flag
\                 is left on stack (else a false flag should be left).
\ The macro will be 'compiled' correctly if the word starts with # or %
\ so there is no need to used the above primitives directly.
\ Examples:
\    : #stars ( -- ) ." *" ;
\    : #bar ( n -- )  cr #stars ;
\    : chart (  n ... -- ) cr ." Bar Chart" depth #bar cr cr ;
\       12 4 8 2 chart    
\ More examples: Loops
\    : #loop1 ( -- ) cr ii .  ii ii * . ;
\    : test1 ( -- )  cr 10 #loop1 ;
\    : %loop2 ( -- ) cr ii .  ii 75 = ;
\    : test2 ( -- )  cr %loop2 ;
\ If_Then
\    : test3 ( n -- ) dup 0 > if{ ." +" }then  0 < if{ ." -" }then ;   
\ Tools
\    words  -- show user defined words 
\    forget -- delete the last defined word
\    .s     -- display the stack
\    bye    -- quit the program

include lib/evaluate.4th 
include lib/anstools.4th 
include lib/stack.4th

false constant ignorenumbers                        \ ignore numbers 
:noname 2drop ." Not found!" cr ; is NotFound       \ define NotFound

16 constant NLEN                 \ character length of user defined names
64 constant CLEN                 \ length (code) for each defined word
32 constant MAXLINES             \ maximum number of words (or lines)
64 constant PADLEN               \ length of scratch pad 
32 constant STACKSIZE            \ stack size of calling user defined words
 
NLEN MAXLINES *  string zname    \ buffer for user defined word names
CLEN MAXLINES *  string zcode    \ buffer for user defined word definitions
 
CLEN string workspace             \ tempory space used when 'compiling' words
PADLEN string pad$
variable zline                    \ number of defined words (or code lines)
variable zflag                    \ flag used to track 'compiling'
variable index                    \ loop index for #load and %load
variable loadchar                 \ used to compile the 'z' '#' or '%'
                                  \     in zload, #load, or %load

STACKSIZE array zvar              \ define the stack and support words
zvar stack
: push zvar >a ;
: pop  zvar a> ;
: z@   zvar a@ ;

16 constant #variables             \ user variables for the calculator 
#variables array variables 
 
: variable?                            \ is it a valid variable? 
  dup                                  ( n n) 
  #variables 1- invert and             ( n f)
  if 
    cr ." Bad variable" 
  else 
    cells variables +                  ( a) 
  then 
; 
  
: zlist ( n -- ) CLEN * zcode + count  type  ;     \ list the word definition
: zload ( n -- ) CLEN * zcode + count evaluate ;   \ execuate word definition
 
: zload$ ( n -- adr n )                \ sting for 'zload' '#load' or '%load' 
  <# bl hold  char d hold char a hold  char o hold 
     char l hold loadchar @ hold bl hold #s 
  #> ; 
 
: #load ( n2 n -- )  push         \ execute word n for n2 times
   0 do i index !  z@ zload loop  pop drop ; 
 
 : %load ( n  -- ) push          \ execute word n until true-flag is left
     0 index !
     begin 1 index +! z@ zload until  pop drop ; 

: load_type ( char -- )    \ define the 'z' '#' or '%' for load$
     dup char # = 
     if  char # loadchar !          
     else char % = 
          if  char % loadchar ! else char z loadchar ! then
     then ; 

       
 : comp_on ( -- )   1 zflag ! ;   \ not using previously defined words
 : comp_off ( -- )  0 zflag ! ;   \ using previously defined words 
 : comp? ( -- n )   zflag @ ;      
 
 : zmacro ( -- )     \ analyze word definition from user 
    bl parse-word  zname zline @ NLEN * +  place    \ name of word  
    begin 
     bl parse-word dup                   \ parse the contents of definition
    while  
     workspace place  
     workspace count drop c@  load_type  \ check if word starts with # or % 
     comp_on   
     zline @ 0 do                         \ check if user defined word
       workspace count zname NLEN i * + count 
       compare 0= if 
         i zload$  zcode zline @ CLEN * +  +place 
         comp_off  leave   
       then 
     loop 
     comp? if                          \ else no need to modify just store
        workspace count zcode zline @ CLEN * +  +place 
        s"  "    zcode zline @ CLEN * +  +place 
     then 
    repeat drop drop 
    zline @  1+   MAXLINES 1- min zline !
    zline @ MAXLINES 1- = if cr ." Out of memory!" cr then 
  ; 
 
\ variable for the calculator
: A. 0 ;                               \ variable A 
: B. 1 ;                               \ variable B 
: C. 2 ;                               \ variable C 
: D. 3 ;                               \ variable D 
: E. 4 ;                               \ variable E 
: F. 5 ;                               \ variable F 
: G. 6 ;                               \ variable G 
: H. 7 ;                               \ variable H 
 
: !_      variable? ! ;                \ ! command 
: +!_     variable? +! ;               \ +! command 
: @_      variable? @ ;                \ @ command 
 
\ words for the interpreter 
: dup_  dup ;               
: rot_  rot ; 
: swap_  swap  ; 
: +_    + ; 
: -_    - ; 
: *_    * ; 
: /_    / ; 
: quit_  quit ; 
: ._      depth 0= if ." Empty stack " else .  then ; 
: emit_   emit ; 
: ii      index @ ; 
: if{     0= if char } parse drop drop then ; 
: ."_      char " parse type ;
: (_ 41 parse drop drop ;              \ ( command
: dummy ;
: =_     = ;
: <>_    <> ;
: <_     < ;
: >_     > ;
: and_    and ;
: or_     or ;
: pad?   pad$ count type ;
: pad"   char " parse pad$ place ;
: cr_    cr ;
: depth_   depth ; 

: forget  ( -- )     \ forget the last user defined definition          
   zline @ 1-  0 max zline ! 
   0 zcode zline @  CLEN * + c! ; 

: words ( -- )      \ show the user defined word definitions
    zline @ dup
     0= if cr ." No macros defined." cr drop 
     else  
        0 do 
          cr i . ." )  : " 
          zname NLEN i * + count 
          type  ."   " 
          i zlist 
        loop 
     then ; 

create wordset 
  ," dup"    ' dup_ , 
  ," swap"   ' swap_ , 
  ," rot"    ' rot_ , 
  ," +"      ' +_ , 
  ," -"      ' -_ , 
  ," *"      ' *_ , 
  ," /"      ' /_ , 
  ," bye"   ' quit_ , 
  ," .s"     ' .s , 
  ," ."      ' ._ , 
  ," ("      ' (_ ,
  ," emit"   ' emit_ , 
  ," zlist"  ' zlist , 
  ," zload"  ' zload , 
  ," #load"  ' #load ,
  ," %load"  ' %load , 
  ," ii"     ' ii  , 
  ," !"      ' !_  , 
  ," +!"     ' +!_ , 
  ," @"      ' @_  , 
  ," A."     ' A.  , 
  ," B."     ' B.  , 
  ," C."     ' C.  , 
  ," D."     ' D.  , 
  ," E."     ' E.  , 
  ," F."     ' F.  , 
  ," G."     ' G.  , 
  ," H."     ' H.  , 
  ," if{"    ' if{ , 
  ," }"      ' dummy , 
  ," ;"      ' dummy ,
  ," then"   ' dummy ,
  ," }then"  ' dummy ,
  ," ="      ' =_ ,
  ," <>"     ' <>_ ,
  ," <"      ' <_ ,
  ," >"      ' >_ ,
  ," and"    ' and_ ,
  ," or"     ' or_ ,
  ,| pad"|   ' pad" ,
  ," pad?"   ' pad? ,
  ,| ."|     ' ."_ ,
  ," cr"     ' cr_ ,
  ," depth"  ' depth_ ,
  ," words"  ' words ,
  ," forget" ' forget ,
  NULL , 
 
wordset to dictionary                  \ assign to dictionary 
 
: do_macro
   begin 
     bl parse-word dup 
    while 
     workspace place   comp_on
     workspace count s" :" compare 0= if zmacro  \ new user defined word?
     else                                        \ else process the word
     zline @ 0 do                        \ previous user defined word?
       workspace count zname NLEN i * + count 
       compare 0= if 
          zcode CLEN i * + count evaluate  comp_off
          leave 
       then 
     loop 
     comp? if workspace count evaluate then     \ not a user defined word 
   then                               
    repeat drop drop        
    ; 


 : init_mem ( -- ) 
      0 zline !
      0 zname c!
      MAXLINES 0 do
         0 zcode i CLEN * + c!
       loop ;

: dc_macro   
  init_mem
  begin 
     ." ok" cr  refill drop  
   do_macro
  again 
 ; 
 
dc_macro 
