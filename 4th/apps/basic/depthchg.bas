2 REM PRINT TAB(30);"DEPTH CHARGE"
4 REM PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
6 PRINT: PRINT: PRINT
20 INPUT "DIMENSION OF SEARCH AREA: ";G: PRINT
30 N=0 : Q=G
35 Q=Q/2 : N=N+1 : IF Q THEN GOTO 35
40 PRINT "YOU ARE THE CAPTAIN OF THE DESTROYER USS COMPUTER"
50 PRINT "AN ENEMY SUB HAS BEEN CAUSING YOU TROUBLE.  YOUR"
60 PRINT "MISSION IS TO DESTROY IT.  YOU HAVE ";N;" SHOTS."
70 PRINT "SPECIFY DEPTH CHARGE EXPLOSION POINT WITH A"
80 PRINT "TRIO OF NUMBERS -- THE FIRST TWO ARE THE"
90 PRINT "SURFACE COORDINATES; THE THIRD IS THE DEPTH."
100 PRINT : PRINT "GOOD LUCK !": PRINT
110 A=RND(G) : B=RND(G) : C=RND(G) : D=1
120 PRINT : PRINT "TRIAL #";D : INPUT "(we): ";X : INPUT "(sn): "; Y :  INPUT "(^v): ";Z
130 GOSUB 650 : IF K+L+M=0 THEN GOTO 300
140 GOSUB 500 : PRINT : D=D+1 : IF D<N+1 THEN GOTO 120
200 PRINT : PRINT "YOU HAVE BEEN TORPEDOED!  ABANDON SHIP!"
210 PRINT "THE SUBMARINE WAS AT ";A;", ";B;", ";C : GOTO 400
300 PRINT : PRINT "B O O M ! ! YOU FOUND IT IN ";D;" TRIES!"
400 PRINT : PRINT: INPUT "ANOTHER GAME (Y=1 OR N=0)? ";A
410 IF A THEN GOTO 100
420 PRINT "OK.  HOPE YOU ENJOYED YOURSELF." : GOTO 600
500 PRINT "SONAR REPORTS SHOT WAS ";
510 IF Y>B THEN PRINT "NORTH";
520 IF Y<B THEN PRINT "SOUTH";
530 IF X>A THEN PRINT "EAST";
540 IF X<A THEN PRINT "WEST";
550 IF (Y#B)+(X#A) THEN PRINT " AND";
560 IF Z>C THEN PRINT " TOO LOW."
570 IF Z<C THEN PRINT " TOO HIGH."
580 IF Z=C THEN PRINT " DEPTH OK."
590 RETURN
600 END
650 K=X-A : IF K<0 THEN K=-K
660 L=Y-B : IF L<0 THEN L=-L
670 M=Z-C : IF M<0 THEN M=-M
680 RETURN
