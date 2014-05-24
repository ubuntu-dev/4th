10 REM PRINT TAB(33);"TOWERS"
20 REM PRINT TAB(15);"CREATIVE COMPUTING  MORRISTOWN, NEW JERSEY"
30 PRINT:PRINT:PRINT
90 PRINT
100 REM*** INITIALIZE
110 REM DIM T(7,3)
120 E=0
130 FOR D=0 TO 6
140 FOR N=0 TO 2
150 @(D*7+N)=0
160 NEXT N
170 NEXT D
180 PRINT "TOWERS OF HANOI PUZZLE.": PRINT
200 PRINT "YOU MUST TRANSFER THE DISKS FROM THE LEFT TO THE RIGHT"
205 PRINT "TOWER, ONE AT A TIME, NEVER PUTTING A LARGER DISK ON A"
210 PRINT "SMALLER DISK.": PRINT
215 INPUT "HOW MANY DISKS DO YOU WANT TO MOVE (7 IS MAX): "; S
220 PRINT
230 M=0
240 Q=0
250 IF (Q=S)+(Q=7) THEN GOTO 350
260 Q=Q+1 GOTO 250
270 E=E+1
280 IF E>2 THEN GOTO 310
290 PRINT "SORRY, BUT I CAN'T DO THAT JOB FOR YOU.": GOTO 215
310 PRINT "ALL RIGHT, WISE GUY, IF YOU CAN'T PLAY THE GAME RIGHT, I'LL"
320 PRINT "JUST TAKE MY PUZZLE AND GO HOME.  SO LONG.": STOP
340 REM *** STORE DISKS FROM SMALLEST TO LARGEST
350 PRINT "IN THIS PROGRAM, WE SHALL REFER TO DISKS BY NUMERICAL CODE."
355 PRINT "3 WILL REPRESENT THE SMALLEST DISK, 5 THE NEXT SIZE,"
360 PRINT "7 THE NEXT, AND SO ON, UP TO 15.  IF YOU DO THE PUZZLE WITH"
365 PRINT "2 DISKS, THEIR CODE NAMES WOULD BE 13 AND 15.  WITH 3 DISKS"
370 PRINT "THE CODE NAMES WOULD BE 11, 13 AND 15, ETC.  THE NEEDLES"
375 PRINT "ARE NUMBERED FROM LEFT TO RIGHT, 1 TO 3.  WE WILL"
380 PRINT "START WITH THE DISKS ON NEEDLE 1, AND ATTEMPT TO MOVE THEM"
385 PRINT "TO NEEDLE 3."
390 PRINT: PRINT "GOOD LUCK!": PRINT
400 Y=6: D=15
420 X=S
430 @(Y*7)=D : D=D-2: Y=Y-1
460 X=X-1 : IF X>0 THEN GOTO 430
470 GOSUB 1230
480 INPUT "WHICH DISK WOULD YOU LIKE TO MOVE: "; D : E=0
510 IF (D-3)*(D-5)*(D-7)*(D-9)*(D-11)*(D-13)*(D-15)=0 THEN GOTO 580
520 PRINT "ILLEGAL ENTRY... YOU MAY ONLY TYPE 3,5,7,9,11,13, OR 15."
530 E=E+1: IF E>1 THEN GOTO 560
550 GOTO 500
560 PRINT "STOP WASTING MY TIME.  GO BOTHER SOMEONE ELSE.": STOP
580 REM *** CHECK IF REQUESTED DISK IS BELOW ANOTHER
590 R=0
600 C=0
610 IF @(R*7+C)=D THEN GOTO 640
620 C=C+1 : IF C<3 THEN GOTO 610
630 R=R+1 : IF R<7 THEN GOTO 600
640 Q=R-1
645 IF @(Q*7+C)=0 THEN GOTO 660
650 IF @(Q*7+C)<D THEN GOTO 680
660 Q=Q-1 : IF Q>-1 THEN GOTO 645
670 GOTO 700
680 PRINT "THAT DISK IS BELOW ANOTHER ONE.  MAKE ANOTHER CHOICE."
690 GOTO 480
700 E=0
705 INPUT "PLACE DISK ON WHICH NEEDLE: ";N
730 IF (N-1)*(N-2)*(N-3)=0 THEN N=N-1: GOTO 800
735 E=E+1
740 IF E>1 THEN GOTO 780
750 PRINT "I'LL ASSUME YOU HIT THE WRONG KEY THIS TIME.  BUT WATCH IT,"
760 PRINT "I ONLY ALLOW ONE MISTAKE.": GOTO 705
780 PRINT "I TRIED TO WARN YOU, BUT YOU WOULDN'T LISTEN."
790 PRINT "BYE BYE, BIG SHOT." : STOP
800 R=0
810 IF @(R*7+N)#0 THEN GOTO 840
820 R=R+1 : IF R<7 THEN GOTO 810
830 GOTO 880
835 REM *** CHECK IF DISK TO BE PLACED ON A LARGER ONE
840 IF D<@(R*7+N) THEN GOTO 880
850 PRINT "YOU CAN'T PLACE A LARGER DISK ON TOP OF A SMALLER ONE,"
860 PRINT "IT MIGHT CRUSH IT!": PRINT "NOW THEN, "; : GOTO 480
875 REM *** MOVE RELOCATED DISK
880 V=0
890 W=0
900 IF @(V*7+W)=D THEN GOTO 930
910 W=W+1 : IF W<3 THEN GOTO 900
920 V=V+1 : IF V<7 THEN GOTO 890
925 REM *** LOCATE EMPTY SPACE ON NEEDLE N
930 U=0
940 IF @(U*7+N)#0 THEN GOTO 970
950 U=U+1 : IF U<7 THEN GOTO 940
960 U=6: GOTO 980
965 REM *** MOVE DISK AND SET OLD LOCATION TO 0
970 U=U-1
980 @(U*7+N)=@(V*7+W): @(V*7+W)=0
995 REM *** PRINT OUT CURRENT STATUS
1000 GOSUB 1230
1018 REM *** CHECK IF DONE
1020 M=M+1
1030 R=0
1040 C=0
1050 IF @(R*7+C)#0 THEN GOTO 1090
1060 C=C+1 : IF C<2 THEN GOTO 1050
1070 R=R+1 : IF R<7 THEN GOTO 1040
1080 GOTO 1120
1090 IF M<129 THEN GOTO 480
1100 PRINT "SORRY, BUT I HAVE ORDERS TO STOP"
1110 PRINT "IF YOU MAKE MORE THAN 128 MOVES.": STOP
1120 IF M#2^S-1 THEN GOTO 1140
1130 PRINT:PRINT "CONGRATULATIONS!!":PRINT
1140 PRINT "YOU HAVE PERFORMED THE TASK IN ";M;" MOVES."
1150 PRINT: PRINT "TRY AGAIN (YES=1 OR NO=0): ";: INPUT O
1160 IF O=0 THEN GOTO 1390
1170 IF O=1 THEN GOTO 90
1180 PRINT: INPUT "'YES' OR 'NO' PLEASE: "; O: GOTO 1160
1230 REM *** PRINT SUBROUTINE
1240 FOR K=0 TO 6
1250 Z=10
1260 FOR J=0 TO 2
1270 FOR O=0 TO Z-(@(K*7+J)/2); PRINT " "; : NEXT O
1280 IF @(K*7+J)=0 THEN PRINT "*";
1290 FOR V=1 TO @(K*7+J) : PRINT "*"; : NEXT V
1315 IF J<2 THEN FOR O=0 TO Z-(@(K*7+J)/2); PRINT " "; : NEXT O
1340 NEXT J
1360 PRINT
1370 NEXT K : PRINT
1380 RETURN
1390 PRINT: PRINT "THANKS FOR THE GAME!": PRINT: END