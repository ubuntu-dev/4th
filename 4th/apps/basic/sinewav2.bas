10 REM Sine Wave
20 REM
30 Q = 10
40 C = 1000
60 REM DO
70 T = S * 967 / 1000 + C * 249 / 1000
80 C = C * 967 / 1000 - S * 249 / 1000
90 S = T
100 I = 0
110 REM DO
120 PRINT " ";
130 I = I + 1
140 IF I < 28 + 26 * S / 1000 GOTO 110
150 REM LOOP
160 PRINT "uBasic for 4tH compiler"
200 N = N + 1
210 IF N < 25 GOTO 60
220 N = 0
230 S = 0
240 C = 1000
250 Q = Q - 1 : IF Q GOTO 60
260 REM LOOP