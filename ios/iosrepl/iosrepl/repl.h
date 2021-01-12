#ifndef repl_h
#define repl_h

#include <stdlib.h>

int racket_init(const char *, const char *, const char *, const char *);
int repl_eval(char *, char *, size_t);

#endif
