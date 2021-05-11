
_proc1:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:

#include "types.h"
#include "stat.h"
#include "user.h"

int main (int argc, char** argv) {
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp

    printf(1, "proc 1 (pid: %d)\n", getpid());
   9:	e8 e4 02 00 00       	call   2f2 <getpid>
   e:	c7 44 24 04 26 07 00 	movl   $0x726,0x4(%esp)
  15:	00 
  16:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1d:	89 44 24 08          	mov    %eax,0x8(%esp)
  21:	e8 9a 03 00 00       	call   3c0 <printf>
    set_prior(1);
  26:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  2d:	e8 e0 02 00 00       	call   312 <set_prior>
  32:	ba f8 a7 00 00       	mov    $0xa7f8,%edx
  37:	90                   	nop
    int i,k;
    for (i = 0; i < 43000; ++i) {
        asm("nop");
  38:	90                   	nop
  39:	b8 f8 a7 00 00       	mov    $0xa7f8,%eax
  3e:	66 90                	xchg   %ax,%ax
        for (k = 0; k < 43000; ++k) {
            asm("nop");
  40:	90                   	nop
        for (k = 0; k < 43000; ++k) {
  41:	83 e8 01             	sub    $0x1,%eax
  44:	75 fa                	jne    40 <main+0x40>
    for (i = 0; i < 43000; ++i) {
  46:	83 ea 01             	sub    $0x1,%edx
  49:	75 ed                	jne    38 <main+0x38>
        }
    }

    exit();
  4b:	e8 22 02 00 00       	call   272 <exit>

00000050 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	8b 45 08             	mov    0x8(%ebp),%eax
  56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  59:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5a:	89 c2                	mov    %eax,%edx
  5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  60:	83 c1 01             	add    $0x1,%ecx
  63:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  67:	83 c2 01             	add    $0x1,%edx
  6a:	84 db                	test   %bl,%bl
  6c:	88 5a ff             	mov    %bl,-0x1(%edx)
  6f:	75 ef                	jne    60 <strcpy+0x10>
    ;
  return os;
}
  71:	5b                   	pop    %ebx
  72:	5d                   	pop    %ebp
  73:	c3                   	ret    
  74:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  7a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000080 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80:	55                   	push   %ebp
  81:	89 e5                	mov    %esp,%ebp
  83:	8b 55 08             	mov    0x8(%ebp),%edx
  86:	53                   	push   %ebx
  87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  8a:	0f b6 02             	movzbl (%edx),%eax
  8d:	84 c0                	test   %al,%al
  8f:	74 2d                	je     be <strcmp+0x3e>
  91:	0f b6 19             	movzbl (%ecx),%ebx
  94:	38 d8                	cmp    %bl,%al
  96:	74 0e                	je     a6 <strcmp+0x26>
  98:	eb 2b                	jmp    c5 <strcmp+0x45>
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  a0:	38 c8                	cmp    %cl,%al
  a2:	75 15                	jne    b9 <strcmp+0x39>
    p++, q++;
  a4:	89 d9                	mov    %ebx,%ecx
  a6:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
  a9:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  ac:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
  af:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
  b3:	84 c0                	test   %al,%al
  b5:	75 e9                	jne    a0 <strcmp+0x20>
  b7:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  b9:	29 c8                	sub    %ecx,%eax
}
  bb:	5b                   	pop    %ebx
  bc:	5d                   	pop    %ebp
  bd:	c3                   	ret    
  be:	0f b6 09             	movzbl (%ecx),%ecx
  while(*p && *p == *q)
  c1:	31 c0                	xor    %eax,%eax
  c3:	eb f4                	jmp    b9 <strcmp+0x39>
  c5:	0f b6 cb             	movzbl %bl,%ecx
  c8:	eb ef                	jmp    b9 <strcmp+0x39>
  ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000d0 <strlen>:

uint
strlen(const char *s)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  d6:	80 39 00             	cmpb   $0x0,(%ecx)
  d9:	74 12                	je     ed <strlen+0x1d>
  db:	31 d2                	xor    %edx,%edx
  dd:	8d 76 00             	lea    0x0(%esi),%esi
  e0:	83 c2 01             	add    $0x1,%edx
  e3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  e7:	89 d0                	mov    %edx,%eax
  e9:	75 f5                	jne    e0 <strlen+0x10>
    ;
  return n;
}
  eb:	5d                   	pop    %ebp
  ec:	c3                   	ret    
  for(n = 0; s[n]; n++)
  ed:	31 c0                	xor    %eax,%eax
}
  ef:	5d                   	pop    %ebp
  f0:	c3                   	ret    
  f1:	eb 0d                	jmp    100 <memset>
  f3:	90                   	nop
  f4:	90                   	nop
  f5:	90                   	nop
  f6:	90                   	nop
  f7:	90                   	nop
  f8:	90                   	nop
  f9:	90                   	nop
  fa:	90                   	nop
  fb:	90                   	nop
  fc:	90                   	nop
  fd:	90                   	nop
  fe:	90                   	nop
  ff:	90                   	nop

