##########################
### 99 Bottles of Beer ###
### coded in Brainfuck ###
### with explanations  ###
##########################
#
# This Bottles of Beer program
# was written by Andrew Paczkowski
# Coder Alias: thepacz
# three_halves_plus_one@yahoo.com
#####

>                            blank the zeroth cell
+++++++>++++++++++[<+++++>-] 57 in the first cell
+++++++>++++++++++[<+++++>-] 57 in second cell
++++++++++                   10 in third cell
>++++++++++                  10 in fourth cell

##########################################
### create ASCII chars in higher cells ###
##########################################

>>++++++++[<++++>-]               " "
>++++++++++++++[<+++++++>-]        b
+>+++++++++++[<++++++++++>-]       o
++>+++++++++++++++++++[<++++++>-]  t
++>+++++++++++++++++++[<++++++>-]  t
>++++++++++++[<+++++++++>-]        l
+>++++++++++[<++++++++++>-]        e
+>+++++++++++++++++++[<++++++>-]   s
>++++++++[<++++>-]                " "
+>+++++++++++[<++++++++++>-]       o
++>++++++++++[<++++++++++>-]       f
>++++++++[<++++>-]                " "
>++++++++++++++[<+++++++>-]        b
+>++++++++++[<++++++++++>-]        e
+>++++++++++[<++++++++++>-]        e
>+++++++++++++++++++[<++++++>-]    r
>++++++++[<++++>-]                " "
+>+++++++++++[<++++++++++>-]       o
>+++++++++++[<++++++++++>-]        n
>++++++++[<++++>-]                " "
++>+++++++++++++++++++[<++++++>-]  t
++++>++++++++++[<++++++++++>-]     h
+>++++++++++[<++++++++++>-]        e
>++++++++[<++++>-]                " "
++>+++++++++++++[<+++++++++>-]     w
+>++++++++++++[<++++++++>-]        a
>++++++++++++[<+++++++++>-]        l
>++++++++++++[<+++++++++>-]        l
>+++++[<++>-]                      LF
++>+++++++++++++++++++[<++++++>-]  t
+>++++++++++++[<++++++++>-]        a
+++>+++++++++++++[<++++++++>-]     k
+>++++++++++[<++++++++++>-]        e
>++++++++[<++++>-]                " "
+>+++++++++++[<++++++++++>-]       o
>+++++++++++[<++++++++++>-]        n
+>++++++++++[<++++++++++>-]        e
>++++++++[<++++>-]                " "
>++++++++++[<++++++++++>-]         d
+>+++++++++++[<++++++++++>-]       o
++>+++++++++++++[<+++++++++>-]     w
>+++++++++++[<++++++++++>-]        n
>++++++++[<++++>-]                " "
+>++++++++++++[<++++++++>-]        a
>+++++++++++[<++++++++++>-]        n
>++++++++++[<++++++++++>-]         d
>++++++++[<++++>-]                " "
++>+++++++++++[<++++++++++>-]      p
+>++++++++++++[<++++++++>-]        a
+>+++++++++++++++++++[<++++++>-]   s
+>+++++++++++++++++++[<++++++>-]   s
>++++++++[<++++>-]                " "
+>+++++++++++++[<++++++++>-]       i
++>+++++++++++++++++++[<++++++>-]  t
>++++++++[<++++>-]                " "
+>++++++++++++[<++++++++>-]        a
>+++++++++++++++++++[<++++++>-]    r
+>+++++++++++[<++++++++++>-]       o
>+++++++++++++[<+++++++++>-]       u
>+++++++++++[<++++++++++>-]        n
>++++++++++[<++++++++++>-]         d
>+++++[<++>-]                      LF
+++++++++++++                      CR

<[<]>>>>  go back to fourth cell

#################################
### initiate the display loop ###
#################################

[            loop
 <            back to cell 3
 [           loop
  [>]<<       go to last cell and back to LF
  ..          output 2 newlines
  <[<]>       go to first cell

 ###################################
 #### begin display of characters###
 ###################################
 #
 #.>.>>>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>
 #X X     b o t t l e s   o f   b e e r  
 #.>.>.>.>.>.>.>.>.>.>.>.
 #o n   t h e   w a l l N
 #<[<]>    go to first cell
 #.>.>>>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>>>>>>>>>>>>>.>
 #X X     b o t t l e s   o f   b e e r             N
 #.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>
 #t a k e   o n e   d o w n   a n d   p a s s   
 #.>.>.>.>.>.>.>.>.>.
 #i t   a r o u n d N
 #####

  <[<]>>      go to cell 2
  -           decrement cell 2
  <           go to cell 1

 ########################
 ### display last line ##
 ########################
 #
 #.>.>>>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>
 #X X     b o t t l e s   o f   b e e r  
 #.>.>.>.>.>.>.>.>.>.>.
 #o n   t h e   w a l l
 #####

  <[<]>>>-    go to cell 3/decrement
 ]           end loop when cell 3 is 0
 ++++++++++   add 10 to cell 3
 <++++++++++  back to cell 2/add 10
 <-           back to cell 1/decrement
 [>]<.        go to last line/carriage return
 <[<]>        go to first line

########################
### correct last line ##
########################
#
#.>.>>>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>
#X X     b o t t l e s   o f   b e e r  
#.>.>.>.>.>.>.>.>.>.>.
#o n   t h e   w a l l
#####

 <[<]>>>>-    go to cell 4/ decrement
]            end loop when cell 4 is 0
>[>]<.        go to last line/carriage return
<<<.<<.<<<.
   n  o    
<[<]>         go to first zero line
>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>.>
   b o t t l e s   o f   b e e r  
.>.>.>.>.>.>.>.>.>.>.
o n   t h e   w a l l

 
