
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 20 2e 10 80       	mov    $0x80102e20,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
{
80100049:	83 ec 14             	sub    $0x14,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 00 6e 10 	movl   $0x80106e00,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 e0 41 00 00       	call   80104240 <initlock>
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 07 6e 10 	movl   $0x80106e07,0x4(%esp)
8010009b:	80 
8010009c:	e8 6f 40 00 00       	call   80104110 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000e6:	e8 c5 42 00 00       	call   801043b0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 ba 42 00 00       	call   80104420 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 df 3f 00 00       	call   80104150 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 d2 1f 00 00       	call   80102150 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
  panic("bget: no buffers");
80100188:	c7 04 24 0e 6e 10 80 	movl   $0x80106e0e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 3b 40 00 00       	call   801041f0 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
  iderw(b);
801001c4:	e9 87 1f 00 00       	jmp    80102150 <iderw>
    panic("bwrite");
801001c9:	c7 04 24 1f 6e 10 80 	movl   $0x80106e1f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 fa 3f 00 00       	call   801041f0 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 ae 3f 00 00       	call   801041b0 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 a2 41 00 00       	call   801043b0 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
  release(&bcache.lock);
80100250:	e9 cb 41 00 00       	jmp    80104420 <release>
    panic("brelse");
80100255:	c7 04 24 26 6e 10 80 	movl   $0x80106e26,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 39 15 00 00       	call   801017c0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 1d 41 00 00       	call   801043b0 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 33 34 00 00       	call   801036e0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 b8 3a 00 00       	call   80103d80 <sleep>
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 0a 41 00 00       	call   80104420 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 c2 13 00 00       	call   801016e0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 ec 40 00 00       	call   80104420 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 a4 13 00 00       	call   801016e0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 15 24 00 00       	call   80102790 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 2d 6e 10 80 	movl   $0x80106e2d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 db 77 10 80 	movl   $0x801077db,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 ac 3e 00 00       	call   80104260 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 41 6e 10 80 	movl   $0x80106e41,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 52 55 00 00       	call   80105960 <uartputc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx
  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 
  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 a2 54 00 00       	call   80105960 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 96 54 00 00       	call   80105960 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 8a 54 00 00       	call   80105960 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 0f 40 00 00       	call   80104510 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 52 3f 00 00       	call   80104470 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    panic("pos under/overflow");
8010052a:	c7 04 24 45 6e 10 80 	movl   $0x80106e45,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 70 6e 10 80 	movzbl -0x7fef9190(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>
  if(sign)
801005a8:	85 ff                	test   %edi,%edi
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)
  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 b9 11 00 00       	call   801017c0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 9d 3d 00 00       	call   801043b0 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 e5 3d 00 00       	call   80104420 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 9a 10 00 00       	call   801016e0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 28 3d 00 00       	call   80104420 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 58 6e 10 80       	mov    $0x80106e58,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 14 3c 00 00       	call   801043b0 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>
    panic("null fmt");
801007a1:	c7 04 24 5f 6e 10 80 	movl   $0x80106e5f,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 e6 3b 00 00       	call   801043b0 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 f4 3b 00 00       	call   80104420 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 69 36 00 00       	call   80103f20 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 e4 36 00 00       	jmp    80104010 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 68 6e 10 	movl   $0x80106e68,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 d6 38 00 00       	call   80104240 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100997:	e8 44 19 00 00       	call   801022e0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 2f 2d 00 00       	call   801036e0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 84 21 00 00       	call   80102b40 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 69 15 00 00       	call   80101f30 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 07 0d 00 00       	call   801016e0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 95 0f 00 00       	call   80101990 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 38 0f 00 00       	call   80101940 <iunlockput>
    end_op();
80100a08:	e8 a3 21 00 00       	call   80102bb0 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 1f 61 00 00       	call   80106b50 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 fd 0e 00 00       	call   80101990 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 e9 5e 00 00       	call   801069c0 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 e8 5d 00 00       	call   80106900 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 a2 5f 00 00       	call   80106ad0 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 05 0e 00 00       	call   80101940 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 6b 20 00 00       	call   80102bb0 <end_op>
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 4f 5e 00 00       	call   801069c0 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 47 5f 00 00       	call   80106ad0 <freevm>
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
    end_op();
80100b93:	e8 18 20 00 00       	call   80102bb0 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 81 6e 10 80 	movl   $0x80106e81,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 33 60 00 00       	call   80106c00 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 8c 01 00 00    	je     80100d66 <exec+0x3c6>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 8a 3a 00 00       	call   80104690 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 79 3a 00 00       	call   80104690 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 2a 61 00 00       	call   80106d60 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx
  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 b7 60 00 00       	call   80106d60 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 5a 39 00 00       	call   80104650 <safestrcpy>
    acquire(&tickslock);
80100cf6:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80100cfd:	e8 ae 36 00 00       	call   801043b0 <acquire>
    curproc->start_time = ticks;
80100d02:	a1 a0 58 11 80       	mov    0x801158a0,%eax
    curproc->burst_time = 0;
80100d07:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
80100d0e:	00 00 00 
    curproc->start_time = ticks;
80100d11:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
    curproc->last_burst_time_ticks = ticks;
80100d17:	89 87 88 00 00 00    	mov    %eax,0x88(%edi)
    release(&tickslock);
80100d1d:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80100d24:	e8 f7 36 00 00       	call   80104420 <release>
  curproc->pgdir = pgdir;
80100d29:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  oldpgdir = curproc->pgdir;
80100d2f:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
80100d32:	89 47 04             	mov    %eax,0x4(%edi)
  curproc->sz = sz;
80100d35:	8b 85 e8 fe ff ff    	mov    -0x118(%ebp),%eax
80100d3b:	89 07                	mov    %eax,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d3d:	8b 47 18             	mov    0x18(%edi),%eax
80100d40:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d46:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d49:	8b 47 18             	mov    0x18(%edi),%eax
80100d4c:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d4f:	89 3c 24             	mov    %edi,(%esp)
80100d52:	e8 19 5a 00 00       	call   80106770 <switchuvm>
  freevm(oldpgdir);
80100d57:	89 34 24             	mov    %esi,(%esp)
80100d5a:	e8 71 5d 00 00       	call   80106ad0 <freevm>
  return 0;
80100d5f:	31 c0                	xor    %eax,%eax
80100d61:	e9 ac fc ff ff       	jmp    80100a12 <exec+0x72>
  for(argc = 0; argv[argc]; argc++) {
80100d66:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d6c:	31 d2                	xor    %edx,%edx
80100d6e:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d74:	e9 e5 fe ff ff       	jmp    80100c5e <exec+0x2be>
80100d79:	66 90                	xchg   %ax,%ax
80100d7b:	66 90                	xchg   %ax,%ax
80100d7d:	66 90                	xchg   %ax,%ax
80100d7f:	90                   	nop

80100d80 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d86:	c7 44 24 04 8d 6e 10 	movl   $0x80106e8d,0x4(%esp)
80100d8d:	80 
80100d8e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d95:	e8 a6 34 00 00       	call   80104240 <initlock>
}
80100d9a:	c9                   	leave  
80100d9b:	c3                   	ret    
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100da0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100da0:	55                   	push   %ebp
80100da1:	89 e5                	mov    %esp,%ebp
80100da3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da4:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
{
80100da9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ftable.lock);
80100dac:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100db3:	e8 f8 35 00 00       	call   801043b0 <acquire>
80100db8:	eb 11                	jmp    80100dcb <filealloc+0x2b>
80100dba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100dc0:	83 c3 18             	add    $0x18,%ebx
80100dc3:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100dc9:	74 25                	je     80100df0 <filealloc+0x50>
    if(f->ref == 0){
80100dcb:	8b 43 04             	mov    0x4(%ebx),%eax
80100dce:	85 c0                	test   %eax,%eax
80100dd0:	75 ee                	jne    80100dc0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100dd2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
      f->ref = 1;
80100dd9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100de0:	e8 3b 36 00 00       	call   80104420 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100de5:	83 c4 14             	add    $0x14,%esp
      return f;
80100de8:	89 d8                	mov    %ebx,%eax
}
80100dea:	5b                   	pop    %ebx
80100deb:	5d                   	pop    %ebp
80100dec:	c3                   	ret    
80100ded:	8d 76 00             	lea    0x0(%esi),%esi
  release(&ftable.lock);
80100df0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df7:	e8 24 36 00 00       	call   80104420 <release>
}
80100dfc:	83 c4 14             	add    $0x14,%esp
  return 0;
80100dff:	31 c0                	xor    %eax,%eax
}
80100e01:	5b                   	pop    %ebx
80100e02:	5d                   	pop    %ebp
80100e03:	c3                   	ret    
80100e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100e10 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100e10:	55                   	push   %ebp
80100e11:	89 e5                	mov    %esp,%ebp
80100e13:	53                   	push   %ebx
80100e14:	83 ec 14             	sub    $0x14,%esp
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100e1a:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e21:	e8 8a 35 00 00       	call   801043b0 <acquire>
  if(f->ref < 1)
80100e26:	8b 43 04             	mov    0x4(%ebx),%eax
80100e29:	85 c0                	test   %eax,%eax
80100e2b:	7e 1a                	jle    80100e47 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100e2d:	83 c0 01             	add    $0x1,%eax
80100e30:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e33:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e3a:	e8 e1 35 00 00       	call   80104420 <release>
  return f;
}
80100e3f:	83 c4 14             	add    $0x14,%esp
80100e42:	89 d8                	mov    %ebx,%eax
80100e44:	5b                   	pop    %ebx
80100e45:	5d                   	pop    %ebp
80100e46:	c3                   	ret    
    panic("filedup");
80100e47:	c7 04 24 94 6e 10 80 	movl   $0x80106e94,(%esp)
80100e4e:	e8 0d f5 ff ff       	call   80100360 <panic>
80100e53:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e60 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e60:	55                   	push   %ebp
80100e61:	89 e5                	mov    %esp,%ebp
80100e63:	57                   	push   %edi
80100e64:	56                   	push   %esi
80100e65:	53                   	push   %ebx
80100e66:	83 ec 1c             	sub    $0x1c,%esp
80100e69:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e6c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e73:	e8 38 35 00 00       	call   801043b0 <acquire>
  if(f->ref < 1)
80100e78:	8b 57 04             	mov    0x4(%edi),%edx
80100e7b:	85 d2                	test   %edx,%edx
80100e7d:	0f 8e 89 00 00 00    	jle    80100f0c <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e83:	83 ea 01             	sub    $0x1,%edx
80100e86:	85 d2                	test   %edx,%edx
80100e88:	89 57 04             	mov    %edx,0x4(%edi)
80100e8b:	74 13                	je     80100ea0 <fileclose+0x40>
    release(&ftable.lock);
80100e8d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e94:	83 c4 1c             	add    $0x1c,%esp
80100e97:	5b                   	pop    %ebx
80100e98:	5e                   	pop    %esi
80100e99:	5f                   	pop    %edi
80100e9a:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e9b:	e9 80 35 00 00       	jmp    80104420 <release>
  ff = *f;
80100ea0:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100ea4:	8b 37                	mov    (%edi),%esi
80100ea6:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->type = FD_NONE;
80100ea9:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
  ff = *f;
80100eaf:	88 45 e7             	mov    %al,-0x19(%ebp)
80100eb2:	8b 47 10             	mov    0x10(%edi),%eax
  release(&ftable.lock);
80100eb5:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  ff = *f;
80100ebc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ebf:	e8 5c 35 00 00       	call   80104420 <release>
  if(ff.type == FD_PIPE)
80100ec4:	83 fe 01             	cmp    $0x1,%esi
80100ec7:	74 0f                	je     80100ed8 <fileclose+0x78>
  else if(ff.type == FD_INODE){
80100ec9:	83 fe 02             	cmp    $0x2,%esi
80100ecc:	74 22                	je     80100ef0 <fileclose+0x90>
}
80100ece:	83 c4 1c             	add    $0x1c,%esp
80100ed1:	5b                   	pop    %ebx
80100ed2:	5e                   	pop    %esi
80100ed3:	5f                   	pop    %edi
80100ed4:	5d                   	pop    %ebp
80100ed5:	c3                   	ret    
80100ed6:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80100ed8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100edc:	89 1c 24             	mov    %ebx,(%esp)
80100edf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100ee3:	e8 a8 23 00 00       	call   80103290 <pipeclose>
80100ee8:	eb e4                	jmp    80100ece <fileclose+0x6e>
80100eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    begin_op();
80100ef0:	e8 4b 1c 00 00       	call   80102b40 <begin_op>
    iput(ff.ip);
80100ef5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ef8:	89 04 24             	mov    %eax,(%esp)
80100efb:	e8 00 09 00 00       	call   80101800 <iput>
}
80100f00:	83 c4 1c             	add    $0x1c,%esp
80100f03:	5b                   	pop    %ebx
80100f04:	5e                   	pop    %esi
80100f05:	5f                   	pop    %edi
80100f06:	5d                   	pop    %ebp
    end_op();
80100f07:	e9 a4 1c 00 00       	jmp    80102bb0 <end_op>
    panic("fileclose");
80100f0c:	c7 04 24 9c 6e 10 80 	movl   $0x80106e9c,(%esp)
80100f13:	e8 48 f4 ff ff       	call   80100360 <panic>
80100f18:	90                   	nop
80100f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f20 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f20:	55                   	push   %ebp
80100f21:	89 e5                	mov    %esp,%ebp
80100f23:	53                   	push   %ebx
80100f24:	83 ec 14             	sub    $0x14,%esp
80100f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f2a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f2d:	75 31                	jne    80100f60 <filestat+0x40>
    ilock(f->ip);
80100f2f:	8b 43 10             	mov    0x10(%ebx),%eax
80100f32:	89 04 24             	mov    %eax,(%esp)
80100f35:	e8 a6 07 00 00       	call   801016e0 <ilock>
    stati(f->ip, st);
80100f3a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f3d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f41:	8b 43 10             	mov    0x10(%ebx),%eax
80100f44:	89 04 24             	mov    %eax,(%esp)
80100f47:	e8 14 0a 00 00       	call   80101960 <stati>
    iunlock(f->ip);
80100f4c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f4f:	89 04 24             	mov    %eax,(%esp)
80100f52:	e8 69 08 00 00       	call   801017c0 <iunlock>
    return 0;
  }
  return -1;
}
80100f57:	83 c4 14             	add    $0x14,%esp
    return 0;
80100f5a:	31 c0                	xor    %eax,%eax
}
80100f5c:	5b                   	pop    %ebx
80100f5d:	5d                   	pop    %ebp
80100f5e:	c3                   	ret    
80100f5f:	90                   	nop
80100f60:	83 c4 14             	add    $0x14,%esp
  return -1;
80100f63:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f68:	5b                   	pop    %ebx
80100f69:	5d                   	pop    %ebp
80100f6a:	c3                   	ret    
80100f6b:	90                   	nop
80100f6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f70 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f70:	55                   	push   %ebp
80100f71:	89 e5                	mov    %esp,%ebp
80100f73:	57                   	push   %edi
80100f74:	56                   	push   %esi
80100f75:	53                   	push   %ebx
80100f76:	83 ec 1c             	sub    $0x1c,%esp
80100f79:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f7f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f82:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f86:	74 68                	je     80100ff0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f88:	8b 03                	mov    (%ebx),%eax
80100f8a:	83 f8 01             	cmp    $0x1,%eax
80100f8d:	74 49                	je     80100fd8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f8f:	83 f8 02             	cmp    $0x2,%eax
80100f92:	75 63                	jne    80100ff7 <fileread+0x87>
    ilock(f->ip);
80100f94:	8b 43 10             	mov    0x10(%ebx),%eax
80100f97:	89 04 24             	mov    %eax,(%esp)
80100f9a:	e8 41 07 00 00       	call   801016e0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100fa3:	8b 43 14             	mov    0x14(%ebx),%eax
80100fa6:	89 74 24 04          	mov    %esi,0x4(%esp)
80100faa:	89 44 24 08          	mov    %eax,0x8(%esp)
80100fae:	8b 43 10             	mov    0x10(%ebx),%eax
80100fb1:	89 04 24             	mov    %eax,(%esp)
80100fb4:	e8 d7 09 00 00       	call   80101990 <readi>
80100fb9:	85 c0                	test   %eax,%eax
80100fbb:	89 c6                	mov    %eax,%esi
80100fbd:	7e 03                	jle    80100fc2 <fileread+0x52>
      f->off += r;
80100fbf:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fc2:	8b 43 10             	mov    0x10(%ebx),%eax
80100fc5:	89 04 24             	mov    %eax,(%esp)
80100fc8:	e8 f3 07 00 00       	call   801017c0 <iunlock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fcd:	89 f0                	mov    %esi,%eax
    return r;
  }
  panic("fileread");
}
80100fcf:	83 c4 1c             	add    $0x1c,%esp
80100fd2:	5b                   	pop    %ebx
80100fd3:	5e                   	pop    %esi
80100fd4:	5f                   	pop    %edi
80100fd5:	5d                   	pop    %ebp
80100fd6:	c3                   	ret    
80100fd7:	90                   	nop
    return piperead(f->pipe, addr, n);
80100fd8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fdb:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fde:	83 c4 1c             	add    $0x1c,%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fe5:	e9 26 24 00 00       	jmp    80103410 <piperead>
80100fea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100ff0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ff5:	eb d8                	jmp    80100fcf <fileread+0x5f>
  panic("fileread");
80100ff7:	c7 04 24 a6 6e 10 80 	movl   $0x80106ea6,(%esp)
80100ffe:	e8 5d f3 ff ff       	call   80100360 <panic>
80101003:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101010 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101010:	55                   	push   %ebp
80101011:	89 e5                	mov    %esp,%ebp
80101013:	57                   	push   %edi
80101014:	56                   	push   %esi
80101015:	53                   	push   %ebx
80101016:	83 ec 2c             	sub    $0x2c,%esp
80101019:	8b 45 0c             	mov    0xc(%ebp),%eax
8010101c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010101f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101022:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101025:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)
{
80101029:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010102c:	0f 84 ae 00 00 00    	je     801010e0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101032:	8b 07                	mov    (%edi),%eax
80101034:	83 f8 01             	cmp    $0x1,%eax
80101037:	0f 84 c2 00 00 00    	je     801010ff <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010103d:	83 f8 02             	cmp    $0x2,%eax
80101040:	0f 85 d7 00 00 00    	jne    8010111d <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101049:	31 db                	xor    %ebx,%ebx
8010104b:	85 c0                	test   %eax,%eax
8010104d:	7f 31                	jg     80101080 <filewrite+0x70>
8010104f:	e9 9c 00 00 00       	jmp    801010f0 <filewrite+0xe0>
80101054:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101058:	8b 4f 10             	mov    0x10(%edi),%ecx
        f->off += r;
8010105b:	01 47 14             	add    %eax,0x14(%edi)
8010105e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101061:	89 0c 24             	mov    %ecx,(%esp)
80101064:	e8 57 07 00 00       	call   801017c0 <iunlock>
      end_op();
80101069:	e8 42 1b 00 00       	call   80102bb0 <end_op>
8010106e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101071:	39 f0                	cmp    %esi,%eax
80101073:	0f 85 98 00 00 00    	jne    80101111 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101079:	01 c3                	add    %eax,%ebx
    while(i < n){
8010107b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010107e:	7e 70                	jle    801010f0 <filewrite+0xe0>
      int n1 = n - i;
80101080:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101083:	b8 00 06 00 00       	mov    $0x600,%eax
80101088:	29 de                	sub    %ebx,%esi
8010108a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101090:	0f 4f f0             	cmovg  %eax,%esi
      begin_op();
80101093:	e8 a8 1a 00 00       	call   80102b40 <begin_op>
      ilock(f->ip);
80101098:	8b 47 10             	mov    0x10(%edi),%eax
8010109b:	89 04 24             	mov    %eax,(%esp)
8010109e:	e8 3d 06 00 00       	call   801016e0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801010a3:	89 74 24 0c          	mov    %esi,0xc(%esp)
801010a7:	8b 47 14             	mov    0x14(%edi),%eax
801010aa:	89 44 24 08          	mov    %eax,0x8(%esp)
801010ae:	8b 45 dc             	mov    -0x24(%ebp),%eax
801010b1:	01 d8                	add    %ebx,%eax
801010b3:	89 44 24 04          	mov    %eax,0x4(%esp)
801010b7:	8b 47 10             	mov    0x10(%edi),%eax
801010ba:	89 04 24             	mov    %eax,(%esp)
801010bd:	e8 ce 09 00 00       	call   80101a90 <writei>
801010c2:	85 c0                	test   %eax,%eax
801010c4:	7f 92                	jg     80101058 <filewrite+0x48>
      iunlock(f->ip);
801010c6:	8b 4f 10             	mov    0x10(%edi),%ecx
801010c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010cc:	89 0c 24             	mov    %ecx,(%esp)
801010cf:	e8 ec 06 00 00       	call   801017c0 <iunlock>
      end_op();
801010d4:	e8 d7 1a 00 00       	call   80102bb0 <end_op>
      if(r < 0)
801010d9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010dc:	85 c0                	test   %eax,%eax
801010de:	74 91                	je     80101071 <filewrite+0x61>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010e0:	83 c4 2c             	add    $0x2c,%esp
    return -1;
801010e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010e8:	5b                   	pop    %ebx
801010e9:	5e                   	pop    %esi
801010ea:	5f                   	pop    %edi
801010eb:	5d                   	pop    %ebp
801010ec:	c3                   	ret    
801010ed:	8d 76 00             	lea    0x0(%esi),%esi
    return i == n ? n : -1;
801010f0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010f3:	89 d8                	mov    %ebx,%eax
801010f5:	75 e9                	jne    801010e0 <filewrite+0xd0>
}
801010f7:	83 c4 2c             	add    $0x2c,%esp
801010fa:	5b                   	pop    %ebx
801010fb:	5e                   	pop    %esi
801010fc:	5f                   	pop    %edi
801010fd:	5d                   	pop    %ebp
801010fe:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
801010ff:	8b 47 0c             	mov    0xc(%edi),%eax
80101102:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101105:	83 c4 2c             	add    $0x2c,%esp
80101108:	5b                   	pop    %ebx
80101109:	5e                   	pop    %esi
8010110a:	5f                   	pop    %edi
8010110b:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
8010110c:	e9 0f 22 00 00       	jmp    80103320 <pipewrite>
        panic("short filewrite");
80101111:	c7 04 24 af 6e 10 80 	movl   $0x80106eaf,(%esp)
80101118:	e8 43 f2 ff ff       	call   80100360 <panic>
  panic("filewrite");
8010111d:	c7 04 24 b5 6e 10 80 	movl   $0x80106eb5,(%esp)
80101124:	e8 37 f2 ff ff       	call   80100360 <panic>
80101129:	66 90                	xchg   %ax,%ax
8010112b:	66 90                	xchg   %ax,%ax
8010112d:	66 90                	xchg   %ax,%ax
8010112f:	90                   	nop

80101130 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101130:	55                   	push   %ebp
80101131:	89 e5                	mov    %esp,%ebp
80101133:	57                   	push   %edi
80101134:	89 d7                	mov    %edx,%edi
80101136:	56                   	push   %esi
80101137:	53                   	push   %ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101138:	bb 01 00 00 00       	mov    $0x1,%ebx
{
8010113d:	83 ec 1c             	sub    $0x1c,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101140:	c1 ea 0c             	shr    $0xc,%edx
80101143:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101149:	89 04 24             	mov    %eax,(%esp)
8010114c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101150:	e8 7b ef ff ff       	call   801000d0 <bread>
  m = 1 << (bi % 8);
80101155:	89 f9                	mov    %edi,%ecx
  bi = b % BPB;
80101157:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
8010115d:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
8010115f:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101162:	c1 fa 03             	sar    $0x3,%edx
  m = 1 << (bi % 8);
80101165:	d3 e3                	shl    %cl,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101167:	89 c6                	mov    %eax,%esi
  if((bp->data[bi/8] & m) == 0)
80101169:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
8010116e:	0f b6 c8             	movzbl %al,%ecx
80101171:	85 d9                	test   %ebx,%ecx
80101173:	74 20                	je     80101195 <bfree+0x65>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101175:	f7 d3                	not    %ebx
80101177:	21 c3                	and    %eax,%ebx
80101179:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
8010117d:	89 34 24             	mov    %esi,(%esp)
80101180:	e8 5b 1b 00 00       	call   80102ce0 <log_write>
  brelse(bp);
80101185:	89 34 24             	mov    %esi,(%esp)
80101188:	e8 53 f0 ff ff       	call   801001e0 <brelse>
}
8010118d:	83 c4 1c             	add    $0x1c,%esp
80101190:	5b                   	pop    %ebx
80101191:	5e                   	pop    %esi
80101192:	5f                   	pop    %edi
80101193:	5d                   	pop    %ebp
80101194:	c3                   	ret    
    panic("freeing free block");
80101195:	c7 04 24 bf 6e 10 80 	movl   $0x80106ebf,(%esp)
8010119c:	e8 bf f1 ff ff       	call   80100360 <panic>
801011a1:	eb 0d                	jmp    801011b0 <balloc>
801011a3:	90                   	nop
801011a4:	90                   	nop
801011a5:	90                   	nop
801011a6:	90                   	nop
801011a7:	90                   	nop
801011a8:	90                   	nop
801011a9:	90                   	nop
801011aa:	90                   	nop
801011ab:	90                   	nop
801011ac:	90                   	nop
801011ad:	90                   	nop
801011ae:	90                   	nop
801011af:	90                   	nop

801011b0 <balloc>:
{
801011b0:	55                   	push   %ebp
801011b1:	89 e5                	mov    %esp,%ebp
801011b3:	57                   	push   %edi
801011b4:	56                   	push   %esi
801011b5:	53                   	push   %ebx
801011b6:	83 ec 2c             	sub    $0x2c,%esp
801011b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801011bc:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011c1:	85 c0                	test   %eax,%eax
801011c3:	0f 84 8c 00 00 00    	je     80101255 <balloc+0xa5>
801011c9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011d0:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011d3:	89 f0                	mov    %esi,%eax
801011d5:	c1 f8 0c             	sar    $0xc,%eax
801011d8:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801011de:	89 44 24 04          	mov    %eax,0x4(%esp)
801011e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011e5:	89 04 24             	mov    %eax,(%esp)
801011e8:	e8 e3 ee ff ff       	call   801000d0 <bread>
801011ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011f0:	a1 c0 09 11 80       	mov    0x801109c0,%eax
801011f5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011f8:	31 c0                	xor    %eax,%eax
801011fa:	eb 33                	jmp    8010122f <balloc+0x7f>
801011fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101200:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101203:	89 c2                	mov    %eax,%edx
      m = 1 << (bi % 8);
80101205:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101207:	c1 fa 03             	sar    $0x3,%edx
      m = 1 << (bi % 8);
8010120a:	83 e1 07             	and    $0x7,%ecx
8010120d:	bf 01 00 00 00       	mov    $0x1,%edi
80101212:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101214:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx
      m = 1 << (bi % 8);
80101219:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010121b:	0f b6 fb             	movzbl %bl,%edi
8010121e:	85 cf                	test   %ecx,%edi
80101220:	74 46                	je     80101268 <balloc+0xb8>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101222:	83 c0 01             	add    $0x1,%eax
80101225:	83 c6 01             	add    $0x1,%esi
80101228:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010122d:	74 05                	je     80101234 <balloc+0x84>
8010122f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101232:	72 cc                	jb     80101200 <balloc+0x50>
    brelse(bp);
80101234:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101237:	89 04 24             	mov    %eax,(%esp)
8010123a:	e8 a1 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010123f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101246:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101249:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010124f:	0f 82 7b ff ff ff    	jb     801011d0 <balloc+0x20>
  panic("balloc: out of blocks");
80101255:	c7 04 24 d2 6e 10 80 	movl   $0x80106ed2,(%esp)
8010125c:	e8 ff f0 ff ff       	call   80100360 <panic>
80101261:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        bp->data[bi/8] |= m;  // Mark block in use.
80101268:	09 d9                	or     %ebx,%ecx
8010126a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010126d:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
80101271:	89 1c 24             	mov    %ebx,(%esp)
80101274:	e8 67 1a 00 00       	call   80102ce0 <log_write>
        brelse(bp);
80101279:	89 1c 24             	mov    %ebx,(%esp)
8010127c:	e8 5f ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
80101281:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101284:	89 74 24 04          	mov    %esi,0x4(%esp)
80101288:	89 04 24             	mov    %eax,(%esp)
8010128b:	e8 40 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
80101290:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80101297:	00 
80101298:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010129f:	00 
  bp = bread(dev, bno);
801012a0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801012a2:	8d 40 5c             	lea    0x5c(%eax),%eax
801012a5:	89 04 24             	mov    %eax,(%esp)
801012a8:	e8 c3 31 00 00       	call   80104470 <memset>
  log_write(bp);
801012ad:	89 1c 24             	mov    %ebx,(%esp)
801012b0:	e8 2b 1a 00 00       	call   80102ce0 <log_write>
  brelse(bp);
801012b5:	89 1c 24             	mov    %ebx,(%esp)
801012b8:	e8 23 ef ff ff       	call   801001e0 <brelse>
}
801012bd:	83 c4 2c             	add    $0x2c,%esp
801012c0:	89 f0                	mov    %esi,%eax
801012c2:	5b                   	pop    %ebx
801012c3:	5e                   	pop    %esi
801012c4:	5f                   	pop    %edi
801012c5:	5d                   	pop    %ebp
801012c6:	c3                   	ret    
801012c7:	89 f6                	mov    %esi,%esi
801012c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801012d0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	89 c7                	mov    %eax,%edi
801012d6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801012d7:	31 f6                	xor    %esi,%esi
{
801012d9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012da:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
{
801012df:	83 ec 1c             	sub    $0x1c,%esp
  acquire(&icache.lock);
801012e2:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
{
801012e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012ec:	e8 bf 30 00 00       	call   801043b0 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012f4:	eb 14                	jmp    8010130a <iget+0x3a>
801012f6:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012f8:	85 f6                	test   %esi,%esi
801012fa:	74 3c                	je     80101338 <iget+0x68>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012fc:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101302:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101308:	74 46                	je     80101350 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010130a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010130d:	85 c9                	test   %ecx,%ecx
8010130f:	7e e7                	jle    801012f8 <iget+0x28>
80101311:	39 3b                	cmp    %edi,(%ebx)
80101313:	75 e3                	jne    801012f8 <iget+0x28>
80101315:	39 53 04             	cmp    %edx,0x4(%ebx)
80101318:	75 de                	jne    801012f8 <iget+0x28>
      ip->ref++;
8010131a:	83 c1 01             	add    $0x1,%ecx
      return ip;
8010131d:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010131f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
      ip->ref++;
80101326:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101329:	e8 f2 30 00 00       	call   80104420 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010132e:	83 c4 1c             	add    $0x1c,%esp
80101331:	89 f0                	mov    %esi,%eax
80101333:	5b                   	pop    %ebx
80101334:	5e                   	pop    %esi
80101335:	5f                   	pop    %edi
80101336:	5d                   	pop    %ebp
80101337:	c3                   	ret    
80101338:	85 c9                	test   %ecx,%ecx
8010133a:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010133d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101343:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101349:	75 bf                	jne    8010130a <iget+0x3a>
8010134b:	90                   	nop
8010134c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(empty == 0)
80101350:	85 f6                	test   %esi,%esi
80101352:	74 29                	je     8010137d <iget+0xad>
  ip->dev = dev;
80101354:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101356:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101359:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101360:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101367:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010136e:	e8 ad 30 00 00       	call   80104420 <release>
}
80101373:	83 c4 1c             	add    $0x1c,%esp
80101376:	89 f0                	mov    %esi,%eax
80101378:	5b                   	pop    %ebx
80101379:	5e                   	pop    %esi
8010137a:	5f                   	pop    %edi
8010137b:	5d                   	pop    %ebp
8010137c:	c3                   	ret    
    panic("iget: no inodes");
8010137d:	c7 04 24 e8 6e 10 80 	movl   $0x80106ee8,(%esp)
80101384:	e8 d7 ef ff ff       	call   80100360 <panic>
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101390 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101390:	55                   	push   %ebp
80101391:	89 e5                	mov    %esp,%ebp
80101393:	57                   	push   %edi
80101394:	56                   	push   %esi
80101395:	53                   	push   %ebx
80101396:	89 c3                	mov    %eax,%ebx
80101398:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010139b:	83 fa 0b             	cmp    $0xb,%edx
8010139e:	77 18                	ja     801013b8 <bmap+0x28>
801013a0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801013a3:	8b 46 5c             	mov    0x5c(%esi),%eax
801013a6:	85 c0                	test   %eax,%eax
801013a8:	74 66                	je     80101410 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801013aa:	83 c4 1c             	add    $0x1c,%esp
801013ad:	5b                   	pop    %ebx
801013ae:	5e                   	pop    %esi
801013af:	5f                   	pop    %edi
801013b0:	5d                   	pop    %ebp
801013b1:	c3                   	ret    
801013b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;
801013b8:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801013bb:	83 fe 7f             	cmp    $0x7f,%esi
801013be:	77 77                	ja     80101437 <bmap+0xa7>
    if((addr = ip->addrs[NDIRECT]) == 0)
801013c0:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801013c6:	85 c0                	test   %eax,%eax
801013c8:	74 5e                	je     80101428 <bmap+0x98>
    bp = bread(ip->dev, addr);
801013ca:	89 44 24 04          	mov    %eax,0x4(%esp)
801013ce:	8b 03                	mov    (%ebx),%eax
801013d0:	89 04 24             	mov    %eax,(%esp)
801013d3:	e8 f8 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
801013d8:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx
    bp = bread(ip->dev, addr);
801013dc:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801013de:	8b 32                	mov    (%edx),%esi
801013e0:	85 f6                	test   %esi,%esi
801013e2:	75 19                	jne    801013fd <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
801013e4:	8b 03                	mov    (%ebx),%eax
801013e6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801013e9:	e8 c2 fd ff ff       	call   801011b0 <balloc>
801013ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013f1:	89 02                	mov    %eax,(%edx)
801013f3:	89 c6                	mov    %eax,%esi
      log_write(bp);
801013f5:	89 3c 24             	mov    %edi,(%esp)
801013f8:	e8 e3 18 00 00       	call   80102ce0 <log_write>
    brelse(bp);
801013fd:	89 3c 24             	mov    %edi,(%esp)
80101400:	e8 db ed ff ff       	call   801001e0 <brelse>
}
80101405:	83 c4 1c             	add    $0x1c,%esp
    brelse(bp);
80101408:	89 f0                	mov    %esi,%eax
}
8010140a:	5b                   	pop    %ebx
8010140b:	5e                   	pop    %esi
8010140c:	5f                   	pop    %edi
8010140d:	5d                   	pop    %ebp
8010140e:	c3                   	ret    
8010140f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101410:	8b 03                	mov    (%ebx),%eax
80101412:	e8 99 fd ff ff       	call   801011b0 <balloc>
80101417:	89 46 5c             	mov    %eax,0x5c(%esi)
}
8010141a:	83 c4 1c             	add    $0x1c,%esp
8010141d:	5b                   	pop    %ebx
8010141e:	5e                   	pop    %esi
8010141f:	5f                   	pop    %edi
80101420:	5d                   	pop    %ebp
80101421:	c3                   	ret    
80101422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101428:	8b 03                	mov    (%ebx),%eax
8010142a:	e8 81 fd ff ff       	call   801011b0 <balloc>
8010142f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101435:	eb 93                	jmp    801013ca <bmap+0x3a>
  panic("bmap: out of range");
80101437:	c7 04 24 f8 6e 10 80 	movl   $0x80106ef8,(%esp)
8010143e:	e8 1d ef ff ff       	call   80100360 <panic>
80101443:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101450 <readsb>:
{
80101450:	55                   	push   %ebp
80101451:	89 e5                	mov    %esp,%ebp
80101453:	56                   	push   %esi
80101454:	53                   	push   %ebx
80101455:	83 ec 10             	sub    $0x10,%esp
  bp = bread(dev, 1);
80101458:	8b 45 08             	mov    0x8(%ebp),%eax
8010145b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80101462:	00 
{
80101463:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101466:	89 04 24             	mov    %eax,(%esp)
80101469:	e8 62 ec ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010146e:	89 34 24             	mov    %esi,(%esp)
80101471:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
80101478:	00 
  bp = bread(dev, 1);
80101479:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010147b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010147e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101482:	e8 89 30 00 00       	call   80104510 <memmove>
  brelse(bp);
80101487:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010148a:	83 c4 10             	add    $0x10,%esp
8010148d:	5b                   	pop    %ebx
8010148e:	5e                   	pop    %esi
8010148f:	5d                   	pop    %ebp
  brelse(bp);
80101490:	e9 4b ed ff ff       	jmp    801001e0 <brelse>
80101495:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801014a0 <iinit>:
{
801014a0:	55                   	push   %ebp
801014a1:	89 e5                	mov    %esp,%ebp
801014a3:	53                   	push   %ebx
801014a4:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
801014a9:	83 ec 24             	sub    $0x24,%esp
  initlock(&icache.lock, "icache");
801014ac:	c7 44 24 04 0b 6f 10 	movl   $0x80106f0b,0x4(%esp)
801014b3:	80 
801014b4:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801014bb:	e8 80 2d 00 00       	call   80104240 <initlock>
    initsleeplock(&icache.inode[i].lock, "inode");
801014c0:	89 1c 24             	mov    %ebx,(%esp)
801014c3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014c9:	c7 44 24 04 12 6f 10 	movl   $0x80106f12,0x4(%esp)
801014d0:	80 
801014d1:	e8 3a 2c 00 00       	call   80104110 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801014d6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014dc:	75 e2                	jne    801014c0 <iinit+0x20>
  readsb(dev, &sb);
801014de:	8b 45 08             	mov    0x8(%ebp),%eax
801014e1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014e8:	80 
801014e9:	89 04 24             	mov    %eax,(%esp)
801014ec:	e8 5f ff ff ff       	call   80101450 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014f1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014f6:	c7 04 24 78 6f 10 80 	movl   $0x80106f78,(%esp)
801014fd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
80101501:	a1 d4 09 11 80       	mov    0x801109d4,%eax
80101506:	89 44 24 18          	mov    %eax,0x18(%esp)
8010150a:	a1 d0 09 11 80       	mov    0x801109d0,%eax
8010150f:	89 44 24 14          	mov    %eax,0x14(%esp)
80101513:	a1 cc 09 11 80       	mov    0x801109cc,%eax
80101518:	89 44 24 10          	mov    %eax,0x10(%esp)
8010151c:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101521:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101525:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010152a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010152e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101533:	89 44 24 04          	mov    %eax,0x4(%esp)
80101537:	e8 14 f1 ff ff       	call   80100650 <cprintf>
}
8010153c:	83 c4 24             	add    $0x24,%esp
8010153f:	5b                   	pop    %ebx
80101540:	5d                   	pop    %ebp
80101541:	c3                   	ret    
80101542:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101550 <ialloc>:
{
80101550:	55                   	push   %ebp
80101551:	89 e5                	mov    %esp,%ebp
80101553:	57                   	push   %edi
80101554:	56                   	push   %esi
80101555:	53                   	push   %ebx
80101556:	83 ec 2c             	sub    $0x2c,%esp
80101559:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
8010155c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
{
80101563:	8b 7d 08             	mov    0x8(%ebp),%edi
80101566:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101569:	0f 86 a2 00 00 00    	jbe    80101611 <ialloc+0xc1>
8010156f:	be 01 00 00 00       	mov    $0x1,%esi
80101574:	bb 01 00 00 00       	mov    $0x1,%ebx
80101579:	eb 1a                	jmp    80101595 <ialloc+0x45>
8010157b:	90                   	nop
8010157c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    brelse(bp);
80101580:	89 14 24             	mov    %edx,(%esp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101583:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101586:	e8 55 ec ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010158b:	89 de                	mov    %ebx,%esi
8010158d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101593:	73 7c                	jae    80101611 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101595:	89 f0                	mov    %esi,%eax
80101597:	c1 e8 03             	shr    $0x3,%eax
8010159a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801015a0:	89 3c 24             	mov    %edi,(%esp)
801015a3:	89 44 24 04          	mov    %eax,0x4(%esp)
801015a7:	e8 24 eb ff ff       	call   801000d0 <bread>
801015ac:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
801015ae:	89 f0                	mov    %esi,%eax
801015b0:	83 e0 07             	and    $0x7,%eax
801015b3:	c1 e0 06             	shl    $0x6,%eax
801015b6:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
801015ba:	66 83 39 00          	cmpw   $0x0,(%ecx)
801015be:	75 c0                	jne    80101580 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015c0:	89 0c 24             	mov    %ecx,(%esp)
801015c3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015ca:	00 
801015cb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015d2:	00 
801015d3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015d6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015d9:	e8 92 2e 00 00       	call   80104470 <memset>
      dip->type = type;
801015de:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
      dip->type = type;
801015e5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015e8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      dip->type = type;
801015eb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ee:	89 14 24             	mov    %edx,(%esp)
801015f1:	e8 ea 16 00 00       	call   80102ce0 <log_write>
      brelse(bp);
801015f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015f9:	89 14 24             	mov    %edx,(%esp)
801015fc:	e8 df eb ff ff       	call   801001e0 <brelse>
}
80101601:	83 c4 2c             	add    $0x2c,%esp
      return iget(dev, inum);
80101604:	89 f2                	mov    %esi,%edx
}
80101606:	5b                   	pop    %ebx
      return iget(dev, inum);
80101607:	89 f8                	mov    %edi,%eax
}
80101609:	5e                   	pop    %esi
8010160a:	5f                   	pop    %edi
8010160b:	5d                   	pop    %ebp
      return iget(dev, inum);
8010160c:	e9 bf fc ff ff       	jmp    801012d0 <iget>
  panic("ialloc: no inodes");
80101611:	c7 04 24 18 6f 10 80 	movl   $0x80106f18,(%esp)
80101618:	e8 43 ed ff ff       	call   80100360 <panic>
8010161d:	8d 76 00             	lea    0x0(%esi),%esi

80101620 <iupdate>:
{
80101620:	55                   	push   %ebp
80101621:	89 e5                	mov    %esp,%ebp
80101623:	56                   	push   %esi
80101624:	53                   	push   %ebx
80101625:	83 ec 10             	sub    $0x10,%esp
80101628:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010162b:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010162e:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101631:	c1 e8 03             	shr    $0x3,%eax
80101634:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010163a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010163e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101641:	89 04 24             	mov    %eax,(%esp)
80101644:	e8 87 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101649:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010164c:	83 e2 07             	and    $0x7,%edx
8010164f:	c1 e2 06             	shl    $0x6,%edx
80101652:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101656:	89 c6                	mov    %eax,%esi
  dip->type = ip->type;
80101658:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010165c:	83 c2 0c             	add    $0xc,%edx
  dip->type = ip->type;
8010165f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101663:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101667:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010166b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010166f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101673:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101677:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010167b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010167e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101681:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101685:	89 14 24             	mov    %edx,(%esp)
80101688:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010168f:	00 
80101690:	e8 7b 2e 00 00       	call   80104510 <memmove>
  log_write(bp);
80101695:	89 34 24             	mov    %esi,(%esp)
80101698:	e8 43 16 00 00       	call   80102ce0 <log_write>
  brelse(bp);
8010169d:	89 75 08             	mov    %esi,0x8(%ebp)
}
801016a0:	83 c4 10             	add    $0x10,%esp
801016a3:	5b                   	pop    %ebx
801016a4:	5e                   	pop    %esi
801016a5:	5d                   	pop    %ebp
  brelse(bp);
801016a6:	e9 35 eb ff ff       	jmp    801001e0 <brelse>
801016ab:	90                   	nop
801016ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016b0 <idup>:
{
801016b0:	55                   	push   %ebp
801016b1:	89 e5                	mov    %esp,%ebp
801016b3:	53                   	push   %ebx
801016b4:	83 ec 14             	sub    $0x14,%esp
801016b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801016ba:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016c1:	e8 ea 2c 00 00       	call   801043b0 <acquire>
  ip->ref++;
801016c6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016ca:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016d1:	e8 4a 2d 00 00       	call   80104420 <release>
}
801016d6:	83 c4 14             	add    $0x14,%esp
801016d9:	89 d8                	mov    %ebx,%eax
801016db:	5b                   	pop    %ebx
801016dc:	5d                   	pop    %ebp
801016dd:	c3                   	ret    
801016de:	66 90                	xchg   %ax,%ax

801016e0 <ilock>:
{
801016e0:	55                   	push   %ebp
801016e1:	89 e5                	mov    %esp,%ebp
801016e3:	56                   	push   %esi
801016e4:	53                   	push   %ebx
801016e5:	83 ec 10             	sub    $0x10,%esp
801016e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801016eb:	85 db                	test   %ebx,%ebx
801016ed:	0f 84 b3 00 00 00    	je     801017a6 <ilock+0xc6>
801016f3:	8b 53 08             	mov    0x8(%ebx),%edx
801016f6:	85 d2                	test   %edx,%edx
801016f8:	0f 8e a8 00 00 00    	jle    801017a6 <ilock+0xc6>
  acquiresleep(&ip->lock);
801016fe:	8d 43 0c             	lea    0xc(%ebx),%eax
80101701:	89 04 24             	mov    %eax,(%esp)
80101704:	e8 47 2a 00 00       	call   80104150 <acquiresleep>
  if(ip->valid == 0){
80101709:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010170c:	85 c0                	test   %eax,%eax
8010170e:	74 08                	je     80101718 <ilock+0x38>
}
80101710:	83 c4 10             	add    $0x10,%esp
80101713:	5b                   	pop    %ebx
80101714:	5e                   	pop    %esi
80101715:	5d                   	pop    %ebp
80101716:	c3                   	ret    
80101717:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101718:	8b 43 04             	mov    0x4(%ebx),%eax
8010171b:	c1 e8 03             	shr    $0x3,%eax
8010171e:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101724:	89 44 24 04          	mov    %eax,0x4(%esp)
80101728:	8b 03                	mov    (%ebx),%eax
8010172a:	89 04 24             	mov    %eax,(%esp)
8010172d:	e8 9e e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101732:	8b 53 04             	mov    0x4(%ebx),%edx
80101735:	83 e2 07             	and    $0x7,%edx
80101738:	c1 e2 06             	shl    $0x6,%edx
8010173b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010173f:	89 c6                	mov    %eax,%esi
    ip->type = dip->type;
80101741:	0f b7 02             	movzwl (%edx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101744:	83 c2 0c             	add    $0xc,%edx
    ip->type = dip->type;
80101747:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010174b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010174f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101753:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101757:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010175b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010175f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101763:	8b 42 fc             	mov    -0x4(%edx),%eax
80101766:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101769:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010176c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101770:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101777:	00 
80101778:	89 04 24             	mov    %eax,(%esp)
8010177b:	e8 90 2d 00 00       	call   80104510 <memmove>
    brelse(bp);
80101780:	89 34 24             	mov    %esi,(%esp)
80101783:	e8 58 ea ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101788:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010178d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101794:	0f 85 76 ff ff ff    	jne    80101710 <ilock+0x30>
      panic("ilock: no type");
8010179a:	c7 04 24 30 6f 10 80 	movl   $0x80106f30,(%esp)
801017a1:	e8 ba eb ff ff       	call   80100360 <panic>
    panic("ilock");
801017a6:	c7 04 24 2a 6f 10 80 	movl   $0x80106f2a,(%esp)
801017ad:	e8 ae eb ff ff       	call   80100360 <panic>
801017b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017c0 <iunlock>:
{
801017c0:	55                   	push   %ebp
801017c1:	89 e5                	mov    %esp,%ebp
801017c3:	56                   	push   %esi
801017c4:	53                   	push   %ebx
801017c5:	83 ec 10             	sub    $0x10,%esp
801017c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017cb:	85 db                	test   %ebx,%ebx
801017cd:	74 24                	je     801017f3 <iunlock+0x33>
801017cf:	8d 73 0c             	lea    0xc(%ebx),%esi
801017d2:	89 34 24             	mov    %esi,(%esp)
801017d5:	e8 16 2a 00 00       	call   801041f0 <holdingsleep>
801017da:	85 c0                	test   %eax,%eax
801017dc:	74 15                	je     801017f3 <iunlock+0x33>
801017de:	8b 43 08             	mov    0x8(%ebx),%eax
801017e1:	85 c0                	test   %eax,%eax
801017e3:	7e 0e                	jle    801017f3 <iunlock+0x33>
  releasesleep(&ip->lock);
801017e5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017e8:	83 c4 10             	add    $0x10,%esp
801017eb:	5b                   	pop    %ebx
801017ec:	5e                   	pop    %esi
801017ed:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
801017ee:	e9 bd 29 00 00       	jmp    801041b0 <releasesleep>
    panic("iunlock");
801017f3:	c7 04 24 3f 6f 10 80 	movl   $0x80106f3f,(%esp)
801017fa:	e8 61 eb ff ff       	call   80100360 <panic>
801017ff:	90                   	nop

80101800 <iput>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	57                   	push   %edi
80101804:	56                   	push   %esi
80101805:	53                   	push   %ebx
80101806:	83 ec 1c             	sub    $0x1c,%esp
80101809:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
8010180c:	8d 7e 0c             	lea    0xc(%esi),%edi
8010180f:	89 3c 24             	mov    %edi,(%esp)
80101812:	e8 39 29 00 00       	call   80104150 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101817:	8b 56 4c             	mov    0x4c(%esi),%edx
8010181a:	85 d2                	test   %edx,%edx
8010181c:	74 07                	je     80101825 <iput+0x25>
8010181e:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101823:	74 2b                	je     80101850 <iput+0x50>
  releasesleep(&ip->lock);
80101825:	89 3c 24             	mov    %edi,(%esp)
80101828:	e8 83 29 00 00       	call   801041b0 <releasesleep>
  acquire(&icache.lock);
8010182d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101834:	e8 77 2b 00 00       	call   801043b0 <acquire>
  ip->ref--;
80101839:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010183d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101844:	83 c4 1c             	add    $0x1c,%esp
80101847:	5b                   	pop    %ebx
80101848:	5e                   	pop    %esi
80101849:	5f                   	pop    %edi
8010184a:	5d                   	pop    %ebp
  release(&icache.lock);
8010184b:	e9 d0 2b 00 00       	jmp    80104420 <release>
    acquire(&icache.lock);
80101850:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101857:	e8 54 2b 00 00       	call   801043b0 <acquire>
    int r = ip->ref;
8010185c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010185f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101866:	e8 b5 2b 00 00       	call   80104420 <release>
    if(r == 1){
8010186b:	83 fb 01             	cmp    $0x1,%ebx
8010186e:	75 b5                	jne    80101825 <iput+0x25>
80101870:	8d 4e 30             	lea    0x30(%esi),%ecx
80101873:	89 f3                	mov    %esi,%ebx
80101875:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101878:	89 cf                	mov    %ecx,%edi
8010187a:	eb 0b                	jmp    80101887 <iput+0x87>
8010187c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101880:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101883:	39 fb                	cmp    %edi,%ebx
80101885:	74 19                	je     801018a0 <iput+0xa0>
    if(ip->addrs[i]){
80101887:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010188a:	85 d2                	test   %edx,%edx
8010188c:	74 f2                	je     80101880 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010188e:	8b 06                	mov    (%esi),%eax
80101890:	e8 9b f8 ff ff       	call   80101130 <bfree>
      ip->addrs[i] = 0;
80101895:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010189c:	eb e2                	jmp    80101880 <iput+0x80>
8010189e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
801018a0:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
801018a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801018a9:	85 c0                	test   %eax,%eax
801018ab:	75 2b                	jne    801018d8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
801018ad:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
801018b4:	89 34 24             	mov    %esi,(%esp)
801018b7:	e8 64 fd ff ff       	call   80101620 <iupdate>
      ip->type = 0;
801018bc:	31 c0                	xor    %eax,%eax
801018be:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018c2:	89 34 24             	mov    %esi,(%esp)
801018c5:	e8 56 fd ff ff       	call   80101620 <iupdate>
      ip->valid = 0;
801018ca:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018d1:	e9 4f ff ff ff       	jmp    80101825 <iput+0x25>
801018d6:	66 90                	xchg   %ax,%ax
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018d8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018dc:	8b 06                	mov    (%esi),%eax
    for(j = 0; j < NINDIRECT; j++){
801018de:	31 db                	xor    %ebx,%ebx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018e0:	89 04 24             	mov    %eax,(%esp)
801018e3:	e8 e8 e7 ff ff       	call   801000d0 <bread>
    for(j = 0; j < NINDIRECT; j++){
801018e8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    a = (uint*)bp->data;
801018eb:	8d 48 5c             	lea    0x5c(%eax),%ecx
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
801018f1:	89 cf                	mov    %ecx,%edi
801018f3:	31 c0                	xor    %eax,%eax
801018f5:	eb 0e                	jmp    80101905 <iput+0x105>
801018f7:	90                   	nop
801018f8:	83 c3 01             	add    $0x1,%ebx
801018fb:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
80101901:	89 d8                	mov    %ebx,%eax
80101903:	74 10                	je     80101915 <iput+0x115>
      if(a[j])
80101905:	8b 14 87             	mov    (%edi,%eax,4),%edx
80101908:	85 d2                	test   %edx,%edx
8010190a:	74 ec                	je     801018f8 <iput+0xf8>
        bfree(ip->dev, a[j]);
8010190c:	8b 06                	mov    (%esi),%eax
8010190e:	e8 1d f8 ff ff       	call   80101130 <bfree>
80101913:	eb e3                	jmp    801018f8 <iput+0xf8>
    brelse(bp);
80101915:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101918:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010191b:	89 04 24             	mov    %eax,(%esp)
8010191e:	e8 bd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101923:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101929:	8b 06                	mov    (%esi),%eax
8010192b:	e8 00 f8 ff ff       	call   80101130 <bfree>
    ip->addrs[NDIRECT] = 0;
80101930:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101937:	00 00 00 
8010193a:	e9 6e ff ff ff       	jmp    801018ad <iput+0xad>
8010193f:	90                   	nop

80101940 <iunlockput>:
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	53                   	push   %ebx
80101944:	83 ec 14             	sub    $0x14,%esp
80101947:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010194a:	89 1c 24             	mov    %ebx,(%esp)
8010194d:	e8 6e fe ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101952:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101955:	83 c4 14             	add    $0x14,%esp
80101958:	5b                   	pop    %ebx
80101959:	5d                   	pop    %ebp
  iput(ip);
8010195a:	e9 a1 fe ff ff       	jmp    80101800 <iput>
8010195f:	90                   	nop

80101960 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	8b 55 08             	mov    0x8(%ebp),%edx
80101966:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101969:	8b 0a                	mov    (%edx),%ecx
8010196b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010196e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101971:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101974:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101978:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010197b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010197f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101983:	8b 52 58             	mov    0x58(%edx),%edx
80101986:	89 50 10             	mov    %edx,0x10(%eax)
}
80101989:	5d                   	pop    %ebp
8010198a:	c3                   	ret    
8010198b:	90                   	nop
8010198c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101990 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101990:	55                   	push   %ebp
80101991:	89 e5                	mov    %esp,%ebp
80101993:	57                   	push   %edi
80101994:	56                   	push   %esi
80101995:	53                   	push   %ebx
80101996:	83 ec 2c             	sub    $0x2c,%esp
80101999:	8b 45 0c             	mov    0xc(%ebp),%eax
8010199c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010199f:	8b 75 10             	mov    0x10(%ebp),%esi
801019a2:	89 45 e0             	mov    %eax,-0x20(%ebp)
801019a5:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
801019a8:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
{
801019ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(ip->type == T_DEV){
801019b0:	0f 84 aa 00 00 00    	je     80101a60 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
801019b6:	8b 47 58             	mov    0x58(%edi),%eax
801019b9:	39 f0                	cmp    %esi,%eax
801019bb:	0f 82 c7 00 00 00    	jb     80101a88 <readi+0xf8>
801019c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019c4:	89 da                	mov    %ebx,%edx
801019c6:	01 f2                	add    %esi,%edx
801019c8:	0f 82 ba 00 00 00    	jb     80101a88 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ce:	89 c1                	mov    %eax,%ecx
801019d0:	29 f1                	sub    %esi,%ecx
801019d2:	39 d0                	cmp    %edx,%eax
801019d4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019d7:	31 c0                	xor    %eax,%eax
801019d9:	85 c9                	test   %ecx,%ecx
    n = ip->size - off;
801019db:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019de:	74 70                	je     80101a50 <readi+0xc0>
801019e0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019e3:	89 c7                	mov    %eax,%edi
801019e5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019eb:	89 f2                	mov    %esi,%edx
801019ed:	c1 ea 09             	shr    $0x9,%edx
801019f0:	89 d8                	mov    %ebx,%eax
801019f2:	e8 99 f9 ff ff       	call   80101390 <bmap>
801019f7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019fb:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019fd:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a02:	89 04 24             	mov    %eax,(%esp)
80101a05:	e8 c6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101a0a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101a0d:	29 f9                	sub    %edi,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101a0f:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101a11:	89 f0                	mov    %esi,%eax
80101a13:	25 ff 01 00 00       	and    $0x1ff,%eax
80101a18:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a1a:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a1e:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a24:	8b 45 e0             	mov    -0x20(%ebp),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101a27:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a2a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a2e:	01 df                	add    %ebx,%edi
80101a30:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101a32:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a35:	89 04 24             	mov    %eax,(%esp)
80101a38:	e8 d3 2a 00 00       	call   80104510 <memmove>
    brelse(bp);
80101a3d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a40:	89 14 24             	mov    %edx,(%esp)
80101a43:	e8 98 e7 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a48:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a4b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a4e:	77 98                	ja     801019e8 <readi+0x58>
  }
  return n;
80101a50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a53:	83 c4 2c             	add    $0x2c,%esp
80101a56:	5b                   	pop    %ebx
80101a57:	5e                   	pop    %esi
80101a58:	5f                   	pop    %edi
80101a59:	5d                   	pop    %ebp
80101a5a:	c3                   	ret    
80101a5b:	90                   	nop
80101a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a60:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a64:	66 83 f8 09          	cmp    $0x9,%ax
80101a68:	77 1e                	ja     80101a88 <readi+0xf8>
80101a6a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a71:	85 c0                	test   %eax,%eax
80101a73:	74 13                	je     80101a88 <readi+0xf8>
    return devsw[ip->major].read(ip, dst, n);
80101a75:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a78:	89 75 10             	mov    %esi,0x10(%ebp)
}
80101a7b:	83 c4 2c             	add    $0x2c,%esp
80101a7e:	5b                   	pop    %ebx
80101a7f:	5e                   	pop    %esi
80101a80:	5f                   	pop    %edi
80101a81:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101a82:	ff e0                	jmp    *%eax
80101a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101a88:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a8d:	eb c4                	jmp    80101a53 <readi+0xc3>
80101a8f:	90                   	nop

80101a90 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a90:	55                   	push   %ebp
80101a91:	89 e5                	mov    %esp,%ebp
80101a93:	57                   	push   %edi
80101a94:	56                   	push   %esi
80101a95:	53                   	push   %ebx
80101a96:	83 ec 2c             	sub    $0x2c,%esp
80101a99:	8b 45 08             	mov    0x8(%ebp),%eax
80101a9c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a9f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101aa2:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101aa7:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101aaa:	8b 75 10             	mov    0x10(%ebp),%esi
80101aad:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101ab0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101ab3:	0f 84 b7 00 00 00    	je     80101b70 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101ab9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101abc:	39 70 58             	cmp    %esi,0x58(%eax)
80101abf:	0f 82 e3 00 00 00    	jb     80101ba8 <writei+0x118>
80101ac5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101ac8:	89 c8                	mov    %ecx,%eax
80101aca:	01 f0                	add    %esi,%eax
80101acc:	0f 82 d6 00 00 00    	jb     80101ba8 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ad2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ad7:	0f 87 cb 00 00 00    	ja     80101ba8 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101add:	85 c9                	test   %ecx,%ecx
80101adf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ae6:	74 77                	je     80101b5f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ae8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101aeb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101aed:	bb 00 02 00 00       	mov    $0x200,%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af2:	c1 ea 09             	shr    $0x9,%edx
80101af5:	89 f8                	mov    %edi,%eax
80101af7:	e8 94 f8 ff ff       	call   80101390 <bmap>
80101afc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101b00:	8b 07                	mov    (%edi),%eax
80101b02:	89 04 24             	mov    %eax,(%esp)
80101b05:	e8 c6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b0a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101b0d:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101b10:	8b 55 dc             	mov    -0x24(%ebp),%edx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b13:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101b15:	89 f0                	mov    %esi,%eax
80101b17:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b1c:	29 c3                	sub    %eax,%ebx
80101b1e:	39 cb                	cmp    %ecx,%ebx
80101b20:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b23:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b27:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101b29:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b2d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b31:	89 04 24             	mov    %eax,(%esp)
80101b34:	e8 d7 29 00 00       	call   80104510 <memmove>
    log_write(bp);
80101b39:	89 3c 24             	mov    %edi,(%esp)
80101b3c:	e8 9f 11 00 00       	call   80102ce0 <log_write>
    brelse(bp);
80101b41:	89 3c 24             	mov    %edi,(%esp)
80101b44:	e8 97 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b49:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b4f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b52:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b55:	77 91                	ja     80101ae8 <writei+0x58>
  }

  if(n > 0 && off > ip->size){
80101b57:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b5a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b5d:	72 39                	jb     80101b98 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b5f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b62:	83 c4 2c             	add    $0x2c,%esp
80101b65:	5b                   	pop    %ebx
80101b66:	5e                   	pop    %esi
80101b67:	5f                   	pop    %edi
80101b68:	5d                   	pop    %ebp
80101b69:	c3                   	ret    
80101b6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b70:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b74:	66 83 f8 09          	cmp    $0x9,%ax
80101b78:	77 2e                	ja     80101ba8 <writei+0x118>
80101b7a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b81:	85 c0                	test   %eax,%eax
80101b83:	74 23                	je     80101ba8 <writei+0x118>
    return devsw[ip->major].write(ip, src, n);
80101b85:	89 4d 10             	mov    %ecx,0x10(%ebp)
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
80101b8b:	5b                   	pop    %ebx
80101b8c:	5e                   	pop    %esi
80101b8d:	5f                   	pop    %edi
80101b8e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101b8f:	ff e0                	jmp    *%eax
80101b91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101b98:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b9b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b9e:	89 04 24             	mov    %eax,(%esp)
80101ba1:	e8 7a fa ff ff       	call   80101620 <iupdate>
80101ba6:	eb b7                	jmp    80101b5f <writei+0xcf>
}
80101ba8:	83 c4 2c             	add    $0x2c,%esp
      return -1;
80101bab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80101bb0:	5b                   	pop    %ebx
80101bb1:	5e                   	pop    %esi
80101bb2:	5f                   	pop    %edi
80101bb3:	5d                   	pop    %ebp
80101bb4:	c3                   	ret    
80101bb5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bc0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101bc0:	55                   	push   %ebp
80101bc1:	89 e5                	mov    %esp,%ebp
80101bc3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101bc9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bd0:	00 
80101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bd5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bd8:	89 04 24             	mov    %eax,(%esp)
80101bdb:	e8 b0 29 00 00       	call   80104590 <strncmp>
}
80101be0:	c9                   	leave  
80101be1:	c3                   	ret    
80101be2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bf0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bf0:	55                   	push   %ebp
80101bf1:	89 e5                	mov    %esp,%ebp
80101bf3:	57                   	push   %edi
80101bf4:	56                   	push   %esi
80101bf5:	53                   	push   %ebx
80101bf6:	83 ec 2c             	sub    $0x2c,%esp
80101bf9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bfc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101c01:	0f 85 97 00 00 00    	jne    80101c9e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101c07:	8b 53 58             	mov    0x58(%ebx),%edx
80101c0a:	31 ff                	xor    %edi,%edi
80101c0c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101c0f:	85 d2                	test   %edx,%edx
80101c11:	75 0d                	jne    80101c20 <dirlookup+0x30>
80101c13:	eb 73                	jmp    80101c88 <dirlookup+0x98>
80101c15:	8d 76 00             	lea    0x0(%esi),%esi
80101c18:	83 c7 10             	add    $0x10,%edi
80101c1b:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101c1e:	76 68                	jbe    80101c88 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c20:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c27:	00 
80101c28:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c2c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c30:	89 1c 24             	mov    %ebx,(%esp)
80101c33:	e8 58 fd ff ff       	call   80101990 <readi>
80101c38:	83 f8 10             	cmp    $0x10,%eax
80101c3b:	75 55                	jne    80101c92 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c3d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c42:	74 d4                	je     80101c18 <dirlookup+0x28>
  return strncmp(s, t, DIRSIZ);
80101c44:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c47:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c4b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c4e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c55:	00 
80101c56:	89 04 24             	mov    %eax,(%esp)
80101c59:	e8 32 29 00 00       	call   80104590 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101c5e:	85 c0                	test   %eax,%eax
80101c60:	75 b6                	jne    80101c18 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c62:	8b 45 10             	mov    0x10(%ebp),%eax
80101c65:	85 c0                	test   %eax,%eax
80101c67:	74 05                	je     80101c6e <dirlookup+0x7e>
        *poff = off;
80101c69:	8b 45 10             	mov    0x10(%ebp),%eax
80101c6c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c6e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c72:	8b 03                	mov    (%ebx),%eax
80101c74:	e8 57 f6 ff ff       	call   801012d0 <iget>
    }
  }

  return 0;
}
80101c79:	83 c4 2c             	add    $0x2c,%esp
80101c7c:	5b                   	pop    %ebx
80101c7d:	5e                   	pop    %esi
80101c7e:	5f                   	pop    %edi
80101c7f:	5d                   	pop    %ebp
80101c80:	c3                   	ret    
80101c81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c88:	83 c4 2c             	add    $0x2c,%esp
  return 0;
80101c8b:	31 c0                	xor    %eax,%eax
}
80101c8d:	5b                   	pop    %ebx
80101c8e:	5e                   	pop    %esi
80101c8f:	5f                   	pop    %edi
80101c90:	5d                   	pop    %ebp
80101c91:	c3                   	ret    
      panic("dirlookup read");
80101c92:	c7 04 24 59 6f 10 80 	movl   $0x80106f59,(%esp)
80101c99:	e8 c2 e6 ff ff       	call   80100360 <panic>
    panic("dirlookup not DIR");
80101c9e:	c7 04 24 47 6f 10 80 	movl   $0x80106f47,(%esp)
80101ca5:	e8 b6 e6 ff ff       	call   80100360 <panic>
80101caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101cb0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	57                   	push   %edi
80101cb4:	89 cf                	mov    %ecx,%edi
80101cb6:	56                   	push   %esi
80101cb7:	53                   	push   %ebx
80101cb8:	89 c3                	mov    %eax,%ebx
80101cba:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101cbd:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101cc0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101cc3:	0f 84 51 01 00 00    	je     80101e1a <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101cc9:	e8 12 1a 00 00       	call   801036e0 <myproc>
80101cce:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101cd1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cd8:	e8 d3 26 00 00       	call   801043b0 <acquire>
  ip->ref++;
80101cdd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101ce1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101ce8:	e8 33 27 00 00       	call   80104420 <release>
80101ced:	eb 04                	jmp    80101cf3 <namex+0x43>
80101cef:	90                   	nop
    path++;
80101cf0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101cf3:	0f b6 03             	movzbl (%ebx),%eax
80101cf6:	3c 2f                	cmp    $0x2f,%al
80101cf8:	74 f6                	je     80101cf0 <namex+0x40>
  if(*path == 0)
80101cfa:	84 c0                	test   %al,%al
80101cfc:	0f 84 ed 00 00 00    	je     80101def <namex+0x13f>
  while(*path != '/' && *path != 0)
80101d02:	0f b6 03             	movzbl (%ebx),%eax
80101d05:	89 da                	mov    %ebx,%edx
80101d07:	84 c0                	test   %al,%al
80101d09:	0f 84 b1 00 00 00    	je     80101dc0 <namex+0x110>
80101d0f:	3c 2f                	cmp    $0x2f,%al
80101d11:	75 0f                	jne    80101d22 <namex+0x72>
80101d13:	e9 a8 00 00 00       	jmp    80101dc0 <namex+0x110>
80101d18:	3c 2f                	cmp    $0x2f,%al
80101d1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d20:	74 0a                	je     80101d2c <namex+0x7c>
    path++;
80101d22:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101d25:	0f b6 02             	movzbl (%edx),%eax
80101d28:	84 c0                	test   %al,%al
80101d2a:	75 ec                	jne    80101d18 <namex+0x68>
80101d2c:	89 d1                	mov    %edx,%ecx
80101d2e:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101d30:	83 f9 0d             	cmp    $0xd,%ecx
80101d33:	0f 8e 8f 00 00 00    	jle    80101dc8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d39:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d3d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d44:	00 
80101d45:	89 3c 24             	mov    %edi,(%esp)
80101d48:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d4b:	e8 c0 27 00 00       	call   80104510 <memmove>
    path++;
80101d50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d53:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101d55:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d58:	75 0e                	jne    80101d68 <namex+0xb8>
80101d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d60:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101d63:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d66:	74 f8                	je     80101d60 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d68:	89 34 24             	mov    %esi,(%esp)
80101d6b:	e8 70 f9 ff ff       	call   801016e0 <ilock>
    if(ip->type != T_DIR){
80101d70:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d75:	0f 85 85 00 00 00    	jne    80101e00 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d7b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d7e:	85 d2                	test   %edx,%edx
80101d80:	74 09                	je     80101d8b <namex+0xdb>
80101d82:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d85:	0f 84 a5 00 00 00    	je     80101e30 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d8b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d92:	00 
80101d93:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d97:	89 34 24             	mov    %esi,(%esp)
80101d9a:	e8 51 fe ff ff       	call   80101bf0 <dirlookup>
80101d9f:	85 c0                	test   %eax,%eax
80101da1:	74 5d                	je     80101e00 <namex+0x150>
  iunlock(ip);
80101da3:	89 34 24             	mov    %esi,(%esp)
80101da6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101da9:	e8 12 fa ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101dae:	89 34 24             	mov    %esi,(%esp)
80101db1:	e8 4a fa ff ff       	call   80101800 <iput>
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101db6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101db9:	89 c6                	mov    %eax,%esi
80101dbb:	e9 33 ff ff ff       	jmp    80101cf3 <namex+0x43>
  while(*path != '/' && *path != 0)
80101dc0:	31 c9                	xor    %ecx,%ecx
80101dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(name, s, len);
80101dc8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dcc:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101dd0:	89 3c 24             	mov    %edi,(%esp)
80101dd3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101dd6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101dd9:	e8 32 27 00 00       	call   80104510 <memmove>
    name[len] = 0;
80101dde:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101de4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101de8:	89 d3                	mov    %edx,%ebx
80101dea:	e9 66 ff ff ff       	jmp    80101d55 <namex+0xa5>
  }
  if(nameiparent){
80101def:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101df2:	85 c0                	test   %eax,%eax
80101df4:	75 4c                	jne    80101e42 <namex+0x192>
80101df6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101df8:	83 c4 2c             	add    $0x2c,%esp
80101dfb:	5b                   	pop    %ebx
80101dfc:	5e                   	pop    %esi
80101dfd:	5f                   	pop    %edi
80101dfe:	5d                   	pop    %ebp
80101dff:	c3                   	ret    
  iunlock(ip);
80101e00:	89 34 24             	mov    %esi,(%esp)
80101e03:	e8 b8 f9 ff ff       	call   801017c0 <iunlock>
  iput(ip);
80101e08:	89 34 24             	mov    %esi,(%esp)
80101e0b:	e8 f0 f9 ff ff       	call   80101800 <iput>
}
80101e10:	83 c4 2c             	add    $0x2c,%esp
      return 0;
80101e13:	31 c0                	xor    %eax,%eax
}
80101e15:	5b                   	pop    %ebx
80101e16:	5e                   	pop    %esi
80101e17:	5f                   	pop    %edi
80101e18:	5d                   	pop    %ebp
80101e19:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101e1a:	ba 01 00 00 00       	mov    $0x1,%edx
80101e1f:	b8 01 00 00 00       	mov    $0x1,%eax
80101e24:	e8 a7 f4 ff ff       	call   801012d0 <iget>
80101e29:	89 c6                	mov    %eax,%esi
80101e2b:	e9 c3 fe ff ff       	jmp    80101cf3 <namex+0x43>
      iunlock(ip);
80101e30:	89 34 24             	mov    %esi,(%esp)
80101e33:	e8 88 f9 ff ff       	call   801017c0 <iunlock>
}
80101e38:	83 c4 2c             	add    $0x2c,%esp
      return ip;
80101e3b:	89 f0                	mov    %esi,%eax
}
80101e3d:	5b                   	pop    %ebx
80101e3e:	5e                   	pop    %esi
80101e3f:	5f                   	pop    %edi
80101e40:	5d                   	pop    %ebp
80101e41:	c3                   	ret    
    iput(ip);
80101e42:	89 34 24             	mov    %esi,(%esp)
80101e45:	e8 b6 f9 ff ff       	call   80101800 <iput>
    return 0;
80101e4a:	31 c0                	xor    %eax,%eax
80101e4c:	eb aa                	jmp    80101df8 <namex+0x148>
80101e4e:	66 90                	xchg   %ax,%ax

80101e50 <dirlink>:
{
80101e50:	55                   	push   %ebp
80101e51:	89 e5                	mov    %esp,%ebp
80101e53:	57                   	push   %edi
80101e54:	56                   	push   %esi
80101e55:	53                   	push   %ebx
80101e56:	83 ec 2c             	sub    $0x2c,%esp
80101e59:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e5c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e5f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e66:	00 
80101e67:	89 1c 24             	mov    %ebx,(%esp)
80101e6a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e6e:	e8 7d fd ff ff       	call   80101bf0 <dirlookup>
80101e73:	85 c0                	test   %eax,%eax
80101e75:	0f 85 8b 00 00 00    	jne    80101f06 <dirlink+0xb6>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e7b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e7e:	31 ff                	xor    %edi,%edi
80101e80:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e83:	85 c0                	test   %eax,%eax
80101e85:	75 13                	jne    80101e9a <dirlink+0x4a>
80101e87:	eb 35                	jmp    80101ebe <dirlink+0x6e>
80101e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e90:	8d 57 10             	lea    0x10(%edi),%edx
80101e93:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e96:	89 d7                	mov    %edx,%edi
80101e98:	76 24                	jbe    80101ebe <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e9a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ea1:	00 
80101ea2:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ea6:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eaa:	89 1c 24             	mov    %ebx,(%esp)
80101ead:	e8 de fa ff ff       	call   80101990 <readi>
80101eb2:	83 f8 10             	cmp    $0x10,%eax
80101eb5:	75 5e                	jne    80101f15 <dirlink+0xc5>
    if(de.inum == 0)
80101eb7:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101ebc:	75 d2                	jne    80101e90 <dirlink+0x40>
  strncpy(de.name, name, DIRSIZ);
80101ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ec1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ec8:	00 
80101ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ecd:	8d 45 da             	lea    -0x26(%ebp),%eax
80101ed0:	89 04 24             	mov    %eax,(%esp)
80101ed3:	e8 28 27 00 00       	call   80104600 <strncpy>
  de.inum = inum;
80101ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101edb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ee2:	00 
80101ee3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ee7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101eeb:	89 1c 24             	mov    %ebx,(%esp)
  de.inum = inum;
80101eee:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ef2:	e8 99 fb ff ff       	call   80101a90 <writei>
80101ef7:	83 f8 10             	cmp    $0x10,%eax
80101efa:	75 25                	jne    80101f21 <dirlink+0xd1>
  return 0;
80101efc:	31 c0                	xor    %eax,%eax
}
80101efe:	83 c4 2c             	add    $0x2c,%esp
80101f01:	5b                   	pop    %ebx
80101f02:	5e                   	pop    %esi
80101f03:	5f                   	pop    %edi
80101f04:	5d                   	pop    %ebp
80101f05:	c3                   	ret    
    iput(ip);
80101f06:	89 04 24             	mov    %eax,(%esp)
80101f09:	e8 f2 f8 ff ff       	call   80101800 <iput>
    return -1;
80101f0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101f13:	eb e9                	jmp    80101efe <dirlink+0xae>
      panic("dirlink read");
80101f15:	c7 04 24 68 6f 10 80 	movl   $0x80106f68,(%esp)
80101f1c:	e8 3f e4 ff ff       	call   80100360 <panic>
    panic("dirlink");
80101f21:	c7 04 24 c2 75 10 80 	movl   $0x801075c2,(%esp)
80101f28:	e8 33 e4 ff ff       	call   80100360 <panic>
80101f2d:	8d 76 00             	lea    0x0(%esi),%esi

80101f30 <namei>:

struct inode*
namei(char *path)
{
80101f30:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f31:	31 d2                	xor    %edx,%edx
{
80101f33:	89 e5                	mov    %esp,%ebp
80101f35:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80101f38:	8b 45 08             	mov    0x8(%ebp),%eax
80101f3b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f3e:	e8 6d fd ff ff       	call   80101cb0 <namex>
}
80101f43:	c9                   	leave  
80101f44:	c3                   	ret    
80101f45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f50 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f50:	55                   	push   %ebp
  return namex(path, 1, name);
80101f51:	ba 01 00 00 00       	mov    $0x1,%edx
{
80101f56:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f5b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f5e:	5d                   	pop    %ebp
  return namex(path, 1, name);
80101f5f:	e9 4c fd ff ff       	jmp    80101cb0 <namex>
80101f64:	66 90                	xchg   %ax,%ax
80101f66:	66 90                	xchg   %ax,%ax
80101f68:	66 90                	xchg   %ax,%ax
80101f6a:	66 90                	xchg   %ax,%ax
80101f6c:	66 90                	xchg   %ax,%ax
80101f6e:	66 90                	xchg   %ax,%ax

80101f70 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f70:	55                   	push   %ebp
80101f71:	89 e5                	mov    %esp,%ebp
80101f73:	56                   	push   %esi
80101f74:	89 c6                	mov    %eax,%esi
80101f76:	53                   	push   %ebx
80101f77:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f7a:	85 c0                	test   %eax,%eax
80101f7c:	0f 84 99 00 00 00    	je     8010201b <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f82:	8b 48 08             	mov    0x8(%eax),%ecx
80101f85:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f8b:	0f 87 7e 00 00 00    	ja     8010200f <idestart+0x9f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f91:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f96:	66 90                	xchg   %ax,%ax
80101f98:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f99:	83 e0 c0             	and    $0xffffffc0,%eax
80101f9c:	3c 40                	cmp    $0x40,%al
80101f9e:	75 f8                	jne    80101f98 <idestart+0x28>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101fa0:	31 db                	xor    %ebx,%ebx
80101fa2:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101fa7:	89 d8                	mov    %ebx,%eax
80101fa9:	ee                   	out    %al,(%dx)
80101faa:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101faf:	b8 01 00 00 00       	mov    $0x1,%eax
80101fb4:	ee                   	out    %al,(%dx)
80101fb5:	0f b6 c1             	movzbl %cl,%eax
80101fb8:	b2 f3                	mov    $0xf3,%dl
80101fba:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101fbb:	89 c8                	mov    %ecx,%eax
80101fbd:	b2 f4                	mov    $0xf4,%dl
80101fbf:	c1 f8 08             	sar    $0x8,%eax
80101fc2:	ee                   	out    %al,(%dx)
80101fc3:	b2 f5                	mov    $0xf5,%dl
80101fc5:	89 d8                	mov    %ebx,%eax
80101fc7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fc8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fcc:	b2 f6                	mov    $0xf6,%dl
80101fce:	83 e0 01             	and    $0x1,%eax
80101fd1:	c1 e0 04             	shl    $0x4,%eax
80101fd4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fd7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fd8:	f6 06 04             	testb  $0x4,(%esi)
80101fdb:	75 13                	jne    80101ff0 <idestart+0x80>
80101fdd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fe2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fe7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
80101fef:	90                   	nop
80101ff0:	b2 f7                	mov    $0xf7,%dl
80101ff2:	b8 30 00 00 00       	mov    $0x30,%eax
80101ff7:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80101ff8:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80101ffd:	83 c6 5c             	add    $0x5c,%esi
80102000:	ba f0 01 00 00       	mov    $0x1f0,%edx
80102005:	fc                   	cld    
80102006:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102008:	83 c4 10             	add    $0x10,%esp
8010200b:	5b                   	pop    %ebx
8010200c:	5e                   	pop    %esi
8010200d:	5d                   	pop    %ebp
8010200e:	c3                   	ret    
    panic("incorrect blockno");
8010200f:	c7 04 24 d4 6f 10 80 	movl   $0x80106fd4,(%esp)
80102016:	e8 45 e3 ff ff       	call   80100360 <panic>
    panic("idestart");
8010201b:	c7 04 24 cb 6f 10 80 	movl   $0x80106fcb,(%esp)
80102022:	e8 39 e3 ff ff       	call   80100360 <panic>
80102027:	89 f6                	mov    %esi,%esi
80102029:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102030 <ideinit>:
{
80102030:	55                   	push   %ebp
80102031:	89 e5                	mov    %esp,%ebp
80102033:	83 ec 18             	sub    $0x18,%esp
  initlock(&idelock, "ide");
80102036:	c7 44 24 04 e6 6f 10 	movl   $0x80106fe6,0x4(%esp)
8010203d:	80 
8010203e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102045:	e8 f6 21 00 00       	call   80104240 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010204a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010204f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102056:	83 e8 01             	sub    $0x1,%eax
80102059:	89 44 24 04          	mov    %eax,0x4(%esp)
8010205d:	e8 7e 02 00 00       	call   801022e0 <ioapicenable>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102062:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102067:	90                   	nop
80102068:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102069:	83 e0 c0             	and    $0xffffffc0,%eax
8010206c:	3c 40                	cmp    $0x40,%al
8010206e:	75 f8                	jne    80102068 <ideinit+0x38>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102070:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102075:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010207a:	ee                   	out    %al,(%dx)
8010207b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102080:	b2 f7                	mov    $0xf7,%dl
80102082:	eb 09                	jmp    8010208d <ideinit+0x5d>
80102084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<1000; i++){
80102088:	83 e9 01             	sub    $0x1,%ecx
8010208b:	74 0f                	je     8010209c <ideinit+0x6c>
8010208d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010208e:	84 c0                	test   %al,%al
80102090:	74 f6                	je     80102088 <ideinit+0x58>
      havedisk1 = 1;
80102092:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102099:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010209c:	ba f6 01 00 00       	mov    $0x1f6,%edx
801020a1:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801020a6:	ee                   	out    %al,(%dx)
}
801020a7:	c9                   	leave  
801020a8:	c3                   	ret    
801020a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801020b0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801020b0:	55                   	push   %ebp
801020b1:	89 e5                	mov    %esp,%ebp
801020b3:	57                   	push   %edi
801020b4:	56                   	push   %esi
801020b5:	53                   	push   %ebx
801020b6:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801020b9:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020c0:	e8 eb 22 00 00       	call   801043b0 <acquire>

  if((b = idequeue) == 0){
801020c5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020cb:	85 db                	test   %ebx,%ebx
801020cd:	74 30                	je     801020ff <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020cf:	8b 43 58             	mov    0x58(%ebx),%eax
801020d2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020d7:	8b 33                	mov    (%ebx),%esi
801020d9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020df:	74 37                	je     80102118 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020e1:	83 e6 fb             	and    $0xfffffffb,%esi
801020e4:	83 ce 02             	or     $0x2,%esi
801020e7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020e9:	89 1c 24             	mov    %ebx,(%esp)
801020ec:	e8 2f 1e 00 00       	call   80103f20 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020f1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020f6:	85 c0                	test   %eax,%eax
801020f8:	74 05                	je     801020ff <ideintr+0x4f>
    idestart(idequeue);
801020fa:	e8 71 fe ff ff       	call   80101f70 <idestart>
    release(&idelock);
801020ff:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102106:	e8 15 23 00 00       	call   80104420 <release>

  release(&idelock);
}
8010210b:	83 c4 1c             	add    $0x1c,%esp
8010210e:	5b                   	pop    %ebx
8010210f:	5e                   	pop    %esi
80102110:	5f                   	pop    %edi
80102111:	5d                   	pop    %ebp
80102112:	c3                   	ret    
80102113:	90                   	nop
80102114:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102118:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010211d:	8d 76 00             	lea    0x0(%esi),%esi
80102120:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102121:	89 c1                	mov    %eax,%ecx
80102123:	83 e1 c0             	and    $0xffffffc0,%ecx
80102126:	80 f9 40             	cmp    $0x40,%cl
80102129:	75 f5                	jne    80102120 <ideintr+0x70>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010212b:	a8 21                	test   $0x21,%al
8010212d:	75 b2                	jne    801020e1 <ideintr+0x31>
    insl(0x1f0, b->data, BSIZE/4);
8010212f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102132:	b9 80 00 00 00       	mov    $0x80,%ecx
80102137:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010213c:	fc                   	cld    
8010213d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010213f:	8b 33                	mov    (%ebx),%esi
80102141:	eb 9e                	jmp    801020e1 <ideintr+0x31>
80102143:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102150 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102150:	55                   	push   %ebp
80102151:	89 e5                	mov    %esp,%ebp
80102153:	53                   	push   %ebx
80102154:	83 ec 14             	sub    $0x14,%esp
80102157:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010215a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010215d:	89 04 24             	mov    %eax,(%esp)
80102160:	e8 8b 20 00 00       	call   801041f0 <holdingsleep>
80102165:	85 c0                	test   %eax,%eax
80102167:	0f 84 9e 00 00 00    	je     8010220b <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010216d:	8b 03                	mov    (%ebx),%eax
8010216f:	83 e0 06             	and    $0x6,%eax
80102172:	83 f8 02             	cmp    $0x2,%eax
80102175:	0f 84 a8 00 00 00    	je     80102223 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010217b:	8b 53 04             	mov    0x4(%ebx),%edx
8010217e:	85 d2                	test   %edx,%edx
80102180:	74 0d                	je     8010218f <iderw+0x3f>
80102182:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102187:	85 c0                	test   %eax,%eax
80102189:	0f 84 88 00 00 00    	je     80102217 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010218f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102196:	e8 15 22 00 00       	call   801043b0 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010219b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
  b->qnext = 0;
801021a0:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021a7:	85 c0                	test   %eax,%eax
801021a9:	75 07                	jne    801021b2 <iderw+0x62>
801021ab:	eb 4e                	jmp    801021fb <iderw+0xab>
801021ad:	8d 76 00             	lea    0x0(%esi),%esi
801021b0:	89 d0                	mov    %edx,%eax
801021b2:	8b 50 58             	mov    0x58(%eax),%edx
801021b5:	85 d2                	test   %edx,%edx
801021b7:	75 f7                	jne    801021b0 <iderw+0x60>
801021b9:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
801021bc:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
801021be:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021c4:	74 3c                	je     80102202 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c6:	8b 03                	mov    (%ebx),%eax
801021c8:	83 e0 06             	and    $0x6,%eax
801021cb:	83 f8 02             	cmp    $0x2,%eax
801021ce:	74 1a                	je     801021ea <iderw+0x9a>
    sleep(b, &idelock);
801021d0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021d7:	80 
801021d8:	89 1c 24             	mov    %ebx,(%esp)
801021db:	e8 a0 1b 00 00       	call   80103d80 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021e0:	8b 13                	mov    (%ebx),%edx
801021e2:	83 e2 06             	and    $0x6,%edx
801021e5:	83 fa 02             	cmp    $0x2,%edx
801021e8:	75 e6                	jne    801021d0 <iderw+0x80>
  }


  release(&idelock);
801021ea:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021f1:	83 c4 14             	add    $0x14,%esp
801021f4:	5b                   	pop    %ebx
801021f5:	5d                   	pop    %ebp
  release(&idelock);
801021f6:	e9 25 22 00 00       	jmp    80104420 <release>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021fb:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
80102200:	eb ba                	jmp    801021bc <iderw+0x6c>
    idestart(b);
80102202:	89 d8                	mov    %ebx,%eax
80102204:	e8 67 fd ff ff       	call   80101f70 <idestart>
80102209:	eb bb                	jmp    801021c6 <iderw+0x76>
    panic("iderw: buf not locked");
8010220b:	c7 04 24 ea 6f 10 80 	movl   $0x80106fea,(%esp)
80102212:	e8 49 e1 ff ff       	call   80100360 <panic>
    panic("iderw: ide disk 1 not present");
80102217:	c7 04 24 15 70 10 80 	movl   $0x80107015,(%esp)
8010221e:	e8 3d e1 ff ff       	call   80100360 <panic>
    panic("iderw: nothing to do");
80102223:	c7 04 24 00 70 10 80 	movl   $0x80107000,(%esp)
8010222a:	e8 31 e1 ff ff       	call   80100360 <panic>
8010222f:	90                   	nop

80102230 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	56                   	push   %esi
80102234:	53                   	push   %ebx
80102235:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102238:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010223f:	00 c0 fe 
  ioapic->reg = reg;
80102242:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102249:	00 00 00 
  return ioapic->data;
8010224c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102252:	8b 42 10             	mov    0x10(%edx),%eax
  ioapic->reg = reg;
80102255:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010225b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102261:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102268:	c1 e8 10             	shr    $0x10,%eax
8010226b:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
8010226e:	8b 43 10             	mov    0x10(%ebx),%eax
  id = ioapicread(REG_ID) >> 24;
80102271:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102274:	39 c2                	cmp    %eax,%edx
80102276:	74 12                	je     8010228a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102278:	c7 04 24 34 70 10 80 	movl   $0x80107034,(%esp)
8010227f:	e8 cc e3 ff ff       	call   80100650 <cprintf>
80102284:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010228a:	ba 10 00 00 00       	mov    $0x10,%edx
8010228f:	31 c0                	xor    %eax,%eax
80102291:	eb 07                	jmp    8010229a <ioapicinit+0x6a>
80102293:	90                   	nop
80102294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102298:	89 cb                	mov    %ecx,%ebx
  ioapic->reg = reg;
8010229a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010229c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
801022a2:	8d 48 20             	lea    0x20(%eax),%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801022a5:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  for(i = 0; i <= maxintr; i++){
801022ab:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022ae:	89 4b 10             	mov    %ecx,0x10(%ebx)
801022b1:	8d 4a 01             	lea    0x1(%edx),%ecx
801022b4:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
801022b7:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
801022b9:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  for(i = 0; i <= maxintr; i++){
801022bf:	39 c6                	cmp    %eax,%esi
  ioapic->data = data;
801022c1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
801022c8:	7d ce                	jge    80102298 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022ca:	83 c4 10             	add    $0x10,%esp
801022cd:	5b                   	pop    %ebx
801022ce:	5e                   	pop    %esi
801022cf:	5d                   	pop    %ebp
801022d0:	c3                   	ret    
801022d1:	eb 0d                	jmp    801022e0 <ioapicenable>
801022d3:	90                   	nop
801022d4:	90                   	nop
801022d5:	90                   	nop
801022d6:	90                   	nop
801022d7:	90                   	nop
801022d8:	90                   	nop
801022d9:	90                   	nop
801022da:	90                   	nop
801022db:	90                   	nop
801022dc:	90                   	nop
801022dd:	90                   	nop
801022de:	90                   	nop
801022df:	90                   	nop

801022e0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	8b 55 08             	mov    0x8(%ebp),%edx
801022e6:	53                   	push   %ebx
801022e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ea:	8d 5a 20             	lea    0x20(%edx),%ebx
801022ed:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
  ioapic->reg = reg;
801022f1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022f7:	c1 e0 18             	shl    $0x18,%eax
  ioapic->reg = reg;
801022fa:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022fc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102302:	83 c1 01             	add    $0x1,%ecx
  ioapic->data = data;
80102305:	89 5a 10             	mov    %ebx,0x10(%edx)
  ioapic->reg = reg;
80102308:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
8010230a:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102310:	89 42 10             	mov    %eax,0x10(%edx)
}
80102313:	5b                   	pop    %ebx
80102314:	5d                   	pop    %ebp
80102315:	c3                   	ret    
80102316:	66 90                	xchg   %ax,%ax
80102318:	66 90                	xchg   %ax,%ax
8010231a:	66 90                	xchg   %ax,%ax
8010231c:	66 90                	xchg   %ax,%ax
8010231e:	66 90                	xchg   %ax,%ax

80102320 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102320:	55                   	push   %ebp
80102321:	89 e5                	mov    %esp,%ebp
80102323:	53                   	push   %ebx
80102324:	83 ec 14             	sub    $0x14,%esp
80102327:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010232a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102330:	75 7c                	jne    801023ae <kfree+0x8e>
80102332:	81 fb a8 58 11 80    	cmp    $0x801158a8,%ebx
80102338:	72 74                	jb     801023ae <kfree+0x8e>
8010233a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102340:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102345:	77 67                	ja     801023ae <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102347:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010234e:	00 
8010234f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102356:	00 
80102357:	89 1c 24             	mov    %ebx,(%esp)
8010235a:	e8 11 21 00 00       	call   80104470 <memset>

  if(kmem.use_lock)
8010235f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102365:	85 d2                	test   %edx,%edx
80102367:	75 37                	jne    801023a0 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102369:	a1 78 26 11 80       	mov    0x80112678,%eax
8010236e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102370:	a1 74 26 11 80       	mov    0x80112674,%eax
  kmem.freelist = r;
80102375:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010237b:	85 c0                	test   %eax,%eax
8010237d:	75 09                	jne    80102388 <kfree+0x68>
    release(&kmem.lock);
}
8010237f:	83 c4 14             	add    $0x14,%esp
80102382:	5b                   	pop    %ebx
80102383:	5d                   	pop    %ebp
80102384:	c3                   	ret    
80102385:	8d 76 00             	lea    0x0(%esi),%esi
    release(&kmem.lock);
80102388:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010238f:	83 c4 14             	add    $0x14,%esp
80102392:	5b                   	pop    %ebx
80102393:	5d                   	pop    %ebp
    release(&kmem.lock);
80102394:	e9 87 20 00 00       	jmp    80104420 <release>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&kmem.lock);
801023a0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801023a7:	e8 04 20 00 00       	call   801043b0 <acquire>
801023ac:	eb bb                	jmp    80102369 <kfree+0x49>
    panic("kfree");
801023ae:	c7 04 24 66 70 10 80 	movl   $0x80107066,(%esp)
801023b5:	e8 a6 df ff ff       	call   80100360 <panic>
801023ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023c0 <freerange>:
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
801023c8:	8b 45 08             	mov    0x8(%ebp),%eax
{
801023cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
801023ce:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023d4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023da:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023e0:	39 de                	cmp    %ebx,%esi
801023e2:	73 08                	jae    801023ec <freerange+0x2c>
801023e4:	eb 18                	jmp    801023fe <freerange+0x3e>
801023e6:	66 90                	xchg   %ax,%ax
801023e8:	89 da                	mov    %ebx,%edx
801023ea:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023ec:	89 14 24             	mov    %edx,(%esp)
801023ef:	e8 2c ff ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023fa:	39 f0                	cmp    %esi,%eax
801023fc:	76 ea                	jbe    801023e8 <freerange+0x28>
}
801023fe:	83 c4 10             	add    $0x10,%esp
80102401:	5b                   	pop    %ebx
80102402:	5e                   	pop    %esi
80102403:	5d                   	pop    %ebp
80102404:	c3                   	ret    
80102405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102410 <kinit1>:
{
80102410:	55                   	push   %ebp
80102411:	89 e5                	mov    %esp,%ebp
80102413:	56                   	push   %esi
80102414:	53                   	push   %ebx
80102415:	83 ec 10             	sub    $0x10,%esp
80102418:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
8010241b:	c7 44 24 04 6c 70 10 	movl   $0x8010706c,0x4(%esp)
80102422:	80 
80102423:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010242a:	e8 11 1e 00 00       	call   80104240 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
8010242f:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 0;
80102432:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102439:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
8010243c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102442:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102448:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010244e:	39 de                	cmp    %ebx,%esi
80102450:	73 0a                	jae    8010245c <kinit1+0x4c>
80102452:	eb 1a                	jmp    8010246e <kinit1+0x5e>
80102454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102458:	89 da                	mov    %ebx,%edx
8010245a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010245c:	89 14 24             	mov    %edx,(%esp)
8010245f:	e8 bc fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102464:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010246a:	39 c6                	cmp    %eax,%esi
8010246c:	73 ea                	jae    80102458 <kinit1+0x48>
}
8010246e:	83 c4 10             	add    $0x10,%esp
80102471:	5b                   	pop    %ebx
80102472:	5e                   	pop    %esi
80102473:	5d                   	pop    %ebp
80102474:	c3                   	ret    
80102475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <kinit2>:
{
80102480:	55                   	push   %ebp
80102481:	89 e5                	mov    %esp,%ebp
80102483:	56                   	push   %esi
80102484:	53                   	push   %ebx
80102485:	83 ec 10             	sub    $0x10,%esp
  p = (char*)PGROUNDUP((uint)vstart);
80102488:	8b 45 08             	mov    0x8(%ebp),%eax
{
8010248b:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010248e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102494:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010249a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801024a0:	39 de                	cmp    %ebx,%esi
801024a2:	73 08                	jae    801024ac <kinit2+0x2c>
801024a4:	eb 18                	jmp    801024be <kinit2+0x3e>
801024a6:	66 90                	xchg   %ax,%ax
801024a8:	89 da                	mov    %ebx,%edx
801024aa:	89 c3                	mov    %eax,%ebx
    kfree(p);
801024ac:	89 14 24             	mov    %edx,(%esp)
801024af:	e8 6c fe ff ff       	call   80102320 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801024b4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801024ba:	39 c6                	cmp    %eax,%esi
801024bc:	73 ea                	jae    801024a8 <kinit2+0x28>
  kmem.use_lock = 1;
801024be:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024c5:	00 00 00 
}
801024c8:	83 c4 10             	add    $0x10,%esp
801024cb:	5b                   	pop    %ebx
801024cc:	5e                   	pop    %esi
801024cd:	5d                   	pop    %ebp
801024ce:	c3                   	ret    
801024cf:	90                   	nop

801024d0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024d0:	55                   	push   %ebp
801024d1:	89 e5                	mov    %esp,%ebp
801024d3:	53                   	push   %ebx
801024d4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024d7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024dc:	85 c0                	test   %eax,%eax
801024de:	75 30                	jne    80102510 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024e0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024e6:	85 db                	test   %ebx,%ebx
801024e8:	74 08                	je     801024f2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ea:	8b 13                	mov    (%ebx),%edx
801024ec:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024f2:	85 c0                	test   %eax,%eax
801024f4:	74 0c                	je     80102502 <kalloc+0x32>
    release(&kmem.lock);
801024f6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024fd:	e8 1e 1f 00 00       	call   80104420 <release>
  return (char*)r;
}
80102502:	83 c4 14             	add    $0x14,%esp
80102505:	89 d8                	mov    %ebx,%eax
80102507:	5b                   	pop    %ebx
80102508:	5d                   	pop    %ebp
80102509:	c3                   	ret    
8010250a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
80102510:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102517:	e8 94 1e 00 00       	call   801043b0 <acquire>
8010251c:	a1 74 26 11 80       	mov    0x80112674,%eax
80102521:	eb bd                	jmp    801024e0 <kalloc+0x10>
80102523:	66 90                	xchg   %ax,%ax
80102525:	66 90                	xchg   %ax,%ax
80102527:	66 90                	xchg   %ax,%ax
80102529:	66 90                	xchg   %ax,%ax
8010252b:	66 90                	xchg   %ax,%ax
8010252d:	66 90                	xchg   %ax,%ax
8010252f:	90                   	nop

80102530 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102530:	ba 64 00 00 00       	mov    $0x64,%edx
80102535:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102536:	a8 01                	test   $0x1,%al
80102538:	0f 84 ba 00 00 00    	je     801025f8 <kbdgetc+0xc8>
8010253e:	b2 60                	mov    $0x60,%dl
80102540:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102541:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102544:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010254a:	0f 84 88 00 00 00    	je     801025d8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102550:	84 c0                	test   %al,%al
80102552:	79 2c                	jns    80102580 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102554:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010255a:	f6 c2 40             	test   $0x40,%dl
8010255d:	75 05                	jne    80102564 <kbdgetc+0x34>
8010255f:	89 c1                	mov    %eax,%ecx
80102561:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102564:	0f b6 81 a0 71 10 80 	movzbl -0x7fef8e60(%ecx),%eax
8010256b:	83 c8 40             	or     $0x40,%eax
8010256e:	0f b6 c0             	movzbl %al,%eax
80102571:	f7 d0                	not    %eax
80102573:	21 d0                	and    %edx,%eax
80102575:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010257a:	31 c0                	xor    %eax,%eax
8010257c:	c3                   	ret    
8010257d:	8d 76 00             	lea    0x0(%esi),%esi
{
80102580:	55                   	push   %ebp
80102581:	89 e5                	mov    %esp,%ebp
80102583:	53                   	push   %ebx
80102584:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(shift & E0ESC){
8010258a:	f6 c3 40             	test   $0x40,%bl
8010258d:	74 09                	je     80102598 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010258f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102592:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
80102595:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
80102598:	0f b6 91 a0 71 10 80 	movzbl -0x7fef8e60(%ecx),%edx
  shift ^= togglecode[data];
8010259f:	0f b6 81 a0 70 10 80 	movzbl -0x7fef8f60(%ecx),%eax
  shift |= shiftcode[data];
801025a6:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801025a8:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025aa:	89 d0                	mov    %edx,%eax
801025ac:	83 e0 03             	and    $0x3,%eax
801025af:	8b 04 85 80 70 10 80 	mov    -0x7fef8f80(,%eax,4),%eax
  shift ^= togglecode[data];
801025b6:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  if(shift & CAPSLOCK){
801025bc:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801025bf:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025c3:	74 0b                	je     801025d0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025c5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025c8:	83 fa 19             	cmp    $0x19,%edx
801025cb:	77 1b                	ja     801025e8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025cd:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025d0:	5b                   	pop    %ebx
801025d1:	5d                   	pop    %ebp
801025d2:	c3                   	ret    
801025d3:	90                   	nop
801025d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
801025d8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025df:	31 c0                	xor    %eax,%eax
801025e1:	c3                   	ret    
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
801025e8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025eb:	8d 50 20             	lea    0x20(%eax),%edx
801025ee:	83 f9 19             	cmp    $0x19,%ecx
801025f1:	0f 46 c2             	cmovbe %edx,%eax
  return c;
801025f4:	eb da                	jmp    801025d0 <kbdgetc+0xa0>
801025f6:	66 90                	xchg   %ax,%ax
    return -1;
801025f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025fd:	c3                   	ret    
801025fe:	66 90                	xchg   %ax,%ax

80102600 <kbdintr>:

void
kbdintr(void)
{
80102600:	55                   	push   %ebp
80102601:	89 e5                	mov    %esp,%ebp
80102603:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
80102606:	c7 04 24 30 25 10 80 	movl   $0x80102530,(%esp)
8010260d:	e8 9e e1 ff ff       	call   801007b0 <consoleintr>
}
80102612:	c9                   	leave  
80102613:	c3                   	ret    
80102614:	66 90                	xchg   %ax,%ax
80102616:	66 90                	xchg   %ax,%ax
80102618:	66 90                	xchg   %ax,%ax
8010261a:	66 90                	xchg   %ax,%ax
8010261c:	66 90                	xchg   %ax,%ax
8010261e:	66 90                	xchg   %ax,%ax

80102620 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102620:	55                   	push   %ebp
80102621:	89 c1                	mov    %eax,%ecx
80102623:	89 e5                	mov    %esp,%ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102625:	ba 70 00 00 00       	mov    $0x70,%edx
8010262a:	53                   	push   %ebx
8010262b:	31 c0                	xor    %eax,%eax
8010262d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010262e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102633:	89 da                	mov    %ebx,%edx
80102635:	ec                   	in     (%dx),%al
  return inb(CMOS_RETURN);
80102636:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102639:	b2 70                	mov    $0x70,%dl
8010263b:	89 01                	mov    %eax,(%ecx)
8010263d:	b8 02 00 00 00       	mov    $0x2,%eax
80102642:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102643:	89 da                	mov    %ebx,%edx
80102645:	ec                   	in     (%dx),%al
80102646:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102649:	b2 70                	mov    $0x70,%dl
8010264b:	89 41 04             	mov    %eax,0x4(%ecx)
8010264e:	b8 04 00 00 00       	mov    $0x4,%eax
80102653:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102654:	89 da                	mov    %ebx,%edx
80102656:	ec                   	in     (%dx),%al
80102657:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265a:	b2 70                	mov    $0x70,%dl
8010265c:	89 41 08             	mov    %eax,0x8(%ecx)
8010265f:	b8 07 00 00 00       	mov    $0x7,%eax
80102664:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102665:	89 da                	mov    %ebx,%edx
80102667:	ec                   	in     (%dx),%al
80102668:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010266b:	b2 70                	mov    $0x70,%dl
8010266d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102670:	b8 08 00 00 00       	mov    $0x8,%eax
80102675:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102676:	89 da                	mov    %ebx,%edx
80102678:	ec                   	in     (%dx),%al
80102679:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010267c:	b2 70                	mov    $0x70,%dl
8010267e:	89 41 10             	mov    %eax,0x10(%ecx)
80102681:	b8 09 00 00 00       	mov    $0x9,%eax
80102686:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102687:	89 da                	mov    %ebx,%edx
80102689:	ec                   	in     (%dx),%al
8010268a:	0f b6 d8             	movzbl %al,%ebx
8010268d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102690:	5b                   	pop    %ebx
80102691:	5d                   	pop    %ebp
80102692:	c3                   	ret    
80102693:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026a0 <lapicinit>:
  if(!lapic)
801026a0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801026a5:	55                   	push   %ebp
801026a6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801026a8:	85 c0                	test   %eax,%eax
801026aa:	0f 84 c0 00 00 00    	je     80102770 <lapicinit+0xd0>
  lapic[index] = value;
801026b0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801026b7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026ba:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026bd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026c4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026ca:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026d1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026d4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026d7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026de:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026e1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026e4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026eb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ee:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801026f1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026f8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026fb:	8b 50 20             	mov    0x20(%eax),%edx
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026fe:	8b 50 30             	mov    0x30(%eax),%edx
80102701:	c1 ea 10             	shr    $0x10,%edx
80102704:	80 fa 03             	cmp    $0x3,%dl
80102707:	77 6f                	ja     80102778 <lapicinit+0xd8>
  lapic[index] = value;
80102709:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102710:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102713:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102716:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010271d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102720:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102723:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010272a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010272d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102730:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102737:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010273a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010273d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102744:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102747:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010274a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102751:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102754:	8b 50 20             	mov    0x20(%eax),%edx
80102757:	90                   	nop
  while(lapic[ICRLO] & DELIVS)
80102758:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010275e:	80 e6 10             	and    $0x10,%dh
80102761:	75 f5                	jne    80102758 <lapicinit+0xb8>
  lapic[index] = value;
80102763:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010276a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010276d:	8b 40 20             	mov    0x20(%eax),%eax
}
80102770:	5d                   	pop    %ebp
80102771:	c3                   	ret    
80102772:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
80102778:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010277f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102782:	8b 50 20             	mov    0x20(%eax),%edx
80102785:	eb 82                	jmp    80102709 <lapicinit+0x69>
80102787:	89 f6                	mov    %esi,%esi
80102789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102790 <lapicid>:
  if (!lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0c                	je     801027a8 <lapicid+0x18>
  return lapic[ID] >> 24;
8010279c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010279f:	5d                   	pop    %ebp
  return lapic[ID] >> 24;
801027a0:	c1 e8 18             	shr    $0x18,%eax
}
801027a3:	c3                   	ret    
801027a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
801027a8:	31 c0                	xor    %eax,%eax
}
801027aa:	5d                   	pop    %ebp
801027ab:	c3                   	ret    
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <lapiceoi>:
  if(lapic)
801027b0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
{
801027b5:	55                   	push   %ebp
801027b6:	89 e5                	mov    %esp,%ebp
  if(lapic)
801027b8:	85 c0                	test   %eax,%eax
801027ba:	74 0d                	je     801027c9 <lapiceoi+0x19>
  lapic[index] = value;
801027bc:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027c3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027c6:	8b 40 20             	mov    0x20(%eax),%eax
}
801027c9:	5d                   	pop    %ebp
801027ca:	c3                   	ret    
801027cb:	90                   	nop
801027cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027d0 <microdelay>:
{
801027d0:	55                   	push   %ebp
801027d1:	89 e5                	mov    %esp,%ebp
}
801027d3:	5d                   	pop    %ebp
801027d4:	c3                   	ret    
801027d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027e0 <lapicstartap>:
{
801027e0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027e1:	ba 70 00 00 00       	mov    $0x70,%edx
801027e6:	89 e5                	mov    %esp,%ebp
801027e8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027ed:	53                   	push   %ebx
801027ee:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027f1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027f4:	ee                   	out    %al,(%dx)
801027f5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027fa:	b2 71                	mov    $0x71,%dl
801027fc:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
801027fd:	31 c0                	xor    %eax,%eax
801027ff:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102805:	89 d8                	mov    %ebx,%eax
80102807:	c1 e8 04             	shr    $0x4,%eax
8010280a:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102810:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(ICRHI, apicid<<24);
80102815:	c1 e1 18             	shl    $0x18,%ecx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102818:	c1 eb 0c             	shr    $0xc,%ebx
  lapic[index] = value;
8010281b:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010282b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102838:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010283e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 50 20             	mov    0x20(%eax),%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102847:	89 da                	mov    %ebx,%edx
80102849:	80 ce 06             	or     $0x6,%dh
  lapic[index] = value;
8010284c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102852:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102855:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010285b:	8b 48 20             	mov    0x20(%eax),%ecx
  lapic[index] = value;
8010285e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102864:	8b 40 20             	mov    0x20(%eax),%eax
}
80102867:	5b                   	pop    %ebx
80102868:	5d                   	pop    %ebp
80102869:	c3                   	ret    
8010286a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102870 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102870:	55                   	push   %ebp
80102871:	ba 70 00 00 00       	mov    $0x70,%edx
80102876:	89 e5                	mov    %esp,%ebp
80102878:	b8 0b 00 00 00       	mov    $0xb,%eax
8010287d:	57                   	push   %edi
8010287e:	56                   	push   %esi
8010287f:	53                   	push   %ebx
80102880:	83 ec 4c             	sub    $0x4c,%esp
80102883:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102884:	b2 71                	mov    $0x71,%dl
80102886:	ec                   	in     (%dx),%al
80102887:	88 45 b7             	mov    %al,-0x49(%ebp)
8010288a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010288d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102891:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102894:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102898:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010289d:	89 d8                	mov    %ebx,%eax
8010289f:	e8 7c fd ff ff       	call   80102620 <fill_rtcdate>
801028a4:	b8 0a 00 00 00       	mov    $0xa,%eax
801028a9:	89 f2                	mov    %esi,%edx
801028ab:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028ac:	ba 71 00 00 00       	mov    $0x71,%edx
801028b1:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
801028b2:	84 c0                	test   %al,%al
801028b4:	78 e7                	js     8010289d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
801028b6:	89 f8                	mov    %edi,%eax
801028b8:	e8 63 fd ff ff       	call   80102620 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028bd:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028c4:	00 
801028c5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028c9:	89 1c 24             	mov    %ebx,(%esp)
801028cc:	e8 ef 1b 00 00       	call   801044c0 <memcmp>
801028d1:	85 c0                	test   %eax,%eax
801028d3:	75 c3                	jne    80102898 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028d5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028d9:	75 78                	jne    80102953 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028db:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028de:	89 c2                	mov    %eax,%edx
801028e0:	83 e0 0f             	and    $0xf,%eax
801028e3:	c1 ea 04             	shr    $0x4,%edx
801028e6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028e9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028ec:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028ef:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028f2:	89 c2                	mov    %eax,%edx
801028f4:	83 e0 0f             	and    $0xf,%eax
801028f7:	c1 ea 04             	shr    $0x4,%edx
801028fa:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028fd:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102900:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102903:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102906:	89 c2                	mov    %eax,%edx
80102908:	83 e0 0f             	and    $0xf,%eax
8010290b:	c1 ea 04             	shr    $0x4,%edx
8010290e:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102911:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102914:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102917:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010291a:	89 c2                	mov    %eax,%edx
8010291c:	83 e0 0f             	and    $0xf,%eax
8010291f:	c1 ea 04             	shr    $0x4,%edx
80102922:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102925:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102928:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010292b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010292e:	89 c2                	mov    %eax,%edx
80102930:	83 e0 0f             	and    $0xf,%eax
80102933:	c1 ea 04             	shr    $0x4,%edx
80102936:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102939:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010293c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010293f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102942:	89 c2                	mov    %eax,%edx
80102944:	83 e0 0f             	and    $0xf,%eax
80102947:	c1 ea 04             	shr    $0x4,%edx
8010294a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010294d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102950:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102953:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102956:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102959:	89 01                	mov    %eax,(%ecx)
8010295b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010295e:	89 41 04             	mov    %eax,0x4(%ecx)
80102961:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102964:	89 41 08             	mov    %eax,0x8(%ecx)
80102967:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010296a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010296d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102970:	89 41 10             	mov    %eax,0x10(%ecx)
80102973:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102976:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102979:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102980:	83 c4 4c             	add    $0x4c,%esp
80102983:	5b                   	pop    %ebx
80102984:	5e                   	pop    %esi
80102985:	5f                   	pop    %edi
80102986:	5d                   	pop    %ebp
80102987:	c3                   	ret    
80102988:	66 90                	xchg   %ax,%ax
8010298a:	66 90                	xchg   %ax,%ax
8010298c:	66 90                	xchg   %ax,%ax
8010298e:	66 90                	xchg   %ax,%ax

80102990 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102990:	55                   	push   %ebp
80102991:	89 e5                	mov    %esp,%ebp
80102993:	57                   	push   %edi
80102994:	56                   	push   %esi
80102995:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102996:	31 db                	xor    %ebx,%ebx
{
80102998:	83 ec 1c             	sub    $0x1c,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
8010299b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
801029a0:	85 c0                	test   %eax,%eax
801029a2:	7e 78                	jle    80102a1c <install_trans+0x8c>
801029a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029a8:	a1 b4 26 11 80       	mov    0x801126b4,%eax
801029ad:	01 d8                	add    %ebx,%eax
801029af:	83 c0 01             	add    $0x1,%eax
801029b2:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b6:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029bb:	89 04 24             	mov    %eax,(%esp)
801029be:	e8 0d d7 ff ff       	call   801000d0 <bread>
801029c3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
801029cc:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029cf:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029d8:	89 04 24             	mov    %eax,(%esp)
801029db:	e8 f0 d6 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029e7:	00 
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029e8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ea:	8d 47 5c             	lea    0x5c(%edi),%eax
801029ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801029f1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029f4:	89 04 24             	mov    %eax,(%esp)
801029f7:	e8 14 1b 00 00       	call   80104510 <memmove>
    bwrite(dbuf);  // write dst to disk
801029fc:	89 34 24             	mov    %esi,(%esp)
801029ff:	e8 9c d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a04:	89 3c 24             	mov    %edi,(%esp)
80102a07:	e8 d4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a0c:	89 34 24             	mov    %esi,(%esp)
80102a0f:	e8 cc d7 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102a14:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
80102a1a:	7f 8c                	jg     801029a8 <install_trans+0x18>
  }
}
80102a1c:	83 c4 1c             	add    $0x1c,%esp
80102a1f:	5b                   	pop    %ebx
80102a20:	5e                   	pop    %esi
80102a21:	5f                   	pop    %edi
80102a22:	5d                   	pop    %ebp
80102a23:	c3                   	ret    
80102a24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a30 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a30:	55                   	push   %ebp
80102a31:	89 e5                	mov    %esp,%ebp
80102a33:	57                   	push   %edi
80102a34:	56                   	push   %esi
80102a35:	53                   	push   %ebx
80102a36:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a39:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a3e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a42:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a47:	89 04 24             	mov    %eax,(%esp)
80102a4a:	e8 81 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a4f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a55:	31 d2                	xor    %edx,%edx
80102a57:	85 db                	test   %ebx,%ebx
  struct buf *buf = bread(log.dev, log.start);
80102a59:	89 c7                	mov    %eax,%edi
  hb->n = log.lh.n;
80102a5b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a5e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a61:	7e 17                	jle    80102a7a <write_head+0x4a>
80102a63:	90                   	nop
80102a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a68:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a6f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102a73:	83 c2 01             	add    $0x1,%edx
80102a76:	39 da                	cmp    %ebx,%edx
80102a78:	75 ee                	jne    80102a68 <write_head+0x38>
  }
  bwrite(buf);
80102a7a:	89 3c 24             	mov    %edi,(%esp)
80102a7d:	e8 1e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a82:	89 3c 24             	mov    %edi,(%esp)
80102a85:	e8 56 d7 ff ff       	call   801001e0 <brelse>
}
80102a8a:	83 c4 1c             	add    $0x1c,%esp
80102a8d:	5b                   	pop    %ebx
80102a8e:	5e                   	pop    %esi
80102a8f:	5f                   	pop    %edi
80102a90:	5d                   	pop    %ebp
80102a91:	c3                   	ret    
80102a92:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102aa0 <initlog>:
{
80102aa0:	55                   	push   %ebp
80102aa1:	89 e5                	mov    %esp,%ebp
80102aa3:	56                   	push   %esi
80102aa4:	53                   	push   %ebx
80102aa5:	83 ec 30             	sub    $0x30,%esp
80102aa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102aab:	c7 44 24 04 a0 72 10 	movl   $0x801072a0,0x4(%esp)
80102ab2:	80 
80102ab3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102aba:	e8 81 17 00 00       	call   80104240 <initlock>
  readsb(dev, &sb);
80102abf:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ac2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102ac6:	89 1c 24             	mov    %ebx,(%esp)
80102ac9:	e8 82 e9 ff ff       	call   80101450 <readsb>
  log.start = sb.logstart;
80102ace:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ad1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  struct buf *buf = bread(log.dev, log.start);
80102ad4:	89 1c 24             	mov    %ebx,(%esp)
  log.dev = dev;
80102ad7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  struct buf *buf = bread(log.dev, log.start);
80102add:	89 44 24 04          	mov    %eax,0x4(%esp)
  log.size = sb.nlog;
80102ae1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
  log.start = sb.logstart;
80102ae7:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  struct buf *buf = bread(log.dev, log.start);
80102aec:	e8 df d5 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102af1:	31 d2                	xor    %edx,%edx
  log.lh.n = lh->n;
80102af3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102af6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102af9:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102afb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102b01:	7e 17                	jle    80102b1a <initlog+0x7a>
80102b03:	90                   	nop
80102b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102b08:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102b0c:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102b13:	83 c2 01             	add    $0x1,%edx
80102b16:	39 da                	cmp    %ebx,%edx
80102b18:	75 ee                	jne    80102b08 <initlog+0x68>
  brelse(buf);
80102b1a:	89 04 24             	mov    %eax,(%esp)
80102b1d:	e8 be d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b22:	e8 69 fe ff ff       	call   80102990 <install_trans>
  log.lh.n = 0;
80102b27:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b2e:	00 00 00 
  write_head(); // clear the log
80102b31:	e8 fa fe ff ff       	call   80102a30 <write_head>
}
80102b36:	83 c4 30             	add    $0x30,%esp
80102b39:	5b                   	pop    %ebx
80102b3a:	5e                   	pop    %esi
80102b3b:	5d                   	pop    %ebp
80102b3c:	c3                   	ret    
80102b3d:	8d 76 00             	lea    0x0(%esi),%esi

80102b40 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b40:	55                   	push   %ebp
80102b41:	89 e5                	mov    %esp,%ebp
80102b43:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b46:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b4d:	e8 5e 18 00 00       	call   801043b0 <acquire>
80102b52:	eb 18                	jmp    80102b6c <begin_op+0x2c>
80102b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b58:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b5f:	80 
80102b60:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b67:	e8 14 12 00 00       	call   80103d80 <sleep>
    if(log.committing){
80102b6c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b71:	85 c0                	test   %eax,%eax
80102b73:	75 e3                	jne    80102b58 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b75:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b7a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b80:	83 c0 01             	add    $0x1,%eax
80102b83:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b86:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b89:	83 fa 1e             	cmp    $0x1e,%edx
80102b8c:	7f ca                	jg     80102b58 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b8e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      log.outstanding += 1;
80102b95:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b9a:	e8 81 18 00 00       	call   80104420 <release>
      break;
    }
  }
}
80102b9f:	c9                   	leave  
80102ba0:	c3                   	ret    
80102ba1:	eb 0d                	jmp    80102bb0 <end_op>
80102ba3:	90                   	nop
80102ba4:	90                   	nop
80102ba5:	90                   	nop
80102ba6:	90                   	nop
80102ba7:	90                   	nop
80102ba8:	90                   	nop
80102ba9:	90                   	nop
80102baa:	90                   	nop
80102bab:	90                   	nop
80102bac:	90                   	nop
80102bad:	90                   	nop
80102bae:	90                   	nop
80102baf:	90                   	nop

80102bb0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bb0:	55                   	push   %ebp
80102bb1:	89 e5                	mov    %esp,%ebp
80102bb3:	57                   	push   %edi
80102bb4:	56                   	push   %esi
80102bb5:	53                   	push   %ebx
80102bb6:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bb9:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102bc0:	e8 eb 17 00 00       	call   801043b0 <acquire>
  log.outstanding -= 1;
80102bc5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102bca:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
  log.outstanding -= 1;
80102bd0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bd3:	85 d2                	test   %edx,%edx
  log.outstanding -= 1;
80102bd5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bda:	0f 85 f3 00 00 00    	jne    80102cd3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102be0:	85 c0                	test   %eax,%eax
80102be2:	0f 85 cb 00 00 00    	jne    80102cb3 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102be8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bef:	31 db                	xor    %ebx,%ebx
    log.committing = 1;
80102bf1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bf8:	00 00 00 
  release(&log.lock);
80102bfb:	e8 20 18 00 00       	call   80104420 <release>
  if (log.lh.n > 0) {
80102c00:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102c05:	85 c0                	test   %eax,%eax
80102c07:	0f 8e 90 00 00 00    	jle    80102c9d <end_op+0xed>
80102c0d:	8d 76 00             	lea    0x0(%esi),%esi
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c10:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102c15:	01 d8                	add    %ebx,%eax
80102c17:	83 c0 01             	add    $0x1,%eax
80102c1a:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1e:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c23:	89 04 24             	mov    %eax,(%esp)
80102c26:	e8 a5 d4 ff ff       	call   801000d0 <bread>
80102c2b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c2d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
  for (tail = 0; tail < log.lh.n; tail++) {
80102c34:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c37:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c3b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c40:	89 04 24             	mov    %eax,(%esp)
80102c43:	e8 88 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c48:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c4f:	00 
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c50:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c52:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c55:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c59:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c5c:	89 04 24             	mov    %eax,(%esp)
80102c5f:	e8 ac 18 00 00       	call   80104510 <memmove>
    bwrite(to);  // write the log
80102c64:	89 34 24             	mov    %esi,(%esp)
80102c67:	e8 34 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c6c:	89 3c 24             	mov    %edi,(%esp)
80102c6f:	e8 6c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c74:	89 34 24             	mov    %esi,(%esp)
80102c77:	e8 64 d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c7c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c82:	7c 8c                	jl     80102c10 <end_op+0x60>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c84:	e8 a7 fd ff ff       	call   80102a30 <write_head>
    install_trans(); // Now install writes to home locations
80102c89:	e8 02 fd ff ff       	call   80102990 <install_trans>
    log.lh.n = 0;
80102c8e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c95:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c98:	e8 93 fd ff ff       	call   80102a30 <write_head>
    acquire(&log.lock);
80102c9d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca4:	e8 07 17 00 00       	call   801043b0 <acquire>
    log.committing = 0;
80102ca9:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102cb0:	00 00 00 
    wakeup(&log);
80102cb3:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cba:	e8 61 12 00 00       	call   80103f20 <wakeup>
    release(&log.lock);
80102cbf:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cc6:	e8 55 17 00 00       	call   80104420 <release>
}
80102ccb:	83 c4 1c             	add    $0x1c,%esp
80102cce:	5b                   	pop    %ebx
80102ccf:	5e                   	pop    %esi
80102cd0:	5f                   	pop    %edi
80102cd1:	5d                   	pop    %ebp
80102cd2:	c3                   	ret    
    panic("log.committing");
80102cd3:	c7 04 24 a4 72 10 80 	movl   $0x801072a4,(%esp)
80102cda:	e8 81 d6 ff ff       	call   80100360 <panic>
80102cdf:	90                   	nop

80102ce0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ce0:	55                   	push   %ebp
80102ce1:	89 e5                	mov    %esp,%ebp
80102ce3:	53                   	push   %ebx
80102ce4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ce7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
{
80102cec:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cef:	83 f8 1d             	cmp    $0x1d,%eax
80102cf2:	0f 8f 98 00 00 00    	jg     80102d90 <log_write+0xb0>
80102cf8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cfe:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102d01:	39 d0                	cmp    %edx,%eax
80102d03:	0f 8d 87 00 00 00    	jge    80102d90 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d09:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102d0e:	85 c0                	test   %eax,%eax
80102d10:	0f 8e 86 00 00 00    	jle    80102d9c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d16:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102d1d:	e8 8e 16 00 00       	call   801043b0 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d22:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d28:	83 fa 00             	cmp    $0x0,%edx
80102d2b:	7e 54                	jle    80102d81 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d2d:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102d30:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d32:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d38:	75 0f                	jne    80102d49 <log_write+0x69>
80102d3a:	eb 3c                	jmp    80102d78 <log_write+0x98>
80102d3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d40:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d47:	74 2f                	je     80102d78 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102d49:	83 c0 01             	add    $0x1,%eax
80102d4c:	39 d0                	cmp    %edx,%eax
80102d4e:	75 f0                	jne    80102d40 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102d50:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d57:	83 c2 01             	add    $0x1,%edx
80102d5a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d60:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d63:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d6a:	83 c4 14             	add    $0x14,%esp
80102d6d:	5b                   	pop    %ebx
80102d6e:	5d                   	pop    %ebp
  release(&log.lock);
80102d6f:	e9 ac 16 00 00       	jmp    80104420 <release>
80102d74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  log.lh.block[i] = b->blockno;
80102d78:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d7f:	eb df                	jmp    80102d60 <log_write+0x80>
80102d81:	8b 43 08             	mov    0x8(%ebx),%eax
80102d84:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d89:	75 d5                	jne    80102d60 <log_write+0x80>
80102d8b:	eb ca                	jmp    80102d57 <log_write+0x77>
80102d8d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("too big a transaction");
80102d90:	c7 04 24 b3 72 10 80 	movl   $0x801072b3,(%esp)
80102d97:	e8 c4 d5 ff ff       	call   80100360 <panic>
    panic("log_write outside of trans");
80102d9c:	c7 04 24 c9 72 10 80 	movl   $0x801072c9,(%esp)
80102da3:	e8 b8 d5 ff ff       	call   80100360 <panic>
80102da8:	66 90                	xchg   %ax,%ax
80102daa:	66 90                	xchg   %ax,%ax
80102dac:	66 90                	xchg   %ax,%ax
80102dae:	66 90                	xchg   %ax,%ax

80102db0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102db0:	55                   	push   %ebp
80102db1:	89 e5                	mov    %esp,%ebp
80102db3:	53                   	push   %ebx
80102db4:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102db7:	e8 04 09 00 00       	call   801036c0 <cpuid>
80102dbc:	89 c3                	mov    %eax,%ebx
80102dbe:	e8 fd 08 00 00       	call   801036c0 <cpuid>
80102dc3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102dc7:	c7 04 24 e4 72 10 80 	movl   $0x801072e4,(%esp)
80102dce:	89 44 24 04          	mov    %eax,0x4(%esp)
80102dd2:	e8 79 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102dd7:	e8 b4 28 00 00       	call   80105690 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102ddc:	e8 5f 08 00 00       	call   80103640 <mycpu>
80102de1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102de3:	b8 01 00 00 00       	mov    $0x1,%eax
80102de8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102def:	e8 ac 0b 00 00       	call   801039a0 <scheduler>
80102df4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102e00 <mpenter>:
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e06:	e8 45 39 00 00       	call   80106750 <switchkvm>
  seginit();
80102e0b:	e8 80 38 00 00       	call   80106690 <seginit>
  lapicinit();
80102e10:	e8 8b f8 ff ff       	call   801026a0 <lapicinit>
  mpmain();
80102e15:	e8 96 ff ff ff       	call   80102db0 <mpmain>
80102e1a:	66 90                	xchg   %ax,%ax
80102e1c:	66 90                	xchg   %ax,%ax
80102e1e:	66 90                	xchg   %ax,%ax

80102e20 <main>:
{
80102e20:	55                   	push   %ebp
80102e21:	89 e5                	mov    %esp,%ebp
80102e23:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e24:	bb 80 27 11 80       	mov    $0x80112780,%ebx
{
80102e29:	83 e4 f0             	and    $0xfffffff0,%esp
80102e2c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e2f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e36:	80 
80102e37:	c7 04 24 a8 58 11 80 	movl   $0x801158a8,(%esp)
80102e3e:	e8 cd f5 ff ff       	call   80102410 <kinit1>
  kvmalloc();      // kernel page table
80102e43:	e8 98 3d 00 00       	call   80106be0 <kvmalloc>
  mpinit();        // detect other processors
80102e48:	e8 73 01 00 00       	call   80102fc0 <mpinit>
80102e4d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e50:	e8 4b f8 ff ff       	call   801026a0 <lapicinit>
  seginit();       // segment descriptors
80102e55:	e8 36 38 00 00       	call   80106690 <seginit>
  picinit();       // disable pic
80102e5a:	e8 21 03 00 00       	call   80103180 <picinit>
80102e5f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e60:	e8 cb f3 ff ff       	call   80102230 <ioapicinit>
  consoleinit();   // console hardware
80102e65:	e8 e6 da ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e6a:	e8 41 2b 00 00       	call   801059b0 <uartinit>
80102e6f:	90                   	nop
  pinit();         // process table
80102e70:	e8 ab 07 00 00       	call   80103620 <pinit>
  tvinit();        // trap vectors
80102e75:	e8 76 27 00 00       	call   801055f0 <tvinit>
  binit();         // buffer cache
80102e7a:	e8 c1 d1 ff ff       	call   80100040 <binit>
80102e7f:	90                   	nop
  fileinit();      // file table
80102e80:	e8 fb de ff ff       	call   80100d80 <fileinit>
  ideinit();       // disk 
80102e85:	e8 a6 f1 ff ff       	call   80102030 <ideinit>
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e8a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e91:	00 
80102e92:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e99:	80 
80102e9a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102ea1:	e8 6a 16 00 00       	call   80104510 <memmove>
  for(c = cpus; c < cpus+ncpu; c++){
80102ea6:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ead:	00 00 00 
80102eb0:	05 80 27 11 80       	add    $0x80112780,%eax
80102eb5:	39 d8                	cmp    %ebx,%eax
80102eb7:	76 6a                	jbe    80102f23 <main+0x103>
80102eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ec0:	e8 7b 07 00 00       	call   80103640 <mycpu>
80102ec5:	39 d8                	cmp    %ebx,%eax
80102ec7:	74 41                	je     80102f0a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ec9:	e8 02 f6 ff ff       	call   801024d0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102ece:	c7 05 f8 6f 00 80 00 	movl   $0x80102e00,0x80006ff8
80102ed5:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102ed8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102edf:	90 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ee2:	05 00 10 00 00       	add    $0x1000,%eax
80102ee7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
80102eec:	0f b6 03             	movzbl (%ebx),%eax
80102eef:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ef6:	00 
80102ef7:	89 04 24             	mov    %eax,(%esp)
80102efa:	e8 e1 f8 ff ff       	call   801027e0 <lapicstartap>
80102eff:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f00:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f06:	85 c0                	test   %eax,%eax
80102f08:	74 f6                	je     80102f00 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
80102f0a:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102f11:	00 00 00 
80102f14:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f1a:	05 80 27 11 80       	add    $0x80112780,%eax
80102f1f:	39 c3                	cmp    %eax,%ebx
80102f21:	72 9d                	jb     80102ec0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f23:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f2a:	8e 
80102f2b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f32:	e8 49 f5 ff ff       	call   80102480 <kinit2>
  userinit();      // first user process
80102f37:	e8 d4 07 00 00       	call   80103710 <userinit>
  mpmain();        // finish this processor's setup
80102f3c:	e8 6f fe ff ff       	call   80102db0 <mpmain>
80102f41:	66 90                	xchg   %ax,%ax
80102f43:	66 90                	xchg   %ax,%ax
80102f45:	66 90                	xchg   %ax,%ax
80102f47:	66 90                	xchg   %ax,%ax
80102f49:	66 90                	xchg   %ax,%ax
80102f4b:	66 90                	xchg   %ax,%ax
80102f4d:	66 90                	xchg   %ax,%ax
80102f4f:	90                   	nop

80102f50 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f50:	55                   	push   %ebp
80102f51:	89 e5                	mov    %esp,%ebp
80102f53:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f54:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
80102f5a:	53                   	push   %ebx
  e = addr+len;
80102f5b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
80102f5e:	83 ec 10             	sub    $0x10,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80102f61:	39 de                	cmp    %ebx,%esi
80102f63:	73 3c                	jae    80102fa1 <mpsearch1+0x51>
80102f65:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f68:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f6f:	00 
80102f70:	c7 44 24 04 f8 72 10 	movl   $0x801072f8,0x4(%esp)
80102f77:	80 
80102f78:	89 34 24             	mov    %esi,(%esp)
80102f7b:	e8 40 15 00 00       	call   801044c0 <memcmp>
80102f80:	85 c0                	test   %eax,%eax
80102f82:	75 16                	jne    80102f9a <mpsearch1+0x4a>
80102f84:	31 c9                	xor    %ecx,%ecx
80102f86:	31 d2                	xor    %edx,%edx
    sum += addr[i];
80102f88:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
  for(i=0; i<len; i++)
80102f8c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f8f:	01 c1                	add    %eax,%ecx
  for(i=0; i<len; i++)
80102f91:	83 fa 10             	cmp    $0x10,%edx
80102f94:	75 f2                	jne    80102f88 <mpsearch1+0x38>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f96:	84 c9                	test   %cl,%cl
80102f98:	74 10                	je     80102faa <mpsearch1+0x5a>
  for(p = addr; p < e; p += sizeof(struct mp))
80102f9a:	83 c6 10             	add    $0x10,%esi
80102f9d:	39 f3                	cmp    %esi,%ebx
80102f9f:	77 c7                	ja     80102f68 <mpsearch1+0x18>
      return (struct mp*)p;
  return 0;
}
80102fa1:	83 c4 10             	add    $0x10,%esp
  return 0;
80102fa4:	31 c0                	xor    %eax,%eax
}
80102fa6:	5b                   	pop    %ebx
80102fa7:	5e                   	pop    %esi
80102fa8:	5d                   	pop    %ebp
80102fa9:	c3                   	ret    
80102faa:	83 c4 10             	add    $0x10,%esp
80102fad:	89 f0                	mov    %esi,%eax
80102faf:	5b                   	pop    %ebx
80102fb0:	5e                   	pop    %esi
80102fb1:	5d                   	pop    %ebp
80102fb2:	c3                   	ret    
80102fb3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fc0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fc0:	55                   	push   %ebp
80102fc1:	89 e5                	mov    %esp,%ebp
80102fc3:	57                   	push   %edi
80102fc4:	56                   	push   %esi
80102fc5:	53                   	push   %ebx
80102fc6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fc9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fd0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fd7:	c1 e0 08             	shl    $0x8,%eax
80102fda:	09 d0                	or     %edx,%eax
80102fdc:	c1 e0 04             	shl    $0x4,%eax
80102fdf:	85 c0                	test   %eax,%eax
80102fe1:	75 1b                	jne    80102ffe <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fe3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fea:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102ff1:	c1 e0 08             	shl    $0x8,%eax
80102ff4:	09 d0                	or     %edx,%eax
80102ff6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102ff9:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
80102ffe:	ba 00 04 00 00       	mov    $0x400,%edx
80103003:	e8 48 ff ff ff       	call   80102f50 <mpsearch1>
80103008:	85 c0                	test   %eax,%eax
8010300a:	89 c7                	mov    %eax,%edi
8010300c:	0f 84 22 01 00 00    	je     80103134 <mpinit+0x174>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103012:	8b 77 04             	mov    0x4(%edi),%esi
80103015:	85 f6                	test   %esi,%esi
80103017:	0f 84 30 01 00 00    	je     8010314d <mpinit+0x18d>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010301d:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103023:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010302a:	00 
8010302b:	c7 44 24 04 fd 72 10 	movl   $0x801072fd,0x4(%esp)
80103032:	80 
80103033:	89 04 24             	mov    %eax,(%esp)
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103036:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103039:	e8 82 14 00 00       	call   801044c0 <memcmp>
8010303e:	85 c0                	test   %eax,%eax
80103040:	0f 85 07 01 00 00    	jne    8010314d <mpinit+0x18d>
  if(conf->version != 1 && conf->version != 4)
80103046:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010304d:	3c 04                	cmp    $0x4,%al
8010304f:	0f 85 0b 01 00 00    	jne    80103160 <mpinit+0x1a0>
  if(sum((uchar*)conf, conf->length) != 0)
80103055:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
  for(i=0; i<len; i++)
8010305c:	85 c0                	test   %eax,%eax
8010305e:	74 21                	je     80103081 <mpinit+0xc1>
  sum = 0;
80103060:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103062:	31 d2                	xor    %edx,%edx
80103064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103068:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010306f:	80 
  for(i=0; i<len; i++)
80103070:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103073:	01 d9                	add    %ebx,%ecx
  for(i=0; i<len; i++)
80103075:	39 d0                	cmp    %edx,%eax
80103077:	7f ef                	jg     80103068 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103079:	84 c9                	test   %cl,%cl
8010307b:	0f 85 cc 00 00 00    	jne    8010314d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103081:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103084:	85 c0                	test   %eax,%eax
80103086:	0f 84 c1 00 00 00    	je     8010314d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010308c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  ismp = 1;
80103092:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103097:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010309c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
801030a3:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
801030a9:	03 55 e4             	add    -0x1c(%ebp),%edx
801030ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801030b0:	39 c2                	cmp    %eax,%edx
801030b2:	76 1b                	jbe    801030cf <mpinit+0x10f>
801030b4:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
801030b7:	80 f9 04             	cmp    $0x4,%cl
801030ba:	77 74                	ja     80103130 <mpinit+0x170>
801030bc:	ff 24 8d 3c 73 10 80 	jmp    *-0x7fef8cc4(,%ecx,4)
801030c3:	90                   	nop
801030c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030c8:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030cb:	39 c2                	cmp    %eax,%edx
801030cd:	77 e5                	ja     801030b4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030cf:	85 db                	test   %ebx,%ebx
801030d1:	0f 84 93 00 00 00    	je     8010316a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030d7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030db:	74 12                	je     801030ef <mpinit+0x12f>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030dd:	ba 22 00 00 00       	mov    $0x22,%edx
801030e2:	b8 70 00 00 00       	mov    $0x70,%eax
801030e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030e8:	b2 23                	mov    $0x23,%dl
801030ea:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030eb:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ee:	ee                   	out    %al,(%dx)
  }
}
801030ef:	83 c4 1c             	add    $0x1c,%esp
801030f2:	5b                   	pop    %ebx
801030f3:	5e                   	pop    %esi
801030f4:	5f                   	pop    %edi
801030f5:	5d                   	pop    %ebp
801030f6:	c3                   	ret    
801030f7:	90                   	nop
      if(ncpu < NCPU) {
801030f8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030fe:	83 fe 07             	cmp    $0x7,%esi
80103101:	7f 17                	jg     8010311a <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103103:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
80103107:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
8010310d:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103114:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
      p += sizeof(struct mpproc);
8010311a:	83 c0 14             	add    $0x14,%eax
      continue;
8010311d:	eb 91                	jmp    801030b0 <mpinit+0xf0>
8010311f:	90                   	nop
      ioapicid = ioapic->apicno;
80103120:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103124:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103127:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      continue;
8010312d:	eb 81                	jmp    801030b0 <mpinit+0xf0>
8010312f:	90                   	nop
      ismp = 0;
80103130:	31 db                	xor    %ebx,%ebx
80103132:	eb 83                	jmp    801030b7 <mpinit+0xf7>
  return mpsearch1(0xF0000, 0x10000);
80103134:	ba 00 00 01 00       	mov    $0x10000,%edx
80103139:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010313e:	e8 0d fe ff ff       	call   80102f50 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103143:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103145:	89 c7                	mov    %eax,%edi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103147:	0f 85 c5 fe ff ff    	jne    80103012 <mpinit+0x52>
    panic("Expect to run on an SMP");
8010314d:	c7 04 24 02 73 10 80 	movl   $0x80107302,(%esp)
80103154:	e8 07 d2 ff ff       	call   80100360 <panic>
80103159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(conf->version != 1 && conf->version != 4)
80103160:	3c 01                	cmp    $0x1,%al
80103162:	0f 84 ed fe ff ff    	je     80103055 <mpinit+0x95>
80103168:	eb e3                	jmp    8010314d <mpinit+0x18d>
    panic("Didn't find a suitable machine");
8010316a:	c7 04 24 1c 73 10 80 	movl   $0x8010731c,(%esp)
80103171:	e8 ea d1 ff ff       	call   80100360 <panic>
80103176:	66 90                	xchg   %ax,%ax
80103178:	66 90                	xchg   %ax,%ax
8010317a:	66 90                	xchg   %ax,%ax
8010317c:	66 90                	xchg   %ax,%ax
8010317e:	66 90                	xchg   %ax,%ax

80103180 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103180:	55                   	push   %ebp
80103181:	ba 21 00 00 00       	mov    $0x21,%edx
80103186:	89 e5                	mov    %esp,%ebp
80103188:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010318d:	ee                   	out    %al,(%dx)
8010318e:	b2 a1                	mov    $0xa1,%dl
80103190:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103191:	5d                   	pop    %ebp
80103192:	c3                   	ret    
80103193:	66 90                	xchg   %ax,%ax
80103195:	66 90                	xchg   %ax,%ax
80103197:	66 90                	xchg   %ax,%ax
80103199:	66 90                	xchg   %ax,%ax
8010319b:	66 90                	xchg   %ax,%ax
8010319d:	66 90                	xchg   %ax,%ax
8010319f:	90                   	nop

801031a0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031a0:	55                   	push   %ebp
801031a1:	89 e5                	mov    %esp,%ebp
801031a3:	57                   	push   %edi
801031a4:	56                   	push   %esi
801031a5:	53                   	push   %ebx
801031a6:	83 ec 1c             	sub    $0x1c,%esp
801031a9:	8b 75 08             	mov    0x8(%ebp),%esi
801031ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031af:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
801031b5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801031bb:	e8 e0 db ff ff       	call   80100da0 <filealloc>
801031c0:	85 c0                	test   %eax,%eax
801031c2:	89 06                	mov    %eax,(%esi)
801031c4:	0f 84 a4 00 00 00    	je     8010326e <pipealloc+0xce>
801031ca:	e8 d1 db ff ff       	call   80100da0 <filealloc>
801031cf:	85 c0                	test   %eax,%eax
801031d1:	89 03                	mov    %eax,(%ebx)
801031d3:	0f 84 87 00 00 00    	je     80103260 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031d9:	e8 f2 f2 ff ff       	call   801024d0 <kalloc>
801031de:	85 c0                	test   %eax,%eax
801031e0:	89 c7                	mov    %eax,%edi
801031e2:	74 7c                	je     80103260 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031e4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031eb:	00 00 00 
  p->writeopen = 1;
801031ee:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031f5:	00 00 00 
  p->nwrite = 0;
801031f8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031ff:	00 00 00 
  p->nread = 0;
80103202:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103209:	00 00 00 
  initlock(&p->lock, "pipe");
8010320c:	89 04 24             	mov    %eax,(%esp)
8010320f:	c7 44 24 04 50 73 10 	movl   $0x80107350,0x4(%esp)
80103216:	80 
80103217:	e8 24 10 00 00       	call   80104240 <initlock>
  (*f0)->type = FD_PIPE;
8010321c:	8b 06                	mov    (%esi),%eax
8010321e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103224:	8b 06                	mov    (%esi),%eax
80103226:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010322a:	8b 06                	mov    (%esi),%eax
8010322c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103230:	8b 06                	mov    (%esi),%eax
80103232:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103235:	8b 03                	mov    (%ebx),%eax
80103237:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010323d:	8b 03                	mov    (%ebx),%eax
8010323f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103243:	8b 03                	mov    (%ebx),%eax
80103245:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103249:	8b 03                	mov    (%ebx),%eax
  return 0;
8010324b:	31 db                	xor    %ebx,%ebx
  (*f1)->pipe = p;
8010324d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103250:	83 c4 1c             	add    $0x1c,%esp
80103253:	89 d8                	mov    %ebx,%eax
80103255:	5b                   	pop    %ebx
80103256:	5e                   	pop    %esi
80103257:	5f                   	pop    %edi
80103258:	5d                   	pop    %ebp
80103259:	c3                   	ret    
8010325a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(*f0)
80103260:	8b 06                	mov    (%esi),%eax
80103262:	85 c0                	test   %eax,%eax
80103264:	74 08                	je     8010326e <pipealloc+0xce>
    fileclose(*f0);
80103266:	89 04 24             	mov    %eax,(%esp)
80103269:	e8 f2 db ff ff       	call   80100e60 <fileclose>
  if(*f1)
8010326e:	8b 03                	mov    (%ebx),%eax
  return -1;
80103270:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  if(*f1)
80103275:	85 c0                	test   %eax,%eax
80103277:	74 d7                	je     80103250 <pipealloc+0xb0>
    fileclose(*f1);
80103279:	89 04 24             	mov    %eax,(%esp)
8010327c:	e8 df db ff ff       	call   80100e60 <fileclose>
}
80103281:	83 c4 1c             	add    $0x1c,%esp
80103284:	89 d8                	mov    %ebx,%eax
80103286:	5b                   	pop    %ebx
80103287:	5e                   	pop    %esi
80103288:	5f                   	pop    %edi
80103289:	5d                   	pop    %ebp
8010328a:	c3                   	ret    
8010328b:	90                   	nop
8010328c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103290 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103290:	55                   	push   %ebp
80103291:	89 e5                	mov    %esp,%ebp
80103293:	56                   	push   %esi
80103294:	53                   	push   %ebx
80103295:	83 ec 10             	sub    $0x10,%esp
80103298:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010329b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010329e:	89 1c 24             	mov    %ebx,(%esp)
801032a1:	e8 0a 11 00 00       	call   801043b0 <acquire>
  if(writable){
801032a6:	85 f6                	test   %esi,%esi
801032a8:	74 3e                	je     801032e8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
801032aa:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
801032b0:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
801032b7:	00 00 00 
    wakeup(&p->nread);
801032ba:	89 04 24             	mov    %eax,(%esp)
801032bd:	e8 5e 0c 00 00       	call   80103f20 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032c2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032c8:	85 d2                	test   %edx,%edx
801032ca:	75 0a                	jne    801032d6 <pipeclose+0x46>
801032cc:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032d2:	85 c0                	test   %eax,%eax
801032d4:	74 32                	je     80103308 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032d9:	83 c4 10             	add    $0x10,%esp
801032dc:	5b                   	pop    %ebx
801032dd:	5e                   	pop    %esi
801032de:	5d                   	pop    %ebp
    release(&p->lock);
801032df:	e9 3c 11 00 00       	jmp    80104420 <release>
801032e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
801032e8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
801032ee:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032f5:	00 00 00 
    wakeup(&p->nwrite);
801032f8:	89 04 24             	mov    %eax,(%esp)
801032fb:	e8 20 0c 00 00       	call   80103f20 <wakeup>
80103300:	eb c0                	jmp    801032c2 <pipeclose+0x32>
80103302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&p->lock);
80103308:	89 1c 24             	mov    %ebx,(%esp)
8010330b:	e8 10 11 00 00       	call   80104420 <release>
    kfree((char*)p);
80103310:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80103313:	83 c4 10             	add    $0x10,%esp
80103316:	5b                   	pop    %ebx
80103317:	5e                   	pop    %esi
80103318:	5d                   	pop    %ebp
    kfree((char*)p);
80103319:	e9 02 f0 ff ff       	jmp    80102320 <kfree>
8010331e:	66 90                	xchg   %ax,%ax

80103320 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103320:	55                   	push   %ebp
80103321:	89 e5                	mov    %esp,%ebp
80103323:	57                   	push   %edi
80103324:	56                   	push   %esi
80103325:	53                   	push   %ebx
80103326:	83 ec 1c             	sub    $0x1c,%esp
80103329:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010332c:	89 1c 24             	mov    %ebx,(%esp)
8010332f:	e8 7c 10 00 00       	call   801043b0 <acquire>
  for(i = 0; i < n; i++){
80103334:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103337:	85 c9                	test   %ecx,%ecx
80103339:	0f 8e b2 00 00 00    	jle    801033f1 <pipewrite+0xd1>
8010333f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103342:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103348:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010334e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103354:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103357:	03 4d 10             	add    0x10(%ebp),%ecx
8010335a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010335d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103363:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103369:	39 c8                	cmp    %ecx,%eax
8010336b:	74 38                	je     801033a5 <pipewrite+0x85>
8010336d:	eb 55                	jmp    801033c4 <pipewrite+0xa4>
8010336f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103370:	e8 6b 03 00 00       	call   801036e0 <myproc>
80103375:	8b 40 24             	mov    0x24(%eax),%eax
80103378:	85 c0                	test   %eax,%eax
8010337a:	75 33                	jne    801033af <pipewrite+0x8f>
      wakeup(&p->nread);
8010337c:	89 3c 24             	mov    %edi,(%esp)
8010337f:	e8 9c 0b 00 00       	call   80103f20 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103384:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103388:	89 34 24             	mov    %esi,(%esp)
8010338b:	e8 f0 09 00 00       	call   80103d80 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103390:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103396:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010339c:	05 00 02 00 00       	add    $0x200,%eax
801033a1:	39 c2                	cmp    %eax,%edx
801033a3:	75 23                	jne    801033c8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
801033a5:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801033ab:	85 d2                	test   %edx,%edx
801033ad:	75 c1                	jne    80103370 <pipewrite+0x50>
        release(&p->lock);
801033af:	89 1c 24             	mov    %ebx,(%esp)
801033b2:	e8 69 10 00 00       	call   80104420 <release>
        return -1;
801033b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
801033bc:	83 c4 1c             	add    $0x1c,%esp
801033bf:	5b                   	pop    %ebx
801033c0:	5e                   	pop    %esi
801033c1:	5f                   	pop    %edi
801033c2:	5d                   	pop    %ebp
801033c3:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033c4:	89 c2                	mov    %eax,%edx
801033c6:	66 90                	xchg   %ax,%ax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033c8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033cb:	8d 42 01             	lea    0x1(%edx),%eax
801033ce:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033d4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033da:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033de:	0f b6 09             	movzbl (%ecx),%ecx
801033e1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
801033e5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033e8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033eb:	0f 85 6c ff ff ff    	jne    8010335d <pipewrite+0x3d>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033f1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033f7:	89 04 24             	mov    %eax,(%esp)
801033fa:	e8 21 0b 00 00       	call   80103f20 <wakeup>
  release(&p->lock);
801033ff:	89 1c 24             	mov    %ebx,(%esp)
80103402:	e8 19 10 00 00       	call   80104420 <release>
  return n;
80103407:	8b 45 10             	mov    0x10(%ebp),%eax
8010340a:	eb b0                	jmp    801033bc <pipewrite+0x9c>
8010340c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103410 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103410:	55                   	push   %ebp
80103411:	89 e5                	mov    %esp,%ebp
80103413:	57                   	push   %edi
80103414:	56                   	push   %esi
80103415:	53                   	push   %ebx
80103416:	83 ec 1c             	sub    $0x1c,%esp
80103419:	8b 75 08             	mov    0x8(%ebp),%esi
8010341c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010341f:	89 34 24             	mov    %esi,(%esp)
80103422:	e8 89 0f 00 00       	call   801043b0 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103427:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010342d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103433:	75 5b                	jne    80103490 <piperead+0x80>
80103435:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010343b:	85 db                	test   %ebx,%ebx
8010343d:	74 51                	je     80103490 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010343f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103445:	eb 25                	jmp    8010346c <piperead+0x5c>
80103447:	90                   	nop
80103448:	89 74 24 04          	mov    %esi,0x4(%esp)
8010344c:	89 1c 24             	mov    %ebx,(%esp)
8010344f:	e8 2c 09 00 00       	call   80103d80 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103454:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010345a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103460:	75 2e                	jne    80103490 <piperead+0x80>
80103462:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103468:	85 d2                	test   %edx,%edx
8010346a:	74 24                	je     80103490 <piperead+0x80>
    if(myproc()->killed){
8010346c:	e8 6f 02 00 00       	call   801036e0 <myproc>
80103471:	8b 48 24             	mov    0x24(%eax),%ecx
80103474:	85 c9                	test   %ecx,%ecx
80103476:	74 d0                	je     80103448 <piperead+0x38>
      release(&p->lock);
80103478:	89 34 24             	mov    %esi,(%esp)
8010347b:	e8 a0 0f 00 00       	call   80104420 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103480:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80103483:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103488:	5b                   	pop    %ebx
80103489:	5e                   	pop    %esi
8010348a:	5f                   	pop    %edi
8010348b:	5d                   	pop    %ebp
8010348c:	c3                   	ret    
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103490:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103493:	31 db                	xor    %ebx,%ebx
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103495:	85 d2                	test   %edx,%edx
80103497:	7f 2b                	jg     801034c4 <piperead+0xb4>
80103499:	eb 31                	jmp    801034cc <piperead+0xbc>
8010349b:	90                   	nop
8010349c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    addr[i] = p->data[p->nread++ % PIPESIZE];
801034a0:	8d 48 01             	lea    0x1(%eax),%ecx
801034a3:	25 ff 01 00 00       	and    $0x1ff,%eax
801034a8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801034ae:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
801034b3:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801034b6:	83 c3 01             	add    $0x1,%ebx
801034b9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
801034bc:	74 0e                	je     801034cc <piperead+0xbc>
    if(p->nread == p->nwrite)
801034be:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034c4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034ca:	75 d4                	jne    801034a0 <piperead+0x90>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034cc:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034d2:	89 04 24             	mov    %eax,(%esp)
801034d5:	e8 46 0a 00 00       	call   80103f20 <wakeup>
  release(&p->lock);
801034da:	89 34 24             	mov    %esi,(%esp)
801034dd:	e8 3e 0f 00 00       	call   80104420 <release>
}
801034e2:	83 c4 1c             	add    $0x1c,%esp
  return i;
801034e5:	89 d8                	mov    %ebx,%eax
}
801034e7:	5b                   	pop    %ebx
801034e8:	5e                   	pop    %esi
801034e9:	5f                   	pop    %edi
801034ea:	5d                   	pop    %ebp
801034eb:	c3                   	ret    
801034ec:	66 90                	xchg   %ax,%ax
801034ee:	66 90                	xchg   %ax,%ax

801034f0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034f0:	55                   	push   %ebp
801034f1:	89 e5                	mov    %esp,%ebp
801034f3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
{
801034f9:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
801034fc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103503:	e8 a8 0e 00 00       	call   801043b0 <acquire>
80103508:	eb 18                	jmp    80103522 <allocproc+0x32>
8010350a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103510:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103516:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
8010351c:	0f 84 86 00 00 00    	je     801035a8 <allocproc+0xb8>
    if(p->state == UNUSED)
80103522:	8b 43 0c             	mov    0xc(%ebx),%eax
80103525:	85 c0                	test   %eax,%eax
80103527:	75 e7                	jne    80103510 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103529:	a1 04 a0 10 80       	mov    0x8010a004,%eax
  p->prior_val = 0;                 //!! initialize priority value

  release(&ptable.lock);
8010352e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  p->state = EMBRYO;
80103535:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->prior_val = 0;                 //!! initialize priority value
8010353c:	c7 43 7c 00 00 00 00 	movl   $0x0,0x7c(%ebx)
  p->pid = nextpid++;
80103543:	8d 50 01             	lea    0x1(%eax),%edx
80103546:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010354c:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010354f:	e8 cc 0e 00 00       	call   80104420 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103554:	e8 77 ef ff ff       	call   801024d0 <kalloc>
80103559:	85 c0                	test   %eax,%eax
8010355b:	89 43 08             	mov    %eax,0x8(%ebx)
8010355e:	74 5c                	je     801035bc <allocproc+0xcc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103560:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103566:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
8010356b:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010356e:	c7 40 14 df 55 10 80 	movl   $0x801055df,0x14(%eax)
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103575:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
8010357c:	00 
8010357d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103584:	00 
80103585:	89 04 24             	mov    %eax,(%esp)
  p->context = (struct context*)sp;
80103588:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010358b:	e8 e0 0e 00 00       	call   80104470 <memset>
  p->context->eip = (uint)forkret;
80103590:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103593:	c7 40 10 d0 35 10 80 	movl   $0x801035d0,0x10(%eax)

  return p;
8010359a:	89 d8                	mov    %ebx,%eax
}
8010359c:	83 c4 14             	add    $0x14,%esp
8010359f:	5b                   	pop    %ebx
801035a0:	5d                   	pop    %ebp
801035a1:	c3                   	ret    
801035a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
801035a8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035af:	e8 6c 0e 00 00       	call   80104420 <release>
}
801035b4:	83 c4 14             	add    $0x14,%esp
  return 0;
801035b7:	31 c0                	xor    %eax,%eax
}
801035b9:	5b                   	pop    %ebx
801035ba:	5d                   	pop    %ebp
801035bb:	c3                   	ret    
    p->state = UNUSED;
801035bc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801035c3:	eb d7                	jmp    8010359c <allocproc+0xac>
801035c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801035c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035d0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035d0:	55                   	push   %ebp
801035d1:	89 e5                	mov    %esp,%ebp
801035d3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035d6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035dd:	e8 3e 0e 00 00       	call   80104420 <release>

  if (first) {
801035e2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035e7:	85 c0                	test   %eax,%eax
801035e9:	75 05                	jne    801035f0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035eb:	c9                   	leave  
801035ec:	c3                   	ret    
801035ed:	8d 76 00             	lea    0x0(%esi),%esi
    iinit(ROOTDEV);
801035f0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    first = 0;
801035f7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035fe:	00 00 00 
    iinit(ROOTDEV);
80103601:	e8 9a de ff ff       	call   801014a0 <iinit>
    initlog(ROOTDEV);
80103606:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010360d:	e8 8e f4 ff ff       	call   80102aa0 <initlog>
}
80103612:	c9                   	leave  
80103613:	c3                   	ret    
80103614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010361a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103620 <pinit>:
{
80103620:	55                   	push   %ebp
80103621:	89 e5                	mov    %esp,%ebp
80103623:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
80103626:	c7 44 24 04 55 73 10 	movl   $0x80107355,0x4(%esp)
8010362d:	80 
8010362e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103635:	e8 06 0c 00 00       	call   80104240 <initlock>
}
8010363a:	c9                   	leave  
8010363b:	c3                   	ret    
8010363c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103640 <mycpu>:
{
80103640:	55                   	push   %ebp
80103641:	89 e5                	mov    %esp,%ebp
80103643:	56                   	push   %esi
80103644:	53                   	push   %ebx
80103645:	83 ec 10             	sub    $0x10,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103648:	9c                   	pushf  
80103649:	58                   	pop    %eax
  if(readeflags()&FL_IF)
8010364a:	f6 c4 02             	test   $0x2,%ah
8010364d:	75 57                	jne    801036a6 <mycpu+0x66>
  apicid = lapicid();
8010364f:	e8 3c f1 ff ff       	call   80102790 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103654:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010365a:	85 f6                	test   %esi,%esi
8010365c:	7e 3c                	jle    8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010365e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103665:	39 c2                	cmp    %eax,%edx
80103667:	74 2d                	je     80103696 <mycpu+0x56>
80103669:	b9 30 28 11 80       	mov    $0x80112830,%ecx
  for (i = 0; i < ncpu; ++i) {
8010366e:	31 d2                	xor    %edx,%edx
80103670:	83 c2 01             	add    $0x1,%edx
80103673:	39 f2                	cmp    %esi,%edx
80103675:	74 23                	je     8010369a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103677:	0f b6 19             	movzbl (%ecx),%ebx
8010367a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103680:	39 c3                	cmp    %eax,%ebx
80103682:	75 ec                	jne    80103670 <mycpu+0x30>
      return &cpus[i];
80103684:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
}
8010368a:	83 c4 10             	add    $0x10,%esp
8010368d:	5b                   	pop    %ebx
8010368e:	5e                   	pop    %esi
8010368f:	5d                   	pop    %ebp
      return &cpus[i];
80103690:	05 80 27 11 80       	add    $0x80112780,%eax
}
80103695:	c3                   	ret    
  for (i = 0; i < ncpu; ++i) {
80103696:	31 d2                	xor    %edx,%edx
80103698:	eb ea                	jmp    80103684 <mycpu+0x44>
  panic("unknown apicid\n");
8010369a:	c7 04 24 5c 73 10 80 	movl   $0x8010735c,(%esp)
801036a1:	e8 ba cc ff ff       	call   80100360 <panic>
    panic("mycpu called with interrupts enabled\n");
801036a6:	c7 04 24 58 74 10 80 	movl   $0x80107458,(%esp)
801036ad:	e8 ae cc ff ff       	call   80100360 <panic>
801036b2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801036b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036c0 <cpuid>:
cpuid() {
801036c0:	55                   	push   %ebp
801036c1:	89 e5                	mov    %esp,%ebp
801036c3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801036c6:	e8 75 ff ff ff       	call   80103640 <mycpu>
}
801036cb:	c9                   	leave  
  return mycpu()-cpus;
801036cc:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036d1:	c1 f8 04             	sar    $0x4,%eax
801036d4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036da:	c3                   	ret    
801036db:	90                   	nop
801036dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036e0 <myproc>:
myproc(void) {
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801036e7:	e8 d4 0b 00 00       	call   801042c0 <pushcli>
  c = mycpu();
801036ec:	e8 4f ff ff ff       	call   80103640 <mycpu>
  p = c->proc;
801036f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036f7:	e8 04 0c 00 00       	call   80104300 <popcli>
}
801036fc:	83 c4 04             	add    $0x4,%esp
801036ff:	89 d8                	mov    %ebx,%eax
80103701:	5b                   	pop    %ebx
80103702:	5d                   	pop    %ebp
80103703:	c3                   	ret    
80103704:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010370a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103710 <userinit>:
{
80103710:	55                   	push   %ebp
80103711:	89 e5                	mov    %esp,%ebp
80103713:	53                   	push   %ebx
80103714:	83 ec 14             	sub    $0x14,%esp
  p = allocproc();
80103717:	e8 d4 fd ff ff       	call   801034f0 <allocproc>
8010371c:	89 c3                	mov    %eax,%ebx
  initproc = p;
8010371e:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
80103723:	e8 28 34 00 00       	call   80106b50 <setupkvm>
80103728:	85 c0                	test   %eax,%eax
8010372a:	89 43 04             	mov    %eax,0x4(%ebx)
8010372d:	0f 84 d4 00 00 00    	je     80103807 <userinit+0xf7>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103733:	89 04 24             	mov    %eax,(%esp)
80103736:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010373d:	00 
8010373e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103745:	80 
80103746:	e8 35 31 00 00       	call   80106880 <inituvm>
  p->sz = PGSIZE;
8010374b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103751:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103758:	00 
80103759:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103760:	00 
80103761:	8b 43 18             	mov    0x18(%ebx),%eax
80103764:	89 04 24             	mov    %eax,(%esp)
80103767:	e8 04 0d 00 00       	call   80104470 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010376c:	8b 43 18             	mov    0x18(%ebx),%eax
8010376f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103774:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103779:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010377d:	8b 43 18             	mov    0x18(%ebx),%eax
80103780:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103784:	8b 43 18             	mov    0x18(%ebx),%eax
80103787:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010378b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010378f:	8b 43 18             	mov    0x18(%ebx),%eax
80103792:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103796:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010379a:	8b 43 18             	mov    0x18(%ebx),%eax
8010379d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
801037a4:	8b 43 18             	mov    0x18(%ebx),%eax
801037a7:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
801037ae:	8b 43 18             	mov    0x18(%ebx),%eax
801037b1:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
801037b8:	8d 43 6c             	lea    0x6c(%ebx),%eax
801037bb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
801037c2:	00 
801037c3:	c7 44 24 04 85 73 10 	movl   $0x80107385,0x4(%esp)
801037ca:	80 
801037cb:	89 04 24             	mov    %eax,(%esp)
801037ce:	e8 7d 0e 00 00       	call   80104650 <safestrcpy>
  p->cwd = namei("/");
801037d3:	c7 04 24 8e 73 10 80 	movl   $0x8010738e,(%esp)
801037da:	e8 51 e7 ff ff       	call   80101f30 <namei>
801037df:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801037e2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037e9:	e8 c2 0b 00 00       	call   801043b0 <acquire>
  p->state = RUNNABLE;
801037ee:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801037f5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037fc:	e8 1f 0c 00 00       	call   80104420 <release>
}
80103801:	83 c4 14             	add    $0x14,%esp
80103804:	5b                   	pop    %ebx
80103805:	5d                   	pop    %ebp
80103806:	c3                   	ret    
    panic("userinit: out of memory?");
80103807:	c7 04 24 6c 73 10 80 	movl   $0x8010736c,(%esp)
8010380e:	e8 4d cb ff ff       	call   80100360 <panic>
80103813:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103819:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103820 <growproc>:
{
80103820:	55                   	push   %ebp
80103821:	89 e5                	mov    %esp,%ebp
80103823:	56                   	push   %esi
80103824:	53                   	push   %ebx
80103825:	83 ec 10             	sub    $0x10,%esp
80103828:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
8010382b:	e8 b0 fe ff ff       	call   801036e0 <myproc>
  if(n > 0){
80103830:	83 fe 00             	cmp    $0x0,%esi
  struct proc *curproc = myproc();
80103833:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
80103835:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103837:	7e 2f                	jle    80103868 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103839:	01 c6                	add    %eax,%esi
8010383b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010383f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103843:	8b 43 04             	mov    0x4(%ebx),%eax
80103846:	89 04 24             	mov    %eax,(%esp)
80103849:	e8 72 31 00 00       	call   801069c0 <allocuvm>
8010384e:	85 c0                	test   %eax,%eax
80103850:	74 36                	je     80103888 <growproc+0x68>
  curproc->sz = sz;
80103852:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103854:	89 1c 24             	mov    %ebx,(%esp)
80103857:	e8 14 2f 00 00       	call   80106770 <switchuvm>
  return 0;
8010385c:	31 c0                	xor    %eax,%eax
}
8010385e:	83 c4 10             	add    $0x10,%esp
80103861:	5b                   	pop    %ebx
80103862:	5e                   	pop    %esi
80103863:	5d                   	pop    %ebp
80103864:	c3                   	ret    
80103865:	8d 76 00             	lea    0x0(%esi),%esi
  } else if(n < 0){
80103868:	74 e8                	je     80103852 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010386a:	01 c6                	add    %eax,%esi
8010386c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103870:	89 44 24 04          	mov    %eax,0x4(%esp)
80103874:	8b 43 04             	mov    0x4(%ebx),%eax
80103877:	89 04 24             	mov    %eax,(%esp)
8010387a:	e8 31 32 00 00       	call   80106ab0 <deallocuvm>
8010387f:	85 c0                	test   %eax,%eax
80103881:	75 cf                	jne    80103852 <growproc+0x32>
80103883:	90                   	nop
80103884:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80103888:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010388d:	eb cf                	jmp    8010385e <growproc+0x3e>
8010388f:	90                   	nop

80103890 <fork>:
{
80103890:	55                   	push   %ebp
80103891:	89 e5                	mov    %esp,%ebp
80103893:	57                   	push   %edi
80103894:	56                   	push   %esi
80103895:	53                   	push   %ebx
80103896:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
80103899:	e8 42 fe ff ff       	call   801036e0 <myproc>
8010389e:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
801038a0:	e8 4b fc ff ff       	call   801034f0 <allocproc>
801038a5:	85 c0                	test   %eax,%eax
801038a7:	89 c7                	mov    %eax,%edi
801038a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801038ac:	0f 84 c2 00 00 00    	je     80103974 <fork+0xe4>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
801038b2:	8b 03                	mov    (%ebx),%eax
801038b4:	89 44 24 04          	mov    %eax,0x4(%esp)
801038b8:	8b 43 04             	mov    0x4(%ebx),%eax
801038bb:	89 04 24             	mov    %eax,(%esp)
801038be:	e8 6d 33 00 00       	call   80106c30 <copyuvm>
801038c3:	85 c0                	test   %eax,%eax
801038c5:	89 47 04             	mov    %eax,0x4(%edi)
801038c8:	0f 84 ad 00 00 00    	je     8010397b <fork+0xeb>
  np->sz = curproc->sz;
801038ce:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
801038d0:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
801038d5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038d8:	89 07                	mov    %eax,(%edi)
  *np->tf = *curproc->tf;
801038da:	89 f8                	mov    %edi,%eax
  np->parent = curproc;
801038dc:	89 5f 14             	mov    %ebx,0x14(%edi)
  *np->tf = *curproc->tf;
801038df:	8b 7f 18             	mov    0x18(%edi),%edi
801038e2:	8b 73 18             	mov    0x18(%ebx),%esi
801038e5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
801038e7:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
801038e9:	8b 40 18             	mov    0x18(%eax),%eax
801038ec:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038f3:	90                   	nop
801038f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[i])
801038f8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038fc:	85 c0                	test   %eax,%eax
801038fe:	74 0f                	je     8010390f <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103900:	89 04 24             	mov    %eax,(%esp)
80103903:	e8 08 d5 ff ff       	call   80100e10 <filedup>
80103908:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010390b:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
8010390f:	83 c6 01             	add    $0x1,%esi
80103912:	83 fe 10             	cmp    $0x10,%esi
80103915:	75 e1                	jne    801038f8 <fork+0x68>
  np->cwd = idup(curproc->cwd);
80103917:	8b 43 68             	mov    0x68(%ebx),%eax
8010391a:	89 04 24             	mov    %eax,(%esp)
8010391d:	e8 8e dd ff ff       	call   801016b0 <idup>
80103922:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103925:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103928:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010392b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010392f:	8d 47 6c             	lea    0x6c(%edi),%eax
80103932:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103939:	00 
8010393a:	89 04 24             	mov    %eax,(%esp)
8010393d:	e8 0e 0d 00 00       	call   80104650 <safestrcpy>
  pid = np->pid;
80103942:	8b 77 10             	mov    0x10(%edi),%esi
  acquire(&ptable.lock);
80103945:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010394c:	e8 5f 0a 00 00       	call   801043b0 <acquire>
  np->state = RUNNABLE;
80103951:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->prior_val = curproc->prior_val; //!! inherit the parent's priority value
80103958:	8b 43 7c             	mov    0x7c(%ebx),%eax
8010395b:	89 47 7c             	mov    %eax,0x7c(%edi)
  release(&ptable.lock);
8010395e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103965:	e8 b6 0a 00 00       	call   80104420 <release>
  return pid;
8010396a:	89 f0                	mov    %esi,%eax
}
8010396c:	83 c4 1c             	add    $0x1c,%esp
8010396f:	5b                   	pop    %ebx
80103970:	5e                   	pop    %esi
80103971:	5f                   	pop    %edi
80103972:	5d                   	pop    %ebp
80103973:	c3                   	ret    
    return -1;
80103974:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103979:	eb f1                	jmp    8010396c <fork+0xdc>
    kfree(np->kstack);
8010397b:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
8010397e:	8b 43 08             	mov    0x8(%ebx),%eax
80103981:	89 04 24             	mov    %eax,(%esp)
80103984:	e8 97 e9 ff ff       	call   80102320 <kfree>
    return -1;
80103989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    np->kstack = 0;
8010398e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103995:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
8010399c:	eb ce                	jmp    8010396c <fork+0xdc>
8010399e:	66 90                	xchg   %ax,%ax

801039a0 <scheduler>:
{
801039a0:	55                   	push   %ebp
801039a1:	89 e5                	mov    %esp,%ebp
801039a3:	57                   	push   %edi
801039a4:	56                   	push   %esi
801039a5:	53                   	push   %ebx
801039a6:	83 ec 1c             	sub    $0x1c,%esp
  struct cpu *c = mycpu();
801039a9:	e8 92 fc ff ff       	call   80103640 <mycpu>
801039ae:	89 c3                	mov    %eax,%ebx
  c->proc = 0;
801039b0:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801039b7:	00 00 00 
801039ba:	8d 70 04             	lea    0x4(%eax),%esi
801039bd:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
801039c0:	fb                   	sti    
    struct proc* cur = ptable.proc;
801039c1:	bf 54 2d 11 80       	mov    $0x80112d54,%edi
    acquire(&ptable.lock);
801039c6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801039cd:	e8 de 09 00 00       	call   801043b0 <acquire>
    int highest_prior_val = 31;
801039d2:	b9 1f 00 00 00       	mov    $0x1f,%ecx
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d7:	89 f8                	mov    %edi,%eax
801039d9:	eb 11                	jmp    801039ec <scheduler+0x4c>
801039db:	90                   	nop
801039dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039e0:	05 8c 00 00 00       	add    $0x8c,%eax
801039e5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
801039ea:	74 24                	je     80103a10 <scheduler+0x70>
      if (p->state == RUNNABLE) {
801039ec:	83 78 0c 03          	cmpl   $0x3,0xc(%eax)
801039f0:	75 ee                	jne    801039e0 <scheduler+0x40>
          if (p->prior_val < highest_prior_val) {
801039f2:	8b 50 7c             	mov    0x7c(%eax),%edx
801039f5:	39 ca                	cmp    %ecx,%edx
801039f7:	7d e7                	jge    801039e0 <scheduler+0x40>
801039f9:	89 c7                	mov    %eax,%edi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039fb:	05 8c 00 00 00       	add    $0x8c,%eax
80103a00:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103a05:	89 d1                	mov    %edx,%ecx
80103a07:	75 e3                	jne    801039ec <scheduler+0x4c>
80103a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      acquire(&tickslock);
80103a10:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80103a17:	e8 94 09 00 00       	call   801043b0 <acquire>
      int current_ticks = ticks;
80103a1c:	a1 a0 58 11 80       	mov    0x801158a0,%eax
      if (current_ticks > cur->last_burst_time_ticks) {
80103a21:	3b 87 88 00 00 00    	cmp    0x88(%edi),%eax
80103a27:	7e 0d                	jle    80103a36 <scheduler+0x96>
          cur->burst_time += 1;
80103a29:	83 87 84 00 00 00 01 	addl   $0x1,0x84(%edi)
          cur->last_burst_time_ticks = current_ticks;
80103a30:	89 87 88 00 00 00    	mov    %eax,0x88(%edi)
      release(&tickslock);
80103a36:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80103a3d:	e8 de 09 00 00       	call   80104420 <release>
      c->proc = cur;
80103a42:	89 bb ac 00 00 00    	mov    %edi,0xac(%ebx)
      switchuvm(cur);
80103a48:	89 3c 24             	mov    %edi,(%esp)
80103a4b:	e8 20 2d 00 00       	call   80106770 <switchuvm>
      swtch(&(c->scheduler), cur->context);
80103a50:	8b 47 1c             	mov    0x1c(%edi),%eax
      cur->state = RUNNING;
80103a53:	c7 47 0c 04 00 00 00 	movl   $0x4,0xc(%edi)
      swtch(&(c->scheduler), cur->context);
80103a5a:	89 34 24             	mov    %esi,(%esp)
80103a5d:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a61:	e8 45 0c 00 00       	call   801046ab <swtch>
      switchkvm();
80103a66:	e8 e5 2c 00 00       	call   80106750 <switchkvm>
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a6b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
      c->proc = 0;
80103a70:	c7 83 ac 00 00 00 00 	movl   $0x0,0xac(%ebx)
80103a77:	00 00 00 
80103a7a:	eb 27                	jmp    80103aa3 <scheduler+0x103>
80103a7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
              int x = (p->prior_val - 1);
80103a80:	8b 42 7c             	mov    0x7c(%edx),%eax
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a83:	81 c2 8c 00 00 00    	add    $0x8c,%edx
              int x = (p->prior_val - 1);
80103a89:	83 e8 01             	sub    $0x1,%eax
              x = (x > 0) ? x : -x; //ensure x is positive
80103a8c:	89 c1                	mov    %eax,%ecx
80103a8e:	c1 f9 1f             	sar    $0x1f,%ecx
80103a91:	31 c8                	xor    %ecx,%eax
80103a93:	29 c8                	sub    %ecx,%eax
              p->prior_val = x % 32;
80103a95:	83 e0 1f             	and    $0x1f,%eax
80103a98:	89 42 f0             	mov    %eax,-0x10(%edx)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a9b:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103aa1:	74 2d                	je     80103ad0 <scheduler+0x130>
          if (p != cur) {
80103aa3:	39 d7                	cmp    %edx,%edi
80103aa5:	75 d9                	jne    80103a80 <scheduler+0xe0>
              p->prior_val = (p->prior_val + 1) % 32;
80103aa7:	8b 47 7c             	mov    0x7c(%edi),%eax
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aaa:	81 c2 8c 00 00 00    	add    $0x8c,%edx
              p->prior_val = (p->prior_val + 1) % 32;
80103ab0:	83 c0 01             	add    $0x1,%eax
80103ab3:	89 c1                	mov    %eax,%ecx
80103ab5:	c1 f9 1f             	sar    $0x1f,%ecx
80103ab8:	c1 e9 1b             	shr    $0x1b,%ecx
80103abb:	01 c8                	add    %ecx,%eax
80103abd:	83 e0 1f             	and    $0x1f,%eax
80103ac0:	29 c8                	sub    %ecx,%eax
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ac2:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
              p->prior_val = (p->prior_val + 1) % 32;
80103ac8:	89 47 7c             	mov    %eax,0x7c(%edi)
      for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103acb:	75 d6                	jne    80103aa3 <scheduler+0x103>
80103acd:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ptable.lock);
80103ad0:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ad7:	e8 44 09 00 00       	call   80104420 <release>
  }
80103adc:	e9 df fe ff ff       	jmp    801039c0 <scheduler+0x20>
80103ae1:	eb 0d                	jmp    80103af0 <sched>
80103ae3:	90                   	nop
80103ae4:	90                   	nop
80103ae5:	90                   	nop
80103ae6:	90                   	nop
80103ae7:	90                   	nop
80103ae8:	90                   	nop
80103ae9:	90                   	nop
80103aea:	90                   	nop
80103aeb:	90                   	nop
80103aec:	90                   	nop
80103aed:	90                   	nop
80103aee:	90                   	nop
80103aef:	90                   	nop

80103af0 <sched>:
{
80103af0:	55                   	push   %ebp
80103af1:	89 e5                	mov    %esp,%ebp
80103af3:	56                   	push   %esi
80103af4:	53                   	push   %ebx
80103af5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p = myproc();
80103af8:	e8 e3 fb ff ff       	call   801036e0 <myproc>
  if(!holding(&ptable.lock))
80103afd:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *p = myproc();
80103b04:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
80103b06:	e8 65 08 00 00       	call   80104370 <holding>
80103b0b:	85 c0                	test   %eax,%eax
80103b0d:	74 4f                	je     80103b5e <sched+0x6e>
  if(mycpu()->ncli != 1)
80103b0f:	e8 2c fb ff ff       	call   80103640 <mycpu>
80103b14:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b1b:	75 65                	jne    80103b82 <sched+0x92>
  if(p->state == RUNNING)
80103b1d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103b21:	74 53                	je     80103b76 <sched+0x86>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b23:	9c                   	pushf  
80103b24:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103b25:	f6 c4 02             	test   $0x2,%ah
80103b28:	75 40                	jne    80103b6a <sched+0x7a>
  intena = mycpu()->intena;
80103b2a:	e8 11 fb ff ff       	call   80103640 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b2f:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103b32:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b38:	e8 03 fb ff ff       	call   80103640 <mycpu>
80103b3d:	8b 40 04             	mov    0x4(%eax),%eax
80103b40:	89 1c 24             	mov    %ebx,(%esp)
80103b43:	89 44 24 04          	mov    %eax,0x4(%esp)
80103b47:	e8 5f 0b 00 00       	call   801046ab <swtch>
  mycpu()->intena = intena;
80103b4c:	e8 ef fa ff ff       	call   80103640 <mycpu>
80103b51:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b57:	83 c4 10             	add    $0x10,%esp
80103b5a:	5b                   	pop    %ebx
80103b5b:	5e                   	pop    %esi
80103b5c:	5d                   	pop    %ebp
80103b5d:	c3                   	ret    
    panic("sched ptable.lock");
80103b5e:	c7 04 24 90 73 10 80 	movl   $0x80107390,(%esp)
80103b65:	e8 f6 c7 ff ff       	call   80100360 <panic>
    panic("sched interruptible");
80103b6a:	c7 04 24 bc 73 10 80 	movl   $0x801073bc,(%esp)
80103b71:	e8 ea c7 ff ff       	call   80100360 <panic>
    panic("sched running");
80103b76:	c7 04 24 ae 73 10 80 	movl   $0x801073ae,(%esp)
80103b7d:	e8 de c7 ff ff       	call   80100360 <panic>
    panic("sched locks");
80103b82:	c7 04 24 a2 73 10 80 	movl   $0x801073a2,(%esp)
80103b89:	e8 d2 c7 ff ff       	call   80100360 <panic>
80103b8e:	66 90                	xchg   %ax,%ax

80103b90 <exit>:
{
80103b90:	55                   	push   %ebp
80103b91:	89 e5                	mov    %esp,%ebp
80103b93:	56                   	push   %esi
80103b94:	53                   	push   %ebx
80103b95:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103b98:	e8 43 fb ff ff       	call   801036e0 <myproc>
    acquire(&tickslock);
80103b9d:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
  struct proc *curproc = myproc();
80103ba4:	89 c3                	mov    %eax,%ebx
    acquire(&tickslock);
80103ba6:	e8 05 08 00 00       	call   801043b0 <acquire>
    turnaround_time = ticks - curproc->start_time;
80103bab:	8b 35 a0 58 11 80    	mov    0x801158a0,%esi
80103bb1:	2b b3 80 00 00 00    	sub    0x80(%ebx),%esi
    release(&tickslock);
80103bb7:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80103bbe:	e8 5d 08 00 00       	call   80104420 <release>
    cprintf("\n");
80103bc3:	c7 04 24 db 77 10 80 	movl   $0x801077db,(%esp)
80103bca:	e8 81 ca ff ff       	call   80100650 <cprintf>
    cprintf("pid: %d\n", curproc->pid);
80103bcf:	8b 43 10             	mov    0x10(%ebx),%eax
80103bd2:	c7 04 24 d0 73 10 80 	movl   $0x801073d0,(%esp)
80103bd9:	89 44 24 04          	mov    %eax,0x4(%esp)
80103bdd:	e8 6e ca ff ff       	call   80100650 <cprintf>
    cprintf("Turnaround time: %d\n", turnaround_time);
80103be2:	89 74 24 04          	mov    %esi,0x4(%esp)
80103be6:	c7 04 24 d9 73 10 80 	movl   $0x801073d9,(%esp)
80103bed:	e8 5e ca ff ff       	call   80100650 <cprintf>
    cprintf("Waiting time = turnaround - burst = %d - %d = %d\n", turnaround_time, curproc->burst_time,turnaround_time - curproc->burst_time);
80103bf2:	8b 83 84 00 00 00    	mov    0x84(%ebx),%eax
80103bf8:	89 f2                	mov    %esi,%edx
80103bfa:	89 74 24 04          	mov    %esi,0x4(%esp)
  if(curproc == initproc)
80103bfe:	31 f6                	xor    %esi,%esi
    cprintf("Waiting time = turnaround - burst = %d - %d = %d\n", turnaround_time, curproc->burst_time,turnaround_time - curproc->burst_time);
80103c00:	c7 04 24 80 74 10 80 	movl   $0x80107480,(%esp)
80103c07:	29 c2                	sub    %eax,%edx
80103c09:	89 54 24 0c          	mov    %edx,0xc(%esp)
80103c0d:	89 44 24 08          	mov    %eax,0x8(%esp)
80103c11:	e8 3a ca ff ff       	call   80100650 <cprintf>
    cprintf("\n");
80103c16:	c7 04 24 db 77 10 80 	movl   $0x801077db,(%esp)
80103c1d:	e8 2e ca ff ff       	call   80100650 <cprintf>
  if(curproc == initproc)
80103c22:	3b 1d b8 a5 10 80    	cmp    0x8010a5b8,%ebx
80103c28:	0f 84 fc 00 00 00    	je     80103d2a <exit+0x19a>
80103c2e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd]){
80103c30:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103c34:	85 c0                	test   %eax,%eax
80103c36:	74 10                	je     80103c48 <exit+0xb8>
      fileclose(curproc->ofile[fd]);
80103c38:	89 04 24             	mov    %eax,(%esp)
80103c3b:	e8 20 d2 ff ff       	call   80100e60 <fileclose>
      curproc->ofile[fd] = 0;
80103c40:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103c47:	00 
  for(fd = 0; fd < NOFILE; fd++){
80103c48:	83 c6 01             	add    $0x1,%esi
80103c4b:	83 fe 10             	cmp    $0x10,%esi
80103c4e:	75 e0                	jne    80103c30 <exit+0xa0>
  begin_op();
80103c50:	e8 eb ee ff ff       	call   80102b40 <begin_op>
  iput(curproc->cwd);
80103c55:	8b 43 68             	mov    0x68(%ebx),%eax
80103c58:	89 04 24             	mov    %eax,(%esp)
80103c5b:	e8 a0 db ff ff       	call   80101800 <iput>
  end_op();
80103c60:	e8 4b ef ff ff       	call   80102bb0 <end_op>
  curproc->cwd = 0;
80103c65:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
80103c6c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c73:	e8 38 07 00 00       	call   801043b0 <acquire>
  wakeup1(curproc->parent);
80103c78:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c7b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103c80:	eb 14                	jmp    80103c96 <exit+0x106>
80103c82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103c88:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103c8e:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103c94:	74 20                	je     80103cb6 <exit+0x126>
    if(p->state == SLEEPING && p->chan == chan)
80103c96:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103c9a:	75 ec                	jne    80103c88 <exit+0xf8>
80103c9c:	3b 42 20             	cmp    0x20(%edx),%eax
80103c9f:	75 e7                	jne    80103c88 <exit+0xf8>
      p->state = RUNNABLE;
80103ca1:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ca8:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103cae:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103cb4:	75 e0                	jne    80103c96 <exit+0x106>
      p->parent = initproc;
80103cb6:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103cbb:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103cc0:	eb 14                	jmp    80103cd6 <exit+0x146>
80103cc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cc8:	81 c1 8c 00 00 00    	add    $0x8c,%ecx
80103cce:	81 f9 54 50 11 80    	cmp    $0x80115054,%ecx
80103cd4:	74 3c                	je     80103d12 <exit+0x182>
    if(p->parent == curproc){
80103cd6:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103cd9:	75 ed                	jne    80103cc8 <exit+0x138>
      if(p->state == ZOMBIE)
80103cdb:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
      p->parent = initproc;
80103cdf:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103ce2:	75 e4                	jne    80103cc8 <exit+0x138>
80103ce4:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103ce9:	eb 13                	jmp    80103cfe <exit+0x16e>
80103ceb:	90                   	nop
80103cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cf0:	81 c2 8c 00 00 00    	add    $0x8c,%edx
80103cf6:	81 fa 54 50 11 80    	cmp    $0x80115054,%edx
80103cfc:	74 ca                	je     80103cc8 <exit+0x138>
    if(p->state == SLEEPING && p->chan == chan)
80103cfe:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103d02:	75 ec                	jne    80103cf0 <exit+0x160>
80103d04:	3b 42 20             	cmp    0x20(%edx),%eax
80103d07:	75 e7                	jne    80103cf0 <exit+0x160>
      p->state = RUNNABLE;
80103d09:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103d10:	eb de                	jmp    80103cf0 <exit+0x160>
  curproc->state = ZOMBIE;
80103d12:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103d19:	e8 d2 fd ff ff       	call   80103af0 <sched>
  panic("zombie exit");
80103d1e:	c7 04 24 fb 73 10 80 	movl   $0x801073fb,(%esp)
80103d25:	e8 36 c6 ff ff       	call   80100360 <panic>
    panic("init exiting");
80103d2a:	c7 04 24 ee 73 10 80 	movl   $0x801073ee,(%esp)
80103d31:	e8 2a c6 ff ff       	call   80100360 <panic>
80103d36:	8d 76 00             	lea    0x0(%esi),%esi
80103d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d40 <yield>:
{
80103d40:	55                   	push   %ebp
80103d41:	89 e5                	mov    %esp,%ebp
80103d43:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d46:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d4d:	e8 5e 06 00 00       	call   801043b0 <acquire>
  myproc()->state = RUNNABLE;
80103d52:	e8 89 f9 ff ff       	call   801036e0 <myproc>
80103d57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103d5e:	e8 8d fd ff ff       	call   80103af0 <sched>
  release(&ptable.lock);
80103d63:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103d6a:	e8 b1 06 00 00       	call   80104420 <release>
}
80103d6f:	c9                   	leave  
80103d70:	c3                   	ret    
80103d71:	eb 0d                	jmp    80103d80 <sleep>
80103d73:	90                   	nop
80103d74:	90                   	nop
80103d75:	90                   	nop
80103d76:	90                   	nop
80103d77:	90                   	nop
80103d78:	90                   	nop
80103d79:	90                   	nop
80103d7a:	90                   	nop
80103d7b:	90                   	nop
80103d7c:	90                   	nop
80103d7d:	90                   	nop
80103d7e:	90                   	nop
80103d7f:	90                   	nop

80103d80 <sleep>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	57                   	push   %edi
80103d84:	56                   	push   %esi
80103d85:	53                   	push   %ebx
80103d86:	83 ec 1c             	sub    $0x1c,%esp
80103d89:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d8c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103d8f:	e8 4c f9 ff ff       	call   801036e0 <myproc>
  if(p == 0)
80103d94:	85 c0                	test   %eax,%eax
  struct proc *p = myproc();
80103d96:	89 c3                	mov    %eax,%ebx
  if(p == 0)
80103d98:	0f 84 7c 00 00 00    	je     80103e1a <sleep+0x9a>
  if(lk == 0)
80103d9e:	85 f6                	test   %esi,%esi
80103da0:	74 6c                	je     80103e0e <sleep+0x8e>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103da2:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103da8:	74 46                	je     80103df0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103daa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103db1:	e8 fa 05 00 00       	call   801043b0 <acquire>
    release(lk);
80103db6:	89 34 24             	mov    %esi,(%esp)
80103db9:	e8 62 06 00 00       	call   80104420 <release>
  p->chan = chan;
80103dbe:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103dc1:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80103dc8:	e8 23 fd ff ff       	call   80103af0 <sched>
  p->chan = 0;
80103dcd:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80103dd4:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103ddb:	e8 40 06 00 00       	call   80104420 <release>
    acquire(lk);
80103de0:	89 75 08             	mov    %esi,0x8(%ebp)
}
80103de3:	83 c4 1c             	add    $0x1c,%esp
80103de6:	5b                   	pop    %ebx
80103de7:	5e                   	pop    %esi
80103de8:	5f                   	pop    %edi
80103de9:	5d                   	pop    %ebp
    acquire(lk);
80103dea:	e9 c1 05 00 00       	jmp    801043b0 <acquire>
80103def:	90                   	nop
  p->chan = chan;
80103df0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103df3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)
  sched();
80103dfa:	e8 f1 fc ff ff       	call   80103af0 <sched>
  p->chan = 0;
80103dff:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
80103e06:	83 c4 1c             	add    $0x1c,%esp
80103e09:	5b                   	pop    %ebx
80103e0a:	5e                   	pop    %esi
80103e0b:	5f                   	pop    %edi
80103e0c:	5d                   	pop    %ebp
80103e0d:	c3                   	ret    
    panic("sleep without lk");
80103e0e:	c7 04 24 0d 74 10 80 	movl   $0x8010740d,(%esp)
80103e15:	e8 46 c5 ff ff       	call   80100360 <panic>
    panic("sleep");
80103e1a:	c7 04 24 07 74 10 80 	movl   $0x80107407,(%esp)
80103e21:	e8 3a c5 ff ff       	call   80100360 <panic>
80103e26:	8d 76 00             	lea    0x0(%esi),%esi
80103e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e30 <wait>:
{
80103e30:	55                   	push   %ebp
80103e31:	89 e5                	mov    %esp,%ebp
80103e33:	56                   	push   %esi
80103e34:	53                   	push   %ebx
80103e35:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103e38:	e8 a3 f8 ff ff       	call   801036e0 <myproc>
  acquire(&ptable.lock);
80103e3d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
  struct proc *curproc = myproc();
80103e44:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103e46:	e8 65 05 00 00       	call   801043b0 <acquire>
    havekids = 0;
80103e4b:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e4d:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103e52:	eb 12                	jmp    80103e66 <wait+0x36>
80103e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e58:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
80103e5e:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103e64:	74 22                	je     80103e88 <wait+0x58>
      if(p->parent != curproc)
80103e66:	39 73 14             	cmp    %esi,0x14(%ebx)
80103e69:	75 ed                	jne    80103e58 <wait+0x28>
      if(p->state == ZOMBIE){
80103e6b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103e6f:	74 34                	je     80103ea5 <wait+0x75>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e71:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
      havekids = 1;
80103e77:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e7c:	81 fb 54 50 11 80    	cmp    $0x80115054,%ebx
80103e82:	75 e2                	jne    80103e66 <wait+0x36>
80103e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(!havekids || curproc->killed){
80103e88:	85 c0                	test   %eax,%eax
80103e8a:	74 6e                	je     80103efa <wait+0xca>
80103e8c:	8b 46 24             	mov    0x24(%esi),%eax
80103e8f:	85 c0                	test   %eax,%eax
80103e91:	75 67                	jne    80103efa <wait+0xca>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e93:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103e9a:	80 
80103e9b:	89 34 24             	mov    %esi,(%esp)
80103e9e:	e8 dd fe ff ff       	call   80103d80 <sleep>
  }
80103ea3:	eb a6                	jmp    80103e4b <wait+0x1b>
        kfree(p->kstack);
80103ea5:	8b 43 08             	mov    0x8(%ebx),%eax
        pid = p->pid;
80103ea8:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103eab:	89 04 24             	mov    %eax,(%esp)
80103eae:	e8 6d e4 ff ff       	call   80102320 <kfree>
        freevm(p->pgdir);
80103eb3:	8b 43 04             	mov    0x4(%ebx),%eax
        p->kstack = 0;
80103eb6:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103ebd:	89 04 24             	mov    %eax,(%esp)
80103ec0:	e8 0b 2c 00 00       	call   80106ad0 <freevm>
        release(&ptable.lock);
80103ec5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        p->pid = 0;
80103ecc:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103ed3:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103eda:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103ede:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103ee5:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103eec:	e8 2f 05 00 00       	call   80104420 <release>
}
80103ef1:	83 c4 10             	add    $0x10,%esp
        return pid;
80103ef4:	89 f0                	mov    %esi,%eax
}
80103ef6:	5b                   	pop    %ebx
80103ef7:	5e                   	pop    %esi
80103ef8:	5d                   	pop    %ebp
80103ef9:	c3                   	ret    
      release(&ptable.lock);
80103efa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f01:	e8 1a 05 00 00       	call   80104420 <release>
}
80103f06:	83 c4 10             	add    $0x10,%esp
      return -1;
80103f09:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103f0e:	5b                   	pop    %ebx
80103f0f:	5e                   	pop    %esi
80103f10:	5d                   	pop    %ebp
80103f11:	c3                   	ret    
80103f12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103f20 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f20:	55                   	push   %ebp
80103f21:	89 e5                	mov    %esp,%ebp
80103f23:	53                   	push   %ebx
80103f24:	83 ec 14             	sub    $0x14,%esp
80103f27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f2a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103f31:	e8 7a 04 00 00       	call   801043b0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f36:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103f3b:	eb 0f                	jmp    80103f4c <wakeup+0x2c>
80103f3d:	8d 76 00             	lea    0x0(%esi),%esi
80103f40:	05 8c 00 00 00       	add    $0x8c,%eax
80103f45:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103f4a:	74 24                	je     80103f70 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103f4c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103f50:	75 ee                	jne    80103f40 <wakeup+0x20>
80103f52:	3b 58 20             	cmp    0x20(%eax),%ebx
80103f55:	75 e9                	jne    80103f40 <wakeup+0x20>
      p->state = RUNNABLE;
80103f57:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f5e:	05 8c 00 00 00       	add    $0x8c,%eax
80103f63:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103f68:	75 e2                	jne    80103f4c <wakeup+0x2c>
80103f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  wakeup1(chan);
  release(&ptable.lock);
80103f70:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103f77:	83 c4 14             	add    $0x14,%esp
80103f7a:	5b                   	pop    %ebx
80103f7b:	5d                   	pop    %ebp
  release(&ptable.lock);
80103f7c:	e9 9f 04 00 00       	jmp    80104420 <release>
80103f81:	eb 0d                	jmp    80103f90 <kill>
80103f83:	90                   	nop
80103f84:	90                   	nop
80103f85:	90                   	nop
80103f86:	90                   	nop
80103f87:	90                   	nop
80103f88:	90                   	nop
80103f89:	90                   	nop
80103f8a:	90                   	nop
80103f8b:	90                   	nop
80103f8c:	90                   	nop
80103f8d:	90                   	nop
80103f8e:	90                   	nop
80103f8f:	90                   	nop

80103f90 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 14             	sub    $0x14,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f9a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fa1:	e8 0a 04 00 00       	call   801043b0 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fa6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103fab:	eb 0f                	jmp    80103fbc <kill+0x2c>
80103fad:	8d 76 00             	lea    0x0(%esi),%esi
80103fb0:	05 8c 00 00 00       	add    $0x8c,%eax
80103fb5:	3d 54 50 11 80       	cmp    $0x80115054,%eax
80103fba:	74 3c                	je     80103ff8 <kill+0x68>
    if(p->pid == pid){
80103fbc:	39 58 10             	cmp    %ebx,0x10(%eax)
80103fbf:	75 ef                	jne    80103fb0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fc1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80103fc5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
80103fcc:	74 1a                	je     80103fe8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103fce:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fd5:	e8 46 04 00 00       	call   80104420 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fda:	83 c4 14             	add    $0x14,%esp
      return 0;
80103fdd:	31 c0                	xor    %eax,%eax
}
80103fdf:	5b                   	pop    %ebx
80103fe0:	5d                   	pop    %ebp
80103fe1:	c3                   	ret    
80103fe2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        p->state = RUNNABLE;
80103fe8:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103fef:	eb dd                	jmp    80103fce <kill+0x3e>
80103ff1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80103ff8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103fff:	e8 1c 04 00 00       	call   80104420 <release>
}
80104004:	83 c4 14             	add    $0x14,%esp
  return -1;
80104007:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010400c:	5b                   	pop    %ebx
8010400d:	5d                   	pop    %ebp
8010400e:	c3                   	ret    
8010400f:	90                   	nop

80104010 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104010:	55                   	push   %ebp
80104011:	89 e5                	mov    %esp,%ebp
80104013:	57                   	push   %edi
80104014:	56                   	push   %esi
80104015:	53                   	push   %ebx
80104016:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
8010401b:	83 ec 4c             	sub    $0x4c,%esp
8010401e:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104021:	eb 23                	jmp    80104046 <procdump+0x36>
80104023:	90                   	nop
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104028:	c7 04 24 db 77 10 80 	movl   $0x801077db,(%esp)
8010402f:	e8 1c c6 ff ff       	call   80100650 <cprintf>
80104034:	81 c3 8c 00 00 00    	add    $0x8c,%ebx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010403a:	81 fb c0 50 11 80    	cmp    $0x801150c0,%ebx
80104040:	0f 84 8a 00 00 00    	je     801040d0 <procdump+0xc0>
    if(p->state == UNUSED)
80104046:	8b 43 a0             	mov    -0x60(%ebx),%eax
80104049:	85 c0                	test   %eax,%eax
8010404b:	74 e7                	je     80104034 <procdump+0x24>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010404d:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104050:	ba 1e 74 10 80       	mov    $0x8010741e,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104055:	77 11                	ja     80104068 <procdump+0x58>
80104057:	8b 14 85 b4 74 10 80 	mov    -0x7fef8b4c(,%eax,4),%edx
      state = "???";
8010405e:	b8 1e 74 10 80       	mov    $0x8010741e,%eax
80104063:	85 d2                	test   %edx,%edx
80104065:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80104068:	8b 43 a4             	mov    -0x5c(%ebx),%eax
8010406b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
8010406f:	89 54 24 08          	mov    %edx,0x8(%esp)
80104073:	c7 04 24 22 74 10 80 	movl   $0x80107422,(%esp)
8010407a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010407e:	e8 cd c5 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80104083:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104087:	75 9f                	jne    80104028 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104089:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010408c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104090:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104093:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104096:	8b 40 0c             	mov    0xc(%eax),%eax
80104099:	83 c0 08             	add    $0x8,%eax
8010409c:	89 04 24             	mov    %eax,(%esp)
8010409f:	e8 bc 01 00 00       	call   80104260 <getcallerpcs>
801040a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
801040a8:	8b 17                	mov    (%edi),%edx
801040aa:	85 d2                	test   %edx,%edx
801040ac:	0f 84 76 ff ff ff    	je     80104028 <procdump+0x18>
        cprintf(" %p", pc[i]);
801040b2:	89 54 24 04          	mov    %edx,0x4(%esp)
801040b6:	83 c7 04             	add    $0x4,%edi
801040b9:	c7 04 24 41 6e 10 80 	movl   $0x80106e41,(%esp)
801040c0:	e8 8b c5 ff ff       	call   80100650 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801040c5:	39 f7                	cmp    %esi,%edi
801040c7:	75 df                	jne    801040a8 <procdump+0x98>
801040c9:	e9 5a ff ff ff       	jmp    80104028 <procdump+0x18>
801040ce:	66 90                	xchg   %ax,%ax
  }
}
801040d0:	83 c4 4c             	add    $0x4c,%esp
801040d3:	5b                   	pop    %ebx
801040d4:	5e                   	pop    %esi
801040d5:	5f                   	pop    %edi
801040d6:	5d                   	pop    %ebp
801040d7:	c3                   	ret    
801040d8:	90                   	nop
801040d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801040e0 <set_prior>:

//!!
int
set_prior(int prior_val) {
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
801040e3:	53                   	push   %ebx
801040e4:	83 ec 04             	sub    $0x4,%esp
801040e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
801040ea:	e8 f1 f5 ff ff       	call   801036e0 <myproc>

    if (prior_val >= 0 && prior_val <= 31) {
801040ef:	83 fb 1f             	cmp    $0x1f,%ebx
801040f2:	77 08                	ja     801040fc <set_prior+0x1c>
        curproc->prior_val = prior_val;
801040f4:	89 58 7c             	mov    %ebx,0x7c(%eax)
        yield();
801040f7:	e8 44 fc ff ff       	call   80103d40 <yield>
    }

    return -1;
801040fc:	83 c4 04             	add    $0x4,%esp
801040ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104104:	5b                   	pop    %ebx
80104105:	5d                   	pop    %ebp
80104106:	c3                   	ret    
80104107:	66 90                	xchg   %ax,%ax
80104109:	66 90                	xchg   %ax,%ax
8010410b:	66 90                	xchg   %ax,%ax
8010410d:	66 90                	xchg   %ax,%ax
8010410f:	90                   	nop

80104110 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104110:	55                   	push   %ebp
80104111:	89 e5                	mov    %esp,%ebp
80104113:	53                   	push   %ebx
80104114:	83 ec 14             	sub    $0x14,%esp
80104117:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010411a:	c7 44 24 04 cc 74 10 	movl   $0x801074cc,0x4(%esp)
80104121:	80 
80104122:	8d 43 04             	lea    0x4(%ebx),%eax
80104125:	89 04 24             	mov    %eax,(%esp)
80104128:	e8 13 01 00 00       	call   80104240 <initlock>
  lk->name = name;
8010412d:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80104130:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80104136:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010413d:	89 43 38             	mov    %eax,0x38(%ebx)
}
80104140:	83 c4 14             	add    $0x14,%esp
80104143:	5b                   	pop    %ebx
80104144:	5d                   	pop    %ebp
80104145:	c3                   	ret    
80104146:	8d 76 00             	lea    0x0(%esi),%esi
80104149:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104150 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104150:	55                   	push   %ebp
80104151:	89 e5                	mov    %esp,%ebp
80104153:	56                   	push   %esi
80104154:	53                   	push   %ebx
80104155:	83 ec 10             	sub    $0x10,%esp
80104158:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010415b:	8d 73 04             	lea    0x4(%ebx),%esi
8010415e:	89 34 24             	mov    %esi,(%esp)
80104161:	e8 4a 02 00 00       	call   801043b0 <acquire>
  while (lk->locked) {
80104166:	8b 13                	mov    (%ebx),%edx
80104168:	85 d2                	test   %edx,%edx
8010416a:	74 16                	je     80104182 <acquiresleep+0x32>
8010416c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80104170:	89 74 24 04          	mov    %esi,0x4(%esp)
80104174:	89 1c 24             	mov    %ebx,(%esp)
80104177:	e8 04 fc ff ff       	call   80103d80 <sleep>
  while (lk->locked) {
8010417c:	8b 03                	mov    (%ebx),%eax
8010417e:	85 c0                	test   %eax,%eax
80104180:	75 ee                	jne    80104170 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104182:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104188:	e8 53 f5 ff ff       	call   801036e0 <myproc>
8010418d:	8b 40 10             	mov    0x10(%eax),%eax
80104190:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104193:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104196:	83 c4 10             	add    $0x10,%esp
80104199:	5b                   	pop    %ebx
8010419a:	5e                   	pop    %esi
8010419b:	5d                   	pop    %ebp
  release(&lk->lk);
8010419c:	e9 7f 02 00 00       	jmp    80104420 <release>
801041a1:	eb 0d                	jmp    801041b0 <releasesleep>
801041a3:	90                   	nop
801041a4:	90                   	nop
801041a5:	90                   	nop
801041a6:	90                   	nop
801041a7:	90                   	nop
801041a8:	90                   	nop
801041a9:	90                   	nop
801041aa:	90                   	nop
801041ab:	90                   	nop
801041ac:	90                   	nop
801041ad:	90                   	nop
801041ae:	90                   	nop
801041af:	90                   	nop

801041b0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801041b0:	55                   	push   %ebp
801041b1:	89 e5                	mov    %esp,%ebp
801041b3:	56                   	push   %esi
801041b4:	53                   	push   %ebx
801041b5:	83 ec 10             	sub    $0x10,%esp
801041b8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041bb:	8d 73 04             	lea    0x4(%ebx),%esi
801041be:	89 34 24             	mov    %esi,(%esp)
801041c1:	e8 ea 01 00 00       	call   801043b0 <acquire>
  lk->locked = 0;
801041c6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801041cc:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801041d3:	89 1c 24             	mov    %ebx,(%esp)
801041d6:	e8 45 fd ff ff       	call   80103f20 <wakeup>
  release(&lk->lk);
801041db:	89 75 08             	mov    %esi,0x8(%ebp)
}
801041de:	83 c4 10             	add    $0x10,%esp
801041e1:	5b                   	pop    %ebx
801041e2:	5e                   	pop    %esi
801041e3:	5d                   	pop    %ebp
  release(&lk->lk);
801041e4:	e9 37 02 00 00       	jmp    80104420 <release>
801041e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801041f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
801041f4:	31 ff                	xor    %edi,%edi
{
801041f6:	56                   	push   %esi
801041f7:	53                   	push   %ebx
801041f8:	83 ec 1c             	sub    $0x1c,%esp
801041fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801041fe:	8d 73 04             	lea    0x4(%ebx),%esi
80104201:	89 34 24             	mov    %esi,(%esp)
80104204:	e8 a7 01 00 00       	call   801043b0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104209:	8b 03                	mov    (%ebx),%eax
8010420b:	85 c0                	test   %eax,%eax
8010420d:	74 13                	je     80104222 <holdingsleep+0x32>
8010420f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104212:	e8 c9 f4 ff ff       	call   801036e0 <myproc>
80104217:	3b 58 10             	cmp    0x10(%eax),%ebx
8010421a:	0f 94 c0             	sete   %al
8010421d:	0f b6 c0             	movzbl %al,%eax
80104220:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104222:	89 34 24             	mov    %esi,(%esp)
80104225:	e8 f6 01 00 00       	call   80104420 <release>
  return r;
}
8010422a:	83 c4 1c             	add    $0x1c,%esp
8010422d:	89 f8                	mov    %edi,%eax
8010422f:	5b                   	pop    %ebx
80104230:	5e                   	pop    %esi
80104231:	5f                   	pop    %edi
80104232:	5d                   	pop    %ebp
80104233:	c3                   	ret    
80104234:	66 90                	xchg   %ax,%ax
80104236:	66 90                	xchg   %ax,%ax
80104238:	66 90                	xchg   %ax,%ax
8010423a:	66 90                	xchg   %ax,%ax
8010423c:	66 90                	xchg   %ax,%ax
8010423e:	66 90                	xchg   %ax,%ax

80104240 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104240:	55                   	push   %ebp
80104241:	89 e5                	mov    %esp,%ebp
80104243:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104246:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104249:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010424f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104252:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104259:	5d                   	pop    %ebp
8010425a:	c3                   	ret    
8010425b:	90                   	nop
8010425c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104260 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104260:	55                   	push   %ebp
80104261:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104263:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104266:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104269:	53                   	push   %ebx
  ebp = (uint*)v - 2;
8010426a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010426d:	31 c0                	xor    %eax,%eax
8010426f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104270:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104276:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010427c:	77 1a                	ja     80104298 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010427e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104281:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104284:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104287:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80104289:	83 f8 0a             	cmp    $0xa,%eax
8010428c:	75 e2                	jne    80104270 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010428e:	5b                   	pop    %ebx
8010428f:	5d                   	pop    %ebp
80104290:	c3                   	ret    
80104291:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    pcs[i] = 0;
80104298:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
8010429f:	83 c0 01             	add    $0x1,%eax
801042a2:	83 f8 0a             	cmp    $0xa,%eax
801042a5:	74 e7                	je     8010428e <getcallerpcs+0x2e>
    pcs[i] = 0;
801042a7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
801042ae:	83 c0 01             	add    $0x1,%eax
801042b1:	83 f8 0a             	cmp    $0xa,%eax
801042b4:	75 e2                	jne    80104298 <getcallerpcs+0x38>
801042b6:	eb d6                	jmp    8010428e <getcallerpcs+0x2e>
801042b8:	90                   	nop
801042b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042c0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801042c0:	55                   	push   %ebp
801042c1:	89 e5                	mov    %esp,%ebp
801042c3:	53                   	push   %ebx
801042c4:	83 ec 04             	sub    $0x4,%esp
801042c7:	9c                   	pushf  
801042c8:	5b                   	pop    %ebx
  asm volatile("cli");
801042c9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801042ca:	e8 71 f3 ff ff       	call   80103640 <mycpu>
801042cf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801042d5:	85 c0                	test   %eax,%eax
801042d7:	75 11                	jne    801042ea <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801042d9:	e8 62 f3 ff ff       	call   80103640 <mycpu>
801042de:	81 e3 00 02 00 00    	and    $0x200,%ebx
801042e4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801042ea:	e8 51 f3 ff ff       	call   80103640 <mycpu>
801042ef:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042f6:	83 c4 04             	add    $0x4,%esp
801042f9:	5b                   	pop    %ebx
801042fa:	5d                   	pop    %ebp
801042fb:	c3                   	ret    
801042fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104300 <popcli>:

void
popcli(void)
{
80104300:	55                   	push   %ebp
80104301:	89 e5                	mov    %esp,%ebp
80104303:	83 ec 18             	sub    $0x18,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104306:	9c                   	pushf  
80104307:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104308:	f6 c4 02             	test   $0x2,%ah
8010430b:	75 49                	jne    80104356 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010430d:	e8 2e f3 ff ff       	call   80103640 <mycpu>
80104312:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104318:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010431b:	85 d2                	test   %edx,%edx
8010431d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80104323:	78 25                	js     8010434a <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104325:	e8 16 f3 ff ff       	call   80103640 <mycpu>
8010432a:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104330:	85 d2                	test   %edx,%edx
80104332:	74 04                	je     80104338 <popcli+0x38>
    sti();
}
80104334:	c9                   	leave  
80104335:	c3                   	ret    
80104336:	66 90                	xchg   %ax,%ax
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104338:	e8 03 f3 ff ff       	call   80103640 <mycpu>
8010433d:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
80104343:	85 c0                	test   %eax,%eax
80104345:	74 ed                	je     80104334 <popcli+0x34>
  asm volatile("sti");
80104347:	fb                   	sti    
}
80104348:	c9                   	leave  
80104349:	c3                   	ret    
    panic("popcli");
8010434a:	c7 04 24 ee 74 10 80 	movl   $0x801074ee,(%esp)
80104351:	e8 0a c0 ff ff       	call   80100360 <panic>
    panic("popcli - interruptible");
80104356:	c7 04 24 d7 74 10 80 	movl   $0x801074d7,(%esp)
8010435d:	e8 fe bf ff ff       	call   80100360 <panic>
80104362:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104369:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104370 <holding>:
{
80104370:	55                   	push   %ebp
80104371:	89 e5                	mov    %esp,%ebp
80104373:	56                   	push   %esi
  r = lock->locked && lock->cpu == mycpu();
80104374:	31 f6                	xor    %esi,%esi
{
80104376:	53                   	push   %ebx
80104377:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010437a:	e8 41 ff ff ff       	call   801042c0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010437f:	8b 03                	mov    (%ebx),%eax
80104381:	85 c0                	test   %eax,%eax
80104383:	74 12                	je     80104397 <holding+0x27>
80104385:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104388:	e8 b3 f2 ff ff       	call   80103640 <mycpu>
8010438d:	39 c3                	cmp    %eax,%ebx
8010438f:	0f 94 c0             	sete   %al
80104392:	0f b6 c0             	movzbl %al,%eax
80104395:	89 c6                	mov    %eax,%esi
  popcli();
80104397:	e8 64 ff ff ff       	call   80104300 <popcli>
}
8010439c:	89 f0                	mov    %esi,%eax
8010439e:	5b                   	pop    %ebx
8010439f:	5e                   	pop    %esi
801043a0:	5d                   	pop    %ebp
801043a1:	c3                   	ret    
801043a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801043a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801043b0 <acquire>:
{
801043b0:	55                   	push   %ebp
801043b1:	89 e5                	mov    %esp,%ebp
801043b3:	53                   	push   %ebx
801043b4:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
801043b7:	e8 04 ff ff ff       	call   801042c0 <pushcli>
  if(holding(lk))
801043bc:	8b 45 08             	mov    0x8(%ebp),%eax
801043bf:	89 04 24             	mov    %eax,(%esp)
801043c2:	e8 a9 ff ff ff       	call   80104370 <holding>
801043c7:	85 c0                	test   %eax,%eax
801043c9:	75 3a                	jne    80104405 <acquire+0x55>
  asm volatile("lock; xchgl %0, %1" :
801043cb:	b9 01 00 00 00       	mov    $0x1,%ecx
  while(xchg(&lk->locked, 1) != 0)
801043d0:	8b 55 08             	mov    0x8(%ebp),%edx
801043d3:	89 c8                	mov    %ecx,%eax
801043d5:	f0 87 02             	lock xchg %eax,(%edx)
801043d8:	85 c0                	test   %eax,%eax
801043da:	75 f4                	jne    801043d0 <acquire+0x20>
  __sync_synchronize();
801043dc:	0f ae f0             	mfence 
  lk->cpu = mycpu();
801043df:	8b 5d 08             	mov    0x8(%ebp),%ebx
801043e2:	e8 59 f2 ff ff       	call   80103640 <mycpu>
801043e7:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
801043ea:	8b 45 08             	mov    0x8(%ebp),%eax
801043ed:	83 c0 0c             	add    $0xc,%eax
801043f0:	89 44 24 04          	mov    %eax,0x4(%esp)
801043f4:	8d 45 08             	lea    0x8(%ebp),%eax
801043f7:	89 04 24             	mov    %eax,(%esp)
801043fa:	e8 61 fe ff ff       	call   80104260 <getcallerpcs>
}
801043ff:	83 c4 14             	add    $0x14,%esp
80104402:	5b                   	pop    %ebx
80104403:	5d                   	pop    %ebp
80104404:	c3                   	ret    
    panic("acquire");
80104405:	c7 04 24 f5 74 10 80 	movl   $0x801074f5,(%esp)
8010440c:	e8 4f bf ff ff       	call   80100360 <panic>
80104411:	eb 0d                	jmp    80104420 <release>
80104413:	90                   	nop
80104414:	90                   	nop
80104415:	90                   	nop
80104416:	90                   	nop
80104417:	90                   	nop
80104418:	90                   	nop
80104419:	90                   	nop
8010441a:	90                   	nop
8010441b:	90                   	nop
8010441c:	90                   	nop
8010441d:	90                   	nop
8010441e:	90                   	nop
8010441f:	90                   	nop

80104420 <release>:
{
80104420:	55                   	push   %ebp
80104421:	89 e5                	mov    %esp,%ebp
80104423:	53                   	push   %ebx
80104424:	83 ec 14             	sub    $0x14,%esp
80104427:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010442a:	89 1c 24             	mov    %ebx,(%esp)
8010442d:	e8 3e ff ff ff       	call   80104370 <holding>
80104432:	85 c0                	test   %eax,%eax
80104434:	74 21                	je     80104457 <release+0x37>
  lk->pcs[0] = 0;
80104436:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010443d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104444:	0f ae f0             	mfence 
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104447:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
8010444d:	83 c4 14             	add    $0x14,%esp
80104450:	5b                   	pop    %ebx
80104451:	5d                   	pop    %ebp
  popcli();
80104452:	e9 a9 fe ff ff       	jmp    80104300 <popcli>
    panic("release");
80104457:	c7 04 24 fd 74 10 80 	movl   $0x801074fd,(%esp)
8010445e:	e8 fd be ff ff       	call   80100360 <panic>
80104463:	66 90                	xchg   %ax,%ax
80104465:	66 90                	xchg   %ax,%ax
80104467:	66 90                	xchg   %ax,%ax
80104469:	66 90                	xchg   %ax,%ax
8010446b:	66 90                	xchg   %ax,%ax
8010446d:	66 90                	xchg   %ax,%ax
8010446f:	90                   	nop

80104470 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104470:	55                   	push   %ebp
80104471:	89 e5                	mov    %esp,%ebp
80104473:	8b 55 08             	mov    0x8(%ebp),%edx
80104476:	57                   	push   %edi
80104477:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010447a:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
8010447b:	f6 c2 03             	test   $0x3,%dl
8010447e:	75 05                	jne    80104485 <memset+0x15>
80104480:	f6 c1 03             	test   $0x3,%cl
80104483:	74 13                	je     80104498 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104485:	89 d7                	mov    %edx,%edi
80104487:	8b 45 0c             	mov    0xc(%ebp),%eax
8010448a:	fc                   	cld    
8010448b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010448d:	5b                   	pop    %ebx
8010448e:	89 d0                	mov    %edx,%eax
80104490:	5f                   	pop    %edi
80104491:	5d                   	pop    %ebp
80104492:	c3                   	ret    
80104493:	90                   	nop
80104494:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104498:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010449c:	c1 e9 02             	shr    $0x2,%ecx
8010449f:	89 f8                	mov    %edi,%eax
801044a1:	89 fb                	mov    %edi,%ebx
801044a3:	c1 e0 18             	shl    $0x18,%eax
801044a6:	c1 e3 10             	shl    $0x10,%ebx
801044a9:	09 d8                	or     %ebx,%eax
801044ab:	09 f8                	or     %edi,%eax
801044ad:	c1 e7 08             	shl    $0x8,%edi
801044b0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801044b2:	89 d7                	mov    %edx,%edi
801044b4:	fc                   	cld    
801044b5:	f3 ab                	rep stos %eax,%es:(%edi)
}
801044b7:	5b                   	pop    %ebx
801044b8:	89 d0                	mov    %edx,%eax
801044ba:	5f                   	pop    %edi
801044bb:	5d                   	pop    %ebp
801044bc:	c3                   	ret    
801044bd:	8d 76 00             	lea    0x0(%esi),%esi

801044c0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	8b 45 10             	mov    0x10(%ebp),%eax
801044c6:	57                   	push   %edi
801044c7:	56                   	push   %esi
801044c8:	8b 75 0c             	mov    0xc(%ebp),%esi
801044cb:	53                   	push   %ebx
801044cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044cf:	85 c0                	test   %eax,%eax
801044d1:	8d 78 ff             	lea    -0x1(%eax),%edi
801044d4:	74 26                	je     801044fc <memcmp+0x3c>
    if(*s1 != *s2)
801044d6:	0f b6 03             	movzbl (%ebx),%eax
801044d9:	31 d2                	xor    %edx,%edx
801044db:	0f b6 0e             	movzbl (%esi),%ecx
801044de:	38 c8                	cmp    %cl,%al
801044e0:	74 16                	je     801044f8 <memcmp+0x38>
801044e2:	eb 24                	jmp    80104508 <memcmp+0x48>
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044e8:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
801044ed:	83 c2 01             	add    $0x1,%edx
801044f0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801044f4:	38 c8                	cmp    %cl,%al
801044f6:	75 10                	jne    80104508 <memcmp+0x48>
  while(n-- > 0){
801044f8:	39 fa                	cmp    %edi,%edx
801044fa:	75 ec                	jne    801044e8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801044fc:	5b                   	pop    %ebx
  return 0;
801044fd:	31 c0                	xor    %eax,%eax
}
801044ff:	5e                   	pop    %esi
80104500:	5f                   	pop    %edi
80104501:	5d                   	pop    %ebp
80104502:	c3                   	ret    
80104503:	90                   	nop
80104504:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104508:	5b                   	pop    %ebx
      return *s1 - *s2;
80104509:	29 c8                	sub    %ecx,%eax
}
8010450b:	5e                   	pop    %esi
8010450c:	5f                   	pop    %edi
8010450d:	5d                   	pop    %ebp
8010450e:	c3                   	ret    
8010450f:	90                   	nop

80104510 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104510:	55                   	push   %ebp
80104511:	89 e5                	mov    %esp,%ebp
80104513:	57                   	push   %edi
80104514:	8b 45 08             	mov    0x8(%ebp),%eax
80104517:	56                   	push   %esi
80104518:	8b 75 0c             	mov    0xc(%ebp),%esi
8010451b:	53                   	push   %ebx
8010451c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010451f:	39 c6                	cmp    %eax,%esi
80104521:	73 35                	jae    80104558 <memmove+0x48>
80104523:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104526:	39 c8                	cmp    %ecx,%eax
80104528:	73 2e                	jae    80104558 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
8010452a:	85 db                	test   %ebx,%ebx
    d += n;
8010452c:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
8010452f:	8d 53 ff             	lea    -0x1(%ebx),%edx
80104532:	74 1b                	je     8010454f <memmove+0x3f>
80104534:	f7 db                	neg    %ebx
80104536:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
80104539:	01 fb                	add    %edi,%ebx
8010453b:	90                   	nop
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
80104540:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104544:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
    while(n-- > 0)
80104547:	83 ea 01             	sub    $0x1,%edx
8010454a:	83 fa ff             	cmp    $0xffffffff,%edx
8010454d:	75 f1                	jne    80104540 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
8010454f:	5b                   	pop    %ebx
80104550:	5e                   	pop    %esi
80104551:	5f                   	pop    %edi
80104552:	5d                   	pop    %ebp
80104553:	c3                   	ret    
80104554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104558:	31 d2                	xor    %edx,%edx
8010455a:	85 db                	test   %ebx,%ebx
8010455c:	74 f1                	je     8010454f <memmove+0x3f>
8010455e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104560:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104564:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104567:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
8010456a:	39 da                	cmp    %ebx,%edx
8010456c:	75 f2                	jne    80104560 <memmove+0x50>
}
8010456e:	5b                   	pop    %ebx
8010456f:	5e                   	pop    %esi
80104570:	5f                   	pop    %edi
80104571:	5d                   	pop    %ebp
80104572:	c3                   	ret    
80104573:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104583:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104584:	eb 8a                	jmp    80104510 <memmove>
80104586:	8d 76 00             	lea    0x0(%esi),%esi
80104589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104590 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104590:	55                   	push   %ebp
80104591:	89 e5                	mov    %esp,%ebp
80104593:	56                   	push   %esi
80104594:	8b 75 10             	mov    0x10(%ebp),%esi
80104597:	53                   	push   %ebx
80104598:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010459b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010459e:	85 f6                	test   %esi,%esi
801045a0:	74 30                	je     801045d2 <strncmp+0x42>
801045a2:	0f b6 01             	movzbl (%ecx),%eax
801045a5:	84 c0                	test   %al,%al
801045a7:	74 2f                	je     801045d8 <strncmp+0x48>
801045a9:	0f b6 13             	movzbl (%ebx),%edx
801045ac:	38 d0                	cmp    %dl,%al
801045ae:	75 46                	jne    801045f6 <strncmp+0x66>
801045b0:	8d 51 01             	lea    0x1(%ecx),%edx
801045b3:	01 ce                	add    %ecx,%esi
801045b5:	eb 14                	jmp    801045cb <strncmp+0x3b>
801045b7:	90                   	nop
801045b8:	0f b6 02             	movzbl (%edx),%eax
801045bb:	84 c0                	test   %al,%al
801045bd:	74 31                	je     801045f0 <strncmp+0x60>
801045bf:	0f b6 19             	movzbl (%ecx),%ebx
801045c2:	83 c2 01             	add    $0x1,%edx
801045c5:	38 d8                	cmp    %bl,%al
801045c7:	75 17                	jne    801045e0 <strncmp+0x50>
    n--, p++, q++;
801045c9:	89 cb                	mov    %ecx,%ebx
  while(n > 0 && *p && *p == *q)
801045cb:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
801045cd:	8d 4b 01             	lea    0x1(%ebx),%ecx
  while(n > 0 && *p && *p == *q)
801045d0:	75 e6                	jne    801045b8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045d2:	5b                   	pop    %ebx
    return 0;
801045d3:	31 c0                	xor    %eax,%eax
}
801045d5:	5e                   	pop    %esi
801045d6:	5d                   	pop    %ebp
801045d7:	c3                   	ret    
801045d8:	0f b6 1b             	movzbl (%ebx),%ebx
  while(n > 0 && *p && *p == *q)
801045db:	31 c0                	xor    %eax,%eax
801045dd:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
801045e0:	0f b6 d3             	movzbl %bl,%edx
801045e3:	29 d0                	sub    %edx,%eax
}
801045e5:	5b                   	pop    %ebx
801045e6:	5e                   	pop    %esi
801045e7:	5d                   	pop    %ebp
801045e8:	c3                   	ret    
801045e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045f0:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
801045f4:	eb ea                	jmp    801045e0 <strncmp+0x50>
  while(n > 0 && *p && *p == *q)
801045f6:	89 d3                	mov    %edx,%ebx
801045f8:	eb e6                	jmp    801045e0 <strncmp+0x50>
801045fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104600 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	8b 45 08             	mov    0x8(%ebp),%eax
80104606:	56                   	push   %esi
80104607:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010460a:	53                   	push   %ebx
8010460b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010460e:	89 c2                	mov    %eax,%edx
80104610:	eb 19                	jmp    8010462b <strncpy+0x2b>
80104612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104618:	83 c3 01             	add    $0x1,%ebx
8010461b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010461f:	83 c2 01             	add    $0x1,%edx
80104622:	84 c9                	test   %cl,%cl
80104624:	88 4a ff             	mov    %cl,-0x1(%edx)
80104627:	74 09                	je     80104632 <strncpy+0x32>
80104629:	89 f1                	mov    %esi,%ecx
8010462b:	85 c9                	test   %ecx,%ecx
8010462d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104630:	7f e6                	jg     80104618 <strncpy+0x18>
    ;
  while(n-- > 0)
80104632:	31 c9                	xor    %ecx,%ecx
80104634:	85 f6                	test   %esi,%esi
80104636:	7e 0f                	jle    80104647 <strncpy+0x47>
    *s++ = 0;
80104638:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
8010463c:	89 f3                	mov    %esi,%ebx
8010463e:	83 c1 01             	add    $0x1,%ecx
80104641:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104643:	85 db                	test   %ebx,%ebx
80104645:	7f f1                	jg     80104638 <strncpy+0x38>
  return os;
}
80104647:	5b                   	pop    %ebx
80104648:	5e                   	pop    %esi
80104649:	5d                   	pop    %ebp
8010464a:	c3                   	ret    
8010464b:	90                   	nop
8010464c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104650 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104656:	56                   	push   %esi
80104657:	8b 45 08             	mov    0x8(%ebp),%eax
8010465a:	53                   	push   %ebx
8010465b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010465e:	85 c9                	test   %ecx,%ecx
80104660:	7e 26                	jle    80104688 <safestrcpy+0x38>
80104662:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104666:	89 c1                	mov    %eax,%ecx
80104668:	eb 17                	jmp    80104681 <safestrcpy+0x31>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104670:	83 c2 01             	add    $0x1,%edx
80104673:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104677:	83 c1 01             	add    $0x1,%ecx
8010467a:	84 db                	test   %bl,%bl
8010467c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010467f:	74 04                	je     80104685 <safestrcpy+0x35>
80104681:	39 f2                	cmp    %esi,%edx
80104683:	75 eb                	jne    80104670 <safestrcpy+0x20>
    ;
  *s = 0;
80104685:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104688:	5b                   	pop    %ebx
80104689:	5e                   	pop    %esi
8010468a:	5d                   	pop    %ebp
8010468b:	c3                   	ret    
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104690 <strlen>:

int
strlen(const char *s)
{
80104690:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104691:	31 c0                	xor    %eax,%eax
{
80104693:	89 e5                	mov    %esp,%ebp
80104695:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104698:	80 3a 00             	cmpb   $0x0,(%edx)
8010469b:	74 0c                	je     801046a9 <strlen+0x19>
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
801046a0:	83 c0 01             	add    $0x1,%eax
801046a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046a7:	75 f7                	jne    801046a0 <strlen+0x10>
    ;
  return n;
}
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    

801046ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801046b3:	55                   	push   %ebp
  pushl %ebx
801046b4:	53                   	push   %ebx
  pushl %esi
801046b5:	56                   	push   %esi
  pushl %edi
801046b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801046bb:	5f                   	pop    %edi
  popl %esi
801046bc:	5e                   	pop    %esi
  popl %ebx
801046bd:	5b                   	pop    %ebx
  popl %ebp
801046be:	5d                   	pop    %ebp
  ret
801046bf:	c3                   	ret    

801046c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 04             	sub    $0x4,%esp
801046c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801046ca:	e8 11 f0 ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046cf:	8b 00                	mov    (%eax),%eax
801046d1:	39 d8                	cmp    %ebx,%eax
801046d3:	76 1b                	jbe    801046f0 <fetchint+0x30>
801046d5:	8d 53 04             	lea    0x4(%ebx),%edx
801046d8:	39 d0                	cmp    %edx,%eax
801046da:	72 14                	jb     801046f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801046dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801046df:	8b 13                	mov    (%ebx),%edx
801046e1:	89 10                	mov    %edx,(%eax)
  return 0;
801046e3:	31 c0                	xor    %eax,%eax
}
801046e5:	83 c4 04             	add    $0x4,%esp
801046e8:	5b                   	pop    %ebx
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	90                   	nop
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801046f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f5:	eb ee                	jmp    801046e5 <fetchint+0x25>
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 04             	sub    $0x4,%esp
80104707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010470a:	e8 d1 ef ff ff       	call   801036e0 <myproc>

  if(addr >= curproc->sz)
8010470f:	39 18                	cmp    %ebx,(%eax)
80104711:	76 26                	jbe    80104739 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104716:	89 da                	mov    %ebx,%edx
80104718:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010471a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010471c:	39 c3                	cmp    %eax,%ebx
8010471e:	73 19                	jae    80104739 <fetchstr+0x39>
    if(*s == 0)
80104720:	80 3b 00             	cmpb   $0x0,(%ebx)
80104723:	75 0d                	jne    80104732 <fetchstr+0x32>
80104725:	eb 21                	jmp    80104748 <fetchstr+0x48>
80104727:	90                   	nop
80104728:	80 3a 00             	cmpb   $0x0,(%edx)
8010472b:	90                   	nop
8010472c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104730:	74 16                	je     80104748 <fetchstr+0x48>
  for(s = *pp; s < ep; s++){
80104732:	83 c2 01             	add    $0x1,%edx
80104735:	39 d0                	cmp    %edx,%eax
80104737:	77 ef                	ja     80104728 <fetchstr+0x28>
      return s - *pp;
  }
  return -1;
}
80104739:	83 c4 04             	add    $0x4,%esp
    return -1;
8010473c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104741:	5b                   	pop    %ebx
80104742:	5d                   	pop    %ebp
80104743:	c3                   	ret    
80104744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104748:	83 c4 04             	add    $0x4,%esp
      return s - *pp;
8010474b:	89 d0                	mov    %edx,%eax
8010474d:	29 d8                	sub    %ebx,%eax
}
8010474f:	5b                   	pop    %ebx
80104750:	5d                   	pop    %ebp
80104751:	c3                   	ret    
80104752:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104759:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104760 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	8b 75 0c             	mov    0xc(%ebp),%esi
80104767:	53                   	push   %ebx
80104768:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010476b:	e8 70 ef ff ff       	call   801036e0 <myproc>
80104770:	89 75 0c             	mov    %esi,0xc(%ebp)
80104773:	8b 40 18             	mov    0x18(%eax),%eax
80104776:	8b 40 44             	mov    0x44(%eax),%eax
80104779:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
8010477d:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104780:	5b                   	pop    %ebx
80104781:	5e                   	pop    %esi
80104782:	5d                   	pop    %ebp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104783:	e9 38 ff ff ff       	jmp    801046c0 <fetchint>
80104788:	90                   	nop
80104789:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104790 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	83 ec 20             	sub    $0x20,%esp
80104798:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010479b:	e8 40 ef ff ff       	call   801036e0 <myproc>
801047a0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801047a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047a5:	89 44 24 04          	mov    %eax,0x4(%esp)
801047a9:	8b 45 08             	mov    0x8(%ebp),%eax
801047ac:	89 04 24             	mov    %eax,(%esp)
801047af:	e8 ac ff ff ff       	call   80104760 <argint>
801047b4:	85 c0                	test   %eax,%eax
801047b6:	78 28                	js     801047e0 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801047b8:	85 db                	test   %ebx,%ebx
801047ba:	78 24                	js     801047e0 <argptr+0x50>
801047bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
801047bf:	8b 06                	mov    (%esi),%eax
801047c1:	39 c2                	cmp    %eax,%edx
801047c3:	73 1b                	jae    801047e0 <argptr+0x50>
801047c5:	01 d3                	add    %edx,%ebx
801047c7:	39 d8                	cmp    %ebx,%eax
801047c9:	72 15                	jb     801047e0 <argptr+0x50>
    return -1;
  *pp = (char*)i;
801047cb:	8b 45 0c             	mov    0xc(%ebp),%eax
801047ce:	89 10                	mov    %edx,(%eax)
  return 0;
}
801047d0:	83 c4 20             	add    $0x20,%esp
  return 0;
801047d3:	31 c0                	xor    %eax,%eax
}
801047d5:	5b                   	pop    %ebx
801047d6:	5e                   	pop    %esi
801047d7:	5d                   	pop    %ebp
801047d8:	c3                   	ret    
801047d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047e0:	83 c4 20             	add    $0x20,%esp
    return -1;
801047e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801047e8:	5b                   	pop    %ebx
801047e9:	5e                   	pop    %esi
801047ea:	5d                   	pop    %ebp
801047eb:	c3                   	ret    
801047ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801047f0 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
801047f0:	55                   	push   %ebp
801047f1:	89 e5                	mov    %esp,%ebp
801047f3:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
801047f6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047f9:	89 44 24 04          	mov    %eax,0x4(%esp)
801047fd:	8b 45 08             	mov    0x8(%ebp),%eax
80104800:	89 04 24             	mov    %eax,(%esp)
80104803:	e8 58 ff ff ff       	call   80104760 <argint>
80104808:	85 c0                	test   %eax,%eax
8010480a:	78 14                	js     80104820 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010480c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010480f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104813:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104816:	89 04 24             	mov    %eax,(%esp)
80104819:	e8 e2 fe ff ff       	call   80104700 <fetchstr>
}
8010481e:	c9                   	leave  
8010481f:	c3                   	ret    
    return -1;
80104820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104825:	c9                   	leave  
80104826:	c3                   	ret    
80104827:	89 f6                	mov    %esi,%esi
80104829:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104830 <syscall>:
[SYS_set_prior] sys_set_prior,
};

void
syscall(void)
{
80104830:	55                   	push   %ebp
80104831:	89 e5                	mov    %esp,%ebp
80104833:	56                   	push   %esi
80104834:	53                   	push   %ebx
80104835:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
80104838:	e8 a3 ee ff ff       	call   801036e0 <myproc>

  num = curproc->tf->eax;
8010483d:	8b 70 18             	mov    0x18(%eax),%esi
  struct proc *curproc = myproc();
80104840:	89 c3                	mov    %eax,%ebx
  num = curproc->tf->eax;
80104842:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104845:	8d 50 ff             	lea    -0x1(%eax),%edx
80104848:	83 fa 15             	cmp    $0x15,%edx
8010484b:	77 1b                	ja     80104868 <syscall+0x38>
8010484d:	8b 14 85 40 75 10 80 	mov    -0x7fef8ac0(,%eax,4),%edx
80104854:	85 d2                	test   %edx,%edx
80104856:	74 10                	je     80104868 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
80104858:	ff d2                	call   *%edx
8010485a:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
8010485d:	83 c4 10             	add    $0x10,%esp
80104860:	5b                   	pop    %ebx
80104861:	5e                   	pop    %esi
80104862:	5d                   	pop    %ebp
80104863:	c3                   	ret    
80104864:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104868:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
8010486c:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010486f:	89 44 24 08          	mov    %eax,0x8(%esp)
    cprintf("%d %s: unknown sys call %d\n",
80104873:	8b 43 10             	mov    0x10(%ebx),%eax
80104876:	c7 04 24 05 75 10 80 	movl   $0x80107505,(%esp)
8010487d:	89 44 24 04          	mov    %eax,0x4(%esp)
80104881:	e8 ca bd ff ff       	call   80100650 <cprintf>
    curproc->tf->eax = -1;
80104886:	8b 43 18             	mov    0x18(%ebx),%eax
80104889:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104890:	83 c4 10             	add    $0x10,%esp
80104893:	5b                   	pop    %ebx
80104894:	5e                   	pop    %esi
80104895:	5d                   	pop    %ebp
80104896:	c3                   	ret    
80104897:	66 90                	xchg   %ax,%ax
80104899:	66 90                	xchg   %ax,%ax
8010489b:	66 90                	xchg   %ax,%ax
8010489d:	66 90                	xchg   %ax,%ax
8010489f:	90                   	nop

801048a0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	53                   	push   %ebx
801048a4:	89 c3                	mov    %eax,%ebx
801048a6:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
801048a9:	e8 32 ee ff ff       	call   801036e0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
801048ae:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
801048b0:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
801048b4:	85 c9                	test   %ecx,%ecx
801048b6:	74 18                	je     801048d0 <fdalloc+0x30>
  for(fd = 0; fd < NOFILE; fd++){
801048b8:	83 c2 01             	add    $0x1,%edx
801048bb:	83 fa 10             	cmp    $0x10,%edx
801048be:	75 f0                	jne    801048b0 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
801048c0:	83 c4 04             	add    $0x4,%esp
  return -1;
801048c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801048c8:	5b                   	pop    %ebx
801048c9:	5d                   	pop    %ebp
801048ca:	c3                   	ret    
801048cb:	90                   	nop
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      curproc->ofile[fd] = f;
801048d0:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
}
801048d4:	83 c4 04             	add    $0x4,%esp
      return fd;
801048d7:	89 d0                	mov    %edx,%eax
}
801048d9:	5b                   	pop    %ebx
801048da:	5d                   	pop    %ebp
801048db:	c3                   	ret    
801048dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048e0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	57                   	push   %edi
801048e4:	56                   	push   %esi
801048e5:	53                   	push   %ebx
801048e6:	83 ec 3c             	sub    $0x3c,%esp
801048e9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
801048ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048ef:	8d 5d da             	lea    -0x26(%ebp),%ebx
801048f2:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801048f6:	89 04 24             	mov    %eax,(%esp)
{
801048f9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
801048fc:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
801048ff:	e8 4c d6 ff ff       	call   80101f50 <nameiparent>
80104904:	85 c0                	test   %eax,%eax
80104906:	89 c7                	mov    %eax,%edi
80104908:	0f 84 da 00 00 00    	je     801049e8 <create+0x108>
    return 0;
  ilock(dp);
8010490e:	89 04 24             	mov    %eax,(%esp)
80104911:	e8 ca cd ff ff       	call   801016e0 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104916:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
8010491d:	00 
8010491e:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104922:	89 3c 24             	mov    %edi,(%esp)
80104925:	e8 c6 d2 ff ff       	call   80101bf0 <dirlookup>
8010492a:	85 c0                	test   %eax,%eax
8010492c:	89 c6                	mov    %eax,%esi
8010492e:	74 40                	je     80104970 <create+0x90>
    iunlockput(dp);
80104930:	89 3c 24             	mov    %edi,(%esp)
80104933:	e8 08 d0 ff ff       	call   80101940 <iunlockput>
    ilock(ip);
80104938:	89 34 24             	mov    %esi,(%esp)
8010493b:	e8 a0 cd ff ff       	call   801016e0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104940:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104945:	75 11                	jne    80104958 <create+0x78>
80104947:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
8010494c:	89 f0                	mov    %esi,%eax
8010494e:	75 08                	jne    80104958 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104950:	83 c4 3c             	add    $0x3c,%esp
80104953:	5b                   	pop    %ebx
80104954:	5e                   	pop    %esi
80104955:	5f                   	pop    %edi
80104956:	5d                   	pop    %ebp
80104957:	c3                   	ret    
    iunlockput(ip);
80104958:	89 34 24             	mov    %esi,(%esp)
8010495b:	e8 e0 cf ff ff       	call   80101940 <iunlockput>
}
80104960:	83 c4 3c             	add    $0x3c,%esp
    return 0;
80104963:	31 c0                	xor    %eax,%eax
}
80104965:	5b                   	pop    %ebx
80104966:	5e                   	pop    %esi
80104967:	5f                   	pop    %edi
80104968:	5d                   	pop    %ebp
80104969:	c3                   	ret    
8010496a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if((ip = ialloc(dp->dev, type)) == 0)
80104970:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104974:	89 44 24 04          	mov    %eax,0x4(%esp)
80104978:	8b 07                	mov    (%edi),%eax
8010497a:	89 04 24             	mov    %eax,(%esp)
8010497d:	e8 ce cb ff ff       	call   80101550 <ialloc>
80104982:	85 c0                	test   %eax,%eax
80104984:	89 c6                	mov    %eax,%esi
80104986:	0f 84 bf 00 00 00    	je     80104a4b <create+0x16b>
  ilock(ip);
8010498c:	89 04 24             	mov    %eax,(%esp)
8010498f:	e8 4c cd ff ff       	call   801016e0 <ilock>
  ip->major = major;
80104994:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104998:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010499c:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
801049a0:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
801049a4:	b8 01 00 00 00       	mov    $0x1,%eax
801049a9:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
801049ad:	89 34 24             	mov    %esi,(%esp)
801049b0:	e8 6b cc ff ff       	call   80101620 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
801049b5:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801049ba:	74 34                	je     801049f0 <create+0x110>
  if(dirlink(dp, name, ip->inum) < 0)
801049bc:	8b 46 04             	mov    0x4(%esi),%eax
801049bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801049c3:	89 3c 24             	mov    %edi,(%esp)
801049c6:	89 44 24 08          	mov    %eax,0x8(%esp)
801049ca:	e8 81 d4 ff ff       	call   80101e50 <dirlink>
801049cf:	85 c0                	test   %eax,%eax
801049d1:	78 6c                	js     80104a3f <create+0x15f>
  iunlockput(dp);
801049d3:	89 3c 24             	mov    %edi,(%esp)
801049d6:	e8 65 cf ff ff       	call   80101940 <iunlockput>
}
801049db:	83 c4 3c             	add    $0x3c,%esp
  return ip;
801049de:	89 f0                	mov    %esi,%eax
}
801049e0:	5b                   	pop    %ebx
801049e1:	5e                   	pop    %esi
801049e2:	5f                   	pop    %edi
801049e3:	5d                   	pop    %ebp
801049e4:	c3                   	ret    
801049e5:	8d 76 00             	lea    0x0(%esi),%esi
    return 0;
801049e8:	31 c0                	xor    %eax,%eax
801049ea:	e9 61 ff ff ff       	jmp    80104950 <create+0x70>
801049ef:	90                   	nop
    dp->nlink++;  // for ".."
801049f0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801049f5:	89 3c 24             	mov    %edi,(%esp)
801049f8:	e8 23 cc ff ff       	call   80101620 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801049fd:	8b 46 04             	mov    0x4(%esi),%eax
80104a00:	c7 44 24 04 b8 75 10 	movl   $0x801075b8,0x4(%esp)
80104a07:	80 
80104a08:	89 34 24             	mov    %esi,(%esp)
80104a0b:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a0f:	e8 3c d4 ff ff       	call   80101e50 <dirlink>
80104a14:	85 c0                	test   %eax,%eax
80104a16:	78 1b                	js     80104a33 <create+0x153>
80104a18:	8b 47 04             	mov    0x4(%edi),%eax
80104a1b:	c7 44 24 04 b7 75 10 	movl   $0x801075b7,0x4(%esp)
80104a22:	80 
80104a23:	89 34 24             	mov    %esi,(%esp)
80104a26:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a2a:	e8 21 d4 ff ff       	call   80101e50 <dirlink>
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	79 89                	jns    801049bc <create+0xdc>
      panic("create dots");
80104a33:	c7 04 24 ab 75 10 80 	movl   $0x801075ab,(%esp)
80104a3a:	e8 21 b9 ff ff       	call   80100360 <panic>
    panic("create: dirlink");
80104a3f:	c7 04 24 ba 75 10 80 	movl   $0x801075ba,(%esp)
80104a46:	e8 15 b9 ff ff       	call   80100360 <panic>
    panic("create: ialloc");
80104a4b:	c7 04 24 9c 75 10 80 	movl   $0x8010759c,(%esp)
80104a52:	e8 09 b9 ff ff       	call   80100360 <panic>
80104a57:	89 f6                	mov    %esi,%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	89 c6                	mov    %eax,%esi
80104a66:	53                   	push   %ebx
80104a67:	89 d3                	mov    %edx,%ebx
80104a69:	83 ec 20             	sub    $0x20,%esp
  if(argint(n, &fd) < 0)
80104a6c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a6f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a73:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104a7a:	e8 e1 fc ff ff       	call   80104760 <argint>
80104a7f:	85 c0                	test   %eax,%eax
80104a81:	78 2d                	js     80104ab0 <argfd.constprop.0+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a83:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a87:	77 27                	ja     80104ab0 <argfd.constprop.0+0x50>
80104a89:	e8 52 ec ff ff       	call   801036e0 <myproc>
80104a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a91:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104a95:	85 c0                	test   %eax,%eax
80104a97:	74 17                	je     80104ab0 <argfd.constprop.0+0x50>
  if(pfd)
80104a99:	85 f6                	test   %esi,%esi
80104a9b:	74 02                	je     80104a9f <argfd.constprop.0+0x3f>
    *pfd = fd;
80104a9d:	89 16                	mov    %edx,(%esi)
  if(pf)
80104a9f:	85 db                	test   %ebx,%ebx
80104aa1:	74 1d                	je     80104ac0 <argfd.constprop.0+0x60>
    *pf = f;
80104aa3:	89 03                	mov    %eax,(%ebx)
  return 0;
80104aa5:	31 c0                	xor    %eax,%eax
}
80104aa7:	83 c4 20             	add    $0x20,%esp
80104aaa:	5b                   	pop    %ebx
80104aab:	5e                   	pop    %esi
80104aac:	5d                   	pop    %ebp
80104aad:	c3                   	ret    
80104aae:	66 90                	xchg   %ax,%ax
80104ab0:	83 c4 20             	add    $0x20,%esp
    return -1;
80104ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104ab8:	5b                   	pop    %ebx
80104ab9:	5e                   	pop    %esi
80104aba:	5d                   	pop    %ebp
80104abb:	c3                   	ret    
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return 0;
80104ac0:	31 c0                	xor    %eax,%eax
80104ac2:	eb e3                	jmp    80104aa7 <argfd.constprop.0+0x47>
80104ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ad0 <sys_dup>:
{
80104ad0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
80104ad1:	31 c0                	xor    %eax,%eax
{
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	53                   	push   %ebx
80104ad6:	83 ec 24             	sub    $0x24,%esp
  if(argfd(0, 0, &f) < 0)
80104ad9:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104adc:	e8 7f ff ff ff       	call   80104a60 <argfd.constprop.0>
80104ae1:	85 c0                	test   %eax,%eax
80104ae3:	78 23                	js     80104b08 <sys_dup+0x38>
  if((fd=fdalloc(f)) < 0)
80104ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae8:	e8 b3 fd ff ff       	call   801048a0 <fdalloc>
80104aed:	85 c0                	test   %eax,%eax
80104aef:	89 c3                	mov    %eax,%ebx
80104af1:	78 15                	js     80104b08 <sys_dup+0x38>
  filedup(f);
80104af3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104af6:	89 04 24             	mov    %eax,(%esp)
80104af9:	e8 12 c3 ff ff       	call   80100e10 <filedup>
  return fd;
80104afe:	89 d8                	mov    %ebx,%eax
}
80104b00:	83 c4 24             	add    $0x24,%esp
80104b03:	5b                   	pop    %ebx
80104b04:	5d                   	pop    %ebp
80104b05:	c3                   	ret    
80104b06:	66 90                	xchg   %ax,%ax
    return -1;
80104b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b0d:	eb f1                	jmp    80104b00 <sys_dup+0x30>
80104b0f:	90                   	nop

80104b10 <sys_read>:
{
80104b10:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b11:	31 c0                	xor    %eax,%eax
{
80104b13:	89 e5                	mov    %esp,%ebp
80104b15:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b18:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b1b:	e8 40 ff ff ff       	call   80104a60 <argfd.constprop.0>
80104b20:	85 c0                	test   %eax,%eax
80104b22:	78 54                	js     80104b78 <sys_read+0x68>
80104b24:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b27:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b2b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104b32:	e8 29 fc ff ff       	call   80104760 <argint>
80104b37:	85 c0                	test   %eax,%eax
80104b39:	78 3d                	js     80104b78 <sys_read+0x68>
80104b3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b3e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b45:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b49:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b50:	e8 3b fc ff ff       	call   80104790 <argptr>
80104b55:	85 c0                	test   %eax,%eax
80104b57:	78 1f                	js     80104b78 <sys_read+0x68>
  return fileread(f, p, n);
80104b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104b5c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104b63:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104b6a:	89 04 24             	mov    %eax,(%esp)
80104b6d:	e8 fe c3 ff ff       	call   80100f70 <fileread>
}
80104b72:	c9                   	leave  
80104b73:	c3                   	ret    
80104b74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104b78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104b7d:	c9                   	leave  
80104b7e:	c3                   	ret    
80104b7f:	90                   	nop

80104b80 <sys_write>:
{
80104b80:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b81:	31 c0                	xor    %eax,%eax
{
80104b83:	89 e5                	mov    %esp,%ebp
80104b85:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b88:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b8b:	e8 d0 fe ff ff       	call   80104a60 <argfd.constprop.0>
80104b90:	85 c0                	test   %eax,%eax
80104b92:	78 54                	js     80104be8 <sys_write+0x68>
80104b94:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b97:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b9b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ba2:	e8 b9 fb ff ff       	call   80104760 <argint>
80104ba7:	85 c0                	test   %eax,%eax
80104ba9:	78 3d                	js     80104be8 <sys_write+0x68>
80104bab:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104bb5:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bb9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bc0:	e8 cb fb ff ff       	call   80104790 <argptr>
80104bc5:	85 c0                	test   %eax,%eax
80104bc7:	78 1f                	js     80104be8 <sys_write+0x68>
  return filewrite(f, p, n);
80104bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bcc:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104bd3:	89 44 24 04          	mov    %eax,0x4(%esp)
80104bd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104bda:	89 04 24             	mov    %eax,(%esp)
80104bdd:	e8 2e c4 ff ff       	call   80101010 <filewrite>
}
80104be2:	c9                   	leave  
80104be3:	c3                   	ret    
80104be4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bed:	c9                   	leave  
80104bee:	c3                   	ret    
80104bef:	90                   	nop

80104bf0 <sys_close>:
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, &fd, &f) < 0)
80104bf6:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104bf9:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bfc:	e8 5f fe ff ff       	call   80104a60 <argfd.constprop.0>
80104c01:	85 c0                	test   %eax,%eax
80104c03:	78 23                	js     80104c28 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
80104c05:	e8 d6 ea ff ff       	call   801036e0 <myproc>
80104c0a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104c0d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104c14:	00 
  fileclose(f);
80104c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c18:	89 04 24             	mov    %eax,(%esp)
80104c1b:	e8 40 c2 ff ff       	call   80100e60 <fileclose>
  return 0;
80104c20:	31 c0                	xor    %eax,%eax
}
80104c22:	c9                   	leave  
80104c23:	c3                   	ret    
80104c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c2d:	c9                   	leave  
80104c2e:	c3                   	ret    
80104c2f:	90                   	nop

80104c30 <sys_fstat>:
{
80104c30:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c31:	31 c0                	xor    %eax,%eax
{
80104c33:	89 e5                	mov    %esp,%ebp
80104c35:	83 ec 28             	sub    $0x28,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c38:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c3b:	e8 20 fe ff ff       	call   80104a60 <argfd.constprop.0>
80104c40:	85 c0                	test   %eax,%eax
80104c42:	78 34                	js     80104c78 <sys_fstat+0x48>
80104c44:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c47:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104c4e:	00 
80104c4f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c53:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104c5a:	e8 31 fb ff ff       	call   80104790 <argptr>
80104c5f:	85 c0                	test   %eax,%eax
80104c61:	78 15                	js     80104c78 <sys_fstat+0x48>
  return filestat(f, st);
80104c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104c66:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c6a:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104c6d:	89 04 24             	mov    %eax,(%esp)
80104c70:	e8 ab c2 ff ff       	call   80100f20 <filestat>
}
80104c75:	c9                   	leave  
80104c76:	c3                   	ret    
80104c77:	90                   	nop
    return -1;
80104c78:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c7d:	c9                   	leave  
80104c7e:	c3                   	ret    
80104c7f:	90                   	nop

80104c80 <sys_link>:
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	57                   	push   %edi
80104c84:	56                   	push   %esi
80104c85:	53                   	push   %ebx
80104c86:	83 ec 3c             	sub    $0x3c,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104c89:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c90:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c97:	e8 54 fb ff ff       	call   801047f0 <argstr>
80104c9c:	85 c0                	test   %eax,%eax
80104c9e:	0f 88 e6 00 00 00    	js     80104d8a <sys_link+0x10a>
80104ca4:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104ca7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104cab:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104cb2:	e8 39 fb ff ff       	call   801047f0 <argstr>
80104cb7:	85 c0                	test   %eax,%eax
80104cb9:	0f 88 cb 00 00 00    	js     80104d8a <sys_link+0x10a>
  begin_op();
80104cbf:	e8 7c de ff ff       	call   80102b40 <begin_op>
  if((ip = namei(old)) == 0){
80104cc4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104cc7:	89 04 24             	mov    %eax,(%esp)
80104cca:	e8 61 d2 ff ff       	call   80101f30 <namei>
80104ccf:	85 c0                	test   %eax,%eax
80104cd1:	89 c3                	mov    %eax,%ebx
80104cd3:	0f 84 ac 00 00 00    	je     80104d85 <sys_link+0x105>
  ilock(ip);
80104cd9:	89 04 24             	mov    %eax,(%esp)
80104cdc:	e8 ff c9 ff ff       	call   801016e0 <ilock>
  if(ip->type == T_DIR){
80104ce1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ce6:	0f 84 91 00 00 00    	je     80104d7d <sys_link+0xfd>
  ip->nlink++;
80104cec:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80104cf1:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80104cf4:	89 1c 24             	mov    %ebx,(%esp)
80104cf7:	e8 24 c9 ff ff       	call   80101620 <iupdate>
  iunlock(ip);
80104cfc:	89 1c 24             	mov    %ebx,(%esp)
80104cff:	e8 bc ca ff ff       	call   801017c0 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80104d04:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104d07:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d0b:	89 04 24             	mov    %eax,(%esp)
80104d0e:	e8 3d d2 ff ff       	call   80101f50 <nameiparent>
80104d13:	85 c0                	test   %eax,%eax
80104d15:	89 c6                	mov    %eax,%esi
80104d17:	74 4f                	je     80104d68 <sys_link+0xe8>
  ilock(dp);
80104d19:	89 04 24             	mov    %eax,(%esp)
80104d1c:	e8 bf c9 ff ff       	call   801016e0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d21:	8b 03                	mov    (%ebx),%eax
80104d23:	39 06                	cmp    %eax,(%esi)
80104d25:	75 39                	jne    80104d60 <sys_link+0xe0>
80104d27:	8b 43 04             	mov    0x4(%ebx),%eax
80104d2a:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104d2e:	89 34 24             	mov    %esi,(%esp)
80104d31:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d35:	e8 16 d1 ff ff       	call   80101e50 <dirlink>
80104d3a:	85 c0                	test   %eax,%eax
80104d3c:	78 22                	js     80104d60 <sys_link+0xe0>
  iunlockput(dp);
80104d3e:	89 34 24             	mov    %esi,(%esp)
80104d41:	e8 fa cb ff ff       	call   80101940 <iunlockput>
  iput(ip);
80104d46:	89 1c 24             	mov    %ebx,(%esp)
80104d49:	e8 b2 ca ff ff       	call   80101800 <iput>
  end_op();
80104d4e:	e8 5d de ff ff       	call   80102bb0 <end_op>
}
80104d53:	83 c4 3c             	add    $0x3c,%esp
  return 0;
80104d56:	31 c0                	xor    %eax,%eax
}
80104d58:	5b                   	pop    %ebx
80104d59:	5e                   	pop    %esi
80104d5a:	5f                   	pop    %edi
80104d5b:	5d                   	pop    %ebp
80104d5c:	c3                   	ret    
80104d5d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(dp);
80104d60:	89 34 24             	mov    %esi,(%esp)
80104d63:	e8 d8 cb ff ff       	call   80101940 <iunlockput>
  ilock(ip);
80104d68:	89 1c 24             	mov    %ebx,(%esp)
80104d6b:	e8 70 c9 ff ff       	call   801016e0 <ilock>
  ip->nlink--;
80104d70:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d75:	89 1c 24             	mov    %ebx,(%esp)
80104d78:	e8 a3 c8 ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104d7d:	89 1c 24             	mov    %ebx,(%esp)
80104d80:	e8 bb cb ff ff       	call   80101940 <iunlockput>
  end_op();
80104d85:	e8 26 de ff ff       	call   80102bb0 <end_op>
}
80104d8a:	83 c4 3c             	add    $0x3c,%esp
  return -1;
80104d8d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104d92:	5b                   	pop    %ebx
80104d93:	5e                   	pop    %esi
80104d94:	5f                   	pop    %edi
80104d95:	5d                   	pop    %ebp
80104d96:	c3                   	ret    
80104d97:	89 f6                	mov    %esi,%esi
80104d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104da0 <sys_unlink>:
{
80104da0:	55                   	push   %ebp
80104da1:	89 e5                	mov    %esp,%ebp
80104da3:	57                   	push   %edi
80104da4:	56                   	push   %esi
80104da5:	53                   	push   %ebx
80104da6:	83 ec 5c             	sub    $0x5c,%esp
  if(argstr(0, &path) < 0)
80104da9:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104dac:	89 44 24 04          	mov    %eax,0x4(%esp)
80104db0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104db7:	e8 34 fa ff ff       	call   801047f0 <argstr>
80104dbc:	85 c0                	test   %eax,%eax
80104dbe:	0f 88 76 01 00 00    	js     80104f3a <sys_unlink+0x19a>
  begin_op();
80104dc4:	e8 77 dd ff ff       	call   80102b40 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104dc9:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104dcc:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104dcf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104dd3:	89 04 24             	mov    %eax,(%esp)
80104dd6:	e8 75 d1 ff ff       	call   80101f50 <nameiparent>
80104ddb:	85 c0                	test   %eax,%eax
80104ddd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104de0:	0f 84 4f 01 00 00    	je     80104f35 <sys_unlink+0x195>
  ilock(dp);
80104de6:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104de9:	89 34 24             	mov    %esi,(%esp)
80104dec:	e8 ef c8 ff ff       	call   801016e0 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104df1:	c7 44 24 04 b8 75 10 	movl   $0x801075b8,0x4(%esp)
80104df8:	80 
80104df9:	89 1c 24             	mov    %ebx,(%esp)
80104dfc:	e8 bf cd ff ff       	call   80101bc0 <namecmp>
80104e01:	85 c0                	test   %eax,%eax
80104e03:	0f 84 21 01 00 00    	je     80104f2a <sys_unlink+0x18a>
80104e09:	c7 44 24 04 b7 75 10 	movl   $0x801075b7,0x4(%esp)
80104e10:	80 
80104e11:	89 1c 24             	mov    %ebx,(%esp)
80104e14:	e8 a7 cd ff ff       	call   80101bc0 <namecmp>
80104e19:	85 c0                	test   %eax,%eax
80104e1b:	0f 84 09 01 00 00    	je     80104f2a <sys_unlink+0x18a>
  if((ip = dirlookup(dp, name, &off)) == 0)
80104e21:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e24:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104e28:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e2c:	89 34 24             	mov    %esi,(%esp)
80104e2f:	e8 bc cd ff ff       	call   80101bf0 <dirlookup>
80104e34:	85 c0                	test   %eax,%eax
80104e36:	89 c3                	mov    %eax,%ebx
80104e38:	0f 84 ec 00 00 00    	je     80104f2a <sys_unlink+0x18a>
  ilock(ip);
80104e3e:	89 04 24             	mov    %eax,(%esp)
80104e41:	e8 9a c8 ff ff       	call   801016e0 <ilock>
  if(ip->nlink < 1)
80104e46:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104e4b:	0f 8e 24 01 00 00    	jle    80104f75 <sys_unlink+0x1d5>
  if(ip->type == T_DIR && !isdirempty(ip)){
80104e51:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e56:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104e59:	74 7d                	je     80104ed8 <sys_unlink+0x138>
  memset(&de, 0, sizeof(de));
80104e5b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104e62:	00 
80104e63:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104e6a:	00 
80104e6b:	89 34 24             	mov    %esi,(%esp)
80104e6e:	e8 fd f5 ff ff       	call   80104470 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104e73:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104e76:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104e7d:	00 
80104e7e:	89 74 24 04          	mov    %esi,0x4(%esp)
80104e82:	89 44 24 08          	mov    %eax,0x8(%esp)
80104e86:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104e89:	89 04 24             	mov    %eax,(%esp)
80104e8c:	e8 ff cb ff ff       	call   80101a90 <writei>
80104e91:	83 f8 10             	cmp    $0x10,%eax
80104e94:	0f 85 cf 00 00 00    	jne    80104f69 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
80104e9a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104e9f:	0f 84 a3 00 00 00    	je     80104f48 <sys_unlink+0x1a8>
  iunlockput(dp);
80104ea5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104ea8:	89 04 24             	mov    %eax,(%esp)
80104eab:	e8 90 ca ff ff       	call   80101940 <iunlockput>
  ip->nlink--;
80104eb0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104eb5:	89 1c 24             	mov    %ebx,(%esp)
80104eb8:	e8 63 c7 ff ff       	call   80101620 <iupdate>
  iunlockput(ip);
80104ebd:	89 1c 24             	mov    %ebx,(%esp)
80104ec0:	e8 7b ca ff ff       	call   80101940 <iunlockput>
  end_op();
80104ec5:	e8 e6 dc ff ff       	call   80102bb0 <end_op>
}
80104eca:	83 c4 5c             	add    $0x5c,%esp
  return 0;
80104ecd:	31 c0                	xor    %eax,%eax
}
80104ecf:	5b                   	pop    %ebx
80104ed0:	5e                   	pop    %esi
80104ed1:	5f                   	pop    %edi
80104ed2:	5d                   	pop    %ebp
80104ed3:	c3                   	ret    
80104ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104ed8:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104edc:	0f 86 79 ff ff ff    	jbe    80104e5b <sys_unlink+0xbb>
80104ee2:	bf 20 00 00 00       	mov    $0x20,%edi
80104ee7:	eb 15                	jmp    80104efe <sys_unlink+0x15e>
80104ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ef0:	8d 57 10             	lea    0x10(%edi),%edx
80104ef3:	3b 53 58             	cmp    0x58(%ebx),%edx
80104ef6:	0f 83 5f ff ff ff    	jae    80104e5b <sys_unlink+0xbb>
80104efc:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104efe:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104f05:	00 
80104f06:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104f0a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104f0e:	89 1c 24             	mov    %ebx,(%esp)
80104f11:	e8 7a ca ff ff       	call   80101990 <readi>
80104f16:	83 f8 10             	cmp    $0x10,%eax
80104f19:	75 42                	jne    80104f5d <sys_unlink+0x1bd>
    if(de.inum != 0)
80104f1b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f20:	74 ce                	je     80104ef0 <sys_unlink+0x150>
    iunlockput(ip);
80104f22:	89 1c 24             	mov    %ebx,(%esp)
80104f25:	e8 16 ca ff ff       	call   80101940 <iunlockput>
  iunlockput(dp);
80104f2a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f2d:	89 04 24             	mov    %eax,(%esp)
80104f30:	e8 0b ca ff ff       	call   80101940 <iunlockput>
  end_op();
80104f35:	e8 76 dc ff ff       	call   80102bb0 <end_op>
}
80104f3a:	83 c4 5c             	add    $0x5c,%esp
  return -1;
80104f3d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f42:	5b                   	pop    %ebx
80104f43:	5e                   	pop    %esi
80104f44:	5f                   	pop    %edi
80104f45:	5d                   	pop    %ebp
80104f46:	c3                   	ret    
80104f47:	90                   	nop
    dp->nlink--;
80104f48:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104f4b:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104f50:	89 04 24             	mov    %eax,(%esp)
80104f53:	e8 c8 c6 ff ff       	call   80101620 <iupdate>
80104f58:	e9 48 ff ff ff       	jmp    80104ea5 <sys_unlink+0x105>
      panic("isdirempty: readi");
80104f5d:	c7 04 24 dc 75 10 80 	movl   $0x801075dc,(%esp)
80104f64:	e8 f7 b3 ff ff       	call   80100360 <panic>
    panic("unlink: writei");
80104f69:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
80104f70:	e8 eb b3 ff ff       	call   80100360 <panic>
    panic("unlink: nlink < 1");
80104f75:	c7 04 24 ca 75 10 80 	movl   $0x801075ca,(%esp)
80104f7c:	e8 df b3 ff ff       	call   80100360 <panic>
80104f81:	eb 0d                	jmp    80104f90 <sys_open>
80104f83:	90                   	nop
80104f84:	90                   	nop
80104f85:	90                   	nop
80104f86:	90                   	nop
80104f87:	90                   	nop
80104f88:	90                   	nop
80104f89:	90                   	nop
80104f8a:	90                   	nop
80104f8b:	90                   	nop
80104f8c:	90                   	nop
80104f8d:	90                   	nop
80104f8e:	90                   	nop
80104f8f:	90                   	nop

80104f90 <sys_open>:

int
sys_open(void)
{
80104f90:	55                   	push   %ebp
80104f91:	89 e5                	mov    %esp,%ebp
80104f93:	57                   	push   %edi
80104f94:	56                   	push   %esi
80104f95:	53                   	push   %ebx
80104f96:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104f99:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104f9c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fa0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fa7:	e8 44 f8 ff ff       	call   801047f0 <argstr>
80104fac:	85 c0                	test   %eax,%eax
80104fae:	0f 88 d1 00 00 00    	js     80105085 <sys_open+0xf5>
80104fb4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104fb7:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fc2:	e8 99 f7 ff ff       	call   80104760 <argint>
80104fc7:	85 c0                	test   %eax,%eax
80104fc9:	0f 88 b6 00 00 00    	js     80105085 <sys_open+0xf5>
    return -1;

  begin_op();
80104fcf:	e8 6c db ff ff       	call   80102b40 <begin_op>

  if(omode & O_CREATE){
80104fd4:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104fd8:	0f 85 82 00 00 00    	jne    80105060 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104fde:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104fe1:	89 04 24             	mov    %eax,(%esp)
80104fe4:	e8 47 cf ff ff       	call   80101f30 <namei>
80104fe9:	85 c0                	test   %eax,%eax
80104feb:	89 c6                	mov    %eax,%esi
80104fed:	0f 84 8d 00 00 00    	je     80105080 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104ff3:	89 04 24             	mov    %eax,(%esp)
80104ff6:	e8 e5 c6 ff ff       	call   801016e0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104ffb:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105000:	0f 84 92 00 00 00    	je     80105098 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105006:	e8 95 bd ff ff       	call   80100da0 <filealloc>
8010500b:	85 c0                	test   %eax,%eax
8010500d:	89 c3                	mov    %eax,%ebx
8010500f:	0f 84 93 00 00 00    	je     801050a8 <sys_open+0x118>
80105015:	e8 86 f8 ff ff       	call   801048a0 <fdalloc>
8010501a:	85 c0                	test   %eax,%eax
8010501c:	89 c7                	mov    %eax,%edi
8010501e:	0f 88 94 00 00 00    	js     801050b8 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105024:	89 34 24             	mov    %esi,(%esp)
80105027:	e8 94 c7 ff ff       	call   801017c0 <iunlock>
  end_op();
8010502c:	e8 7f db ff ff       	call   80102bb0 <end_op>

  f->type = FD_INODE;
80105031:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  f->ip = ip;
8010503a:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
8010503d:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80105044:	89 c2                	mov    %eax,%edx
80105046:	83 e2 01             	and    $0x1,%edx
80105049:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010504c:	a8 03                	test   $0x3,%al
  f->readable = !(omode & O_WRONLY);
8010504e:	88 53 08             	mov    %dl,0x8(%ebx)
  return fd;
80105051:	89 f8                	mov    %edi,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105053:	0f 95 43 09          	setne  0x9(%ebx)
}
80105057:	83 c4 2c             	add    $0x2c,%esp
8010505a:	5b                   	pop    %ebx
8010505b:	5e                   	pop    %esi
8010505c:	5f                   	pop    %edi
8010505d:	5d                   	pop    %ebp
8010505e:	c3                   	ret    
8010505f:	90                   	nop
    ip = create(path, T_FILE, 0, 0);
80105060:	8b 45 e0             	mov    -0x20(%ebp),%eax
80105063:	31 c9                	xor    %ecx,%ecx
80105065:	ba 02 00 00 00       	mov    $0x2,%edx
8010506a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105071:	e8 6a f8 ff ff       	call   801048e0 <create>
    if(ip == 0){
80105076:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
80105078:	89 c6                	mov    %eax,%esi
    if(ip == 0){
8010507a:	75 8a                	jne    80105006 <sys_open+0x76>
8010507c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    end_op();
80105080:	e8 2b db ff ff       	call   80102bb0 <end_op>
}
80105085:	83 c4 2c             	add    $0x2c,%esp
    return -1;
80105088:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010508d:	5b                   	pop    %ebx
8010508e:	5e                   	pop    %esi
8010508f:	5f                   	pop    %edi
80105090:	5d                   	pop    %ebp
80105091:	c3                   	ret    
80105092:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
80105098:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010509b:	85 c0                	test   %eax,%eax
8010509d:	0f 84 63 ff ff ff    	je     80105006 <sys_open+0x76>
801050a3:	90                   	nop
801050a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iunlockput(ip);
801050a8:	89 34 24             	mov    %esi,(%esp)
801050ab:	e8 90 c8 ff ff       	call   80101940 <iunlockput>
801050b0:	eb ce                	jmp    80105080 <sys_open+0xf0>
801050b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      fileclose(f);
801050b8:	89 1c 24             	mov    %ebx,(%esp)
801050bb:	e8 a0 bd ff ff       	call   80100e60 <fileclose>
801050c0:	eb e6                	jmp    801050a8 <sys_open+0x118>
801050c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <sys_mkdir>:

int
sys_mkdir(void)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
801050d6:	e8 65 da ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
801050db:	8d 45 f4             	lea    -0xc(%ebp),%eax
801050de:	89 44 24 04          	mov    %eax,0x4(%esp)
801050e2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050e9:	e8 02 f7 ff ff       	call   801047f0 <argstr>
801050ee:	85 c0                	test   %eax,%eax
801050f0:	78 2e                	js     80105120 <sys_mkdir+0x50>
801050f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
801050f5:	31 c9                	xor    %ecx,%ecx
801050f7:	ba 01 00 00 00       	mov    $0x1,%edx
801050fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105103:	e8 d8 f7 ff ff       	call   801048e0 <create>
80105108:	85 c0                	test   %eax,%eax
8010510a:	74 14                	je     80105120 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010510c:	89 04 24             	mov    %eax,(%esp)
8010510f:	e8 2c c8 ff ff       	call   80101940 <iunlockput>
  end_op();
80105114:	e8 97 da ff ff       	call   80102bb0 <end_op>
  return 0;
80105119:	31 c0                	xor    %eax,%eax
}
8010511b:	c9                   	leave  
8010511c:	c3                   	ret    
8010511d:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
80105120:	e8 8b da ff ff       	call   80102bb0 <end_op>
    return -1;
80105125:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010512a:	c9                   	leave  
8010512b:	c3                   	ret    
8010512c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105130 <sys_mknod>:

int
sys_mknod(void)
{
80105130:	55                   	push   %ebp
80105131:	89 e5                	mov    %esp,%ebp
80105133:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105136:	e8 05 da ff ff       	call   80102b40 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010513b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010513e:	89 44 24 04          	mov    %eax,0x4(%esp)
80105142:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105149:	e8 a2 f6 ff ff       	call   801047f0 <argstr>
8010514e:	85 c0                	test   %eax,%eax
80105150:	78 5e                	js     801051b0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105152:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105155:	89 44 24 04          	mov    %eax,0x4(%esp)
80105159:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80105160:	e8 fb f5 ff ff       	call   80104760 <argint>
  if((argstr(0, &path)) < 0 ||
80105165:	85 c0                	test   %eax,%eax
80105167:	78 47                	js     801051b0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105169:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010516c:	89 44 24 04          	mov    %eax,0x4(%esp)
80105170:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80105177:	e8 e4 f5 ff ff       	call   80104760 <argint>
     argint(1, &major) < 0 ||
8010517c:	85 c0                	test   %eax,%eax
8010517e:	78 30                	js     801051b0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
80105180:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
80105184:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105189:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010518d:	89 04 24             	mov    %eax,(%esp)
     argint(2, &minor) < 0 ||
80105190:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105193:	e8 48 f7 ff ff       	call   801048e0 <create>
80105198:	85 c0                	test   %eax,%eax
8010519a:	74 14                	je     801051b0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010519c:	89 04 24             	mov    %eax,(%esp)
8010519f:	e8 9c c7 ff ff       	call   80101940 <iunlockput>
  end_op();
801051a4:	e8 07 da ff ff       	call   80102bb0 <end_op>
  return 0;
801051a9:	31 c0                	xor    %eax,%eax
}
801051ab:	c9                   	leave  
801051ac:	c3                   	ret    
801051ad:	8d 76 00             	lea    0x0(%esi),%esi
    end_op();
801051b0:	e8 fb d9 ff ff       	call   80102bb0 <end_op>
    return -1;
801051b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051ba:	c9                   	leave  
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <sys_chdir>:

int
sys_chdir(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	56                   	push   %esi
801051c4:	53                   	push   %ebx
801051c5:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801051c8:	e8 13 e5 ff ff       	call   801036e0 <myproc>
801051cd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801051cf:	e8 6c d9 ff ff       	call   80102b40 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
801051d4:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801051db:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051e2:	e8 09 f6 ff ff       	call   801047f0 <argstr>
801051e7:	85 c0                	test   %eax,%eax
801051e9:	78 4a                	js     80105235 <sys_chdir+0x75>
801051eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
801051ee:	89 04 24             	mov    %eax,(%esp)
801051f1:	e8 3a cd ff ff       	call   80101f30 <namei>
801051f6:	85 c0                	test   %eax,%eax
801051f8:	89 c3                	mov    %eax,%ebx
801051fa:	74 39                	je     80105235 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
801051fc:	89 04 24             	mov    %eax,(%esp)
801051ff:	e8 dc c4 ff ff       	call   801016e0 <ilock>
  if(ip->type != T_DIR){
80105204:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105209:	89 1c 24             	mov    %ebx,(%esp)
  if(ip->type != T_DIR){
8010520c:	75 22                	jne    80105230 <sys_chdir+0x70>
    end_op();
    return -1;
  }
  iunlock(ip);
8010520e:	e8 ad c5 ff ff       	call   801017c0 <iunlock>
  iput(curproc->cwd);
80105213:	8b 46 68             	mov    0x68(%esi),%eax
80105216:	89 04 24             	mov    %eax,(%esp)
80105219:	e8 e2 c5 ff ff       	call   80101800 <iput>
  end_op();
8010521e:	e8 8d d9 ff ff       	call   80102bb0 <end_op>
  curproc->cwd = ip;
  return 0;
80105223:	31 c0                	xor    %eax,%eax
  curproc->cwd = ip;
80105225:	89 5e 68             	mov    %ebx,0x68(%esi)
}
80105228:	83 c4 20             	add    $0x20,%esp
8010522b:	5b                   	pop    %ebx
8010522c:	5e                   	pop    %esi
8010522d:	5d                   	pop    %ebp
8010522e:	c3                   	ret    
8010522f:	90                   	nop
    iunlockput(ip);
80105230:	e8 0b c7 ff ff       	call   80101940 <iunlockput>
    end_op();
80105235:	e8 76 d9 ff ff       	call   80102bb0 <end_op>
}
8010523a:	83 c4 20             	add    $0x20,%esp
    return -1;
8010523d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105242:	5b                   	pop    %ebx
80105243:	5e                   	pop    %esi
80105244:	5d                   	pop    %ebp
80105245:	c3                   	ret    
80105246:	8d 76 00             	lea    0x0(%esi),%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_exec>:

int
sys_exec(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	57                   	push   %edi
80105254:	56                   	push   %esi
80105255:	53                   	push   %ebx
80105256:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
8010525c:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
80105262:	89 44 24 04          	mov    %eax,0x4(%esp)
80105266:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010526d:	e8 7e f5 ff ff       	call   801047f0 <argstr>
80105272:	85 c0                	test   %eax,%eax
80105274:	0f 88 84 00 00 00    	js     801052fe <sys_exec+0xae>
8010527a:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105280:	89 44 24 04          	mov    %eax,0x4(%esp)
80105284:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010528b:	e8 d0 f4 ff ff       	call   80104760 <argint>
80105290:	85 c0                	test   %eax,%eax
80105292:	78 6a                	js     801052fe <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105294:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010529a:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
8010529c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
801052a3:	00 
801052a4:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
801052aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801052b1:	00 
801052b2:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
801052b8:	89 04 24             	mov    %eax,(%esp)
801052bb:	e8 b0 f1 ff ff       	call   80104470 <memset>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
801052c0:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
801052c6:	89 7c 24 04          	mov    %edi,0x4(%esp)
801052ca:	8d 04 98             	lea    (%eax,%ebx,4),%eax
801052cd:	89 04 24             	mov    %eax,(%esp)
801052d0:	e8 eb f3 ff ff       	call   801046c0 <fetchint>
801052d5:	85 c0                	test   %eax,%eax
801052d7:	78 25                	js     801052fe <sys_exec+0xae>
      return -1;
    if(uarg == 0){
801052d9:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
801052df:	85 c0                	test   %eax,%eax
801052e1:	74 2d                	je     80105310 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
801052e3:	89 74 24 04          	mov    %esi,0x4(%esp)
801052e7:	89 04 24             	mov    %eax,(%esp)
801052ea:	e8 11 f4 ff ff       	call   80104700 <fetchstr>
801052ef:	85 c0                	test   %eax,%eax
801052f1:	78 0b                	js     801052fe <sys_exec+0xae>
  for(i=0;; i++){
801052f3:	83 c3 01             	add    $0x1,%ebx
801052f6:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
801052f9:	83 fb 20             	cmp    $0x20,%ebx
801052fc:	75 c2                	jne    801052c0 <sys_exec+0x70>
      return -1;
  }
  return exec(path, argv);
}
801052fe:	81 c4 ac 00 00 00    	add    $0xac,%esp
    return -1;
80105304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105309:	5b                   	pop    %ebx
8010530a:	5e                   	pop    %esi
8010530b:	5f                   	pop    %edi
8010530c:	5d                   	pop    %ebp
8010530d:	c3                   	ret    
8010530e:	66 90                	xchg   %ax,%ax
  return exec(path, argv);
80105310:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105316:	89 44 24 04          	mov    %eax,0x4(%esp)
8010531a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
      argv[i] = 0;
80105320:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
80105327:	00 00 00 00 
  return exec(path, argv);
8010532b:	89 04 24             	mov    %eax,(%esp)
8010532e:	e8 6d b6 ff ff       	call   801009a0 <exec>
}
80105333:	81 c4 ac 00 00 00    	add    $0xac,%esp
80105339:	5b                   	pop    %ebx
8010533a:	5e                   	pop    %esi
8010533b:	5f                   	pop    %edi
8010533c:	5d                   	pop    %ebp
8010533d:	c3                   	ret    
8010533e:	66 90                	xchg   %ax,%ax

80105340 <sys_pipe>:

int
sys_pipe(void)
{
80105340:	55                   	push   %ebp
80105341:	89 e5                	mov    %esp,%ebp
80105343:	53                   	push   %ebx
80105344:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
80105347:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010534a:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
80105351:	00 
80105352:	89 44 24 04          	mov    %eax,0x4(%esp)
80105356:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
8010535d:	e8 2e f4 ff ff       	call   80104790 <argptr>
80105362:	85 c0                	test   %eax,%eax
80105364:	78 6d                	js     801053d3 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105366:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105369:	89 44 24 04          	mov    %eax,0x4(%esp)
8010536d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105370:	89 04 24             	mov    %eax,(%esp)
80105373:	e8 28 de ff ff       	call   801031a0 <pipealloc>
80105378:	85 c0                	test   %eax,%eax
8010537a:	78 57                	js     801053d3 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010537c:	8b 45 f0             	mov    -0x10(%ebp),%eax
8010537f:	e8 1c f5 ff ff       	call   801048a0 <fdalloc>
80105384:	85 c0                	test   %eax,%eax
80105386:	89 c3                	mov    %eax,%ebx
80105388:	78 33                	js     801053bd <sys_pipe+0x7d>
8010538a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010538d:	e8 0e f5 ff ff       	call   801048a0 <fdalloc>
80105392:	85 c0                	test   %eax,%eax
80105394:	78 1a                	js     801053b0 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105396:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105399:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010539b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010539e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
801053a1:	83 c4 24             	add    $0x24,%esp
  return 0;
801053a4:	31 c0                	xor    %eax,%eax
}
801053a6:	5b                   	pop    %ebx
801053a7:	5d                   	pop    %ebp
801053a8:	c3                   	ret    
801053a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
801053b0:	e8 2b e3 ff ff       	call   801036e0 <myproc>
801053b5:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
801053bc:	00 
    fileclose(rf);
801053bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
801053c0:	89 04 24             	mov    %eax,(%esp)
801053c3:	e8 98 ba ff ff       	call   80100e60 <fileclose>
    fileclose(wf);
801053c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
801053cb:	89 04 24             	mov    %eax,(%esp)
801053ce:	e8 8d ba ff ff       	call   80100e60 <fileclose>
}
801053d3:	83 c4 24             	add    $0x24,%esp
    return -1;
801053d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053db:	5b                   	pop    %ebx
801053dc:	5d                   	pop    %ebp
801053dd:	c3                   	ret    
801053de:	66 90                	xchg   %ax,%ax

801053e0 <sys_fork>:
#include "mmu.h"
#include "proc.h"

int
sys_fork(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
  return fork();
}
801053e3:	5d                   	pop    %ebp
  return fork();
801053e4:	e9 a7 e4 ff ff       	jmp    80103890 <fork>
801053e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_exit>:

int
sys_exit(void)
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	83 ec 08             	sub    $0x8,%esp
  exit();
801053f6:	e8 95 e7 ff ff       	call   80103b90 <exit>
  return 0;  // not reached
}
801053fb:	31 c0                	xor    %eax,%eax
801053fd:	c9                   	leave  
801053fe:	c3                   	ret    
801053ff:	90                   	nop

80105400 <sys_wait>:

int
sys_wait(void)
{
80105400:	55                   	push   %ebp
80105401:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105403:	5d                   	pop    %ebp
  return wait();
80105404:	e9 27 ea ff ff       	jmp    80103e30 <wait>
80105409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105410 <sys_kill>:

int
sys_kill(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105416:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105419:	89 44 24 04          	mov    %eax,0x4(%esp)
8010541d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105424:	e8 37 f3 ff ff       	call   80104760 <argint>
80105429:	85 c0                	test   %eax,%eax
8010542b:	78 13                	js     80105440 <sys_kill+0x30>
    return -1;
  return kill(pid);
8010542d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105430:	89 04 24             	mov    %eax,(%esp)
80105433:	e8 58 eb ff ff       	call   80103f90 <kill>
}
80105438:	c9                   	leave  
80105439:	c3                   	ret    
8010543a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105440:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105445:	c9                   	leave  
80105446:	c3                   	ret    
80105447:	89 f6                	mov    %esi,%esi
80105449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105450 <sys_getpid>:

int
sys_getpid(void)
{
80105450:	55                   	push   %ebp
80105451:	89 e5                	mov    %esp,%ebp
80105453:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105456:	e8 85 e2 ff ff       	call   801036e0 <myproc>
8010545b:	8b 40 10             	mov    0x10(%eax),%eax
}
8010545e:	c9                   	leave  
8010545f:	c3                   	ret    

80105460 <sys_sbrk>:

int
sys_sbrk(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	53                   	push   %ebx
80105464:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105467:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010546a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010546e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105475:	e8 e6 f2 ff ff       	call   80104760 <argint>
8010547a:	85 c0                	test   %eax,%eax
8010547c:	78 22                	js     801054a0 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
8010547e:	e8 5d e2 ff ff       	call   801036e0 <myproc>
  if(growproc(n) < 0)
80105483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  addr = myproc()->sz;
80105486:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105488:	89 14 24             	mov    %edx,(%esp)
8010548b:	e8 90 e3 ff ff       	call   80103820 <growproc>
80105490:	85 c0                	test   %eax,%eax
80105492:	78 0c                	js     801054a0 <sys_sbrk+0x40>
    return -1;
  return addr;
80105494:	89 d8                	mov    %ebx,%eax
}
80105496:	83 c4 24             	add    $0x24,%esp
80105499:	5b                   	pop    %ebx
8010549a:	5d                   	pop    %ebp
8010549b:	c3                   	ret    
8010549c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801054a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801054a5:	eb ef                	jmp    80105496 <sys_sbrk+0x36>
801054a7:	89 f6                	mov    %esi,%esi
801054a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054b0 <sys_sleep>:

int
sys_sleep(void)
{
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	53                   	push   %ebx
801054b4:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
801054b7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801054ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801054be:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801054c5:	e8 96 f2 ff ff       	call   80104760 <argint>
801054ca:	85 c0                	test   %eax,%eax
801054cc:	78 7e                	js     8010554c <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
801054ce:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801054d5:	e8 d6 ee ff ff       	call   801043b0 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
801054da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
801054dd:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  while(ticks - ticks0 < n){
801054e3:	85 d2                	test   %edx,%edx
801054e5:	75 29                	jne    80105510 <sys_sleep+0x60>
801054e7:	eb 4f                	jmp    80105538 <sys_sleep+0x88>
801054e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801054f0:	c7 44 24 04 60 50 11 	movl   $0x80115060,0x4(%esp)
801054f7:	80 
801054f8:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
801054ff:	e8 7c e8 ff ff       	call   80103d80 <sleep>
  while(ticks - ticks0 < n){
80105504:	a1 a0 58 11 80       	mov    0x801158a0,%eax
80105509:	29 d8                	sub    %ebx,%eax
8010550b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010550e:	73 28                	jae    80105538 <sys_sleep+0x88>
    if(myproc()->killed){
80105510:	e8 cb e1 ff ff       	call   801036e0 <myproc>
80105515:	8b 40 24             	mov    0x24(%eax),%eax
80105518:	85 c0                	test   %eax,%eax
8010551a:	74 d4                	je     801054f0 <sys_sleep+0x40>
      release(&tickslock);
8010551c:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105523:	e8 f8 ee ff ff       	call   80104420 <release>
      return -1;
80105528:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
8010552d:	83 c4 24             	add    $0x24,%esp
80105530:	5b                   	pop    %ebx
80105531:	5d                   	pop    %ebp
80105532:	c3                   	ret    
80105533:	90                   	nop
80105534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&tickslock);
80105538:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
8010553f:	e8 dc ee ff ff       	call   80104420 <release>
}
80105544:	83 c4 24             	add    $0x24,%esp
  return 0;
80105547:	31 c0                	xor    %eax,%eax
}
80105549:	5b                   	pop    %ebx
8010554a:	5d                   	pop    %ebp
8010554b:	c3                   	ret    
    return -1;
8010554c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105551:	eb da                	jmp    8010552d <sys_sleep+0x7d>
80105553:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105559:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105560 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105560:	55                   	push   %ebp
80105561:	89 e5                	mov    %esp,%ebp
80105563:	53                   	push   %ebx
80105564:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
80105567:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
8010556e:	e8 3d ee ff ff       	call   801043b0 <acquire>
  xticks = ticks;
80105573:	8b 1d a0 58 11 80    	mov    0x801158a0,%ebx
  release(&tickslock);
80105579:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
80105580:	e8 9b ee ff ff       	call   80104420 <release>
  return xticks;
}
80105585:	83 c4 14             	add    $0x14,%esp
80105588:	89 d8                	mov    %ebx,%eax
8010558a:	5b                   	pop    %ebx
8010558b:	5d                   	pop    %ebp
8010558c:	c3                   	ret    
8010558d:	8d 76 00             	lea    0x0(%esi),%esi

80105590 <sys_set_prior>:

//!!
int
sys_set_prior(void) {
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 28             	sub    $0x28,%esp
    int prior_val;

    if ( argint(0, &prior_val) < 0 ) {
80105596:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105599:	89 44 24 04          	mov    %eax,0x4(%esp)
8010559d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801055a4:	e8 b7 f1 ff ff       	call   80104760 <argint>
801055a9:	85 c0                	test   %eax,%eax
801055ab:	78 13                	js     801055c0 <sys_set_prior+0x30>
        return -1;
    }

    return set_prior(prior_val);
801055ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801055b0:	89 04 24             	mov    %eax,(%esp)
801055b3:	e8 28 eb ff ff       	call   801040e0 <set_prior>
801055b8:	c9                   	leave  
801055b9:	c3                   	ret    
801055ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        return -1;
801055c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801055c5:	c9                   	leave  
801055c6:	c3                   	ret    

801055c7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801055c7:	1e                   	push   %ds
  pushl %es
801055c8:	06                   	push   %es
  pushl %fs
801055c9:	0f a0                	push   %fs
  pushl %gs
801055cb:	0f a8                	push   %gs
  pushal
801055cd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801055ce:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801055d2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801055d4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801055d6:	54                   	push   %esp
  call trap
801055d7:	e8 e4 00 00 00       	call   801056c0 <trap>
  addl $4, %esp
801055dc:	83 c4 04             	add    $0x4,%esp

801055df <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801055df:	61                   	popa   
  popl %gs
801055e0:	0f a9                	pop    %gs
  popl %fs
801055e2:	0f a1                	pop    %fs
  popl %es
801055e4:	07                   	pop    %es
  popl %ds
801055e5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801055e6:	83 c4 08             	add    $0x8,%esp
  iret
801055e9:	cf                   	iret   
801055ea:	66 90                	xchg   %ax,%ax
801055ec:	66 90                	xchg   %ax,%ax
801055ee:	66 90                	xchg   %ax,%ax

801055f0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801055f0:	31 c0                	xor    %eax,%eax
801055f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801055f8:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
801055ff:	b9 08 00 00 00       	mov    $0x8,%ecx
80105604:	66 89 0c c5 a2 50 11 	mov    %cx,-0x7feeaf5e(,%eax,8)
8010560b:	80 
8010560c:	c6 04 c5 a4 50 11 80 	movb   $0x0,-0x7feeaf5c(,%eax,8)
80105613:	00 
80105614:	c6 04 c5 a5 50 11 80 	movb   $0x8e,-0x7feeaf5b(,%eax,8)
8010561b:	8e 
8010561c:	66 89 14 c5 a0 50 11 	mov    %dx,-0x7feeaf60(,%eax,8)
80105623:	80 
80105624:	c1 ea 10             	shr    $0x10,%edx
80105627:	66 89 14 c5 a6 50 11 	mov    %dx,-0x7feeaf5a(,%eax,8)
8010562e:	80 
  for(i = 0; i < 256; i++)
8010562f:	83 c0 01             	add    $0x1,%eax
80105632:	3d 00 01 00 00       	cmp    $0x100,%eax
80105637:	75 bf                	jne    801055f8 <tvinit+0x8>
{
80105639:	55                   	push   %ebp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010563a:	ba 08 00 00 00       	mov    $0x8,%edx
{
8010563f:	89 e5                	mov    %esp,%ebp
80105641:	83 ec 18             	sub    $0x18,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105644:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
80105649:	c7 44 24 04 fd 75 10 	movl   $0x801075fd,0x4(%esp)
80105650:	80 
80105651:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105658:	66 89 15 a2 52 11 80 	mov    %dx,0x801152a2
8010565f:	66 a3 a0 52 11 80    	mov    %ax,0x801152a0
80105665:	c1 e8 10             	shr    $0x10,%eax
80105668:	c6 05 a4 52 11 80 00 	movb   $0x0,0x801152a4
8010566f:	c6 05 a5 52 11 80 ef 	movb   $0xef,0x801152a5
80105676:	66 a3 a6 52 11 80    	mov    %ax,0x801152a6
  initlock(&tickslock, "time");
8010567c:	e8 bf eb ff ff       	call   80104240 <initlock>
}
80105681:	c9                   	leave  
80105682:	c3                   	ret    
80105683:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105690 <idtinit>:

void
idtinit(void)
{
80105690:	55                   	push   %ebp
  pd[0] = size-1;
80105691:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105696:	89 e5                	mov    %esp,%ebp
80105698:	83 ec 10             	sub    $0x10,%esp
8010569b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010569f:	b8 a0 50 11 80       	mov    $0x801150a0,%eax
801056a4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
801056a8:	c1 e8 10             	shr    $0x10,%eax
801056ab:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
801056af:	8d 45 fa             	lea    -0x6(%ebp),%eax
801056b2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
801056b5:	c9                   	leave  
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801056c0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801056c0:	55                   	push   %ebp
801056c1:	89 e5                	mov    %esp,%ebp
801056c3:	57                   	push   %edi
801056c4:	56                   	push   %esi
801056c5:	53                   	push   %ebx
801056c6:	83 ec 3c             	sub    $0x3c,%esp
801056c9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
801056cc:	8b 43 30             	mov    0x30(%ebx),%eax
801056cf:	83 f8 40             	cmp    $0x40,%eax
801056d2:	0f 84 a0 01 00 00    	je     80105878 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801056d8:	83 e8 20             	sub    $0x20,%eax
801056db:	83 f8 1f             	cmp    $0x1f,%eax
801056de:	77 08                	ja     801056e8 <trap+0x28>
801056e0:	ff 24 85 a4 76 10 80 	jmp    *-0x7fef895c(,%eax,4)
801056e7:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801056e8:	e8 f3 df ff ff       	call   801036e0 <myproc>
801056ed:	85 c0                	test   %eax,%eax
801056ef:	90                   	nop
801056f0:	0f 84 fa 01 00 00    	je     801058f0 <trap+0x230>
801056f6:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
801056fa:	0f 84 f0 01 00 00    	je     801058f0 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105700:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105703:	8b 53 38             	mov    0x38(%ebx),%edx
80105706:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105709:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010570c:	e8 af df ff ff       	call   801036c0 <cpuid>
80105711:	8b 73 30             	mov    0x30(%ebx),%esi
80105714:	89 c7                	mov    %eax,%edi
80105716:	8b 43 34             	mov    0x34(%ebx),%eax
80105719:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010571c:	e8 bf df ff ff       	call   801036e0 <myproc>
80105721:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105724:	e8 b7 df ff ff       	call   801036e0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105729:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010572c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105730:	8b 75 e0             	mov    -0x20(%ebp),%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105733:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105736:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010573a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010573e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            myproc()->pid, myproc()->name, tf->trapno,
80105741:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105744:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            myproc()->pid, myproc()->name, tf->trapno,
80105748:	89 74 24 08          	mov    %esi,0x8(%esp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010574c:	89 54 24 10          	mov    %edx,0x10(%esp)
80105750:	8b 40 10             	mov    0x10(%eax),%eax
80105753:	c7 04 24 60 76 10 80 	movl   $0x80107660,(%esp)
8010575a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010575e:	e8 ed ae ff ff       	call   80100650 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105763:	e8 78 df ff ff       	call   801036e0 <myproc>
80105768:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
8010576f:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105770:	e8 6b df ff ff       	call   801036e0 <myproc>
80105775:	85 c0                	test   %eax,%eax
80105777:	74 0c                	je     80105785 <trap+0xc5>
80105779:	e8 62 df ff ff       	call   801036e0 <myproc>
8010577e:	8b 50 24             	mov    0x24(%eax),%edx
80105781:	85 d2                	test   %edx,%edx
80105783:	75 4b                	jne    801057d0 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105785:	e8 56 df ff ff       	call   801036e0 <myproc>
8010578a:	85 c0                	test   %eax,%eax
8010578c:	74 0d                	je     8010579b <trap+0xdb>
8010578e:	66 90                	xchg   %ax,%ax
80105790:	e8 4b df ff ff       	call   801036e0 <myproc>
80105795:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105799:	74 4d                	je     801057e8 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010579b:	e8 40 df ff ff       	call   801036e0 <myproc>
801057a0:	85 c0                	test   %eax,%eax
801057a2:	74 1d                	je     801057c1 <trap+0x101>
801057a4:	e8 37 df ff ff       	call   801036e0 <myproc>
801057a9:	8b 40 24             	mov    0x24(%eax),%eax
801057ac:	85 c0                	test   %eax,%eax
801057ae:	74 11                	je     801057c1 <trap+0x101>
801057b0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057b4:	83 e0 03             	and    $0x3,%eax
801057b7:	66 83 f8 03          	cmp    $0x3,%ax
801057bb:	0f 84 e8 00 00 00    	je     801058a9 <trap+0x1e9>
    exit();
}
801057c1:	83 c4 3c             	add    $0x3c,%esp
801057c4:	5b                   	pop    %ebx
801057c5:	5e                   	pop    %esi
801057c6:	5f                   	pop    %edi
801057c7:	5d                   	pop    %ebp
801057c8:	c3                   	ret    
801057c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801057d0:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801057d4:	83 e0 03             	and    $0x3,%eax
801057d7:	66 83 f8 03          	cmp    $0x3,%ax
801057db:	75 a8                	jne    80105785 <trap+0xc5>
    exit();
801057dd:	e8 ae e3 ff ff       	call   80103b90 <exit>
801057e2:	eb a1                	jmp    80105785 <trap+0xc5>
801057e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
801057e8:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801057f0:	75 a9                	jne    8010579b <trap+0xdb>
    yield();
801057f2:	e8 49 e5 ff ff       	call   80103d40 <yield>
801057f7:	eb a2                	jmp    8010579b <trap+0xdb>
801057f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105800:	e8 bb de ff ff       	call   801036c0 <cpuid>
80105805:	85 c0                	test   %eax,%eax
80105807:	0f 84 b3 00 00 00    	je     801058c0 <trap+0x200>
8010580d:	8d 76 00             	lea    0x0(%esi),%esi
    lapiceoi();
80105810:	e8 9b cf ff ff       	call   801027b0 <lapiceoi>
    break;
80105815:	e9 56 ff ff ff       	jmp    80105770 <trap+0xb0>
8010581a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    kbdintr();
80105820:	e8 db cd ff ff       	call   80102600 <kbdintr>
    lapiceoi();
80105825:	e8 86 cf ff ff       	call   801027b0 <lapiceoi>
    break;
8010582a:	e9 41 ff ff ff       	jmp    80105770 <trap+0xb0>
8010582f:	90                   	nop
    uartintr();
80105830:	e8 1b 02 00 00       	call   80105a50 <uartintr>
    lapiceoi();
80105835:	e8 76 cf ff ff       	call   801027b0 <lapiceoi>
    break;
8010583a:	e9 31 ff ff ff       	jmp    80105770 <trap+0xb0>
8010583f:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105840:	8b 7b 38             	mov    0x38(%ebx),%edi
80105843:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105847:	e8 74 de ff ff       	call   801036c0 <cpuid>
8010584c:	c7 04 24 08 76 10 80 	movl   $0x80107608,(%esp)
80105853:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105857:	89 74 24 08          	mov    %esi,0x8(%esp)
8010585b:	89 44 24 04          	mov    %eax,0x4(%esp)
8010585f:	e8 ec ad ff ff       	call   80100650 <cprintf>
    lapiceoi();
80105864:	e8 47 cf ff ff       	call   801027b0 <lapiceoi>
    break;
80105869:	e9 02 ff ff ff       	jmp    80105770 <trap+0xb0>
8010586e:	66 90                	xchg   %ax,%ax
    ideintr();
80105870:	e8 3b c8 ff ff       	call   801020b0 <ideintr>
80105875:	eb 96                	jmp    8010580d <trap+0x14d>
80105877:	90                   	nop
80105878:	90                   	nop
80105879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105880:	e8 5b de ff ff       	call   801036e0 <myproc>
80105885:	8b 70 24             	mov    0x24(%eax),%esi
80105888:	85 f6                	test   %esi,%esi
8010588a:	75 2c                	jne    801058b8 <trap+0x1f8>
    myproc()->tf = tf;
8010588c:	e8 4f de ff ff       	call   801036e0 <myproc>
80105891:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105894:	e8 97 ef ff ff       	call   80104830 <syscall>
    if(myproc()->killed)
80105899:	e8 42 de ff ff       	call   801036e0 <myproc>
8010589e:	8b 48 24             	mov    0x24(%eax),%ecx
801058a1:	85 c9                	test   %ecx,%ecx
801058a3:	0f 84 18 ff ff ff    	je     801057c1 <trap+0x101>
}
801058a9:	83 c4 3c             	add    $0x3c,%esp
801058ac:	5b                   	pop    %ebx
801058ad:	5e                   	pop    %esi
801058ae:	5f                   	pop    %edi
801058af:	5d                   	pop    %ebp
      exit();
801058b0:	e9 db e2 ff ff       	jmp    80103b90 <exit>
801058b5:	8d 76 00             	lea    0x0(%esi),%esi
      exit();
801058b8:	e8 d3 e2 ff ff       	call   80103b90 <exit>
801058bd:	eb cd                	jmp    8010588c <trap+0x1cc>
801058bf:	90                   	nop
      acquire(&tickslock);
801058c0:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801058c7:	e8 e4 ea ff ff       	call   801043b0 <acquire>
      wakeup(&ticks);
801058cc:	c7 04 24 a0 58 11 80 	movl   $0x801158a0,(%esp)
      ticks++;
801058d3:	83 05 a0 58 11 80 01 	addl   $0x1,0x801158a0
      wakeup(&ticks);
801058da:	e8 41 e6 ff ff       	call   80103f20 <wakeup>
      release(&tickslock);
801058df:	c7 04 24 60 50 11 80 	movl   $0x80115060,(%esp)
801058e6:	e8 35 eb ff ff       	call   80104420 <release>
801058eb:	e9 1d ff ff ff       	jmp    8010580d <trap+0x14d>
801058f0:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801058f3:	8b 73 38             	mov    0x38(%ebx),%esi
801058f6:	e8 c5 dd ff ff       	call   801036c0 <cpuid>
801058fb:	89 7c 24 10          	mov    %edi,0x10(%esp)
801058ff:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105903:	89 44 24 08          	mov    %eax,0x8(%esp)
80105907:	8b 43 30             	mov    0x30(%ebx),%eax
8010590a:	c7 04 24 2c 76 10 80 	movl   $0x8010762c,(%esp)
80105911:	89 44 24 04          	mov    %eax,0x4(%esp)
80105915:	e8 36 ad ff ff       	call   80100650 <cprintf>
      panic("trap");
8010591a:	c7 04 24 02 76 10 80 	movl   $0x80107602,(%esp)
80105921:	e8 3a aa ff ff       	call   80100360 <panic>
80105926:	66 90                	xchg   %ax,%ax
80105928:	66 90                	xchg   %ax,%ax
8010592a:	66 90                	xchg   %ax,%ax
8010592c:	66 90                	xchg   %ax,%ax
8010592e:	66 90                	xchg   %ax,%ax

80105930 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105930:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
{
80105935:	55                   	push   %ebp
80105936:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105938:	85 c0                	test   %eax,%eax
8010593a:	74 14                	je     80105950 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010593c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105941:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105942:	a8 01                	test   $0x1,%al
80105944:	74 0a                	je     80105950 <uartgetc+0x20>
80105946:	b2 f8                	mov    $0xf8,%dl
80105948:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105949:	0f b6 c0             	movzbl %al,%eax
}
8010594c:	5d                   	pop    %ebp
8010594d:	c3                   	ret    
8010594e:	66 90                	xchg   %ax,%ax
    return -1;
80105950:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105955:	5d                   	pop    %ebp
80105956:	c3                   	ret    
80105957:	89 f6                	mov    %esi,%esi
80105959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105960 <uartputc>:
  if(!uart)
80105960:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105965:	85 c0                	test   %eax,%eax
80105967:	74 3f                	je     801059a8 <uartputc+0x48>
{
80105969:	55                   	push   %ebp
8010596a:	89 e5                	mov    %esp,%ebp
8010596c:	56                   	push   %esi
8010596d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105972:	53                   	push   %ebx
  if(!uart)
80105973:	bb 80 00 00 00       	mov    $0x80,%ebx
{
80105978:	83 ec 10             	sub    $0x10,%esp
8010597b:	eb 14                	jmp    80105991 <uartputc+0x31>
8010597d:	8d 76 00             	lea    0x0(%esi),%esi
    microdelay(10);
80105980:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105987:	e8 44 ce ff ff       	call   801027d0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010598c:	83 eb 01             	sub    $0x1,%ebx
8010598f:	74 07                	je     80105998 <uartputc+0x38>
80105991:	89 f2                	mov    %esi,%edx
80105993:	ec                   	in     (%dx),%al
80105994:	a8 20                	test   $0x20,%al
80105996:	74 e8                	je     80105980 <uartputc+0x20>
  outb(COM1+0, c);
80105998:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010599c:	ba f8 03 00 00       	mov    $0x3f8,%edx
801059a1:	ee                   	out    %al,(%dx)
}
801059a2:	83 c4 10             	add    $0x10,%esp
801059a5:	5b                   	pop    %ebx
801059a6:	5e                   	pop    %esi
801059a7:	5d                   	pop    %ebp
801059a8:	f3 c3                	repz ret 
801059aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801059b0 <uartinit>:
{
801059b0:	55                   	push   %ebp
801059b1:	31 c9                	xor    %ecx,%ecx
801059b3:	89 e5                	mov    %esp,%ebp
801059b5:	89 c8                	mov    %ecx,%eax
801059b7:	57                   	push   %edi
801059b8:	bf fa 03 00 00       	mov    $0x3fa,%edi
801059bd:	56                   	push   %esi
801059be:	89 fa                	mov    %edi,%edx
801059c0:	53                   	push   %ebx
801059c1:	83 ec 1c             	sub    $0x1c,%esp
801059c4:	ee                   	out    %al,(%dx)
801059c5:	be fb 03 00 00       	mov    $0x3fb,%esi
801059ca:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
801059cf:	89 f2                	mov    %esi,%edx
801059d1:	ee                   	out    %al,(%dx)
801059d2:	b8 0c 00 00 00       	mov    $0xc,%eax
801059d7:	b2 f8                	mov    $0xf8,%dl
801059d9:	ee                   	out    %al,(%dx)
801059da:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801059df:	89 c8                	mov    %ecx,%eax
801059e1:	89 da                	mov    %ebx,%edx
801059e3:	ee                   	out    %al,(%dx)
801059e4:	b8 03 00 00 00       	mov    $0x3,%eax
801059e9:	89 f2                	mov    %esi,%edx
801059eb:	ee                   	out    %al,(%dx)
801059ec:	b2 fc                	mov    $0xfc,%dl
801059ee:	89 c8                	mov    %ecx,%eax
801059f0:	ee                   	out    %al,(%dx)
801059f1:	b8 01 00 00 00       	mov    $0x1,%eax
801059f6:	89 da                	mov    %ebx,%edx
801059f8:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801059f9:	b2 fd                	mov    $0xfd,%dl
801059fb:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801059fc:	3c ff                	cmp    $0xff,%al
801059fe:	74 42                	je     80105a42 <uartinit+0x92>
  uart = 1;
80105a00:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105a07:	00 00 00 
80105a0a:	89 fa                	mov    %edi,%edx
80105a0c:	ec                   	in     (%dx),%al
80105a0d:	b2 f8                	mov    $0xf8,%dl
80105a0f:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
80105a10:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105a17:	00 
  for(p="xv6...\n"; *p; p++)
80105a18:	bb 24 77 10 80       	mov    $0x80107724,%ebx
  ioapicenable(IRQ_COM1, 0);
80105a1d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105a24:	e8 b7 c8 ff ff       	call   801022e0 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
80105a29:	b8 78 00 00 00       	mov    $0x78,%eax
80105a2e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105a30:	89 04 24             	mov    %eax,(%esp)
  for(p="xv6...\n"; *p; p++)
80105a33:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105a36:	e8 25 ff ff ff       	call   80105960 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105a3b:	0f be 03             	movsbl (%ebx),%eax
80105a3e:	84 c0                	test   %al,%al
80105a40:	75 ee                	jne    80105a30 <uartinit+0x80>
}
80105a42:	83 c4 1c             	add    $0x1c,%esp
80105a45:	5b                   	pop    %ebx
80105a46:	5e                   	pop    %esi
80105a47:	5f                   	pop    %edi
80105a48:	5d                   	pop    %ebp
80105a49:	c3                   	ret    
80105a4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105a50 <uartintr>:

void
uartintr(void)
{
80105a50:	55                   	push   %ebp
80105a51:	89 e5                	mov    %esp,%ebp
80105a53:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105a56:	c7 04 24 30 59 10 80 	movl   $0x80105930,(%esp)
80105a5d:	e8 4e ad ff ff       	call   801007b0 <consoleintr>
}
80105a62:	c9                   	leave  
80105a63:	c3                   	ret    

80105a64 <vector0>:
80105a64:	6a 00                	push   $0x0
80105a66:	6a 00                	push   $0x0
80105a68:	e9 5a fb ff ff       	jmp    801055c7 <alltraps>

80105a6d <vector1>:
80105a6d:	6a 00                	push   $0x0
80105a6f:	6a 01                	push   $0x1
80105a71:	e9 51 fb ff ff       	jmp    801055c7 <alltraps>

80105a76 <vector2>:
80105a76:	6a 00                	push   $0x0
80105a78:	6a 02                	push   $0x2
80105a7a:	e9 48 fb ff ff       	jmp    801055c7 <alltraps>

80105a7f <vector3>:
80105a7f:	6a 00                	push   $0x0
80105a81:	6a 03                	push   $0x3
80105a83:	e9 3f fb ff ff       	jmp    801055c7 <alltraps>

80105a88 <vector4>:
80105a88:	6a 00                	push   $0x0
80105a8a:	6a 04                	push   $0x4
80105a8c:	e9 36 fb ff ff       	jmp    801055c7 <alltraps>

80105a91 <vector5>:
80105a91:	6a 00                	push   $0x0
80105a93:	6a 05                	push   $0x5
80105a95:	e9 2d fb ff ff       	jmp    801055c7 <alltraps>

80105a9a <vector6>:
80105a9a:	6a 00                	push   $0x0
80105a9c:	6a 06                	push   $0x6
80105a9e:	e9 24 fb ff ff       	jmp    801055c7 <alltraps>

80105aa3 <vector7>:
80105aa3:	6a 00                	push   $0x0
80105aa5:	6a 07                	push   $0x7
80105aa7:	e9 1b fb ff ff       	jmp    801055c7 <alltraps>

80105aac <vector8>:
80105aac:	6a 08                	push   $0x8
80105aae:	e9 14 fb ff ff       	jmp    801055c7 <alltraps>

80105ab3 <vector9>:
80105ab3:	6a 00                	push   $0x0
80105ab5:	6a 09                	push   $0x9
80105ab7:	e9 0b fb ff ff       	jmp    801055c7 <alltraps>

80105abc <vector10>:
80105abc:	6a 0a                	push   $0xa
80105abe:	e9 04 fb ff ff       	jmp    801055c7 <alltraps>

80105ac3 <vector11>:
80105ac3:	6a 0b                	push   $0xb
80105ac5:	e9 fd fa ff ff       	jmp    801055c7 <alltraps>

80105aca <vector12>:
80105aca:	6a 0c                	push   $0xc
80105acc:	e9 f6 fa ff ff       	jmp    801055c7 <alltraps>

80105ad1 <vector13>:
80105ad1:	6a 0d                	push   $0xd
80105ad3:	e9 ef fa ff ff       	jmp    801055c7 <alltraps>

80105ad8 <vector14>:
80105ad8:	6a 0e                	push   $0xe
80105ada:	e9 e8 fa ff ff       	jmp    801055c7 <alltraps>

80105adf <vector15>:
80105adf:	6a 00                	push   $0x0
80105ae1:	6a 0f                	push   $0xf
80105ae3:	e9 df fa ff ff       	jmp    801055c7 <alltraps>

80105ae8 <vector16>:
80105ae8:	6a 00                	push   $0x0
80105aea:	6a 10                	push   $0x10
80105aec:	e9 d6 fa ff ff       	jmp    801055c7 <alltraps>

80105af1 <vector17>:
80105af1:	6a 11                	push   $0x11
80105af3:	e9 cf fa ff ff       	jmp    801055c7 <alltraps>

80105af8 <vector18>:
80105af8:	6a 00                	push   $0x0
80105afa:	6a 12                	push   $0x12
80105afc:	e9 c6 fa ff ff       	jmp    801055c7 <alltraps>

80105b01 <vector19>:
80105b01:	6a 00                	push   $0x0
80105b03:	6a 13                	push   $0x13
80105b05:	e9 bd fa ff ff       	jmp    801055c7 <alltraps>

80105b0a <vector20>:
80105b0a:	6a 00                	push   $0x0
80105b0c:	6a 14                	push   $0x14
80105b0e:	e9 b4 fa ff ff       	jmp    801055c7 <alltraps>

80105b13 <vector21>:
80105b13:	6a 00                	push   $0x0
80105b15:	6a 15                	push   $0x15
80105b17:	e9 ab fa ff ff       	jmp    801055c7 <alltraps>

80105b1c <vector22>:
80105b1c:	6a 00                	push   $0x0
80105b1e:	6a 16                	push   $0x16
80105b20:	e9 a2 fa ff ff       	jmp    801055c7 <alltraps>

80105b25 <vector23>:
80105b25:	6a 00                	push   $0x0
80105b27:	6a 17                	push   $0x17
80105b29:	e9 99 fa ff ff       	jmp    801055c7 <alltraps>

80105b2e <vector24>:
80105b2e:	6a 00                	push   $0x0
80105b30:	6a 18                	push   $0x18
80105b32:	e9 90 fa ff ff       	jmp    801055c7 <alltraps>

80105b37 <vector25>:
80105b37:	6a 00                	push   $0x0
80105b39:	6a 19                	push   $0x19
80105b3b:	e9 87 fa ff ff       	jmp    801055c7 <alltraps>

80105b40 <vector26>:
80105b40:	6a 00                	push   $0x0
80105b42:	6a 1a                	push   $0x1a
80105b44:	e9 7e fa ff ff       	jmp    801055c7 <alltraps>

80105b49 <vector27>:
80105b49:	6a 00                	push   $0x0
80105b4b:	6a 1b                	push   $0x1b
80105b4d:	e9 75 fa ff ff       	jmp    801055c7 <alltraps>

80105b52 <vector28>:
80105b52:	6a 00                	push   $0x0
80105b54:	6a 1c                	push   $0x1c
80105b56:	e9 6c fa ff ff       	jmp    801055c7 <alltraps>

80105b5b <vector29>:
80105b5b:	6a 00                	push   $0x0
80105b5d:	6a 1d                	push   $0x1d
80105b5f:	e9 63 fa ff ff       	jmp    801055c7 <alltraps>

80105b64 <vector30>:
80105b64:	6a 00                	push   $0x0
80105b66:	6a 1e                	push   $0x1e
80105b68:	e9 5a fa ff ff       	jmp    801055c7 <alltraps>

80105b6d <vector31>:
80105b6d:	6a 00                	push   $0x0
80105b6f:	6a 1f                	push   $0x1f
80105b71:	e9 51 fa ff ff       	jmp    801055c7 <alltraps>

80105b76 <vector32>:
80105b76:	6a 00                	push   $0x0
80105b78:	6a 20                	push   $0x20
80105b7a:	e9 48 fa ff ff       	jmp    801055c7 <alltraps>

80105b7f <vector33>:
80105b7f:	6a 00                	push   $0x0
80105b81:	6a 21                	push   $0x21
80105b83:	e9 3f fa ff ff       	jmp    801055c7 <alltraps>

80105b88 <vector34>:
80105b88:	6a 00                	push   $0x0
80105b8a:	6a 22                	push   $0x22
80105b8c:	e9 36 fa ff ff       	jmp    801055c7 <alltraps>

80105b91 <vector35>:
80105b91:	6a 00                	push   $0x0
80105b93:	6a 23                	push   $0x23
80105b95:	e9 2d fa ff ff       	jmp    801055c7 <alltraps>

80105b9a <vector36>:
80105b9a:	6a 00                	push   $0x0
80105b9c:	6a 24                	push   $0x24
80105b9e:	e9 24 fa ff ff       	jmp    801055c7 <alltraps>

80105ba3 <vector37>:
80105ba3:	6a 00                	push   $0x0
80105ba5:	6a 25                	push   $0x25
80105ba7:	e9 1b fa ff ff       	jmp    801055c7 <alltraps>

80105bac <vector38>:
80105bac:	6a 00                	push   $0x0
80105bae:	6a 26                	push   $0x26
80105bb0:	e9 12 fa ff ff       	jmp    801055c7 <alltraps>

80105bb5 <vector39>:
80105bb5:	6a 00                	push   $0x0
80105bb7:	6a 27                	push   $0x27
80105bb9:	e9 09 fa ff ff       	jmp    801055c7 <alltraps>

80105bbe <vector40>:
80105bbe:	6a 00                	push   $0x0
80105bc0:	6a 28                	push   $0x28
80105bc2:	e9 00 fa ff ff       	jmp    801055c7 <alltraps>

80105bc7 <vector41>:
80105bc7:	6a 00                	push   $0x0
80105bc9:	6a 29                	push   $0x29
80105bcb:	e9 f7 f9 ff ff       	jmp    801055c7 <alltraps>

80105bd0 <vector42>:
80105bd0:	6a 00                	push   $0x0
80105bd2:	6a 2a                	push   $0x2a
80105bd4:	e9 ee f9 ff ff       	jmp    801055c7 <alltraps>

80105bd9 <vector43>:
80105bd9:	6a 00                	push   $0x0
80105bdb:	6a 2b                	push   $0x2b
80105bdd:	e9 e5 f9 ff ff       	jmp    801055c7 <alltraps>

80105be2 <vector44>:
80105be2:	6a 00                	push   $0x0
80105be4:	6a 2c                	push   $0x2c
80105be6:	e9 dc f9 ff ff       	jmp    801055c7 <alltraps>

80105beb <vector45>:
80105beb:	6a 00                	push   $0x0
80105bed:	6a 2d                	push   $0x2d
80105bef:	e9 d3 f9 ff ff       	jmp    801055c7 <alltraps>

80105bf4 <vector46>:
80105bf4:	6a 00                	push   $0x0
80105bf6:	6a 2e                	push   $0x2e
80105bf8:	e9 ca f9 ff ff       	jmp    801055c7 <alltraps>

80105bfd <vector47>:
80105bfd:	6a 00                	push   $0x0
80105bff:	6a 2f                	push   $0x2f
80105c01:	e9 c1 f9 ff ff       	jmp    801055c7 <alltraps>

80105c06 <vector48>:
80105c06:	6a 00                	push   $0x0
80105c08:	6a 30                	push   $0x30
80105c0a:	e9 b8 f9 ff ff       	jmp    801055c7 <alltraps>

80105c0f <vector49>:
80105c0f:	6a 00                	push   $0x0
80105c11:	6a 31                	push   $0x31
80105c13:	e9 af f9 ff ff       	jmp    801055c7 <alltraps>

80105c18 <vector50>:
80105c18:	6a 00                	push   $0x0
80105c1a:	6a 32                	push   $0x32
80105c1c:	e9 a6 f9 ff ff       	jmp    801055c7 <alltraps>

80105c21 <vector51>:
80105c21:	6a 00                	push   $0x0
80105c23:	6a 33                	push   $0x33
80105c25:	e9 9d f9 ff ff       	jmp    801055c7 <alltraps>

80105c2a <vector52>:
80105c2a:	6a 00                	push   $0x0
80105c2c:	6a 34                	push   $0x34
80105c2e:	e9 94 f9 ff ff       	jmp    801055c7 <alltraps>

80105c33 <vector53>:
80105c33:	6a 00                	push   $0x0
80105c35:	6a 35                	push   $0x35
80105c37:	e9 8b f9 ff ff       	jmp    801055c7 <alltraps>

80105c3c <vector54>:
80105c3c:	6a 00                	push   $0x0
80105c3e:	6a 36                	push   $0x36
80105c40:	e9 82 f9 ff ff       	jmp    801055c7 <alltraps>

80105c45 <vector55>:
80105c45:	6a 00                	push   $0x0
80105c47:	6a 37                	push   $0x37
80105c49:	e9 79 f9 ff ff       	jmp    801055c7 <alltraps>

80105c4e <vector56>:
80105c4e:	6a 00                	push   $0x0
80105c50:	6a 38                	push   $0x38
80105c52:	e9 70 f9 ff ff       	jmp    801055c7 <alltraps>

80105c57 <vector57>:
80105c57:	6a 00                	push   $0x0
80105c59:	6a 39                	push   $0x39
80105c5b:	e9 67 f9 ff ff       	jmp    801055c7 <alltraps>

80105c60 <vector58>:
80105c60:	6a 00                	push   $0x0
80105c62:	6a 3a                	push   $0x3a
80105c64:	e9 5e f9 ff ff       	jmp    801055c7 <alltraps>

80105c69 <vector59>:
80105c69:	6a 00                	push   $0x0
80105c6b:	6a 3b                	push   $0x3b
80105c6d:	e9 55 f9 ff ff       	jmp    801055c7 <alltraps>

80105c72 <vector60>:
80105c72:	6a 00                	push   $0x0
80105c74:	6a 3c                	push   $0x3c
80105c76:	e9 4c f9 ff ff       	jmp    801055c7 <alltraps>

80105c7b <vector61>:
80105c7b:	6a 00                	push   $0x0
80105c7d:	6a 3d                	push   $0x3d
80105c7f:	e9 43 f9 ff ff       	jmp    801055c7 <alltraps>

80105c84 <vector62>:
80105c84:	6a 00                	push   $0x0
80105c86:	6a 3e                	push   $0x3e
80105c88:	e9 3a f9 ff ff       	jmp    801055c7 <alltraps>

80105c8d <vector63>:
80105c8d:	6a 00                	push   $0x0
80105c8f:	6a 3f                	push   $0x3f
80105c91:	e9 31 f9 ff ff       	jmp    801055c7 <alltraps>

80105c96 <vector64>:
80105c96:	6a 00                	push   $0x0
80105c98:	6a 40                	push   $0x40
80105c9a:	e9 28 f9 ff ff       	jmp    801055c7 <alltraps>

80105c9f <vector65>:
80105c9f:	6a 00                	push   $0x0
80105ca1:	6a 41                	push   $0x41
80105ca3:	e9 1f f9 ff ff       	jmp    801055c7 <alltraps>

80105ca8 <vector66>:
80105ca8:	6a 00                	push   $0x0
80105caa:	6a 42                	push   $0x42
80105cac:	e9 16 f9 ff ff       	jmp    801055c7 <alltraps>

80105cb1 <vector67>:
80105cb1:	6a 00                	push   $0x0
80105cb3:	6a 43                	push   $0x43
80105cb5:	e9 0d f9 ff ff       	jmp    801055c7 <alltraps>

80105cba <vector68>:
80105cba:	6a 00                	push   $0x0
80105cbc:	6a 44                	push   $0x44
80105cbe:	e9 04 f9 ff ff       	jmp    801055c7 <alltraps>

80105cc3 <vector69>:
80105cc3:	6a 00                	push   $0x0
80105cc5:	6a 45                	push   $0x45
80105cc7:	e9 fb f8 ff ff       	jmp    801055c7 <alltraps>

80105ccc <vector70>:
80105ccc:	6a 00                	push   $0x0
80105cce:	6a 46                	push   $0x46
80105cd0:	e9 f2 f8 ff ff       	jmp    801055c7 <alltraps>

80105cd5 <vector71>:
80105cd5:	6a 00                	push   $0x0
80105cd7:	6a 47                	push   $0x47
80105cd9:	e9 e9 f8 ff ff       	jmp    801055c7 <alltraps>

80105cde <vector72>:
80105cde:	6a 00                	push   $0x0
80105ce0:	6a 48                	push   $0x48
80105ce2:	e9 e0 f8 ff ff       	jmp    801055c7 <alltraps>

80105ce7 <vector73>:
80105ce7:	6a 00                	push   $0x0
80105ce9:	6a 49                	push   $0x49
80105ceb:	e9 d7 f8 ff ff       	jmp    801055c7 <alltraps>

80105cf0 <vector74>:
80105cf0:	6a 00                	push   $0x0
80105cf2:	6a 4a                	push   $0x4a
80105cf4:	e9 ce f8 ff ff       	jmp    801055c7 <alltraps>

80105cf9 <vector75>:
80105cf9:	6a 00                	push   $0x0
80105cfb:	6a 4b                	push   $0x4b
80105cfd:	e9 c5 f8 ff ff       	jmp    801055c7 <alltraps>

80105d02 <vector76>:
80105d02:	6a 00                	push   $0x0
80105d04:	6a 4c                	push   $0x4c
80105d06:	e9 bc f8 ff ff       	jmp    801055c7 <alltraps>

80105d0b <vector77>:
80105d0b:	6a 00                	push   $0x0
80105d0d:	6a 4d                	push   $0x4d
80105d0f:	e9 b3 f8 ff ff       	jmp    801055c7 <alltraps>

80105d14 <vector78>:
80105d14:	6a 00                	push   $0x0
80105d16:	6a 4e                	push   $0x4e
80105d18:	e9 aa f8 ff ff       	jmp    801055c7 <alltraps>

80105d1d <vector79>:
80105d1d:	6a 00                	push   $0x0
80105d1f:	6a 4f                	push   $0x4f
80105d21:	e9 a1 f8 ff ff       	jmp    801055c7 <alltraps>

80105d26 <vector80>:
80105d26:	6a 00                	push   $0x0
80105d28:	6a 50                	push   $0x50
80105d2a:	e9 98 f8 ff ff       	jmp    801055c7 <alltraps>

80105d2f <vector81>:
80105d2f:	6a 00                	push   $0x0
80105d31:	6a 51                	push   $0x51
80105d33:	e9 8f f8 ff ff       	jmp    801055c7 <alltraps>

80105d38 <vector82>:
80105d38:	6a 00                	push   $0x0
80105d3a:	6a 52                	push   $0x52
80105d3c:	e9 86 f8 ff ff       	jmp    801055c7 <alltraps>

80105d41 <vector83>:
80105d41:	6a 00                	push   $0x0
80105d43:	6a 53                	push   $0x53
80105d45:	e9 7d f8 ff ff       	jmp    801055c7 <alltraps>

80105d4a <vector84>:
80105d4a:	6a 00                	push   $0x0
80105d4c:	6a 54                	push   $0x54
80105d4e:	e9 74 f8 ff ff       	jmp    801055c7 <alltraps>

80105d53 <vector85>:
80105d53:	6a 00                	push   $0x0
80105d55:	6a 55                	push   $0x55
80105d57:	e9 6b f8 ff ff       	jmp    801055c7 <alltraps>

80105d5c <vector86>:
80105d5c:	6a 00                	push   $0x0
80105d5e:	6a 56                	push   $0x56
80105d60:	e9 62 f8 ff ff       	jmp    801055c7 <alltraps>

80105d65 <vector87>:
80105d65:	6a 00                	push   $0x0
80105d67:	6a 57                	push   $0x57
80105d69:	e9 59 f8 ff ff       	jmp    801055c7 <alltraps>

80105d6e <vector88>:
80105d6e:	6a 00                	push   $0x0
80105d70:	6a 58                	push   $0x58
80105d72:	e9 50 f8 ff ff       	jmp    801055c7 <alltraps>

80105d77 <vector89>:
80105d77:	6a 00                	push   $0x0
80105d79:	6a 59                	push   $0x59
80105d7b:	e9 47 f8 ff ff       	jmp    801055c7 <alltraps>

80105d80 <vector90>:
80105d80:	6a 00                	push   $0x0
80105d82:	6a 5a                	push   $0x5a
80105d84:	e9 3e f8 ff ff       	jmp    801055c7 <alltraps>

80105d89 <vector91>:
80105d89:	6a 00                	push   $0x0
80105d8b:	6a 5b                	push   $0x5b
80105d8d:	e9 35 f8 ff ff       	jmp    801055c7 <alltraps>

80105d92 <vector92>:
80105d92:	6a 00                	push   $0x0
80105d94:	6a 5c                	push   $0x5c
80105d96:	e9 2c f8 ff ff       	jmp    801055c7 <alltraps>

80105d9b <vector93>:
80105d9b:	6a 00                	push   $0x0
80105d9d:	6a 5d                	push   $0x5d
80105d9f:	e9 23 f8 ff ff       	jmp    801055c7 <alltraps>

80105da4 <vector94>:
80105da4:	6a 00                	push   $0x0
80105da6:	6a 5e                	push   $0x5e
80105da8:	e9 1a f8 ff ff       	jmp    801055c7 <alltraps>

80105dad <vector95>:
80105dad:	6a 00                	push   $0x0
80105daf:	6a 5f                	push   $0x5f
80105db1:	e9 11 f8 ff ff       	jmp    801055c7 <alltraps>

80105db6 <vector96>:
80105db6:	6a 00                	push   $0x0
80105db8:	6a 60                	push   $0x60
80105dba:	e9 08 f8 ff ff       	jmp    801055c7 <alltraps>

80105dbf <vector97>:
80105dbf:	6a 00                	push   $0x0
80105dc1:	6a 61                	push   $0x61
80105dc3:	e9 ff f7 ff ff       	jmp    801055c7 <alltraps>

80105dc8 <vector98>:
80105dc8:	6a 00                	push   $0x0
80105dca:	6a 62                	push   $0x62
80105dcc:	e9 f6 f7 ff ff       	jmp    801055c7 <alltraps>

80105dd1 <vector99>:
80105dd1:	6a 00                	push   $0x0
80105dd3:	6a 63                	push   $0x63
80105dd5:	e9 ed f7 ff ff       	jmp    801055c7 <alltraps>

80105dda <vector100>:
80105dda:	6a 00                	push   $0x0
80105ddc:	6a 64                	push   $0x64
80105dde:	e9 e4 f7 ff ff       	jmp    801055c7 <alltraps>

80105de3 <vector101>:
80105de3:	6a 00                	push   $0x0
80105de5:	6a 65                	push   $0x65
80105de7:	e9 db f7 ff ff       	jmp    801055c7 <alltraps>

80105dec <vector102>:
80105dec:	6a 00                	push   $0x0
80105dee:	6a 66                	push   $0x66
80105df0:	e9 d2 f7 ff ff       	jmp    801055c7 <alltraps>

80105df5 <vector103>:
80105df5:	6a 00                	push   $0x0
80105df7:	6a 67                	push   $0x67
80105df9:	e9 c9 f7 ff ff       	jmp    801055c7 <alltraps>

80105dfe <vector104>:
80105dfe:	6a 00                	push   $0x0
80105e00:	6a 68                	push   $0x68
80105e02:	e9 c0 f7 ff ff       	jmp    801055c7 <alltraps>

80105e07 <vector105>:
80105e07:	6a 00                	push   $0x0
80105e09:	6a 69                	push   $0x69
80105e0b:	e9 b7 f7 ff ff       	jmp    801055c7 <alltraps>

80105e10 <vector106>:
80105e10:	6a 00                	push   $0x0
80105e12:	6a 6a                	push   $0x6a
80105e14:	e9 ae f7 ff ff       	jmp    801055c7 <alltraps>

80105e19 <vector107>:
80105e19:	6a 00                	push   $0x0
80105e1b:	6a 6b                	push   $0x6b
80105e1d:	e9 a5 f7 ff ff       	jmp    801055c7 <alltraps>

80105e22 <vector108>:
80105e22:	6a 00                	push   $0x0
80105e24:	6a 6c                	push   $0x6c
80105e26:	e9 9c f7 ff ff       	jmp    801055c7 <alltraps>

80105e2b <vector109>:
80105e2b:	6a 00                	push   $0x0
80105e2d:	6a 6d                	push   $0x6d
80105e2f:	e9 93 f7 ff ff       	jmp    801055c7 <alltraps>

80105e34 <vector110>:
80105e34:	6a 00                	push   $0x0
80105e36:	6a 6e                	push   $0x6e
80105e38:	e9 8a f7 ff ff       	jmp    801055c7 <alltraps>

80105e3d <vector111>:
80105e3d:	6a 00                	push   $0x0
80105e3f:	6a 6f                	push   $0x6f
80105e41:	e9 81 f7 ff ff       	jmp    801055c7 <alltraps>

80105e46 <vector112>:
80105e46:	6a 00                	push   $0x0
80105e48:	6a 70                	push   $0x70
80105e4a:	e9 78 f7 ff ff       	jmp    801055c7 <alltraps>

80105e4f <vector113>:
80105e4f:	6a 00                	push   $0x0
80105e51:	6a 71                	push   $0x71
80105e53:	e9 6f f7 ff ff       	jmp    801055c7 <alltraps>

80105e58 <vector114>:
80105e58:	6a 00                	push   $0x0
80105e5a:	6a 72                	push   $0x72
80105e5c:	e9 66 f7 ff ff       	jmp    801055c7 <alltraps>

80105e61 <vector115>:
80105e61:	6a 00                	push   $0x0
80105e63:	6a 73                	push   $0x73
80105e65:	e9 5d f7 ff ff       	jmp    801055c7 <alltraps>

80105e6a <vector116>:
80105e6a:	6a 00                	push   $0x0
80105e6c:	6a 74                	push   $0x74
80105e6e:	e9 54 f7 ff ff       	jmp    801055c7 <alltraps>

80105e73 <vector117>:
80105e73:	6a 00                	push   $0x0
80105e75:	6a 75                	push   $0x75
80105e77:	e9 4b f7 ff ff       	jmp    801055c7 <alltraps>

80105e7c <vector118>:
80105e7c:	6a 00                	push   $0x0
80105e7e:	6a 76                	push   $0x76
80105e80:	e9 42 f7 ff ff       	jmp    801055c7 <alltraps>

80105e85 <vector119>:
80105e85:	6a 00                	push   $0x0
80105e87:	6a 77                	push   $0x77
80105e89:	e9 39 f7 ff ff       	jmp    801055c7 <alltraps>

80105e8e <vector120>:
80105e8e:	6a 00                	push   $0x0
80105e90:	6a 78                	push   $0x78
80105e92:	e9 30 f7 ff ff       	jmp    801055c7 <alltraps>

80105e97 <vector121>:
80105e97:	6a 00                	push   $0x0
80105e99:	6a 79                	push   $0x79
80105e9b:	e9 27 f7 ff ff       	jmp    801055c7 <alltraps>

80105ea0 <vector122>:
80105ea0:	6a 00                	push   $0x0
80105ea2:	6a 7a                	push   $0x7a
80105ea4:	e9 1e f7 ff ff       	jmp    801055c7 <alltraps>

80105ea9 <vector123>:
80105ea9:	6a 00                	push   $0x0
80105eab:	6a 7b                	push   $0x7b
80105ead:	e9 15 f7 ff ff       	jmp    801055c7 <alltraps>

80105eb2 <vector124>:
80105eb2:	6a 00                	push   $0x0
80105eb4:	6a 7c                	push   $0x7c
80105eb6:	e9 0c f7 ff ff       	jmp    801055c7 <alltraps>

80105ebb <vector125>:
80105ebb:	6a 00                	push   $0x0
80105ebd:	6a 7d                	push   $0x7d
80105ebf:	e9 03 f7 ff ff       	jmp    801055c7 <alltraps>

80105ec4 <vector126>:
80105ec4:	6a 00                	push   $0x0
80105ec6:	6a 7e                	push   $0x7e
80105ec8:	e9 fa f6 ff ff       	jmp    801055c7 <alltraps>

80105ecd <vector127>:
80105ecd:	6a 00                	push   $0x0
80105ecf:	6a 7f                	push   $0x7f
80105ed1:	e9 f1 f6 ff ff       	jmp    801055c7 <alltraps>

80105ed6 <vector128>:
80105ed6:	6a 00                	push   $0x0
80105ed8:	68 80 00 00 00       	push   $0x80
80105edd:	e9 e5 f6 ff ff       	jmp    801055c7 <alltraps>

80105ee2 <vector129>:
80105ee2:	6a 00                	push   $0x0
80105ee4:	68 81 00 00 00       	push   $0x81
80105ee9:	e9 d9 f6 ff ff       	jmp    801055c7 <alltraps>

80105eee <vector130>:
80105eee:	6a 00                	push   $0x0
80105ef0:	68 82 00 00 00       	push   $0x82
80105ef5:	e9 cd f6 ff ff       	jmp    801055c7 <alltraps>

80105efa <vector131>:
80105efa:	6a 00                	push   $0x0
80105efc:	68 83 00 00 00       	push   $0x83
80105f01:	e9 c1 f6 ff ff       	jmp    801055c7 <alltraps>

80105f06 <vector132>:
80105f06:	6a 00                	push   $0x0
80105f08:	68 84 00 00 00       	push   $0x84
80105f0d:	e9 b5 f6 ff ff       	jmp    801055c7 <alltraps>

80105f12 <vector133>:
80105f12:	6a 00                	push   $0x0
80105f14:	68 85 00 00 00       	push   $0x85
80105f19:	e9 a9 f6 ff ff       	jmp    801055c7 <alltraps>

80105f1e <vector134>:
80105f1e:	6a 00                	push   $0x0
80105f20:	68 86 00 00 00       	push   $0x86
80105f25:	e9 9d f6 ff ff       	jmp    801055c7 <alltraps>

80105f2a <vector135>:
80105f2a:	6a 00                	push   $0x0
80105f2c:	68 87 00 00 00       	push   $0x87
80105f31:	e9 91 f6 ff ff       	jmp    801055c7 <alltraps>

80105f36 <vector136>:
80105f36:	6a 00                	push   $0x0
80105f38:	68 88 00 00 00       	push   $0x88
80105f3d:	e9 85 f6 ff ff       	jmp    801055c7 <alltraps>

80105f42 <vector137>:
80105f42:	6a 00                	push   $0x0
80105f44:	68 89 00 00 00       	push   $0x89
80105f49:	e9 79 f6 ff ff       	jmp    801055c7 <alltraps>

80105f4e <vector138>:
80105f4e:	6a 00                	push   $0x0
80105f50:	68 8a 00 00 00       	push   $0x8a
80105f55:	e9 6d f6 ff ff       	jmp    801055c7 <alltraps>

80105f5a <vector139>:
80105f5a:	6a 00                	push   $0x0
80105f5c:	68 8b 00 00 00       	push   $0x8b
80105f61:	e9 61 f6 ff ff       	jmp    801055c7 <alltraps>

80105f66 <vector140>:
80105f66:	6a 00                	push   $0x0
80105f68:	68 8c 00 00 00       	push   $0x8c
80105f6d:	e9 55 f6 ff ff       	jmp    801055c7 <alltraps>

80105f72 <vector141>:
80105f72:	6a 00                	push   $0x0
80105f74:	68 8d 00 00 00       	push   $0x8d
80105f79:	e9 49 f6 ff ff       	jmp    801055c7 <alltraps>

80105f7e <vector142>:
80105f7e:	6a 00                	push   $0x0
80105f80:	68 8e 00 00 00       	push   $0x8e
80105f85:	e9 3d f6 ff ff       	jmp    801055c7 <alltraps>

80105f8a <vector143>:
80105f8a:	6a 00                	push   $0x0
80105f8c:	68 8f 00 00 00       	push   $0x8f
80105f91:	e9 31 f6 ff ff       	jmp    801055c7 <alltraps>

80105f96 <vector144>:
80105f96:	6a 00                	push   $0x0
80105f98:	68 90 00 00 00       	push   $0x90
80105f9d:	e9 25 f6 ff ff       	jmp    801055c7 <alltraps>

80105fa2 <vector145>:
80105fa2:	6a 00                	push   $0x0
80105fa4:	68 91 00 00 00       	push   $0x91
80105fa9:	e9 19 f6 ff ff       	jmp    801055c7 <alltraps>

80105fae <vector146>:
80105fae:	6a 00                	push   $0x0
80105fb0:	68 92 00 00 00       	push   $0x92
80105fb5:	e9 0d f6 ff ff       	jmp    801055c7 <alltraps>

80105fba <vector147>:
80105fba:	6a 00                	push   $0x0
80105fbc:	68 93 00 00 00       	push   $0x93
80105fc1:	e9 01 f6 ff ff       	jmp    801055c7 <alltraps>

80105fc6 <vector148>:
80105fc6:	6a 00                	push   $0x0
80105fc8:	68 94 00 00 00       	push   $0x94
80105fcd:	e9 f5 f5 ff ff       	jmp    801055c7 <alltraps>

80105fd2 <vector149>:
80105fd2:	6a 00                	push   $0x0
80105fd4:	68 95 00 00 00       	push   $0x95
80105fd9:	e9 e9 f5 ff ff       	jmp    801055c7 <alltraps>

80105fde <vector150>:
80105fde:	6a 00                	push   $0x0
80105fe0:	68 96 00 00 00       	push   $0x96
80105fe5:	e9 dd f5 ff ff       	jmp    801055c7 <alltraps>

80105fea <vector151>:
80105fea:	6a 00                	push   $0x0
80105fec:	68 97 00 00 00       	push   $0x97
80105ff1:	e9 d1 f5 ff ff       	jmp    801055c7 <alltraps>

80105ff6 <vector152>:
80105ff6:	6a 00                	push   $0x0
80105ff8:	68 98 00 00 00       	push   $0x98
80105ffd:	e9 c5 f5 ff ff       	jmp    801055c7 <alltraps>

80106002 <vector153>:
80106002:	6a 00                	push   $0x0
80106004:	68 99 00 00 00       	push   $0x99
80106009:	e9 b9 f5 ff ff       	jmp    801055c7 <alltraps>

8010600e <vector154>:
8010600e:	6a 00                	push   $0x0
80106010:	68 9a 00 00 00       	push   $0x9a
80106015:	e9 ad f5 ff ff       	jmp    801055c7 <alltraps>

8010601a <vector155>:
8010601a:	6a 00                	push   $0x0
8010601c:	68 9b 00 00 00       	push   $0x9b
80106021:	e9 a1 f5 ff ff       	jmp    801055c7 <alltraps>

80106026 <vector156>:
80106026:	6a 00                	push   $0x0
80106028:	68 9c 00 00 00       	push   $0x9c
8010602d:	e9 95 f5 ff ff       	jmp    801055c7 <alltraps>

80106032 <vector157>:
80106032:	6a 00                	push   $0x0
80106034:	68 9d 00 00 00       	push   $0x9d
80106039:	e9 89 f5 ff ff       	jmp    801055c7 <alltraps>

8010603e <vector158>:
8010603e:	6a 00                	push   $0x0
80106040:	68 9e 00 00 00       	push   $0x9e
80106045:	e9 7d f5 ff ff       	jmp    801055c7 <alltraps>

8010604a <vector159>:
8010604a:	6a 00                	push   $0x0
8010604c:	68 9f 00 00 00       	push   $0x9f
80106051:	e9 71 f5 ff ff       	jmp    801055c7 <alltraps>

80106056 <vector160>:
80106056:	6a 00                	push   $0x0
80106058:	68 a0 00 00 00       	push   $0xa0
8010605d:	e9 65 f5 ff ff       	jmp    801055c7 <alltraps>

80106062 <vector161>:
80106062:	6a 00                	push   $0x0
80106064:	68 a1 00 00 00       	push   $0xa1
80106069:	e9 59 f5 ff ff       	jmp    801055c7 <alltraps>

8010606e <vector162>:
8010606e:	6a 00                	push   $0x0
80106070:	68 a2 00 00 00       	push   $0xa2
80106075:	e9 4d f5 ff ff       	jmp    801055c7 <alltraps>

8010607a <vector163>:
8010607a:	6a 00                	push   $0x0
8010607c:	68 a3 00 00 00       	push   $0xa3
80106081:	e9 41 f5 ff ff       	jmp    801055c7 <alltraps>

80106086 <vector164>:
80106086:	6a 00                	push   $0x0
80106088:	68 a4 00 00 00       	push   $0xa4
8010608d:	e9 35 f5 ff ff       	jmp    801055c7 <alltraps>

80106092 <vector165>:
80106092:	6a 00                	push   $0x0
80106094:	68 a5 00 00 00       	push   $0xa5
80106099:	e9 29 f5 ff ff       	jmp    801055c7 <alltraps>

8010609e <vector166>:
8010609e:	6a 00                	push   $0x0
801060a0:	68 a6 00 00 00       	push   $0xa6
801060a5:	e9 1d f5 ff ff       	jmp    801055c7 <alltraps>

801060aa <vector167>:
801060aa:	6a 00                	push   $0x0
801060ac:	68 a7 00 00 00       	push   $0xa7
801060b1:	e9 11 f5 ff ff       	jmp    801055c7 <alltraps>

801060b6 <vector168>:
801060b6:	6a 00                	push   $0x0
801060b8:	68 a8 00 00 00       	push   $0xa8
801060bd:	e9 05 f5 ff ff       	jmp    801055c7 <alltraps>

801060c2 <vector169>:
801060c2:	6a 00                	push   $0x0
801060c4:	68 a9 00 00 00       	push   $0xa9
801060c9:	e9 f9 f4 ff ff       	jmp    801055c7 <alltraps>

801060ce <vector170>:
801060ce:	6a 00                	push   $0x0
801060d0:	68 aa 00 00 00       	push   $0xaa
801060d5:	e9 ed f4 ff ff       	jmp    801055c7 <alltraps>

801060da <vector171>:
801060da:	6a 00                	push   $0x0
801060dc:	68 ab 00 00 00       	push   $0xab
801060e1:	e9 e1 f4 ff ff       	jmp    801055c7 <alltraps>

801060e6 <vector172>:
801060e6:	6a 00                	push   $0x0
801060e8:	68 ac 00 00 00       	push   $0xac
801060ed:	e9 d5 f4 ff ff       	jmp    801055c7 <alltraps>

801060f2 <vector173>:
801060f2:	6a 00                	push   $0x0
801060f4:	68 ad 00 00 00       	push   $0xad
801060f9:	e9 c9 f4 ff ff       	jmp    801055c7 <alltraps>

801060fe <vector174>:
801060fe:	6a 00                	push   $0x0
80106100:	68 ae 00 00 00       	push   $0xae
80106105:	e9 bd f4 ff ff       	jmp    801055c7 <alltraps>

8010610a <vector175>:
8010610a:	6a 00                	push   $0x0
8010610c:	68 af 00 00 00       	push   $0xaf
80106111:	e9 b1 f4 ff ff       	jmp    801055c7 <alltraps>

80106116 <vector176>:
80106116:	6a 00                	push   $0x0
80106118:	68 b0 00 00 00       	push   $0xb0
8010611d:	e9 a5 f4 ff ff       	jmp    801055c7 <alltraps>

80106122 <vector177>:
80106122:	6a 00                	push   $0x0
80106124:	68 b1 00 00 00       	push   $0xb1
80106129:	e9 99 f4 ff ff       	jmp    801055c7 <alltraps>

8010612e <vector178>:
8010612e:	6a 00                	push   $0x0
80106130:	68 b2 00 00 00       	push   $0xb2
80106135:	e9 8d f4 ff ff       	jmp    801055c7 <alltraps>

8010613a <vector179>:
8010613a:	6a 00                	push   $0x0
8010613c:	68 b3 00 00 00       	push   $0xb3
80106141:	e9 81 f4 ff ff       	jmp    801055c7 <alltraps>

80106146 <vector180>:
80106146:	6a 00                	push   $0x0
80106148:	68 b4 00 00 00       	push   $0xb4
8010614d:	e9 75 f4 ff ff       	jmp    801055c7 <alltraps>

80106152 <vector181>:
80106152:	6a 00                	push   $0x0
80106154:	68 b5 00 00 00       	push   $0xb5
80106159:	e9 69 f4 ff ff       	jmp    801055c7 <alltraps>

8010615e <vector182>:
8010615e:	6a 00                	push   $0x0
80106160:	68 b6 00 00 00       	push   $0xb6
80106165:	e9 5d f4 ff ff       	jmp    801055c7 <alltraps>

8010616a <vector183>:
8010616a:	6a 00                	push   $0x0
8010616c:	68 b7 00 00 00       	push   $0xb7
80106171:	e9 51 f4 ff ff       	jmp    801055c7 <alltraps>

80106176 <vector184>:
80106176:	6a 00                	push   $0x0
80106178:	68 b8 00 00 00       	push   $0xb8
8010617d:	e9 45 f4 ff ff       	jmp    801055c7 <alltraps>

80106182 <vector185>:
80106182:	6a 00                	push   $0x0
80106184:	68 b9 00 00 00       	push   $0xb9
80106189:	e9 39 f4 ff ff       	jmp    801055c7 <alltraps>

8010618e <vector186>:
8010618e:	6a 00                	push   $0x0
80106190:	68 ba 00 00 00       	push   $0xba
80106195:	e9 2d f4 ff ff       	jmp    801055c7 <alltraps>

8010619a <vector187>:
8010619a:	6a 00                	push   $0x0
8010619c:	68 bb 00 00 00       	push   $0xbb
801061a1:	e9 21 f4 ff ff       	jmp    801055c7 <alltraps>

801061a6 <vector188>:
801061a6:	6a 00                	push   $0x0
801061a8:	68 bc 00 00 00       	push   $0xbc
801061ad:	e9 15 f4 ff ff       	jmp    801055c7 <alltraps>

801061b2 <vector189>:
801061b2:	6a 00                	push   $0x0
801061b4:	68 bd 00 00 00       	push   $0xbd
801061b9:	e9 09 f4 ff ff       	jmp    801055c7 <alltraps>

801061be <vector190>:
801061be:	6a 00                	push   $0x0
801061c0:	68 be 00 00 00       	push   $0xbe
801061c5:	e9 fd f3 ff ff       	jmp    801055c7 <alltraps>

801061ca <vector191>:
801061ca:	6a 00                	push   $0x0
801061cc:	68 bf 00 00 00       	push   $0xbf
801061d1:	e9 f1 f3 ff ff       	jmp    801055c7 <alltraps>

801061d6 <vector192>:
801061d6:	6a 00                	push   $0x0
801061d8:	68 c0 00 00 00       	push   $0xc0
801061dd:	e9 e5 f3 ff ff       	jmp    801055c7 <alltraps>

801061e2 <vector193>:
801061e2:	6a 00                	push   $0x0
801061e4:	68 c1 00 00 00       	push   $0xc1
801061e9:	e9 d9 f3 ff ff       	jmp    801055c7 <alltraps>

801061ee <vector194>:
801061ee:	6a 00                	push   $0x0
801061f0:	68 c2 00 00 00       	push   $0xc2
801061f5:	e9 cd f3 ff ff       	jmp    801055c7 <alltraps>

801061fa <vector195>:
801061fa:	6a 00                	push   $0x0
801061fc:	68 c3 00 00 00       	push   $0xc3
80106201:	e9 c1 f3 ff ff       	jmp    801055c7 <alltraps>

80106206 <vector196>:
80106206:	6a 00                	push   $0x0
80106208:	68 c4 00 00 00       	push   $0xc4
8010620d:	e9 b5 f3 ff ff       	jmp    801055c7 <alltraps>

80106212 <vector197>:
80106212:	6a 00                	push   $0x0
80106214:	68 c5 00 00 00       	push   $0xc5
80106219:	e9 a9 f3 ff ff       	jmp    801055c7 <alltraps>

8010621e <vector198>:
8010621e:	6a 00                	push   $0x0
80106220:	68 c6 00 00 00       	push   $0xc6
80106225:	e9 9d f3 ff ff       	jmp    801055c7 <alltraps>

8010622a <vector199>:
8010622a:	6a 00                	push   $0x0
8010622c:	68 c7 00 00 00       	push   $0xc7
80106231:	e9 91 f3 ff ff       	jmp    801055c7 <alltraps>

80106236 <vector200>:
80106236:	6a 00                	push   $0x0
80106238:	68 c8 00 00 00       	push   $0xc8
8010623d:	e9 85 f3 ff ff       	jmp    801055c7 <alltraps>

80106242 <vector201>:
80106242:	6a 00                	push   $0x0
80106244:	68 c9 00 00 00       	push   $0xc9
80106249:	e9 79 f3 ff ff       	jmp    801055c7 <alltraps>

8010624e <vector202>:
8010624e:	6a 00                	push   $0x0
80106250:	68 ca 00 00 00       	push   $0xca
80106255:	e9 6d f3 ff ff       	jmp    801055c7 <alltraps>

8010625a <vector203>:
8010625a:	6a 00                	push   $0x0
8010625c:	68 cb 00 00 00       	push   $0xcb
80106261:	e9 61 f3 ff ff       	jmp    801055c7 <alltraps>

80106266 <vector204>:
80106266:	6a 00                	push   $0x0
80106268:	68 cc 00 00 00       	push   $0xcc
8010626d:	e9 55 f3 ff ff       	jmp    801055c7 <alltraps>

80106272 <vector205>:
80106272:	6a 00                	push   $0x0
80106274:	68 cd 00 00 00       	push   $0xcd
80106279:	e9 49 f3 ff ff       	jmp    801055c7 <alltraps>

8010627e <vector206>:
8010627e:	6a 00                	push   $0x0
80106280:	68 ce 00 00 00       	push   $0xce
80106285:	e9 3d f3 ff ff       	jmp    801055c7 <alltraps>

8010628a <vector207>:
8010628a:	6a 00                	push   $0x0
8010628c:	68 cf 00 00 00       	push   $0xcf
80106291:	e9 31 f3 ff ff       	jmp    801055c7 <alltraps>

80106296 <vector208>:
80106296:	6a 00                	push   $0x0
80106298:	68 d0 00 00 00       	push   $0xd0
8010629d:	e9 25 f3 ff ff       	jmp    801055c7 <alltraps>

801062a2 <vector209>:
801062a2:	6a 00                	push   $0x0
801062a4:	68 d1 00 00 00       	push   $0xd1
801062a9:	e9 19 f3 ff ff       	jmp    801055c7 <alltraps>

801062ae <vector210>:
801062ae:	6a 00                	push   $0x0
801062b0:	68 d2 00 00 00       	push   $0xd2
801062b5:	e9 0d f3 ff ff       	jmp    801055c7 <alltraps>

801062ba <vector211>:
801062ba:	6a 00                	push   $0x0
801062bc:	68 d3 00 00 00       	push   $0xd3
801062c1:	e9 01 f3 ff ff       	jmp    801055c7 <alltraps>

801062c6 <vector212>:
801062c6:	6a 00                	push   $0x0
801062c8:	68 d4 00 00 00       	push   $0xd4
801062cd:	e9 f5 f2 ff ff       	jmp    801055c7 <alltraps>

801062d2 <vector213>:
801062d2:	6a 00                	push   $0x0
801062d4:	68 d5 00 00 00       	push   $0xd5
801062d9:	e9 e9 f2 ff ff       	jmp    801055c7 <alltraps>

801062de <vector214>:
801062de:	6a 00                	push   $0x0
801062e0:	68 d6 00 00 00       	push   $0xd6
801062e5:	e9 dd f2 ff ff       	jmp    801055c7 <alltraps>

801062ea <vector215>:
801062ea:	6a 00                	push   $0x0
801062ec:	68 d7 00 00 00       	push   $0xd7
801062f1:	e9 d1 f2 ff ff       	jmp    801055c7 <alltraps>

801062f6 <vector216>:
801062f6:	6a 00                	push   $0x0
801062f8:	68 d8 00 00 00       	push   $0xd8
801062fd:	e9 c5 f2 ff ff       	jmp    801055c7 <alltraps>

80106302 <vector217>:
80106302:	6a 00                	push   $0x0
80106304:	68 d9 00 00 00       	push   $0xd9
80106309:	e9 b9 f2 ff ff       	jmp    801055c7 <alltraps>

8010630e <vector218>:
8010630e:	6a 00                	push   $0x0
80106310:	68 da 00 00 00       	push   $0xda
80106315:	e9 ad f2 ff ff       	jmp    801055c7 <alltraps>

8010631a <vector219>:
8010631a:	6a 00                	push   $0x0
8010631c:	68 db 00 00 00       	push   $0xdb
80106321:	e9 a1 f2 ff ff       	jmp    801055c7 <alltraps>

80106326 <vector220>:
80106326:	6a 00                	push   $0x0
80106328:	68 dc 00 00 00       	push   $0xdc
8010632d:	e9 95 f2 ff ff       	jmp    801055c7 <alltraps>

80106332 <vector221>:
80106332:	6a 00                	push   $0x0
80106334:	68 dd 00 00 00       	push   $0xdd
80106339:	e9 89 f2 ff ff       	jmp    801055c7 <alltraps>

8010633e <vector222>:
8010633e:	6a 00                	push   $0x0
80106340:	68 de 00 00 00       	push   $0xde
80106345:	e9 7d f2 ff ff       	jmp    801055c7 <alltraps>

8010634a <vector223>:
8010634a:	6a 00                	push   $0x0
8010634c:	68 df 00 00 00       	push   $0xdf
80106351:	e9 71 f2 ff ff       	jmp    801055c7 <alltraps>

80106356 <vector224>:
80106356:	6a 00                	push   $0x0
80106358:	68 e0 00 00 00       	push   $0xe0
8010635d:	e9 65 f2 ff ff       	jmp    801055c7 <alltraps>

80106362 <vector225>:
80106362:	6a 00                	push   $0x0
80106364:	68 e1 00 00 00       	push   $0xe1
80106369:	e9 59 f2 ff ff       	jmp    801055c7 <alltraps>

8010636e <vector226>:
8010636e:	6a 00                	push   $0x0
80106370:	68 e2 00 00 00       	push   $0xe2
80106375:	e9 4d f2 ff ff       	jmp    801055c7 <alltraps>

8010637a <vector227>:
8010637a:	6a 00                	push   $0x0
8010637c:	68 e3 00 00 00       	push   $0xe3
80106381:	e9 41 f2 ff ff       	jmp    801055c7 <alltraps>

80106386 <vector228>:
80106386:	6a 00                	push   $0x0
80106388:	68 e4 00 00 00       	push   $0xe4
8010638d:	e9 35 f2 ff ff       	jmp    801055c7 <alltraps>

80106392 <vector229>:
80106392:	6a 00                	push   $0x0
80106394:	68 e5 00 00 00       	push   $0xe5
80106399:	e9 29 f2 ff ff       	jmp    801055c7 <alltraps>

8010639e <vector230>:
8010639e:	6a 00                	push   $0x0
801063a0:	68 e6 00 00 00       	push   $0xe6
801063a5:	e9 1d f2 ff ff       	jmp    801055c7 <alltraps>

801063aa <vector231>:
801063aa:	6a 00                	push   $0x0
801063ac:	68 e7 00 00 00       	push   $0xe7
801063b1:	e9 11 f2 ff ff       	jmp    801055c7 <alltraps>

801063b6 <vector232>:
801063b6:	6a 00                	push   $0x0
801063b8:	68 e8 00 00 00       	push   $0xe8
801063bd:	e9 05 f2 ff ff       	jmp    801055c7 <alltraps>

801063c2 <vector233>:
801063c2:	6a 00                	push   $0x0
801063c4:	68 e9 00 00 00       	push   $0xe9
801063c9:	e9 f9 f1 ff ff       	jmp    801055c7 <alltraps>

801063ce <vector234>:
801063ce:	6a 00                	push   $0x0
801063d0:	68 ea 00 00 00       	push   $0xea
801063d5:	e9 ed f1 ff ff       	jmp    801055c7 <alltraps>

801063da <vector235>:
801063da:	6a 00                	push   $0x0
801063dc:	68 eb 00 00 00       	push   $0xeb
801063e1:	e9 e1 f1 ff ff       	jmp    801055c7 <alltraps>

801063e6 <vector236>:
801063e6:	6a 00                	push   $0x0
801063e8:	68 ec 00 00 00       	push   $0xec
801063ed:	e9 d5 f1 ff ff       	jmp    801055c7 <alltraps>

801063f2 <vector237>:
801063f2:	6a 00                	push   $0x0
801063f4:	68 ed 00 00 00       	push   $0xed
801063f9:	e9 c9 f1 ff ff       	jmp    801055c7 <alltraps>

801063fe <vector238>:
801063fe:	6a 00                	push   $0x0
80106400:	68 ee 00 00 00       	push   $0xee
80106405:	e9 bd f1 ff ff       	jmp    801055c7 <alltraps>

8010640a <vector239>:
8010640a:	6a 00                	push   $0x0
8010640c:	68 ef 00 00 00       	push   $0xef
80106411:	e9 b1 f1 ff ff       	jmp    801055c7 <alltraps>

80106416 <vector240>:
80106416:	6a 00                	push   $0x0
80106418:	68 f0 00 00 00       	push   $0xf0
8010641d:	e9 a5 f1 ff ff       	jmp    801055c7 <alltraps>

80106422 <vector241>:
80106422:	6a 00                	push   $0x0
80106424:	68 f1 00 00 00       	push   $0xf1
80106429:	e9 99 f1 ff ff       	jmp    801055c7 <alltraps>

8010642e <vector242>:
8010642e:	6a 00                	push   $0x0
80106430:	68 f2 00 00 00       	push   $0xf2
80106435:	e9 8d f1 ff ff       	jmp    801055c7 <alltraps>

8010643a <vector243>:
8010643a:	6a 00                	push   $0x0
8010643c:	68 f3 00 00 00       	push   $0xf3
80106441:	e9 81 f1 ff ff       	jmp    801055c7 <alltraps>

80106446 <vector244>:
80106446:	6a 00                	push   $0x0
80106448:	68 f4 00 00 00       	push   $0xf4
8010644d:	e9 75 f1 ff ff       	jmp    801055c7 <alltraps>

80106452 <vector245>:
80106452:	6a 00                	push   $0x0
80106454:	68 f5 00 00 00       	push   $0xf5
80106459:	e9 69 f1 ff ff       	jmp    801055c7 <alltraps>

8010645e <vector246>:
8010645e:	6a 00                	push   $0x0
80106460:	68 f6 00 00 00       	push   $0xf6
80106465:	e9 5d f1 ff ff       	jmp    801055c7 <alltraps>

8010646a <vector247>:
8010646a:	6a 00                	push   $0x0
8010646c:	68 f7 00 00 00       	push   $0xf7
80106471:	e9 51 f1 ff ff       	jmp    801055c7 <alltraps>

80106476 <vector248>:
80106476:	6a 00                	push   $0x0
80106478:	68 f8 00 00 00       	push   $0xf8
8010647d:	e9 45 f1 ff ff       	jmp    801055c7 <alltraps>

80106482 <vector249>:
80106482:	6a 00                	push   $0x0
80106484:	68 f9 00 00 00       	push   $0xf9
80106489:	e9 39 f1 ff ff       	jmp    801055c7 <alltraps>

8010648e <vector250>:
8010648e:	6a 00                	push   $0x0
80106490:	68 fa 00 00 00       	push   $0xfa
80106495:	e9 2d f1 ff ff       	jmp    801055c7 <alltraps>

8010649a <vector251>:
8010649a:	6a 00                	push   $0x0
8010649c:	68 fb 00 00 00       	push   $0xfb
801064a1:	e9 21 f1 ff ff       	jmp    801055c7 <alltraps>

801064a6 <vector252>:
801064a6:	6a 00                	push   $0x0
801064a8:	68 fc 00 00 00       	push   $0xfc
801064ad:	e9 15 f1 ff ff       	jmp    801055c7 <alltraps>

801064b2 <vector253>:
801064b2:	6a 00                	push   $0x0
801064b4:	68 fd 00 00 00       	push   $0xfd
801064b9:	e9 09 f1 ff ff       	jmp    801055c7 <alltraps>

801064be <vector254>:
801064be:	6a 00                	push   $0x0
801064c0:	68 fe 00 00 00       	push   $0xfe
801064c5:	e9 fd f0 ff ff       	jmp    801055c7 <alltraps>

801064ca <vector255>:
801064ca:	6a 00                	push   $0x0
801064cc:	68 ff 00 00 00       	push   $0xff
801064d1:	e9 f1 f0 ff ff       	jmp    801055c7 <alltraps>
801064d6:	66 90                	xchg   %ax,%ax
801064d8:	66 90                	xchg   %ax,%ax
801064da:	66 90                	xchg   %ax,%ax
801064dc:	66 90                	xchg   %ax,%ax
801064de:	66 90                	xchg   %ax,%ax

801064e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801064e0:	55                   	push   %ebp
801064e1:	89 e5                	mov    %esp,%ebp
801064e3:	57                   	push   %edi
801064e4:	56                   	push   %esi
801064e5:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801064e7:	c1 ea 16             	shr    $0x16,%edx
{
801064ea:	53                   	push   %ebx
  pde = &pgdir[PDX(va)];
801064eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
{
801064ee:	83 ec 1c             	sub    $0x1c,%esp
  if(*pde & PTE_P){
801064f1:	8b 1f                	mov    (%edi),%ebx
801064f3:	f6 c3 01             	test   $0x1,%bl
801064f6:	74 28                	je     80106520 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801064f8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
801064fe:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106504:	c1 ee 0a             	shr    $0xa,%esi
}
80106507:	83 c4 1c             	add    $0x1c,%esp
  return &pgtab[PTX(va)];
8010650a:	89 f2                	mov    %esi,%edx
8010650c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106512:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106515:	5b                   	pop    %ebx
80106516:	5e                   	pop    %esi
80106517:	5f                   	pop    %edi
80106518:	5d                   	pop    %ebp
80106519:	c3                   	ret    
8010651a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106520:	85 c9                	test   %ecx,%ecx
80106522:	74 34                	je     80106558 <walkpgdir+0x78>
80106524:	e8 a7 bf ff ff       	call   801024d0 <kalloc>
80106529:	85 c0                	test   %eax,%eax
8010652b:	89 c3                	mov    %eax,%ebx
8010652d:	74 29                	je     80106558 <walkpgdir+0x78>
    memset(pgtab, 0, PGSIZE);
8010652f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106536:	00 
80106537:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010653e:	00 
8010653f:	89 04 24             	mov    %eax,(%esp)
80106542:	e8 29 df ff ff       	call   80104470 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106547:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010654d:	83 c8 07             	or     $0x7,%eax
80106550:	89 07                	mov    %eax,(%edi)
80106552:	eb b0                	jmp    80106504 <walkpgdir+0x24>
80106554:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}
80106558:	83 c4 1c             	add    $0x1c,%esp
      return 0;
8010655b:	31 c0                	xor    %eax,%eax
}
8010655d:	5b                   	pop    %ebx
8010655e:	5e                   	pop    %esi
8010655f:	5f                   	pop    %edi
80106560:	5d                   	pop    %ebp
80106561:	c3                   	ret    
80106562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106570 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106570:	55                   	push   %ebp
80106571:	89 e5                	mov    %esp,%ebp
80106573:	57                   	push   %edi
80106574:	56                   	push   %esi
80106575:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106576:	89 d3                	mov    %edx,%ebx
{
80106578:	83 ec 1c             	sub    $0x1c,%esp
8010657b:	8b 7d 08             	mov    0x8(%ebp),%edi
  a = (char*)PGROUNDDOWN((uint)va);
8010657e:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106584:	89 45 e0             	mov    %eax,-0x20(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106587:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
8010658b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010658e:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106592:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
80106599:	29 df                	sub    %ebx,%edi
8010659b:	eb 18                	jmp    801065b5 <mappages+0x45>
8010659d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*pte & PTE_P)
801065a0:	f6 00 01             	testb  $0x1,(%eax)
801065a3:	75 3d                	jne    801065e2 <mappages+0x72>
    *pte = pa | perm | PTE_P;
801065a5:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
801065a8:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
    *pte = pa | perm | PTE_P;
801065ab:	89 30                	mov    %esi,(%eax)
    if(a == last)
801065ad:	74 29                	je     801065d8 <mappages+0x68>
      break;
    a += PGSIZE;
801065af:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801065b5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801065b8:	b9 01 00 00 00       	mov    $0x1,%ecx
801065bd:	89 da                	mov    %ebx,%edx
801065bf:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801065c2:	e8 19 ff ff ff       	call   801064e0 <walkpgdir>
801065c7:	85 c0                	test   %eax,%eax
801065c9:	75 d5                	jne    801065a0 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
801065cb:	83 c4 1c             	add    $0x1c,%esp
      return -1;
801065ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801065d3:	5b                   	pop    %ebx
801065d4:	5e                   	pop    %esi
801065d5:	5f                   	pop    %edi
801065d6:	5d                   	pop    %ebp
801065d7:	c3                   	ret    
801065d8:	83 c4 1c             	add    $0x1c,%esp
  return 0;
801065db:	31 c0                	xor    %eax,%eax
}
801065dd:	5b                   	pop    %ebx
801065de:	5e                   	pop    %esi
801065df:	5f                   	pop    %edi
801065e0:	5d                   	pop    %ebp
801065e1:	c3                   	ret    
      panic("remap");
801065e2:	c7 04 24 2c 77 10 80 	movl   $0x8010772c,(%esp)
801065e9:	e8 72 9d ff ff       	call   80100360 <panic>
801065ee:	66 90                	xchg   %ax,%ax

801065f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801065f0:	55                   	push   %ebp
801065f1:	89 e5                	mov    %esp,%ebp
801065f3:	57                   	push   %edi
801065f4:	89 c7                	mov    %eax,%edi
801065f6:	56                   	push   %esi
801065f7:	89 d6                	mov    %edx,%esi
801065f9:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801065fa:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106600:	83 ec 1c             	sub    $0x1c,%esp
  a = PGROUNDUP(newsz);
80106603:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106609:	39 d3                	cmp    %edx,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010660b:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
8010660e:	72 3b                	jb     8010664b <deallocuvm.part.0+0x5b>
80106610:	eb 5e                	jmp    80106670 <deallocuvm.part.0+0x80>
80106612:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106618:	8b 10                	mov    (%eax),%edx
8010661a:	f6 c2 01             	test   $0x1,%dl
8010661d:	74 22                	je     80106641 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010661f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106625:	74 54                	je     8010667b <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106627:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010662d:	89 14 24             	mov    %edx,(%esp)
80106630:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106633:	e8 e8 bc ff ff       	call   80102320 <kfree>
      *pte = 0;
80106638:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010663b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106647:	39 f3                	cmp    %esi,%ebx
80106649:	73 25                	jae    80106670 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010664b:	31 c9                	xor    %ecx,%ecx
8010664d:	89 da                	mov    %ebx,%edx
8010664f:	89 f8                	mov    %edi,%eax
80106651:	e8 8a fe ff ff       	call   801064e0 <walkpgdir>
    if(!pte)
80106656:	85 c0                	test   %eax,%eax
80106658:	75 be                	jne    80106618 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010665a:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106660:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106666:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010666c:	39 f3                	cmp    %esi,%ebx
8010666e:	72 db                	jb     8010664b <deallocuvm.part.0+0x5b>
    }
  }
  return newsz;
}
80106670:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106673:	83 c4 1c             	add    $0x1c,%esp
80106676:	5b                   	pop    %ebx
80106677:	5e                   	pop    %esi
80106678:	5f                   	pop    %edi
80106679:	5d                   	pop    %ebp
8010667a:	c3                   	ret    
        panic("kfree");
8010667b:	c7 04 24 66 70 10 80 	movl   $0x80107066,(%esp)
80106682:	e8 d9 9c ff ff       	call   80100360 <panic>
80106687:	89 f6                	mov    %esi,%esi
80106689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106690 <seginit>:
{
80106690:	55                   	push   %ebp
80106691:	89 e5                	mov    %esp,%ebp
80106693:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106696:	e8 25 d0 ff ff       	call   801036c0 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010669b:	31 c9                	xor    %ecx,%ecx
8010669d:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c = &cpus[cpuid()];
801066a2:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801066a8:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066ad:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066b1:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  lgdt(c->gdt, sizeof(c->gdt));
801066b6:	83 c0 70             	add    $0x70,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066b9:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066bd:	31 c9                	xor    %ecx,%ecx
801066bf:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066c3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066c8:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066cc:	31 c9                	xor    %ecx,%ecx
801066ce:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066d2:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066d7:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066db:	31 c9                	xor    %ecx,%ecx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801066dd:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
801066e1:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801066e5:	c6 40 15 92          	movb   $0x92,0x15(%eax)
801066e9:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801066ed:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
801066f1:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801066f5:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
801066f9:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
801066fd:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106701:	ba 2f 00 00 00       	mov    $0x2f,%edx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106706:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010670a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010670e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106712:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106716:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010671a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010671e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106722:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106726:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010672a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010672e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106732:	c1 e8 10             	shr    $0x10,%eax
80106735:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106739:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010673c:	0f 01 10             	lgdtl  (%eax)
}
8010673f:	c9                   	leave  
80106740:	c3                   	ret    
80106741:	eb 0d                	jmp    80106750 <switchkvm>
80106743:	90                   	nop
80106744:	90                   	nop
80106745:	90                   	nop
80106746:	90                   	nop
80106747:	90                   	nop
80106748:	90                   	nop
80106749:	90                   	nop
8010674a:	90                   	nop
8010674b:	90                   	nop
8010674c:	90                   	nop
8010674d:	90                   	nop
8010674e:	90                   	nop
8010674f:	90                   	nop

80106750 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106750:	a1 a4 58 11 80       	mov    0x801158a4,%eax
{
80106755:	55                   	push   %ebp
80106756:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106758:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010675d:	0f 22 d8             	mov    %eax,%cr3
}
80106760:	5d                   	pop    %ebp
80106761:	c3                   	ret    
80106762:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106770 <switchuvm>:
{
80106770:	55                   	push   %ebp
80106771:	89 e5                	mov    %esp,%ebp
80106773:	57                   	push   %edi
80106774:	56                   	push   %esi
80106775:	53                   	push   %ebx
80106776:	83 ec 1c             	sub    $0x1c,%esp
80106779:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010677c:	85 f6                	test   %esi,%esi
8010677e:	0f 84 cd 00 00 00    	je     80106851 <switchuvm+0xe1>
  if(p->kstack == 0)
80106784:	8b 46 08             	mov    0x8(%esi),%eax
80106787:	85 c0                	test   %eax,%eax
80106789:	0f 84 da 00 00 00    	je     80106869 <switchuvm+0xf9>
  if(p->pgdir == 0)
8010678f:	8b 7e 04             	mov    0x4(%esi),%edi
80106792:	85 ff                	test   %edi,%edi
80106794:	0f 84 c3 00 00 00    	je     8010685d <switchuvm+0xed>
  pushcli();
8010679a:	e8 21 db ff ff       	call   801042c0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010679f:	e8 9c ce ff ff       	call   80103640 <mycpu>
801067a4:	89 c3                	mov    %eax,%ebx
801067a6:	e8 95 ce ff ff       	call   80103640 <mycpu>
801067ab:	89 c7                	mov    %eax,%edi
801067ad:	e8 8e ce ff ff       	call   80103640 <mycpu>
801067b2:	83 c7 08             	add    $0x8,%edi
801067b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801067b8:	e8 83 ce ff ff       	call   80103640 <mycpu>
801067bd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801067c0:	ba 67 00 00 00       	mov    $0x67,%edx
801067c5:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
801067cc:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801067d3:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
801067da:	83 c1 08             	add    $0x8,%ecx
801067dd:	c1 e9 10             	shr    $0x10,%ecx
801067e0:	83 c0 08             	add    $0x8,%eax
801067e3:	c1 e8 18             	shr    $0x18,%eax
801067e6:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801067ec:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
801067f3:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801067f9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
801067fe:	e8 3d ce ff ff       	call   80103640 <mycpu>
80106803:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010680a:	e8 31 ce ff ff       	call   80103640 <mycpu>
8010680f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106814:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106818:	e8 23 ce ff ff       	call   80103640 <mycpu>
8010681d:	8b 56 08             	mov    0x8(%esi),%edx
80106820:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106826:	89 48 0c             	mov    %ecx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106829:	e8 12 ce ff ff       	call   80103640 <mycpu>
8010682e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106832:	b8 28 00 00 00       	mov    $0x28,%eax
80106837:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010683a:	8b 46 04             	mov    0x4(%esi),%eax
8010683d:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106842:	0f 22 d8             	mov    %eax,%cr3
}
80106845:	83 c4 1c             	add    $0x1c,%esp
80106848:	5b                   	pop    %ebx
80106849:	5e                   	pop    %esi
8010684a:	5f                   	pop    %edi
8010684b:	5d                   	pop    %ebp
  popcli();
8010684c:	e9 af da ff ff       	jmp    80104300 <popcli>
    panic("switchuvm: no process");
80106851:	c7 04 24 32 77 10 80 	movl   $0x80107732,(%esp)
80106858:	e8 03 9b ff ff       	call   80100360 <panic>
    panic("switchuvm: no pgdir");
8010685d:	c7 04 24 5d 77 10 80 	movl   $0x8010775d,(%esp)
80106864:	e8 f7 9a ff ff       	call   80100360 <panic>
    panic("switchuvm: no kstack");
80106869:	c7 04 24 48 77 10 80 	movl   $0x80107748,(%esp)
80106870:	e8 eb 9a ff ff       	call   80100360 <panic>
80106875:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106879:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106880 <inituvm>:
{
80106880:	55                   	push   %ebp
80106881:	89 e5                	mov    %esp,%ebp
80106883:	57                   	push   %edi
80106884:	56                   	push   %esi
80106885:	53                   	push   %ebx
80106886:	83 ec 1c             	sub    $0x1c,%esp
80106889:	8b 75 10             	mov    0x10(%ebp),%esi
8010688c:	8b 45 08             	mov    0x8(%ebp),%eax
8010688f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80106892:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80106898:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010689b:	77 54                	ja     801068f1 <inituvm+0x71>
  mem = kalloc();
8010689d:	e8 2e bc ff ff       	call   801024d0 <kalloc>
  memset(mem, 0, PGSIZE);
801068a2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801068a9:	00 
801068aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801068b1:	00 
  mem = kalloc();
801068b2:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801068b4:	89 04 24             	mov    %eax,(%esp)
801068b7:	e8 b4 db ff ff       	call   80104470 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801068bc:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801068c2:	b9 00 10 00 00       	mov    $0x1000,%ecx
801068c7:	89 04 24             	mov    %eax,(%esp)
801068ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801068cd:	31 d2                	xor    %edx,%edx
801068cf:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
801068d6:	00 
801068d7:	e8 94 fc ff ff       	call   80106570 <mappages>
  memmove(mem, init, sz);
801068dc:	89 75 10             	mov    %esi,0x10(%ebp)
801068df:	89 7d 0c             	mov    %edi,0xc(%ebp)
801068e2:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801068e5:	83 c4 1c             	add    $0x1c,%esp
801068e8:	5b                   	pop    %ebx
801068e9:	5e                   	pop    %esi
801068ea:	5f                   	pop    %edi
801068eb:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801068ec:	e9 1f dc ff ff       	jmp    80104510 <memmove>
    panic("inituvm: more than a page");
801068f1:	c7 04 24 71 77 10 80 	movl   $0x80107771,(%esp)
801068f8:	e8 63 9a ff ff       	call   80100360 <panic>
801068fd:	8d 76 00             	lea    0x0(%esi),%esi

80106900 <loaduvm>:
{
80106900:	55                   	push   %ebp
80106901:	89 e5                	mov    %esp,%ebp
80106903:	57                   	push   %edi
80106904:	56                   	push   %esi
80106905:	53                   	push   %ebx
80106906:	83 ec 1c             	sub    $0x1c,%esp
  if((uint) addr % PGSIZE != 0)
80106909:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106910:	0f 85 98 00 00 00    	jne    801069ae <loaduvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
80106916:	8b 75 18             	mov    0x18(%ebp),%esi
80106919:	31 db                	xor    %ebx,%ebx
8010691b:	85 f6                	test   %esi,%esi
8010691d:	75 1a                	jne    80106939 <loaduvm+0x39>
8010691f:	eb 77                	jmp    80106998 <loaduvm+0x98>
80106921:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106928:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010692e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106934:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106937:	76 5f                	jbe    80106998 <loaduvm+0x98>
80106939:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010693c:	31 c9                	xor    %ecx,%ecx
8010693e:	8b 45 08             	mov    0x8(%ebp),%eax
80106941:	01 da                	add    %ebx,%edx
80106943:	e8 98 fb ff ff       	call   801064e0 <walkpgdir>
80106948:	85 c0                	test   %eax,%eax
8010694a:	74 56                	je     801069a2 <loaduvm+0xa2>
    pa = PTE_ADDR(*pte);
8010694c:	8b 00                	mov    (%eax),%eax
      n = PGSIZE;
8010694e:	bf 00 10 00 00       	mov    $0x1000,%edi
80106953:	8b 4d 14             	mov    0x14(%ebp),%ecx
    pa = PTE_ADDR(*pte);
80106956:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      n = PGSIZE;
8010695b:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106961:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106964:	05 00 00 00 80       	add    $0x80000000,%eax
80106969:	89 44 24 04          	mov    %eax,0x4(%esp)
8010696d:	8b 45 10             	mov    0x10(%ebp),%eax
80106970:	01 d9                	add    %ebx,%ecx
80106972:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106976:	89 4c 24 08          	mov    %ecx,0x8(%esp)
8010697a:	89 04 24             	mov    %eax,(%esp)
8010697d:	e8 0e b0 ff ff       	call   80101990 <readi>
80106982:	39 f8                	cmp    %edi,%eax
80106984:	74 a2                	je     80106928 <loaduvm+0x28>
}
80106986:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106989:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010698e:	5b                   	pop    %ebx
8010698f:	5e                   	pop    %esi
80106990:	5f                   	pop    %edi
80106991:	5d                   	pop    %ebp
80106992:	c3                   	ret    
80106993:	90                   	nop
80106994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106998:	83 c4 1c             	add    $0x1c,%esp
  return 0;
8010699b:	31 c0                	xor    %eax,%eax
}
8010699d:	5b                   	pop    %ebx
8010699e:	5e                   	pop    %esi
8010699f:	5f                   	pop    %edi
801069a0:	5d                   	pop    %ebp
801069a1:	c3                   	ret    
      panic("loaduvm: address should exist");
801069a2:	c7 04 24 8b 77 10 80 	movl   $0x8010778b,(%esp)
801069a9:	e8 b2 99 ff ff       	call   80100360 <panic>
    panic("loaduvm: addr must be page aligned");
801069ae:	c7 04 24 2c 78 10 80 	movl   $0x8010782c,(%esp)
801069b5:	e8 a6 99 ff ff       	call   80100360 <panic>
801069ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801069c0 <allocuvm>:
{
801069c0:	55                   	push   %ebp
801069c1:	89 e5                	mov    %esp,%ebp
801069c3:	57                   	push   %edi
801069c4:	56                   	push   %esi
801069c5:	53                   	push   %ebx
801069c6:	83 ec 1c             	sub    $0x1c,%esp
801069c9:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801069cc:	85 ff                	test   %edi,%edi
801069ce:	0f 88 7e 00 00 00    	js     80106a52 <allocuvm+0x92>
  if(newsz < oldsz)
801069d4:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
801069d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
801069da:	72 78                	jb     80106a54 <allocuvm+0x94>
  a = PGROUNDUP(oldsz);
801069dc:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801069e2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
801069e8:	39 df                	cmp    %ebx,%edi
801069ea:	77 4a                	ja     80106a36 <allocuvm+0x76>
801069ec:	eb 72                	jmp    80106a60 <allocuvm+0xa0>
801069ee:	66 90                	xchg   %ax,%ax
    memset(mem, 0, PGSIZE);
801069f0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
801069f7:	00 
801069f8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801069ff:	00 
80106a00:	89 04 24             	mov    %eax,(%esp)
80106a03:	e8 68 da ff ff       	call   80104470 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106a08:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106a0e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106a13:	89 04 24             	mov    %eax,(%esp)
80106a16:	8b 45 08             	mov    0x8(%ebp),%eax
80106a19:	89 da                	mov    %ebx,%edx
80106a1b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106a22:	00 
80106a23:	e8 48 fb ff ff       	call   80106570 <mappages>
80106a28:	85 c0                	test   %eax,%eax
80106a2a:	78 44                	js     80106a70 <allocuvm+0xb0>
  for(; a < newsz; a += PGSIZE){
80106a2c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106a32:	39 df                	cmp    %ebx,%edi
80106a34:	76 2a                	jbe    80106a60 <allocuvm+0xa0>
    mem = kalloc();
80106a36:	e8 95 ba ff ff       	call   801024d0 <kalloc>
    if(mem == 0){
80106a3b:	85 c0                	test   %eax,%eax
    mem = kalloc();
80106a3d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106a3f:	75 af                	jne    801069f0 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106a41:	c7 04 24 a9 77 10 80 	movl   $0x801077a9,(%esp)
80106a48:	e8 03 9c ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106a4d:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a50:	77 48                	ja     80106a9a <allocuvm+0xda>
      return 0;
80106a52:	31 c0                	xor    %eax,%eax
}
80106a54:	83 c4 1c             	add    $0x1c,%esp
80106a57:	5b                   	pop    %ebx
80106a58:	5e                   	pop    %esi
80106a59:	5f                   	pop    %edi
80106a5a:	5d                   	pop    %ebp
80106a5b:	c3                   	ret    
80106a5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106a60:	83 c4 1c             	add    $0x1c,%esp
80106a63:	89 f8                	mov    %edi,%eax
80106a65:	5b                   	pop    %ebx
80106a66:	5e                   	pop    %esi
80106a67:	5f                   	pop    %edi
80106a68:	5d                   	pop    %ebp
80106a69:	c3                   	ret    
80106a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80106a70:	c7 04 24 c1 77 10 80 	movl   $0x801077c1,(%esp)
80106a77:	e8 d4 9b ff ff       	call   80100650 <cprintf>
  if(newsz >= oldsz)
80106a7c:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106a7f:	76 0d                	jbe    80106a8e <allocuvm+0xce>
80106a81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a84:	89 fa                	mov    %edi,%edx
80106a86:	8b 45 08             	mov    0x8(%ebp),%eax
80106a89:	e8 62 fb ff ff       	call   801065f0 <deallocuvm.part.0>
      kfree(mem);
80106a8e:	89 34 24             	mov    %esi,(%esp)
80106a91:	e8 8a b8 ff ff       	call   80102320 <kfree>
      return 0;
80106a96:	31 c0                	xor    %eax,%eax
80106a98:	eb ba                	jmp    80106a54 <allocuvm+0x94>
80106a9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106a9d:	89 fa                	mov    %edi,%edx
80106a9f:	8b 45 08             	mov    0x8(%ebp),%eax
80106aa2:	e8 49 fb ff ff       	call   801065f0 <deallocuvm.part.0>
      return 0;
80106aa7:	31 c0                	xor    %eax,%eax
80106aa9:	eb a9                	jmp    80106a54 <allocuvm+0x94>
80106aab:	90                   	nop
80106aac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ab0 <deallocuvm>:
{
80106ab0:	55                   	push   %ebp
80106ab1:	89 e5                	mov    %esp,%ebp
80106ab3:	8b 55 0c             	mov    0xc(%ebp),%edx
80106ab6:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
80106abc:	39 d1                	cmp    %edx,%ecx
80106abe:	73 08                	jae    80106ac8 <deallocuvm+0x18>
}
80106ac0:	5d                   	pop    %ebp
80106ac1:	e9 2a fb ff ff       	jmp    801065f0 <deallocuvm.part.0>
80106ac6:	66 90                	xchg   %ax,%ax
80106ac8:	89 d0                	mov    %edx,%eax
80106aca:	5d                   	pop    %ebp
80106acb:	c3                   	ret    
80106acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106ad0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106ad0:	55                   	push   %ebp
80106ad1:	89 e5                	mov    %esp,%ebp
80106ad3:	56                   	push   %esi
80106ad4:	53                   	push   %ebx
80106ad5:	83 ec 10             	sub    $0x10,%esp
80106ad8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106adb:	85 f6                	test   %esi,%esi
80106add:	74 59                	je     80106b38 <freevm+0x68>
80106adf:	31 c9                	xor    %ecx,%ecx
80106ae1:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106ae6:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106ae8:	31 db                	xor    %ebx,%ebx
80106aea:	e8 01 fb ff ff       	call   801065f0 <deallocuvm.part.0>
80106aef:	eb 12                	jmp    80106b03 <freevm+0x33>
80106af1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106af8:	83 c3 01             	add    $0x1,%ebx
80106afb:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b01:	74 27                	je     80106b2a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106b03:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106b06:	f6 c2 01             	test   $0x1,%dl
80106b09:	74 ed                	je     80106af8 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b0b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(i = 0; i < NPDENTRIES; i++){
80106b11:	83 c3 01             	add    $0x1,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106b14:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106b1a:	89 14 24             	mov    %edx,(%esp)
80106b1d:	e8 fe b7 ff ff       	call   80102320 <kfree>
  for(i = 0; i < NPDENTRIES; i++){
80106b22:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106b28:	75 d9                	jne    80106b03 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
80106b2a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106b2d:	83 c4 10             	add    $0x10,%esp
80106b30:	5b                   	pop    %ebx
80106b31:	5e                   	pop    %esi
80106b32:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80106b33:	e9 e8 b7 ff ff       	jmp    80102320 <kfree>
    panic("freevm: no pgdir");
80106b38:	c7 04 24 dd 77 10 80 	movl   $0x801077dd,(%esp)
80106b3f:	e8 1c 98 ff ff       	call   80100360 <panic>
80106b44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106b50 <setupkvm>:
{
80106b50:	55                   	push   %ebp
80106b51:	89 e5                	mov    %esp,%ebp
80106b53:	56                   	push   %esi
80106b54:	53                   	push   %ebx
80106b55:	83 ec 10             	sub    $0x10,%esp
  if((pgdir = (pde_t*)kalloc()) == 0)
80106b58:	e8 73 b9 ff ff       	call   801024d0 <kalloc>
80106b5d:	85 c0                	test   %eax,%eax
80106b5f:	89 c6                	mov    %eax,%esi
80106b61:	74 6d                	je     80106bd0 <setupkvm+0x80>
  memset(pgdir, 0, PGSIZE);
80106b63:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b6a:	00 
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b6b:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  memset(pgdir, 0, PGSIZE);
80106b70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b77:	00 
80106b78:	89 04 24             	mov    %eax,(%esp)
80106b7b:	e8 f0 d8 ff ff       	call   80104470 <memset>
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106b80:	8b 53 0c             	mov    0xc(%ebx),%edx
80106b83:	8b 43 04             	mov    0x4(%ebx),%eax
80106b86:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106b89:	89 54 24 04          	mov    %edx,0x4(%esp)
80106b8d:	8b 13                	mov    (%ebx),%edx
80106b8f:	89 04 24             	mov    %eax,(%esp)
80106b92:	29 c1                	sub    %eax,%ecx
80106b94:	89 f0                	mov    %esi,%eax
80106b96:	e8 d5 f9 ff ff       	call   80106570 <mappages>
80106b9b:	85 c0                	test   %eax,%eax
80106b9d:	78 19                	js     80106bb8 <setupkvm+0x68>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106b9f:	83 c3 10             	add    $0x10,%ebx
80106ba2:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106ba8:	72 d6                	jb     80106b80 <setupkvm+0x30>
80106baa:	89 f0                	mov    %esi,%eax
}
80106bac:	83 c4 10             	add    $0x10,%esp
80106baf:	5b                   	pop    %ebx
80106bb0:	5e                   	pop    %esi
80106bb1:	5d                   	pop    %ebp
80106bb2:	c3                   	ret    
80106bb3:	90                   	nop
80106bb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80106bb8:	89 34 24             	mov    %esi,(%esp)
80106bbb:	e8 10 ff ff ff       	call   80106ad0 <freevm>
}
80106bc0:	83 c4 10             	add    $0x10,%esp
      return 0;
80106bc3:	31 c0                	xor    %eax,%eax
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5d                   	pop    %ebp
80106bc8:	c3                   	ret    
80106bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106bd0:	31 c0                	xor    %eax,%eax
80106bd2:	eb d8                	jmp    80106bac <setupkvm+0x5c>
80106bd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106be0 <kvmalloc>:
{
80106be0:	55                   	push   %ebp
80106be1:	89 e5                	mov    %esp,%ebp
80106be3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106be6:	e8 65 ff ff ff       	call   80106b50 <setupkvm>
80106beb:	a3 a4 58 11 80       	mov    %eax,0x801158a4
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106bf0:	05 00 00 00 80       	add    $0x80000000,%eax
80106bf5:	0f 22 d8             	mov    %eax,%cr3
}
80106bf8:	c9                   	leave  
80106bf9:	c3                   	ret    
80106bfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c00 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106c00:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106c01:	31 c9                	xor    %ecx,%ecx
{
80106c03:	89 e5                	mov    %esp,%ebp
80106c05:	83 ec 18             	sub    $0x18,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106c08:	8b 55 0c             	mov    0xc(%ebp),%edx
80106c0b:	8b 45 08             	mov    0x8(%ebp),%eax
80106c0e:	e8 cd f8 ff ff       	call   801064e0 <walkpgdir>
  if(pte == 0)
80106c13:	85 c0                	test   %eax,%eax
80106c15:	74 05                	je     80106c1c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106c17:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106c1a:	c9                   	leave  
80106c1b:	c3                   	ret    
    panic("clearpteu");
80106c1c:	c7 04 24 ee 77 10 80 	movl   $0x801077ee,(%esp)
80106c23:	e8 38 97 ff ff       	call   80100360 <panic>
80106c28:	90                   	nop
80106c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106c30 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106c30:	55                   	push   %ebp
80106c31:	89 e5                	mov    %esp,%ebp
80106c33:	57                   	push   %edi
80106c34:	56                   	push   %esi
80106c35:	53                   	push   %ebx
80106c36:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106c39:	e8 12 ff ff ff       	call   80106b50 <setupkvm>
80106c3e:	85 c0                	test   %eax,%eax
80106c40:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106c43:	0f 84 b9 00 00 00    	je     80106d02 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80106c4c:	85 c0                	test   %eax,%eax
80106c4e:	0f 84 94 00 00 00    	je     80106ce8 <copyuvm+0xb8>
80106c54:	31 ff                	xor    %edi,%edi
80106c56:	eb 48                	jmp    80106ca0 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106c58:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106c5e:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c65:	00 
80106c66:	89 74 24 04          	mov    %esi,0x4(%esp)
80106c6a:	89 04 24             	mov    %eax,(%esp)
80106c6d:	e8 9e d8 ff ff       	call   80104510 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106c72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106c75:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c7a:	89 fa                	mov    %edi,%edx
80106c7c:	89 44 24 04          	mov    %eax,0x4(%esp)
80106c80:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106c86:	89 04 24             	mov    %eax,(%esp)
80106c89:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106c8c:	e8 df f8 ff ff       	call   80106570 <mappages>
80106c91:	85 c0                	test   %eax,%eax
80106c93:	78 63                	js     80106cf8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80106c95:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106c9b:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106c9e:	76 48                	jbe    80106ce8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ca0:	8b 45 08             	mov    0x8(%ebp),%eax
80106ca3:	31 c9                	xor    %ecx,%ecx
80106ca5:	89 fa                	mov    %edi,%edx
80106ca7:	e8 34 f8 ff ff       	call   801064e0 <walkpgdir>
80106cac:	85 c0                	test   %eax,%eax
80106cae:	74 62                	je     80106d12 <copyuvm+0xe2>
    if(!(*pte & PTE_P))
80106cb0:	8b 00                	mov    (%eax),%eax
80106cb2:	a8 01                	test   $0x1,%al
80106cb4:	74 50                	je     80106d06 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80106cb6:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106cb8:	25 ff 0f 00 00       	and    $0xfff,%eax
80106cbd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
80106cc0:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    if((mem = kalloc()) == 0)
80106cc6:	e8 05 b8 ff ff       	call   801024d0 <kalloc>
80106ccb:	85 c0                	test   %eax,%eax
80106ccd:	89 c3                	mov    %eax,%ebx
80106ccf:	75 87                	jne    80106c58 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106cd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106cd4:	89 04 24             	mov    %eax,(%esp)
80106cd7:	e8 f4 fd ff ff       	call   80106ad0 <freevm>
  return 0;
80106cdc:	31 c0                	xor    %eax,%eax
}
80106cde:	83 c4 2c             	add    $0x2c,%esp
80106ce1:	5b                   	pop    %ebx
80106ce2:	5e                   	pop    %esi
80106ce3:	5f                   	pop    %edi
80106ce4:	5d                   	pop    %ebp
80106ce5:	c3                   	ret    
80106ce6:	66 90                	xchg   %ax,%ax
80106ce8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106ceb:	83 c4 2c             	add    $0x2c,%esp
80106cee:	5b                   	pop    %ebx
80106cef:	5e                   	pop    %esi
80106cf0:	5f                   	pop    %edi
80106cf1:	5d                   	pop    %ebp
80106cf2:	c3                   	ret    
80106cf3:	90                   	nop
80106cf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80106cf8:	89 1c 24             	mov    %ebx,(%esp)
80106cfb:	e8 20 b6 ff ff       	call   80102320 <kfree>
      goto bad;
80106d00:	eb cf                	jmp    80106cd1 <copyuvm+0xa1>
    return 0;
80106d02:	31 c0                	xor    %eax,%eax
80106d04:	eb d8                	jmp    80106cde <copyuvm+0xae>
      panic("copyuvm: page not present");
80106d06:	c7 04 24 12 78 10 80 	movl   $0x80107812,(%esp)
80106d0d:	e8 4e 96 ff ff       	call   80100360 <panic>
      panic("copyuvm: pte should exist");
80106d12:	c7 04 24 f8 77 10 80 	movl   $0x801077f8,(%esp)
80106d19:	e8 42 96 ff ff       	call   80100360 <panic>
80106d1e:	66 90                	xchg   %ax,%ax

80106d20 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106d20:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106d21:	31 c9                	xor    %ecx,%ecx
{
80106d23:	89 e5                	mov    %esp,%ebp
80106d25:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
80106d28:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d2b:	8b 45 08             	mov    0x8(%ebp),%eax
80106d2e:	e8 ad f7 ff ff       	call   801064e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106d33:	8b 00                	mov    (%eax),%eax
80106d35:	89 c2                	mov    %eax,%edx
80106d37:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106d3a:	83 fa 05             	cmp    $0x5,%edx
80106d3d:	75 11                	jne    80106d50 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106d3f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d44:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106d49:	c9                   	leave  
80106d4a:	c3                   	ret    
80106d4b:	90                   	nop
80106d4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return 0;
80106d50:	31 c0                	xor    %eax,%eax
}
80106d52:	c9                   	leave  
80106d53:	c3                   	ret    
80106d54:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d5a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d60 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106d60:	55                   	push   %ebp
80106d61:	89 e5                	mov    %esp,%ebp
80106d63:	57                   	push   %edi
80106d64:	56                   	push   %esi
80106d65:	53                   	push   %ebx
80106d66:	83 ec 1c             	sub    $0x1c,%esp
80106d69:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106d6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106d72:	85 db                	test   %ebx,%ebx
80106d74:	75 3a                	jne    80106db0 <copyout+0x50>
80106d76:	eb 68                	jmp    80106de0 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106d78:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106d7b:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106d7d:	89 7c 24 04          	mov    %edi,0x4(%esp)
    n = PGSIZE - (va - va0);
80106d81:	29 ca                	sub    %ecx,%edx
80106d83:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106d89:	39 da                	cmp    %ebx,%edx
80106d8b:	0f 47 d3             	cmova  %ebx,%edx
    memmove(pa0 + (va - va0), buf, n);
80106d8e:	29 f1                	sub    %esi,%ecx
80106d90:	01 c8                	add    %ecx,%eax
80106d92:	89 54 24 08          	mov    %edx,0x8(%esp)
80106d96:	89 04 24             	mov    %eax,(%esp)
80106d99:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106d9c:	e8 6f d7 ff ff       	call   80104510 <memmove>
    len -= n;
    buf += n;
80106da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80106da4:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    buf += n;
80106daa:	01 d7                	add    %edx,%edi
  while(len > 0){
80106dac:	29 d3                	sub    %edx,%ebx
80106dae:	74 30                	je     80106de0 <copyout+0x80>
    pa0 = uva2ka(pgdir, (char*)va0);
80106db0:	8b 45 08             	mov    0x8(%ebp),%eax
    va0 = (uint)PGROUNDDOWN(va);
80106db3:	89 ce                	mov    %ecx,%esi
80106db5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106dbb:	89 74 24 04          	mov    %esi,0x4(%esp)
    va0 = (uint)PGROUNDDOWN(va);
80106dbf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80106dc2:	89 04 24             	mov    %eax,(%esp)
80106dc5:	e8 56 ff ff ff       	call   80106d20 <uva2ka>
    if(pa0 == 0)
80106dca:	85 c0                	test   %eax,%eax
80106dcc:	75 aa                	jne    80106d78 <copyout+0x18>
  }
  return 0;
}
80106dce:	83 c4 1c             	add    $0x1c,%esp
      return -1;
80106dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106dd6:	5b                   	pop    %ebx
80106dd7:	5e                   	pop    %esi
80106dd8:	5f                   	pop    %edi
80106dd9:	5d                   	pop    %ebp
80106dda:	c3                   	ret    
80106ddb:	90                   	nop
80106ddc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106de0:	83 c4 1c             	add    $0x1c,%esp
  return 0;
80106de3:	31 c0                	xor    %eax,%eax
}
80106de5:	5b                   	pop    %ebx
80106de6:	5e                   	pop    %esi
80106de7:	5f                   	pop    %edi
80106de8:	5d                   	pop    %ebp
80106de9:	c3                   	ret    