00000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
 106:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 107:	8b 4d 10             	mov    0x10(%ebp),%ecx
 10a:	8b 45 0c             	mov    0xc(%ebp),%eax
 10d:	89 d7                	mov    %edx,%edi
 10f:	fc                   	cld    
 110:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 112:	89 d0                	mov    %edx,%eax
 114:	5f                   	pop    %edi
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    
 117:	89 f6                	mov    %esi,%esi
 119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000120 <strchr>:

char*
strchr(const char *s, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	8b 45 08             	mov    0x8(%ebp),%eax
 126:	53                   	push   %ebx
 127:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 12a:	0f b6 18             	movzbl (%eax),%ebx
 12d:	84 db                	test   %bl,%bl
 12f:	74 1d                	je     14e <strchr+0x2e>
    if(*s == c)
 131:	38 d3                	cmp    %dl,%bl
 133:	89 d1                	mov    %edx,%ecx
 135:	75 0d                	jne    144 <strchr+0x24>
 137:	eb 17                	jmp    150 <strchr+0x30>
 139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 140:	38 ca                	cmp    %cl,%dl
 142:	74 0c                	je     150 <strchr+0x30>
  for(; *s; s++)
 144:	83 c0 01             	add    $0x1,%eax
 147:	0f b6 10             	movzbl (%eax),%edx
 14a:	84 d2                	test   %dl,%dl
 14c:	75 f2                	jne    140 <strchr+0x20>
      return (char*)s;
  return 0;
 14e:	31 c0                	xor    %eax,%eax
}
 150:	5b                   	pop    %ebx
 151:	5d                   	pop    %ebp
 152:	c3                   	ret    
 153:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000160 <gets>:

