\ Bitmap image viewer in plain text using the 4tH library. 
\ Each pixel is converted to an ascii character. Thus the image will
\ likely need to be reduced to produce the ascii-art version.
\ See the examples below.    David Johnsonm July 2012  
\ ======================================================================
\ Simple example of a few commands:
\   file portrait.ppm          Load the image file "portrait.ppm"
\   shrink shrink              Shrink the image by 4x (2x 2x)
\   info                       Display image size and viewing frame info
\   117 width  150 height      Change the viewing frame size
\   show                       Display image line by line to text screen
\   save portrait.txt          Save the ascii-art image
\   invert show                show the "negative" version of the image
\   normal show                Show the normal image (white background)
\   45 50 xy                   move the frame to column-45 and row-50
\   50 width 30 height         Resize the viewing frame
\   show                       Display the current view
\   save crop.txt              Save current viewing frame to "crop.txt"           
\   move kkm                   Move viewing frame: k=right j=left m=down i=up
\   show                       Show the new viewing area
\   quit                       All done.
\ =======================================================================
\ Example 2:
\ file wldchild.ppm            Load the image
\ shrink info                  Reduce the image by 2x and report new size
\ 135 width  237 height        Change the viewing frame                   
\ show                         Display the current viewing frame
\ save leftsd.txt              Save the view
\ 135 0 xy                     Shift the viewing frame to right side
\ show                         Show the rest of the image
\ save rightsd. txt            Save the view
\ shrink  0 0 xy  show         Reduce the image by 2x and move frame
\ save wldchild.txt            Save the current view
\ quit                         All done.
\ =========================================================================

include lib/interprt.4th 
include lib/anstools.4th   \ for .s in the calculator 

include lib/graphics.4th 
include lib/gview.4th 
include lib/gshrink.4th 
include lib/gcol2gry.4th

variable reduction    1 reduction !   \ count the times image is shrunk 
variable iwidth       \ image width 
variable iheight      \ image height 
81 string gfile       \ graphics file 

70 constant default_width    \ Assuming a sheet of paper 
60 constant default_height 

\ Must define the 'NotFound' for interprt.4th 
:noname 2drop ." Not found!" cr ; is NotFound 

: defaults ( -- ) 
    0 0 view_from ; 

: show ( -- ) 
     iwidth @   pic_width @   reduction @ /  min 
     iheight @  pic_height @  reduction @ /  min 
     show_image ; 

: shrinkit ( -- ) 
     current_view  swap 2/  swap 2/   view_from 
     reduction @  2*  reduction !  shrink ; 

: info ( -- ) cr ."  Current file: " gfile count type cr 
."  Image size     " pic_width @   reduction @  /  . 
                     pic_height @  reduction @  /  .  cr 
."  Display from   " current_view swap . . cr 
."  Display width  " iwidth @ . cr
."  Display height " iheight @ . cr
 cr  ; 

: width_ ( n -- ) iwidth ! ; 
: height_ ( n -- ) iheight ! ; 

: +xy ( nx ny -- )  \ shift upper left corner of viewing frame
     >r current_view >r +  r> r> +  view_from ;  

5 constant sfactor
: lsframe ( -- ) sfactor negate  0 +xy ;
: rsframe ( -- ) sfactor 0 +xy ;
: usframe ( -- ) 0 sfactor negate +xy ;
: dsframe ( -- ) 0 sfactor +xy ;

 create shift_keys             \ Evaluate user string for finer
  char i ,    ' usframe ,      \ placment of the viewing frame
  char m ,    ' dsframe ,
  char j ,    ' lsframe ,
  char k ,    ' rsframe ,
  null , 

: get_string ( -- a n) 
  bl parse-word dup 0=                 \ parse the filename 
  if 1 throw then ;           \ if no filename throw exception   

: shift_it (  c -- ) 
       shift_keys 2 num-key  row if 
        cell+ @c execute 
      then drop ;

