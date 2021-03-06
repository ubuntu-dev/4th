\ 4tH SRT subtitle time shift - Copyright 2012,2014 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

include lib/leading.4th                \ for -LEADING
include lib/getopts.4th                \ for GET-OPTIONS
include lib/argopen.4th                \ for ARG-OPEN
include lib/utf8.4th                   \ for PUTWCH
include lib/ulcase.4th                 \ for S>LOWER
include lib/parsexml.4th               \ for PARSE-TAG

3600000 constant hours                 \ an hour in ms
  60000 constant mins                  \ a minute in ms
   1000 constant secs                  \ a second in ms

0 value seq#                           \ sequence number
0 value (shift)                        \ shift in milliseconds

:noname emit ; is putch                \ map EMIT to PUTCH
:noname type ; is (type)               \ map TYPE to (TYPE)

: parse+trim parse -leading -trailing ;
: length? 0 parse+trim nip ;           ( -- len)
: zero? length? 0= ;                   ( -- f)
: (empty) 0  begin drop refill dup while drop dup execute dup until nip ;
: skip-empty ['] length? (empty) ;     ( -- f)
: scan-empty ['] zero? (empty) ;       ( -- f)
: --> bl parse+trim s" -->" compare abort" Arrow expected" ;
: num> parse+trim number error? abort" Number expected" ;
: :00 # 6 base ! # decimal ':' hold ;
: .timestamp <# # # # ',' hold :00 :00 # # #> type ;
: timestamp> ':' num> hours * ':' num> mins * + ',' num> secs * + bl num> + ;
: +shift (shift) + dup 0< ;            ( n -- n+s f)
: skip-subtitle drop drop scan-empty 0= abort" Unexpected end of file" ;
                                       \ write the payload
: .payload                             ( --)
  begin
    refill                             \ get a line
  while                                \ if not end of file
    0 parse+trim dup                   \ check for subtitle
    if (type) cr else 2drop exit then  \ if a subtitle is there print it
  repeat                               \ otherwise return
;
                                       \ parse a subtitle sequence
: parse-subtitle                       ( n1 n2 --)
  seq# 1+ dup to seq# 0 .r cr          \ increase sequence and print it
  .timestamp ."  --> " .timestamp cr   \ rewrite the timestamp
  .payload cr                          \ print the payload
;
                                       \ rewrite all subtitles
: subtitle                             ( --)
  begin
    skip-empty                         \ skip empty lines
  while                                \ if not EOF
    refill 0= abort" Time stamp expected"
    timestamp> --> timestamp> +shift >r swap +shift r> or
    if skip-subtitle else parse-subtitle then
  repeat                               \ rewrite subtitle or skip subtitle
;

: set-lower                            \ set lowercase conversion
  2dup chop s>lower 1- chars + c@ is-alnum >r type r> if '.' emit then
;

: set-nofont                           \ remove <FONT> tags
  2drop 0 dup >in ! >r                 \ drop the string provided and
  begin                                \ reset the buffer; we start over
    parse-tag dup                      \ parse an XML tag
  while                                \ if not end of buffer
    over s" <font" tuck compare 0= >r  \ check for <FONT> tags
    2dup s" </font>" compare 0= r> or  \ and remove them, add space if needed
    if 2drop else r@ if space else r> 1+ >r then type then
  repeat 2drop r> drop
;
                                       \ set UTF8 conversion
: set-utf8 bounds ?do i c@ putwch loop ;

create modes                           \ table with conversion modes
  ' set-utf8     ,                     \ UTF-8 conversion
  ' set-lower    ,                     \ lowercase conversion
  ' set-nofont   ,                     \ no <FONT> conversion
  here modes 1 + - constant #modes
                                       \ get output mode
: get-conversion                       ( --)
  get-argument number error? abort" 'mode' must be a positive number"
  0 max #modes min cells modes + @c is (type)
;
                                       \ get time shift
: get-shift                            ( --)
  get-argument number error? abort" 'ms' must be a number" to (shift)
;
                                       \ options list
create options
  char s , ' get-shift ,
  char c , ' get-conversion ,
  NULL ,
                                       \ get arguments and handle files
: shift-subtitle                       ( --)
  options get-options option-index dup 2 + argn >
  abort" Usage: srtshift -c mode -s milliseconds infile outfile"
  input over arg-open output rot 1+ arg-open subtitle close close
;

shift-subtitle