char*
gets(char *buf, int max)
{
 160:	55                   	push   %ebp
 161:	89 e5                	mov    %esp,%ebp
 163:	57                   	push   %edi
 164:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 165:	31 f6                	xor    %esi,%esi
{
 167:	53                   	push   %ebx
 168:	83 ec 2c             	sub    $0x2c,%esp
    cc = read(0, &c, 1);
 16b:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 16e:	eb 31                	jmp    1a1 <gets+0x41>
    cc = read(0, &c, 1);
 170:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 177:	00 
 178:	89 7c 24 04          	mov    %edi,0x4(%esp)
 17c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 183:	e8 02 01 00 00       	call   28a <read>
    if(cc < 1)
 188:	85 c0                	test   %eax,%eax
 18a:	7e 1d                	jle    1a9 <gets+0x49>
      break;
    buf[i++] = c;
 18c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  for(i=0; i+1 < max; ){
 190:	89 de                	mov    %ebx,%esi
    buf[i++] = c;
 192:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 195:	3c 0d                	cmp    $0xd,%al
    buf[i++] = c;
 197:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 19b:	74 0c                	je     1a9 <gets+0x49>
 19d:	3c 0a                	cmp    $0xa,%al
 19f:	74 08                	je     1a9 <gets+0x49>
  for(i=0; i+1 < max; ){
 1a1:	8d 5e 01             	lea    0x1(%esi),%ebx
 1a4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1a7:	7c c7                	jl     170 <gets+0x10>
      break;
  }
  buf[i] = '\0';
 1a9:	8b 45 08             	mov    0x8(%ebp),%eax
 1ac:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 1b0:	83 c4 2c             	add    $0x2c,%esp
 1b3:	5b                   	pop    %ebx
 1b4:	5e                   	pop    %esi
 1b5:	5f                   	pop    %edi
 1b6:	5d                   	pop    %ebp
 1b7:	c3                   	ret    
 1b8:	90                   	nop
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	55                   	push   %ebp
 1c1:	89 e5                	mov    %esp,%ebp
 1c3:	56                   	push   %esi
 1c4:	53                   	push   %ebx
 1c5:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c8:	8b 45 08             	mov    0x8(%ebp),%eax
 1cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1d2:	00 
 1d3:	89 04 24             	mov    %eax,(%esp)
 1d6:	e8 d7 00 00 00       	call   2b2 <open>
  if(fd < 0)
 1db:	85 c0                	test   %eax,%eax
  fd = open(n, O_RDONLY);
 1dd:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1df:	78 27                	js     208 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 1e1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e4:	89 1c 24             	mov    %ebx,(%esp)
 1e7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1eb:	e8 da 00 00 00       	call   2ca <fstat>
  close(fd);
 1f0:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1f3:	89 c6                	mov    %eax,%esi
  close(fd);
 1f5:	e8 a0 00 00 00       	call   29a <close>
  return r;
 1fa:	89 f0                	mov    %esi,%eax
}
 1fc:	83 c4 10             	add    $0x10,%esp
 1ff:	5b                   	pop    %ebx
 200:	5e                   	pop    %esi
 201:	5d                   	pop    %ebp
 202:	c3                   	ret    
 203:	90                   	nop
 204:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 208:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 20d:	eb ed                	jmp    1fc <stat+0x3c>
 20f:	90                   	nop

00000210 <atoi>:

int
atoi(const char *s)
{
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	8b 4d 08             	mov    0x8(%ebp),%ecx
 216:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 217:	0f be 11             	movsbl (%ecx),%edx
 21a:	8d 42 d0             	lea    -0x30(%edx),%eax
 21d:	3c 09                	cmp    $0x9,%al
  n = 0;
 21f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 224:	77 17                	ja     23d <atoi+0x2d>
 226:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 228:	83 c1 01             	add    $0x1,%ecx
 22b:	8d 04 80             	lea    (%eax,%eax,4),%eax
 22e:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 232:	0f be 11             	movsbl (%ecx),%edx
 235:	8d 5a d0             	lea    -0x30(%edx),%ebx
 238:	80 fb 09             	cmp    $0x9,%bl
 23b:	76 eb                	jbe    228 <atoi+0x18>
  return n;
}
 23d:	5b                   	pop    %ebx
 23e:	5d                   	pop    %ebp
 23f:	c3                   	ret    

00000240 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 240:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 241:	31 d2                	xor    %edx,%edx
{
 243:	89 e5                	mov    %esp,%ebp
 245:	56                   	push   %esi
 246:	8b 45 08             	mov    0x8(%ebp),%eax
 249:	53                   	push   %ebx
 24a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 24d:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0)
 250:	85 db                	test   %ebx,%ebx
 252:	7e 12                	jle    266 <memmove+0x26>
 254:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 258:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 25c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 25f:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 262:	39 da                	cmp    %ebx,%edx
 264:	75 f2                	jne    258 <memmove+0x18>
  return vdst;
}
 266:	5b                   	pop    %ebx
 267:	5e                   	pop    %esi
 268:	5d                   	pop    %ebp
 269:	c3                   	ret    

0000026a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 26a:	b8 01 00 00 00       	mov    $0x1,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <exit>:
SYSCALL(exit)
 272:	b8 02 00 00 00       	mov    $0x2,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <wait>:
SYSCALL(wait)
 27a:	b8 03 00 00 00       	mov    $0x3,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <pipe>:
SYSCALL(pipe)
 282:	b8 04 00 00 00       	mov    $0x4,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <read>:
SYSCALL(read)
 28a:	b8 05 00 00 00       	mov    $0x5,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <write>:
SYSCALL(write)
 292:	b8 10 00 00 00       	mov    $0x10,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <close>:
SYSCALL(close)
 29a:	b8 15 00 00 00       	mov    $0x15,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <kill>:
SYSCALL(kill)
 2a2:	b8 06 00 00 00       	mov    $0x6,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <exec>:
SYSCALL(exec)
 2aa:	b8 07 00 00 00       	mov    $0x7,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <open>:
SYSCALL(open)
 2b2:	b8 0f 00 00 00       	mov    $0xf,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <mknod>:
SYSCALL(mknod)
 2ba:	b8 11 00 00 00       	mov    $0x11,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <unlink>:
SYSCALL(unlink)
 2c2:	b8 12 00 00 00       	mov    $0x12,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <fstat>:
SYSCALL(fstat)
 2ca:	b8 08 00 00 00       	mov    $0x8,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <link>:
SYSCALL(link)
 2d2:	b8 13 00 00 00       	mov    $0x13,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <mkdir>:
SYSCALL(mkdir)
 2da:	b8 14 00 00 00       	mov    $0x14,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <chdir>:
SYSCALL(chdir)
 2e2:	b8 09 00 00 00       	mov    $0x9,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <dup>:
SYSCALL(dup)
 2ea:	b8 0a 00 00 00       	mov    $0xa,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <getpid>:
SYSCALL(getpid)
 2f2:	b8 0b 00 00 00       	mov    $0xb,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <sbrk>:
SYSCALL(sbrk)
 2fa:	b8 0c 00 00 00       	mov    $0xc,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <sleep>:
SYSCALL(sleep)
 302:	b8 0d 00 00 00       	mov    $0xd,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <uptime>:
SYSCALL(uptime)
 30a:	b8 0e 00 00 00       	mov    $0xe,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <set_prior>:
SYSCALL(set_prior)
 312:	b8 16 00 00 00       	mov    $0x16,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    
 31a:	66 90                	xchg   %ax,%ax
 31c:	66 90                	xchg   %ax,%ax
 31e:	66 90                	xchg   %ax,%ax

00000320 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 320:	55                   	push   %ebp
 321:	89 e5                	mov    %esp,%ebp
 323:	57                   	push   %edi
 324:	56                   	push   %esi
 325:	89 c6                	mov    %eax,%esi
 327:	53                   	push   %ebx
 328:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 32b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 32e:	85 db                	test   %ebx,%ebx
 330:	74 09                	je     33b <printint+0x1b>
 332:	89 d0                	mov    %edx,%eax
 334:	c1 e8 1f             	shr    $0x1f,%eax
 337:	84 c0                	test   %al,%al
 339:	75 75                	jne    3b0 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 33b:	89 d0                	mov    %edx,%eax
  neg = 0;
 33d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 344:	89 75 c0             	mov    %esi,-0x40(%ebp)
  }

  i = 0;
 347:	31 ff                	xor    %edi,%edi
 349:	89 ce                	mov    %ecx,%esi
 34b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 34e:	eb 02                	jmp    352 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 350:	89 cf                	mov    %ecx,%edi
 352:	31 d2                	xor    %edx,%edx
 354:	f7 f6                	div    %esi
 356:	8d 4f 01             	lea    0x1(%edi),%ecx
 359:	0f b6 92 3f 07 00 00 	movzbl 0x73f(%edx),%edx
  }while((x /= base) != 0);
 360:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 362:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 365:	75 e9                	jne    350 <printint+0x30>
  if(neg)
 367:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    buf[i++] = digits[x % base];
 36a:	89 c8                	mov    %ecx,%eax
 36c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  if(neg)
 36f:	85 d2                	test   %edx,%edx
 371:	74 08                	je     37b <printint+0x5b>
    buf[i++] = '-';
 373:	8d 4f 02             	lea    0x2(%edi),%ecx
 376:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 37b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 37e:	66 90                	xchg   %ax,%ax
 380:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 385:	83 ef 01             	sub    $0x1,%edi
  write(fd, &c, 1);
 388:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 38f:	00 
 390:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 394:	89 34 24             	mov    %esi,(%esp)
 397:	88 45 d7             	mov    %al,-0x29(%ebp)
 39a:	e8 f3 fe ff ff       	call   292 <write>
  while(--i >= 0)
 39f:	83 ff ff             	cmp    $0xffffffff,%edi
 3a2:	75 dc                	jne    380 <printint+0x60>
    putc(fd, buf[i]);
}
 3a4:	83 c4 4c             	add    $0x4c,%esp
 3a7:	5b                   	pop    %ebx
 3a8:	5e                   	pop    %esi
 3a9:	5f                   	pop    %edi
 3aa:	5d                   	pop    %ebp
 3ab:	c3                   	ret    
 3ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    x = -xx;
 3b0:	89 d0                	mov    %edx,%eax
 3b2:	f7 d8                	neg    %eax
    neg = 1;
 3b4:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 3bb:	eb 87                	jmp    344 <printint+0x24>
 3bd:	8d 76 00             	lea    0x0(%esi),%esi