: shift_frame ( -- )            \ Shift viewing frame based on 
      get_string                \ keystrokes recorded from user
      0 do
         dup i +  c@ shift_it 
      loop drop ;

: getfile ( --  ) 
         defaults  1 reduction ! 
         get_string 2dup gfile place get_image 
         image_comment$ count type cr 
         info ; 

: saveit ( -- )   \ save current ascii image display
  get_string 
  output open error?        \ value for file 
  abort" File could not be opened"    \ save handle 
  dup use                   \ redirect input to file 
  show close ; 

: isave ( -- )   \ save as ppm-bitmap using current shrink size.
   get_string 
   0 0                              ( rx1 cy1 ) 
   pic_height @  reduction @  /     ( rx2 ) 
   pic_width @   reduction @  /     ( cy2 ) 
   crop ; 

: reload ( -- ) 1 reduction !  defaults  gfile count get_image ; 

\ Calculator executables 
: bye abort ; 
: dot . ; 
: .s_  .s ; 
: dup_ dup ; 
: rot_ rot ; 
: swap_ swap ; 
: plus_ + ; 
: minus_ - ; 
: times_ * ; 
: divide_ / ; 
 
: help  ( -- ) cr 
."  file  <name>  Load the PPM image file" cr
."  save  <name>  Save current display of image" cr 
."  isave <name>  Save as PPM-bitmap" cr
."  info          Current settings" cr 
."  show          Show the ASCII image" cr
."  n n xy        Define the upper corner of image" cr
."  n n +xy       Shift the current viewing frame" cr 
."  move <string> Move: imjk = up/down left/right increments" cr
."  n width       Define the width to display" cr 
."  n height      Define the height to display" cr 
."  invert        Set to display the negative image" cr 
."  normal        Set to display the normal image" cr 
."  shrink        Reduce current image size by two" cr 
."  reload        Reload image to full size" cr
."  grayscale     Bitmap converted to grayscale" cr 
."  + - * / .     Simple 4tH calculator" cr
."  swap dup rot  Simple 4tH calculator" cr
."  quit          Exit the program" cr 
cr ;

\ Dictionary 
create wordset 
  ," quit"   ' bye , 
  ," q"      ' bye , 
  ," bye"    ' bye , 
  ," .s"     ' .s_  , 
  ," ."      ' dot  , 
  ," dup"    ' dup_ , 
  ," rot"    ' rot_ , 
  ," swap"   ' swap_ , 
  ," +"      ' plus_ , 
  ," -"      ' minus_ , 
  ," *"      ' times_ , 
  ," /"      ' divide_ , 
  ," file"   ' getfile , 
  ," save"   ' saveit , 
  ," info"   ' info , 
  ," i"      ' info , 
  ," show"   ' show , 
  ," s"      ' show , 
  ," shrink" ' shrinkit , 
  ," reload" ' reload , 
  ," xy"     ' view_from ,
  ," +xy"    ' +xy , 
  ," move"   ' shift_frame ,
  ," width"  ' width_ , 
  ," height" ' height_ , 
  ," invert" ' invert_text_pixel , 
  ," normal" ' normal_text_pixel ,
  ," grayscale" ' image>grayscale , 
  ," isave"  ' isave , 
  ," help"   ' help , 
  NULL , 
wordset to dictionary                  \ assign to dictionary 

 : initialize 
    argn 1 > 
    if  1 args 2dup  gfile place  get_image 
    else  s" none"  gfile place 
    then 
    default_width iwidth ! 
    default_height iheight !  ; 
 
: title
  cr ." ASCII PPM/PMG image viewer"
  cr ." Maximum image size is " 
  ppm_width .  ppm_height . cr 
  cr ."  help  = viewer commands" cr info ; 
 
: iview 
  initialize defaults title 
  begin                                \ show the prompt and get a command 
    ." OK" cr refill drop              \ interpret and issue oops when needed 
    ['] interpret catch if ." Oops " then 
  again                                \ repeat command loop eternally 
;

iview 
