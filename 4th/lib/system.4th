\ 4tH library - SYSTEM - Copyright 2010,2012 J.L. Bezemer
\ You can redistribute this file and/or modify it under
\ the terms of the GNU General Public License

\ Translation of Sun's:

\  int my_system(const char *cmd) 
\  {
\          FILE *p;
\          if ((p = popen(cmd, "w")) == NULL) return (-1);
\          return (pclose(p));
\  }

[UNDEFINED] system [IF]                ( a n -- f)
: system output pipe + open error? tuck if drop else close then ;
[THEN]