000003c0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3c4:	31 ff                	xor    %edi,%edi
{
 3c6:	56                   	push   %esi
 3c7:	53                   	push   %ebx
 3c8:	83 ec 3c             	sub    $0x3c,%esp
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  ap = (uint*)(void*)&fmt + 1;
 3ce:	8d 45 10             	lea    0x10(%ebp),%eax
{
 3d1:	8b 75 08             	mov    0x8(%ebp),%esi
  ap = (uint*)(void*)&fmt + 1;
 3d4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 3d7:	0f b6 13             	movzbl (%ebx),%edx
 3da:	83 c3 01             	add    $0x1,%ebx
 3dd:	84 d2                	test   %dl,%dl
 3df:	75 39                	jne    41a <printf+0x5a>
 3e1:	e9 c2 00 00 00       	jmp    4a8 <printf+0xe8>
 3e6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3e8:	83 fa 25             	cmp    $0x25,%edx
 3eb:	0f 84 bf 00 00 00    	je     4b0 <printf+0xf0>
  write(fd, &c, 1);
 3f1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3f4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3fb:	00 
 3fc:	89 44 24 04          	mov    %eax,0x4(%esp)
 400:	89 34 24             	mov    %esi,(%esp)
        state = '%';
      } else {
        putc(fd, c);
 403:	88 55 e2             	mov    %dl,-0x1e(%ebp)
  write(fd, &c, 1);
 406:	e8 87 fe ff ff       	call   292 <write>
 40b:	83 c3 01             	add    $0x1,%ebx
  for(i = 0; fmt[i]; i++){
 40e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 412:	84 d2                	test   %dl,%dl
 414:	0f 84 8e 00 00 00    	je     4a8 <printf+0xe8>
    if(state == 0){
 41a:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 41c:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 41f:	74 c7                	je     3e8 <printf+0x28>
      }
    } else if(state == '%'){
 421:	83 ff 25             	cmp    $0x25,%edi
 424:	75 e5                	jne    40b <printf+0x4b>
      if(c == 'd'){
 426:	83 fa 64             	cmp    $0x64,%edx
 429:	0f 84 31 01 00 00    	je     560 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 42f:	25 f7 00 00 00       	and    $0xf7,%eax
 434:	83 f8 70             	cmp    $0x70,%eax
 437:	0f 84 83 00 00 00    	je     4c0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43d:	83 fa 73             	cmp    $0x73,%edx
 440:	0f 84 a2 00 00 00    	je     4e8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 446:	83 fa 63             	cmp    $0x63,%edx
 449:	0f 84 35 01 00 00    	je     584 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 44f:	83 fa 25             	cmp    $0x25,%edx
 452:	0f 84 e0 00 00 00    	je     538 <printf+0x178>
  write(fd, &c, 1);
 458:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 45b:	83 c3 01             	add    $0x1,%ebx
 45e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 465:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 466:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 468:	89 44 24 04          	mov    %eax,0x4(%esp)
 46c:	89 34 24             	mov    %esi,(%esp)
 46f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 472:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 476:	e8 17 fe ff ff       	call   292 <write>
        putc(fd, c);
 47b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  write(fd, &c, 1);
 47e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 481:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 488:	00 
 489:	89 44 24 04          	mov    %eax,0x4(%esp)
 48d:	89 34 24             	mov    %esi,(%esp)
        putc(fd, c);
 490:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
 493:	e8 fa fd ff ff       	call   292 <write>
  for(i = 0; fmt[i]; i++){
 498:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 49c:	84 d2                	test   %dl,%dl
 49e:	0f 85 76 ff ff ff    	jne    41a <printf+0x5a>
 4a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }
}
 4a8:	83 c4 3c             	add    $0x3c,%esp
 4ab:	5b                   	pop    %ebx
 4ac:	5e                   	pop    %esi
 4ad:	5f                   	pop    %edi
 4ae:	5d                   	pop    %ebp
 4af:	c3                   	ret    
        state = '%';
 4b0:	bf 25 00 00 00       	mov    $0x25,%edi
 4b5:	e9 51 ff ff ff       	jmp    40b <printf+0x4b>
 4ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 4c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4c3:	b9 10 00 00 00       	mov    $0x10,%ecx
      state = 0;
 4c8:	31 ff                	xor    %edi,%edi
        printint(fd, *ap, 16, 0);
 4ca:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4d1:	8b 10                	mov    (%eax),%edx
 4d3:	89 f0                	mov    %esi,%eax
 4d5:	e8 46 fe ff ff       	call   320 <printint>
        ap++;
 4da:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4de:	e9 28 ff ff ff       	jmp    40b <printf+0x4b>
 4e3:	90                   	nop
 4e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 4e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 4eb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        s = (char*)*ap;
 4ef:	8b 38                	mov    (%eax),%edi
          s = "(null)";
 4f1:	b8 38 07 00 00       	mov    $0x738,%eax
 4f6:	85 ff                	test   %edi,%edi
 4f8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 4fb:	0f b6 07             	movzbl (%edi),%eax
 4fe:	84 c0                	test   %al,%al
 500:	74 2a                	je     52c <printf+0x16c>
 502:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 508:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 50b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
          s++;
 50e:	83 c7 01             	add    $0x1,%edi
  write(fd, &c, 1);
 511:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 518:	00 
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	89 34 24             	mov    %esi,(%esp)
 520:	e8 6d fd ff ff       	call   292 <write>
        while(*s != 0){
 525:	0f b6 07             	movzbl (%edi),%eax
 528:	84 c0                	test   %al,%al
 52a:	75 dc                	jne    508 <printf+0x148>
      state = 0;
 52c:	31 ff                	xor    %edi,%edi
 52e:	e9 d8 fe ff ff       	jmp    40b <printf+0x4b>
 533:	90                   	nop
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 538:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      state = 0;
 53b:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 53d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 544:	00 
 545:	89 44 24 04          	mov    %eax,0x4(%esp)
 549:	89 34 24             	mov    %esi,(%esp)
 54c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 550:	e8 3d fd ff ff       	call   292 <write>
 555:	e9 b1 fe ff ff       	jmp    40b <printf+0x4b>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 560:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 563:	b9 0a 00 00 00       	mov    $0xa,%ecx
      state = 0;
 568:	66 31 ff             	xor    %di,%di
        printint(fd, *ap, 10, 1);
 56b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 572:	8b 10                	mov    (%eax),%edx
 574:	89 f0                	mov    %esi,%eax
 576:	e8 a5 fd ff ff       	call   320 <printint>
        ap++;
 57b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 57f:	e9 87 fe ff ff       	jmp    40b <printf+0x4b>
        putc(fd, *ap);
 584:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      state = 0;
 587:	31 ff                	xor    %edi,%edi
        putc(fd, *ap);
 589:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
 58b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 592:	00 
 593:	89 34 24             	mov    %esi,(%esp)
        putc(fd, *ap);
 596:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 599:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 59c:	89 44 24 04          	mov    %eax,0x4(%esp)
 5a0:	e8 ed fc ff ff       	call   292 <write>
        ap++;
 5a5:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 5a9:	e9 5d fe ff ff       	jmp    40b <printf+0x4b>
 5ae:	66 90                	xchg   %ax,%ax

000005b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5b0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b1:	a1 b4 09 00 00       	mov    0x9b4,%eax
{
 5b6:	89 e5                	mov    %esp,%ebp
 5b8:	57                   	push   %edi
 5b9:	56                   	push   %esi
 5ba:	53                   	push   %ebx
 5bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5be:	8b 08                	mov    (%eax),%ecx
  bp = (Header*)ap - 1;
 5c0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c3:	39 d0                	cmp    %edx,%eax
 5c5:	72 11                	jb     5d8 <free+0x28>
 5c7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5c8:	39 c8                	cmp    %ecx,%eax
 5ca:	72 04                	jb     5d0 <free+0x20>
 5cc:	39 ca                	cmp    %ecx,%edx
 5ce:	72 10                	jb     5e0 <free+0x30>
 5d0:	89 c8                	mov    %ecx,%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5d4:	8b 08                	mov    (%eax),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5d6:	73 f0                	jae    5c8 <free+0x18>
 5d8:	39 ca                	cmp    %ecx,%edx
 5da:	72 04                	jb     5e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5dc:	39 c8                	cmp    %ecx,%eax
 5de:	72 f0                	jb     5d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5e0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5e3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5e6:	39 cf                	cmp    %ecx,%edi
 5e8:	74 1e                	je     608 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ea:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5ed:	8b 48 04             	mov    0x4(%eax),%ecx
 5f0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5f3:	39 f2                	cmp    %esi,%edx
 5f5:	74 28                	je     61f <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5f7:	89 10                	mov    %edx,(%eax)
  freep = p;
 5f9:	a3 b4 09 00 00       	mov    %eax,0x9b4
}
 5fe:	5b                   	pop    %ebx
 5ff:	5e                   	pop    %esi
 600:	5f                   	pop    %edi
 601:	5d                   	pop    %ebp
 602:	c3                   	ret    
 603:	90                   	nop
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 608:	03 71 04             	add    0x4(%ecx),%esi
 60b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 60e:	8b 08                	mov    (%eax),%ecx
 610:	8b 09                	mov    (%ecx),%ecx
 612:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 615:	8b 48 04             	mov    0x4(%eax),%ecx
 618:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 61b:	39 f2                	cmp    %esi,%edx
 61d:	75 d8                	jne    5f7 <free+0x47>
    p->s.size += bp->s.size;
 61f:	03 4b fc             	add    -0x4(%ebx),%ecx
  freep = p;
 622:	a3 b4 09 00 00       	mov    %eax,0x9b4
    p->s.size += bp->s.size;
 627:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 62a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 62d:	89 10                	mov    %edx,(%eax)
}
 62f:	5b                   	pop    %ebx
 630:	5e                   	pop    %esi
 631:	5f                   	pop    %edi
 632:	5d                   	pop    %ebp
 633:	c3                   	ret    
 634:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 63a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 64c:	8b 1d b4 09 00 00    	mov    0x9b4,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 652:	8d 48 07             	lea    0x7(%eax),%ecx
 655:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 658:	85 db                	test   %ebx,%ebx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 65a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 65d:	0f 84 9b 00 00 00    	je     6fe <malloc+0xbe>
 663:	8b 13                	mov    (%ebx),%edx
 665:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 668:	39 fe                	cmp    %edi,%esi
 66a:	76 64                	jbe    6d0 <malloc+0x90>
 66c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
  if(nu < 4096)
 673:	bb 00 80 00 00       	mov    $0x8000,%ebx
 678:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 67b:	eb 0e                	jmp    68b <malloc+0x4b>
 67d:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 680:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 682:	8b 78 04             	mov    0x4(%eax),%edi
 685:	39 fe                	cmp    %edi,%esi
 687:	76 4f                	jbe    6d8 <malloc+0x98>
 689:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 68b:	3b 15 b4 09 00 00    	cmp    0x9b4,%edx
 691:	75 ed                	jne    680 <malloc+0x40>
  if(nu < 4096)
 693:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 696:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 69c:	bf 00 10 00 00       	mov    $0x1000,%edi
 6a1:	0f 43 fe             	cmovae %esi,%edi
 6a4:	0f 42 c3             	cmovb  %ebx,%eax
  p = sbrk(nu * sizeof(Header));
 6a7:	89 04 24             	mov    %eax,(%esp)
 6aa:	e8 4b fc ff ff       	call   2fa <sbrk>
  if(p == (char*)-1)
 6af:	83 f8 ff             	cmp    $0xffffffff,%eax
 6b2:	74 18                	je     6cc <malloc+0x8c>
  hp->s.size = nu;
 6b4:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 6b7:	83 c0 08             	add    $0x8,%eax
 6ba:	89 04 24             	mov    %eax,(%esp)
 6bd:	e8 ee fe ff ff       	call   5b0 <free>
  return freep;
 6c2:	8b 15 b4 09 00 00    	mov    0x9b4,%edx
      if((p = morecore(nunits)) == 0)
 6c8:	85 d2                	test   %edx,%edx
 6ca:	75 b4                	jne    680 <malloc+0x40>
        return 0;
 6cc:	31 c0                	xor    %eax,%eax
 6ce:	eb 20                	jmp    6f0 <malloc+0xb0>
    if(p->s.size >= nunits){
 6d0:	89 d0                	mov    %edx,%eax
 6d2:	89 da                	mov    %ebx,%edx
 6d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 6d8:	39 fe                	cmp    %edi,%esi
 6da:	74 1c                	je     6f8 <malloc+0xb8>
        p->s.size -= nunits;
 6dc:	29 f7                	sub    %esi,%edi
 6de:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 6e1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 6e4:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
 6e7:	89 15 b4 09 00 00    	mov    %edx,0x9b4
      return (void*)(p + 1);
 6ed:	83 c0 08             	add    $0x8,%eax
  }
}
 6f0:	83 c4 1c             	add    $0x1c,%esp
 6f3:	5b                   	pop    %ebx
 6f4:	5e                   	pop    %esi
 6f5:	5f                   	pop    %edi
 6f6:	5d                   	pop    %ebp
 6f7:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6f8:	8b 08                	mov    (%eax),%ecx
 6fa:	89 0a                	mov    %ecx,(%edx)
 6fc:	eb e9                	jmp    6e7 <malloc+0xa7>
    base.s.ptr = freep = prevp = &base;
 6fe:	c7 05 b4 09 00 00 b8 	movl   $0x9b8,0x9b4
 705:	09 00 00 
    base.s.size = 0;
 708:	ba b8 09 00 00       	mov    $0x9b8,%edx
    base.s.ptr = freep = prevp = &base;
 70d:	c7 05 b8 09 00 00 b8 	movl   $0x9b8,0x9b8
 714:	09 00 00 
    base.s.size = 0;
 717:	c7 05 bc 09 00 00 00 	movl   $0x0,0x9bc
 71e:	00 00 00 
 721:	e9 46 ff ff ff       	jmp    66c <malloc+0x2c>
