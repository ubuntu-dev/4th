\ Nach geladenem Gforth-R8C ueber die Tastatur in das
\ RAM des R8Cs eingeben. Danach per SAVESYSTEM 
\ "festfrieren". Kann per EMPTY bis auf das eigentliche
\ Forth-System geloescht werden.

\ Ich verwende im gesamten Programm Grossschreibung.
\ Kleinschreibung reicht aber. Das System ist auf
\ egal voreingestellt.

[HEX]

\ Sudoku-Matrix, zeilenweise, pro Element ein Byte
OFFSET Sudoku

0 C, 1 C, 2 C,  3 C, 4 C, 5 C,  6 C, 7 C, 8 C,
3 C, 4 C, 5 C,  6 C, 7 C, 8 C,  0 C, 1 C, 2 C,
6 C, 7 C, 8 C,  0 C, 1 C, 2 C,  3 C, 4 C, 5 C,

1 C, 2 C, 3 C,  4 C, 5 C, 6 C,  7 C, 8 C, 0 C,
4 C, 5 C, 6 C,  7 C, 8 C, 0 C,  1 C, 2 C, 3 C,
7 C, 8 C, 0 C,  1 C, 2 C, 3 C,  4 C, 5 C, 6 C,

2 C, 3 C, 4 C,  5 C, 6 C, 7 C,  8 C, 0 C, 1 C,
5 C, 6 C, 7 C,  8 C, 0 C, 1 C,  2 C, 3 C, 4 C,
8 C, 0 C, 1 C,  2 C, 3 C, 4 C,  5 C, 6 C, 7 C,

51 CONSTANT #M

#M BUFFER: M

\ Hole Element in Zeile i und Spalte j von Matrix M
: IJ@ ( i j -- a[ij] ) SWAP 9 * + M + C@ ;

\ Speichere Element in Zeile i und Spalte j nach Matrix M
: IJ! ( a[ij] i j -- ) SWAP 9 * + M + C! ;

\ Addiere n modulo 9 zu saemtlichen Elementen von Matrix M
: ADDn ( n -- )
    #M 0 DO DUP M I + C@ + 9 MOD M I + C! LOOP DROP ;

\ INDEX
VARIABLE IX

\ Vertausche willkuerlich 2 Spalten einer Laengsdreierreihe in Matrix M
: XCHJ ( -- ) IX @ C@ 9 0
   DO DUP 9 MOD DUP DUP 3 MOD 0> IF 1 - ELSE 1+ THEN
     2DUP I SWAP IJ@ I ROT IJ@ ROT I SWAP IJ! I ROT IJ!
   LOOP DROP ;

\ Vertausche Zeile 3 und 5 und Zeile 7 und 8 in Matrix M
: XCHI ( -- ) 9 0
   DO 3 I IJ@ 5 I IJ@ 3 I IJ! 5 I IJ! 7 I IJ@ 8 I IJ@ 7 I IJ! 8 I IJ!
   LOOP ;

\ ASCII --> Ziffernausgabe
: ZIFFM ( n -- ) DUP MAX-N AND 8 > IF DROP SPACE SPACE ELSE 1+ . THEN ;
: ZIFFS ( n -- ) DUP MAX-N AND 8 > IF DROP ." 0" ELSE 1+ 0 .R THEN ;

\ IX um 5 weitersetzen
: I5+! ( -- ) IX @ DUP M #M + 6 - > IF #M - THEN 5 + IX ! ;

\ Zufaellige Auslassungen
\ Etwa 27d Elemente bleiben als Vorgabe stehen. Breite Streuung!
: RAND ( n -- m ) IX @ C@ 3 MOD IF DROP 20 THEN I5+! ;

\ Bildschirmdarstellung von geaenderter Vorgabematrix
: V ( -- ) 
   CR 9 0 DO 9 0 DO J I IJ@      ZIFFM LOOP CR LOOP
   CR 9 0 DO 9 0 DO J I IJ@ RAND ZIFFS LOOP CR LOOP ;

\ Neue Sudoku-Matrix mit passender Vorgabematrix
: S ( -- ) IX @ C@  ADDn  XCHI  XCHJ  I5+! V ;

: MakeSudoku
  #M 0 DO I Sudoku I CHARS M + C! LOOP TIME ADDn M IX !
  BEGIN 
    S ." Press space and enter for another one.."
    REFILL DROP TIB C@ BL -
  UNTIL
;

MakeSudoku

\ Will man zu ein und derselben (Loesungs-)Matrix M verschiedene
\ Vorgabematrizen erzeugen, dann rufe man (beliebig oft) V auf.
\ Bei jedem erneuten Aufruf von V wird die bis dato erreichte
\ Sudoku-Matrix M beibehalten, waehrend die Vorgabematrix neu er-
\ zeugt wird.

\ Selbstverstaendlich kann man eine erreichte Vorgabematrix
\ auch per Hand ausbessern: Man uebernehme (und notiere auf
\ Papier) nur, sagen wir, 27d Elemente oder ergaenze (bei zu
\ wenigen Vorgabeelementen) Elemente durch Einfuegen von der
\ Sudoku-Matrix M her.

\ Man kann eine erreichte Sudoku-Matrix M auch per Hand aendern:
\ Dazu stehen die drei Forth-Worte  x ADDN  XCHI  XCHJ  (in
\ beliebiger Anwendungsreihenfolge) zur Verfuegung. x kann
\ eine beliebige Zahl sein.

\ Geaenderte Vorgabe-Matrizen bei gleichbleibender Sudoku-
\ Matrix werden durch V angezeigt. Geaenderte Sudoku-Matrizen
\ mit passender Vorgabe-Matrix werden durch S angezeigt.

\ Solche Tastatureingaben muessen natuerlich immer durch
\ [return] abgeschlossen werden, um Wirksamkeit zu erlangen.