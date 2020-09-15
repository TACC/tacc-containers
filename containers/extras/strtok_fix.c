#include <stdio.h>
#include <string.h>
char *strtok_r(char *s, const char *delim, char **save_ptr) {
  char *end;
  if( (s == NULL) && (*save_ptr != NULL)) {
    if((*save_ptr)[1] == 0) {
      return NULL;
    }
  }
  if (s == NULL)
    s = *save_ptr;
  if (*s == '\0') {
    *save_ptr = s;
    return NULL;
  }
  s += strspn (s, delim);
  if (*s == '\0') {
    *save_ptr = s;
    return NULL;
  }
  end = s + strcspn (s, delim);
  if (*end == '\0') {
    *save_ptr = end;
    return s;
  }
  *end = '\0';
  *save_ptr = end + 1;
  return s;
}
