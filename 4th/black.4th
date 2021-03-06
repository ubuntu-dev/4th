\ BLACKJACK a small program converted from FigForth 79.
\ What it does is obvious, so I won't bother to explain
\ further here.
\ 4tH conversion - Copyright 2005,2008 J.L. Bezemer

[PRAGMA] IGNORENUMBERS

INCLUDE lib/interprt.4th
INCLUDE lib/choose.4th
INCLUDE lib/enter.4th

 VARIABLE CARDS VARIABLE HAND        ( comp hand, player hand )
 VARIABLE CARD  VARIABLE TESTV ( last card/exit the loop flag )
 VARIABLE BET   VARIABLE TOTAL             ( bet & win/losses )
 VARIABLE HACE  VARIABLE CACE      ( human/computer ace flags )

: .$ DUP ABS <# #S [CHAR] $ HOLD SIGN #> TYPE ;
: HELLO ." Welcome to Forth Blackjack. " CR ;
: 1$ ." Ace converted to 11." CR ;
: 2$ ." Ace converted to 1." CR ;
: DRAW ." We have both busted!" CR ;
: LOST TYPE CR BET @ NEGATE TOTAL +! ;
: CARDS-HAND CARDS @ HAND @ ;
: CARDS-21? CARDS @ 21 > ;
                                     ( the strings obviously! )
( BLACKJACK )                      ( win, lose, draw and deal )
: WIN ." Hand won." CR BET @ DUP TOTAL +! 2/ TOTAL +! ;
                         ( deal - randomly generate next card )
: DEAL ( -- n ) 13 CHOOSE 1+  10 MIN DUP CARD ! ;
( BLACKJACK )              ( shift aces to greatest advantage )
: ACE1 HACE @ 0 > IF -1 HACE +! -10 HAND +! 2$ THEN ;
                                       ( change ace back to 1 )
: ACE2 CARD @ 1 = IF 1 HACE +! 10 HAND +! 1$ THEN ;
                               ( change an ace to 11 if dealt )
: ACEH1 HAND @ 21 > IF ACE1 ELSE ACE2 THEN 0 CARD ! ;
                      ( change ace back to 1 if a bust occurs )
: ACEH ACEH1 ACEH1 ;
      ( do above twice for multiple aces for the human player )
: ACE3 CACE @ 0 > IF -1 CACE +! -10 CARDS +! 2$ THEN ;
: ACE4 CARD @ 1 = IF 1 CACE +! 10 CARDS +! 1$ THEN ;

: ACEC1 CARDS-21? IF ACE3 ELSE ACE4 THEN 0 CARD ! ;
: ACEC ACEC1 ACEC1 ;
                               ( do the same for the computer )
( BLACKJACK )                         ( compare the two hands )
: COMP4 CARDS-HAND = IF S" Push!" LOST ELSE WIN THEN ;
                      ( if both equal, push. Else player wins )
: COMP3 CARDS-HAND > IF S" Hand lost." LOST ELSE COMP4 THEN ;
                 ( if computer's hand is greater, player loses)
: COMP2 CARDS-21? IF WIN ELSE COMP3 THEN ;
                              ( if computer busts, human wins )
: COMP1 CARDS-21? IF DRAW ELSE S" Hand lost." LOST THEN ;
                ( if both human & computer busts, it's a draw )
: COMP HAND @ 21 > IF COMP1 ELSE COMP2 THEN ;
            ( decide if we need to check computer for busting )
( BLACKJACK )                             ( play action words )
: HIT CR DEAL DUP ." Card drawn " . HAND +! ACEH ." Total="
  HAND @ . CR ;                   ( deal a card to the player )

: SHOW CR ." Dealer has " DEAL DUP . CARDS +! ACEC ." Total="
       CARDS @ . CR ;           ( deal a card to the computer )

: STAND SHOW CARDS @ 16 < IF BEGIN DEAL DUP ." Dealer draws "
    . CARDS +! ACEC ." Total=" CARDS @ DUP . CR 16 > UNTIL
    THEN 1 TESTV ! ;
       ( deal cards to computer until 17 or higher is reached )
: STOP 2 TESTV ! ;                     ( halt by setting flag )

:NONAME ." I don't know what '" TYPE ." ' means" CR ;
    IS NOTFOUND
                            ( if you enter an invalid command )
CREATE WORDLIST
  ," HIT"   ' HIT ,
  ," STAND" ' STAND ,
  ," STOP"  ' STOP ,
  ," SHOW"  ' SHOW ,
  NULL ,

WORDLIST TO DICTIONARY

( BLACKJACK )                              ( player interface )
: GETB BEGIN CR ." What is your bet ($10 min)" CR ." ? " ENTER
  DUP BET ! 9 > UNTIL ;
                                    ( get the amount of a bet )
: SETUP 0 TESTV ! 0 CACE ! 0 HACE ! HELLO DEAL DUP CARDS !
  ." Dealer showing " . ACEC DEAL DUP HAND ! CR ." First card "
  . ACEH DEAL DUP HAND +! ." Top card " . ACEH ." Total="
  HAND @ . CR ;      ( deal out starting cards and show stats )

( BLACKJACK )                              ( player interface )
: PLAY1 SETUP BEGIN ." Hit, Stand, Show or Stop?" CR ." ? " 
  REFILL DROP INTERPRET TESTV @ 0 > UNTIL ;
                                  ( perform play for one hand )
: PLAY HELLO GETB BEGIN CR CR PLAY1 TESTV @ 2 < IF
    COMP THEN TOTAL @ ." Total of bets: " .$ CR
    TESTV @ 2 = UNTIL ;     ( perform play until told to quit )

( BLACKJACK )              ( say hello with basic intrustions )
: HI! ." Blackjack Vers. 1.0 is now loaded ." CR
  ." Program by Mary Bell 09/12/83" CR
  ." Dealer pays 1 & 1/2 bet for greater hand and takes pushes."
  CR ." Dealer must hit on 16 and stand on 17." CR
  ." Aces are automatically converted to greatest advantage." CR
;

: BLACKJACK HI! PLAY ;

BLACKJACK
