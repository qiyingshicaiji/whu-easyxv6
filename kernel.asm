
kernel.elf:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	100002b7          	lui	t0,0x10000
    80000004:	05300313          	li	t1,83
    80000008:	00628023          	sb	t1,0(t0) # 10000000 <_entry-0x70000000>
    8000000c:	00011117          	auipc	sp,0x11
    80000010:	ff410113          	add	sp,sp,-12 # 80011000 <full>
    80000014:	05000313          	li	t1,80
    80000018:	00628023          	sb	t1,0(t0)
    8000001c:	00007297          	auipc	t0,0x7
    80000020:	ac428293          	add	t0,t0,-1340 # 80006ae0 <machinevec>
    80000024:	30529073          	csrw	mtvec,t0
    80000028:	08000293          	li	t0,128
    8000002c:	30429073          	csrw	mie,t0
    80000030:	2000c2b7          	lui	t0,0x2000c
    80000034:	ff82829b          	addw	t0,t0,-8 # 2000bff8 <_entry-0x5fff4008>
    80000038:	0002b303          	ld	t1,0(t0)
    8000003c:	000f43b7          	lui	t2,0xf4
    80000040:	2403839b          	addw	t2,t2,576 # f4240 <_entry-0x7ff0bdc0>
    80000044:	00730e33          	add	t3,t1,t2
    80000048:	02004eb7          	lui	t4,0x2004
    8000004c:	01ceb023          	sd	t3,0(t4) # 2004000 <_entry-0x7dffc000>
    80000050:	00800293          	li	t0,8
    80000054:	30029073          	csrw	mstatus,t0
    80000058:	00010297          	auipc	t0,0x10
    8000005c:	fa828293          	add	t0,t0,-88 # 80010000 <bss_start>
    80000060:	00428317          	auipc	t1,0x428
    80000064:	c9830313          	add	t1,t1,-872 # 80427cf8 <bss_end>

0000000080000068 <bss_clear>:
    80000068:	00628863          	beq	t0,t1,80000078 <bss_done>
    8000006c:	0002b023          	sd	zero,0(t0)
    80000070:	00828293          	add	t0,t0,8
    80000074:	ff5ff06f          	j	80000068 <bss_clear>

0000000080000078 <bss_done>:
    80000078:	194020ef          	jal	8000220c <main>

000000008000007c <loop>:
    8000007c:	0000006f          	j	8000007c <loop>

0000000080000080 <rr_worker>:
    80000080:	fc010113          	add	sp,sp,-64
    80000084:	02813823          	sd	s0,48(sp)
    80000088:	02913423          	sd	s1,40(sp)
    8000008c:	03213023          	sd	s2,32(sp)
    80000090:	01313c23          	sd	s3,24(sp)
    80000094:	01413823          	sd	s4,16(sp)
    80000098:	02113c23          	sd	ra,56(sp)
    8000009c:	00018437          	lui	s0,0x18
    800000a0:	481050ef          	jal	80005d20 <get_pid>
    800000a4:	00050913          	mv	s2,a0
    800000a8:	00000493          	li	s1,0
    800000ac:	00008a17          	auipc	s4,0x8
    800000b0:	f54a0a13          	add	s4,s4,-172 # 80008000 <rodata_start>
    800000b4:	69f40413          	add	s0,s0,1695 # 1869f <_entry-0x7ffe7961>
    800000b8:	00500993          	li	s3,5
    800000bc:	00048613          	mv	a2,s1
    800000c0:	00090593          	mv	a1,s2
    800000c4:	000a0513          	mv	a0,s4
    800000c8:	7a0020ef          	jal	80002868 <printf>
    800000cc:	00012623          	sw	zero,12(sp)
    800000d0:	00c12783          	lw	a5,12(sp)
    800000d4:	00f44c63          	blt	s0,a5,800000ec <rr_worker+0x6c>
    800000d8:	00c12783          	lw	a5,12(sp)
    800000dc:	0017879b          	addw	a5,a5,1
    800000e0:	00f12623          	sw	a5,12(sp)
    800000e4:	00c12783          	lw	a5,12(sp)
    800000e8:	fef458e3          	bge	s0,a5,800000d8 <rr_worker+0x58>
    800000ec:	0014849b          	addw	s1,s1,1
    800000f0:	0cc060ef          	jal	800061bc <yield>
    800000f4:	fd3494e3          	bne	s1,s3,800000bc <rr_worker+0x3c>
    800000f8:	00090593          	mv	a1,s2
    800000fc:	00008517          	auipc	a0,0x8
    80000100:	f2450513          	add	a0,a0,-220 # 80008020 <rodata_start+0x20>
    80000104:	764020ef          	jal	80002868 <printf>
    80000108:	03013403          	ld	s0,48(sp)
    8000010c:	03813083          	ld	ra,56(sp)
    80000110:	02813483          	ld	s1,40(sp)
    80000114:	02013903          	ld	s2,32(sp)
    80000118:	01813983          	ld	s3,24(sp)
    8000011c:	01013a03          	ld	s4,16(sp)
    80000120:	00000513          	li	a0,0
    80000124:	04010113          	add	sp,sp,64
    80000128:	3840606f          	j	800064ac <exit>

000000008000012c <consumer>:
    8000012c:	f9010113          	add	sp,sp,-112
    80000130:	06813023          	sd	s0,96(sp)
    80000134:	04913c23          	sd	s1,88(sp)
    80000138:	05213823          	sd	s2,80(sp)
    8000013c:	05313423          	sd	s3,72(sp)
    80000140:	05413023          	sd	s4,64(sp)
    80000144:	03513c23          	sd	s5,56(sp)
    80000148:	03613823          	sd	s6,48(sp)
    8000014c:	03713423          	sd	s7,40(sp)
    80000150:	03813023          	sd	s8,32(sp)
    80000154:	01913c23          	sd	s9,24(sp)
    80000158:	06113423          	sd	ra,104(sp)
    8000015c:	00018cb7          	lui	s9,0x18
    80000160:	3c1050ef          	jal	80005d20 <get_pid>
    80000164:	00050913          	mv	s2,a0
    80000168:	00300493          	li	s1,3
    8000016c:	00011a17          	auipc	s4,0x11
    80000170:	e94a0a13          	add	s4,s4,-364 # 80011000 <full>
    80000174:	00428417          	auipc	s0,0x428
    80000178:	b3440413          	add	s0,s0,-1228 # 80427ca8 <out>
    8000017c:	00008c17          	auipc	s8,0x8
    80000180:	ec4c0c13          	add	s8,s8,-316 # 80008040 <rodata_start+0x40>
    80000184:	00011997          	auipc	s3,0x11
    80000188:	e9c98993          	add	s3,s3,-356 # 80011020 <mutex>
    8000018c:	00008b97          	auipc	s7,0x8
    80000190:	ed4b8b93          	add	s7,s7,-300 # 80008060 <rodata_start+0x60>
    80000194:	00500b13          	li	s6,5
    80000198:	00011a97          	auipc	s5,0x11
    8000019c:	ec0a8a93          	add	s5,s5,-320 # 80011058 <empty>
    800001a0:	69fc8c93          	add	s9,s9,1695 # 1869f <_entry-0x7ffe7961>
    800001a4:	00090593          	mv	a1,s2
    800001a8:	000c0513          	mv	a0,s8
    800001ac:	6bc020ef          	jal	80002868 <printf>
    800001b0:	000a0513          	mv	a0,s4
    800001b4:	6d8060ef          	jal	8000688c <sem_wait>
    800001b8:	00098513          	mv	a0,s3
    800001bc:	6d0060ef          	jal	8000688c <sem_wait>
    800001c0:	00042683          	lw	a3,0(s0)
    800001c4:	00090593          	mv	a1,s2
    800001c8:	000b8513          	mv	a0,s7
    800001cc:	00269793          	sll	a5,a3,0x2
    800001d0:	00fa07b3          	add	a5,s4,a5
    800001d4:	0407a603          	lw	a2,64(a5)
    800001d8:	690020ef          	jal	80002868 <printf>
    800001dc:	00042783          	lw	a5,0(s0)
    800001e0:	00098513          	mv	a0,s3
    800001e4:	0017879b          	addw	a5,a5,1
    800001e8:	0367e7bb          	remw	a5,a5,s6
    800001ec:	00f42023          	sw	a5,0(s0)
    800001f0:	7b8060ef          	jal	800069a8 <sem_post>
    800001f4:	000a8513          	mv	a0,s5
    800001f8:	7b0060ef          	jal	800069a8 <sem_post>
    800001fc:	00012623          	sw	zero,12(sp)
    80000200:	00c12783          	lw	a5,12(sp)
    80000204:	00fccc63          	blt	s9,a5,8000021c <consumer+0xf0>
    80000208:	00c12783          	lw	a5,12(sp)
    8000020c:	0017879b          	addw	a5,a5,1
    80000210:	00f12623          	sw	a5,12(sp)
    80000214:	00c12783          	lw	a5,12(sp)
    80000218:	fefcd8e3          	bge	s9,a5,80000208 <consumer+0xdc>
    8000021c:	fff4849b          	addw	s1,s1,-1
    80000220:	79d050ef          	jal	800061bc <yield>
    80000224:	f80490e3          	bnez	s1,800001a4 <consumer+0x78>
    80000228:	00090593          	mv	a1,s2
    8000022c:	00008517          	auipc	a0,0x8
    80000230:	e6450513          	add	a0,a0,-412 # 80008090 <rodata_start+0x90>
    80000234:	634020ef          	jal	80002868 <printf>
    80000238:	06013403          	ld	s0,96(sp)
    8000023c:	06813083          	ld	ra,104(sp)
    80000240:	05813483          	ld	s1,88(sp)
    80000244:	05013903          	ld	s2,80(sp)
    80000248:	04813983          	ld	s3,72(sp)
    8000024c:	04013a03          	ld	s4,64(sp)
    80000250:	03813a83          	ld	s5,56(sp)
    80000254:	03013b03          	ld	s6,48(sp)
    80000258:	02813b83          	ld	s7,40(sp)
    8000025c:	02013c03          	ld	s8,32(sp)
    80000260:	01813c83          	ld	s9,24(sp)
    80000264:	00000513          	li	a0,0
    80000268:	07010113          	add	sp,sp,112
    8000026c:	2400606f          	j	800064ac <exit>

0000000080000270 <producer>:
    80000270:	f8010113          	add	sp,sp,-128
    80000274:	06813823          	sd	s0,112(sp)
    80000278:	06913423          	sd	s1,104(sp)
    8000027c:	07213023          	sd	s2,96(sp)
    80000280:	05313c23          	sd	s3,88(sp)
    80000284:	05413823          	sd	s4,80(sp)
    80000288:	05513423          	sd	s5,72(sp)
    8000028c:	05613023          	sd	s6,64(sp)
    80000290:	03713c23          	sd	s7,56(sp)
    80000294:	03813823          	sd	s8,48(sp)
    80000298:	03913423          	sd	s9,40(sp)
    8000029c:	03a13023          	sd	s10,32(sp)
    800002a0:	06400913          	li	s2,100
    800002a4:	06113c23          	sd	ra,120(sp)
    800002a8:	01b13c23          	sd	s11,24(sp)
    800002ac:	275050ef          	jal	80005d20 <get_pid>
    800002b0:	02a90d3b          	mulw	s10,s2,a0
    800002b4:	00018cb7          	lui	s9,0x18
    800002b8:	00050413          	mv	s0,a0
    800002bc:	00011a17          	auipc	s4,0x11
    800002c0:	d44a0a13          	add	s4,s4,-700 # 80011000 <full>
    800002c4:	00428497          	auipc	s1,0x428
    800002c8:	9e848493          	add	s1,s1,-1560 # 80427cac <in>
    800002cc:	00008c17          	auipc	s8,0x8
    800002d0:	df4c0c13          	add	s8,s8,-524 # 800080c0 <rodata_start+0xc0>
    800002d4:	00011b97          	auipc	s7,0x11
    800002d8:	d84b8b93          	add	s7,s7,-636 # 80011058 <empty>
    800002dc:	00011997          	auipc	s3,0x11
    800002e0:	d4498993          	add	s3,s3,-700 # 80011020 <mutex>
    800002e4:	00008b17          	auipc	s6,0x8
    800002e8:	e04b0b13          	add	s6,s6,-508 # 800080e8 <rodata_start+0xe8>
    800002ec:	00500a93          	li	s5,5
    800002f0:	69fc8c93          	add	s9,s9,1695 # 1869f <_entry-0x7ffe7961>
    800002f4:	003d091b          	addw	s2,s10,3
    800002f8:	000d0d9b          	sext.w	s11,s10
    800002fc:	000d8613          	mv	a2,s11
    80000300:	00040593          	mv	a1,s0
    80000304:	000c0513          	mv	a0,s8
    80000308:	560020ef          	jal	80002868 <printf>
    8000030c:	000b8513          	mv	a0,s7
    80000310:	57c060ef          	jal	8000688c <sem_wait>
    80000314:	00098513          	mv	a0,s3
    80000318:	574060ef          	jal	8000688c <sem_wait>
    8000031c:	0004a683          	lw	a3,0(s1)
    80000320:	000d8613          	mv	a2,s11
    80000324:	00040593          	mv	a1,s0
    80000328:	00269793          	sll	a5,a3,0x2
    8000032c:	00fa07b3          	add	a5,s4,a5
    80000330:	000b0513          	mv	a0,s6
    80000334:	05b7a023          	sw	s11,64(a5)
    80000338:	530020ef          	jal	80002868 <printf>
    8000033c:	0004a783          	lw	a5,0(s1)
    80000340:	00098513          	mv	a0,s3
    80000344:	0017879b          	addw	a5,a5,1
    80000348:	0357e7bb          	remw	a5,a5,s5
    8000034c:	00f4a023          	sw	a5,0(s1)
    80000350:	658060ef          	jal	800069a8 <sem_post>
    80000354:	000a0513          	mv	a0,s4
    80000358:	650060ef          	jal	800069a8 <sem_post>
    8000035c:	00012623          	sw	zero,12(sp)
    80000360:	00c12783          	lw	a5,12(sp)
    80000364:	00fccc63          	blt	s9,a5,8000037c <producer+0x10c>
    80000368:	00c12783          	lw	a5,12(sp)
    8000036c:	0017879b          	addw	a5,a5,1
    80000370:	00f12623          	sw	a5,12(sp)
    80000374:	00c12783          	lw	a5,12(sp)
    80000378:	fefcd8e3          	bge	s9,a5,80000368 <producer+0xf8>
    8000037c:	001d0d1b          	addw	s10,s10,1
    80000380:	63d050ef          	jal	800061bc <yield>
    80000384:	f72d1ae3          	bne	s10,s2,800002f8 <producer+0x88>
    80000388:	00040593          	mv	a1,s0
    8000038c:	00008517          	auipc	a0,0x8
    80000390:	d9450513          	add	a0,a0,-620 # 80008120 <rodata_start+0x120>
    80000394:	4d4020ef          	jal	80002868 <printf>
    80000398:	07013403          	ld	s0,112(sp)
    8000039c:	07813083          	ld	ra,120(sp)
    800003a0:	06813483          	ld	s1,104(sp)
    800003a4:	06013903          	ld	s2,96(sp)
    800003a8:	05813983          	ld	s3,88(sp)
    800003ac:	05013a03          	ld	s4,80(sp)
    800003b0:	04813a83          	ld	s5,72(sp)
    800003b4:	04013b03          	ld	s6,64(sp)
    800003b8:	03813b83          	ld	s7,56(sp)
    800003bc:	03013c03          	ld	s8,48(sp)
    800003c0:	02813c83          	ld	s9,40(sp)
    800003c4:	02013d03          	ld	s10,32(sp)
    800003c8:	01813d83          	ld	s11,24(sp)
    800003cc:	00000513          	li	a0,0
    800003d0:	08010113          	add	sp,sp,128
    800003d4:	0d80606f          	j	800064ac <exit>

00000000800003d8 <writer>:
    800003d8:	f9010113          	add	sp,sp,-112
    800003dc:	06813023          	sd	s0,96(sp)
    800003e0:	04913c23          	sd	s1,88(sp)
    800003e4:	05313423          	sd	s3,72(sp)
    800003e8:	05413023          	sd	s4,64(sp)
    800003ec:	03513c23          	sd	s5,56(sp)
    800003f0:	03613823          	sd	s6,48(sp)
    800003f4:	03713423          	sd	s7,40(sp)
    800003f8:	03813023          	sd	s8,32(sp)
    800003fc:	01913c23          	sd	s9,24(sp)
    80000400:	06113423          	sd	ra,104(sp)
    80000404:	05213823          	sd	s2,80(sp)
    80000408:	01a13823          	sd	s10,16(sp)
    8000040c:	06400493          	li	s1,100
    80000410:	111050ef          	jal	80005d20 <get_pid>
    80000414:	02a484bb          	mulw	s1,s1,a0
    80000418:	00018cb7          	lui	s9,0x18
    8000041c:	00050413          	mv	s0,a0
    80000420:	00000793          	li	a5,0
    80000424:	00428a17          	auipc	s4,0x428
    80000428:	880a0a13          	add	s4,s4,-1920 # 80427ca4 <shared_data>
    8000042c:	00008c17          	auipc	s8,0x8
    80000430:	d24c0c13          	add	s8,s8,-732 # 80008150 <rodata_start+0x150>
    80000434:	00011997          	auipc	s3,0x11
    80000438:	c4498993          	add	s3,s3,-956 # 80011078 <rw_mutex>
    8000043c:	00008b97          	auipc	s7,0x8
    80000440:	d3cb8b93          	add	s7,s7,-708 # 80008178 <rodata_start+0x178>
    80000444:	69fc8c93          	add	s9,s9,1695 # 1869f <_entry-0x7ffe7961>
    80000448:	00008b17          	auipc	s6,0x8
    8000044c:	d58b0b13          	add	s6,s6,-680 # 800081a0 <rodata_start+0x1a0>
    80000450:	00200a93          	li	s5,2
    80000454:	fff4849b          	addw	s1,s1,-1
    80000458:	00178913          	add	s2,a5,1
    8000045c:	00090613          	mv	a2,s2
    80000460:	00040593          	mv	a1,s0
    80000464:	000c0513          	mv	a0,s8
    80000468:	00178d1b          	addw	s10,a5,1
    8000046c:	3fc020ef          	jal	80002868 <printf>
    80000470:	00098513          	mv	a0,s3
    80000474:	418060ef          	jal	8000688c <sem_wait>
    80000478:	000a2603          	lw	a2,0(s4)
    8000047c:	01a486bb          	addw	a3,s1,s10
    80000480:	00040593          	mv	a1,s0
    80000484:	000b8513          	mv	a0,s7
    80000488:	00da2023          	sw	a3,0(s4)
    8000048c:	3dc020ef          	jal	80002868 <printf>
    80000490:	00012423          	sw	zero,8(sp)
    80000494:	00812783          	lw	a5,8(sp)
    80000498:	00fccc63          	blt	s9,a5,800004b0 <writer+0xd8>
    8000049c:	00812783          	lw	a5,8(sp)
    800004a0:	0017879b          	addw	a5,a5,1
    800004a4:	00f12423          	sw	a5,8(sp)
    800004a8:	00812783          	lw	a5,8(sp)
    800004ac:	fefcd8e3          	bge	s9,a5,8000049c <writer+0xc4>
    800004b0:	00098513          	mv	a0,s3
    800004b4:	4f4060ef          	jal	800069a8 <sem_post>
    800004b8:	00040593          	mv	a1,s0
    800004bc:	000b0513          	mv	a0,s6
    800004c0:	3a8020ef          	jal	80002868 <printf>
    800004c4:	00012623          	sw	zero,12(sp)
    800004c8:	00c12783          	lw	a5,12(sp)
    800004cc:	00fccc63          	blt	s9,a5,800004e4 <writer+0x10c>
    800004d0:	00c12783          	lw	a5,12(sp)
    800004d4:	0017879b          	addw	a5,a5,1
    800004d8:	00f12623          	sw	a5,12(sp)
    800004dc:	00c12783          	lw	a5,12(sp)
    800004e0:	fefcd8e3          	bge	s9,a5,800004d0 <writer+0xf8>
    800004e4:	4d9050ef          	jal	800061bc <yield>
    800004e8:	00100793          	li	a5,1
    800004ec:	f75916e3          	bne	s2,s5,80000458 <writer+0x80>
    800004f0:	00040593          	mv	a1,s0
    800004f4:	00008517          	auipc	a0,0x8
    800004f8:	ccc50513          	add	a0,a0,-820 # 800081c0 <rodata_start+0x1c0>
    800004fc:	36c020ef          	jal	80002868 <printf>
    80000500:	06013403          	ld	s0,96(sp)
    80000504:	06813083          	ld	ra,104(sp)
    80000508:	05813483          	ld	s1,88(sp)
    8000050c:	05013903          	ld	s2,80(sp)
    80000510:	04813983          	ld	s3,72(sp)
    80000514:	04013a03          	ld	s4,64(sp)
    80000518:	03813a83          	ld	s5,56(sp)
    8000051c:	03013b03          	ld	s6,48(sp)
    80000520:	02813b83          	ld	s7,40(sp)
    80000524:	02013c03          	ld	s8,32(sp)
    80000528:	01813c83          	ld	s9,24(sp)
    8000052c:	01013d03          	ld	s10,16(sp)
    80000530:	00000513          	li	a0,0
    80000534:	07010113          	add	sp,sp,112
    80000538:	7750506f          	j	800064ac <exit>

000000008000053c <reader>:
    8000053c:	f9010113          	add	sp,sp,-112
    80000540:	06813023          	sd	s0,96(sp)
    80000544:	04913c23          	sd	s1,88(sp)
    80000548:	05213823          	sd	s2,80(sp)
    8000054c:	05313423          	sd	s3,72(sp)
    80000550:	05413023          	sd	s4,64(sp)
    80000554:	03513c23          	sd	s5,56(sp)
    80000558:	03613823          	sd	s6,48(sp)
    8000055c:	03713423          	sd	s7,40(sp)
    80000560:	03813023          	sd	s8,32(sp)
    80000564:	01913c23          	sd	s9,24(sp)
    80000568:	01a13823          	sd	s10,16(sp)
    8000056c:	06113423          	sd	ra,104(sp)
    80000570:	0000cd37          	lui	s10,0xc
    80000574:	7ac050ef          	jal	80005d20 <get_pid>
    80000578:	00050493          	mv	s1,a0
    8000057c:	00000993          	li	s3,0
    80000580:	00427417          	auipc	s0,0x427
    80000584:	72040413          	add	s0,s0,1824 # 80427ca0 <read_count>
    80000588:	00427c97          	auipc	s9,0x427
    8000058c:	71cc8c93          	add	s9,s9,1820 # 80427ca4 <shared_data>
    80000590:	00008c17          	auipc	s8,0x8
    80000594:	c60c0c13          	add	s8,s8,-928 # 800081f0 <rodata_start+0x1f0>
    80000598:	00011917          	auipc	s2,0x11
    8000059c:	b0090913          	add	s2,s2,-1280 # 80011098 <read_mutex>
    800005a0:	00100b93          	li	s7,1
    800005a4:	00008b17          	auipc	s6,0x8
    800005a8:	ca4b0b13          	add	s6,s6,-860 # 80008248 <rodata_start+0x248>
    800005ac:	34fd0d13          	add	s10,s10,847 # c34f <_entry-0x7fff3cb1>
    800005b0:	00008a97          	auipc	s5,0x8
    800005b4:	d08a8a93          	add	s5,s5,-760 # 800082b8 <rodata_start+0x2b8>
    800005b8:	00300a13          	li	s4,3
    800005bc:	0019899b          	addw	s3,s3,1
    800005c0:	00098613          	mv	a2,s3
    800005c4:	00048593          	mv	a1,s1
    800005c8:	000c0513          	mv	a0,s8
    800005cc:	29c020ef          	jal	80002868 <printf>
    800005d0:	00090513          	mv	a0,s2
    800005d4:	2b8060ef          	jal	8000688c <sem_wait>
    800005d8:	00042783          	lw	a5,0(s0)
    800005dc:	0017871b          	addw	a4,a5,1
    800005e0:	00e42023          	sw	a4,0(s0)
    800005e4:	11770063          	beq	a4,s7,800006e4 <reader+0x1a8>
    800005e8:	00090513          	mv	a0,s2
    800005ec:	3bc060ef          	jal	800069a8 <sem_post>
    800005f0:	00042683          	lw	a3,0(s0)
    800005f4:	000ca603          	lw	a2,0(s9)
    800005f8:	00048593          	mv	a1,s1
    800005fc:	000b0513          	mv	a0,s6
    80000600:	268020ef          	jal	80002868 <printf>
    80000604:	00012423          	sw	zero,8(sp)
    80000608:	00812783          	lw	a5,8(sp)
    8000060c:	00fd4c63          	blt	s10,a5,80000624 <reader+0xe8>
    80000610:	00812783          	lw	a5,8(sp)
    80000614:	0017879b          	addw	a5,a5,1
    80000618:	00f12423          	sw	a5,8(sp)
    8000061c:	00812783          	lw	a5,8(sp)
    80000620:	fefd58e3          	bge	s10,a5,80000610 <reader+0xd4>
    80000624:	00090513          	mv	a0,s2
    80000628:	264060ef          	jal	8000688c <sem_wait>
    8000062c:	00042783          	lw	a5,0(s0)
    80000630:	fff7871b          	addw	a4,a5,-1
    80000634:	00e42023          	sw	a4,0(s0)
    80000638:	08070663          	beqz	a4,800006c4 <reader+0x188>
    8000063c:	00090513          	mv	a0,s2
    80000640:	368060ef          	jal	800069a8 <sem_post>
    80000644:	00048593          	mv	a1,s1
    80000648:	000a8513          	mv	a0,s5
    8000064c:	21c020ef          	jal	80002868 <printf>
    80000650:	00012623          	sw	zero,12(sp)
    80000654:	00c12783          	lw	a5,12(sp)
    80000658:	00fd4c63          	blt	s10,a5,80000670 <reader+0x134>
    8000065c:	00c12783          	lw	a5,12(sp)
    80000660:	0017879b          	addw	a5,a5,1
    80000664:	00f12623          	sw	a5,12(sp)
    80000668:	00c12783          	lw	a5,12(sp)
    8000066c:	fefd58e3          	bge	s10,a5,8000065c <reader+0x120>
    80000670:	34d050ef          	jal	800061bc <yield>
    80000674:	f54994e3          	bne	s3,s4,800005bc <reader+0x80>
    80000678:	00048593          	mv	a1,s1
    8000067c:	00008517          	auipc	a0,0x8
    80000680:	c5c50513          	add	a0,a0,-932 # 800082d8 <rodata_start+0x2d8>
    80000684:	1e4020ef          	jal	80002868 <printf>
    80000688:	06013403          	ld	s0,96(sp)
    8000068c:	06813083          	ld	ra,104(sp)
    80000690:	05813483          	ld	s1,88(sp)
    80000694:	05013903          	ld	s2,80(sp)
    80000698:	04813983          	ld	s3,72(sp)
    8000069c:	04013a03          	ld	s4,64(sp)
    800006a0:	03813a83          	ld	s5,56(sp)
    800006a4:	03013b03          	ld	s6,48(sp)
    800006a8:	02813b83          	ld	s7,40(sp)
    800006ac:	02013c03          	ld	s8,32(sp)
    800006b0:	01813c83          	ld	s9,24(sp)
    800006b4:	01013d03          	ld	s10,16(sp)
    800006b8:	00000513          	li	a0,0
    800006bc:	07010113          	add	sp,sp,112
    800006c0:	5ed0506f          	j	800064ac <exit>
    800006c4:	00048593          	mv	a1,s1
    800006c8:	00008517          	auipc	a0,0x8
    800006cc:	bb850513          	add	a0,a0,-1096 # 80008280 <rodata_start+0x280>
    800006d0:	198020ef          	jal	80002868 <printf>
    800006d4:	00011517          	auipc	a0,0x11
    800006d8:	9a450513          	add	a0,a0,-1628 # 80011078 <rw_mutex>
    800006dc:	2cc060ef          	jal	800069a8 <sem_post>
    800006e0:	f5dff06f          	j	8000063c <reader+0x100>
    800006e4:	00048593          	mv	a1,s1
    800006e8:	00008517          	auipc	a0,0x8
    800006ec:	b3050513          	add	a0,a0,-1232 # 80008218 <rodata_start+0x218>
    800006f0:	178020ef          	jal	80002868 <printf>
    800006f4:	00011517          	auipc	a0,0x11
    800006f8:	98450513          	add	a0,a0,-1660 # 80011078 <rw_mutex>
    800006fc:	190060ef          	jal	8000688c <sem_wait>
    80000700:	ee9ff06f          	j	800005e8 <reader+0xac>

0000000080000704 <philosopher>:
    80000704:	f8010113          	add	sp,sp,-128
    80000708:	06813823          	sd	s0,112(sp)
    8000070c:	06913423          	sd	s1,104(sp)
    80000710:	07213023          	sd	s2,96(sp)
    80000714:	05313c23          	sd	s3,88(sp)
    80000718:	05413823          	sd	s4,80(sp)
    8000071c:	05513423          	sd	s5,72(sp)
    80000720:	03713c23          	sd	s7,56(sp)
    80000724:	03813823          	sd	s8,48(sp)
    80000728:	03913423          	sd	s9,40(sp)
    8000072c:	03a13023          	sd	s10,32(sp)
    80000730:	01b13c23          	sd	s11,24(sp)
    80000734:	06113c23          	sd	ra,120(sp)
    80000738:	05613023          	sd	s6,64(sp)
    8000073c:	5e4050ef          	jal	80005d20 <get_pid>
    80000740:	00500793          	li	a5,5
    80000744:	02f5643b          	remw	s0,a0,a5
    80000748:	00011a17          	auipc	s4,0x11
    8000074c:	970a0a13          	add	s4,s4,-1680 # 800110b8 <forks>
    80000750:	00018937          	lui	s2,0x18
    80000754:	000254b7          	lui	s1,0x25
    80000758:	00000b93          	li	s7,0
    8000075c:	00008d97          	auipc	s11,0x8
    80000760:	bacd8d93          	add	s11,s11,-1108 # 80008308 <rodata_start+0x308>
    80000764:	69f90913          	add	s2,s2,1695 # 1869f <_entry-0x7ffe7961>
    80000768:	00008d17          	auipc	s10,0x8
    8000076c:	bc0d0d13          	add	s10,s10,-1088 # 80008328 <rodata_start+0x328>
    80000770:	00008c97          	auipc	s9,0x8
    80000774:	c18c8c93          	add	s9,s9,-1000 # 80008388 <rodata_start+0x388>
    80000778:	00008c17          	auipc	s8,0x8
    8000077c:	be8c0c13          	add	s8,s8,-1048 # 80008360 <rodata_start+0x360>
    80000780:	9ef48493          	add	s1,s1,-1553 # 249ef <_entry-0x7ffdb611>
    80000784:	0014099b          	addw	s3,s0,1
    80000788:	02f9e9bb          	remw	s3,s3,a5
    8000078c:	00541a93          	sll	s5,s0,0x5
    80000790:	015a0ab3          	add	s5,s4,s5
    80000794:	00599793          	sll	a5,s3,0x5
    80000798:	00fa0a33          	add	s4,s4,a5
    8000079c:	00040593          	mv	a1,s0
    800007a0:	000d8513          	mv	a0,s11
    800007a4:	0c4020ef          	jal	80002868 <printf>
    800007a8:	00012423          	sw	zero,8(sp)
    800007ac:	00812783          	lw	a5,8(sp)
    800007b0:	00f94c63          	blt	s2,a5,800007c8 <philosopher+0xc4>
    800007b4:	00812783          	lw	a5,8(sp)
    800007b8:	0017879b          	addw	a5,a5,1
    800007bc:	00f12423          	sw	a5,8(sp)
    800007c0:	00812783          	lw	a5,8(sp)
    800007c4:	fef958e3          	bge	s2,a5,800007b4 <philosopher+0xb0>
    800007c8:	00098693          	mv	a3,s3
    800007cc:	00040613          	mv	a2,s0
    800007d0:	00040593          	mv	a1,s0
    800007d4:	000d0513          	mv	a0,s10
    800007d8:	090020ef          	jal	80002868 <printf>
    800007dc:	11345a63          	bge	s0,s3,800008f0 <philosopher+0x1ec>
    800007e0:	000a8513          	mv	a0,s5
    800007e4:	0a8060ef          	jal	8000688c <sem_wait>
    800007e8:	00040613          	mv	a2,s0
    800007ec:	00040593          	mv	a1,s0
    800007f0:	000c0513          	mv	a0,s8
    800007f4:	074020ef          	jal	80002868 <printf>
    800007f8:	000a0513          	mv	a0,s4
    800007fc:	090060ef          	jal	8000688c <sem_wait>
    80000800:	00098613          	mv	a2,s3
    80000804:	00040593          	mv	a1,s0
    80000808:	000c8513          	mv	a0,s9
    8000080c:	05c020ef          	jal	80002868 <printf>
    80000810:	001b8b13          	add	s6,s7,1
    80000814:	000b0613          	mv	a2,s6
    80000818:	00040593          	mv	a1,s0
    8000081c:	00008517          	auipc	a0,0x8
    80000820:	b9450513          	add	a0,a0,-1132 # 800083b0 <rodata_start+0x3b0>
    80000824:	044020ef          	jal	80002868 <printf>
    80000828:	00012623          	sw	zero,12(sp)
    8000082c:	00c12783          	lw	a5,12(sp)
    80000830:	00f4cc63          	blt	s1,a5,80000848 <philosopher+0x144>
    80000834:	00c12783          	lw	a5,12(sp)
    80000838:	0017879b          	addw	a5,a5,1
    8000083c:	00f12623          	sw	a5,12(sp)
    80000840:	00c12783          	lw	a5,12(sp)
    80000844:	fef4d8e3          	bge	s1,a5,80000834 <philosopher+0x130>
    80000848:	000a8513          	mv	a0,s5
    8000084c:	15c060ef          	jal	800069a8 <sem_post>
    80000850:	00040613          	mv	a2,s0
    80000854:	00040593          	mv	a1,s0
    80000858:	00008517          	auipc	a0,0x8
    8000085c:	b8850513          	add	a0,a0,-1144 # 800083e0 <rodata_start+0x3e0>
    80000860:	008020ef          	jal	80002868 <printf>
    80000864:	000a0513          	mv	a0,s4
    80000868:	140060ef          	jal	800069a8 <sem_post>
    8000086c:	00098613          	mv	a2,s3
    80000870:	00040593          	mv	a1,s0
    80000874:	00008517          	auipc	a0,0x8
    80000878:	b9450513          	add	a0,a0,-1132 # 80008408 <rodata_start+0x408>
    8000087c:	7ed010ef          	jal	80002868 <printf>
    80000880:	00040593          	mv	a1,s0
    80000884:	00008517          	auipc	a0,0x8
    80000888:	bac50513          	add	a0,a0,-1108 # 80008430 <rodata_start+0x430>
    8000088c:	7dd010ef          	jal	80002868 <printf>
    80000890:	12d050ef          	jal	800061bc <yield>
    80000894:	00200793          	li	a5,2
    80000898:	00100b93          	li	s7,1
    8000089c:	f0fb10e3          	bne	s6,a5,8000079c <philosopher+0x98>
    800008a0:	00040593          	mv	a1,s0
    800008a4:	00008517          	auipc	a0,0x8
    800008a8:	bac50513          	add	a0,a0,-1108 # 80008450 <rodata_start+0x450>
    800008ac:	7bd010ef          	jal	80002868 <printf>
    800008b0:	07013403          	ld	s0,112(sp)
    800008b4:	07813083          	ld	ra,120(sp)
    800008b8:	06813483          	ld	s1,104(sp)
    800008bc:	06013903          	ld	s2,96(sp)
    800008c0:	05813983          	ld	s3,88(sp)
    800008c4:	05013a03          	ld	s4,80(sp)
    800008c8:	04813a83          	ld	s5,72(sp)
    800008cc:	04013b03          	ld	s6,64(sp)
    800008d0:	03813b83          	ld	s7,56(sp)
    800008d4:	03013c03          	ld	s8,48(sp)
    800008d8:	02813c83          	ld	s9,40(sp)
    800008dc:	02013d03          	ld	s10,32(sp)
    800008e0:	01813d83          	ld	s11,24(sp)
    800008e4:	00000513          	li	a0,0
    800008e8:	08010113          	add	sp,sp,128
    800008ec:	3c10506f          	j	800064ac <exit>
    800008f0:	000a0513          	mv	a0,s4
    800008f4:	799050ef          	jal	8000688c <sem_wait>
    800008f8:	00098613          	mv	a2,s3
    800008fc:	00040593          	mv	a1,s0
    80000900:	000c8513          	mv	a0,s9
    80000904:	765010ef          	jal	80002868 <printf>
    80000908:	000a8513          	mv	a0,s5
    8000090c:	781050ef          	jal	8000688c <sem_wait>
    80000910:	00040613          	mv	a2,s0
    80000914:	00040593          	mv	a1,s0
    80000918:	000c0513          	mv	a0,s8
    8000091c:	74d010ef          	jal	80002868 <printf>
    80000920:	ef1ff06f          	j	80000810 <philosopher+0x10c>

0000000080000924 <start_user_test>:
    80000924:	ff010113          	add	sp,sp,-16
    80000928:	00113423          	sd	ra,8(sp)
    8000092c:	00813023          	sd	s0,0(sp)
    80000930:	0f0050ef          	jal	80005a20 <alloc_proc>
    80000934:	02050263          	beqz	a0,80000958 <start_user_test+0x34>
    80000938:	3fe00613          	li	a2,1022
    8000093c:	0000a597          	auipc	a1,0xa
    80000940:	e9c58593          	add	a1,a1,-356 # 8000a7d8 <user_test_fs_bin>
    80000944:	00050413          	mv	s0,a0
    80000948:	630050ef          	jal	80005f78 <load_user_program>
    8000094c:	00051e63          	bnez	a0,80000968 <start_user_test+0x44>
    80000950:	00200793          	li	a5,2
    80000954:	00f42023          	sw	a5,0(s0)
    80000958:	00813083          	ld	ra,8(sp)
    8000095c:	00013403          	ld	s0,0(sp)
    80000960:	01010113          	add	sp,sp,16
    80000964:	00008067          	ret
    80000968:	00008517          	auipc	a0,0x8
    8000096c:	b1050513          	add	a0,a0,-1264 # 80008478 <rodata_start+0x478>
    80000970:	268020ef          	jal	80002bd8 <uart_puts>
    80000974:	32300613          	li	a2,803
    80000978:	0000a597          	auipc	a1,0xa
    8000097c:	26058593          	add	a1,a1,608 # 8000abd8 <user_test_syscalls_bin>
    80000980:	00040513          	mv	a0,s0
    80000984:	5f4050ef          	jal	80005f78 <load_user_program>
    80000988:	fc0504e3          	beqz	a0,80000950 <start_user_test+0x2c>
    8000098c:	00013403          	ld	s0,0(sp)
    80000990:	00813083          	ld	ra,8(sp)
    80000994:	00008517          	auipc	a0,0x8
    80000998:	b1c50513          	add	a0,a0,-1252 # 800084b0 <rodata_start+0x4b0>
    8000099c:	01010113          	add	sp,sp,16
    800009a0:	2380206f          	j	80002bd8 <uart_puts>

00000000800009a4 <test_process_allocation>:
    800009a4:	fe010113          	add	sp,sp,-32
    800009a8:	00008517          	auipc	a0,0x8
    800009ac:	b3050513          	add	a0,a0,-1232 # 800084d8 <rodata_start+0x4d8>
    800009b0:	00113c23          	sd	ra,24(sp)
    800009b4:	00813823          	sd	s0,16(sp)
    800009b8:	00913423          	sd	s1,8(sp)
    800009bc:	01213023          	sd	s2,0(sp)
    800009c0:	218020ef          	jal	80002bd8 <uart_puts>
    800009c4:	05c050ef          	jal	80005a20 <alloc_proc>
    800009c8:	00050413          	mv	s0,a0
    800009cc:	054050ef          	jal	80005a20 <alloc_proc>
    800009d0:	00050493          	mv	s1,a0
    800009d4:	04c050ef          	jal	80005a20 <alloc_proc>
    800009d8:	0a040663          	beqz	s0,80000a84 <test_process_allocation+0xe0>
    800009dc:	0a048463          	beqz	s1,80000a84 <test_process_allocation+0xe0>
    800009e0:	00050913          	mv	s2,a0
    800009e4:	0a050063          	beqz	a0,80000a84 <test_process_allocation+0xe0>
    800009e8:	00452683          	lw	a3,4(a0)
    800009ec:	0044a603          	lw	a2,4(s1)
    800009f0:	00442583          	lw	a1,4(s0)
    800009f4:	00008517          	auipc	a0,0x8
    800009f8:	b2450513          	add	a0,a0,-1244 # 80008518 <rodata_start+0x518>
    800009fc:	66d010ef          	jal	80002868 <printf>
    80000a00:	00042783          	lw	a5,0(s0)
    80000a04:	00100713          	li	a4,1
    80000a08:	00e79a63          	bne	a5,a4,80000a1c <test_process_allocation+0x78>
    80000a0c:	0004a703          	lw	a4,0(s1)
    80000a10:	00f71663          	bne	a4,a5,80000a1c <test_process_allocation+0x78>
    80000a14:	00092783          	lw	a5,0(s2)
    80000a18:	0ae78463          	beq	a5,a4,80000ac0 <test_process_allocation+0x11c>
    80000a1c:	00008517          	auipc	a0,0x8
    80000a20:	b5c50513          	add	a0,a0,-1188 # 80008578 <rodata_start+0x578>
    80000a24:	1b4020ef          	jal	80002bd8 <uart_puts>
    80000a28:	00040513          	mv	a0,s0
    80000a2c:	1b4050ef          	jal	80005be0 <free_proc>
    80000a30:	00048513          	mv	a0,s1
    80000a34:	1ac050ef          	jal	80005be0 <free_proc>
    80000a38:	00090513          	mv	a0,s2
    80000a3c:	1a4050ef          	jal	80005be0 <free_proc>
    80000a40:	00042783          	lw	a5,0(s0)
    80000a44:	00079a63          	bnez	a5,80000a58 <test_process_allocation+0xb4>
    80000a48:	0004a783          	lw	a5,0(s1)
    80000a4c:	00079663          	bnez	a5,80000a58 <test_process_allocation+0xb4>
    80000a50:	00092783          	lw	a5,0(s2)
    80000a54:	04078e63          	beqz	a5,80000ab0 <test_process_allocation+0x10c>
    80000a58:	00008517          	auipc	a0,0x8
    80000a5c:	b5050513          	add	a0,a0,-1200 # 800085a8 <rodata_start+0x5a8>
    80000a60:	178020ef          	jal	80002bd8 <uart_puts>
    80000a64:	01013403          	ld	s0,16(sp)
    80000a68:	01813083          	ld	ra,24(sp)
    80000a6c:	00813483          	ld	s1,8(sp)
    80000a70:	00013903          	ld	s2,0(sp)
    80000a74:	00008517          	auipc	a0,0x8
    80000a78:	b6450513          	add	a0,a0,-1180 # 800085d8 <rodata_start+0x5d8>
    80000a7c:	02010113          	add	sp,sp,32
    80000a80:	1580206f          	j	80002bd8 <uart_puts>
    80000a84:	00008517          	auipc	a0,0x8
    80000a88:	b3c50513          	add	a0,a0,-1220 # 800085c0 <rodata_start+0x5c0>
    80000a8c:	14c020ef          	jal	80002bd8 <uart_puts>
    80000a90:	01013403          	ld	s0,16(sp)
    80000a94:	01813083          	ld	ra,24(sp)
    80000a98:	00813483          	ld	s1,8(sp)
    80000a9c:	00013903          	ld	s2,0(sp)
    80000aa0:	00008517          	auipc	a0,0x8
    80000aa4:	b3850513          	add	a0,a0,-1224 # 800085d8 <rodata_start+0x5d8>
    80000aa8:	02010113          	add	sp,sp,32
    80000aac:	12c0206f          	j	80002bd8 <uart_puts>
    80000ab0:	00008517          	auipc	a0,0x8
    80000ab4:	ae050513          	add	a0,a0,-1312 # 80008590 <rodata_start+0x590>
    80000ab8:	120020ef          	jal	80002bd8 <uart_puts>
    80000abc:	fd5ff06f          	j	80000a90 <test_process_allocation+0xec>
    80000ac0:	00008517          	auipc	a0,0x8
    80000ac4:	a9050513          	add	a0,a0,-1392 # 80008550 <rodata_start+0x550>
    80000ac8:	110020ef          	jal	80002bd8 <uart_puts>
    80000acc:	f5dff06f          	j	80000a28 <test_process_allocation+0x84>

0000000080000ad0 <test_process_find>:
    80000ad0:	fe010113          	add	sp,sp,-32
    80000ad4:	00008517          	auipc	a0,0x8
    80000ad8:	b1c50513          	add	a0,a0,-1252 # 800085f0 <rodata_start+0x5f0>
    80000adc:	00113c23          	sd	ra,24(sp)
    80000ae0:	00813823          	sd	s0,16(sp)
    80000ae4:	00913423          	sd	s1,8(sp)
    80000ae8:	0f0020ef          	jal	80002bd8 <uart_puts>
    80000aec:	735040ef          	jal	80005a20 <alloc_proc>
    80000af0:	08050863          	beqz	a0,80000b80 <test_process_find+0xb0>
    80000af4:	00452483          	lw	s1,4(a0)
    80000af8:	00050413          	mv	s0,a0
    80000afc:	00008517          	auipc	a0,0x8
    80000b00:	b4450513          	add	a0,a0,-1212 # 80008640 <rodata_start+0x640>
    80000b04:	00048593          	mv	a1,s1
    80000b08:	561010ef          	jal	80002868 <printf>
    80000b0c:	00048513          	mv	a0,s1
    80000b10:	144050ef          	jal	80005c54 <find_proc>
    80000b14:	00050663          	beqz	a0,80000b20 <test_process_find+0x50>
    80000b18:	00452783          	lw	a5,4(a0)
    80000b1c:	08978063          	beq	a5,s1,80000b9c <test_process_find+0xcc>
    80000b20:	00008517          	auipc	a0,0x8
    80000b24:	b5850513          	add	a0,a0,-1192 # 80008678 <rodata_start+0x678>
    80000b28:	0b0020ef          	jal	80002bd8 <uart_puts>
    80000b2c:	00040513          	mv	a0,s0
    80000b30:	0b0050ef          	jal	80005be0 <free_proc>
    80000b34:	00048513          	mv	a0,s1
    80000b38:	11c050ef          	jal	80005c54 <find_proc>
    80000b3c:	00050663          	beqz	a0,80000b48 <test_process_find+0x78>
    80000b40:	00052783          	lw	a5,0(a0)
    80000b44:	02079663          	bnez	a5,80000b70 <test_process_find+0xa0>
    80000b48:	00008517          	auipc	a0,0x8
    80000b4c:	b4850513          	add	a0,a0,-1208 # 80008690 <rodata_start+0x690>
    80000b50:	088020ef          	jal	80002bd8 <uart_puts>
    80000b54:	01013403          	ld	s0,16(sp)
    80000b58:	01813083          	ld	ra,24(sp)
    80000b5c:	00813483          	ld	s1,8(sp)
    80000b60:	00008517          	auipc	a0,0x8
    80000b64:	a7850513          	add	a0,a0,-1416 # 800085d8 <rodata_start+0x5d8>
    80000b68:	02010113          	add	sp,sp,32
    80000b6c:	06c0206f          	j	80002bd8 <uart_puts>
    80000b70:	00008517          	auipc	a0,0x8
    80000b74:	b5850513          	add	a0,a0,-1192 # 800086c8 <rodata_start+0x6c8>
    80000b78:	060020ef          	jal	80002bd8 <uart_puts>
    80000b7c:	fd9ff06f          	j	80000b54 <test_process_find+0x84>
    80000b80:	01013403          	ld	s0,16(sp)
    80000b84:	01813083          	ld	ra,24(sp)
    80000b88:	00813483          	ld	s1,8(sp)
    80000b8c:	00008517          	auipc	a0,0x8
    80000b90:	a9c50513          	add	a0,a0,-1380 # 80008628 <rodata_start+0x628>
    80000b94:	02010113          	add	sp,sp,32
    80000b98:	0400206f          	j	80002bd8 <uart_puts>
    80000b9c:	00048593          	mv	a1,s1
    80000ba0:	00008517          	auipc	a0,0x8
    80000ba4:	ab850513          	add	a0,a0,-1352 # 80008658 <rodata_start+0x658>
    80000ba8:	4c1010ef          	jal	80002868 <printf>
    80000bac:	f81ff06f          	j	80000b2c <test_process_find+0x5c>

0000000080000bb0 <test_process_state_transition>:
    80000bb0:	fe010113          	add	sp,sp,-32
    80000bb4:	00008517          	auipc	a0,0x8
    80000bb8:	b4450513          	add	a0,a0,-1212 # 800086f8 <rodata_start+0x6f8>
    80000bbc:	00113c23          	sd	ra,24(sp)
    80000bc0:	00813823          	sd	s0,16(sp)
    80000bc4:	00913423          	sd	s1,8(sp)
    80000bc8:	010020ef          	jal	80002bd8 <uart_puts>
    80000bcc:	655040ef          	jal	80005a20 <alloc_proc>
    80000bd0:	0c050a63          	beqz	a0,80000ca4 <test_process_state_transition+0xf4>
    80000bd4:	00052583          	lw	a1,0(a0)
    80000bd8:	00050413          	mv	s0,a0
    80000bdc:	00100613          	li	a2,1
    80000be0:	00008517          	auipc	a0,0x8
    80000be4:	b5850513          	add	a0,a0,-1192 # 80008738 <rodata_start+0x738>
    80000be8:	481010ef          	jal	80002868 <printf>
    80000bec:	00040513          	mv	a0,s0
    80000bf0:	0c8050ef          	jal	80005cb8 <proc_mark_runnable>
    80000bf4:	00042703          	lw	a4,0(s0)
    80000bf8:	00200793          	li	a5,2
    80000bfc:	0cf70263          	beq	a4,a5,80000cc0 <test_process_state_transition+0x110>
    80000c00:	00300793          	li	a5,3
    80000c04:	000014b7          	lui	s1,0x1
    80000c08:	00f42023          	sw	a5,0(s0)
    80000c0c:	23448593          	add	a1,s1,564 # 1234 <_entry-0x7fffedcc>
    80000c10:	00040513          	mv	a0,s0
    80000c14:	0cc050ef          	jal	80005ce0 <proc_mark_sleeping>
    80000c18:	00042583          	lw	a1,0(s0)
    80000c1c:	00400793          	li	a5,4
    80000c20:	00f59863          	bne	a1,a5,80000c30 <test_process_state_transition+0x80>
    80000c24:	0b843783          	ld	a5,184(s0)
    80000c28:	23448493          	add	s1,s1,564
    80000c2c:	06978463          	beq	a5,s1,80000c94 <test_process_state_transition+0xe4>
    80000c30:	00008517          	auipc	a0,0x8
    80000c34:	b6850513          	add	a0,a0,-1176 # 80008798 <rodata_start+0x798>
    80000c38:	431010ef          	jal	80002868 <printf>
    80000c3c:	02a00593          	li	a1,42
    80000c40:	00040513          	mv	a0,s0
    80000c44:	0c0050ef          	jal	80005d04 <proc_mark_zombie>
    80000c48:	00042703          	lw	a4,0(s0)
    80000c4c:	00500793          	li	a5,5
    80000c50:	02f70463          	beq	a4,a5,80000c78 <test_process_state_transition+0xc8>
    80000c54:	00040513          	mv	a0,s0
    80000c58:	789040ef          	jal	80005be0 <free_proc>
    80000c5c:	01013403          	ld	s0,16(sp)
    80000c60:	01813083          	ld	ra,24(sp)
    80000c64:	00813483          	ld	s1,8(sp)
    80000c68:	00008517          	auipc	a0,0x8
    80000c6c:	97050513          	add	a0,a0,-1680 # 800085d8 <rodata_start+0x5d8>
    80000c70:	02010113          	add	sp,sp,32
    80000c74:	7650106f          	j	80002bd8 <uart_puts>
    80000c78:	01042703          	lw	a4,16(s0)
    80000c7c:	02a00793          	li	a5,42
    80000c80:	fcf71ae3          	bne	a4,a5,80000c54 <test_process_state_transition+0xa4>
    80000c84:	00008517          	auipc	a0,0x8
    80000c88:	b4450513          	add	a0,a0,-1212 # 800087c8 <rodata_start+0x7c8>
    80000c8c:	74d010ef          	jal	80002bd8 <uart_puts>
    80000c90:	fc5ff06f          	j	80000c54 <test_process_state_transition+0xa4>
    80000c94:	00008517          	auipc	a0,0x8
    80000c98:	ae450513          	add	a0,a0,-1308 # 80008778 <rodata_start+0x778>
    80000c9c:	73d010ef          	jal	80002bd8 <uart_puts>
    80000ca0:	f9dff06f          	j	80000c3c <test_process_state_transition+0x8c>
    80000ca4:	01013403          	ld	s0,16(sp)
    80000ca8:	01813083          	ld	ra,24(sp)
    80000cac:	00813483          	ld	s1,8(sp)
    80000cb0:	00008517          	auipc	a0,0x8
    80000cb4:	97850513          	add	a0,a0,-1672 # 80008628 <rodata_start+0x628>
    80000cb8:	02010113          	add	sp,sp,32
    80000cbc:	71d0106f          	j	80002bd8 <uart_puts>
    80000cc0:	00008517          	auipc	a0,0x8
    80000cc4:	a9850513          	add	a0,a0,-1384 # 80008758 <rodata_start+0x758>
    80000cc8:	711010ef          	jal	80002bd8 <uart_puts>
    80000ccc:	f35ff06f          	j	80000c00 <test_process_state_transition+0x50>

0000000080000cd0 <test_simple_fork>:
    80000cd0:	fe010113          	add	sp,sp,-32
    80000cd4:	00008517          	auipc	a0,0x8
    80000cd8:	b1450513          	add	a0,a0,-1260 # 800087e8 <rodata_start+0x7e8>
    80000cdc:	00113c23          	sd	ra,24(sp)
    80000ce0:	00813823          	sd	s0,16(sp)
    80000ce4:	00913423          	sd	s1,8(sp)
    80000ce8:	6f1010ef          	jal	80002bd8 <uart_puts>
    80000cec:	535040ef          	jal	80005a20 <alloc_proc>
    80000cf0:	0a050463          	beqz	a0,80000d98 <test_simple_fork+0xc8>
    80000cf4:	00300793          	li	a5,3
    80000cf8:	00f52023          	sw	a5,0(a0)
    80000cfc:	00050413          	mv	s0,a0
    80000d00:	048050ef          	jal	80005d48 <set_current_proc>
    80000d04:	00442583          	lw	a1,4(s0)
    80000d08:	00008517          	auipc	a0,0x8
    80000d0c:	b4050513          	add	a0,a0,-1216 # 80008848 <rodata_start+0x848>
    80000d10:	359010ef          	jal	80002868 <printf>
    80000d14:	558050ef          	jal	8000626c <fork>
    80000d18:	00050493          	mv	s1,a0
    80000d1c:	06a05663          	blez	a0,80000d88 <test_simple_fork+0xb8>
    80000d20:	00050593          	mv	a1,a0
    80000d24:	00008517          	auipc	a0,0x8
    80000d28:	b3c50513          	add	a0,a0,-1220 # 80008860 <rodata_start+0x860>
    80000d2c:	33d010ef          	jal	80002868 <printf>
    80000d30:	00048513          	mv	a0,s1
    80000d34:	721040ef          	jal	80005c54 <find_proc>
    80000d38:	00050493          	mv	s1,a0
    80000d3c:	02050063          	beqz	a0,80000d5c <test_simple_fork+0x8c>
    80000d40:	0b053783          	ld	a5,176(a0)
    80000d44:	06878863          	beq	a5,s0,80000db4 <test_simple_fork+0xe4>
    80000d48:	0004a703          	lw	a4,0(s1)
    80000d4c:	00200793          	li	a5,2
    80000d50:	08f70063          	beq	a4,a5,80000dd0 <test_simple_fork+0x100>
    80000d54:	00048513          	mv	a0,s1
    80000d58:	689040ef          	jal	80005be0 <free_proc>
    80000d5c:	00040513          	mv	a0,s0
    80000d60:	681040ef          	jal	80005be0 <free_proc>
    80000d64:	00000513          	li	a0,0
    80000d68:	7e1040ef          	jal	80005d48 <set_current_proc>
    80000d6c:	01013403          	ld	s0,16(sp)
    80000d70:	01813083          	ld	ra,24(sp)
    80000d74:	00813483          	ld	s1,8(sp)
    80000d78:	00008517          	auipc	a0,0x8
    80000d7c:	86050513          	add	a0,a0,-1952 # 800085d8 <rodata_start+0x5d8>
    80000d80:	02010113          	add	sp,sp,32
    80000d84:	6550106f          	j	80002bd8 <uart_puts>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	b4050513          	add	a0,a0,-1216 # 800088c8 <rodata_start+0x8c8>
    80000d90:	649010ef          	jal	80002bd8 <uart_puts>
    80000d94:	fc9ff06f          	j	80000d5c <test_simple_fork+0x8c>
    80000d98:	01013403          	ld	s0,16(sp)
    80000d9c:	01813083          	ld	ra,24(sp)
    80000da0:	00813483          	ld	s1,8(sp)
    80000da4:	00008517          	auipc	a0,0x8
    80000da8:	a8450513          	add	a0,a0,-1404 # 80008828 <rodata_start+0x828>
    80000dac:	02010113          	add	sp,sp,32
    80000db0:	6290106f          	j	80002bd8 <uart_puts>
    80000db4:	00852703          	lw	a4,8(a0)
    80000db8:	00442783          	lw	a5,4(s0)
    80000dbc:	f8f716e3          	bne	a4,a5,80000d48 <test_simple_fork+0x78>
    80000dc0:	00008517          	auipc	a0,0x8
    80000dc4:	ac850513          	add	a0,a0,-1336 # 80008888 <rodata_start+0x888>
    80000dc8:	611010ef          	jal	80002bd8 <uart_puts>
    80000dcc:	f7dff06f          	j	80000d48 <test_simple_fork+0x78>
    80000dd0:	00008517          	auipc	a0,0x8
    80000dd4:	ad850513          	add	a0,a0,-1320 # 800088a8 <rodata_start+0x8a8>
    80000dd8:	601010ef          	jal	80002bd8 <uart_puts>
    80000ddc:	f79ff06f          	j	80000d54 <test_simple_fork+0x84>

0000000080000de0 <test_scheduler_basic>:
    80000de0:	fb010113          	add	sp,sp,-80
    80000de4:	04813023          	sd	s0,64(sp)
    80000de8:	00008517          	auipc	a0,0x8
    80000dec:	af050513          	add	a0,a0,-1296 # 800088d8 <rodata_start+0x8d8>
    80000df0:	00810413          	add	s0,sp,8
    80000df4:	02913c23          	sd	s1,56(sp)
    80000df8:	03213823          	sd	s2,48(sp)
    80000dfc:	03313423          	sd	s3,40(sp)
    80000e00:	03413023          	sd	s4,32(sp)
    80000e04:	04113423          	sd	ra,72(sp)
    80000e08:	02010913          	add	s2,sp,32
    80000e0c:	5cd010ef          	jal	80002bd8 <uart_puts>
    80000e10:	00040493          	mv	s1,s0
    80000e14:	00200a13          	li	s4,2
    80000e18:	00008997          	auipc	s3,0x8
    80000e1c:	b0098993          	add	s3,s3,-1280 # 80008918 <rodata_start+0x918>
    80000e20:	401040ef          	jal	80005a20 <alloc_proc>
    80000e24:	00a4b023          	sd	a0,0(s1)
    80000e28:	00050793          	mv	a5,a0
    80000e2c:	00848493          	add	s1,s1,8
    80000e30:	00098513          	mv	a0,s3
    80000e34:	00078863          	beqz	a5,80000e44 <test_scheduler_basic+0x64>
    80000e38:	0047a583          	lw	a1,4(a5)
    80000e3c:	0147a023          	sw	s4,0(a5)
    80000e40:	229010ef          	jal	80002868 <printf>
    80000e44:	fd249ee3          	bne	s1,s2,80000e20 <test_scheduler_basic+0x40>
    80000e48:	00425797          	auipc	a5,0x425
    80000e4c:	8d878793          	add	a5,a5,-1832 # 80425720 <proc>
    80000e50:	00425617          	auipc	a2,0x425
    80000e54:	55060613          	add	a2,a2,1360 # 804263a0 <fds>
    80000e58:	00000593          	li	a1,0
    80000e5c:	00200693          	li	a3,2
    80000e60:	0007a703          	lw	a4,0(a5)
    80000e64:	0c878793          	add	a5,a5,200
    80000e68:	04d70863          	beq	a4,a3,80000eb8 <test_scheduler_basic+0xd8>
    80000e6c:	fec79ae3          	bne	a5,a2,80000e60 <test_scheduler_basic+0x80>
    80000e70:	00008517          	auipc	a0,0x8
    80000e74:	ac050513          	add	a0,a0,-1344 # 80008930 <rodata_start+0x930>
    80000e78:	1f1010ef          	jal	80002868 <printf>
    80000e7c:	00043503          	ld	a0,0(s0)
    80000e80:	00840413          	add	s0,s0,8
    80000e84:	00050463          	beqz	a0,80000e8c <test_scheduler_basic+0xac>
    80000e88:	559040ef          	jal	80005be0 <free_proc>
    80000e8c:	ff2418e3          	bne	s0,s2,80000e7c <test_scheduler_basic+0x9c>
    80000e90:	04013403          	ld	s0,64(sp)
    80000e94:	04813083          	ld	ra,72(sp)
    80000e98:	03813483          	ld	s1,56(sp)
    80000e9c:	03013903          	ld	s2,48(sp)
    80000ea0:	02813983          	ld	s3,40(sp)
    80000ea4:	02013a03          	ld	s4,32(sp)
    80000ea8:	00007517          	auipc	a0,0x7
    80000eac:	73050513          	add	a0,a0,1840 # 800085d8 <rodata_start+0x5d8>
    80000eb0:	05010113          	add	sp,sp,80
    80000eb4:	5250106f          	j	80002bd8 <uart_puts>
    80000eb8:	0015859b          	addw	a1,a1,1
    80000ebc:	fac792e3          	bne	a5,a2,80000e60 <test_scheduler_basic+0x80>
    80000ec0:	fb1ff06f          	j	80000e70 <test_scheduler_basic+0x90>

0000000080000ec4 <test_process_memory>:
    80000ec4:	fd010113          	add	sp,sp,-48
    80000ec8:	00008517          	auipc	a0,0x8
    80000ecc:	a9050513          	add	a0,a0,-1392 # 80008958 <rodata_start+0x958>
    80000ed0:	02113423          	sd	ra,40(sp)
    80000ed4:	02813023          	sd	s0,32(sp)
    80000ed8:	00913c23          	sd	s1,24(sp)
    80000edc:	01213823          	sd	s2,16(sp)
    80000ee0:	01313423          	sd	s3,8(sp)
    80000ee4:	4f5010ef          	jal	80002bd8 <uart_puts>
    80000ee8:	339040ef          	jal	80005a20 <alloc_proc>
    80000eec:	10050663          	beqz	a0,80000ff8 <test_process_memory+0x134>
    80000ef0:	01853783          	ld	a5,24(a0)
    80000ef4:	00050413          	mv	s0,a0
    80000ef8:	0c078a63          	beqz	a5,80000fcc <test_process_memory+0x108>
    80000efc:	00452583          	lw	a1,4(a0)
    80000f00:	00008517          	auipc	a0,0x8
    80000f04:	a9850513          	add	a0,a0,-1384 # 80008998 <rodata_start+0x998>
    80000f08:	00002937          	lui	s2,0x2
    80000f0c:	15d010ef          	jal	80002868 <printf>
    80000f10:	02043983          	ld	s3,32(s0)
    80000f14:	01843503          	ld	a0,24(s0)
    80000f18:	01298933          	add	s2,s3,s2
    80000f1c:	00090613          	mv	a2,s2
    80000f20:	00098593          	mv	a1,s3
    80000f24:	3f1030ef          	jal	80004b14 <uvmalloc>
    80000f28:	00050493          	mv	s1,a0
    80000f2c:	06a90663          	beq	s2,a0,80000f98 <test_process_memory+0xd4>
    80000f30:	00008517          	auipc	a0,0x8
    80000f34:	ac050513          	add	a0,a0,-1344 # 800089f0 <rodata_start+0x9f0>
    80000f38:	4a1010ef          	jal	80002bd8 <uart_puts>
    80000f3c:	02043483          	ld	s1,32(s0)
    80000f40:	01843503          	ld	a0,24(s0)
    80000f44:	fffff937          	lui	s2,0xfffff
    80000f48:	01248633          	add	a2,s1,s2
    80000f4c:	00048593          	mv	a1,s1
    80000f50:	34d030ef          	jal	80004a9c <uvmdealloc>
    80000f54:	02043583          	ld	a1,32(s0)
    80000f58:	01258933          	add	s2,a1,s2
    80000f5c:	04a90c63          	beq	s2,a0,80000fb4 <test_process_memory+0xf0>
    80000f60:	00008517          	auipc	a0,0x8
    80000f64:	ad850513          	add	a0,a0,-1320 # 80008a38 <rodata_start+0xa38>
    80000f68:	471010ef          	jal	80002bd8 <uart_puts>
    80000f6c:	00040513          	mv	a0,s0
    80000f70:	471040ef          	jal	80005be0 <free_proc>
    80000f74:	00008517          	auipc	a0,0x8
    80000f78:	adc50513          	add	a0,a0,-1316 # 80008a50 <rodata_start+0xa50>
    80000f7c:	02013403          	ld	s0,32(sp)
    80000f80:	02813083          	ld	ra,40(sp)
    80000f84:	01813483          	ld	s1,24(sp)
    80000f88:	01013903          	ld	s2,16(sp)
    80000f8c:	00813983          	ld	s3,8(sp)
    80000f90:	03010113          	add	sp,sp,48
    80000f94:	4450106f          	j	80002bd8 <uart_puts>
    80000f98:	00050613          	mv	a2,a0
    80000f9c:	00098593          	mv	a1,s3
    80000fa0:	00008517          	auipc	a0,0x8
    80000fa4:	a2050513          	add	a0,a0,-1504 # 800089c0 <rodata_start+0x9c0>
    80000fa8:	0c1010ef          	jal	80002868 <printf>
    80000fac:	02943023          	sd	s1,32(s0)
    80000fb0:	f91ff06f          	j	80000f40 <test_process_memory+0x7c>
    80000fb4:	00090613          	mv	a2,s2
    80000fb8:	00008517          	auipc	a0,0x8
    80000fbc:	a5050513          	add	a0,a0,-1456 # 80008a08 <rodata_start+0xa08>
    80000fc0:	0a9010ef          	jal	80002868 <printf>
    80000fc4:	03243023          	sd	s2,32(s0)
    80000fc8:	fa5ff06f          	j	80000f6c <test_process_memory+0xa8>
    80000fcc:	00008517          	auipc	a0,0x8
    80000fd0:	9ac50513          	add	a0,a0,-1620 # 80008978 <rodata_start+0x978>
    80000fd4:	405010ef          	jal	80002bd8 <uart_puts>
    80000fd8:	00040513          	mv	a0,s0
    80000fdc:	02013403          	ld	s0,32(sp)
    80000fe0:	02813083          	ld	ra,40(sp)
    80000fe4:	01813483          	ld	s1,24(sp)
    80000fe8:	01013903          	ld	s2,16(sp)
    80000fec:	00813983          	ld	s3,8(sp)
    80000ff0:	03010113          	add	sp,sp,48
    80000ff4:	3ed0406f          	j	80005be0 <free_proc>
    80000ff8:	00007517          	auipc	a0,0x7
    80000ffc:	5c850513          	add	a0,a0,1480 # 800085c0 <rodata_start+0x5c0>
    80001000:	f7dff06f          	j	80000f7c <test_process_memory+0xb8>

0000000080001004 <test_growproc>:
    80001004:	fe010113          	add	sp,sp,-32
    80001008:	00008517          	auipc	a0,0x8
    8000100c:	a7050513          	add	a0,a0,-1424 # 80008a78 <rodata_start+0xa78>
    80001010:	00113c23          	sd	ra,24(sp)
    80001014:	00813823          	sd	s0,16(sp)
    80001018:	00913423          	sd	s1,8(sp)
    8000101c:	01213023          	sd	s2,0(sp)
    80001020:	3b9010ef          	jal	80002bd8 <uart_puts>
    80001024:	1fd040ef          	jal	80005a20 <alloc_proc>
    80001028:	0c050463          	beqz	a0,800010f0 <test_growproc+0xec>
    8000102c:	00050413          	mv	s0,a0
    80001030:	01853503          	ld	a0,24(a0)
    80001034:	00001637          	lui	a2,0x1
    80001038:	00000593          	li	a1,0
    8000103c:	2d9030ef          	jal	80004b14 <uvmalloc>
    80001040:	00050593          	mv	a1,a0
    80001044:	02a43023          	sd	a0,32(s0)
    80001048:	00008517          	auipc	a0,0x8
    8000104c:	a5050513          	add	a0,a0,-1456 # 80008a98 <rodata_start+0xa98>
    80001050:	019010ef          	jal	80002868 <printf>
    80001054:	00427497          	auipc	s1,0x427
    80001058:	c9c48493          	add	s1,s1,-868 # 80427cf0 <current_proc>
    8000105c:	00001537          	lui	a0,0x1
    80001060:	0004b903          	ld	s2,0(s1)
    80001064:	0084b023          	sd	s0,0(s1)
    80001068:	3d4050ef          	jal	8000643c <growproc>
    8000106c:	04050c63          	beqz	a0,800010c4 <test_growproc+0xc0>
    80001070:	00008517          	auipc	a0,0x8
    80001074:	a8050513          	add	a0,a0,-1408 # 80008af0 <rodata_start+0xaf0>
    80001078:	361010ef          	jal	80002bd8 <uart_puts>
    8000107c:	fffff537          	lui	a0,0xfffff
    80001080:	3bc050ef          	jal	8000643c <growproc>
    80001084:	04051e63          	bnez	a0,800010e0 <test_growproc+0xdc>
    80001088:	02043583          	ld	a1,32(s0)
    8000108c:	00008517          	auipc	a0,0x8
    80001090:	a8450513          	add	a0,a0,-1404 # 80008b10 <rodata_start+0xb10>
    80001094:	7d4010ef          	jal	80002868 <printf>
    80001098:	00040513          	mv	a0,s0
    8000109c:	0124b023          	sd	s2,0(s1)
    800010a0:	341040ef          	jal	80005be0 <free_proc>
    800010a4:	01013403          	ld	s0,16(sp)
    800010a8:	01813083          	ld	ra,24(sp)
    800010ac:	00813483          	ld	s1,8(sp)
    800010b0:	00013903          	ld	s2,0(sp)
    800010b4:	00008517          	auipc	a0,0x8
    800010b8:	ab450513          	add	a0,a0,-1356 # 80008b68 <rodata_start+0xb68>
    800010bc:	02010113          	add	sp,sp,32
    800010c0:	3190106f          	j	80002bd8 <uart_puts>
    800010c4:	02043583          	ld	a1,32(s0)
    800010c8:	00008517          	auipc	a0,0x8
    800010cc:	9f050513          	add	a0,a0,-1552 # 80008ab8 <rodata_start+0xab8>
    800010d0:	798010ef          	jal	80002868 <printf>
    800010d4:	fffff537          	lui	a0,0xfffff
    800010d8:	364050ef          	jal	8000643c <growproc>
    800010dc:	fa0506e3          	beqz	a0,80001088 <test_growproc+0x84>
    800010e0:	00008517          	auipc	a0,0x8
    800010e4:	a6850513          	add	a0,a0,-1432 # 80008b48 <rodata_start+0xb48>
    800010e8:	2f1010ef          	jal	80002bd8 <uart_puts>
    800010ec:	fadff06f          	j	80001098 <test_growproc+0x94>
    800010f0:	01013403          	ld	s0,16(sp)
    800010f4:	01813083          	ld	ra,24(sp)
    800010f8:	00813483          	ld	s1,8(sp)
    800010fc:	00013903          	ld	s2,0(sp)
    80001100:	00007517          	auipc	a0,0x7
    80001104:	4c050513          	add	a0,a0,1216 # 800085c0 <rodata_start+0x5c0>
    80001108:	02010113          	add	sp,sp,32
    8000110c:	2cd0106f          	j	80002bd8 <uart_puts>

0000000080001110 <test_uid_limits>:
    80001110:	f5010113          	add	sp,sp,-176
    80001114:	00008517          	auipc	a0,0x8
    80001118:	a7450513          	add	a0,a0,-1420 # 80008b88 <rodata_start+0xb88>
    8000111c:	0a113423          	sd	ra,168(sp)
    80001120:	0a813023          	sd	s0,160(sp)
    80001124:	09213823          	sd	s2,144(sp)
    80001128:	08913c23          	sd	s1,152(sp)
    8000112c:	09313423          	sd	s3,136(sp)
    80001130:	09413023          	sd	s4,128(sp)
    80001134:	07513c23          	sd	s5,120(sp)
    80001138:	07613823          	sd	s6,112(sp)
    8000113c:	07713423          	sd	s7,104(sp)
    80001140:	07813023          	sd	s8,96(sp)
    80001144:	05913c23          	sd	s9,88(sp)
    80001148:	05a13823          	sd	s10,80(sp)
    8000114c:	28d010ef          	jal	80002bd8 <uart_puts>
    80001150:	0d1040ef          	jal	80005a20 <alloc_proc>
    80001154:	00050413          	mv	s0,a0
    80001158:	00000913          	li	s2,0
    8000115c:	02050063          	beqz	a0,8000117c <test_uid_limits+0x6c>
    80001160:	00c52603          	lw	a2,12(a0)
    80001164:	00452583          	lw	a1,4(a0)
    80001168:	00008517          	auipc	a0,0x8
    8000116c:	a4850513          	add	a0,a0,-1464 # 80008bb0 <rodata_start+0xbb0>
    80001170:	00100913          	li	s2,1
    80001174:	6f4010ef          	jal	80002868 <printf>
    80001178:	00813023          	sd	s0,0(sp)
    8000117c:	00427a97          	auipc	s5,0x427
    80001180:	b74a8a93          	add	s5,s5,-1164 # 80427cf0 <current_proc>
    80001184:	00100513          	li	a0,1
    80001188:	000abc03          	ld	s8,0(s5)
    8000118c:	008ab023          	sd	s0,0(s5)
    80001190:	3dd040ef          	jal	80005d6c <set_uid>
    80001194:	12050063          	beqz	a0,800012b4 <test_uid_limits+0x1a4>
    80001198:	00400593          	li	a1,4
    8000119c:	00008517          	auipc	a0,0x8
    800011a0:	a6c50513          	add	a0,a0,-1428 # 80008c08 <rodata_start+0xc08>
    800011a4:	00391993          	sll	s3,s2,0x3
    800011a8:	00200b13          	li	s6,2
    800011ac:	6bc010ef          	jal	80002868 <printf>
    800011b0:	013109b3          	add	s3,sp,s3
    800011b4:	00990b9b          	addw	s7,s2,9 # fffffffffffff009 <bss_end+0xffffffff7fbd7311>
    800011b8:	412b0b3b          	subw	s6,s6,s2
    800011bc:	00400a13          	li	s4,4
    800011c0:	00008c97          	auipc	s9,0x8
    800011c4:	af8c8c93          	add	s9,s9,-1288 # 80008cb8 <rodata_start+0xcb8>
    800011c8:	059040ef          	jal	80005a20 <alloc_proc>
    800011cc:	00050413          	mv	s0,a0
    800011d0:	012b0d3b          	addw	s10,s6,s2
    800011d4:	0e050a63          	beqz	a0,800012c8 <test_uid_limits+0x1b8>
    800011d8:	000ab783          	ld	a5,0(s5)
    800011dc:	00c7a503          	lw	a0,12(a5)
    800011e0:	00a42623          	sw	a0,12(s0)
    800011e4:	409040ef          	jal	80005dec <count_user_procs>
    800011e8:	00050493          	mv	s1,a0
    800011ec:	000d0593          	mv	a1,s10
    800011f0:	000c8513          	mv	a0,s9
    800011f4:	00048713          	mv	a4,s1
    800011f8:	109a4063          	blt	s4,s1,800012f8 <test_uid_limits+0x1e8>
    800011fc:	00c42683          	lw	a3,12(s0)
    80001200:	00442603          	lw	a2,4(s0)
    80001204:	00898993          	add	s3,s3,8
    80001208:	0019091b          	addw	s2,s2,1
    8000120c:	65c010ef          	jal	80002868 <printf>
    80001210:	fe89bc23          	sd	s0,-8(s3)
    80001214:	13448063          	beq	s1,s4,80001334 <test_uid_limits+0x224>
    80001218:	fb7918e3          	bne	s2,s7,800011c8 <test_uid_limits+0xb8>
    8000121c:	00008517          	auipc	a0,0x8
    80001220:	b1c50513          	add	a0,a0,-1252 # 80008d38 <rodata_start+0xd38>
    80001224:	644010ef          	jal	80002868 <printf>
    80001228:	00100513          	li	a0,1
    8000122c:	41d040ef          	jal	80005e48 <can_fork>
    80001230:	06050a63          	beqz	a0,800012a4 <test_uid_limits+0x194>
    80001234:	00008517          	auipc	a0,0x8
    80001238:	b4c50513          	add	a0,a0,-1204 # 80008d80 <rodata_start+0xd80>
    8000123c:	19d010ef          	jal	80002bd8 <uart_puts>
    80001240:	00010413          	mv	s0,sp
    80001244:	003b9493          	sll	s1,s7,0x3
    80001248:	018ab023          	sd	s8,0(s5)
    8000124c:	009404b3          	add	s1,s0,s1
    80001250:	000b8a63          	beqz	s7,80001264 <test_uid_limits+0x154>
    80001254:	00043503          	ld	a0,0(s0)
    80001258:	00840413          	add	s0,s0,8
    8000125c:	185040ef          	jal	80005be0 <free_proc>
    80001260:	fe941ae3          	bne	s0,s1,80001254 <test_uid_limits+0x144>
    80001264:	0a013403          	ld	s0,160(sp)
    80001268:	0a813083          	ld	ra,168(sp)
    8000126c:	09813483          	ld	s1,152(sp)
    80001270:	09013903          	ld	s2,144(sp)
    80001274:	08813983          	ld	s3,136(sp)
    80001278:	08013a03          	ld	s4,128(sp)
    8000127c:	07813a83          	ld	s5,120(sp)
    80001280:	07013b03          	ld	s6,112(sp)
    80001284:	06813b83          	ld	s7,104(sp)
    80001288:	06013c03          	ld	s8,96(sp)
    8000128c:	05813c83          	ld	s9,88(sp)
    80001290:	05013d03          	ld	s10,80(sp)
    80001294:	00008517          	auipc	a0,0x8
    80001298:	b1450513          	add	a0,a0,-1260 # 80008da8 <rodata_start+0xda8>
    8000129c:	0b010113          	add	sp,sp,176
    800012a0:	1390106f          	j	80002bd8 <uart_puts>
    800012a4:	00008517          	auipc	a0,0x8
    800012a8:	aac50513          	add	a0,a0,-1364 # 80008d50 <rodata_start+0xd50>
    800012ac:	12d010ef          	jal	80002bd8 <uart_puts>
    800012b0:	f91ff06f          	j	80001240 <test_uid_limits+0x130>
    800012b4:	00442583          	lw	a1,4(s0)
    800012b8:	00008517          	auipc	a0,0x8
    800012bc:	92050513          	add	a0,a0,-1760 # 80008bd8 <rodata_start+0xbd8>
    800012c0:	5a8010ef          	jal	80002868 <printf>
    800012c4:	ed5ff06f          	j	80001198 <test_uid_limits+0x88>
    800012c8:	000d0593          	mv	a1,s10
    800012cc:	00008517          	auipc	a0,0x8
    800012d0:	97450513          	add	a0,a0,-1676 # 80008c40 <rodata_start+0xc40>
    800012d4:	594010ef          	jal	80002868 <printf>
    800012d8:	00008517          	auipc	a0,0x8
    800012dc:	a6050513          	add	a0,a0,-1440 # 80008d38 <rodata_start+0xd38>
    800012e0:	588010ef          	jal	80002868 <printf>
    800012e4:	00100513          	li	a0,1
    800012e8:	00090b93          	mv	s7,s2
    800012ec:	35d040ef          	jal	80005e48 <can_fork>
    800012f0:	f40512e3          	bnez	a0,80001234 <test_uid_limits+0x124>
    800012f4:	fb1ff06f          	j	800012a4 <test_uid_limits+0x194>
    800012f8:	00c42603          	lw	a2,12(s0)
    800012fc:	fff4869b          	addw	a3,s1,-1
    80001300:	00008517          	auipc	a0,0x8
    80001304:	97050513          	add	a0,a0,-1680 # 80008c70 <rodata_start+0xc70>
    80001308:	560010ef          	jal	80002868 <printf>
    8000130c:	00040513          	mv	a0,s0
    80001310:	0d1040ef          	jal	80005be0 <free_proc>
    80001314:	00008517          	auipc	a0,0x8
    80001318:	a2450513          	add	a0,a0,-1500 # 80008d38 <rodata_start+0xd38>
    8000131c:	54c010ef          	jal	80002868 <printf>
    80001320:	00100513          	li	a0,1
    80001324:	00090b93          	mv	s7,s2
    80001328:	321040ef          	jal	80005e48 <can_fork>
    8000132c:	f00514e3          	bnez	a0,80001234 <test_uid_limits+0x124>
    80001330:	f75ff06f          	j	800012a4 <test_uid_limits+0x194>
    80001334:	00c42583          	lw	a1,12(s0)
    80001338:	00400613          	li	a2,4
    8000133c:	00008517          	auipc	a0,0x8
    80001340:	9cc50513          	add	a0,a0,-1588 # 80008d08 <rodata_start+0xd08>
    80001344:	524010ef          	jal	80002868 <printf>
    80001348:	00008517          	auipc	a0,0x8
    8000134c:	9f050513          	add	a0,a0,-1552 # 80008d38 <rodata_start+0xd38>
    80001350:	518010ef          	jal	80002868 <printf>
    80001354:	00100513          	li	a0,1
    80001358:	00090b93          	mv	s7,s2
    8000135c:	2ed040ef          	jal	80005e48 <can_fork>
    80001360:	ec051ae3          	bnez	a0,80001234 <test_uid_limits+0x124>
    80001364:	f41ff06f          	j	800012a4 <test_uid_limits+0x194>

0000000080001368 <run_process_management_tests>:
    80001368:	ff010113          	add	sp,sp,-16
    8000136c:	00008517          	auipc	a0,0x8
    80001370:	57c50513          	add	a0,a0,1404 # 800098e8 <rodata_start+0x18e8>
    80001374:	00113423          	sd	ra,8(sp)
    80001378:	061010ef          	jal	80002bd8 <uart_puts>
    8000137c:	00008517          	auipc	a0,0x8
    80001380:	a4c50513          	add	a0,a0,-1460 # 80008dc8 <rodata_start+0xdc8>
    80001384:	055010ef          	jal	80002bd8 <uart_puts>
    80001388:	00008517          	auipc	a0,0x8
    8000138c:	b0850513          	add	a0,a0,-1272 # 80008e90 <rodata_start+0xe90>
    80001390:	049010ef          	jal	80002bd8 <uart_puts>
    80001394:	00008517          	auipc	a0,0x8
    80001398:	b5c50513          	add	a0,a0,-1188 # 80008ef0 <rodata_start+0xef0>
    8000139c:	03d010ef          	jal	80002bd8 <uart_puts>
    800013a0:	e04ff0ef          	jal	800009a4 <test_process_allocation>
    800013a4:	f2cff0ef          	jal	80000ad0 <test_process_find>
    800013a8:	809ff0ef          	jal	80000bb0 <test_process_state_transition>
    800013ac:	925ff0ef          	jal	80000cd0 <test_simple_fork>
    800013b0:	b15ff0ef          	jal	80000ec4 <test_process_memory>
    800013b4:	c51ff0ef          	jal	80001004 <test_growproc>
    800013b8:	d59ff0ef          	jal	80001110 <test_uid_limits>
    800013bc:	a25ff0ef          	jal	80000de0 <test_scheduler_basic>
    800013c0:	00008517          	auipc	a0,0x8
    800013c4:	52850513          	add	a0,a0,1320 # 800098e8 <rodata_start+0x18e8>
    800013c8:	011010ef          	jal	80002bd8 <uart_puts>
    800013cc:	00008517          	auipc	a0,0x8
    800013d0:	9fc50513          	add	a0,a0,-1540 # 80008dc8 <rodata_start+0xdc8>
    800013d4:	005010ef          	jal	80002bd8 <uart_puts>
    800013d8:	00008517          	auipc	a0,0x8
    800013dc:	be050513          	add	a0,a0,-1056 # 80008fb8 <rodata_start+0xfb8>
    800013e0:	7f8010ef          	jal	80002bd8 <uart_puts>
    800013e4:	00008517          	auipc	a0,0x8
    800013e8:	c2c50513          	add	a0,a0,-980 # 80009010 <rodata_start+0x1010>
    800013ec:	7ec010ef          	jal	80002bd8 <uart_puts>
    800013f0:	00008517          	auipc	a0,0x8
    800013f4:	cf050513          	add	a0,a0,-784 # 800090e0 <rodata_start+0x10e0>
    800013f8:	7e0010ef          	jal	80002bd8 <uart_puts>
    800013fc:	00008517          	auipc	a0,0x8
    80001400:	cfc50513          	add	a0,a0,-772 # 800090f8 <rodata_start+0x10f8>
    80001404:	7d4010ef          	jal	80002bd8 <uart_puts>
    80001408:	00008517          	auipc	a0,0x8
    8000140c:	d4050513          	add	a0,a0,-704 # 80009148 <rodata_start+0x1148>
    80001410:	7c8010ef          	jal	80002bd8 <uart_puts>
    80001414:	00008517          	auipc	a0,0x8
    80001418:	d5450513          	add	a0,a0,-684 # 80009168 <rodata_start+0x1168>
    8000141c:	7bc010ef          	jal	80002bd8 <uart_puts>
    80001420:	00008517          	auipc	a0,0x8
    80001424:	d6850513          	add	a0,a0,-664 # 80009188 <rodata_start+0x1188>
    80001428:	7b0010ef          	jal	80002bd8 <uart_puts>
    8000142c:	00008517          	auipc	a0,0x8
    80001430:	d8c50513          	add	a0,a0,-628 # 800091b8 <rodata_start+0x11b8>
    80001434:	7a4010ef          	jal	80002bd8 <uart_puts>
    80001438:	00008517          	auipc	a0,0x8
    8000143c:	db050513          	add	a0,a0,-592 # 800091e8 <rodata_start+0x11e8>
    80001440:	798010ef          	jal	80002bd8 <uart_puts>
    80001444:	00008517          	auipc	a0,0x8
    80001448:	dc450513          	add	a0,a0,-572 # 80009208 <rodata_start+0x1208>
    8000144c:	78c010ef          	jal	80002bd8 <uart_puts>
    80001450:	00813083          	ld	ra,8(sp)
    80001454:	00008517          	auipc	a0,0x8
    80001458:	ddc50513          	add	a0,a0,-548 # 80009230 <rodata_start+0x1230>
    8000145c:	01010113          	add	sp,sp,16
    80001460:	7780106f          	j	80002bd8 <uart_puts>

0000000080001464 <test_round_robin_scheduler>:
    80001464:	fa010113          	add	sp,sp,-96
    80001468:	04813823          	sd	s0,80(sp)
    8000146c:	00008517          	auipc	a0,0x8
    80001470:	de450513          	add	a0,a0,-540 # 80009250 <rodata_start+0x1250>
    80001474:	00810413          	add	s0,sp,8
    80001478:	04913423          	sd	s1,72(sp)
    8000147c:	05213023          	sd	s2,64(sp)
    80001480:	03313c23          	sd	s3,56(sp)
    80001484:	03413823          	sd	s4,48(sp)
    80001488:	03513423          	sd	s5,40(sp)
    8000148c:	03613023          	sd	s6,32(sp)
    80001490:	04113c23          	sd	ra,88(sp)
    80001494:	00040913          	mv	s2,s0
    80001498:	740010ef          	jal	80002bd8 <uart_puts>
    8000149c:	00000493          	li	s1,0
    800014a0:	fffffb17          	auipc	s6,0xfffff
    800014a4:	be0b0b13          	add	s6,s6,-1056 # 80000080 <rr_worker>
    800014a8:	00200a93          	li	s5,2
    800014ac:	00008a17          	auipc	s4,0x8
    800014b0:	e0ca0a13          	add	s4,s4,-500 # 800092b8 <rodata_start+0x12b8>
    800014b4:	00300993          	li	s3,3
    800014b8:	568040ef          	jal	80005a20 <alloc_proc>
    800014bc:	00050793          	mv	a5,a0
    800014c0:	00a93023          	sd	a0,0(s2)
    800014c4:	000a0513          	mv	a0,s4
    800014c8:	06078c63          	beqz	a5,80001540 <test_round_robin_scheduler+0xdc>
    800014cc:	0047a583          	lw	a1,4(a5)
    800014d0:	0567b023          	sd	s6,64(a5)
    800014d4:	0157a023          	sw	s5,0(a5)
    800014d8:	390010ef          	jal	80002868 <printf>
    800014dc:	0014849b          	addw	s1,s1,1
    800014e0:	00890913          	add	s2,s2,8
    800014e4:	fd349ae3          	bne	s1,s3,800014b8 <test_round_robin_scheduler+0x54>
    800014e8:	00008517          	auipc	a0,0x8
    800014ec:	df050513          	add	a0,a0,-528 # 800092d8 <rodata_start+0x12d8>
    800014f0:	6e8010ef          	jal	80002bd8 <uart_puts>
    800014f4:	01840493          	add	s1,s0,24
    800014f8:	369040ef          	jal	80006060 <scheduler>
    800014fc:	00043503          	ld	a0,0(s0)
    80001500:	00840413          	add	s0,s0,8
    80001504:	00050463          	beqz	a0,8000150c <test_round_robin_scheduler+0xa8>
    80001508:	6d8040ef          	jal	80005be0 <free_proc>
    8000150c:	fe9418e3          	bne	s0,s1,800014fc <test_round_robin_scheduler+0x98>
    80001510:	05013403          	ld	s0,80(sp)
    80001514:	05813083          	ld	ra,88(sp)
    80001518:	04813483          	ld	s1,72(sp)
    8000151c:	04013903          	ld	s2,64(sp)
    80001520:	03813983          	ld	s3,56(sp)
    80001524:	03013a03          	ld	s4,48(sp)
    80001528:	02813a83          	ld	s5,40(sp)
    8000152c:	02013b03          	ld	s6,32(sp)
    80001530:	00008517          	auipc	a0,0x8
    80001534:	de850513          	add	a0,a0,-536 # 80009318 <rodata_start+0x1318>
    80001538:	06010113          	add	sp,sp,96
    8000153c:	69c0106f          	j	80002bd8 <uart_puts>
    80001540:	00048593          	mv	a1,s1
    80001544:	00008517          	auipc	a0,0x8
    80001548:	d5450513          	add	a0,a0,-684 # 80009298 <rodata_start+0x1298>
    8000154c:	31c010ef          	jal	80002868 <printf>
    80001550:	f8dff06f          	j	800014dc <test_round_robin_scheduler+0x78>

0000000080001554 <test_producer_consumer>:
    80001554:	ff010113          	add	sp,sp,-16
    80001558:	00008517          	auipc	a0,0x8
    8000155c:	39050513          	add	a0,a0,912 # 800098e8 <rodata_start+0x18e8>
    80001560:	00113423          	sd	ra,8(sp)
    80001564:	00813023          	sd	s0,0(sp)
    80001568:	670010ef          	jal	80002bd8 <uart_puts>
    8000156c:	00008517          	auipc	a0,0x8
    80001570:	85c50513          	add	a0,a0,-1956 # 80008dc8 <rodata_start+0xdc8>
    80001574:	664010ef          	jal	80002bd8 <uart_puts>
    80001578:	00008517          	auipc	a0,0x8
    8000157c:	dc850513          	add	a0,a0,-568 # 80009340 <rodata_start+0x1340>
    80001580:	658010ef          	jal	80002bd8 <uart_puts>
    80001584:	00008517          	auipc	a0,0x8
    80001588:	a8c50513          	add	a0,a0,-1396 # 80009010 <rodata_start+0x1010>
    8000158c:	64c010ef          	jal	80002bd8 <uart_puts>
    80001590:	00500593          	li	a1,5
    80001594:	00008517          	auipc	a0,0x8
    80001598:	e0450513          	add	a0,a0,-508 # 80009398 <rodata_start+0x1398>
    8000159c:	2cc010ef          	jal	80002868 <printf>
    800015a0:	00008517          	auipc	a0,0x8
    800015a4:	e1050513          	add	a0,a0,-496 # 800093b0 <rodata_start+0x13b0>
    800015a8:	2c0010ef          	jal	80002868 <printf>
    800015ac:	00300593          	li	a1,3
    800015b0:	00008517          	auipc	a0,0x8
    800015b4:	e2850513          	add	a0,a0,-472 # 800093d8 <rodata_start+0x13d8>
    800015b8:	2b0010ef          	jal	80002868 <printf>
    800015bc:	00300593          	li	a1,3
    800015c0:	00008517          	auipc	a0,0x8
    800015c4:	e4050513          	add	a0,a0,-448 # 80009400 <rodata_start+0x1400>
    800015c8:	2a0010ef          	jal	80002868 <printf>
    800015cc:	00500593          	li	a1,5
    800015d0:	00010517          	auipc	a0,0x10
    800015d4:	a8850513          	add	a0,a0,-1400 # 80011058 <empty>
    800015d8:	29c050ef          	jal	80006874 <sem_init>
    800015dc:	00010417          	auipc	s0,0x10
    800015e0:	a2440413          	add	s0,s0,-1500 # 80011000 <full>
    800015e4:	00000593          	li	a1,0
    800015e8:	00040513          	mv	a0,s0
    800015ec:	288050ef          	jal	80006874 <sem_init>
    800015f0:	00100593          	li	a1,1
    800015f4:	00010517          	auipc	a0,0x10
    800015f8:	a2c50513          	add	a0,a0,-1492 # 80011020 <mutex>
    800015fc:	278050ef          	jal	80006874 <sem_init>
    80001600:	02042683          	lw	a3,32(s0)
    80001604:	00042603          	lw	a2,0(s0)
    80001608:	05842583          	lw	a1,88(s0)
    8000160c:	00008517          	auipc	a0,0x8
    80001610:	e1c50513          	add	a0,a0,-484 # 80009428 <rodata_start+0x1428>
    80001614:	254010ef          	jal	80002868 <printf>
    80001618:	408040ef          	jal	80005a20 <alloc_proc>
    8000161c:	02050463          	beqz	a0,80001644 <test_producer_consumer+0xf0>
    80001620:	fffff797          	auipc	a5,0xfffff
    80001624:	c5078793          	add	a5,a5,-944 # 80000270 <producer>
    80001628:	00452583          	lw	a1,4(a0)
    8000162c:	04f53023          	sd	a5,64(a0)
    80001630:	00200793          	li	a5,2
    80001634:	00f52023          	sw	a5,0(a0)
    80001638:	00008517          	auipc	a0,0x8
    8000163c:	e2850513          	add	a0,a0,-472 # 80009460 <rodata_start+0x1460>
    80001640:	228010ef          	jal	80002868 <printf>
    80001644:	3dc040ef          	jal	80005a20 <alloc_proc>
    80001648:	02050463          	beqz	a0,80001670 <test_producer_consumer+0x11c>
    8000164c:	fffff797          	auipc	a5,0xfffff
    80001650:	c2478793          	add	a5,a5,-988 # 80000270 <producer>
    80001654:	00452583          	lw	a1,4(a0)
    80001658:	04f53023          	sd	a5,64(a0)
    8000165c:	00200793          	li	a5,2
    80001660:	00f52023          	sw	a5,0(a0)
    80001664:	00008517          	auipc	a0,0x8
    80001668:	dfc50513          	add	a0,a0,-516 # 80009460 <rodata_start+0x1460>
    8000166c:	1fc010ef          	jal	80002868 <printf>
    80001670:	3b0040ef          	jal	80005a20 <alloc_proc>
    80001674:	02050463          	beqz	a0,8000169c <test_producer_consumer+0x148>
    80001678:	fffff797          	auipc	a5,0xfffff
    8000167c:	ab478793          	add	a5,a5,-1356 # 8000012c <consumer>
    80001680:	00452583          	lw	a1,4(a0)
    80001684:	04f53023          	sd	a5,64(a0)
    80001688:	00200793          	li	a5,2
    8000168c:	00f52023          	sw	a5,0(a0)
    80001690:	00008517          	auipc	a0,0x8
    80001694:	df050513          	add	a0,a0,-528 # 80009480 <rodata_start+0x1480>
    80001698:	1d0010ef          	jal	80002868 <printf>
    8000169c:	384040ef          	jal	80005a20 <alloc_proc>
    800016a0:	02050463          	beqz	a0,800016c8 <test_producer_consumer+0x174>
    800016a4:	fffff797          	auipc	a5,0xfffff
    800016a8:	a8878793          	add	a5,a5,-1400 # 8000012c <consumer>
    800016ac:	00452583          	lw	a1,4(a0)
    800016b0:	04f53023          	sd	a5,64(a0)
    800016b4:	00200793          	li	a5,2
    800016b8:	00f52023          	sw	a5,0(a0)
    800016bc:	00008517          	auipc	a0,0x8
    800016c0:	dc450513          	add	a0,a0,-572 # 80009480 <rodata_start+0x1480>
    800016c4:	1a4010ef          	jal	80002868 <printf>
    800016c8:	00008517          	auipc	a0,0x8
    800016cc:	dd850513          	add	a0,a0,-552 # 800094a0 <rodata_start+0x14a0>
    800016d0:	508010ef          	jal	80002bd8 <uart_puts>
    800016d4:	00013403          	ld	s0,0(sp)
    800016d8:	00813083          	ld	ra,8(sp)
    800016dc:	01010113          	add	sp,sp,16
    800016e0:	1810406f          	j	80006060 <scheduler>

00000000800016e4 <test_reader_writer>:
    800016e4:	fd010113          	add	sp,sp,-48
    800016e8:	00008517          	auipc	a0,0x8
    800016ec:	20050513          	add	a0,a0,512 # 800098e8 <rodata_start+0x18e8>
    800016f0:	02113423          	sd	ra,40(sp)
    800016f4:	02813023          	sd	s0,32(sp)
    800016f8:	00913c23          	sd	s1,24(sp)
    800016fc:	01213823          	sd	s2,16(sp)
    80001700:	01313423          	sd	s3,8(sp)
    80001704:	4d4010ef          	jal	80002bd8 <uart_puts>
    80001708:	00007517          	auipc	a0,0x7
    8000170c:	6c050513          	add	a0,a0,1728 # 80008dc8 <rodata_start+0xdc8>
    80001710:	4c8010ef          	jal	80002bd8 <uart_puts>
    80001714:	00008517          	auipc	a0,0x8
    80001718:	db450513          	add	a0,a0,-588 # 800094c8 <rodata_start+0x14c8>
    8000171c:	4bc010ef          	jal	80002bd8 <uart_puts>
    80001720:	00008517          	auipc	a0,0x8
    80001724:	8f050513          	add	a0,a0,-1808 # 80009010 <rodata_start+0x1010>
    80001728:	4b0010ef          	jal	80002bd8 <uart_puts>
    8000172c:	00426597          	auipc	a1,0x426
    80001730:	5785a583          	lw	a1,1400(a1) # 80427ca4 <shared_data>
    80001734:	00008517          	auipc	a0,0x8
    80001738:	df450513          	add	a0,a0,-524 # 80009528 <rodata_start+0x1528>
    8000173c:	12c010ef          	jal	80002868 <printf>
    80001740:	00008517          	auipc	a0,0x8
    80001744:	e0850513          	add	a0,a0,-504 # 80009548 <rodata_start+0x1548>
    80001748:	120010ef          	jal	80002868 <printf>
    8000174c:	00300593          	li	a1,3
    80001750:	00008517          	auipc	a0,0x8
    80001754:	e2050513          	add	a0,a0,-480 # 80009570 <rodata_start+0x1570>
    80001758:	110010ef          	jal	80002868 <printf>
    8000175c:	00200593          	li	a1,2
    80001760:	00008517          	auipc	a0,0x8
    80001764:	e3050513          	add	a0,a0,-464 # 80009590 <rodata_start+0x1590>
    80001768:	100010ef          	jal	80002868 <printf>
    8000176c:	00100593          	li	a1,1
    80001770:	00010517          	auipc	a0,0x10
    80001774:	90850513          	add	a0,a0,-1784 # 80011078 <rw_mutex>
    80001778:	0fc050ef          	jal	80006874 <sem_init>
    8000177c:	00100593          	li	a1,1
    80001780:	00010517          	auipc	a0,0x10
    80001784:	91850513          	add	a0,a0,-1768 # 80011098 <read_mutex>
    80001788:	0ec050ef          	jal	80006874 <sem_init>
    8000178c:	00100593          	li	a1,1
    80001790:	00010517          	auipc	a0,0x10
    80001794:	9c850513          	add	a0,a0,-1592 # 80011158 <write_mutex>
    80001798:	0dc050ef          	jal	80006874 <sem_init>
    8000179c:	00010797          	auipc	a5,0x10
    800017a0:	86478793          	add	a5,a5,-1948 # 80011000 <full>
    800017a4:	0987a603          	lw	a2,152(a5)
    800017a8:	0787a583          	lw	a1,120(a5)
    800017ac:	00008517          	auipc	a0,0x8
    800017b0:	e0450513          	add	a0,a0,-508 # 800095b0 <rodata_start+0x15b0>
    800017b4:	00300413          	li	s0,3
    800017b8:	0b0010ef          	jal	80002868 <printf>
    800017bc:	00008517          	auipc	a0,0x8
    800017c0:	e2c50513          	add	a0,a0,-468 # 800095e8 <rodata_start+0x15e8>
    800017c4:	414010ef          	jal	80002bd8 <uart_puts>
    800017c8:	00008517          	auipc	a0,0x8
    800017cc:	e3050513          	add	a0,a0,-464 # 800095f8 <rodata_start+0x15f8>
    800017d0:	408010ef          	jal	80002bd8 <uart_puts>
    800017d4:	00008517          	auipc	a0,0x8
    800017d8:	e5c50513          	add	a0,a0,-420 # 80009630 <rodata_start+0x1630>
    800017dc:	3fc010ef          	jal	80002bd8 <uart_puts>
    800017e0:	00008517          	auipc	a0,0x8
    800017e4:	e8850513          	add	a0,a0,-376 # 80009668 <rodata_start+0x1668>
    800017e8:	3f0010ef          	jal	80002bd8 <uart_puts>
    800017ec:	fffff997          	auipc	s3,0xfffff
    800017f0:	d5098993          	add	s3,s3,-688 # 8000053c <reader>
    800017f4:	00200913          	li	s2,2
    800017f8:	00008497          	auipc	s1,0x8
    800017fc:	eb048493          	add	s1,s1,-336 # 800096a8 <rodata_start+0x16a8>
    80001800:	220040ef          	jal	80005a20 <alloc_proc>
    80001804:	00050793          	mv	a5,a0
    80001808:	fff4041b          	addw	s0,s0,-1
    8000180c:	00048513          	mv	a0,s1
    80001810:	00078a63          	beqz	a5,80001824 <test_reader_writer+0x140>
    80001814:	0047a583          	lw	a1,4(a5)
    80001818:	0537b023          	sd	s3,64(a5)
    8000181c:	0127a023          	sw	s2,0(a5)
    80001820:	048010ef          	jal	80002868 <printf>
    80001824:	fc041ee3          	bnez	s0,80001800 <test_reader_writer+0x11c>
    80001828:	1f8040ef          	jal	80005a20 <alloc_proc>
    8000182c:	02050463          	beqz	a0,80001854 <test_reader_writer+0x170>
    80001830:	fffff797          	auipc	a5,0xfffff
    80001834:	ba878793          	add	a5,a5,-1112 # 800003d8 <writer>
    80001838:	00452583          	lw	a1,4(a0)
    8000183c:	04f53023          	sd	a5,64(a0)
    80001840:	00200793          	li	a5,2
    80001844:	00f52023          	sw	a5,0(a0)
    80001848:	00008517          	auipc	a0,0x8
    8000184c:	e8050513          	add	a0,a0,-384 # 800096c8 <rodata_start+0x16c8>
    80001850:	018010ef          	jal	80002868 <printf>
    80001854:	1cc040ef          	jal	80005a20 <alloc_proc>
    80001858:	02050463          	beqz	a0,80001880 <test_reader_writer+0x19c>
    8000185c:	fffff797          	auipc	a5,0xfffff
    80001860:	b7c78793          	add	a5,a5,-1156 # 800003d8 <writer>
    80001864:	00452583          	lw	a1,4(a0)
    80001868:	04f53023          	sd	a5,64(a0)
    8000186c:	00200793          	li	a5,2
    80001870:	00f52023          	sw	a5,0(a0)
    80001874:	00008517          	auipc	a0,0x8
    80001878:	e5450513          	add	a0,a0,-428 # 800096c8 <rodata_start+0x16c8>
    8000187c:	7ed000ef          	jal	80002868 <printf>
    80001880:	00008517          	auipc	a0,0x8
    80001884:	e6850513          	add	a0,a0,-408 # 800096e8 <rodata_start+0x16e8>
    80001888:	350010ef          	jal	80002bd8 <uart_puts>
    8000188c:	02013403          	ld	s0,32(sp)
    80001890:	02813083          	ld	ra,40(sp)
    80001894:	01813483          	ld	s1,24(sp)
    80001898:	01013903          	ld	s2,16(sp)
    8000189c:	00813983          	ld	s3,8(sp)
    800018a0:	03010113          	add	sp,sp,48
    800018a4:	7bc0406f          	j	80006060 <scheduler>

00000000800018a8 <test_dining_philosophers>:
    800018a8:	fd010113          	add	sp,sp,-48
    800018ac:	00008517          	auipc	a0,0x8
    800018b0:	03c50513          	add	a0,a0,60 # 800098e8 <rodata_start+0x18e8>
    800018b4:	02113423          	sd	ra,40(sp)
    800018b8:	02813023          	sd	s0,32(sp)
    800018bc:	00913c23          	sd	s1,24(sp)
    800018c0:	01213823          	sd	s2,16(sp)
    800018c4:	01313423          	sd	s3,8(sp)
    800018c8:	01413023          	sd	s4,0(sp)
    800018cc:	30c010ef          	jal	80002bd8 <uart_puts>
    800018d0:	00007517          	auipc	a0,0x7
    800018d4:	4f850513          	add	a0,a0,1272 # 80008dc8 <rodata_start+0xdc8>
    800018d8:	300010ef          	jal	80002bd8 <uart_puts>
    800018dc:	00008517          	auipc	a0,0x8
    800018e0:	e2c50513          	add	a0,a0,-468 # 80009708 <rodata_start+0x1708>
    800018e4:	2f4010ef          	jal	80002bd8 <uart_puts>
    800018e8:	00007517          	auipc	a0,0x7
    800018ec:	72850513          	add	a0,a0,1832 # 80009010 <rodata_start+0x1010>
    800018f0:	2e8010ef          	jal	80002bd8 <uart_puts>
    800018f4:	00500593          	li	a1,5
    800018f8:	00008517          	auipc	a0,0x8
    800018fc:	e6850513          	add	a0,a0,-408 # 80009760 <rodata_start+0x1760>
    80001900:	769000ef          	jal	80002868 <printf>
    80001904:	00200593          	li	a1,2
    80001908:	00008517          	auipc	a0,0x8
    8000190c:	e7050513          	add	a0,a0,-400 # 80009778 <rodata_start+0x1778>
    80001910:	759000ef          	jal	80002868 <printf>
    80001914:	0000f497          	auipc	s1,0xf
    80001918:	7a448493          	add	s1,s1,1956 # 800110b8 <forks>
    8000191c:	00000413          	li	s0,0
    80001920:	00008997          	auipc	s3,0x8
    80001924:	e7898993          	add	s3,s3,-392 # 80009798 <rodata_start+0x1798>
    80001928:	00500913          	li	s2,5
    8000192c:	00048513          	mv	a0,s1
    80001930:	00100593          	li	a1,1
    80001934:	741040ef          	jal	80006874 <sem_init>
    80001938:	00040593          	mv	a1,s0
    8000193c:	00098513          	mv	a0,s3
    80001940:	0014041b          	addw	s0,s0,1
    80001944:	725000ef          	jal	80002868 <printf>
    80001948:	02048493          	add	s1,s1,32
    8000194c:	ff2410e3          	bne	s0,s2,8000192c <test_dining_philosophers+0x84>
    80001950:	00008517          	auipc	a0,0x8
    80001954:	e6050513          	add	a0,a0,-416 # 800097b0 <rodata_start+0x17b0>
    80001958:	280010ef          	jal	80002bd8 <uart_puts>
    8000195c:	00008517          	auipc	a0,0x8
    80001960:	e6450513          	add	a0,a0,-412 # 800097c0 <rodata_start+0x17c0>
    80001964:	274010ef          	jal	80002bd8 <uart_puts>
    80001968:	00008517          	auipc	a0,0x8
    8000196c:	e8050513          	add	a0,a0,-384 # 800097e8 <rodata_start+0x17e8>
    80001970:	268010ef          	jal	80002bd8 <uart_puts>
    80001974:	00008517          	auipc	a0,0x8
    80001978:	eac50513          	add	a0,a0,-340 # 80009820 <rodata_start+0x1820>
    8000197c:	25c010ef          	jal	80002bd8 <uart_puts>
    80001980:	00008517          	auipc	a0,0x8
    80001984:	ee050513          	add	a0,a0,-288 # 80009860 <rodata_start+0x1860>
    80001988:	250010ef          	jal	80002bd8 <uart_puts>
    8000198c:	00000413          	li	s0,0
    80001990:	fffffa17          	auipc	s4,0xfffff
    80001994:	d74a0a13          	add	s4,s4,-652 # 80000704 <philosopher>
    80001998:	00200993          	li	s3,2
    8000199c:	00008917          	auipc	s2,0x8
    800019a0:	efc90913          	add	s2,s2,-260 # 80009898 <rodata_start+0x1898>
    800019a4:	00500493          	li	s1,5
    800019a8:	078040ef          	jal	80005a20 <alloc_proc>
    800019ac:	00050793          	mv	a5,a0
    800019b0:	00040613          	mv	a2,s0
    800019b4:	00090513          	mv	a0,s2
    800019b8:	0014041b          	addw	s0,s0,1
    800019bc:	00078a63          	beqz	a5,800019d0 <test_dining_philosophers+0x128>
    800019c0:	0047a583          	lw	a1,4(a5)
    800019c4:	0547b023          	sd	s4,64(a5)
    800019c8:	0137a023          	sw	s3,0(a5)
    800019cc:	69d000ef          	jal	80002868 <printf>
    800019d0:	fc941ce3          	bne	s0,s1,800019a8 <test_dining_philosophers+0x100>
    800019d4:	00008517          	auipc	a0,0x8
    800019d8:	ef450513          	add	a0,a0,-268 # 800098c8 <rodata_start+0x18c8>
    800019dc:	1fc010ef          	jal	80002bd8 <uart_puts>
    800019e0:	02013403          	ld	s0,32(sp)
    800019e4:	02813083          	ld	ra,40(sp)
    800019e8:	01813483          	ld	s1,24(sp)
    800019ec:	01013903          	ld	s2,16(sp)
    800019f0:	00813983          	ld	s3,8(sp)
    800019f4:	00013a03          	ld	s4,0(sp)
    800019f8:	03010113          	add	sp,sp,48
    800019fc:	6640406f          	j	80006060 <scheduler>

0000000080001a00 <test_trap_initialization>:
    80001a00:	ff010113          	add	sp,sp,-16
    80001a04:	00008517          	auipc	a0,0x8
    80001a08:	eec50513          	add	a0,a0,-276 # 800098f0 <rodata_start+0x18f0>
    80001a0c:	00113423          	sd	ra,8(sp)
    80001a10:	00813023          	sd	s0,0(sp)
    80001a14:	1c4010ef          	jal	80002bd8 <uart_puts>
    80001a18:	171030ef          	jal	80005388 <trap_init>
    80001a1c:	21d030ef          	jal	80005438 <trap_init_hart>
    80001a20:	10502473          	csrr	s0,stvec
    80001a24:	00008517          	auipc	a0,0x8
    80001a28:	f0c50513          	add	a0,a0,-244 # 80009930 <rodata_start+0x1930>
    80001a2c:	00040593          	mv	a1,s0
    80001a30:	639000ef          	jal	80002868 <printf>
    80001a34:	02040c63          	beqz	s0,80001a6c <test_trap_initialization+0x6c>
    80001a38:	00008517          	auipc	a0,0x8
    80001a3c:	f1850513          	add	a0,a0,-232 # 80009950 <rodata_start+0x1950>
    80001a40:	198010ef          	jal	80002bd8 <uart_puts>
    80001a44:	104025f3          	csrr	a1,sie
    80001a48:	00008517          	auipc	a0,0x8
    80001a4c:	f5050513          	add	a0,a0,-176 # 80009998 <rodata_start+0x1998>
    80001a50:	619000ef          	jal	80002868 <printf>
    80001a54:	00013403          	ld	s0,0(sp)
    80001a58:	00813083          	ld	ra,8(sp)
    80001a5c:	00008517          	auipc	a0,0x8
    80001a60:	f6c50513          	add	a0,a0,-148 # 800099c8 <rodata_start+0x19c8>
    80001a64:	01010113          	add	sp,sp,16
    80001a68:	1700106f          	j	80002bd8 <uart_puts>
    80001a6c:	00008517          	auipc	a0,0x8
    80001a70:	f0450513          	add	a0,a0,-252 # 80009970 <rodata_start+0x1970>
    80001a74:	164010ef          	jal	80002bd8 <uart_puts>
    80001a78:	fcdff06f          	j	80001a44 <test_trap_initialization+0x44>

0000000080001a7c <test_interrupt_control>:
    80001a7c:	ff010113          	add	sp,sp,-16
    80001a80:	00008517          	auipc	a0,0x8
    80001a84:	f6050513          	add	a0,a0,-160 # 800099e0 <rodata_start+0x19e0>
    80001a88:	00113423          	sd	ra,8(sp)
    80001a8c:	00813023          	sd	s0,0(sp)
    80001a90:	148010ef          	jal	80002bd8 <uart_puts>
    80001a94:	00008517          	auipc	a0,0x8
    80001a98:	f8c50513          	add	a0,a0,-116 # 80009a20 <rodata_start+0x1a20>
    80001a9c:	13c010ef          	jal	80002bd8 <uart_puts>
    80001aa0:	0bd030ef          	jal	8000535c <intr_off>
    80001aa4:	0c9030ef          	jal	8000536c <intr_get>
    80001aa8:	00050413          	mv	s0,a0
    80001aac:	00050593          	mv	a1,a0
    80001ab0:	00008517          	auipc	a0,0x8
    80001ab4:	f8850513          	add	a0,a0,-120 # 80009a38 <rodata_start+0x1a38>
    80001ab8:	5b1000ef          	jal	80002868 <printf>
    80001abc:	06041063          	bnez	s0,80001b1c <test_interrupt_control+0xa0>
    80001ac0:	00008517          	auipc	a0,0x8
    80001ac4:	f9850513          	add	a0,a0,-104 # 80009a58 <rodata_start+0x1a58>
    80001ac8:	110010ef          	jal	80002bd8 <uart_puts>
    80001acc:	00008517          	auipc	a0,0x8
    80001ad0:	fbc50513          	add	a0,a0,-68 # 80009a88 <rodata_start+0x1a88>
    80001ad4:	104010ef          	jal	80002bd8 <uart_puts>
    80001ad8:	075030ef          	jal	8000534c <intr_on>
    80001adc:	091030ef          	jal	8000536c <intr_get>
    80001ae0:	00050413          	mv	s0,a0
    80001ae4:	00050593          	mv	a1,a0
    80001ae8:	00008517          	auipc	a0,0x8
    80001aec:	fb850513          	add	a0,a0,-72 # 80009aa0 <rodata_start+0x1aa0>
    80001af0:	579000ef          	jal	80002868 <printf>
    80001af4:	02040c63          	beqz	s0,80001b2c <test_interrupt_control+0xb0>
    80001af8:	00008517          	auipc	a0,0x8
    80001afc:	fc850513          	add	a0,a0,-56 # 80009ac0 <rodata_start+0x1ac0>
    80001b00:	0d8010ef          	jal	80002bd8 <uart_puts>
    80001b04:	00013403          	ld	s0,0(sp)
    80001b08:	00813083          	ld	ra,8(sp)
    80001b0c:	00008517          	auipc	a0,0x8
    80001b10:	fe450513          	add	a0,a0,-28 # 80009af0 <rodata_start+0x1af0>
    80001b14:	01010113          	add	sp,sp,16
    80001b18:	0c00106f          	j	80002bd8 <uart_puts>
    80001b1c:	00008517          	auipc	a0,0x8
    80001b20:	f5450513          	add	a0,a0,-172 # 80009a70 <rodata_start+0x1a70>
    80001b24:	0b4010ef          	jal	80002bd8 <uart_puts>
    80001b28:	fa5ff06f          	j	80001acc <test_interrupt_control+0x50>
    80001b2c:	00008517          	auipc	a0,0x8
    80001b30:	fac50513          	add	a0,a0,-84 # 80009ad8 <rodata_start+0x1ad8>
    80001b34:	0a4010ef          	jal	80002bd8 <uart_puts>
    80001b38:	00013403          	ld	s0,0(sp)
    80001b3c:	00813083          	ld	ra,8(sp)
    80001b40:	00008517          	auipc	a0,0x8
    80001b44:	fb050513          	add	a0,a0,-80 # 80009af0 <rodata_start+0x1af0>
    80001b48:	01010113          	add	sp,sp,16
    80001b4c:	08c0106f          	j	80002bd8 <uart_puts>

0000000080001b50 <test_trapframe_allocation>:
    80001b50:	fe010113          	add	sp,sp,-32
    80001b54:	00008517          	auipc	a0,0x8
    80001b58:	fb450513          	add	a0,a0,-76 # 80009b08 <rodata_start+0x1b08>
    80001b5c:	00113c23          	sd	ra,24(sp)
    80001b60:	00813823          	sd	s0,16(sp)
    80001b64:	00913423          	sd	s1,8(sp)
    80001b68:	01213023          	sd	s2,0(sp)
    80001b6c:	06c010ef          	jal	80002bd8 <uart_puts>
    80001b70:	00008517          	auipc	a0,0x8
    80001b74:	fd850513          	add	a0,a0,-40 # 80009b48 <rodata_start+0x1b48>
    80001b78:	060010ef          	jal	80002bd8 <uart_puts>
    80001b7c:	72c030ef          	jal	800052a8 <alloc_trapframe>
    80001b80:	00050413          	mv	s0,a0
    80001b84:	724030ef          	jal	800052a8 <alloc_trapframe>
    80001b88:	00050493          	mv	s1,a0
    80001b8c:	71c030ef          	jal	800052a8 <alloc_trapframe>
    80001b90:	10040863          	beqz	s0,80001ca0 <test_trapframe_allocation+0x150>
    80001b94:	10048663          	beqz	s1,80001ca0 <test_trapframe_allocation+0x150>
    80001b98:	00050913          	mv	s2,a0
    80001b9c:	10050263          	beqz	a0,80001ca0 <test_trapframe_allocation+0x150>
    80001ba0:	00008517          	auipc	a0,0x8
    80001ba4:	fc050513          	add	a0,a0,-64 # 80009b60 <rodata_start+0x1b60>
    80001ba8:	4c1000ef          	jal	80002868 <printf>
    80001bac:	00040593          	mv	a1,s0
    80001bb0:	00008517          	auipc	a0,0x8
    80001bb4:	fd050513          	add	a0,a0,-48 # 80009b80 <rodata_start+0x1b80>
    80001bb8:	4b1000ef          	jal	80002868 <printf>
    80001bbc:	00048593          	mv	a1,s1
    80001bc0:	00008517          	auipc	a0,0x8
    80001bc4:	fd050513          	add	a0,a0,-48 # 80009b90 <rodata_start+0x1b90>
    80001bc8:	4a1000ef          	jal	80002868 <printf>
    80001bcc:	00090593          	mv	a1,s2
    80001bd0:	00008517          	auipc	a0,0x8
    80001bd4:	fd050513          	add	a0,a0,-48 # 80009ba0 <rodata_start+0x1ba0>
    80001bd8:	491000ef          	jal	80002868 <printf>
    80001bdc:	00940463          	beq	s0,s1,80001be4 <test_trapframe_allocation+0x94>
    80001be0:	0f249663          	bne	s1,s2,80001ccc <test_trapframe_allocation+0x17c>
    80001be4:	00008517          	auipc	a0,0x8
    80001be8:	fec50513          	add	a0,a0,-20 # 80009bd0 <rodata_start+0x1bd0>
    80001bec:	7ed000ef          	jal	80002bd8 <uart_puts>
    80001bf0:	00008517          	auipc	a0,0x8
    80001bf4:	01050513          	add	a0,a0,16 # 80009c00 <rodata_start+0x1c00>
    80001bf8:	7e1000ef          	jal	80002bd8 <uart_puts>
    80001bfc:	21d957b7          	lui	a5,0x21d95
    80001c00:	00279793          	sll	a5,a5,0x2
    80001c04:	32178793          	add	a5,a5,801 # 21d95321 <_entry-0x5e26acdf>
    80001c08:	12345737          	lui	a4,0x12345
    80001c0c:	67870713          	add	a4,a4,1656 # 12345678 <_entry-0x6dcba988>
    80001c10:	00f43823          	sd	a5,16(s0)
    80001c14:	02a00793          	li	a5,42
    80001c18:	00e43423          	sd	a4,8(s0)
    80001c1c:	04f43823          	sd	a5,80(s0)
    80001c20:	00008517          	auipc	a0,0x8
    80001c24:	00050513          	mv	a0,a0
    80001c28:	7b1000ef          	jal	80002bd8 <uart_puts>
    80001c2c:	00008517          	auipc	a0,0x8
    80001c30:	01450513          	add	a0,a0,20 # 80009c40 <rodata_start+0x1c40>
    80001c34:	7a5000ef          	jal	80002bd8 <uart_puts>
    80001c38:	00040513          	mv	a0,s0
    80001c3c:	6cc030ef          	jal	80005308 <free_trapframe>
    80001c40:	00048513          	mv	a0,s1
    80001c44:	6c4030ef          	jal	80005308 <free_trapframe>
    80001c48:	00090513          	mv	a0,s2
    80001c4c:	6bc030ef          	jal	80005308 <free_trapframe>
    80001c50:	00008517          	auipc	a0,0x8
    80001c54:	00850513          	add	a0,a0,8 # 80009c58 <rodata_start+0x1c58>
    80001c58:	781000ef          	jal	80002bd8 <uart_puts>
    80001c5c:	64c030ef          	jal	800052a8 <alloc_trapframe>
    80001c60:	00050413          	mv	s0,a0
    80001c64:	04050463          	beqz	a0,80001cac <test_trapframe_allocation+0x15c>
    80001c68:	00050593          	mv	a1,a0
    80001c6c:	00008517          	auipc	a0,0x8
    80001c70:	00c50513          	add	a0,a0,12 # 80009c78 <rodata_start+0x1c78>
    80001c74:	3f5000ef          	jal	80002868 <printf>
    80001c78:	00040513          	mv	a0,s0
    80001c7c:	68c030ef          	jal	80005308 <free_trapframe>
    80001c80:	01013403          	ld	s0,16(sp)
    80001c84:	01813083          	ld	ra,24(sp)
    80001c88:	00813483          	ld	s1,8(sp)
    80001c8c:	00013903          	ld	s2,0(sp)
    80001c90:	00008517          	auipc	a0,0x8
    80001c94:	03850513          	add	a0,a0,56 # 80009cc8 <rodata_start+0x1cc8>
    80001c98:	02010113          	add	sp,sp,32
    80001c9c:	73d0006f          	j	80002bd8 <uart_puts>
    80001ca0:	00008517          	auipc	a0,0x8
    80001ca4:	00850513          	add	a0,a0,8 # 80009ca8 <rodata_start+0x1ca8>
    80001ca8:	731000ef          	jal	80002bd8 <uart_puts>
    80001cac:	01013403          	ld	s0,16(sp)
    80001cb0:	01813083          	ld	ra,24(sp)
    80001cb4:	00813483          	ld	s1,8(sp)
    80001cb8:	00013903          	ld	s2,0(sp)
    80001cbc:	00008517          	auipc	a0,0x8
    80001cc0:	00c50513          	add	a0,a0,12 # 80009cc8 <rodata_start+0x1cc8>
    80001cc4:	02010113          	add	sp,sp,32
    80001cc8:	7110006f          	j	80002bd8 <uart_puts>
    80001ccc:	00008517          	auipc	a0,0x8
    80001cd0:	ee450513          	add	a0,a0,-284 # 80009bb0 <rodata_start+0x1bb0>
    80001cd4:	705000ef          	jal	80002bd8 <uart_puts>
    80001cd8:	f19ff06f          	j	80001bf0 <test_trapframe_allocation+0xa0>

0000000080001cdc <test_csr_operations>:
    80001cdc:	ff010113          	add	sp,sp,-16
    80001ce0:	00008517          	auipc	a0,0x8
    80001ce4:	00050513          	mv	a0,a0
    80001ce8:	00113423          	sd	ra,8(sp)
    80001cec:	00813023          	sd	s0,0(sp)
    80001cf0:	6e9000ef          	jal	80002bd8 <uart_puts>
    80001cf4:	10002473          	csrr	s0,sstatus
    80001cf8:	00008517          	auipc	a0,0x8
    80001cfc:	02050513          	add	a0,a0,32 # 80009d18 <rodata_start+0x1d18>
    80001d00:	00040593          	mv	a1,s0
    80001d04:	365000ef          	jal	80002868 <printf>
    80001d08:	142025f3          	csrr	a1,scause
    80001d0c:	00008517          	auipc	a0,0x8
    80001d10:	02450513          	add	a0,a0,36 # 80009d30 <rodata_start+0x1d30>
    80001d14:	355000ef          	jal	80002868 <printf>
    80001d18:	141025f3          	csrr	a1,sepc
    80001d1c:	00008517          	auipc	a0,0x8
    80001d20:	02c50513          	add	a0,a0,44 # 80009d48 <rodata_start+0x1d48>
    80001d24:	345000ef          	jal	80002868 <printf>
    80001d28:	00008517          	auipc	a0,0x8
    80001d2c:	03850513          	add	a0,a0,56 # 80009d60 <rodata_start+0x1d60>
    80001d30:	6a9000ef          	jal	80002bd8 <uart_puts>
    80001d34:	00000793          	li	a5,0
    80001d38:	10079073          	csrw	sstatus,a5
    80001d3c:	100025f3          	csrr	a1,sstatus
    80001d40:	00008517          	auipc	a0,0x8
    80001d44:	03850513          	add	a0,a0,56 # 80009d78 <rodata_start+0x1d78>
    80001d48:	321000ef          	jal	80002868 <printf>
    80001d4c:	10041073          	csrw	sstatus,s0
    80001d50:	00008517          	auipc	a0,0x8
    80001d54:	04050513          	add	a0,a0,64 # 80009d90 <rodata_start+0x1d90>
    80001d58:	681000ef          	jal	80002bd8 <uart_puts>
    80001d5c:	00013403          	ld	s0,0(sp)
    80001d60:	00813083          	ld	ra,8(sp)
    80001d64:	00008517          	auipc	a0,0x8
    80001d68:	04450513          	add	a0,a0,68 # 80009da8 <rodata_start+0x1da8>
    80001d6c:	01010113          	add	sp,sp,16
    80001d70:	6690006f          	j	80002bd8 <uart_puts>

0000000080001d74 <test_exception_definitions>:
    80001d74:	ff010113          	add	sp,sp,-16
    80001d78:	00008517          	auipc	a0,0x8
    80001d7c:	04850513          	add	a0,a0,72 # 80009dc0 <rodata_start+0x1dc0>
    80001d80:	00113423          	sd	ra,8(sp)
    80001d84:	655000ef          	jal	80002bd8 <uart_puts>
    80001d88:	00008517          	auipc	a0,0x8
    80001d8c:	07850513          	add	a0,a0,120 # 80009e00 <rodata_start+0x1e00>
    80001d90:	2d9000ef          	jal	80002868 <printf>
    80001d94:	00200593          	li	a1,2
    80001d98:	00008517          	auipc	a0,0x8
    80001d9c:	08050513          	add	a0,a0,128 # 80009e18 <rodata_start+0x1e18>
    80001da0:	2c9000ef          	jal	80002868 <printf>
    80001da4:	00d00593          	li	a1,13
    80001da8:	00008517          	auipc	a0,0x8
    80001dac:	09050513          	add	a0,a0,144 # 80009e38 <rodata_start+0x1e38>
    80001db0:	2b9000ef          	jal	80002868 <printf>
    80001db4:	00f00593          	li	a1,15
    80001db8:	00008517          	auipc	a0,0x8
    80001dbc:	0a050513          	add	a0,a0,160 # 80009e58 <rodata_start+0x1e58>
    80001dc0:	2a9000ef          	jal	80002868 <printf>
    80001dc4:	00800593          	li	a1,8
    80001dc8:	00008517          	auipc	a0,0x8
    80001dcc:	0b050513          	add	a0,a0,176 # 80009e78 <rodata_start+0x1e78>
    80001dd0:	299000ef          	jal	80002868 <printf>
    80001dd4:	00008517          	auipc	a0,0x8
    80001dd8:	0bc50513          	add	a0,a0,188 # 80009e90 <rodata_start+0x1e90>
    80001ddc:	28d000ef          	jal	80002868 <printf>
    80001de0:	00500593          	li	a1,5
    80001de4:	00008517          	auipc	a0,0x8
    80001de8:	0c450513          	add	a0,a0,196 # 80009ea8 <rodata_start+0x1ea8>
    80001dec:	27d000ef          	jal	80002868 <printf>
    80001df0:	00700593          	li	a1,7
    80001df4:	00008517          	auipc	a0,0x8
    80001df8:	0cc50513          	add	a0,a0,204 # 80009ec0 <rodata_start+0x1ec0>
    80001dfc:	26d000ef          	jal	80002868 <printf>
    80001e00:	00900593          	li	a1,9
    80001e04:	00008517          	auipc	a0,0x8
    80001e08:	0d450513          	add	a0,a0,212 # 80009ed8 <rodata_start+0x1ed8>
    80001e0c:	25d000ef          	jal	80002868 <printf>
    80001e10:	00008517          	auipc	a0,0x8
    80001e14:	0e050513          	add	a0,a0,224 # 80009ef0 <rodata_start+0x1ef0>
    80001e18:	5c1000ef          	jal	80002bd8 <uart_puts>
    80001e1c:	00813083          	ld	ra,8(sp)
    80001e20:	00008517          	auipc	a0,0x8
    80001e24:	0f850513          	add	a0,a0,248 # 80009f18 <rodata_start+0x1f18>
    80001e28:	01010113          	add	sp,sp,16
    80001e2c:	5ad0006f          	j	80002bd8 <uart_puts>

0000000080001e30 <test_trapframe_structure>:
    80001e30:	ff010113          	add	sp,sp,-16
    80001e34:	00008517          	auipc	a0,0x8
    80001e38:	0fc50513          	add	a0,a0,252 # 80009f30 <rodata_start+0x1f30>
    80001e3c:	00113423          	sd	ra,8(sp)
    80001e40:	599000ef          	jal	80002bd8 <uart_puts>
    80001e44:	11000593          	li	a1,272
    80001e48:	00008517          	auipc	a0,0x8
    80001e4c:	12050513          	add	a0,a0,288 # 80009f68 <rodata_start+0x1f68>
    80001e50:	219000ef          	jal	80002868 <printf>
    80001e54:	00008517          	auipc	a0,0x8
    80001e58:	13c50513          	add	a0,a0,316 # 80009f90 <rodata_start+0x1f90>
    80001e5c:	20d000ef          	jal	80002868 <printf>
    80001e60:	00008517          	auipc	a0,0x8
    80001e64:	16050513          	add	a0,a0,352 # 80009fc0 <rodata_start+0x1fc0>
    80001e68:	201000ef          	jal	80002868 <printf>
    80001e6c:	00800593          	li	a1,8
    80001e70:	00008517          	auipc	a0,0x8
    80001e74:	16850513          	add	a0,a0,360 # 80009fd8 <rodata_start+0x1fd8>
    80001e78:	1f1000ef          	jal	80002868 <printf>
    80001e7c:	00800593          	li	a1,8
    80001e80:	00008517          	auipc	a0,0x8
    80001e84:	17050513          	add	a0,a0,368 # 80009ff0 <rodata_start+0x1ff0>
    80001e88:	1e1000ef          	jal	80002868 <printf>
    80001e8c:	00800593          	li	a1,8
    80001e90:	00008517          	auipc	a0,0x8
    80001e94:	18050513          	add	a0,a0,384 # 8000a010 <rodata_start+0x2010>
    80001e98:	1d1000ef          	jal	80002868 <printf>
    80001e9c:	02200693          	li	a3,34
    80001ea0:	00800613          	li	a2,8
    80001ea4:	11000593          	li	a1,272
    80001ea8:	00008517          	auipc	a0,0x8
    80001eac:	18850513          	add	a0,a0,392 # 8000a030 <rodata_start+0x2030>
    80001eb0:	1b9000ef          	jal	80002868 <printf>
    80001eb4:	00008517          	auipc	a0,0x8
    80001eb8:	1a450513          	add	a0,a0,420 # 8000a058 <rodata_start+0x2058>
    80001ebc:	51d000ef          	jal	80002bd8 <uart_puts>
    80001ec0:	00813083          	ld	ra,8(sp)
    80001ec4:	00008517          	auipc	a0,0x8
    80001ec8:	1bc50513          	add	a0,a0,444 # 8000a080 <rodata_start+0x2080>
    80001ecc:	01010113          	add	sp,sp,16
    80001ed0:	5090006f          	j	80002bd8 <uart_puts>

0000000080001ed4 <test_interrupt_handlers>:
    80001ed4:	ff010113          	add	sp,sp,-16
    80001ed8:	00008517          	auipc	a0,0x8
    80001edc:	1c050513          	add	a0,a0,448 # 8000a098 <rodata_start+0x2098>
    80001ee0:	00113423          	sd	ra,8(sp)
    80001ee4:	4f5000ef          	jal	80002bd8 <uart_puts>
    80001ee8:	00008517          	auipc	a0,0x8
    80001eec:	1f050513          	add	a0,a0,496 # 8000a0d8 <rodata_start+0x20d8>
    80001ef0:	4e9000ef          	jal	80002bd8 <uart_puts>
    80001ef4:	00412797          	auipc	a5,0x412
    80001ef8:	72c78793          	add	a5,a5,1836 # 80414620 <trap_handlers>
    80001efc:	00412697          	auipc	a3,0x412
    80001f00:	7a468693          	add	a3,a3,1956 # 804146a0 <trapframe_pool>
    80001f04:	00000593          	li	a1,0
    80001f08:	0007b703          	ld	a4,0(a5)
    80001f0c:	00878793          	add	a5,a5,8
    80001f10:	00070463          	beqz	a4,80001f18 <test_interrupt_handlers+0x44>
    80001f14:	0015859b          	addw	a1,a1,1
    80001f18:	fed798e3          	bne	a5,a3,80001f08 <test_interrupt_handlers+0x34>
    80001f1c:	00008517          	auipc	a0,0x8
    80001f20:	1dc50513          	add	a0,a0,476 # 8000a0f8 <rodata_start+0x20f8>
    80001f24:	145000ef          	jal	80002868 <printf>
    80001f28:	00008517          	auipc	a0,0x8
    80001f2c:	1f850513          	add	a0,a0,504 # 8000a120 <rodata_start+0x2120>
    80001f30:	4a9000ef          	jal	80002bd8 <uart_puts>
    80001f34:	00813083          	ld	ra,8(sp)
    80001f38:	00008517          	auipc	a0,0x8
    80001f3c:	21850513          	add	a0,a0,536 # 8000a150 <rodata_start+0x2150>
    80001f40:	01010113          	add	sp,sp,16
    80001f44:	4950006f          	j	80002bd8 <uart_puts>

0000000080001f48 <test_timer_interrupt>:
    80001f48:	fd010113          	add	sp,sp,-48
    80001f4c:	00008517          	auipc	a0,0x8
    80001f50:	21c50513          	add	a0,a0,540 # 8000a168 <rodata_start+0x2168>
    80001f54:	02113423          	sd	ra,40(sp)
    80001f58:	02813023          	sd	s0,32(sp)
    80001f5c:	00913c23          	sd	s1,24(sp)
    80001f60:	479000ef          	jal	80002bd8 <uart_puts>
    80001f64:	00008517          	auipc	a0,0x8
    80001f68:	23c50513          	add	a0,a0,572 # 8000a1a0 <rodata_start+0x21a0>
    80001f6c:	46d000ef          	jal	80002bd8 <uart_puts>
    80001f70:	00008517          	auipc	a0,0x8
    80001f74:	26050513          	add	a0,a0,608 # 8000a1d0 <rodata_start+0x21d0>
    80001f78:	461000ef          	jal	80002bd8 <uart_puts>
    80001f7c:	00426417          	auipc	s0,0x426
    80001f80:	d5c40413          	add	s0,s0,-676 # 80427cd8 <ticks>
    80001f84:	00008517          	auipc	a0,0x8
    80001f88:	27c50513          	add	a0,a0,636 # 8000a200 <rodata_start+0x2200>
    80001f8c:	44d000ef          	jal	80002bd8 <uart_puts>
    80001f90:	00043483          	ld	s1,0(s0)
    80001f94:	00008517          	auipc	a0,0x8
    80001f98:	29c50513          	add	a0,a0,668 # 8000a230 <rodata_start+0x2230>
    80001f9c:	00048593          	mv	a1,s1
    80001fa0:	0c9000ef          	jal	80002868 <printf>
    80001fa4:	3a8030ef          	jal	8000534c <intr_on>
    80001fa8:	00008517          	auipc	a0,0x8
    80001fac:	2a050513          	add	a0,a0,672 # 8000a248 <rodata_start+0x2248>
    80001fb0:	429000ef          	jal	80002bd8 <uart_puts>
    80001fb4:	00008517          	auipc	a0,0x8
    80001fb8:	2ac50513          	add	a0,a0,684 # 8000a260 <rodata_start+0x2260>
    80001fbc:	41d000ef          	jal	80002bd8 <uart_puts>
    80001fc0:	00043783          	ld	a5,0(s0)
    80001fc4:	00000593          	li	a1,0
    80001fc8:	00f13423          	sd	a5,8(sp)
    80001fcc:	00813783          	ld	a5,8(sp)
    80001fd0:	00043703          	ld	a4,0(s0)
    80001fd4:	02f71263          	bne	a4,a5,80001ff8 <test_timer_interrupt+0xb0>
    80001fd8:	05f5e6b7          	lui	a3,0x5f5e
    80001fdc:	10068693          	add	a3,a3,256 # 5f5e100 <_entry-0x7a0a1f00>
    80001fe0:	0080006f          	j	80001fe8 <test_timer_interrupt+0xa0>
    80001fe4:	00d58a63          	beq	a1,a3,80001ff8 <test_timer_interrupt+0xb0>
    80001fe8:	00813703          	ld	a4,8(sp)
    80001fec:	00043783          	ld	a5,0(s0)
    80001ff0:	0015859b          	addw	a1,a1,1
    80001ff4:	fef708e3          	beq	a4,a5,80001fe4 <test_timer_interrupt+0x9c>
    80001ff8:	00008517          	auipc	a0,0x8
    80001ffc:	28050513          	add	a0,a0,640 # 8000a278 <rodata_start+0x2278>
    80002000:	069000ef          	jal	80002868 <printf>
    80002004:	00043583          	ld	a1,0(s0)
    80002008:	00008517          	auipc	a0,0x8
    8000200c:	28850513          	add	a0,a0,648 # 8000a290 <rodata_start+0x2290>
    80002010:	059000ef          	jal	80002868 <printf>
    80002014:	00043783          	ld	a5,0(s0)
    80002018:	04f4f063          	bgeu	s1,a5,80002058 <test_timer_interrupt+0x110>
    8000201c:	00043583          	ld	a1,0(s0)
    80002020:	00008517          	auipc	a0,0x8
    80002024:	28850513          	add	a0,a0,648 # 8000a2a8 <rodata_start+0x22a8>
    80002028:	409585b3          	sub	a1,a1,s1
    8000202c:	03d000ef          	jal	80002868 <printf>
    80002030:	00008517          	auipc	a0,0x8
    80002034:	2b050513          	add	a0,a0,688 # 8000a2e0 <rodata_start+0x22e0>
    80002038:	3a1000ef          	jal	80002bd8 <uart_puts>
    8000203c:	02013403          	ld	s0,32(sp)
    80002040:	02813083          	ld	ra,40(sp)
    80002044:	01813483          	ld	s1,24(sp)
    80002048:	00008517          	auipc	a0,0x8
    8000204c:	2e050513          	add	a0,a0,736 # 8000a328 <rodata_start+0x2328>
    80002050:	03010113          	add	sp,sp,48
    80002054:	3850006f          	j	80002bd8 <uart_puts>
    80002058:	00008517          	auipc	a0,0x8
    8000205c:	2b050513          	add	a0,a0,688 # 8000a308 <rodata_start+0x2308>
    80002060:	379000ef          	jal	80002bd8 <uart_puts>
    80002064:	02013403          	ld	s0,32(sp)
    80002068:	02813083          	ld	ra,40(sp)
    8000206c:	01813483          	ld	s1,24(sp)
    80002070:	00008517          	auipc	a0,0x8
    80002074:	2b850513          	add	a0,a0,696 # 8000a328 <rodata_start+0x2328>
    80002078:	03010113          	add	sp,sp,48
    8000207c:	35d0006f          	j	80002bd8 <uart_puts>

0000000080002080 <test_repeated_initialization>:
    80002080:	fe010113          	add	sp,sp,-32
    80002084:	00008517          	auipc	a0,0x8
    80002088:	2bc50513          	add	a0,a0,700 # 8000a340 <rodata_start+0x2340>
    8000208c:	00113c23          	sd	ra,24(sp)
    80002090:	00813823          	sd	s0,16(sp)
    80002094:	00913423          	sd	s1,8(sp)
    80002098:	01213023          	sd	s2,0(sp)
    8000209c:	33d000ef          	jal	80002bd8 <uart_puts>
    800020a0:	00008517          	auipc	a0,0x8
    800020a4:	2e050513          	add	a0,a0,736 # 8000a380 <rodata_start+0x2380>
    800020a8:	331000ef          	jal	80002bd8 <uart_puts>
    800020ac:	00000413          	li	s0,0
    800020b0:	00008917          	auipc	s2,0x8
    800020b4:	2e890913          	add	s2,s2,744 # 8000a398 <rodata_start+0x2398>
    800020b8:	00500493          	li	s1,5
    800020bc:	2cc030ef          	jal	80005388 <trap_init>
    800020c0:	0014041b          	addw	s0,s0,1
    800020c4:	374030ef          	jal	80005438 <trap_init_hart>
    800020c8:	00040593          	mv	a1,s0
    800020cc:	00090513          	mv	a0,s2
    800020d0:	798000ef          	jal	80002868 <printf>
    800020d4:	fe9414e3          	bne	s0,s1,800020bc <test_repeated_initialization+0x3c>
    800020d8:	00008517          	auipc	a0,0x8
    800020dc:	2e050513          	add	a0,a0,736 # 8000a3b8 <rodata_start+0x23b8>
    800020e0:	2f9000ef          	jal	80002bd8 <uart_puts>
    800020e4:	01013403          	ld	s0,16(sp)
    800020e8:	01813083          	ld	ra,24(sp)
    800020ec:	00813483          	ld	s1,8(sp)
    800020f0:	00013903          	ld	s2,0(sp)
    800020f4:	00008517          	auipc	a0,0x8
    800020f8:	2ec50513          	add	a0,a0,748 # 8000a3e0 <rodata_start+0x23e0>
    800020fc:	02010113          	add	sp,sp,32
    80002100:	2d90006f          	j	80002bd8 <uart_puts>

0000000080002104 <run_all_system_tests>:
    80002104:	ff010113          	add	sp,sp,-16
    80002108:	00007517          	auipc	a0,0x7
    8000210c:	7e050513          	add	a0,a0,2016 # 800098e8 <rodata_start+0x18e8>
    80002110:	00113423          	sd	ra,8(sp)
    80002114:	2c5000ef          	jal	80002bd8 <uart_puts>
    80002118:	00007517          	auipc	a0,0x7
    8000211c:	cb050513          	add	a0,a0,-848 # 80008dc8 <rodata_start+0xdc8>
    80002120:	2b9000ef          	jal	80002bd8 <uart_puts>
    80002124:	00008517          	auipc	a0,0x8
    80002128:	2d450513          	add	a0,a0,724 # 8000a3f8 <rodata_start+0x23f8>
    8000212c:	2ad000ef          	jal	80002bd8 <uart_puts>
    80002130:	00007517          	auipc	a0,0x7
    80002134:	dc050513          	add	a0,a0,-576 # 80008ef0 <rodata_start+0xef0>
    80002138:	2a1000ef          	jal	80002bd8 <uart_puts>
    8000213c:	8c5ff0ef          	jal	80001a00 <test_trap_initialization>
    80002140:	93dff0ef          	jal	80001a7c <test_interrupt_control>
    80002144:	a0dff0ef          	jal	80001b50 <test_trapframe_allocation>
    80002148:	b95ff0ef          	jal	80001cdc <test_csr_operations>
    8000214c:	c29ff0ef          	jal	80001d74 <test_exception_definitions>
    80002150:	ce1ff0ef          	jal	80001e30 <test_trapframe_structure>
    80002154:	d81ff0ef          	jal	80001ed4 <test_interrupt_handlers>
    80002158:	df1ff0ef          	jal	80001f48 <test_timer_interrupt>
    8000215c:	f25ff0ef          	jal	80002080 <test_repeated_initialization>
    80002160:	00007517          	auipc	a0,0x7
    80002164:	78850513          	add	a0,a0,1928 # 800098e8 <rodata_start+0x18e8>
    80002168:	271000ef          	jal	80002bd8 <uart_puts>
    8000216c:	00007517          	auipc	a0,0x7
    80002170:	c5c50513          	add	a0,a0,-932 # 80008dc8 <rodata_start+0xdc8>
    80002174:	265000ef          	jal	80002bd8 <uart_puts>
    80002178:	00008517          	auipc	a0,0x8
    8000217c:	2e050513          	add	a0,a0,736 # 8000a458 <rodata_start+0x2458>
    80002180:	259000ef          	jal	80002bd8 <uart_puts>
    80002184:	00813083          	ld	ra,8(sp)
    80002188:	00007517          	auipc	a0,0x7
    8000218c:	e8850513          	add	a0,a0,-376 # 80009010 <rodata_start+0x1010>
    80002190:	01010113          	add	sp,sp,16
    80002194:	2450006f          	j	80002bd8 <uart_puts>

0000000080002198 <run_interrupt_exception_tests>:
    80002198:	f6dff06f          	j	80002104 <run_all_system_tests>

000000008000219c <test_basic_syscalls>:
    8000219c:	00008517          	auipc	a0,0x8
    800021a0:	31450513          	add	a0,a0,788 # 8000a4b0 <rodata_start+0x24b0>
    800021a4:	6c40006f          	j	80002868 <printf>

00000000800021a8 <test_parameter_passing>:
    800021a8:	00008517          	auipc	a0,0x8
    800021ac:	32850513          	add	a0,a0,808 # 8000a4d0 <rodata_start+0x24d0>
    800021b0:	6b80006f          	j	80002868 <printf>

00000000800021b4 <test_security>:
    800021b4:	00008517          	auipc	a0,0x8
    800021b8:	33c50513          	add	a0,a0,828 # 8000a4f0 <rodata_start+0x24f0>
    800021bc:	6ac0006f          	j	80002868 <printf>

00000000800021c0 <test_syscall_performance>:
    800021c0:	00008517          	auipc	a0,0x8
    800021c4:	35050513          	add	a0,a0,848 # 8000a510 <rodata_start+0x2510>
    800021c8:	6a00006f          	j	80002868 <printf>

00000000800021cc <run_syscalls>:
    800021cc:	ff010113          	add	sp,sp,-16
    800021d0:	00008517          	auipc	a0,0x8
    800021d4:	2e050513          	add	a0,a0,736 # 8000a4b0 <rodata_start+0x24b0>
    800021d8:	00113423          	sd	ra,8(sp)
    800021dc:	68c000ef          	jal	80002868 <printf>
    800021e0:	00008517          	auipc	a0,0x8
    800021e4:	2f050513          	add	a0,a0,752 # 8000a4d0 <rodata_start+0x24d0>
    800021e8:	680000ef          	jal	80002868 <printf>
    800021ec:	00008517          	auipc	a0,0x8
    800021f0:	30450513          	add	a0,a0,772 # 8000a4f0 <rodata_start+0x24f0>
    800021f4:	674000ef          	jal	80002868 <printf>
    800021f8:	00813083          	ld	ra,8(sp)
    800021fc:	00008517          	auipc	a0,0x8
    80002200:	31450513          	add	a0,a0,788 # 8000a510 <rodata_start+0x2510>
    80002204:	01010113          	add	sp,sp,16
    80002208:	6600006f          	j	80002868 <printf>

000000008000220c <main>:
    8000220c:	ff010113          	add	sp,sp,-16
    80002210:	00007517          	auipc	a0,0x7
    80002214:	bb850513          	add	a0,a0,-1096 # 80008dc8 <rodata_start+0xdc8>
    80002218:	00113423          	sd	ra,8(sp)
    8000221c:	1bd000ef          	jal	80002bd8 <uart_puts>
    80002220:	00008517          	auipc	a0,0x8
    80002224:	31050513          	add	a0,a0,784 # 8000a530 <rodata_start+0x2530>
    80002228:	1b1000ef          	jal	80002bd8 <uart_puts>
    8000222c:	00007517          	auipc	a0,0x7
    80002230:	de450513          	add	a0,a0,-540 # 80009010 <rodata_start+0x1010>
    80002234:	1a5000ef          	jal	80002bd8 <uart_puts>
    80002238:	00008517          	auipc	a0,0x8
    8000223c:	35850513          	add	a0,a0,856 # 8000a590 <rodata_start+0x2590>
    80002240:	199000ef          	jal	80002bd8 <uart_puts>
    80002244:	01100593          	li	a1,17
    80002248:	02001537          	lui	a0,0x2001
    8000224c:	01b59593          	sll	a1,a1,0x1b
    80002250:	00651513          	sll	a0,a0,0x6
    80002254:	1b1000ef          	jal	80002c04 <pmm_init>
    80002258:	00008517          	auipc	a0,0x8
    8000225c:	37050513          	add	a0,a0,880 # 8000a5c8 <rodata_start+0x25c8>
    80002260:	179000ef          	jal	80002bd8 <uart_puts>
    80002264:	00008517          	auipc	a0,0x8
    80002268:	39c50513          	add	a0,a0,924 # 8000a600 <rodata_start+0x2600>
    8000226c:	16d000ef          	jal	80002bd8 <uart_puts>
    80002270:	118030ef          	jal	80005388 <trap_init>
    80002274:	1c4030ef          	jal	80005438 <trap_init_hart>
    80002278:	00008517          	auipc	a0,0x8
    8000227c:	3c050513          	add	a0,a0,960 # 8000a638 <rodata_start+0x2638>
    80002280:	159000ef          	jal	80002bd8 <uart_puts>
    80002284:	00008517          	auipc	a0,0x8
    80002288:	3e450513          	add	a0,a0,996 # 8000a668 <rodata_start+0x2668>
    8000228c:	14d000ef          	jal	80002bd8 <uart_puts>
    80002290:	21c030ef          	jal	800054ac <timerinit>
    80002294:	00008517          	auipc	a0,0x8
    80002298:	40c50513          	add	a0,a0,1036 # 8000a6a0 <rodata_start+0x26a0>
    8000229c:	13d000ef          	jal	80002bd8 <uart_puts>
    800022a0:	00008517          	auipc	a0,0x8
    800022a4:	43050513          	add	a0,a0,1072 # 8000a6d0 <rodata_start+0x26d0>
    800022a8:	131000ef          	jal	80002bd8 <uart_puts>
    800022ac:	700030ef          	jal	800059ac <proc_init>
    800022b0:	00008517          	auipc	a0,0x8
    800022b4:	45850513          	add	a0,a0,1112 # 8000a708 <rodata_start+0x2708>
    800022b8:	121000ef          	jal	80002bd8 <uart_puts>
    800022bc:	00008517          	auipc	a0,0x8
    800022c0:	47c50513          	add	a0,a0,1148 # 8000a738 <rodata_start+0x2738>
    800022c4:	115000ef          	jal	80002bd8 <uart_puts>
    800022c8:	258050ef          	jal	80007520 <fs_init>
    800022cc:	00008517          	auipc	a0,0x8
    800022d0:	4a450513          	add	a0,a0,1188 # 8000a770 <rodata_start+0x2770>
    800022d4:	105000ef          	jal	80002bd8 <uart_puts>
    800022d8:	e4cfe0ef          	jal	80000924 <start_user_test>
    800022dc:	585030ef          	jal	80006060 <scheduler>
    800022e0:	00008517          	auipc	a0,0x8
    800022e4:	4c050513          	add	a0,a0,1216 # 8000a7a0 <rodata_start+0x27a0>
    800022e8:	0f1000ef          	jal	80002bd8 <uart_puts>
    800022ec:	0000006f          	j	800022ec <main+0xe0>

00000000800022f0 <print_number>:
    800022f0:	0c050663          	beqz	a0,800023bc <print_number+0xcc>
    800022f4:	fd010113          	add	sp,sp,-48
    800022f8:	02113423          	sd	ra,40(sp)
    800022fc:	02813023          	sd	s0,32(sp)
    80002300:	08061a63          	bnez	a2,80002394 <print_number+0xa4>
    80002304:	0005071b          	sext.w	a4,a0
    80002308:	00000613          	li	a2,0
    8000230c:	0005859b          	sext.w	a1,a1
    80002310:	00010fa3          	sb	zero,31(sp)
    80002314:	01e10813          	add	a6,sp,30
    80002318:	01f00693          	li	a3,31
    8000231c:	00009317          	auipc	t1,0x9
    80002320:	ebc30313          	add	t1,t1,-324 # 8000b1d8 <digits>
    80002324:	02b777bb          	remuw	a5,a4,a1
    80002328:	fff80813          	add	a6,a6,-1
    8000232c:	0007089b          	sext.w	a7,a4
    80002330:	00068e13          	mv	t3,a3
    80002334:	fff6869b          	addw	a3,a3,-1
    80002338:	02079793          	sll	a5,a5,0x20
    8000233c:	0207d793          	srl	a5,a5,0x20
    80002340:	00f307b3          	add	a5,t1,a5
    80002344:	0007c503          	lbu	a0,0(a5)
    80002348:	02b7573b          	divuw	a4,a4,a1
    8000234c:	00a800a3          	sb	a0,1(a6)
    80002350:	fcb8fae3          	bgeu	a7,a1,80002324 <print_number+0x34>
    80002354:	04060a63          	beqz	a2,800023a8 <print_number+0xb8>
    80002358:	ffee069b          	addw	a3,t3,-2
    8000235c:	02068793          	add	a5,a3,32
    80002360:	002787b3          	add	a5,a5,sp
    80002364:	02d00713          	li	a4,45
    80002368:	fee78023          	sb	a4,-32(a5)
    8000236c:	02d00513          	li	a0,45
    80002370:	00d10433          	add	s0,sp,a3
    80002374:	00140413          	add	s0,s0,1
    80002378:	049000ef          	jal	80002bc0 <uart_putc>
    8000237c:	00044503          	lbu	a0,0(s0)
    80002380:	fe051ae3          	bnez	a0,80002374 <print_number+0x84>
    80002384:	02813083          	ld	ra,40(sp)
    80002388:	02013403          	ld	s0,32(sp)
    8000238c:	03010113          	add	sp,sp,48
    80002390:	00008067          	ret
    80002394:	f60558e3          	bgez	a0,80002304 <print_number+0x14>
    80002398:	80000737          	lui	a4,0x80000
    8000239c:	f6e508e3          	beq	a0,a4,8000230c <print_number+0x1c>
    800023a0:	40a0073b          	negw	a4,a0
    800023a4:	f69ff06f          	j	8000230c <print_number+0x1c>
    800023a8:	fc0514e3          	bnez	a0,80002370 <print_number+0x80>
    800023ac:	02813083          	ld	ra,40(sp)
    800023b0:	02013403          	ld	s0,32(sp)
    800023b4:	03010113          	add	sp,sp,48
    800023b8:	00008067          	ret
    800023bc:	03000513          	li	a0,48
    800023c0:	0010006f          	j	80002bc0 <uart_putc>

00000000800023c4 <print_number_long.part.0>:
    800023c4:	fd010113          	add	sp,sp,-48
    800023c8:	02113423          	sd	ra,40(sp)
    800023cc:	02813023          	sd	s0,32(sp)
    800023d0:	00050793          	mv	a5,a0
    800023d4:	00060463          	beqz	a2,800023dc <print_number_long.part.0+0x18>
    800023d8:	08054c63          	bltz	a0,80002470 <print_number_long.part.0+0xac>
    800023dc:	00000613          	li	a2,0
    800023e0:	00010fa3          	sb	zero,31(sp)
    800023e4:	01e10813          	add	a6,sp,30
    800023e8:	01f00693          	li	a3,31
    800023ec:	00009317          	auipc	t1,0x9
    800023f0:	dec30313          	add	t1,t1,-532 # 8000b1d8 <digits>
    800023f4:	02b7f733          	remu	a4,a5,a1
    800023f8:	fff80813          	add	a6,a6,-1
    800023fc:	00078893          	mv	a7,a5
    80002400:	00068e13          	mv	t3,a3
    80002404:	fff6869b          	addw	a3,a3,-1
    80002408:	00e30733          	add	a4,t1,a4
    8000240c:	00074503          	lbu	a0,0(a4) # ffffffff80000000 <bss_end+0xfffffffeffbd8308>
    80002410:	02b7d7b3          	divu	a5,a5,a1
    80002414:	00a800a3          	sb	a0,1(a6)
    80002418:	fcb8fee3          	bgeu	a7,a1,800023f4 <print_number_long.part.0+0x30>
    8000241c:	04060063          	beqz	a2,8000245c <print_number_long.part.0+0x98>
    80002420:	ffee069b          	addw	a3,t3,-2
    80002424:	02068793          	add	a5,a3,32
    80002428:	002787b3          	add	a5,a5,sp
    8000242c:	02d00713          	li	a4,45
    80002430:	fee78023          	sb	a4,-32(a5)
    80002434:	02d00513          	li	a0,45
    80002438:	00d10433          	add	s0,sp,a3
    8000243c:	00140413          	add	s0,s0,1
    80002440:	780000ef          	jal	80002bc0 <uart_putc>
    80002444:	00044503          	lbu	a0,0(s0)
    80002448:	fe051ae3          	bnez	a0,8000243c <print_number_long.part.0+0x78>
    8000244c:	02813083          	ld	ra,40(sp)
    80002450:	02013403          	ld	s0,32(sp)
    80002454:	03010113          	add	sp,sp,48
    80002458:	00008067          	ret
    8000245c:	fc051ee3          	bnez	a0,80002438 <print_number_long.part.0+0x74>
    80002460:	02813083          	ld	ra,40(sp)
    80002464:	02013403          	ld	s0,32(sp)
    80002468:	03010113          	add	sp,sp,48
    8000246c:	00008067          	ret
    80002470:	40a007b3          	neg	a5,a0
    80002474:	f6dff06f          	j	800023e0 <print_number_long.part.0+0x1c>

0000000080002478 <clear_screen>:
    80002478:	00009517          	auipc	a0,0x9
    8000247c:	a8850513          	add	a0,a0,-1400 # 8000af00 <user_test_syscalls_bin+0x328>
    80002480:	7580006f          	j	80002bd8 <uart_puts>

0000000080002484 <clear_line>:
    80002484:	00009517          	auipc	a0,0x9
    80002488:	a8450513          	add	a0,a0,-1404 # 8000af08 <user_test_syscalls_bin+0x330>
    8000248c:	74c0006f          	j	80002bd8 <uart_puts>

0000000080002490 <goto_xy>:
    80002490:	fd010113          	add	sp,sp,-48
    80002494:	00913c23          	sd	s1,24(sp)
    80002498:	00050493          	mv	s1,a0
    8000249c:	01b00513          	li	a0,27
    800024a0:	02113423          	sd	ra,40(sp)
    800024a4:	02813023          	sd	s0,32(sp)
    800024a8:	01213823          	sd	s2,16(sp)
    800024ac:	00058413          	mv	s0,a1
    800024b0:	01313423          	sd	s3,8(sp)
    800024b4:	70c000ef          	jal	80002bc0 <uart_putc>
    800024b8:	05b00513          	li	a0,91
    800024bc:	704000ef          	jal	80002bc0 <uart_putc>
    800024c0:	06300793          	li	a5,99
    800024c4:	0c87cc63          	blt	a5,s0,8000259c <goto_xy+0x10c>
    800024c8:	00900793          	li	a5,9
    800024cc:	0487ce63          	blt	a5,s0,80002528 <goto_xy+0x98>
    800024d0:	12805a63          	blez	s0,80002604 <goto_xy+0x174>
    800024d4:	0304041b          	addw	s0,s0,48
    800024d8:	0ff47513          	zext.b	a0,s0
    800024dc:	6e4000ef          	jal	80002bc0 <uart_putc>
    800024e0:	03b00513          	li	a0,59
    800024e4:	6dc000ef          	jal	80002bc0 <uart_putc>
    800024e8:	06300793          	li	a5,99
    800024ec:	0697c863          	blt	a5,s1,8000255c <goto_xy+0xcc>
    800024f0:	00900793          	li	a5,9
    800024f4:	0e97c463          	blt	a5,s1,800025dc <goto_xy+0x14c>
    800024f8:	10905c63          	blez	s1,80002610 <goto_xy+0x180>
    800024fc:	0304851b          	addw	a0,s1,48
    80002500:	0ff57513          	zext.b	a0,a0
    80002504:	6bc000ef          	jal	80002bc0 <uart_putc>
    80002508:	02013403          	ld	s0,32(sp)
    8000250c:	02813083          	ld	ra,40(sp)
    80002510:	01813483          	ld	s1,24(sp)
    80002514:	01013903          	ld	s2,16(sp)
    80002518:	00813983          	ld	s3,8(sp)
    8000251c:	04800513          	li	a0,72
    80002520:	03010113          	add	sp,sp,48
    80002524:	69c0006f          	j	80002bc0 <uart_putc>
    80002528:	00a00913          	li	s2,10
    8000252c:	0324453b          	divw	a0,s0,s2
    80002530:	0305051b          	addw	a0,a0,48
    80002534:	0ff57513          	zext.b	a0,a0
    80002538:	688000ef          	jal	80002bc0 <uart_putc>
    8000253c:	0324643b          	remw	s0,s0,s2
    80002540:	0304041b          	addw	s0,s0,48
    80002544:	0ff47513          	zext.b	a0,s0
    80002548:	678000ef          	jal	80002bc0 <uart_putc>
    8000254c:	03b00513          	li	a0,59
    80002550:	670000ef          	jal	80002bc0 <uart_putc>
    80002554:	06300793          	li	a5,99
    80002558:	f897dce3          	bge	a5,s1,800024f0 <goto_xy+0x60>
    8000255c:	06400413          	li	s0,100
    80002560:	0284c53b          	divw	a0,s1,s0
    80002564:	00a00913          	li	s2,10
    80002568:	0305051b          	addw	a0,a0,48
    8000256c:	0ff57513          	zext.b	a0,a0
    80002570:	650000ef          	jal	80002bc0 <uart_putc>
    80002574:	0284e53b          	remw	a0,s1,s0
    80002578:	0325453b          	divw	a0,a0,s2
    8000257c:	0305051b          	addw	a0,a0,48
    80002580:	0ff57513          	zext.b	a0,a0
    80002584:	63c000ef          	jal	80002bc0 <uart_putc>
    80002588:	0324e53b          	remw	a0,s1,s2
    8000258c:	0305051b          	addw	a0,a0,48
    80002590:	0ff57513          	zext.b	a0,a0
    80002594:	62c000ef          	jal	80002bc0 <uart_putc>
    80002598:	f71ff06f          	j	80002508 <goto_xy+0x78>
    8000259c:	06400913          	li	s2,100
    800025a0:	0324453b          	divw	a0,s0,s2
    800025a4:	00a00993          	li	s3,10
    800025a8:	0305051b          	addw	a0,a0,48
    800025ac:	0ff57513          	zext.b	a0,a0
    800025b0:	610000ef          	jal	80002bc0 <uart_putc>
    800025b4:	0324653b          	remw	a0,s0,s2
    800025b8:	0335453b          	divw	a0,a0,s3
    800025bc:	0305051b          	addw	a0,a0,48
    800025c0:	0ff57513          	zext.b	a0,a0
    800025c4:	5fc000ef          	jal	80002bc0 <uart_putc>
    800025c8:	0334643b          	remw	s0,s0,s3
    800025cc:	0304041b          	addw	s0,s0,48
    800025d0:	0ff47513          	zext.b	a0,s0
    800025d4:	5ec000ef          	jal	80002bc0 <uart_putc>
    800025d8:	f09ff06f          	j	800024e0 <goto_xy+0x50>
    800025dc:	00a00413          	li	s0,10
    800025e0:	0284c53b          	divw	a0,s1,s0
    800025e4:	0305051b          	addw	a0,a0,48
    800025e8:	0ff57513          	zext.b	a0,a0
    800025ec:	5d4000ef          	jal	80002bc0 <uart_putc>
    800025f0:	0284e53b          	remw	a0,s1,s0
    800025f4:	0305051b          	addw	a0,a0,48
    800025f8:	0ff57513          	zext.b	a0,a0
    800025fc:	5c4000ef          	jal	80002bc0 <uart_putc>
    80002600:	f09ff06f          	j	80002508 <goto_xy+0x78>
    80002604:	03100513          	li	a0,49
    80002608:	5b8000ef          	jal	80002bc0 <uart_putc>
    8000260c:	ed5ff06f          	j	800024e0 <goto_xy+0x50>
    80002610:	03100513          	li	a0,49
    80002614:	5ac000ef          	jal	80002bc0 <uart_putc>
    80002618:	ef1ff06f          	j	80002508 <goto_xy+0x78>

000000008000261c <printf_color>:
    8000261c:	f8010113          	add	sp,sp,-128
    80002620:	02913c23          	sd	s1,56(sp)
    80002624:	00050493          	mv	s1,a0
    80002628:	01b00513          	li	a0,27
    8000262c:	06f13423          	sd	a5,104(sp)
    80002630:	04113423          	sd	ra,72(sp)
    80002634:	04813023          	sd	s0,64(sp)
    80002638:	04c13823          	sd	a2,80(sp)
    8000263c:	04d13c23          	sd	a3,88(sp)
    80002640:	06e13023          	sd	a4,96(sp)
    80002644:	07013823          	sd	a6,112(sp)
    80002648:	07113c23          	sd	a7,120(sp)
    8000264c:	00058413          	mv	s0,a1
    80002650:	03213823          	sd	s2,48(sp)
    80002654:	03313423          	sd	s3,40(sp)
    80002658:	03413023          	sd	s4,32(sp)
    8000265c:	01513c23          	sd	s5,24(sp)
    80002660:	560000ef          	jal	80002bc0 <uart_putc>
    80002664:	05b00513          	li	a0,91
    80002668:	558000ef          	jal	80002bc0 <uart_putc>
    8000266c:	06300793          	li	a5,99
    80002670:	1a97e063          	bltu	a5,s1,80002810 <printf_color+0x1f4>
    80002674:	00900793          	li	a5,9
    80002678:	1497e663          	bltu	a5,s1,800027c4 <printf_color+0x1a8>
    8000267c:	0304851b          	addw	a0,s1,48
    80002680:	0ff57513          	zext.b	a0,a0
    80002684:	53c000ef          	jal	80002bc0 <uart_putc>
    80002688:	06d00513          	li	a0,109
    8000268c:	534000ef          	jal	80002bc0 <uart_putc>
    80002690:	1c040863          	beqz	s0,80002860 <printf_color+0x244>
    80002694:	00044503          	lbu	a0,0(s0)
    80002698:	05010793          	add	a5,sp,80
    8000269c:	00f13423          	sd	a5,8(sp)
    800026a0:	00000a93          	li	s5,0
    800026a4:	06050463          	beqz	a0,8000270c <printf_color+0xf0>
    800026a8:	02500913          	li	s2,37
    800026ac:	02000a13          	li	s4,32
    800026b0:	00009997          	auipc	s3,0x9
    800026b4:	99898993          	add	s3,s3,-1640 # 8000b048 <user_test_syscalls_bin+0x470>
    800026b8:	00140493          	add	s1,s0,1
    800026bc:	13251863          	bne	a0,s2,800027ec <printf_color+0x1d0>
    800026c0:	00144783          	lbu	a5,1(s0)
    800026c4:	14078063          	beqz	a5,80002804 <printf_color+0x1e8>
    800026c8:	13278863          	beq	a5,s2,800027f8 <printf_color+0x1dc>
    800026cc:	fa87879b          	addw	a5,a5,-88
    800026d0:	0ff7f793          	zext.b	a5,a5
    800026d4:	00fa6c63          	bltu	s4,a5,800026ec <printf_color+0xd0>
    800026d8:	00279793          	sll	a5,a5,0x2
    800026dc:	013787b3          	add	a5,a5,s3
    800026e0:	0007a783          	lw	a5,0(a5)
    800026e4:	013787b3          	add	a5,a5,s3
    800026e8:	00078067          	jr	a5
    800026ec:	02500513          	li	a0,37
    800026f0:	4d0000ef          	jal	80002bc0 <uart_putc>
    800026f4:	00144503          	lbu	a0,1(s0)
    800026f8:	ffe00a93          	li	s5,-2
    800026fc:	4c4000ef          	jal	80002bc0 <uart_putc>
    80002700:	0014c503          	lbu	a0,1(s1)
    80002704:	00148413          	add	s0,s1,1
    80002708:	fa0518e3          	bnez	a0,800026b8 <printf_color+0x9c>
    8000270c:	00009517          	auipc	a0,0x9
    80002710:	80c50513          	add	a0,a0,-2036 # 8000af18 <user_test_syscalls_bin+0x340>
    80002714:	4c4000ef          	jal	80002bd8 <uart_puts>
    80002718:	04813083          	ld	ra,72(sp)
    8000271c:	04013403          	ld	s0,64(sp)
    80002720:	03813483          	ld	s1,56(sp)
    80002724:	03013903          	ld	s2,48(sp)
    80002728:	02813983          	ld	s3,40(sp)
    8000272c:	02013a03          	ld	s4,32(sp)
    80002730:	000a8513          	mv	a0,s5
    80002734:	01813a83          	ld	s5,24(sp)
    80002738:	08010113          	add	sp,sp,128
    8000273c:	00008067          	ret
    80002740:	00813783          	ld	a5,8(sp)
    80002744:	00000613          	li	a2,0
    80002748:	01000593          	li	a1,16
    8000274c:	0007a503          	lw	a0,0(a5)
    80002750:	00878793          	add	a5,a5,8
    80002754:	00f13423          	sd	a5,8(sp)
    80002758:	b99ff0ef          	jal	800022f0 <print_number>
    8000275c:	fa5ff06f          	j	80002700 <printf_color+0xe4>
    80002760:	00813783          	ld	a5,8(sp)
    80002764:	0007c503          	lbu	a0,0(a5)
    80002768:	00878793          	add	a5,a5,8
    8000276c:	00f13423          	sd	a5,8(sp)
    80002770:	450000ef          	jal	80002bc0 <uart_putc>
    80002774:	f8dff06f          	j	80002700 <printf_color+0xe4>
    80002778:	00813783          	ld	a5,8(sp)
    8000277c:	0007b403          	ld	s0,0(a5)
    80002780:	00878793          	add	a5,a5,8
    80002784:	00f13423          	sd	a5,8(sp)
    80002788:	00041863          	bnez	s0,80002798 <printf_color+0x17c>
    8000278c:	0c40006f          	j	80002850 <printf_color+0x234>
    80002790:	00140413          	add	s0,s0,1
    80002794:	42c000ef          	jal	80002bc0 <uart_putc>
    80002798:	00044503          	lbu	a0,0(s0)
    8000279c:	fe051ae3          	bnez	a0,80002790 <printf_color+0x174>
    800027a0:	f61ff06f          	j	80002700 <printf_color+0xe4>
    800027a4:	00813783          	ld	a5,8(sp)
    800027a8:	00100613          	li	a2,1
    800027ac:	00a00593          	li	a1,10
    800027b0:	0007a503          	lw	a0,0(a5)
    800027b4:	00878793          	add	a5,a5,8
    800027b8:	00f13423          	sd	a5,8(sp)
    800027bc:	b35ff0ef          	jal	800022f0 <print_number>
    800027c0:	f41ff06f          	j	80002700 <printf_color+0xe4>
    800027c4:	00a00913          	li	s2,10
    800027c8:	0324d53b          	divuw	a0,s1,s2
    800027cc:	0305051b          	addw	a0,a0,48
    800027d0:	0ff57513          	zext.b	a0,a0
    800027d4:	3ec000ef          	jal	80002bc0 <uart_putc>
    800027d8:	0324f53b          	remuw	a0,s1,s2
    800027dc:	0305051b          	addw	a0,a0,48
    800027e0:	07f57513          	and	a0,a0,127
    800027e4:	3dc000ef          	jal	80002bc0 <uart_putc>
    800027e8:	ea1ff06f          	j	80002688 <printf_color+0x6c>
    800027ec:	3d4000ef          	jal	80002bc0 <uart_putc>
    800027f0:	00040493          	mv	s1,s0
    800027f4:	f0dff06f          	j	80002700 <printf_color+0xe4>
    800027f8:	02500513          	li	a0,37
    800027fc:	3c4000ef          	jal	80002bc0 <uart_putc>
    80002800:	f01ff06f          	j	80002700 <printf_color+0xe4>
    80002804:	02500513          	li	a0,37
    80002808:	3b8000ef          	jal	80002bc0 <uart_putc>
    8000280c:	f01ff06f          	j	8000270c <printf_color+0xf0>
    80002810:	06400913          	li	s2,100
    80002814:	0324d53b          	divuw	a0,s1,s2
    80002818:	00a00993          	li	s3,10
    8000281c:	0305051b          	addw	a0,a0,48
    80002820:	0ff57513          	zext.b	a0,a0
    80002824:	39c000ef          	jal	80002bc0 <uart_putc>
    80002828:	0324f53b          	remuw	a0,s1,s2
    8000282c:	0335553b          	divuw	a0,a0,s3
    80002830:	0305051b          	addw	a0,a0,48
    80002834:	0ff57513          	zext.b	a0,a0
    80002838:	388000ef          	jal	80002bc0 <uart_putc>
    8000283c:	0334f53b          	remuw	a0,s1,s3
    80002840:	0305051b          	addw	a0,a0,48
    80002844:	07f57513          	and	a0,a0,127
    80002848:	378000ef          	jal	80002bc0 <uart_putc>
    8000284c:	e3dff06f          	j	80002688 <printf_color+0x6c>
    80002850:	00008517          	auipc	a0,0x8
    80002854:	6c050513          	add	a0,a0,1728 # 8000af10 <user_test_syscalls_bin+0x338>
    80002858:	380000ef          	jal	80002bd8 <uart_puts>
    8000285c:	ea5ff06f          	j	80002700 <printf_color+0xe4>
    80002860:	fff00a93          	li	s5,-1
    80002864:	eb5ff06f          	j	80002718 <printf_color+0xfc>

0000000080002868 <printf>:
    80002868:	f6010113          	add	sp,sp,-160
    8000286c:	04113c23          	sd	ra,88(sp)
    80002870:	04813823          	sd	s0,80(sp)
    80002874:	04913423          	sd	s1,72(sp)
    80002878:	05213023          	sd	s2,64(sp)
    8000287c:	03313c23          	sd	s3,56(sp)
    80002880:	03413823          	sd	s4,48(sp)
    80002884:	03513423          	sd	s5,40(sp)
    80002888:	03613023          	sd	s6,32(sp)
    8000288c:	01713c23          	sd	s7,24(sp)
    80002890:	06b13423          	sd	a1,104(sp)
    80002894:	06c13823          	sd	a2,112(sp)
    80002898:	06d13c23          	sd	a3,120(sp)
    8000289c:	08e13023          	sd	a4,128(sp)
    800028a0:	08f13423          	sd	a5,136(sp)
    800028a4:	09013823          	sd	a6,144(sp)
    800028a8:	09113c23          	sd	a7,152(sp)
    800028ac:	20050c63          	beqz	a0,80002ac4 <printf+0x25c>
    800028b0:	00050413          	mv	s0,a0
    800028b4:	00054503          	lbu	a0,0(a0)
    800028b8:	06810793          	add	a5,sp,104
    800028bc:	00f13423          	sd	a5,8(sp)
    800028c0:	00000b13          	li	s6,0
    800028c4:	06050c63          	beqz	a0,8000293c <printf+0xd4>
    800028c8:	02500493          	li	s1,37
    800028cc:	06c00993          	li	s3,108
    800028d0:	02000a13          	li	s4,32
    800028d4:	00008917          	auipc	s2,0x8
    800028d8:	7f890913          	add	s2,s2,2040 # 8000b0cc <user_test_syscalls_bin+0x4f4>
    800028dc:	00009a97          	auipc	s5,0x9
    800028e0:	874a8a93          	add	s5,s5,-1932 # 8000b150 <user_test_syscalls_bin+0x578>
    800028e4:	04951463          	bne	a0,s1,8000292c <printf+0xc4>
    800028e8:	00144783          	lbu	a5,1(s0)
    800028ec:	18078e63          	beqz	a5,80002a88 <printf+0x220>
    800028f0:	11378063          	beq	a5,s3,800029f0 <printf+0x188>
    800028f4:	00140413          	add	s0,s0,1
    800028f8:	16978863          	beq	a5,s1,80002a68 <printf+0x200>
    800028fc:	fa87879b          	addw	a5,a5,-88
    80002900:	0ff7f793          	zext.b	a5,a5
    80002904:	00fa6c63          	bltu	s4,a5,8000291c <printf+0xb4>
    80002908:	00279793          	sll	a5,a5,0x2
    8000290c:	012787b3          	add	a5,a5,s2
    80002910:	0007a783          	lw	a5,0(a5)
    80002914:	012787b3          	add	a5,a5,s2
    80002918:	00078067          	jr	a5
    8000291c:	02500513          	li	a0,37
    80002920:	2a0000ef          	jal	80002bc0 <uart_putc>
    80002924:	00044503          	lbu	a0,0(s0)
    80002928:	ffe00b13          	li	s6,-2
    8000292c:	294000ef          	jal	80002bc0 <uart_putc>
    80002930:	00144503          	lbu	a0,1(s0)
    80002934:	00140413          	add	s0,s0,1
    80002938:	fa0516e3          	bnez	a0,800028e4 <printf+0x7c>
    8000293c:	05813083          	ld	ra,88(sp)
    80002940:	05013403          	ld	s0,80(sp)
    80002944:	04813483          	ld	s1,72(sp)
    80002948:	04013903          	ld	s2,64(sp)
    8000294c:	03813983          	ld	s3,56(sp)
    80002950:	03013a03          	ld	s4,48(sp)
    80002954:	02813a83          	ld	s5,40(sp)
    80002958:	01813b83          	ld	s7,24(sp)
    8000295c:	000b0513          	mv	a0,s6
    80002960:	02013b03          	ld	s6,32(sp)
    80002964:	0a010113          	add	sp,sp,160
    80002968:	00008067          	ret
    8000296c:	00813783          	ld	a5,8(sp)
    80002970:	00000613          	li	a2,0
    80002974:	01000593          	li	a1,16
    80002978:	0007a503          	lw	a0,0(a5)
    8000297c:	00878793          	add	a5,a5,8
    80002980:	00f13423          	sd	a5,8(sp)
    80002984:	96dff0ef          	jal	800022f0 <print_number>
    80002988:	fa9ff06f          	j	80002930 <printf+0xc8>
    8000298c:	00813783          	ld	a5,8(sp)
    80002990:	0007c503          	lbu	a0,0(a5)
    80002994:	00878793          	add	a5,a5,8
    80002998:	00f13423          	sd	a5,8(sp)
    8000299c:	224000ef          	jal	80002bc0 <uart_putc>
    800029a0:	f91ff06f          	j	80002930 <printf+0xc8>
    800029a4:	00813783          	ld	a5,8(sp)
    800029a8:	0007bb83          	ld	s7,0(a5)
    800029ac:	00878793          	add	a5,a5,8
    800029b0:	00f13423          	sd	a5,8(sp)
    800029b4:	000b9863          	bnez	s7,800029c4 <printf+0x15c>
    800029b8:	0e80006f          	j	80002aa0 <printf+0x238>
    800029bc:	001b8b93          	add	s7,s7,1
    800029c0:	200000ef          	jal	80002bc0 <uart_putc>
    800029c4:	000bc503          	lbu	a0,0(s7)
    800029c8:	fe051ae3          	bnez	a0,800029bc <printf+0x154>
    800029cc:	f65ff06f          	j	80002930 <printf+0xc8>
    800029d0:	00813783          	ld	a5,8(sp)
    800029d4:	00100613          	li	a2,1
    800029d8:	00a00593          	li	a1,10
    800029dc:	0007a503          	lw	a0,0(a5)
    800029e0:	00878793          	add	a5,a5,8
    800029e4:	00f13423          	sd	a5,8(sp)
    800029e8:	909ff0ef          	jal	800022f0 <print_number>
    800029ec:	f45ff06f          	j	80002930 <printf+0xc8>
    800029f0:	00244783          	lbu	a5,2(s0)
    800029f4:	00240413          	add	s0,s0,2
    800029f8:	0a078c63          	beqz	a5,80002ab0 <printf+0x248>
    800029fc:	06978663          	beq	a5,s1,80002a68 <printf+0x200>
    80002a00:	fa87879b          	addw	a5,a5,-88
    80002a04:	0ff7f793          	zext.b	a5,a5
    80002a08:	06fa6663          	bltu	s4,a5,80002a74 <printf+0x20c>
    80002a0c:	00279793          	sll	a5,a5,0x2
    80002a10:	015787b3          	add	a5,a5,s5
    80002a14:	0007a783          	lw	a5,0(a5)
    80002a18:	015787b3          	add	a5,a5,s5
    80002a1c:	00078067          	jr	a5
    80002a20:	00813783          	ld	a5,8(sp)
    80002a24:	0007b503          	ld	a0,0(a5)
    80002a28:	00878793          	add	a5,a5,8
    80002a2c:	00f13423          	sd	a5,8(sp)
    80002a30:	06050263          	beqz	a0,80002a94 <printf+0x22c>
    80002a34:	00000613          	li	a2,0
    80002a38:	01000593          	li	a1,16
    80002a3c:	989ff0ef          	jal	800023c4 <print_number_long.part.0>
    80002a40:	ef1ff06f          	j	80002930 <printf+0xc8>
    80002a44:	00813783          	ld	a5,8(sp)
    80002a48:	0007b503          	ld	a0,0(a5)
    80002a4c:	00878793          	add	a5,a5,8
    80002a50:	00f13423          	sd	a5,8(sp)
    80002a54:	04050063          	beqz	a0,80002a94 <printf+0x22c>
    80002a58:	00100613          	li	a2,1
    80002a5c:	00a00593          	li	a1,10
    80002a60:	965ff0ef          	jal	800023c4 <print_number_long.part.0>
    80002a64:	ecdff06f          	j	80002930 <printf+0xc8>
    80002a68:	02500513          	li	a0,37
    80002a6c:	154000ef          	jal	80002bc0 <uart_putc>
    80002a70:	ec1ff06f          	j	80002930 <printf+0xc8>
    80002a74:	02500513          	li	a0,37
    80002a78:	148000ef          	jal	80002bc0 <uart_putc>
    80002a7c:	06c00513          	li	a0,108
    80002a80:	140000ef          	jal	80002bc0 <uart_putc>
    80002a84:	ea1ff06f          	j	80002924 <printf+0xbc>
    80002a88:	02500513          	li	a0,37
    80002a8c:	134000ef          	jal	80002bc0 <uart_putc>
    80002a90:	eadff06f          	j	8000293c <printf+0xd4>
    80002a94:	03000513          	li	a0,48
    80002a98:	128000ef          	jal	80002bc0 <uart_putc>
    80002a9c:	e95ff06f          	j	80002930 <printf+0xc8>
    80002aa0:	00008517          	auipc	a0,0x8
    80002aa4:	47050513          	add	a0,a0,1136 # 8000af10 <user_test_syscalls_bin+0x338>
    80002aa8:	130000ef          	jal	80002bd8 <uart_puts>
    80002aac:	e85ff06f          	j	80002930 <printf+0xc8>
    80002ab0:	02500513          	li	a0,37
    80002ab4:	10c000ef          	jal	80002bc0 <uart_putc>
    80002ab8:	06c00513          	li	a0,108
    80002abc:	104000ef          	jal	80002bc0 <uart_putc>
    80002ac0:	e7dff06f          	j	8000293c <printf+0xd4>
    80002ac4:	fff00b13          	li	s6,-1
    80002ac8:	e75ff06f          	j	8000293c <printf+0xd4>

0000000080002acc <test_printf_basic>:
    80002acc:	ff010113          	add	sp,sp,-16
    80002ad0:	02a00593          	li	a1,42
    80002ad4:	00008517          	auipc	a0,0x8
    80002ad8:	44c50513          	add	a0,a0,1100 # 8000af20 <user_test_syscalls_bin+0x348>
    80002adc:	00113423          	sd	ra,8(sp)
    80002ae0:	d89ff0ef          	jal	80002868 <printf>
    80002ae4:	f8500593          	li	a1,-123
    80002ae8:	00008517          	auipc	a0,0x8
    80002aec:	45050513          	add	a0,a0,1104 # 8000af38 <user_test_syscalls_bin+0x360>
    80002af0:	d79ff0ef          	jal	80002868 <printf>
    80002af4:	00000593          	li	a1,0
    80002af8:	00008517          	auipc	a0,0x8
    80002afc:	45850513          	add	a0,a0,1112 # 8000af50 <user_test_syscalls_bin+0x378>
    80002b00:	d69ff0ef          	jal	80002868 <printf>
    80002b04:	000015b7          	lui	a1,0x1
    80002b08:	abc58593          	add	a1,a1,-1348 # abc <_entry-0x7ffff544>
    80002b0c:	00008517          	auipc	a0,0x8
    80002b10:	45c50513          	add	a0,a0,1116 # 8000af68 <user_test_syscalls_bin+0x390>
    80002b14:	d55ff0ef          	jal	80002868 <printf>
    80002b18:	00008597          	auipc	a1,0x8
    80002b1c:	46858593          	add	a1,a1,1128 # 8000af80 <user_test_syscalls_bin+0x3a8>
    80002b20:	00008517          	auipc	a0,0x8
    80002b24:	46850513          	add	a0,a0,1128 # 8000af88 <user_test_syscalls_bin+0x3b0>
    80002b28:	d41ff0ef          	jal	80002868 <printf>
    80002b2c:	05800593          	li	a1,88
    80002b30:	00008517          	auipc	a0,0x8
    80002b34:	47050513          	add	a0,a0,1136 # 8000afa0 <user_test_syscalls_bin+0x3c8>
    80002b38:	d31ff0ef          	jal	80002868 <printf>
    80002b3c:	00813083          	ld	ra,8(sp)
    80002b40:	00008517          	auipc	a0,0x8
    80002b44:	47850513          	add	a0,a0,1144 # 8000afb8 <user_test_syscalls_bin+0x3e0>
    80002b48:	01010113          	add	sp,sp,16
    80002b4c:	d1dff06f          	j	80002868 <printf>

0000000080002b50 <test_printf_edge_cases>:
    80002b50:	800005b7          	lui	a1,0x80000
    80002b54:	ff010113          	add	sp,sp,-16
    80002b58:	fff5c593          	not	a1,a1
    80002b5c:	00008517          	auipc	a0,0x8
    80002b60:	47450513          	add	a0,a0,1140 # 8000afd0 <user_test_syscalls_bin+0x3f8>
    80002b64:	00113423          	sd	ra,8(sp)
    80002b68:	d01ff0ef          	jal	80002868 <printf>
    80002b6c:	800005b7          	lui	a1,0x80000
    80002b70:	00008517          	auipc	a0,0x8
    80002b74:	47050513          	add	a0,a0,1136 # 8000afe0 <user_test_syscalls_bin+0x408>
    80002b78:	cf1ff0ef          	jal	80002868 <printf>
    80002b7c:	00000593          	li	a1,0
    80002b80:	00008517          	auipc	a0,0x8
    80002b84:	47050513          	add	a0,a0,1136 # 8000aff0 <user_test_syscalls_bin+0x418>
    80002b88:	ce1ff0ef          	jal	80002868 <printf>
    80002b8c:	00007597          	auipc	a1,0x7
    80002b90:	a5458593          	add	a1,a1,-1452 # 800095e0 <rodata_start+0x15e0>
    80002b94:	00008517          	auipc	a0,0x8
    80002b98:	47450513          	add	a0,a0,1140 # 8000b008 <user_test_syscalls_bin+0x430>
    80002b9c:	ccdff0ef          	jal	80002868 <printf>
    80002ba0:	00008517          	auipc	a0,0x8
    80002ba4:	48050513          	add	a0,a0,1152 # 8000b020 <user_test_syscalls_bin+0x448>
    80002ba8:	cc1ff0ef          	jal	80002868 <printf>
    80002bac:	00813083          	ld	ra,8(sp)
    80002bb0:	00008517          	auipc	a0,0x8
    80002bb4:	48050513          	add	a0,a0,1152 # 8000b030 <user_test_syscalls_bin+0x458>
    80002bb8:	01010113          	add	sp,sp,16
    80002bbc:	cadff06f          	j	80002868 <printf>

0000000080002bc0 <uart_putc>:
    80002bc0:	10000737          	lui	a4,0x10000
    80002bc4:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80002bc8:	0207f793          	and	a5,a5,32
    80002bcc:	fe078ce3          	beqz	a5,80002bc4 <uart_putc+0x4>
    80002bd0:	00a70023          	sb	a0,0(a4)
    80002bd4:	00008067          	ret

0000000080002bd8 <uart_puts>:
    80002bd8:	00054683          	lbu	a3,0(a0)
    80002bdc:	02068263          	beqz	a3,80002c00 <uart_puts+0x28>
    80002be0:	10000737          	lui	a4,0x10000
    80002be4:	00150513          	add	a0,a0,1
    80002be8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80002bec:	0207f793          	and	a5,a5,32
    80002bf0:	fe078ce3          	beqz	a5,80002be8 <uart_puts+0x10>
    80002bf4:	00d70023          	sb	a3,0(a4)
    80002bf8:	00054683          	lbu	a3,0(a0)
    80002bfc:	fe0694e3          	bnez	a3,80002be4 <uart_puts+0xc>
    80002c00:	00008067          	ret

0000000080002c04 <pmm_init>:
    80002c04:	000017b7          	lui	a5,0x1
    80002c08:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80002c0c:	00f50533          	add	a0,a0,a5
    80002c10:	fffff737          	lui	a4,0xfffff
    80002c14:	00e57533          	and	a0,a0,a4
    80002c18:	00e5f5b3          	and	a1,a1,a4
    80002c1c:	00425797          	auipc	a5,0x425
    80002c20:	08a7be23          	sd	a0,156(a5) # 80427cb8 <mem_start>
    80002c24:	00425797          	auipc	a5,0x425
    80002c28:	08b7b623          	sd	a1,140(a5) # 80427cb0 <mem_end>
    80002c2c:	00425797          	auipc	a5,0x425
    80002c30:	0807ba23          	sd	zero,148(a5) # 80427cc0 <freelist>
    80002c34:	02b57e63          	bgeu	a0,a1,80002c70 <pmm_init+0x6c>
    80002c38:	02050e63          	beqz	a0,80002c74 <pmm_init+0x70>
    80002c3c:	00050793          	mv	a5,a0
    80002c40:	00000613          	li	a2,0
    80002c44:	00000693          	li	a3,0
    80002c48:	00a7e863          	bltu	a5,a0,80002c58 <pmm_init+0x54>
    80002c4c:	00d7b023          	sd	a3,0(a5)
    80002c50:	00100613          	li	a2,1
    80002c54:	00078693          	mv	a3,a5
    80002c58:	00001737          	lui	a4,0x1
    80002c5c:	00e787b3          	add	a5,a5,a4
    80002c60:	feb7e4e3          	bltu	a5,a1,80002c48 <pmm_init+0x44>
    80002c64:	00060663          	beqz	a2,80002c70 <pmm_init+0x6c>
    80002c68:	00425797          	auipc	a5,0x425
    80002c6c:	04d7bc23          	sd	a3,88(a5) # 80427cc0 <freelist>
    80002c70:	00008067          	ret
    80002c74:	00000793          	li	a5,0
    80002c78:	00000613          	li	a2,0
    80002c7c:	00000693          	li	a3,0
    80002c80:	fd9ff06f          	j	80002c58 <pmm_init+0x54>

0000000080002c84 <alloc_page>:
    80002c84:	00425797          	auipc	a5,0x425
    80002c88:	03c78793          	add	a5,a5,60 # 80427cc0 <freelist>
    80002c8c:	0007b503          	ld	a0,0(a5)
    80002c90:	00050663          	beqz	a0,80002c9c <alloc_page+0x18>
    80002c94:	00053703          	ld	a4,0(a0)
    80002c98:	00e7b023          	sd	a4,0(a5)
    80002c9c:	00008067          	ret

0000000080002ca0 <free_page>:
    80002ca0:	02050c63          	beqz	a0,80002cd8 <free_page+0x38>
    80002ca4:	00425797          	auipc	a5,0x425
    80002ca8:	0147b783          	ld	a5,20(a5) # 80427cb8 <mem_start>
    80002cac:	02f56663          	bltu	a0,a5,80002cd8 <free_page+0x38>
    80002cb0:	00425797          	auipc	a5,0x425
    80002cb4:	0007b783          	ld	a5,0(a5) # 80427cb0 <mem_end>
    80002cb8:	02f57063          	bgeu	a0,a5,80002cd8 <free_page+0x38>
    80002cbc:	03451793          	sll	a5,a0,0x34
    80002cc0:	00079c63          	bnez	a5,80002cd8 <free_page+0x38>
    80002cc4:	00425797          	auipc	a5,0x425
    80002cc8:	ffc78793          	add	a5,a5,-4 # 80427cc0 <freelist>
    80002ccc:	0007b703          	ld	a4,0(a5)
    80002cd0:	00a7b023          	sd	a0,0(a5)
    80002cd4:	00e53023          	sd	a4,0(a0)
    80002cd8:	00008067          	ret

0000000080002cdc <alloc_pages>:
    80002cdc:	00050613          	mv	a2,a0
    80002ce0:	08a05863          	blez	a0,80002d70 <alloc_pages+0x94>
    80002ce4:	00425317          	auipc	t1,0x425
    80002ce8:	fdc30313          	add	t1,t1,-36 # 80427cc0 <freelist>
    80002cec:	00100793          	li	a5,1
    80002cf0:	00033803          	ld	a6,0(t1)
    80002cf4:	06f50463          	beq	a0,a5,80002d5c <alloc_pages+0x80>
    80002cf8:	06080c63          	beqz	a6,80002d70 <alloc_pages+0x94>
    80002cfc:	00083503          	ld	a0,0(a6)
    80002d00:	00080793          	mv	a5,a6
    80002d04:	00100713          	li	a4,1
    80002d08:	00000893          	li	a7,0
    80002d0c:	000015b7          	lui	a1,0x1
    80002d10:	0200006f          	j	80002d30 <alloc_pages+0x54>
    80002d14:	02d50463          	beq	a0,a3,80002d3c <alloc_pages+0x60>
    80002d18:	00053683          	ld	a3,0(a0)
    80002d1c:	00078893          	mv	a7,a5
    80002d20:	00050813          	mv	a6,a0
    80002d24:	00100713          	li	a4,1
    80002d28:	00050793          	mv	a5,a0
    80002d2c:	00068513          	mv	a0,a3
    80002d30:	00b786b3          	add	a3,a5,a1
    80002d34:	fe0510e3          	bnez	a0,80002d14 <alloc_pages+0x38>
    80002d38:	00008067          	ret
    80002d3c:	0017071b          	addw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80002d40:	00053683          	ld	a3,0(a0)
    80002d44:	fee612e3          	bne	a2,a4,80002d28 <alloc_pages+0x4c>
    80002d48:	02088863          	beqz	a7,80002d78 <alloc_pages+0x9c>
    80002d4c:	00d8b023          	sd	a3,0(a7)
    80002d50:	00053023          	sd	zero,0(a0)
    80002d54:	00080513          	mv	a0,a6
    80002d58:	00008067          	ret
    80002d5c:	00080663          	beqz	a6,80002d68 <alloc_pages+0x8c>
    80002d60:	00083783          	ld	a5,0(a6)
    80002d64:	00f33023          	sd	a5,0(t1)
    80002d68:	00080513          	mv	a0,a6
    80002d6c:	00008067          	ret
    80002d70:	00000513          	li	a0,0
    80002d74:	00008067          	ret
    80002d78:	00053023          	sd	zero,0(a0)
    80002d7c:	00d33023          	sd	a3,0(t1)
    80002d80:	00080513          	mv	a0,a6
    80002d84:	00008067          	ret

0000000080002d88 <walk_lookup>:
    80002d88:	01e5d793          	srl	a5,a1,0x1e
    80002d8c:	1ff7f793          	and	a5,a5,511
    80002d90:	00379793          	sll	a5,a5,0x3
    80002d94:	00f50533          	add	a0,a0,a5
    80002d98:	00053703          	ld	a4,0(a0)
    80002d9c:	00177793          	and	a5,a4,1
    80002da0:	04078a63          	beqz	a5,80002df4 <walk_lookup+0x6c>
    80002da4:	00e77793          	and	a5,a4,14
    80002da8:	04079663          	bnez	a5,80002df4 <walk_lookup+0x6c>
    80002dac:	0155d793          	srl	a5,a1,0x15
    80002db0:	00a75713          	srl	a4,a4,0xa
    80002db4:	1ff7f793          	and	a5,a5,511
    80002db8:	00c71713          	sll	a4,a4,0xc
    80002dbc:	00379793          	sll	a5,a5,0x3
    80002dc0:	00e787b3          	add	a5,a5,a4
    80002dc4:	0007b503          	ld	a0,0(a5)
    80002dc8:	00157793          	and	a5,a0,1
    80002dcc:	02078463          	beqz	a5,80002df4 <walk_lookup+0x6c>
    80002dd0:	00e57793          	and	a5,a0,14
    80002dd4:	02079063          	bnez	a5,80002df4 <walk_lookup+0x6c>
    80002dd8:	00c5d593          	srl	a1,a1,0xc
    80002ddc:	00a55513          	srl	a0,a0,0xa
    80002de0:	1ff5f593          	and	a1,a1,511
    80002de4:	00359593          	sll	a1,a1,0x3
    80002de8:	00c51513          	sll	a0,a0,0xc
    80002dec:	00b50533          	add	a0,a0,a1
    80002df0:	00008067          	ret
    80002df4:	00000513          	li	a0,0
    80002df8:	00008067          	ret

0000000080002dfc <free_swap_slot.part.0>:
    80002dfc:	0055579b          	srlw	a5,a0,0x5
    80002e00:	0000e617          	auipc	a2,0xe
    80002e04:	37860613          	add	a2,a2,888 # 80011178 <swap_mgr>
    80002e08:	00279793          	sll	a5,a5,0x2
    80002e0c:	00f607b3          	add	a5,a2,a5
    80002e10:	0007a583          	lw	a1,0(a5)
    80002e14:	00100713          	li	a4,1
    80002e18:	00a7173b          	sllw	a4,a4,a0
    80002e1c:	00e5f6b3          	and	a3,a1,a4
    80002e20:	0006869b          	sext.w	a3,a3
    80002e24:	02068463          	beqz	a3,80002e4c <free_swap_slot.part.0+0x50>
    80002e28:	08862683          	lw	a3,136(a2)
    80002e2c:	fff74713          	not	a4,a4
    80002e30:	08062803          	lw	a6,128(a2)
    80002e34:	00e5f5b3          	and	a1,a1,a4
    80002e38:	fff6871b          	addw	a4,a3,-1
    80002e3c:	00b7a023          	sw	a1,0(a5)
    80002e40:	08e62423          	sw	a4,136(a2)
    80002e44:	01057463          	bgeu	a0,a6,80002e4c <free_swap_slot.part.0+0x50>
    80002e48:	08a62023          	sw	a0,128(a2)
    80002e4c:	00008067          	ret

0000000080002e50 <uvmunmap.part.0>:
    80002e50:	fc010113          	add	sp,sp,-64
    80002e54:	03213023          	sd	s2,32(sp)
    80002e58:	00c61913          	sll	s2,a2,0xc
    80002e5c:	02113c23          	sd	ra,56(sp)
    80002e60:	02813823          	sd	s0,48(sp)
    80002e64:	02913423          	sd	s1,40(sp)
    80002e68:	01313c23          	sd	s3,24(sp)
    80002e6c:	01413823          	sd	s4,16(sp)
    80002e70:	01513423          	sd	s5,8(sp)
    80002e74:	00b90933          	add	s2,s2,a1
    80002e78:	0525f863          	bgeu	a1,s2,80002ec8 <uvmunmap.part.0+0x78>
    80002e7c:	00058493          	mv	s1,a1
    80002e80:	00050993          	mv	s3,a0
    80002e84:	00068a93          	mv	s5,a3
    80002e88:	00001a37          	lui	s4,0x1
    80002e8c:	00048593          	mv	a1,s1
    80002e90:	00098513          	mv	a0,s3
    80002e94:	ef5ff0ef          	jal	80002d88 <walk_lookup>
    80002e98:	00050413          	mv	s0,a0
    80002e9c:	014484b3          	add	s1,s1,s4
    80002ea0:	02050263          	beqz	a0,80002ec4 <uvmunmap.part.0+0x74>
    80002ea4:	00053783          	ld	a5,0(a0)
    80002ea8:	00a7d713          	srl	a4,a5,0xa
    80002eac:	0017f793          	and	a5,a5,1
    80002eb0:	00c71513          	sll	a0,a4,0xc
    80002eb4:	00078863          	beqz	a5,80002ec4 <uvmunmap.part.0+0x74>
    80002eb8:	00050663          	beqz	a0,80002ec4 <uvmunmap.part.0+0x74>
    80002ebc:	020a9863          	bnez	s5,80002eec <uvmunmap.part.0+0x9c>
    80002ec0:	00043023          	sd	zero,0(s0)
    80002ec4:	fd24e4e3          	bltu	s1,s2,80002e8c <uvmunmap.part.0+0x3c>
    80002ec8:	03813083          	ld	ra,56(sp)
    80002ecc:	03013403          	ld	s0,48(sp)
    80002ed0:	02813483          	ld	s1,40(sp)
    80002ed4:	02013903          	ld	s2,32(sp)
    80002ed8:	01813983          	ld	s3,24(sp)
    80002edc:	01013a03          	ld	s4,16(sp)
    80002ee0:	00813a83          	ld	s5,8(sp)
    80002ee4:	04010113          	add	sp,sp,64
    80002ee8:	00008067          	ret
    80002eec:	db5ff0ef          	jal	80002ca0 <free_page>
    80002ef0:	00043023          	sd	zero,0(s0)
    80002ef4:	fd1ff06f          	j	80002ec4 <uvmunmap.part.0+0x74>

0000000080002ef8 <create_pagetable>:
    80002ef8:	ff010113          	add	sp,sp,-16
    80002efc:	00113423          	sd	ra,8(sp)
    80002f00:	d85ff0ef          	jal	80002c84 <alloc_page>
    80002f04:	00050e63          	beqz	a0,80002f20 <create_pagetable+0x28>
    80002f08:	00001737          	lui	a4,0x1
    80002f0c:	00050793          	mv	a5,a0
    80002f10:	00e50733          	add	a4,a0,a4
    80002f14:	0007b023          	sd	zero,0(a5)
    80002f18:	00878793          	add	a5,a5,8
    80002f1c:	fee79ce3          	bne	a5,a4,80002f14 <create_pagetable+0x1c>
    80002f20:	00813083          	ld	ra,8(sp)
    80002f24:	01010113          	add	sp,sp,16
    80002f28:	00008067          	ret

0000000080002f2c <map_page>:
    80002f2c:	00c5e7b3          	or	a5,a1,a2
    80002f30:	03479713          	sll	a4,a5,0x34
    80002f34:	20071863          	bnez	a4,80003144 <map_page+0x218>
    80002f38:	fc010113          	add	sp,sp,-64
    80002f3c:	02913423          	sd	s1,40(sp)
    80002f40:	03213023          	sd	s2,32(sp)
    80002f44:	01313c23          	sd	s3,24(sp)
    80002f48:	01413823          	sd	s4,16(sp)
    80002f4c:	01513423          	sd	s5,8(sp)
    80002f50:	01613023          	sd	s6,0(sp)
    80002f54:	02113c23          	sd	ra,56(sp)
    80002f58:	02813823          	sd	s0,48(sp)
    80002f5c:	00058493          	mv	s1,a1
    80002f60:	00060913          	mv	s2,a2
    80002f64:	00050a13          	mv	s4,a0
    80002f68:	00068993          	mv	s3,a3
    80002f6c:	00050813          	mv	a6,a0
    80002f70:	00200a93          	li	s5,2
    80002f74:	00200793          	li	a5,2
    80002f78:	00100b13          	li	s6,1
    80002f7c:	0037941b          	sllw	s0,a5,0x3
    80002f80:	00f4043b          	addw	s0,s0,a5
    80002f84:	00c4041b          	addw	s0,s0,12
    80002f88:	0084d433          	srl	s0,s1,s0
    80002f8c:	1ff47413          	and	s0,s0,511
    80002f90:	00341413          	sll	s0,s0,0x3
    80002f94:	00880433          	add	s0,a6,s0
    80002f98:	00043783          	ld	a5,0(s0)
    80002f9c:	0017f713          	and	a4,a5,1
    80002fa0:	14070e63          	beqz	a4,800030fc <map_page+0x1d0>
    80002fa4:	00e7f713          	and	a4,a5,14
    80002fa8:	18071a63          	bnez	a4,8000313c <map_page+0x210>
    80002fac:	00a7d793          	srl	a5,a5,0xa
    80002fb0:	00c79813          	sll	a6,a5,0xc
    80002fb4:	00100793          	li	a5,1
    80002fb8:	016a8663          	beq	s5,s6,80002fc4 <map_page+0x98>
    80002fbc:	00100a93          	li	s5,1
    80002fc0:	fbdff06f          	j	80002f7c <map_page+0x50>
    80002fc4:	00c4d793          	srl	a5,s1,0xc
    80002fc8:	1ff7f793          	and	a5,a5,511
    80002fcc:	00379793          	sll	a5,a5,0x3
    80002fd0:	00f80833          	add	a6,a6,a5
    80002fd4:	16080463          	beqz	a6,8000313c <map_page+0x210>
    80002fd8:	00083783          	ld	a5,0(a6)
    80002fdc:	0017f793          	and	a5,a5,1
    80002fe0:	14079e63          	bnez	a5,8000313c <map_page+0x210>
    80002fe4:	00c95793          	srl	a5,s2,0xc
    80002fe8:	00a79793          	sll	a5,a5,0xa
    80002fec:	00411597          	auipc	a1,0x411
    80002ff0:	21c58593          	add	a1,a1,540 # 80414208 <lru_mgr+0x3000>
    80002ff4:	0145a703          	lw	a4,20(a1)
    80002ff8:	0137e7b3          	or	a5,a5,s3
    80002ffc:	0017e793          	or	a5,a5,1
    80003000:	00f83023          	sd	a5,0(a6)
    80003004:	0c070663          	beqz	a4,800030d0 <map_page+0x1a4>
    80003008:	0040e717          	auipc	a4,0x40e
    8000300c:	22470713          	add	a4,a4,548 # 8041122c <lru_mgr+0x24>
    80003010:	00000793          	li	a5,0
    80003014:	10000693          	li	a3,256
    80003018:	00c0006f          	j	80003024 <map_page+0xf8>
    8000301c:	0017879b          	addw	a5,a5,1
    80003020:	0ad78863          	beq	a5,a3,800030d0 <map_page+0x1a4>
    80003024:	00072803          	lw	a6,0(a4)
    80003028:	03070713          	add	a4,a4,48
    8000302c:	fe0818e3          	bnez	a6,8000301c <map_page+0xf0>
    80003030:	00178813          	add	a6,a5,1
    80003034:	00181513          	sll	a0,a6,0x1
    80003038:	00179713          	sll	a4,a5,0x1
    8000303c:	01050533          	add	a0,a0,a6
    80003040:	0040e617          	auipc	a2,0x40e
    80003044:	1c860613          	add	a2,a2,456 # 80411208 <lru_mgr>
    80003048:	00f706b3          	add	a3,a4,a5
    8000304c:	00451513          	sll	a0,a0,0x4
    80003050:	00469693          	sll	a3,a3,0x4
    80003054:	00a60533          	add	a0,a2,a0
    80003058:	fffff337          	lui	t1,0xfffff
    8000305c:	00d608b3          	add	a7,a2,a3
    80003060:	0064f4b3          	and	s1,s1,t1
    80003064:	01453423          	sd	s4,8(a0)
    80003068:	fff00513          	li	a0,-1
    8000306c:	01068693          	add	a3,a3,16
    80003070:	0098b823          	sd	s1,16(a7)
    80003074:	0128bc23          	sd	s2,24(a7)
    80003078:	02a8a023          	sw	a0,32(a7)
    8000307c:	0049f993          	and	s3,s3,4
    80003080:	00d606b3          	add	a3,a2,a3
    80003084:	00098463          	beqz	s3,8000308c <map_page+0x160>
    80003088:	00500a93          	li	s5,5
    8000308c:	00181513          	sll	a0,a6,0x1
    80003090:	00f707b3          	add	a5,a4,a5
    80003094:	00063883          	ld	a7,0(a2)
    80003098:	01050733          	add	a4,a0,a6
    8000309c:	00479793          	sll	a5,a5,0x4
    800030a0:	00471713          	sll	a4,a4,0x4
    800030a4:	00f607b3          	add	a5,a2,a5
    800030a8:	00e60733          	add	a4,a2,a4
    800030ac:	0357a223          	sw	s5,36(a5)
    800030b0:	01173023          	sd	a7,0(a4)
    800030b4:	0207b423          	sd	zero,40(a5)
    800030b8:	06088e63          	beqz	a7,80003134 <map_page+0x208>
    800030bc:	00d8bc23          	sd	a3,24(a7)
    800030c0:	0105a783          	lw	a5,16(a1)
    800030c4:	00d63023          	sd	a3,0(a2)
    800030c8:	0017879b          	addw	a5,a5,1
    800030cc:	00f5a823          	sw	a5,16(a1)
    800030d0:	00000513          	li	a0,0
    800030d4:	03813083          	ld	ra,56(sp)
    800030d8:	03013403          	ld	s0,48(sp)
    800030dc:	02813483          	ld	s1,40(sp)
    800030e0:	02013903          	ld	s2,32(sp)
    800030e4:	01813983          	ld	s3,24(sp)
    800030e8:	01013a03          	ld	s4,16(sp)
    800030ec:	00813a83          	ld	s5,8(sp)
    800030f0:	00013b03          	ld	s6,0(sp)
    800030f4:	04010113          	add	sp,sp,64
    800030f8:	00008067          	ret
    800030fc:	b89ff0ef          	jal	80002c84 <alloc_page>
    80003100:	00050813          	mv	a6,a0
    80003104:	02050c63          	beqz	a0,8000313c <map_page+0x210>
    80003108:	00001737          	lui	a4,0x1
    8000310c:	00e50733          	add	a4,a0,a4
    80003110:	00050793          	mv	a5,a0
    80003114:	0007b023          	sd	zero,0(a5)
    80003118:	00878793          	add	a5,a5,8
    8000311c:	fee79ce3          	bne	a5,a4,80003114 <map_page+0x1e8>
    80003120:	00c85793          	srl	a5,a6,0xc
    80003124:	00a79793          	sll	a5,a5,0xa
    80003128:	0017e793          	or	a5,a5,1
    8000312c:	00f43023          	sd	a5,0(s0)
    80003130:	e85ff06f          	j	80002fb4 <map_page+0x88>
    80003134:	00d63423          	sd	a3,8(a2)
    80003138:	f89ff06f          	j	800030c0 <map_page+0x194>
    8000313c:	fff00513          	li	a0,-1
    80003140:	f95ff06f          	j	800030d4 <map_page+0x1a8>
    80003144:	fff00513          	li	a0,-1
    80003148:	00008067          	ret

000000008000314c <map_region>:
    8000314c:	000017b7          	lui	a5,0x1
    80003150:	fc010113          	add	sp,sp,-64
    80003154:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80003158:	02913423          	sd	s1,40(sp)
    8000315c:	00f684b3          	add	s1,a3,a5
    80003160:	00b484b3          	add	s1,s1,a1
    80003164:	fffff7b7          	lui	a5,0xfffff
    80003168:	02113c23          	sd	ra,56(sp)
    8000316c:	02813823          	sd	s0,48(sp)
    80003170:	03213023          	sd	s2,32(sp)
    80003174:	01313c23          	sd	s3,24(sp)
    80003178:	01413823          	sd	s4,16(sp)
    8000317c:	01513423          	sd	s5,8(sp)
    80003180:	00f4f4b3          	and	s1,s1,a5
    80003184:	0495f263          	bgeu	a1,s1,800031c8 <map_region+0x7c>
    80003188:	00058413          	mv	s0,a1
    8000318c:	00050993          	mv	s3,a0
    80003190:	00070a13          	mv	s4,a4
    80003194:	40b60933          	sub	s2,a2,a1
    80003198:	00001ab7          	lui	s5,0x1
    8000319c:	0080006f          	j	800031a4 <map_region+0x58>
    800031a0:	02947463          	bgeu	s0,s1,800031c8 <map_region+0x7c>
    800031a4:	00890633          	add	a2,s2,s0
    800031a8:	00040593          	mv	a1,s0
    800031ac:	000a0693          	mv	a3,s4
    800031b0:	00098513          	mv	a0,s3
    800031b4:	d79ff0ef          	jal	80002f2c <map_page>
    800031b8:	01540433          	add	s0,s0,s5
    800031bc:	fe0502e3          	beqz	a0,800031a0 <map_region+0x54>
    800031c0:	fff00513          	li	a0,-1
    800031c4:	0080006f          	j	800031cc <map_region+0x80>
    800031c8:	00000513          	li	a0,0
    800031cc:	03813083          	ld	ra,56(sp)
    800031d0:	03013403          	ld	s0,48(sp)
    800031d4:	02813483          	ld	s1,40(sp)
    800031d8:	02013903          	ld	s2,32(sp)
    800031dc:	01813983          	ld	s3,24(sp)
    800031e0:	01013a03          	ld	s4,16(sp)
    800031e4:	00813a83          	ld	s5,8(sp)
    800031e8:	04010113          	add	sp,sp,64
    800031ec:	00008067          	ret

00000000800031f0 <destroy_pagetable>:
    800031f0:	f0010113          	add	sp,sp,-256
    800031f4:	000017b7          	lui	a5,0x1
    800031f8:	0e813823          	sd	s0,240(sp)
    800031fc:	0f213023          	sd	s2,224(sp)
    80003200:	0d613023          	sd	s6,192(sp)
    80003204:	0b713c23          	sd	s7,184(sp)
    80003208:	0e113c23          	sd	ra,248(sp)
    8000320c:	0e913423          	sd	s1,232(sp)
    80003210:	0d313c23          	sd	s3,216(sp)
    80003214:	0d413823          	sd	s4,208(sp)
    80003218:	0d513423          	sd	s5,200(sp)
    8000321c:	0b813823          	sd	s8,176(sp)
    80003220:	0b913423          	sd	s9,168(sp)
    80003224:	0ba13023          	sd	s10,160(sp)
    80003228:	09b13c23          	sd	s11,152(sp)
    8000322c:	00050413          	mv	s0,a0
    80003230:	00050913          	mv	s2,a0
    80003234:	00f50b33          	add	s6,a0,a5
    80003238:	00001bb7          	lui	s7,0x1
    8000323c:	00c0006f          	j	80003248 <destroy_pagetable+0x58>
    80003240:	00890913          	add	s2,s2,8
    80003244:	2d690063          	beq	s2,s6,80003504 <destroy_pagetable+0x314>
    80003248:	00093783          	ld	a5,0(s2)
    8000324c:	00100713          	li	a4,1
    80003250:	00f7f693          	and	a3,a5,15
    80003254:	fee696e3          	bne	a3,a4,80003240 <destroy_pagetable+0x50>
    80003258:	00a7d793          	srl	a5,a5,0xa
    8000325c:	00c79a13          	sll	s4,a5,0xc
    80003260:	017a0cb3          	add	s9,s4,s7
    80003264:	00100d93          	li	s11,1
    80003268:	000a0a93          	mv	s5,s4
    8000326c:	00040493          	mv	s1,s0
    80003270:	00c0006f          	j	8000327c <destroy_pagetable+0x8c>
    80003274:	008a0a13          	add	s4,s4,8 # 1008 <_entry-0x7fffeff8>
    80003278:	279a0c63          	beq	s4,s9,800034f0 <destroy_pagetable+0x300>
    8000327c:	000a3783          	ld	a5,0(s4)
    80003280:	00f7f713          	and	a4,a5,15
    80003284:	ffb718e3          	bne	a4,s11,80003274 <destroy_pagetable+0x84>
    80003288:	00a7d793          	srl	a5,a5,0xa
    8000328c:	00c79993          	sll	s3,a5,0xc
    80003290:	00098c13          	mv	s8,s3
    80003294:	01798d33          	add	s10,s3,s7
    80003298:	00098413          	mv	s0,s3
    8000329c:	00c0006f          	j	800032a8 <destroy_pagetable+0xb8>
    800032a0:	00840413          	add	s0,s0,8
    800032a4:	23a40e63          	beq	s0,s10,800034e0 <destroy_pagetable+0x2f0>
    800032a8:	00043783          	ld	a5,0(s0)
    800032ac:	00f7f713          	and	a4,a5,15
    800032b0:	ffb718e3          	bne	a4,s11,800032a0 <destroy_pagetable+0xb0>
    800032b4:	00a7d793          	srl	a5,a5,0xa
    800032b8:	00c79793          	sll	a5,a5,0xc
    800032bc:	00048713          	mv	a4,s1
    800032c0:	03513c23          	sd	s5,56(sp)
    800032c4:	00090493          	mv	s1,s2
    800032c8:	017789b3          	add	s3,a5,s7
    800032cc:	02813823          	sd	s0,48(sp)
    800032d0:	00078a93          	mv	s5,a5
    800032d4:	00070913          	mv	s2,a4
    800032d8:	00c0006f          	j	800032e4 <destroy_pagetable+0xf4>
    800032dc:	00878793          	add	a5,a5,8 # 1008 <_entry-0x7fffeff8>
    800032e0:	1cf98e63          	beq	s3,a5,800034bc <destroy_pagetable+0x2cc>
    800032e4:	0007b703          	ld	a4,0(a5)
    800032e8:	00f77693          	and	a3,a4,15
    800032ec:	ffb698e3          	bne	a3,s11,800032dc <destroy_pagetable+0xec>
    800032f0:	00a75713          	srl	a4,a4,0xa
    800032f4:	00c71713          	sll	a4,a4,0xc
    800032f8:	017706b3          	add	a3,a4,s7
    800032fc:	05313423          	sd	s3,72(sp)
    80003300:	00d13423          	sd	a3,8(sp)
    80003304:	05813023          	sd	s8,64(sp)
    80003308:	00070993          	mv	s3,a4
    8000330c:	04f13823          	sd	a5,80(sp)
    80003310:	0100006f          	j	80003320 <destroy_pagetable+0x130>
    80003314:	00813783          	ld	a5,8(sp)
    80003318:	00870713          	add	a4,a4,8 # 1008 <_entry-0x7fffeff8>
    8000331c:	16e78e63          	beq	a5,a4,80003498 <destroy_pagetable+0x2a8>
    80003320:	00073783          	ld	a5,0(a4)
    80003324:	00f7f693          	and	a3,a5,15
    80003328:	ffb696e3          	bne	a3,s11,80003314 <destroy_pagetable+0x124>
    8000332c:	00a7d793          	srl	a5,a5,0xa
    80003330:	00c79793          	sll	a5,a5,0xc
    80003334:	017786b3          	add	a3,a5,s7
    80003338:	000a8c13          	mv	s8,s5
    8000333c:	00d13c23          	sd	a3,24(sp)
    80003340:	00078a93          	mv	s5,a5
    80003344:	04e13c23          	sd	a4,88(sp)
    80003348:	07213023          	sd	s2,96(sp)
    8000334c:	0100006f          	j	8000335c <destroy_pagetable+0x16c>
    80003350:	01813703          	ld	a4,24(sp)
    80003354:	00878793          	add	a5,a5,8
    80003358:	10f70c63          	beq	a4,a5,80003470 <destroy_pagetable+0x280>
    8000335c:	0007b703          	ld	a4,0(a5)
    80003360:	00f77693          	and	a3,a4,15
    80003364:	ffb696e3          	bne	a3,s11,80003350 <destroy_pagetable+0x160>
    80003368:	00a75713          	srl	a4,a4,0xa
    8000336c:	00c71913          	sll	s2,a4,0xc
    80003370:	01790733          	add	a4,s2,s7
    80003374:	07213423          	sd	s2,104(sp)
    80003378:	00090413          	mv	s0,s2
    8000337c:	02e13023          	sd	a4,32(sp)
    80003380:	06f13823          	sd	a5,112(sp)
    80003384:	00048913          	mv	s2,s1
    80003388:	0100006f          	j	80003398 <destroy_pagetable+0x1a8>
    8000338c:	02013783          	ld	a5,32(sp)
    80003390:	00840413          	add	s0,s0,8
    80003394:	0a878c63          	beq	a5,s0,8000344c <destroy_pagetable+0x25c>
    80003398:	00043783          	ld	a5,0(s0)
    8000339c:	00f7f693          	and	a3,a5,15
    800033a0:	ffb696e3          	bne	a3,s11,8000338c <destroy_pagetable+0x19c>
    800033a4:	00a7d793          	srl	a5,a5,0xa
    800033a8:	00c79493          	sll	s1,a5,0xc
    800033ac:	017487b3          	add	a5,s1,s7
    800033b0:	00913823          	sd	s1,16(sp)
    800033b4:	02f13423          	sd	a5,40(sp)
    800033b8:	06813c23          	sd	s0,120(sp)
    800033bc:	0100006f          	j	800033cc <destroy_pagetable+0x1dc>
    800033c0:	02813783          	ld	a5,40(sp)
    800033c4:	00848493          	add	s1,s1,8
    800033c8:	06978663          	beq	a5,s1,80003434 <destroy_pagetable+0x244>
    800033cc:	0004b783          	ld	a5,0(s1)
    800033d0:	00f7f693          	and	a3,a5,15
    800033d4:	ffb696e3          	bne	a3,s11,800033c0 <destroy_pagetable+0x1d0>
    800033d8:	00a7d793          	srl	a5,a5,0xa
    800033dc:	00c79413          	sll	s0,a5,0xc
    800033e0:	017406b3          	add	a3,s0,s7
    800033e4:	09213023          	sd	s2,128(sp)
    800033e8:	09613423          	sd	s6,136(sp)
    800033ec:	00040913          	mv	s2,s0
    800033f0:	000a0b13          	mv	s6,s4
    800033f4:	00048a13          	mv	s4,s1
    800033f8:	00068493          	mv	s1,a3
    800033fc:	00043783          	ld	a5,0(s0)
    80003400:	00840413          	add	s0,s0,8
    80003404:	00f7f713          	and	a4,a5,15
    80003408:	13b70e63          	beq	a4,s11,80003544 <destroy_pagetable+0x354>
    8000340c:	fe8498e3          	bne	s1,s0,800033fc <destroy_pagetable+0x20c>
    80003410:	00090513          	mv	a0,s2
    80003414:	000a0493          	mv	s1,s4
    80003418:	08013903          	ld	s2,128(sp)
    8000341c:	000b0a13          	mv	s4,s6
    80003420:	08813b03          	ld	s6,136(sp)
    80003424:	87dff0ef          	jal	80002ca0 <free_page>
    80003428:	02813783          	ld	a5,40(sp)
    8000342c:	00848493          	add	s1,s1,8
    80003430:	f8979ee3          	bne	a5,s1,800033cc <destroy_pagetable+0x1dc>
    80003434:	01013503          	ld	a0,16(sp)
    80003438:	07813403          	ld	s0,120(sp)
    8000343c:	865ff0ef          	jal	80002ca0 <free_page>
    80003440:	02013783          	ld	a5,32(sp)
    80003444:	00840413          	add	s0,s0,8
    80003448:	f48798e3          	bne	a5,s0,80003398 <destroy_pagetable+0x1a8>
    8000344c:	07013783          	ld	a5,112(sp)
    80003450:	06813503          	ld	a0,104(sp)
    80003454:	00090493          	mv	s1,s2
    80003458:	00f13823          	sd	a5,16(sp)
    8000345c:	845ff0ef          	jal	80002ca0 <free_page>
    80003460:	01013783          	ld	a5,16(sp)
    80003464:	01813703          	ld	a4,24(sp)
    80003468:	00878793          	add	a5,a5,8
    8000346c:	eef718e3          	bne	a4,a5,8000335c <destroy_pagetable+0x16c>
    80003470:	05813703          	ld	a4,88(sp)
    80003474:	000a8513          	mv	a0,s5
    80003478:	06013903          	ld	s2,96(sp)
    8000347c:	00e13823          	sd	a4,16(sp)
    80003480:	821ff0ef          	jal	80002ca0 <free_page>
    80003484:	01013703          	ld	a4,16(sp)
    80003488:	00813783          	ld	a5,8(sp)
    8000348c:	000c0a93          	mv	s5,s8
    80003490:	00870713          	add	a4,a4,8
    80003494:	e8e796e3          	bne	a5,a4,80003320 <destroy_pagetable+0x130>
    80003498:	05013783          	ld	a5,80(sp)
    8000349c:	00098513          	mv	a0,s3
    800034a0:	04013c03          	ld	s8,64(sp)
    800034a4:	00f13423          	sd	a5,8(sp)
    800034a8:	04813983          	ld	s3,72(sp)
    800034ac:	ff4ff0ef          	jal	80002ca0 <free_page>
    800034b0:	00813783          	ld	a5,8(sp)
    800034b4:	00878793          	add	a5,a5,8
    800034b8:	e2f996e3          	bne	s3,a5,800032e4 <destroy_pagetable+0xf4>
    800034bc:	03013403          	ld	s0,48(sp)
    800034c0:	00090793          	mv	a5,s2
    800034c4:	000a8513          	mv	a0,s5
    800034c8:	00840413          	add	s0,s0,8
    800034cc:	03813a83          	ld	s5,56(sp)
    800034d0:	00048913          	mv	s2,s1
    800034d4:	00078493          	mv	s1,a5
    800034d8:	fc8ff0ef          	jal	80002ca0 <free_page>
    800034dc:	dda416e3          	bne	s0,s10,800032a8 <destroy_pagetable+0xb8>
    800034e0:	000c0513          	mv	a0,s8
    800034e4:	008a0a13          	add	s4,s4,8
    800034e8:	fb8ff0ef          	jal	80002ca0 <free_page>
    800034ec:	d99a18e3          	bne	s4,s9,8000327c <destroy_pagetable+0x8c>
    800034f0:	000a8513          	mv	a0,s5
    800034f4:	00890913          	add	s2,s2,8
    800034f8:	00048413          	mv	s0,s1
    800034fc:	fa4ff0ef          	jal	80002ca0 <free_page>
    80003500:	d56914e3          	bne	s2,s6,80003248 <destroy_pagetable+0x58>
    80003504:	00040513          	mv	a0,s0
    80003508:	0f013403          	ld	s0,240(sp)
    8000350c:	0f813083          	ld	ra,248(sp)
    80003510:	0e813483          	ld	s1,232(sp)
    80003514:	0e013903          	ld	s2,224(sp)
    80003518:	0d813983          	ld	s3,216(sp)
    8000351c:	0d013a03          	ld	s4,208(sp)
    80003520:	0c813a83          	ld	s5,200(sp)
    80003524:	0c013b03          	ld	s6,192(sp)
    80003528:	0b813b83          	ld	s7,184(sp)
    8000352c:	0b013c03          	ld	s8,176(sp)
    80003530:	0a813c83          	ld	s9,168(sp)
    80003534:	0a013d03          	ld	s10,160(sp)
    80003538:	09813d83          	ld	s11,152(sp)
    8000353c:	10010113          	add	sp,sp,256
    80003540:	f60ff06f          	j	80002ca0 <free_page>
    80003544:	00a7d793          	srl	a5,a5,0xa
    80003548:	00c79513          	sll	a0,a5,0xc
    8000354c:	ca5ff0ef          	jal	800031f0 <destroy_pagetable>
    80003550:	ea8496e3          	bne	s1,s0,800033fc <destroy_pagetable+0x20c>
    80003554:	ebdff06f          	j	80003410 <destroy_pagetable+0x220>

0000000080003558 <kvminithart>:
    80003558:	00424797          	auipc	a5,0x424
    8000355c:	7707b783          	ld	a5,1904(a5) # 80427cc8 <kernel_pagetable>
    80003560:	fff00713          	li	a4,-1
    80003564:	03f71713          	sll	a4,a4,0x3f
    80003568:	00c7d793          	srl	a5,a5,0xc
    8000356c:	00e7e7b3          	or	a5,a5,a4
    80003570:	18079073          	csrw	satp,a5
    80003574:	12000073          	sfence.vma
    80003578:	00008067          	ret

000000008000357c <dump_pagetable>:
    8000357c:	fb010113          	add	sp,sp,-80
    80003580:	03213823          	sd	s2,48(sp)
    80003584:	03313423          	sd	s3,40(sp)
    80003588:	04113423          	sd	ra,72(sp)
    8000358c:	04813023          	sd	s0,64(sp)
    80003590:	02913c23          	sd	s1,56(sp)
    80003594:	03413023          	sd	s4,32(sp)
    80003598:	01513c23          	sd	s5,24(sp)
    8000359c:	01613823          	sd	s6,16(sp)
    800035a0:	01713423          	sd	s7,8(sp)
    800035a4:	00058993          	mv	s3,a1
    800035a8:	00050913          	mv	s2,a0
    800035ac:	28b05263          	blez	a1,80003830 <dump_pagetable+0x2b4>
    800035b0:	00000413          	li	s0,0
    800035b4:	0014041b          	addw	s0,s0,1
    800035b8:	02000513          	li	a0,32
    800035bc:	e04ff0ef          	jal	80002bc0 <uart_putc>
    800035c0:	fe899ae3          	bne	s3,s0,800035b4 <dump_pagetable+0x38>
    800035c4:	00008517          	auipc	a0,0x8
    800035c8:	c2c50513          	add	a0,a0,-980 # 8000b1f0 <digits+0x18>
    800035cc:	e0cff0ef          	jal	80002bd8 <uart_puts>
    800035d0:	00900793          	li	a5,9
    800035d4:	2737d463          	bge	a5,s3,8000383c <dump_pagetable+0x2c0>
    800035d8:	00a00413          	li	s0,10
    800035dc:	0289c53b          	divw	a0,s3,s0
    800035e0:	0305051b          	addw	a0,a0,48
    800035e4:	0ff57513          	zext.b	a0,a0
    800035e8:	dd8ff0ef          	jal	80002bc0 <uart_putc>
    800035ec:	0289e53b          	remw	a0,s3,s0
    800035f0:	0305051b          	addw	a0,a0,48
    800035f4:	0ff57513          	zext.b	a0,a0
    800035f8:	dc8ff0ef          	jal	80002bc0 <uart_putc>
    800035fc:	00008517          	auipc	a0,0x8
    80003600:	c0c50513          	add	a0,a0,-1012 # 8000b208 <digits+0x30>
    80003604:	fff00b13          	li	s6,-1
    80003608:	dd0ff0ef          	jal	80002bd8 <uart_puts>
    8000360c:	00000493          	li	s1,0
    80003610:	00cb5b13          	srl	s6,s6,0xc
    80003614:	00900a13          	li	s4,9
    80003618:	ffc00a93          	li	s5,-4
    8000361c:	0140006f          	j	80003630 <dump_pagetable+0xb4>
    80003620:	0014849b          	addw	s1,s1,1
    80003624:	20000793          	li	a5,512
    80003628:	00890913          	add	s2,s2,8
    8000362c:	0cf48063          	beq	s1,a5,800036ec <dump_pagetable+0x170>
    80003630:	00093783          	ld	a5,0(s2)
    80003634:	0017f793          	and	a5,a5,1
    80003638:	fe0784e3          	beqz	a5,80003620 <dump_pagetable+0xa4>
    8000363c:	00000413          	li	s0,0
    80003640:	0009ca63          	bltz	s3,80003654 <dump_pagetable+0xd8>
    80003644:	0014041b          	addw	s0,s0,1
    80003648:	02000513          	li	a0,32
    8000364c:	d74ff0ef          	jal	80002bc0 <uart_putc>
    80003650:	fe89dae3          	bge	s3,s0,80003644 <dump_pagetable+0xc8>
    80003654:	00008517          	auipc	a0,0x8
    80003658:	bbc50513          	add	a0,a0,-1092 # 8000b210 <digits+0x38>
    8000365c:	d7cff0ef          	jal	80002bd8 <uart_puts>
    80003660:	06300793          	li	a5,99
    80003664:	1697d263          	bge	a5,s1,800037c8 <dump_pagetable+0x24c>
    80003668:	06400413          	li	s0,100
    8000366c:	0284c53b          	divw	a0,s1,s0
    80003670:	00a00b93          	li	s7,10
    80003674:	0305051b          	addw	a0,a0,48
    80003678:	0ff57513          	zext.b	a0,a0
    8000367c:	d44ff0ef          	jal	80002bc0 <uart_putc>
    80003680:	0284e53b          	remw	a0,s1,s0
    80003684:	0375453b          	divw	a0,a0,s7
    80003688:	0305051b          	addw	a0,a0,48
    8000368c:	0ff57513          	zext.b	a0,a0
    80003690:	d30ff0ef          	jal	80002bc0 <uart_putc>
    80003694:	0374e53b          	remw	a0,s1,s7
    80003698:	0305051b          	addw	a0,a0,48
    8000369c:	0ff57513          	zext.b	a0,a0
    800036a0:	d20ff0ef          	jal	80002bc0 <uart_putc>
    800036a4:	00008517          	auipc	a0,0x8
    800036a8:	b7450513          	add	a0,a0,-1164 # 8000b218 <digits+0x40>
    800036ac:	d2cff0ef          	jal	80002bd8 <uart_puts>
    800036b0:	00093b83          	ld	s7,0(s2)
    800036b4:	00ebf793          	and	a5,s7,14
    800036b8:	06079063          	bnez	a5,80003718 <dump_pagetable+0x19c>
    800036bc:	00008517          	auipc	a0,0x8
    800036c0:	b7450513          	add	a0,a0,-1164 # 8000b230 <digits+0x58>
    800036c4:	d14ff0ef          	jal	80002bd8 <uart_puts>
    800036c8:	00093503          	ld	a0,0(s2)
    800036cc:	0019859b          	addw	a1,s3,1
    800036d0:	0014849b          	addw	s1,s1,1
    800036d4:	00a55513          	srl	a0,a0,0xa
    800036d8:	00c51513          	sll	a0,a0,0xc
    800036dc:	ea1ff0ef          	jal	8000357c <dump_pagetable>
    800036e0:	20000793          	li	a5,512
    800036e4:	00890913          	add	s2,s2,8
    800036e8:	f4f494e3          	bne	s1,a5,80003630 <dump_pagetable+0xb4>
    800036ec:	04813083          	ld	ra,72(sp)
    800036f0:	04013403          	ld	s0,64(sp)
    800036f4:	03813483          	ld	s1,56(sp)
    800036f8:	03013903          	ld	s2,48(sp)
    800036fc:	02813983          	ld	s3,40(sp)
    80003700:	02013a03          	ld	s4,32(sp)
    80003704:	01813a83          	ld	s5,24(sp)
    80003708:	01013b03          	ld	s6,16(sp)
    8000370c:	00813b83          	ld	s7,8(sp)
    80003710:	05010113          	add	sp,sp,80
    80003714:	00008067          	ret
    80003718:	00008517          	auipc	a0,0x8
    8000371c:	b0850513          	add	a0,a0,-1272 # 8000b220 <digits+0x48>
    80003720:	cb8ff0ef          	jal	80002bd8 <uart_puts>
    80003724:	00abdb93          	srl	s7,s7,0xa
    80003728:	016bfbb3          	and	s7,s7,s6
    8000372c:	00000713          	li	a4,0
    80003730:	03c00413          	li	s0,60
    80003734:	008bd7b3          	srl	a5,s7,s0
    80003738:	00f7f793          	and	a5,a5,15
    8000373c:	00e7e733          	or	a4,a5,a4
    80003740:	00071e63          	bnez	a4,8000375c <dump_pagetable+0x1e0>
    80003744:	02040c63          	beqz	s0,8000377c <dump_pagetable+0x200>
    80003748:	ffc4041b          	addw	s0,s0,-4
    8000374c:	008bd7b3          	srl	a5,s7,s0
    80003750:	00f7f793          	and	a5,a5,15
    80003754:	00e7e733          	or	a4,a5,a4
    80003758:	fe0706e3          	beqz	a4,80003744 <dump_pagetable+0x1c8>
    8000375c:	ffc4041b          	addw	s0,s0,-4
    80003760:	03778513          	add	a0,a5,55
    80003764:	0ff7f713          	zext.b	a4,a5
    80003768:	04fa5c63          	bge	s4,a5,800037c0 <dump_pagetable+0x244>
    8000376c:	c54ff0ef          	jal	80002bc0 <uart_putc>
    80003770:	01540a63          	beq	s0,s5,80003784 <dump_pagetable+0x208>
    80003774:	00100713          	li	a4,1
    80003778:	fbdff06f          	j	80003734 <dump_pagetable+0x1b8>
    8000377c:	03000513          	li	a0,48
    80003780:	c40ff0ef          	jal	80002bc0 <uart_putc>
    80003784:	00008517          	auipc	a0,0x8
    80003788:	aa450513          	add	a0,a0,-1372 # 8000b228 <digits+0x50>
    8000378c:	c4cff0ef          	jal	80002bd8 <uart_puts>
    80003790:	00093783          	ld	a5,0(s2)
    80003794:	0027f713          	and	a4,a5,2
    80003798:	08071463          	bnez	a4,80003820 <dump_pagetable+0x2a4>
    8000379c:	0047f713          	and	a4,a5,4
    800037a0:	06071863          	bnez	a4,80003810 <dump_pagetable+0x294>
    800037a4:	0087f713          	and	a4,a5,8
    800037a8:	04071c63          	bnez	a4,80003800 <dump_pagetable+0x284>
    800037ac:	0107f793          	and	a5,a5,16
    800037b0:	04079263          	bnez	a5,800037f4 <dump_pagetable+0x278>
    800037b4:	00a00513          	li	a0,10
    800037b8:	c08ff0ef          	jal	80002bc0 <uart_putc>
    800037bc:	e65ff06f          	j	80003620 <dump_pagetable+0xa4>
    800037c0:	03070513          	add	a0,a4,48
    800037c4:	fa9ff06f          	j	8000376c <dump_pagetable+0x1f0>
    800037c8:	089a5263          	bge	s4,s1,8000384c <dump_pagetable+0x2d0>
    800037cc:	00a00413          	li	s0,10
    800037d0:	0284c53b          	divw	a0,s1,s0
    800037d4:	0305051b          	addw	a0,a0,48
    800037d8:	0ff57513          	zext.b	a0,a0
    800037dc:	be4ff0ef          	jal	80002bc0 <uart_putc>
    800037e0:	0284e53b          	remw	a0,s1,s0
    800037e4:	0305051b          	addw	a0,a0,48
    800037e8:	0ff57513          	zext.b	a0,a0
    800037ec:	bd4ff0ef          	jal	80002bc0 <uart_putc>
    800037f0:	eb5ff06f          	j	800036a4 <dump_pagetable+0x128>
    800037f4:	05500513          	li	a0,85
    800037f8:	bc8ff0ef          	jal	80002bc0 <uart_putc>
    800037fc:	fb9ff06f          	j	800037b4 <dump_pagetable+0x238>
    80003800:	05800513          	li	a0,88
    80003804:	bbcff0ef          	jal	80002bc0 <uart_putc>
    80003808:	00093783          	ld	a5,0(s2)
    8000380c:	fa1ff06f          	j	800037ac <dump_pagetable+0x230>
    80003810:	05700513          	li	a0,87
    80003814:	bacff0ef          	jal	80002bc0 <uart_putc>
    80003818:	00093783          	ld	a5,0(s2)
    8000381c:	f89ff06f          	j	800037a4 <dump_pagetable+0x228>
    80003820:	05200513          	li	a0,82
    80003824:	b9cff0ef          	jal	80002bc0 <uart_putc>
    80003828:	00093783          	ld	a5,0(s2)
    8000382c:	f71ff06f          	j	8000379c <dump_pagetable+0x220>
    80003830:	00008517          	auipc	a0,0x8
    80003834:	9c050513          	add	a0,a0,-1600 # 8000b1f0 <digits+0x18>
    80003838:	ba0ff0ef          	jal	80002bd8 <uart_puts>
    8000383c:	0309851b          	addw	a0,s3,48
    80003840:	0ff57513          	zext.b	a0,a0
    80003844:	b7cff0ef          	jal	80002bc0 <uart_putc>
    80003848:	db5ff06f          	j	800035fc <dump_pagetable+0x80>
    8000384c:	0304851b          	addw	a0,s1,48
    80003850:	0ff57513          	zext.b	a0,a0
    80003854:	b6cff0ef          	jal	80002bc0 <uart_putc>
    80003858:	e4dff06f          	j	800036a4 <dump_pagetable+0x128>

000000008000385c <init_page_replacement>:
    8000385c:	00100713          	li	a4,1
    80003860:	02a71713          	sll	a4,a4,0x2a
    80003864:	0000e797          	auipc	a5,0xe
    80003868:	91478793          	add	a5,a5,-1772 # 80011178 <swap_mgr>
    8000386c:	08e7b023          	sd	a4,128(a5)
    80003870:	0000e717          	auipc	a4,0xe
    80003874:	98072823          	sw	zero,-1648(a4) # 80011200 <swap_mgr+0x88>
    80003878:	0000e717          	auipc	a4,0xe
    8000387c:	98070713          	add	a4,a4,-1664 # 800111f8 <swap_mgr+0x80>
    80003880:	0007a023          	sw	zero,0(a5)
    80003884:	00478793          	add	a5,a5,4
    80003888:	fee79ce3          	bne	a5,a4,80003880 <init_page_replacement+0x24>
    8000388c:	0040e797          	auipc	a5,0x40e
    80003890:	9607be23          	sd	zero,-1668(a5) # 80411208 <lru_mgr>
    80003894:	0040e797          	auipc	a5,0x40e
    80003898:	9607be23          	sd	zero,-1668(a5) # 80411210 <lru_mgr+0x8>
    8000389c:	00100793          	li	a5,1
    800038a0:	02879793          	sll	a5,a5,0x28
    800038a4:	00411717          	auipc	a4,0x411
    800038a8:	96f73a23          	sd	a5,-1676(a4) # 80414218 <lru_mgr+0x3010>
    800038ac:	fff00713          	li	a4,-1
    800038b0:	0040e797          	auipc	a5,0x40e
    800038b4:	96878793          	add	a5,a5,-1688 # 80411218 <lru_mgr+0x10>
    800038b8:	00411697          	auipc	a3,0x411
    800038bc:	96068693          	add	a3,a3,-1696 # 80414218 <lru_mgr+0x3010>
    800038c0:	02075713          	srl	a4,a4,0x20
    800038c4:	0007b023          	sd	zero,0(a5)
    800038c8:	0007b423          	sd	zero,8(a5)
    800038cc:	00e7b823          	sd	a4,16(a5)
    800038d0:	0007bc23          	sd	zero,24(a5)
    800038d4:	0207b023          	sd	zero,32(a5)
    800038d8:	0207b423          	sd	zero,40(a5)
    800038dc:	03078793          	add	a5,a5,48
    800038e0:	fed792e3          	bne	a5,a3,800038c4 <init_page_replacement+0x68>
    800038e4:	00008067          	ret

00000000800038e8 <kvminit>:
    800038e8:	fd010113          	add	sp,sp,-48
    800038ec:	02113423          	sd	ra,40(sp)
    800038f0:	02813023          	sd	s0,32(sp)
    800038f4:	00913c23          	sd	s1,24(sp)
    800038f8:	01213823          	sd	s2,16(sp)
    800038fc:	01313423          	sd	s3,8(sp)
    80003900:	01413023          	sd	s4,0(sp)
    80003904:	f59ff0ef          	jal	8000385c <init_page_replacement>
    80003908:	b7cff0ef          	jal	80002c84 <alloc_page>
    8000390c:	00001737          	lui	a4,0x1
    80003910:	00e50733          	add	a4,a0,a4
    80003914:	00050413          	mv	s0,a0
    80003918:	00050793          	mv	a5,a0
    8000391c:	1a050663          	beqz	a0,80003ac8 <kvminit+0x1e0>
    80003920:	0007b023          	sd	zero,0(a5)
    80003924:	00878793          	add	a5,a5,8
    80003928:	fef71ce3          	bne	a4,a5,80003920 <kvminit+0x38>
    8000392c:	00424917          	auipc	s2,0x424
    80003930:	39c90913          	add	s2,s2,924 # 80427cc8 <kernel_pagetable>
    80003934:	00005997          	auipc	s3,0x5
    80003938:	03f98993          	add	s3,s3,63 # 80008973 <rodata_start+0x973>
    8000393c:	fffff7b7          	lui	a5,0xfffff
    80003940:	00893023          	sd	s0,0(s2)
    80003944:	ffffc497          	auipc	s1,0xffffc
    80003948:	6bc48493          	add	s1,s1,1724 # 80000000 <_entry>
    8000394c:	00f9f9b3          	and	s3,s3,a5
    80003950:	0334f863          	bgeu	s1,s3,80003980 <kvminit+0x98>
    80003954:	00001a37          	lui	s4,0x1
    80003958:	0080006f          	j	80003960 <kvminit+0x78>
    8000395c:	0334f063          	bgeu	s1,s3,8000397c <kvminit+0x94>
    80003960:	00048613          	mv	a2,s1
    80003964:	00048593          	mv	a1,s1
    80003968:	00a00693          	li	a3,10
    8000396c:	00040513          	mv	a0,s0
    80003970:	dbcff0ef          	jal	80002f2c <map_page>
    80003974:	014484b3          	add	s1,s1,s4
    80003978:	fe0502e3          	beqz	a0,8000395c <kvminit+0x74>
    8000397c:	00093403          	ld	s0,0(s2)
    80003980:	00009997          	auipc	s3,0x9
    80003984:	68f98993          	add	s3,s3,1679 # 8000d00f <syscall_table+0xf>
    80003988:	fffff7b7          	lui	a5,0xfffff
    8000398c:	00004497          	auipc	s1,0x4
    80003990:	67448493          	add	s1,s1,1652 # 80008000 <rodata_start>
    80003994:	00f9f9b3          	and	s3,s3,a5
    80003998:	0334f863          	bgeu	s1,s3,800039c8 <kvminit+0xe0>
    8000399c:	00001a37          	lui	s4,0x1
    800039a0:	0080006f          	j	800039a8 <kvminit+0xc0>
    800039a4:	0334f063          	bgeu	s1,s3,800039c4 <kvminit+0xdc>
    800039a8:	00048613          	mv	a2,s1
    800039ac:	00048593          	mv	a1,s1
    800039b0:	00200693          	li	a3,2
    800039b4:	00040513          	mv	a0,s0
    800039b8:	d74ff0ef          	jal	80002f2c <map_page>
    800039bc:	014484b3          	add	s1,s1,s4
    800039c0:	fe0502e3          	beqz	a0,800039a4 <kvminit+0xbc>
    800039c4:	00093403          	ld	s0,0(s2)
    800039c8:	0000a997          	auipc	s3,0xa
    800039cc:	6cb98993          	add	s3,s3,1739 # 8000e093 <data_end+0xfff>
    800039d0:	fffff7b7          	lui	a5,0xfffff
    800039d4:	00009497          	auipc	s1,0x9
    800039d8:	62c48493          	add	s1,s1,1580 # 8000d000 <syscall_table>
    800039dc:	00f9f9b3          	and	s3,s3,a5
    800039e0:	0334f863          	bgeu	s1,s3,80003a10 <kvminit+0x128>
    800039e4:	00001a37          	lui	s4,0x1
    800039e8:	0080006f          	j	800039f0 <kvminit+0x108>
    800039ec:	0334f063          	bgeu	s1,s3,80003a0c <kvminit+0x124>
    800039f0:	00048613          	mv	a2,s1
    800039f4:	00048593          	mv	a1,s1
    800039f8:	00600693          	li	a3,6
    800039fc:	00040513          	mv	a0,s0
    80003a00:	d2cff0ef          	jal	80002f2c <map_page>
    80003a04:	014484b3          	add	s1,s1,s4
    80003a08:	fe0502e3          	beqz	a0,800039ec <kvminit+0x104>
    80003a0c:	00093403          	ld	s0,0(s2)
    80003a10:	00425997          	auipc	s3,0x425
    80003a14:	2e798993          	add	s3,s3,743 # 80428cf7 <bss_end+0xfff>
    80003a18:	fffff7b7          	lui	a5,0xfffff
    80003a1c:	0000c497          	auipc	s1,0xc
    80003a20:	5e448493          	add	s1,s1,1508 # 80010000 <bss_start>
    80003a24:	00f9f9b3          	and	s3,s3,a5
    80003a28:	0334f863          	bgeu	s1,s3,80003a58 <kvminit+0x170>
    80003a2c:	00001a37          	lui	s4,0x1
    80003a30:	0080006f          	j	80003a38 <kvminit+0x150>
    80003a34:	0334f063          	bgeu	s1,s3,80003a54 <kvminit+0x16c>
    80003a38:	00048613          	mv	a2,s1
    80003a3c:	00048593          	mv	a1,s1
    80003a40:	00600693          	li	a3,6
    80003a44:	00040513          	mv	a0,s0
    80003a48:	ce4ff0ef          	jal	80002f2c <map_page>
    80003a4c:	014484b3          	add	s1,s1,s4
    80003a50:	fe0502e3          	beqz	a0,80003a34 <kvminit+0x14c>
    80003a54:	00093403          	ld	s0,0(s2)
    80003a58:	01100993          	li	s3,17
    80003a5c:	00424497          	auipc	s1,0x424
    80003a60:	29c48493          	add	s1,s1,668 # 80427cf8 <bss_end>
    80003a64:	01b99993          	sll	s3,s3,0x1b
    80003a68:	0334f863          	bgeu	s1,s3,80003a98 <kvminit+0x1b0>
    80003a6c:	00001a37          	lui	s4,0x1
    80003a70:	0080006f          	j	80003a78 <kvminit+0x190>
    80003a74:	0334f063          	bgeu	s1,s3,80003a94 <kvminit+0x1ac>
    80003a78:	00048613          	mv	a2,s1
    80003a7c:	00048593          	mv	a1,s1
    80003a80:	00600693          	li	a3,6
    80003a84:	00040513          	mv	a0,s0
    80003a88:	ca4ff0ef          	jal	80002f2c <map_page>
    80003a8c:	014484b3          	add	s1,s1,s4
    80003a90:	fe0502e3          	beqz	a0,80003a74 <kvminit+0x18c>
    80003a94:	00093403          	ld	s0,0(s2)
    80003a98:	00040513          	mv	a0,s0
    80003a9c:	02013403          	ld	s0,32(sp)
    80003aa0:	02813083          	ld	ra,40(sp)
    80003aa4:	01813483          	ld	s1,24(sp)
    80003aa8:	01013903          	ld	s2,16(sp)
    80003aac:	00813983          	ld	s3,8(sp)
    80003ab0:	00013a03          	ld	s4,0(sp)
    80003ab4:	00600693          	li	a3,6
    80003ab8:	10000637          	lui	a2,0x10000
    80003abc:	100005b7          	lui	a1,0x10000
    80003ac0:	03010113          	add	sp,sp,48
    80003ac4:	c68ff06f          	j	80002f2c <map_page>
    80003ac8:	02813083          	ld	ra,40(sp)
    80003acc:	02013403          	ld	s0,32(sp)
    80003ad0:	00424797          	auipc	a5,0x424
    80003ad4:	1e07bc23          	sd	zero,504(a5) # 80427cc8 <kernel_pagetable>
    80003ad8:	01813483          	ld	s1,24(sp)
    80003adc:	01013903          	ld	s2,16(sp)
    80003ae0:	00813983          	ld	s3,8(sp)
    80003ae4:	00013a03          	ld	s4,0(sp)
    80003ae8:	03010113          	add	sp,sp,48
    80003aec:	00008067          	ret

0000000080003af0 <alloc_swap_slot>:
    80003af0:	0000d617          	auipc	a2,0xd
    80003af4:	68860613          	add	a2,a2,1672 # 80011178 <swap_mgr>
    80003af8:	08862803          	lw	a6,136(a2)
    80003afc:	08462883          	lw	a7,132(a2)
    80003b00:	fff00513          	li	a0,-1
    80003b04:	0d187663          	bgeu	a6,a7,80003bd0 <alloc_swap_slot+0xe0>
    80003b08:	08062303          	lw	t1,128(a2)
    80003b0c:	07137863          	bgeu	t1,a7,80003b7c <alloc_swap_slot+0x8c>
    80003b10:	0053579b          	srlw	a5,t1,0x5
    80003b14:	00279793          	sll	a5,a5,0x2
    80003b18:	00f607b3          	add	a5,a2,a5
    80003b1c:	0007a683          	lw	a3,0(a5)
    80003b20:	00100593          	li	a1,1
    80003b24:	006595bb          	sllw	a1,a1,t1
    80003b28:	00b6f7b3          	and	a5,a3,a1
    80003b2c:	0007879b          	sext.w	a5,a5
    80003b30:	0053571b          	srlw	a4,t1,0x5
    80003b34:	00030513          	mv	a0,t1
    80003b38:	08078e63          	beqz	a5,80003bd4 <alloc_swap_slot+0xe4>
    80003b3c:	00100e13          	li	t3,1
    80003b40:	01c0006f          	j	80003b5c <alloc_swap_slot+0x6c>
    80003b44:	0006a683          	lw	a3,0(a3)
    80003b48:	0007859b          	sext.w	a1,a5
    80003b4c:	0057571b          	srlw	a4,a4,0x5
    80003b50:	00f6f7b3          	and	a5,a3,a5
    80003b54:	0007879b          	sext.w	a5,a5
    80003b58:	06078e63          	beqz	a5,80003bd4 <alloc_swap_slot+0xe4>
    80003b5c:	0015071b          	addw	a4,a0,1
    80003b60:	0057579b          	srlw	a5,a4,0x5
    80003b64:	00279793          	sll	a5,a5,0x2
    80003b68:	0007051b          	sext.w	a0,a4
    80003b6c:	00f606b3          	add	a3,a2,a5
    80003b70:	00ee17bb          	sllw	a5,t3,a4
    80003b74:	fca898e3          	bne	a7,a0,80003b44 <alloc_swap_slot+0x54>
    80003b78:	04030a63          	beqz	t1,80003bcc <alloc_swap_slot+0xdc>
    80003b7c:	00062683          	lw	a3,0(a2)
    80003b80:	0016f513          	and	a0,a3,1
    80003b84:	0a050063          	beqz	a0,80003c24 <alloc_swap_slot+0x134>
    80003b88:	00000513          	li	a0,0
    80003b8c:	00100e13          	li	t3,1
    80003b90:	01c0006f          	j	80003bac <alloc_swap_slot+0xbc>
    80003b94:	0006a683          	lw	a3,0(a3)
    80003b98:	00078e9b          	sext.w	t4,a5
    80003b9c:	0057571b          	srlw	a4,a4,0x5
    80003ba0:	00f6f7b3          	and	a5,a3,a5
    80003ba4:	0007879b          	sext.w	a5,a5
    80003ba8:	04078a63          	beqz	a5,80003bfc <alloc_swap_slot+0x10c>
    80003bac:	0015071b          	addw	a4,a0,1
    80003bb0:	0057579b          	srlw	a5,a4,0x5
    80003bb4:	00279793          	sll	a5,a5,0x2
    80003bb8:	0005059b          	sext.w	a1,a0
    80003bbc:	0007051b          	sext.w	a0,a4
    80003bc0:	00f606b3          	add	a3,a2,a5
    80003bc4:	00ee17bb          	sllw	a5,t3,a4
    80003bc8:	fca316e3          	bne	t1,a0,80003b94 <alloc_swap_slot+0xa4>
    80003bcc:	fff00513          	li	a0,-1
    80003bd0:	00008067          	ret
    80003bd4:	0015079b          	addw	a5,a0,1
    80003bd8:	0317f7bb          	remuw	a5,a5,a7
    80003bdc:	00271713          	sll	a4,a4,0x2
    80003be0:	00e60733          	add	a4,a2,a4
    80003be4:	00b6e6b3          	or	a3,a3,a1
    80003be8:	0018081b          	addw	a6,a6,1
    80003bec:	00d72023          	sw	a3,0(a4) # 1000 <_entry-0x7ffff000>
    80003bf0:	09062423          	sw	a6,136(a2)
    80003bf4:	08f62023          	sw	a5,128(a2)
    80003bf8:	00008067          	ret
    80003bfc:	0025859b          	addw	a1,a1,2 # 10000002 <_entry-0x6ffffffe>
    80003c00:	0315f5bb          	remuw	a1,a1,a7
    80003c04:	00271713          	sll	a4,a4,0x2
    80003c08:	00e60733          	add	a4,a2,a4
    80003c0c:	01d6e6b3          	or	a3,a3,t4
    80003c10:	0018081b          	addw	a6,a6,1
    80003c14:	00d72023          	sw	a3,0(a4)
    80003c18:	09062423          	sw	a6,136(a2)
    80003c1c:	08b62023          	sw	a1,128(a2)
    80003c20:	00008067          	ret
    80003c24:	00000713          	li	a4,0
    80003c28:	00100593          	li	a1,1
    80003c2c:	00100e93          	li	t4,1
    80003c30:	fd1ff06f          	j	80003c00 <alloc_swap_slot+0x110>

0000000080003c34 <free_swap_slot>:
    80003c34:	0000d717          	auipc	a4,0xd
    80003c38:	54470713          	add	a4,a4,1348 # 80011178 <swap_mgr>
    80003c3c:	08472783          	lw	a5,132(a4)
    80003c40:	04f57663          	bgeu	a0,a5,80003c8c <free_swap_slot+0x58>
    80003c44:	0055579b          	srlw	a5,a0,0x5
    80003c48:	00279793          	sll	a5,a5,0x2
    80003c4c:	00f707b3          	add	a5,a4,a5
    80003c50:	0007a583          	lw	a1,0(a5)
    80003c54:	00100693          	li	a3,1
    80003c58:	00a696bb          	sllw	a3,a3,a0
    80003c5c:	00d5f633          	and	a2,a1,a3
    80003c60:	0006061b          	sext.w	a2,a2
    80003c64:	02060463          	beqz	a2,80003c8c <free_swap_slot+0x58>
    80003c68:	08872603          	lw	a2,136(a4)
    80003c6c:	fff6c693          	not	a3,a3
    80003c70:	08072803          	lw	a6,128(a4)
    80003c74:	00d5f5b3          	and	a1,a1,a3
    80003c78:	fff6069b          	addw	a3,a2,-1
    80003c7c:	00b7a023          	sw	a1,0(a5)
    80003c80:	08d72423          	sw	a3,136(a4)
    80003c84:	01057463          	bgeu	a0,a6,80003c8c <free_swap_slot+0x58>
    80003c88:	08a72023          	sw	a0,128(a4)
    80003c8c:	00008067          	ret

0000000080003c90 <find_page_desc>:
    80003c90:	fffff7b7          	lui	a5,0xfffff
    80003c94:	00f57533          	and	a0,a0,a5
    80003c98:	00000713          	li	a4,0
    80003c9c:	0040d797          	auipc	a5,0x40d
    80003ca0:	57c78793          	add	a5,a5,1404 # 80411218 <lru_mgr+0x10>
    80003ca4:	10000613          	li	a2,256
    80003ca8:	0100006f          	j	80003cb8 <find_page_desc+0x28>
    80003cac:	0017071b          	addw	a4,a4,1
    80003cb0:	03078793          	add	a5,a5,48
    80003cb4:	02c70a63          	beq	a4,a2,80003ce8 <find_page_desc+0x58>
    80003cb8:	0007b683          	ld	a3,0(a5)
    80003cbc:	fea698e3          	bne	a3,a0,80003cac <find_page_desc+0x1c>
    80003cc0:	0147a683          	lw	a3,20(a5)
    80003cc4:	0016f693          	and	a3,a3,1
    80003cc8:	fe0682e3          	beqz	a3,80003cac <find_page_desc+0x1c>
    80003ccc:	00171513          	sll	a0,a4,0x1
    80003cd0:	00e50533          	add	a0,a0,a4
    80003cd4:	0040d797          	auipc	a5,0x40d
    80003cd8:	54478793          	add	a5,a5,1348 # 80411218 <lru_mgr+0x10>
    80003cdc:	00451513          	sll	a0,a0,0x4
    80003ce0:	00f50533          	add	a0,a0,a5
    80003ce4:	00008067          	ret
    80003ce8:	00000513          	li	a0,0
    80003cec:	00008067          	ret

0000000080003cf0 <lru_add_page>:
    80003cf0:	02050c63          	beqz	a0,80003d28 <lru_add_page+0x38>
    80003cf4:	0040d717          	auipc	a4,0x40d
    80003cf8:	51470713          	add	a4,a4,1300 # 80411208 <lru_mgr>
    80003cfc:	00073783          	ld	a5,0(a4)
    80003d00:	00053c23          	sd	zero,24(a0)
    80003d04:	02f53023          	sd	a5,32(a0)
    80003d08:	02078263          	beqz	a5,80003d2c <lru_add_page+0x3c>
    80003d0c:	00a7bc23          	sd	a0,24(a5)
    80003d10:	00410697          	auipc	a3,0x410
    80003d14:	4f868693          	add	a3,a3,1272 # 80414208 <lru_mgr+0x3000>
    80003d18:	0106a783          	lw	a5,16(a3)
    80003d1c:	00a73023          	sd	a0,0(a4)
    80003d20:	0017879b          	addw	a5,a5,1
    80003d24:	00f6a823          	sw	a5,16(a3)
    80003d28:	00008067          	ret
    80003d2c:	00a73423          	sd	a0,8(a4)
    80003d30:	fe1ff06f          	j	80003d10 <lru_add_page+0x20>

0000000080003d34 <lru_remove_page>:
    80003d34:	02050c63          	beqz	a0,80003d6c <lru_remove_page+0x38>
    80003d38:	01853783          	ld	a5,24(a0)
    80003d3c:	02053703          	ld	a4,32(a0)
    80003d40:	02078863          	beqz	a5,80003d70 <lru_remove_page+0x3c>
    80003d44:	02e7b023          	sd	a4,32(a5)
    80003d48:	02070a63          	beqz	a4,80003d7c <lru_remove_page+0x48>
    80003d4c:	00f73c23          	sd	a5,24(a4)
    80003d50:	00410717          	auipc	a4,0x410
    80003d54:	4b870713          	add	a4,a4,1208 # 80414208 <lru_mgr+0x3000>
    80003d58:	01072783          	lw	a5,16(a4)
    80003d5c:	02053023          	sd	zero,32(a0)
    80003d60:	00053c23          	sd	zero,24(a0)
    80003d64:	fff7879b          	addw	a5,a5,-1
    80003d68:	00f72823          	sw	a5,16(a4)
    80003d6c:	00008067          	ret
    80003d70:	0040d697          	auipc	a3,0x40d
    80003d74:	48e6bc23          	sd	a4,1176(a3) # 80411208 <lru_mgr>
    80003d78:	fc071ae3          	bnez	a4,80003d4c <lru_remove_page+0x18>
    80003d7c:	0040d717          	auipc	a4,0x40d
    80003d80:	48f73a23          	sd	a5,1172(a4) # 80411210 <lru_mgr+0x8>
    80003d84:	fcdff06f          	j	80003d50 <lru_remove_page+0x1c>

0000000080003d88 <lru_touch_page>:
    80003d88:	fffff7b7          	lui	a5,0xfffff
    80003d8c:	00f57533          	and	a0,a0,a5
    80003d90:	00000713          	li	a4,0
    80003d94:	0040d797          	auipc	a5,0x40d
    80003d98:	48478793          	add	a5,a5,1156 # 80411218 <lru_mgr+0x10>
    80003d9c:	10000613          	li	a2,256
    80003da0:	0100006f          	j	80003db0 <lru_touch_page+0x28>
    80003da4:	0017071b          	addw	a4,a4,1
    80003da8:	03078793          	add	a5,a5,48
    80003dac:	0ac70663          	beq	a4,a2,80003e58 <lru_touch_page+0xd0>
    80003db0:	0007b683          	ld	a3,0(a5)
    80003db4:	fea698e3          	bne	a3,a0,80003da4 <lru_touch_page+0x1c>
    80003db8:	0147a683          	lw	a3,20(a5)
    80003dbc:	0016f693          	and	a3,a3,1
    80003dc0:	fe0682e3          	beqz	a3,80003da4 <lru_touch_page+0x1c>
    80003dc4:	00171613          	sll	a2,a4,0x1
    80003dc8:	00e607b3          	add	a5,a2,a4
    80003dcc:	0040d597          	auipc	a1,0x40d
    80003dd0:	43c58593          	add	a1,a1,1084 # 80411208 <lru_mgr>
    80003dd4:	00479793          	sll	a5,a5,0x4
    80003dd8:	00170513          	add	a0,a4,1
    80003ddc:	00f58833          	add	a6,a1,a5
    80003de0:	00151693          	sll	a3,a0,0x1
    80003de4:	00a686b3          	add	a3,a3,a0
    80003de8:	02883803          	ld	a6,40(a6)
    80003dec:	00469693          	sll	a3,a3,0x4
    80003df0:	01078793          	add	a5,a5,16
    80003df4:	00d586b3          	add	a3,a1,a3
    80003df8:	0006b683          	ld	a3,0(a3)
    80003dfc:	00f587b3          	add	a5,a1,a5
    80003e00:	04080e63          	beqz	a6,80003e5c <lru_touch_page+0xd4>
    80003e04:	02d83023          	sd	a3,32(a6)
    80003e08:	0005b883          	ld	a7,0(a1)
    80003e0c:	04068c63          	beqz	a3,80003e64 <lru_touch_page+0xdc>
    80003e10:	0106bc23          	sd	a6,24(a3)
    80003e14:	00151693          	sll	a3,a0,0x1
    80003e18:	00e60733          	add	a4,a2,a4
    80003e1c:	00a686b3          	add	a3,a3,a0
    80003e20:	00469693          	sll	a3,a3,0x4
    80003e24:	00471713          	sll	a4,a4,0x4
    80003e28:	00e58733          	add	a4,a1,a4
    80003e2c:	00d586b3          	add	a3,a1,a3
    80003e30:	00410617          	auipc	a2,0x410
    80003e34:	3d860613          	add	a2,a2,984 # 80414208 <lru_mgr+0x3000>
    80003e38:	02073423          	sd	zero,40(a4)
    80003e3c:	0116b023          	sd	a7,0(a3)
    80003e40:	01062703          	lw	a4,16(a2)
    80003e44:	02088463          	beqz	a7,80003e6c <lru_touch_page+0xe4>
    80003e48:	00f8bc23          	sd	a5,24(a7)
    80003e4c:	00f5b023          	sd	a5,0(a1)
    80003e50:	00e62823          	sw	a4,16(a2)
    80003e54:	00008067          	ret
    80003e58:	00008067          	ret
    80003e5c:	00068893          	mv	a7,a3
    80003e60:	fa0698e3          	bnez	a3,80003e10 <lru_touch_page+0x88>
    80003e64:	0105b423          	sd	a6,8(a1)
    80003e68:	fadff06f          	j	80003e14 <lru_touch_page+0x8c>
    80003e6c:	00f5b423          	sd	a5,8(a1)
    80003e70:	00f5b023          	sd	a5,0(a1)
    80003e74:	00e62823          	sw	a4,16(a2)
    80003e78:	00008067          	ret

0000000080003e7c <find_victim_page>:
    80003e7c:	0040d517          	auipc	a0,0x40d
    80003e80:	39453503          	ld	a0,916(a0) # 80411210 <lru_mgr+0x8>
    80003e84:	00008067          	ret

0000000080003e88 <swap_out_page>:
    80003e88:	16050263          	beqz	a0,80003fec <swap_out_page+0x164>
    80003e8c:	fd010113          	add	sp,sp,-48
    80003e90:	00913c23          	sd	s1,24(sp)
    80003e94:	01452483          	lw	s1,20(a0)
    80003e98:	02813023          	sd	s0,32(sp)
    80003e9c:	01313423          	sd	s3,8(sp)
    80003ea0:	02113423          	sd	ra,40(sp)
    80003ea4:	01213823          	sd	s2,16(sp)
    80003ea8:	0014f793          	and	a5,s1,1
    80003eac:	00050413          	mv	s0,a0
    80003eb0:	00048993          	mv	s3,s1
    80003eb4:	12078863          	beqz	a5,80003fe4 <swap_out_page+0x15c>
    80003eb8:	c39ff0ef          	jal	80003af0 <alloc_swap_slot>
    80003ebc:	0005091b          	sext.w	s2,a0
    80003ec0:	fff00793          	li	a5,-1
    80003ec4:	12f90063          	beq	s2,a5,80003fe4 <swap_out_page+0x15c>
    80003ec8:	0049f993          	and	s3,s3,4
    80003ecc:	04098663          	beqz	s3,80003f18 <swap_out_page+0x90>
    80003ed0:	00843683          	ld	a3,8(s0)
    80003ed4:	00c9171b          	sllw	a4,s2,0xc
    80003ed8:	0000d797          	auipc	a5,0xd
    80003edc:	33078793          	add	a5,a5,816 # 80011208 <swap_area>
    80003ee0:	02071713          	sll	a4,a4,0x20
    80003ee4:	02075713          	srl	a4,a4,0x20
    80003ee8:	40f686b3          	sub	a3,a3,a5
    80003eec:	0000e617          	auipc	a2,0xe
    80003ef0:	31c60613          	add	a2,a2,796 # 80012208 <swap_area+0x1000>
    80003ef4:	00f707b3          	add	a5,a4,a5
    80003ef8:	00e60633          	add	a2,a2,a4
    80003efc:	40e686b3          	sub	a3,a3,a4
    80003f00:	00f68733          	add	a4,a3,a5
    80003f04:	00074703          	lbu	a4,0(a4)
    80003f08:	00178793          	add	a5,a5,1
    80003f0c:	fee78fa3          	sb	a4,-1(a5)
    80003f10:	fec798e3          	bne	a5,a2,80003f00 <swap_out_page+0x78>
    80003f14:	01442483          	lw	s1,20(s0)
    80003f18:	00043583          	ld	a1,0(s0)
    80003f1c:	02843503          	ld	a0,40(s0)
    80003f20:	e69fe0ef          	jal	80002d88 <walk_lookup>
    80003f24:	00050863          	beqz	a0,80003f34 <swap_out_page+0xac>
    80003f28:	00053783          	ld	a5,0(a0)
    80003f2c:	0017f713          	and	a4,a5,1
    80003f30:	08071063          	bnez	a4,80003fb0 <swap_out_page+0x128>
    80003f34:	ffe4f793          	and	a5,s1,-2
    80003f38:	0027e793          	or	a5,a5,2
    80003f3c:	02091913          	sll	s2,s2,0x20
    80003f40:	02079793          	sll	a5,a5,0x20
    80003f44:	00843503          	ld	a0,8(s0)
    80003f48:	02095913          	srl	s2,s2,0x20
    80003f4c:	00f96933          	or	s2,s2,a5
    80003f50:	01243823          	sd	s2,16(s0)
    80003f54:	d4dfe0ef          	jal	80002ca0 <free_page>
    80003f58:	01843783          	ld	a5,24(s0)
    80003f5c:	00043423          	sd	zero,8(s0)
    80003f60:	02043703          	ld	a4,32(s0)
    80003f64:	06078463          	beqz	a5,80003fcc <swap_out_page+0x144>
    80003f68:	02e7b023          	sd	a4,32(a5)
    80003f6c:	06070663          	beqz	a4,80003fd8 <swap_out_page+0x150>
    80003f70:	00f73c23          	sd	a5,24(a4)
    80003f74:	00410717          	auipc	a4,0x410
    80003f78:	29470713          	add	a4,a4,660 # 80414208 <lru_mgr+0x3000>
    80003f7c:	01072783          	lw	a5,16(a4)
    80003f80:	02043023          	sd	zero,32(s0)
    80003f84:	00043c23          	sd	zero,24(s0)
    80003f88:	fff7879b          	addw	a5,a5,-1
    80003f8c:	00f72823          	sw	a5,16(a4)
    80003f90:	00000513          	li	a0,0
    80003f94:	02813083          	ld	ra,40(sp)
    80003f98:	02013403          	ld	s0,32(sp)
    80003f9c:	01813483          	ld	s1,24(sp)
    80003fa0:	01013903          	ld	s2,16(sp)
    80003fa4:	00813983          	ld	s3,8(sp)
    80003fa8:	03010113          	add	sp,sp,48
    80003fac:	00008067          	ret
    80003fb0:	00a9171b          	sllw	a4,s2,0xa
    80003fb4:	02071713          	sll	a4,a4,0x20
    80003fb8:	ffe7f793          	and	a5,a5,-2
    80003fbc:	02075713          	srl	a4,a4,0x20
    80003fc0:	00e7e7b3          	or	a5,a5,a4
    80003fc4:	00f53023          	sd	a5,0(a0)
    80003fc8:	f6dff06f          	j	80003f34 <swap_out_page+0xac>
    80003fcc:	0040d697          	auipc	a3,0x40d
    80003fd0:	22e6be23          	sd	a4,572(a3) # 80411208 <lru_mgr>
    80003fd4:	f8071ee3          	bnez	a4,80003f70 <swap_out_page+0xe8>
    80003fd8:	0040d717          	auipc	a4,0x40d
    80003fdc:	22f73c23          	sd	a5,568(a4) # 80411210 <lru_mgr+0x8>
    80003fe0:	f95ff06f          	j	80003f74 <swap_out_page+0xec>
    80003fe4:	fff00513          	li	a0,-1
    80003fe8:	fadff06f          	j	80003f94 <swap_out_page+0x10c>
    80003fec:	fff00513          	li	a0,-1
    80003ff0:	00008067          	ret

0000000080003ff4 <swap_in_page>:
    80003ff4:	12050263          	beqz	a0,80004118 <swap_in_page+0x124>
    80003ff8:	01452783          	lw	a5,20(a0)
    80003ffc:	fe010113          	add	sp,sp,-32
    80004000:	00813823          	sd	s0,16(sp)
    80004004:	00113c23          	sd	ra,24(sp)
    80004008:	00913423          	sd	s1,8(sp)
    8000400c:	0027f793          	and	a5,a5,2
    80004010:	00050413          	mv	s0,a0
    80004014:	0e078e63          	beqz	a5,80004110 <swap_in_page+0x11c>
    80004018:	01052703          	lw	a4,16(a0)
    8000401c:	0000d797          	auipc	a5,0xd
    80004020:	1ec78793          	add	a5,a5,492 # 80011208 <swap_area>
    80004024:	40f58633          	sub	a2,a1,a5
    80004028:	00c7171b          	sllw	a4,a4,0xc
    8000402c:	02071713          	sll	a4,a4,0x20
    80004030:	02075713          	srl	a4,a4,0x20
    80004034:	0000e817          	auipc	a6,0xe
    80004038:	1d480813          	add	a6,a6,468 # 80012208 <swap_area+0x1000>
    8000403c:	00058493          	mv	s1,a1
    80004040:	00f707b3          	add	a5,a4,a5
    80004044:	00e80833          	add	a6,a6,a4
    80004048:	40e60633          	sub	a2,a2,a4
    8000404c:	0007c683          	lbu	a3,0(a5)
    80004050:	00f60733          	add	a4,a2,a5
    80004054:	00178793          	add	a5,a5,1
    80004058:	00d70023          	sb	a3,0(a4)
    8000405c:	ff0798e3          	bne	a5,a6,8000404c <swap_in_page+0x58>
    80004060:	00043583          	ld	a1,0(s0)
    80004064:	02843503          	ld	a0,40(s0)
    80004068:	d21fe0ef          	jal	80002d88 <walk_lookup>
    8000406c:	02050063          	beqz	a0,8000408c <swap_in_page+0x98>
    80004070:	00053703          	ld	a4,0(a0)
    80004074:	00c4d793          	srl	a5,s1,0xc
    80004078:	00a79793          	sll	a5,a5,0xa
    8000407c:	01e77713          	and	a4,a4,30
    80004080:	00e7e7b3          	or	a5,a5,a4
    80004084:	0017e793          	or	a5,a5,1
    80004088:	00f53023          	sd	a5,0(a0)
    8000408c:	01442783          	lw	a5,20(s0)
    80004090:	01042503          	lw	a0,16(s0)
    80004094:	00943423          	sd	s1,8(s0)
    80004098:	ffd7f793          	and	a5,a5,-3
    8000409c:	0017e793          	or	a5,a5,1
    800040a0:	00f42a23          	sw	a5,20(s0)
    800040a4:	0000d797          	auipc	a5,0xd
    800040a8:	1587a783          	lw	a5,344(a5) # 800111fc <swap_mgr+0x84>
    800040ac:	00f57463          	bgeu	a0,a5,800040b4 <swap_in_page+0xc0>
    800040b0:	d4dfe0ef          	jal	80002dfc <free_swap_slot.part.0>
    800040b4:	0040d717          	auipc	a4,0x40d
    800040b8:	15470713          	add	a4,a4,340 # 80411208 <lru_mgr>
    800040bc:	00073783          	ld	a5,0(a4)
    800040c0:	fff00693          	li	a3,-1
    800040c4:	00d42823          	sw	a3,16(s0)
    800040c8:	02f43023          	sd	a5,32(s0)
    800040cc:	00043c23          	sd	zero,24(s0)
    800040d0:	02078c63          	beqz	a5,80004108 <swap_in_page+0x114>
    800040d4:	0087bc23          	sd	s0,24(a5)
    800040d8:	00410697          	auipc	a3,0x410
    800040dc:	13068693          	add	a3,a3,304 # 80414208 <lru_mgr+0x3000>
    800040e0:	0106a783          	lw	a5,16(a3)
    800040e4:	00873023          	sd	s0,0(a4)
    800040e8:	00000513          	li	a0,0
    800040ec:	0017879b          	addw	a5,a5,1
    800040f0:	00f6a823          	sw	a5,16(a3)
    800040f4:	01813083          	ld	ra,24(sp)
    800040f8:	01013403          	ld	s0,16(sp)
    800040fc:	00813483          	ld	s1,8(sp)
    80004100:	02010113          	add	sp,sp,32
    80004104:	00008067          	ret
    80004108:	00873423          	sd	s0,8(a4)
    8000410c:	fcdff06f          	j	800040d8 <swap_in_page+0xe4>
    80004110:	fff00513          	li	a0,-1
    80004114:	fe1ff06f          	j	800040f4 <swap_in_page+0x100>
    80004118:	fff00513          	li	a0,-1
    8000411c:	00008067          	ret

0000000080004120 <handle_page_fault>:
    80004120:	fd010113          	add	sp,sp,-48
    80004124:	fffff7b7          	lui	a5,0xfffff
    80004128:	02813023          	sd	s0,32(sp)
    8000412c:	00f5f433          	and	s0,a1,a5
    80004130:	00040593          	mv	a1,s0
    80004134:	01213823          	sd	s2,16(sp)
    80004138:	02113423          	sd	ra,40(sp)
    8000413c:	00913c23          	sd	s1,24(sp)
    80004140:	01313423          	sd	s3,8(sp)
    80004144:	00050913          	mv	s2,a0
    80004148:	c41fe0ef          	jal	80002d88 <walk_lookup>
    8000414c:	12050c63          	beqz	a0,80004284 <handle_page_fault+0x164>
    80004150:	00053483          	ld	s1,0(a0)
    80004154:	0014f793          	and	a5,s1,1
    80004158:	12079663          	bnez	a5,80004284 <handle_page_fault+0x164>
    8000415c:	12048463          	beqz	s1,80004284 <handle_page_fault+0x164>
    80004160:	00a4d493          	srl	s1,s1,0xa
    80004164:	b21fe0ef          	jal	80002c84 <alloc_page>
    80004168:	0004849b          	sext.w	s1,s1
    8000416c:	00050993          	mv	s3,a0
    80004170:	0e050a63          	beqz	a0,80004264 <handle_page_fault+0x144>
    80004174:	0040d797          	auipc	a5,0x40d
    80004178:	0a478793          	add	a5,a5,164 # 80411218 <lru_mgr+0x10>
    8000417c:	00000713          	li	a4,0
    80004180:	10000613          	li	a2,256
    80004184:	0100006f          	j	80004194 <handle_page_fault+0x74>
    80004188:	0017071b          	addw	a4,a4,1
    8000418c:	03078793          	add	a5,a5,48
    80004190:	06c70063          	beq	a4,a2,800041f0 <handle_page_fault+0xd0>
    80004194:	0007b683          	ld	a3,0(a5)
    80004198:	fe8698e3          	bne	a3,s0,80004188 <handle_page_fault+0x68>
    8000419c:	0147a683          	lw	a3,20(a5)
    800041a0:	0026f693          	and	a3,a3,2
    800041a4:	fe0682e3          	beqz	a3,80004188 <handle_page_fault+0x68>
    800041a8:	0107a683          	lw	a3,16(a5)
    800041ac:	fc969ee3          	bne	a3,s1,80004188 <handle_page_fault+0x68>
    800041b0:	00171513          	sll	a0,a4,0x1
    800041b4:	00e50533          	add	a0,a0,a4
    800041b8:	00451513          	sll	a0,a0,0x4
    800041bc:	0040d797          	auipc	a5,0x40d
    800041c0:	05c78793          	add	a5,a5,92 # 80411218 <lru_mgr+0x10>
    800041c4:	00f50533          	add	a0,a0,a5
    800041c8:	00098593          	mv	a1,s3
    800041cc:	e29ff0ef          	jal	80003ff4 <swap_in_page>
    800041d0:	0a051e63          	bnez	a0,8000428c <handle_page_fault+0x16c>
    800041d4:	02813083          	ld	ra,40(sp)
    800041d8:	02013403          	ld	s0,32(sp)
    800041dc:	01813483          	ld	s1,24(sp)
    800041e0:	01013903          	ld	s2,16(sp)
    800041e4:	00813983          	ld	s3,8(sp)
    800041e8:	03010113          	add	sp,sp,48
    800041ec:	00008067          	ret
    800041f0:	0040d717          	auipc	a4,0x40d
    800041f4:	03c70713          	add	a4,a4,60 # 8041122c <lru_mgr+0x24>
    800041f8:	00000793          	li	a5,0
    800041fc:	10000613          	li	a2,256
    80004200:	00c0006f          	j	8000420c <handle_page_fault+0xec>
    80004204:	0017879b          	addw	a5,a5,1
    80004208:	08c78263          	beq	a5,a2,8000428c <handle_page_fault+0x16c>
    8000420c:	00072683          	lw	a3,0(a4)
    80004210:	03070713          	add	a4,a4,48
    80004214:	fe0698e3          	bnez	a3,80004204 <handle_page_fault+0xe4>
    80004218:	00178613          	add	a2,a5,1
    8000421c:	00179713          	sll	a4,a5,0x1
    80004220:	00161693          	sll	a3,a2,0x1
    80004224:	00f707b3          	add	a5,a4,a5
    80004228:	00479793          	sll	a5,a5,0x4
    8000422c:	00c68733          	add	a4,a3,a2
    80004230:	0040d617          	auipc	a2,0x40d
    80004234:	fd860613          	add	a2,a2,-40 # 80411208 <lru_mgr>
    80004238:	00f606b3          	add	a3,a2,a5
    8000423c:	00471713          	sll	a4,a4,0x4
    80004240:	01078793          	add	a5,a5,16
    80004244:	00e60733          	add	a4,a2,a4
    80004248:	00c78533          	add	a0,a5,a2
    8000424c:	00200793          	li	a5,2
    80004250:	0086b823          	sd	s0,16(a3)
    80004254:	01273423          	sd	s2,8(a4)
    80004258:	0296a023          	sw	s1,32(a3)
    8000425c:	02f6a223          	sw	a5,36(a3)
    80004260:	f69ff06f          	j	800041c8 <handle_page_fault+0xa8>
    80004264:	0040d517          	auipc	a0,0x40d
    80004268:	fac53503          	ld	a0,-84(a0) # 80411210 <lru_mgr+0x8>
    8000426c:	00050c63          	beqz	a0,80004284 <handle_page_fault+0x164>
    80004270:	c19ff0ef          	jal	80003e88 <swap_out_page>
    80004274:	00051863          	bnez	a0,80004284 <handle_page_fault+0x164>
    80004278:	a0dfe0ef          	jal	80002c84 <alloc_page>
    8000427c:	00050993          	mv	s3,a0
    80004280:	ee051ae3          	bnez	a0,80004174 <handle_page_fault+0x54>
    80004284:	fff00513          	li	a0,-1
    80004288:	f4dff06f          	j	800041d4 <handle_page_fault+0xb4>
    8000428c:	00098513          	mv	a0,s3
    80004290:	a11fe0ef          	jal	80002ca0 <free_page>
    80004294:	fff00513          	li	a0,-1
    80004298:	f3dff06f          	j	800041d4 <handle_page_fault+0xb4>

000000008000429c <va2pa_with_replacement>:
    8000429c:	fe010113          	add	sp,sp,-32
    800042a0:	00913423          	sd	s1,8(sp)
    800042a4:	01213023          	sd	s2,0(sp)
    800042a8:	00113c23          	sd	ra,24(sp)
    800042ac:	00813823          	sd	s0,16(sp)
    800042b0:	00050493          	mv	s1,a0
    800042b4:	00058913          	mv	s2,a1
    800042b8:	ad1fe0ef          	jal	80002d88 <walk_lookup>
    800042bc:	00050a63          	beqz	a0,800042d0 <va2pa_with_replacement+0x34>
    800042c0:	00053403          	ld	s0,0(a0)
    800042c4:	00147793          	and	a5,s0,1
    800042c8:	06079663          	bnez	a5,80004334 <va2pa_with_replacement+0x98>
    800042cc:	02041063          	bnez	s0,800042ec <va2pa_with_replacement+0x50>
    800042d0:	00000513          	li	a0,0
    800042d4:	01813083          	ld	ra,24(sp)
    800042d8:	01013403          	ld	s0,16(sp)
    800042dc:	00813483          	ld	s1,8(sp)
    800042e0:	00013903          	ld	s2,0(sp)
    800042e4:	02010113          	add	sp,sp,32
    800042e8:	00008067          	ret
    800042ec:	00600613          	li	a2,6
    800042f0:	00090593          	mv	a1,s2
    800042f4:	00048513          	mv	a0,s1
    800042f8:	e29ff0ef          	jal	80004120 <handle_page_fault>
    800042fc:	fc051ae3          	bnez	a0,800042d0 <va2pa_with_replacement+0x34>
    80004300:	00090593          	mv	a1,s2
    80004304:	00048513          	mv	a0,s1
    80004308:	a81fe0ef          	jal	80002d88 <walk_lookup>
    8000430c:	fc0502e3          	beqz	a0,800042d0 <va2pa_with_replacement+0x34>
    80004310:	00053783          	ld	a5,0(a0)
    80004314:	0017f713          	and	a4,a5,1
    80004318:	fa070ce3          	beqz	a4,800042d0 <va2pa_with_replacement+0x34>
    8000431c:	00a7d793          	srl	a5,a5,0xa
    80004320:	03491593          	sll	a1,s2,0x34
    80004324:	00c79513          	sll	a0,a5,0xc
    80004328:	0345d593          	srl	a1,a1,0x34
    8000432c:	00b50533          	add	a0,a0,a1
    80004330:	fa5ff06f          	j	800042d4 <va2pa_with_replacement+0x38>
    80004334:	00090513          	mv	a0,s2
    80004338:	a51ff0ef          	jal	80003d88 <lru_touch_page>
    8000433c:	01813083          	ld	ra,24(sp)
    80004340:	00a45513          	srl	a0,s0,0xa
    80004344:	01013403          	ld	s0,16(sp)
    80004348:	03491593          	sll	a1,s2,0x34
    8000434c:	00c51513          	sll	a0,a0,0xc
    80004350:	0345d593          	srl	a1,a1,0x34
    80004354:	00813483          	ld	s1,8(sp)
    80004358:	00013903          	ld	s2,0(sp)
    8000435c:	00b50533          	add	a0,a0,a1
    80004360:	02010113          	add	sp,sp,32
    80004364:	00008067          	ret

0000000080004368 <safe_copyout>:
    80004368:	14068063          	beqz	a3,800044a8 <safe_copyout+0x140>
    8000436c:	fb010113          	add	sp,sp,-80
    80004370:	02913c23          	sd	s1,56(sp)
    80004374:	03213823          	sd	s2,48(sp)
    80004378:	03313423          	sd	s3,40(sp)
    8000437c:	03413023          	sd	s4,32(sp)
    80004380:	01513c23          	sd	s5,24(sp)
    80004384:	01613823          	sd	s6,16(sp)
    80004388:	01713423          	sd	s7,8(sp)
    8000438c:	01813023          	sd	s8,0(sp)
    80004390:	04113423          	sd	ra,72(sp)
    80004394:	04813023          	sd	s0,64(sp)
    80004398:	00068b13          	mv	s6,a3
    8000439c:	00050993          	mv	s3,a0
    800043a0:	00058c13          	mv	s8,a1
    800043a4:	00060b93          	mv	s7,a2
    800043a8:	fffffa37          	lui	s4,0xfffff
    800043ac:	00001937          	lui	s2,0x1
    800043b0:	10000493          	li	s1,256
    800043b4:	0040da97          	auipc	s5,0x40d
    800043b8:	e54a8a93          	add	s5,s5,-428 # 80411208 <lru_mgr>
    800043bc:	014c7433          	and	s0,s8,s4
    800043c0:	00040593          	mv	a1,s0
    800043c4:	00098513          	mv	a0,s3
    800043c8:	ed5ff0ef          	jal	8000429c <va2pa_with_replacement>
    800043cc:	0c050a63          	beqz	a0,800044a0 <safe_copyout+0x138>
    800043d0:	41840833          	sub	a6,s0,s8
    800043d4:	01280833          	add	a6,a6,s2
    800043d8:	010b7463          	bgeu	s6,a6,800043e0 <safe_copyout+0x78>
    800043dc:	000b0813          	mv	a6,s6
    800043e0:	01850733          	add	a4,a0,s8
    800043e4:	40870733          	sub	a4,a4,s0
    800043e8:	01780533          	add	a0,a6,s7
    800043ec:	000b8793          	mv	a5,s7
    800043f0:	41770733          	sub	a4,a4,s7
    800043f4:	0a080263          	beqz	a6,80004498 <safe_copyout+0x130>
    800043f8:	0007c583          	lbu	a1,0(a5)
    800043fc:	00f70633          	add	a2,a4,a5
    80004400:	00178793          	add	a5,a5,1
    80004404:	00b60023          	sb	a1,0(a2)
    80004408:	fef518e3          	bne	a0,a5,800043f8 <safe_copyout+0x90>
    8000440c:	0040d797          	auipc	a5,0x40d
    80004410:	e0c78793          	add	a5,a5,-500 # 80411218 <lru_mgr+0x10>
    80004414:	00000713          	li	a4,0
    80004418:	0100006f          	j	80004428 <safe_copyout+0xc0>
    8000441c:	0017071b          	addw	a4,a4,1
    80004420:	03078793          	add	a5,a5,48
    80004424:	02970863          	beq	a4,s1,80004454 <safe_copyout+0xec>
    80004428:	0007b603          	ld	a2,0(a5)
    8000442c:	fec418e3          	bne	s0,a2,8000441c <safe_copyout+0xb4>
    80004430:	0147a603          	lw	a2,20(a5)
    80004434:	00167593          	and	a1,a2,1
    80004438:	fe0582e3          	beqz	a1,8000441c <safe_copyout+0xb4>
    8000443c:	00171793          	sll	a5,a4,0x1
    80004440:	00e787b3          	add	a5,a5,a4
    80004444:	00479793          	sll	a5,a5,0x4
    80004448:	00fa87b3          	add	a5,s5,a5
    8000444c:	00466613          	or	a2,a2,4
    80004450:	02c7a223          	sw	a2,36(a5)
    80004454:	410b0b33          	sub	s6,s6,a6
    80004458:	00050b93          	mv	s7,a0
    8000445c:	01240c33          	add	s8,s0,s2
    80004460:	f40b1ee3          	bnez	s6,800043bc <safe_copyout+0x54>
    80004464:	00000513          	li	a0,0
    80004468:	04813083          	ld	ra,72(sp)
    8000446c:	04013403          	ld	s0,64(sp)
    80004470:	03813483          	ld	s1,56(sp)
    80004474:	03013903          	ld	s2,48(sp)
    80004478:	02813983          	ld	s3,40(sp)
    8000447c:	02013a03          	ld	s4,32(sp)
    80004480:	01813a83          	ld	s5,24(sp)
    80004484:	01013b03          	ld	s6,16(sp)
    80004488:	00813b83          	ld	s7,8(sp)
    8000448c:	00013c03          	ld	s8,0(sp)
    80004490:	05010113          	add	sp,sp,80
    80004494:	00008067          	ret
    80004498:	000b8513          	mv	a0,s7
    8000449c:	f71ff06f          	j	8000440c <safe_copyout+0xa4>
    800044a0:	fff00513          	li	a0,-1
    800044a4:	fc5ff06f          	j	80004468 <safe_copyout+0x100>
    800044a8:	00000513          	li	a0,0
    800044ac:	00008067          	ret

00000000800044b0 <safe_copyin>:
    800044b0:	0e068863          	beqz	a3,800045a0 <safe_copyin+0xf0>
    800044b4:	fc010113          	add	sp,sp,-64
    800044b8:	02813823          	sd	s0,48(sp)
    800044bc:	02913423          	sd	s1,40(sp)
    800044c0:	03213023          	sd	s2,32(sp)
    800044c4:	01313c23          	sd	s3,24(sp)
    800044c8:	01513423          	sd	s5,8(sp)
    800044cc:	01613023          	sd	s6,0(sp)
    800044d0:	02113c23          	sd	ra,56(sp)
    800044d4:	01413823          	sd	s4,16(sp)
    800044d8:	00068b13          	mv	s6,a3
    800044dc:	00050493          	mv	s1,a0
    800044e0:	00058993          	mv	s3,a1
    800044e4:	00060a93          	mv	s5,a2
    800044e8:	fffff937          	lui	s2,0xfffff
    800044ec:	00001437          	lui	s0,0x1
    800044f0:	012afa33          	and	s4,s5,s2
    800044f4:	000a0593          	mv	a1,s4
    800044f8:	00048513          	mv	a0,s1
    800044fc:	da1ff0ef          	jal	8000429c <va2pa_with_replacement>
    80004500:	08050c63          	beqz	a0,80004598 <safe_copyin+0xe8>
    80004504:	415a08b3          	sub	a7,s4,s5
    80004508:	008888b3          	add	a7,a7,s0
    8000450c:	011b7463          	bgeu	s6,a7,80004514 <safe_copyin+0x64>
    80004510:	000b0893          	mv	a7,s6
    80004514:	01550533          	add	a0,a0,s5
    80004518:	41450533          	sub	a0,a0,s4
    8000451c:	06088063          	beqz	a7,8000457c <safe_copyin+0xcc>
    80004520:	00098793          	mv	a5,s3
    80004524:	01198833          	add	a6,s3,a7
    80004528:	41350733          	sub	a4,a0,s3
    8000452c:	00f70633          	add	a2,a4,a5
    80004530:	00064603          	lbu	a2,0(a2)
    80004534:	00178793          	add	a5,a5,1
    80004538:	fec78fa3          	sb	a2,-1(a5)
    8000453c:	fef818e3          	bne	a6,a5,8000452c <safe_copyin+0x7c>
    80004540:	411b0b33          	sub	s6,s6,a7
    80004544:	00080993          	mv	s3,a6
    80004548:	008a0ab3          	add	s5,s4,s0
    8000454c:	fa0b12e3          	bnez	s6,800044f0 <safe_copyin+0x40>
    80004550:	00000513          	li	a0,0
    80004554:	03813083          	ld	ra,56(sp)
    80004558:	03013403          	ld	s0,48(sp)
    8000455c:	02813483          	ld	s1,40(sp)
    80004560:	02013903          	ld	s2,32(sp)
    80004564:	01813983          	ld	s3,24(sp)
    80004568:	01013a03          	ld	s4,16(sp)
    8000456c:	00813a83          	ld	s5,8(sp)
    80004570:	00013b03          	ld	s6,0(sp)
    80004574:	04010113          	add	sp,sp,64
    80004578:	00008067          	ret
    8000457c:	00001ab7          	lui	s5,0x1
    80004580:	015a0ab3          	add	s5,s4,s5
    80004584:	012afa33          	and	s4,s5,s2
    80004588:	000a0593          	mv	a1,s4
    8000458c:	00048513          	mv	a0,s1
    80004590:	d0dff0ef          	jal	8000429c <va2pa_with_replacement>
    80004594:	f60518e3          	bnez	a0,80004504 <safe_copyin+0x54>
    80004598:	fff00513          	li	a0,-1
    8000459c:	fb9ff06f          	j	80004554 <safe_copyin+0xa4>
    800045a0:	00000513          	li	a0,0
    800045a4:	00008067          	ret

00000000800045a8 <test_page_replacement>:
    800045a8:	f4010113          	add	sp,sp,-192
    800045ac:	00007517          	auipc	a0,0x7
    800045b0:	c9450513          	add	a0,a0,-876 # 8000b240 <digits+0x68>
    800045b4:	0a113c23          	sd	ra,184(sp)
    800045b8:	0a813823          	sd	s0,176(sp)
    800045bc:	0a913423          	sd	s1,168(sp)
    800045c0:	0b213023          	sd	s2,160(sp)
    800045c4:	09313c23          	sd	s3,152(sp)
    800045c8:	e10fe0ef          	jal	80002bd8 <uart_puts>
    800045cc:	00007517          	auipc	a0,0x7
    800045d0:	c9c50513          	add	a0,a0,-868 # 8000b268 <digits+0x90>
    800045d4:	e04fe0ef          	jal	80002bd8 <uart_puts>
    800045d8:	d18ff0ef          	jal	80003af0 <alloc_swap_slot>
    800045dc:	0005049b          	sext.w	s1,a0
    800045e0:	d10ff0ef          	jal	80003af0 <alloc_swap_slot>
    800045e4:	0005041b          	sext.w	s0,a0
    800045e8:	d08ff0ef          	jal	80003af0 <alloc_swap_slot>
    800045ec:	fff00793          	li	a5,-1
    800045f0:	02f48663          	beq	s1,a5,8000461c <test_page_replacement+0x74>
    800045f4:	1cf40c63          	beq	s0,a5,800047cc <test_page_replacement+0x224>
    800045f8:	0005051b          	sext.w	a0,a0
    800045fc:	02f50063          	beq	a0,a5,8000461c <test_page_replacement+0x74>
    80004600:	00848e63          	beq	s1,s0,8000461c <test_page_replacement+0x74>
    80004604:	00a40c63          	beq	s0,a0,8000461c <test_page_replacement+0x74>
    80004608:	00a48a63          	beq	s1,a0,8000461c <test_page_replacement+0x74>
    8000460c:	00007517          	auipc	a0,0x7
    80004610:	c8450513          	add	a0,a0,-892 # 8000b290 <digits+0xb8>
    80004614:	dc4fe0ef          	jal	80002bd8 <uart_puts>
    80004618:	0100006f          	j	80004628 <test_page_replacement+0x80>
    8000461c:	00007517          	auipc	a0,0x7
    80004620:	c9450513          	add	a0,a0,-876 # 8000b2b0 <digits+0xd8>
    80004624:	db4fe0ef          	jal	80002bd8 <uart_puts>
    80004628:	0000d797          	auipc	a5,0xd
    8000462c:	bd47a783          	lw	a5,-1068(a5) # 800111fc <swap_mgr+0x84>
    80004630:	00f47663          	bgeu	s0,a5,8000463c <test_page_replacement+0x94>
    80004634:	00040513          	mv	a0,s0
    80004638:	fc4fe0ef          	jal	80002dfc <free_swap_slot.part.0>
    8000463c:	cb4ff0ef          	jal	80003af0 <alloc_swap_slot>
    80004640:	0005051b          	sext.w	a0,a0
    80004644:	14a40c63          	beq	s0,a0,8000479c <test_page_replacement+0x1f4>
    80004648:	00007517          	auipc	a0,0x7
    8000464c:	cb050513          	add	a0,a0,-848 # 8000b2f8 <digits+0x120>
    80004650:	d88fe0ef          	jal	80002bd8 <uart_puts>
    80004654:	00007517          	auipc	a0,0x7
    80004658:	ccc50513          	add	a0,a0,-820 # 8000b320 <digits+0x148>
    8000465c:	d7cfe0ef          	jal	80002bd8 <uart_puts>
    80004660:	00080737          	lui	a4,0x80
    80004664:	00170713          	add	a4,a4,1 # 80001 <_entry-0x7ff7ffff>
    80004668:	00010637          	lui	a2,0x10
    8000466c:	00c71713          	sll	a4,a4,0xc
    80004670:	fff00793          	li	a5,-1
    80004674:	01f7d793          	srl	a5,a5,0x1f
    80004678:	00c13023          	sd	a2,0(sp)
    8000467c:	02e13c23          	sd	a4,56(sp)
    80004680:	00100613          	li	a2,1
    80004684:	00012737          	lui	a4,0x12
    80004688:	01f61613          	sll	a2,a2,0x1f
    8000468c:	00f13823          	sd	a5,16(sp)
    80004690:	04f13023          	sd	a5,64(sp)
    80004694:	06e13023          	sd	a4,96(sp)
    80004698:	06f13823          	sd	a5,112(sp)
    8000469c:	40001737          	lui	a4,0x40001
    800046a0:	03010793          	add	a5,sp,48
    800046a4:	00423697          	auipc	a3,0x423
    800046a8:	6246b683          	ld	a3,1572(a3) # 80427cc8 <kernel_pagetable>
    800046ac:	00171713          	sll	a4,a4,0x1
    800046b0:	0040d417          	auipc	s0,0x40d
    800046b4:	b5840413          	add	s0,s0,-1192 # 80411208 <lru_mgr>
    800046b8:	00010493          	mv	s1,sp
    800046bc:	06010993          	add	s3,sp,96
    800046c0:	00c13423          	sd	a2,8(sp)
    800046c4:	00f13c23          	sd	a5,24(sp)
    800046c8:	00011637          	lui	a2,0x11
    800046cc:	08f13023          	sd	a5,128(sp)
    800046d0:	00410917          	auipc	s2,0x410
    800046d4:	b3890913          	add	s2,s2,-1224 # 80414208 <lru_mgr+0x3000>
    800046d8:	00300793          	li	a5,3
    800046dc:	00007517          	auipc	a0,0x7
    800046e0:	c6450513          	add	a0,a0,-924 # 8000b340 <digits+0x168>
    800046e4:	06e13423          	sd	a4,104(sp)
    800046e8:	00f92823          	sw	a5,16(s2)
    800046ec:	02013023          	sd	zero,32(sp)
    800046f0:	02d13423          	sd	a3,40(sp)
    800046f4:	02c13823          	sd	a2,48(sp)
    800046f8:	04d13c23          	sd	a3,88(sp)
    800046fc:	06013c23          	sd	zero,120(sp)
    80004700:	08d13423          	sd	a3,136(sp)
    80004704:	00943423          	sd	s1,8(s0)
    80004708:	04913823          	sd	s1,80(sp)
    8000470c:	05313423          	sd	s3,72(sp)
    80004710:	01343023          	sd	s3,0(s0)
    80004714:	cc4fe0ef          	jal	80002bd8 <uart_puts>
    80004718:	04813783          	ld	a5,72(sp)
    8000471c:	05013703          	ld	a4,80(sp)
    80004720:	08078a63          	beqz	a5,800047b4 <test_page_replacement+0x20c>
    80004724:	02e7b023          	sd	a4,32(a5)
    80004728:	08070263          	beqz	a4,800047ac <test_page_replacement+0x204>
    8000472c:	00f73c23          	sd	a5,24(a4) # 40001018 <_entry-0x3fffefe8>
    80004730:	01092783          	lw	a5,16(s2)
    80004734:	04013823          	sd	zero,80(sp)
    80004738:	04013423          	sd	zero,72(sp)
    8000473c:	fff7871b          	addw	a4,a5,-1
    80004740:	00e92823          	sw	a4,16(s2)
    80004744:	00200793          	li	a5,2
    80004748:	00f71663          	bne	a4,a5,80004754 <test_page_replacement+0x1ac>
    8000474c:	00043783          	ld	a5,0(s0)
    80004750:	09378663          	beq	a5,s3,800047dc <test_page_replacement+0x234>
    80004754:	00007517          	auipc	a0,0x7
    80004758:	c2c50513          	add	a0,a0,-980 # 8000b380 <digits+0x1a8>
    8000475c:	c7cfe0ef          	jal	80002bd8 <uart_puts>
    80004760:	00843783          	ld	a5,8(s0)
    80004764:	04978c63          	beq	a5,s1,800047bc <test_page_replacement+0x214>
    80004768:	00007517          	auipc	a0,0x7
    8000476c:	c5850513          	add	a0,a0,-936 # 8000b3c0 <digits+0x1e8>
    80004770:	c68fe0ef          	jal	80002bd8 <uart_puts>
    80004774:	00007517          	auipc	a0,0x7
    80004778:	c6c50513          	add	a0,a0,-916 # 8000b3e0 <digits+0x208>
    8000477c:	c5cfe0ef          	jal	80002bd8 <uart_puts>
    80004780:	0b813083          	ld	ra,184(sp)
    80004784:	0b013403          	ld	s0,176(sp)
    80004788:	0a813483          	ld	s1,168(sp)
    8000478c:	0a013903          	ld	s2,160(sp)
    80004790:	09813983          	ld	s3,152(sp)
    80004794:	0c010113          	add	sp,sp,192
    80004798:	00008067          	ret
    8000479c:	00007517          	auipc	a0,0x7
    800047a0:	b3450513          	add	a0,a0,-1228 # 8000b2d0 <digits+0xf8>
    800047a4:	c34fe0ef          	jal	80002bd8 <uart_puts>
    800047a8:	eadff06f          	j	80004654 <test_page_replacement+0xac>
    800047ac:	00f43423          	sd	a5,8(s0)
    800047b0:	f81ff06f          	j	80004730 <test_page_replacement+0x188>
    800047b4:	00e43023          	sd	a4,0(s0)
    800047b8:	f71ff06f          	j	80004728 <test_page_replacement+0x180>
    800047bc:	00007517          	auipc	a0,0x7
    800047c0:	be450513          	add	a0,a0,-1052 # 8000b3a0 <digits+0x1c8>
    800047c4:	c14fe0ef          	jal	80002bd8 <uart_puts>
    800047c8:	fadff06f          	j	80004774 <test_page_replacement+0x1cc>
    800047cc:	00007517          	auipc	a0,0x7
    800047d0:	ae450513          	add	a0,a0,-1308 # 8000b2b0 <digits+0xd8>
    800047d4:	c04fe0ef          	jal	80002bd8 <uart_puts>
    800047d8:	e65ff06f          	j	8000463c <test_page_replacement+0x94>
    800047dc:	00843783          	ld	a5,8(s0)
    800047e0:	f6979ae3          	bne	a5,s1,80004754 <test_page_replacement+0x1ac>
    800047e4:	00007517          	auipc	a0,0x7
    800047e8:	b7c50513          	add	a0,a0,-1156 # 8000b360 <digits+0x188>
    800047ec:	becfe0ef          	jal	80002bd8 <uart_puts>
    800047f0:	f71ff06f          	j	80004760 <test_page_replacement+0x1b8>

00000000800047f4 <walkaddr>:
    800047f4:	fff00793          	li	a5,-1
    800047f8:	0197d793          	srl	a5,a5,0x19
    800047fc:	04b7e463          	bltu	a5,a1,80004844 <walkaddr+0x50>
    80004800:	ff010113          	add	sp,sp,-16
    80004804:	00113423          	sd	ra,8(sp)
    80004808:	d80fe0ef          	jal	80002d88 <walk_lookup>
    8000480c:	04050063          	beqz	a0,8000484c <walkaddr+0x58>
    80004810:	00053783          	ld	a5,0(a0)
    80004814:	01100713          	li	a4,17
    80004818:	00000513          	li	a0,0
    8000481c:	0117f693          	and	a3,a5,17
    80004820:	00e68863          	beq	a3,a4,80004830 <walkaddr+0x3c>
    80004824:	00813083          	ld	ra,8(sp)
    80004828:	01010113          	add	sp,sp,16
    8000482c:	00008067          	ret
    80004830:	00813083          	ld	ra,8(sp)
    80004834:	00a7d793          	srl	a5,a5,0xa
    80004838:	00c79513          	sll	a0,a5,0xc
    8000483c:	01010113          	add	sp,sp,16
    80004840:	00008067          	ret
    80004844:	00000513          	li	a0,0
    80004848:	00008067          	ret
    8000484c:	00813083          	ld	ra,8(sp)
    80004850:	00000513          	li	a0,0
    80004854:	01010113          	add	sp,sp,16
    80004858:	00008067          	ret

000000008000485c <copyin>:
    8000485c:	10068863          	beqz	a3,8000496c <copyin+0x110>
    80004860:	fb010113          	add	sp,sp,-80
    80004864:	02913c23          	sd	s1,56(sp)
    80004868:	01513c23          	sd	s5,24(sp)
    8000486c:	fff00493          	li	s1,-1
    80004870:	fffffab7          	lui	s5,0xfffff
    80004874:	04813023          	sd	s0,64(sp)
    80004878:	04113423          	sd	ra,72(sp)
    8000487c:	03213823          	sd	s2,48(sp)
    80004880:	03313423          	sd	s3,40(sp)
    80004884:	03413023          	sd	s4,32(sp)
    80004888:	01613823          	sd	s6,16(sp)
    8000488c:	01713423          	sd	s7,8(sp)
    80004890:	01567ab3          	and	s5,a2,s5
    80004894:	0194d493          	srl	s1,s1,0x19
    80004898:	00060413          	mv	s0,a2
    8000489c:	0354ea63          	bltu	s1,s5,800048d0 <copyin+0x74>
    800048a0:	00068b13          	mv	s6,a3
    800048a4:	00050913          	mv	s2,a0
    800048a8:	00058b93          	mv	s7,a1
    800048ac:	01100a13          	li	s4,17
    800048b0:	000019b7          	lui	s3,0x1
    800048b4:	000a8593          	mv	a1,s5
    800048b8:	00090513          	mv	a0,s2
    800048bc:	cccfe0ef          	jal	80002d88 <walk_lookup>
    800048c0:	00050863          	beqz	a0,800048d0 <copyin+0x74>
    800048c4:	00053783          	ld	a5,0(a0)
    800048c8:	0117f713          	and	a4,a5,17
    800048cc:	03470a63          	beq	a4,s4,80004900 <copyin+0xa4>
    800048d0:	fff00513          	li	a0,-1
    800048d4:	04813083          	ld	ra,72(sp)
    800048d8:	04013403          	ld	s0,64(sp)
    800048dc:	03813483          	ld	s1,56(sp)
    800048e0:	03013903          	ld	s2,48(sp)
    800048e4:	02813983          	ld	s3,40(sp)
    800048e8:	02013a03          	ld	s4,32(sp)
    800048ec:	01813a83          	ld	s5,24(sp)
    800048f0:	01013b03          	ld	s6,16(sp)
    800048f4:	00813b83          	ld	s7,8(sp)
    800048f8:	05010113          	add	sp,sp,80
    800048fc:	00008067          	ret
    80004900:	00a7d793          	srl	a5,a5,0xa
    80004904:	00c79793          	sll	a5,a5,0xc
    80004908:	fc0784e3          	beqz	a5,800048d0 <copyin+0x74>
    8000490c:	013a85b3          	add	a1,s5,s3
    80004910:	408586b3          	sub	a3,a1,s0
    80004914:	00db7463          	bgeu	s6,a3,8000491c <copyin+0xc0>
    80004918:	000b0693          	mv	a3,s6
    8000491c:	41540733          	sub	a4,s0,s5
    80004920:	00f70733          	add	a4,a4,a5
    80004924:	01768833          	add	a6,a3,s7
    80004928:	000b8793          	mv	a5,s7
    8000492c:	41770733          	sub	a4,a4,s7
    80004930:	02068263          	beqz	a3,80004954 <copyin+0xf8>
    80004934:	00f70633          	add	a2,a4,a5
    80004938:	00064603          	lbu	a2,0(a2) # 11000 <_entry-0x7ffef000>
    8000493c:	00178793          	add	a5,a5,1
    80004940:	fec78fa3          	sb	a2,-1(a5)
    80004944:	fef818e3          	bne	a6,a5,80004934 <copyin+0xd8>
    80004948:	40db0b33          	sub	s6,s6,a3
    8000494c:	00080b93          	mv	s7,a6
    80004950:	000b0a63          	beqz	s6,80004964 <copyin+0x108>
    80004954:	f6b4eee3          	bltu	s1,a1,800048d0 <copyin+0x74>
    80004958:	00058a93          	mv	s5,a1
    8000495c:	00058413          	mv	s0,a1
    80004960:	f55ff06f          	j	800048b4 <copyin+0x58>
    80004964:	00000513          	li	a0,0
    80004968:	f6dff06f          	j	800048d4 <copyin+0x78>
    8000496c:	00000513          	li	a0,0
    80004970:	00008067          	ret

0000000080004974 <copyout>:
    80004974:	10068863          	beqz	a3,80004a84 <copyout+0x110>
    80004978:	fb010113          	add	sp,sp,-80
    8000497c:	02913c23          	sd	s1,56(sp)
    80004980:	01513c23          	sd	s5,24(sp)
    80004984:	fff00493          	li	s1,-1
    80004988:	fffffab7          	lui	s5,0xfffff
    8000498c:	04813023          	sd	s0,64(sp)
    80004990:	04113423          	sd	ra,72(sp)
    80004994:	03213823          	sd	s2,48(sp)
    80004998:	03313423          	sd	s3,40(sp)
    8000499c:	03413023          	sd	s4,32(sp)
    800049a0:	01613823          	sd	s6,16(sp)
    800049a4:	01713423          	sd	s7,8(sp)
    800049a8:	0155fab3          	and	s5,a1,s5
    800049ac:	0194d493          	srl	s1,s1,0x19
    800049b0:	00058413          	mv	s0,a1
    800049b4:	0354ea63          	bltu	s1,s5,800049e8 <copyout+0x74>
    800049b8:	00068b13          	mv	s6,a3
    800049bc:	00050913          	mv	s2,a0
    800049c0:	00060b93          	mv	s7,a2
    800049c4:	01100a13          	li	s4,17
    800049c8:	000019b7          	lui	s3,0x1
    800049cc:	000a8593          	mv	a1,s5
    800049d0:	00090513          	mv	a0,s2
    800049d4:	bb4fe0ef          	jal	80002d88 <walk_lookup>
    800049d8:	00050863          	beqz	a0,800049e8 <copyout+0x74>
    800049dc:	00053783          	ld	a5,0(a0)
    800049e0:	0117f713          	and	a4,a5,17
    800049e4:	03470a63          	beq	a4,s4,80004a18 <copyout+0xa4>
    800049e8:	fff00513          	li	a0,-1
    800049ec:	04813083          	ld	ra,72(sp)
    800049f0:	04013403          	ld	s0,64(sp)
    800049f4:	03813483          	ld	s1,56(sp)
    800049f8:	03013903          	ld	s2,48(sp)
    800049fc:	02813983          	ld	s3,40(sp)
    80004a00:	02013a03          	ld	s4,32(sp)
    80004a04:	01813a83          	ld	s5,24(sp)
    80004a08:	01013b03          	ld	s6,16(sp)
    80004a0c:	00813b83          	ld	s7,8(sp)
    80004a10:	05010113          	add	sp,sp,80
    80004a14:	00008067          	ret
    80004a18:	00a7d793          	srl	a5,a5,0xa
    80004a1c:	00c79793          	sll	a5,a5,0xc
    80004a20:	fc0784e3          	beqz	a5,800049e8 <copyout+0x74>
    80004a24:	013a8533          	add	a0,s5,s3
    80004a28:	408506b3          	sub	a3,a0,s0
    80004a2c:	00db7463          	bgeu	s6,a3,80004a34 <copyout+0xc0>
    80004a30:	000b0693          	mv	a3,s6
    80004a34:	41540733          	sub	a4,s0,s5
    80004a38:	00f70733          	add	a4,a4,a5
    80004a3c:	01768833          	add	a6,a3,s7
    80004a40:	000b8793          	mv	a5,s7
    80004a44:	41770733          	sub	a4,a4,s7
    80004a48:	02068263          	beqz	a3,80004a6c <copyout+0xf8>
    80004a4c:	0007c583          	lbu	a1,0(a5)
    80004a50:	00f70633          	add	a2,a4,a5
    80004a54:	00178793          	add	a5,a5,1
    80004a58:	00b60023          	sb	a1,0(a2)
    80004a5c:	fef818e3          	bne	a6,a5,80004a4c <copyout+0xd8>
    80004a60:	40db0b33          	sub	s6,s6,a3
    80004a64:	00080b93          	mv	s7,a6
    80004a68:	000b0a63          	beqz	s6,80004a7c <copyout+0x108>
    80004a6c:	f6a4eee3          	bltu	s1,a0,800049e8 <copyout+0x74>
    80004a70:	00050a93          	mv	s5,a0
    80004a74:	00050413          	mv	s0,a0
    80004a78:	f55ff06f          	j	800049cc <copyout+0x58>
    80004a7c:	00000513          	li	a0,0
    80004a80:	f6dff06f          	j	800049ec <copyout+0x78>
    80004a84:	00000513          	li	a0,0
    80004a88:	00008067          	ret

0000000080004a8c <uvmunmap>:
    80004a8c:	03459793          	sll	a5,a1,0x34
    80004a90:	00079463          	bnez	a5,80004a98 <uvmunmap+0xc>
    80004a94:	bbcfe06f          	j	80002e50 <uvmunmap.part.0>
    80004a98:	00008067          	ret

0000000080004a9c <uvmdealloc>:
    80004a9c:	06b67863          	bgeu	a2,a1,80004b0c <uvmdealloc+0x70>
    80004aa0:	000017b7          	lui	a5,0x1
    80004aa4:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004aa8:	ff010113          	add	sp,sp,-16
    80004aac:	fffff6b7          	lui	a3,0xfffff
    80004ab0:	00f60733          	add	a4,a2,a5
    80004ab4:	00f587b3          	add	a5,a1,a5
    80004ab8:	00813023          	sd	s0,0(sp)
    80004abc:	00113423          	sd	ra,8(sp)
    80004ac0:	00d775b3          	and	a1,a4,a3
    80004ac4:	00d7f7b3          	and	a5,a5,a3
    80004ac8:	00060413          	mv	s0,a2
    80004acc:	00f5ec63          	bltu	a1,a5,80004ae4 <uvmdealloc+0x48>
    80004ad0:	00813083          	ld	ra,8(sp)
    80004ad4:	00040513          	mv	a0,s0
    80004ad8:	00013403          	ld	s0,0(sp)
    80004adc:	01010113          	add	sp,sp,16
    80004ae0:	00008067          	ret
    80004ae4:	40b787b3          	sub	a5,a5,a1
    80004ae8:	00c7d793          	srl	a5,a5,0xc
    80004aec:	00100693          	li	a3,1
    80004af0:	0007861b          	sext.w	a2,a5
    80004af4:	b5cfe0ef          	jal	80002e50 <uvmunmap.part.0>
    80004af8:	00813083          	ld	ra,8(sp)
    80004afc:	00040513          	mv	a0,s0
    80004b00:	00013403          	ld	s0,0(sp)
    80004b04:	01010113          	add	sp,sp,16
    80004b08:	00008067          	ret
    80004b0c:	00058513          	mv	a0,a1
    80004b10:	00008067          	ret

0000000080004b14 <uvmalloc>:
    80004b14:	0eb66463          	bltu	a2,a1,80004bfc <uvmalloc+0xe8>
    80004b18:	00001737          	lui	a4,0x1
    80004b1c:	fff70713          	add	a4,a4,-1 # fff <_entry-0x7ffff001>
    80004b20:	fc010113          	add	sp,sp,-64
    80004b24:	00e587b3          	add	a5,a1,a4
    80004b28:	fffff737          	lui	a4,0xfffff
    80004b2c:	02913423          	sd	s1,40(sp)
    80004b30:	03213023          	sd	s2,32(sp)
    80004b34:	01313c23          	sd	s3,24(sp)
    80004b38:	01413823          	sd	s4,16(sp)
    80004b3c:	01513423          	sd	s5,8(sp)
    80004b40:	00e7f933          	and	s2,a5,a4
    80004b44:	02113c23          	sd	ra,56(sp)
    80004b48:	02813823          	sd	s0,48(sp)
    80004b4c:	00060a93          	mv	s5,a2
    80004b50:	00050a13          	mv	s4,a0
    80004b54:	00090493          	mv	s1,s2
    80004b58:	000019b7          	lui	s3,0x1
    80004b5c:	04c97263          	bgeu	s2,a2,80004ba0 <uvmalloc+0x8c>
    80004b60:	924fe0ef          	jal	80002c84 <alloc_page>
    80004b64:	00050413          	mv	s0,a0
    80004b68:	06050463          	beqz	a0,80004bd0 <uvmalloc+0xbc>
    80004b6c:	01350733          	add	a4,a0,s3
    80004b70:	00050793          	mv	a5,a0
    80004b74:	00078023          	sb	zero,0(a5)
    80004b78:	00178793          	add	a5,a5,1
    80004b7c:	fef71ce3          	bne	a4,a5,80004b74 <uvmalloc+0x60>
    80004b80:	01e00693          	li	a3,30
    80004b84:	00040613          	mv	a2,s0
    80004b88:	00048593          	mv	a1,s1
    80004b8c:	000a0513          	mv	a0,s4
    80004b90:	b9cfe0ef          	jal	80002f2c <map_page>
    80004b94:	02051a63          	bnez	a0,80004bc8 <uvmalloc+0xb4>
    80004b98:	013484b3          	add	s1,s1,s3
    80004b9c:	fd54e2e3          	bltu	s1,s5,80004b60 <uvmalloc+0x4c>
    80004ba0:	000a8513          	mv	a0,s5
    80004ba4:	03813083          	ld	ra,56(sp)
    80004ba8:	03013403          	ld	s0,48(sp)
    80004bac:	02813483          	ld	s1,40(sp)
    80004bb0:	02013903          	ld	s2,32(sp)
    80004bb4:	01813983          	ld	s3,24(sp)
    80004bb8:	01013a03          	ld	s4,16(sp)
    80004bbc:	00813a83          	ld	s5,8(sp)
    80004bc0:	04010113          	add	sp,sp,64
    80004bc4:	00008067          	ret
    80004bc8:	00040513          	mv	a0,s0
    80004bcc:	8d4fe0ef          	jal	80002ca0 <free_page>
    80004bd0:	02997263          	bgeu	s2,s1,80004bf4 <uvmalloc+0xe0>
    80004bd4:	000017b7          	lui	a5,0x1
    80004bd8:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004bdc:	fffff737          	lui	a4,0xfffff
    80004be0:	00f905b3          	add	a1,s2,a5
    80004be4:	00f487b3          	add	a5,s1,a5
    80004be8:	00e5f5b3          	and	a1,a1,a4
    80004bec:	00e7f7b3          	and	a5,a5,a4
    80004bf0:	00f5ea63          	bltu	a1,a5,80004c04 <uvmalloc+0xf0>
    80004bf4:	00000513          	li	a0,0
    80004bf8:	fadff06f          	j	80004ba4 <uvmalloc+0x90>
    80004bfc:	00058513          	mv	a0,a1
    80004c00:	00008067          	ret
    80004c04:	40b787b3          	sub	a5,a5,a1
    80004c08:	00c7d613          	srl	a2,a5,0xc
    80004c0c:	000a0513          	mv	a0,s4
    80004c10:	00100693          	li	a3,1
    80004c14:	0006061b          	sext.w	a2,a2
    80004c18:	a38fe0ef          	jal	80002e50 <uvmunmap.part.0>
    80004c1c:	00000513          	li	a0,0
    80004c20:	f85ff06f          	j	80004ba4 <uvmalloc+0x90>

0000000080004c24 <freewalk>:
    80004c24:	f0010113          	add	sp,sp,-256
    80004c28:	000017b7          	lui	a5,0x1
    80004c2c:	0e813823          	sd	s0,240(sp)
    80004c30:	0f213023          	sd	s2,224(sp)
    80004c34:	0d613023          	sd	s6,192(sp)
    80004c38:	0b713c23          	sd	s7,184(sp)
    80004c3c:	0e113c23          	sd	ra,248(sp)
    80004c40:	0e913423          	sd	s1,232(sp)
    80004c44:	0d313c23          	sd	s3,216(sp)
    80004c48:	0d413823          	sd	s4,208(sp)
    80004c4c:	0d513423          	sd	s5,200(sp)
    80004c50:	0b813823          	sd	s8,176(sp)
    80004c54:	0b913423          	sd	s9,168(sp)
    80004c58:	0ba13023          	sd	s10,160(sp)
    80004c5c:	09b13c23          	sd	s11,152(sp)
    80004c60:	00050413          	mv	s0,a0
    80004c64:	00050913          	mv	s2,a0
    80004c68:	00f50b33          	add	s6,a0,a5
    80004c6c:	00001bb7          	lui	s7,0x1
    80004c70:	00c0006f          	j	80004c7c <freewalk+0x58>
    80004c74:	00890913          	add	s2,s2,8
    80004c78:	2f690e63          	beq	s2,s6,80004f74 <freewalk+0x350>
    80004c7c:	00093783          	ld	a5,0(s2)
    80004c80:	00100713          	li	a4,1
    80004c84:	00f7f693          	and	a3,a5,15
    80004c88:	fee696e3          	bne	a3,a4,80004c74 <freewalk+0x50>
    80004c8c:	00a7d793          	srl	a5,a5,0xa
    80004c90:	00c79a13          	sll	s4,a5,0xc
    80004c94:	017a0cb3          	add	s9,s4,s7
    80004c98:	00100d93          	li	s11,1
    80004c9c:	000a0a93          	mv	s5,s4
    80004ca0:	00040493          	mv	s1,s0
    80004ca4:	00c0006f          	j	80004cb0 <freewalk+0x8c>
    80004ca8:	008a0a13          	add	s4,s4,8 # fffffffffffff008 <bss_end+0xffffffff7fbd7310>
    80004cac:	2b9a0863          	beq	s4,s9,80004f5c <freewalk+0x338>
    80004cb0:	000a3783          	ld	a5,0(s4)
    80004cb4:	00f7f713          	and	a4,a5,15
    80004cb8:	ffb718e3          	bne	a4,s11,80004ca8 <freewalk+0x84>
    80004cbc:	00a7d793          	srl	a5,a5,0xa
    80004cc0:	00c79993          	sll	s3,a5,0xc
    80004cc4:	00098c13          	mv	s8,s3
    80004cc8:	01798d33          	add	s10,s3,s7
    80004ccc:	00098413          	mv	s0,s3
    80004cd0:	00c0006f          	j	80004cdc <freewalk+0xb8>
    80004cd4:	00840413          	add	s0,s0,8
    80004cd8:	27a40863          	beq	s0,s10,80004f48 <freewalk+0x324>
    80004cdc:	00043783          	ld	a5,0(s0)
    80004ce0:	00f7f713          	and	a4,a5,15
    80004ce4:	ffb718e3          	bne	a4,s11,80004cd4 <freewalk+0xb0>
    80004ce8:	00a7d793          	srl	a5,a5,0xa
    80004cec:	00c79793          	sll	a5,a5,0xc
    80004cf0:	00048713          	mv	a4,s1
    80004cf4:	03513823          	sd	s5,48(sp)
    80004cf8:	00090493          	mv	s1,s2
    80004cfc:	017789b3          	add	s3,a5,s7
    80004d00:	00078a93          	mv	s5,a5
    80004d04:	00070913          	mv	s2,a4
    80004d08:	00c0006f          	j	80004d14 <freewalk+0xf0>
    80004d0c:	00878793          	add	a5,a5,8 # 1008 <_entry-0x7fffeff8>
    80004d10:	20f98a63          	beq	s3,a5,80004f24 <freewalk+0x300>
    80004d14:	0007b703          	ld	a4,0(a5)
    80004d18:	00f77693          	and	a3,a4,15
    80004d1c:	ffb698e3          	bne	a3,s11,80004d0c <freewalk+0xe8>
    80004d20:	00a75713          	srl	a4,a4,0xa
    80004d24:	00c71713          	sll	a4,a4,0xc
    80004d28:	017706b3          	add	a3,a4,s7
    80004d2c:	05313023          	sd	s3,64(sp)
    80004d30:	00d13423          	sd	a3,8(sp)
    80004d34:	02813c23          	sd	s0,56(sp)
    80004d38:	04f13423          	sd	a5,72(sp)
    80004d3c:	00070993          	mv	s3,a4
    80004d40:	0100006f          	j	80004d50 <freewalk+0x12c>
    80004d44:	00813783          	ld	a5,8(sp)
    80004d48:	00870713          	add	a4,a4,8 # fffffffffffff008 <bss_end+0xffffffff7fbd7310>
    80004d4c:	1ae78863          	beq	a5,a4,80004efc <freewalk+0x2d8>
    80004d50:	00073783          	ld	a5,0(a4)
    80004d54:	00f7f693          	and	a3,a5,15
    80004d58:	ffb696e3          	bne	a3,s11,80004d44 <freewalk+0x120>
    80004d5c:	00a7d793          	srl	a5,a5,0xa
    80004d60:	00c79793          	sll	a5,a5,0xc
    80004d64:	017786b3          	add	a3,a5,s7
    80004d68:	05813823          	sd	s8,80(sp)
    80004d6c:	00d13c23          	sd	a3,24(sp)
    80004d70:	000a8c13          	mv	s8,s5
    80004d74:	04e13c23          	sd	a4,88(sp)
    80004d78:	00078a93          	mv	s5,a5
    80004d7c:	07213023          	sd	s2,96(sp)
    80004d80:	0100006f          	j	80004d90 <freewalk+0x16c>
    80004d84:	01813703          	ld	a4,24(sp)
    80004d88:	00878793          	add	a5,a5,8
    80004d8c:	14f70063          	beq	a4,a5,80004ecc <freewalk+0x2a8>
    80004d90:	0007b703          	ld	a4,0(a5)
    80004d94:	00f77693          	and	a3,a4,15
    80004d98:	ffb696e3          	bne	a3,s11,80004d84 <freewalk+0x160>
    80004d9c:	00a75713          	srl	a4,a4,0xa
    80004da0:	00c71913          	sll	s2,a4,0xc
    80004da4:	01790733          	add	a4,s2,s7
    80004da8:	07213423          	sd	s2,104(sp)
    80004dac:	00090413          	mv	s0,s2
    80004db0:	02e13023          	sd	a4,32(sp)
    80004db4:	06f13823          	sd	a5,112(sp)
    80004db8:	00048913          	mv	s2,s1
    80004dbc:	0100006f          	j	80004dcc <freewalk+0x1a8>
    80004dc0:	02013783          	ld	a5,32(sp)
    80004dc4:	00840413          	add	s0,s0,8
    80004dc8:	0c878e63          	beq	a5,s0,80004ea4 <freewalk+0x280>
    80004dcc:	00043783          	ld	a5,0(s0)
    80004dd0:	00f7f693          	and	a3,a5,15
    80004dd4:	ffb696e3          	bne	a3,s11,80004dc0 <freewalk+0x19c>
    80004dd8:	00a7d793          	srl	a5,a5,0xa
    80004ddc:	00c79493          	sll	s1,a5,0xc
    80004de0:	017487b3          	add	a5,s1,s7
    80004de4:	00913823          	sd	s1,16(sp)
    80004de8:	02f13423          	sd	a5,40(sp)
    80004dec:	06813c23          	sd	s0,120(sp)
    80004df0:	0100006f          	j	80004e00 <freewalk+0x1dc>
    80004df4:	02813783          	ld	a5,40(sp)
    80004df8:	00848493          	add	s1,s1,8
    80004dfc:	08978663          	beq	a5,s1,80004e88 <freewalk+0x264>
    80004e00:	0004b783          	ld	a5,0(s1)
    80004e04:	00f7f693          	and	a3,a5,15
    80004e08:	ffb696e3          	bne	a3,s11,80004df4 <freewalk+0x1d0>
    80004e0c:	00a7d793          	srl	a5,a5,0xa
    80004e10:	00c79413          	sll	s0,a5,0xc
    80004e14:	017406b3          	add	a3,s0,s7
    80004e18:	09213023          	sd	s2,128(sp)
    80004e1c:	09613423          	sd	s6,136(sp)
    80004e20:	00040913          	mv	s2,s0
    80004e24:	000a0b13          	mv	s6,s4
    80004e28:	00048a13          	mv	s4,s1
    80004e2c:	00068493          	mv	s1,a3
    80004e30:	00c0006f          	j	80004e3c <freewalk+0x218>
    80004e34:	00840413          	add	s0,s0,8
    80004e38:	02848463          	beq	s1,s0,80004e60 <freewalk+0x23c>
    80004e3c:	00043783          	ld	a5,0(s0)
    80004e40:	00f7f713          	and	a4,a5,15
    80004e44:	ffb718e3          	bne	a4,s11,80004e34 <freewalk+0x210>
    80004e48:	00a7d793          	srl	a5,a5,0xa
    80004e4c:	00c79513          	sll	a0,a5,0xc
    80004e50:	dd5ff0ef          	jal	80004c24 <freewalk>
    80004e54:	00840413          	add	s0,s0,8
    80004e58:	fe043c23          	sd	zero,-8(s0)
    80004e5c:	fe8490e3          	bne	s1,s0,80004e3c <freewalk+0x218>
    80004e60:	00090513          	mv	a0,s2
    80004e64:	000a0493          	mv	s1,s4
    80004e68:	08013903          	ld	s2,128(sp)
    80004e6c:	000b0a13          	mv	s4,s6
    80004e70:	08813b03          	ld	s6,136(sp)
    80004e74:	e2dfd0ef          	jal	80002ca0 <free_page>
    80004e78:	02813783          	ld	a5,40(sp)
    80004e7c:	0004b023          	sd	zero,0(s1)
    80004e80:	00848493          	add	s1,s1,8
    80004e84:	f6979ee3          	bne	a5,s1,80004e00 <freewalk+0x1dc>
    80004e88:	01013503          	ld	a0,16(sp)
    80004e8c:	07813403          	ld	s0,120(sp)
    80004e90:	e11fd0ef          	jal	80002ca0 <free_page>
    80004e94:	02013783          	ld	a5,32(sp)
    80004e98:	00043023          	sd	zero,0(s0)
    80004e9c:	00840413          	add	s0,s0,8
    80004ea0:	f28796e3          	bne	a5,s0,80004dcc <freewalk+0x1a8>
    80004ea4:	07013783          	ld	a5,112(sp)
    80004ea8:	06813503          	ld	a0,104(sp)
    80004eac:	00090493          	mv	s1,s2
    80004eb0:	00f13823          	sd	a5,16(sp)
    80004eb4:	dedfd0ef          	jal	80002ca0 <free_page>
    80004eb8:	01013783          	ld	a5,16(sp)
    80004ebc:	01813703          	ld	a4,24(sp)
    80004ec0:	0007b023          	sd	zero,0(a5)
    80004ec4:	00878793          	add	a5,a5,8
    80004ec8:	ecf714e3          	bne	a4,a5,80004d90 <freewalk+0x16c>
    80004ecc:	05813703          	ld	a4,88(sp)
    80004ed0:	000a8513          	mv	a0,s5
    80004ed4:	06013903          	ld	s2,96(sp)
    80004ed8:	00e13823          	sd	a4,16(sp)
    80004edc:	000c0a93          	mv	s5,s8
    80004ee0:	05013c03          	ld	s8,80(sp)
    80004ee4:	dbdfd0ef          	jal	80002ca0 <free_page>
    80004ee8:	01013703          	ld	a4,16(sp)
    80004eec:	00813783          	ld	a5,8(sp)
    80004ef0:	00073023          	sd	zero,0(a4)
    80004ef4:	00870713          	add	a4,a4,8
    80004ef8:	e4e79ce3          	bne	a5,a4,80004d50 <freewalk+0x12c>
    80004efc:	04813783          	ld	a5,72(sp)
    80004f00:	00098513          	mv	a0,s3
    80004f04:	03813403          	ld	s0,56(sp)
    80004f08:	00f13423          	sd	a5,8(sp)
    80004f0c:	04013983          	ld	s3,64(sp)
    80004f10:	d91fd0ef          	jal	80002ca0 <free_page>
    80004f14:	00813783          	ld	a5,8(sp)
    80004f18:	0007b023          	sd	zero,0(a5)
    80004f1c:	00878793          	add	a5,a5,8
    80004f20:	def99ae3          	bne	s3,a5,80004d14 <freewalk+0xf0>
    80004f24:	00090793          	mv	a5,s2
    80004f28:	000a8513          	mv	a0,s5
    80004f2c:	00048913          	mv	s2,s1
    80004f30:	03013a83          	ld	s5,48(sp)
    80004f34:	00078493          	mv	s1,a5
    80004f38:	00840413          	add	s0,s0,8
    80004f3c:	d65fd0ef          	jal	80002ca0 <free_page>
    80004f40:	fe043c23          	sd	zero,-8(s0)
    80004f44:	d9a41ce3          	bne	s0,s10,80004cdc <freewalk+0xb8>
    80004f48:	000c0513          	mv	a0,s8
    80004f4c:	d55fd0ef          	jal	80002ca0 <free_page>
    80004f50:	008a0a13          	add	s4,s4,8
    80004f54:	fe0a3c23          	sd	zero,-8(s4)
    80004f58:	d59a1ce3          	bne	s4,s9,80004cb0 <freewalk+0x8c>
    80004f5c:	000a8513          	mv	a0,s5
    80004f60:	d41fd0ef          	jal	80002ca0 <free_page>
    80004f64:	00890913          	add	s2,s2,8
    80004f68:	fe093c23          	sd	zero,-8(s2)
    80004f6c:	00048413          	mv	s0,s1
    80004f70:	d16916e3          	bne	s2,s6,80004c7c <freewalk+0x58>
    80004f74:	00040513          	mv	a0,s0
    80004f78:	0f013403          	ld	s0,240(sp)
    80004f7c:	0f813083          	ld	ra,248(sp)
    80004f80:	0e813483          	ld	s1,232(sp)
    80004f84:	0e013903          	ld	s2,224(sp)
    80004f88:	0d813983          	ld	s3,216(sp)
    80004f8c:	0d013a03          	ld	s4,208(sp)
    80004f90:	0c813a83          	ld	s5,200(sp)
    80004f94:	0c013b03          	ld	s6,192(sp)
    80004f98:	0b813b83          	ld	s7,184(sp)
    80004f9c:	0b013c03          	ld	s8,176(sp)
    80004fa0:	0a813c83          	ld	s9,168(sp)
    80004fa4:	0a013d03          	ld	s10,160(sp)
    80004fa8:	09813d83          	ld	s11,152(sp)
    80004fac:	10010113          	add	sp,sp,256
    80004fb0:	cf1fd06f          	j	80002ca0 <free_page>

0000000080004fb4 <uvmfree>:
    80004fb4:	00059463          	bnez	a1,80004fbc <uvmfree+0x8>
    80004fb8:	00008067          	ret
    80004fbc:	000017b7          	lui	a5,0x1
    80004fc0:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    80004fc4:	00f585b3          	add	a1,a1,a5
    80004fc8:	00c5d613          	srl	a2,a1,0xc
    80004fcc:	00100693          	li	a3,1
    80004fd0:	00000593          	li	a1,0
    80004fd4:	e7dfd06f          	j	80002e50 <uvmunmap.part.0>

0000000080004fd8 <proc_pagetable>:
    80004fd8:	ff010113          	add	sp,sp,-16
    80004fdc:	00113423          	sd	ra,8(sp)
    80004fe0:	02050863          	beqz	a0,80005010 <proc_pagetable+0x38>
    80004fe4:	ca1fd0ef          	jal	80002c84 <alloc_page>
    80004fe8:	00001737          	lui	a4,0x1
    80004fec:	00050793          	mv	a5,a0
    80004ff0:	00e50733          	add	a4,a0,a4
    80004ff4:	02050863          	beqz	a0,80005024 <proc_pagetable+0x4c>
    80004ff8:	0007b023          	sd	zero,0(a5)
    80004ffc:	00878793          	add	a5,a5,8
    80005000:	fef71ce3          	bne	a4,a5,80004ff8 <proc_pagetable+0x20>
    80005004:	00813083          	ld	ra,8(sp)
    80005008:	01010113          	add	sp,sp,16
    8000500c:	00008067          	ret
    80005010:	00006517          	auipc	a0,0x6
    80005014:	3f850513          	add	a0,a0,1016 # 8000b408 <digits+0x230>
    80005018:	bc1fd0ef          	jal	80002bd8 <uart_puts>
    8000501c:	00000513          	li	a0,0
    80005020:	fe5ff06f          	j	80005004 <proc_pagetable+0x2c>
    80005024:	00006517          	auipc	a0,0x6
    80005028:	40450513          	add	a0,a0,1028 # 8000b428 <digits+0x250>
    8000502c:	badfd0ef          	jal	80002bd8 <uart_puts>
    80005030:	00000513          	li	a0,0
    80005034:	fd1ff06f          	j	80005004 <proc_pagetable+0x2c>

0000000080005038 <proc_freepagetable>:
    80005038:	fd010113          	add	sp,sp,-48
    8000503c:	01313423          	sd	s3,8(sp)
    80005040:	02113423          	sd	ra,40(sp)
    80005044:	02813023          	sd	s0,32(sp)
    80005048:	00913c23          	sd	s1,24(sp)
    8000504c:	01213823          	sd	s2,16(sp)
    80005050:	00050993          	mv	s3,a0
    80005054:	06059263          	bnez	a1,800050b8 <proc_freepagetable+0x80>
    80005058:	000014b7          	lui	s1,0x1
    8000505c:	00098413          	mv	s0,s3
    80005060:	009984b3          	add	s1,s3,s1
    80005064:	00100913          	li	s2,1
    80005068:	00c0006f          	j	80005074 <proc_freepagetable+0x3c>
    8000506c:	00840413          	add	s0,s0,8
    80005070:	02940463          	beq	s0,s1,80005098 <proc_freepagetable+0x60>
    80005074:	00043503          	ld	a0,0(s0)
    80005078:	00f57793          	and	a5,a0,15
    8000507c:	ff2798e3          	bne	a5,s2,8000506c <proc_freepagetable+0x34>
    80005080:	00a55513          	srl	a0,a0,0xa
    80005084:	00c51513          	sll	a0,a0,0xc
    80005088:	b9dff0ef          	jal	80004c24 <freewalk>
    8000508c:	00840413          	add	s0,s0,8
    80005090:	fe043c23          	sd	zero,-8(s0)
    80005094:	fe9410e3          	bne	s0,s1,80005074 <proc_freepagetable+0x3c>
    80005098:	02013403          	ld	s0,32(sp)
    8000509c:	02813083          	ld	ra,40(sp)
    800050a0:	01813483          	ld	s1,24(sp)
    800050a4:	01013903          	ld	s2,16(sp)
    800050a8:	00098513          	mv	a0,s3
    800050ac:	00813983          	ld	s3,8(sp)
    800050b0:	03010113          	add	sp,sp,48
    800050b4:	bedfd06f          	j	80002ca0 <free_page>
    800050b8:	000017b7          	lui	a5,0x1
    800050bc:	fff78793          	add	a5,a5,-1 # fff <_entry-0x7ffff001>
    800050c0:	00f58633          	add	a2,a1,a5
    800050c4:	00100693          	li	a3,1
    800050c8:	00c65613          	srl	a2,a2,0xc
    800050cc:	00000593          	li	a1,0
    800050d0:	d81fd0ef          	jal	80002e50 <uvmunmap.part.0>
    800050d4:	f85ff06f          	j	80005058 <proc_freepagetable+0x20>

00000000800050d8 <uvmcopy>:
    800050d8:	10060463          	beqz	a2,800051e0 <uvmcopy+0x108>
    800050dc:	fb010113          	add	sp,sp,-80
    800050e0:	02913c23          	sd	s1,56(sp)
    800050e4:	03213823          	sd	s2,48(sp)
    800050e8:	03313423          	sd	s3,40(sp)
    800050ec:	03413023          	sd	s4,32(sp)
    800050f0:	01513c23          	sd	s5,24(sp)
    800050f4:	04113423          	sd	ra,72(sp)
    800050f8:	04813023          	sd	s0,64(sp)
    800050fc:	01613823          	sd	s6,16(sp)
    80005100:	01713423          	sd	s7,8(sp)
    80005104:	00060a13          	mv	s4,a2
    80005108:	00050a93          	mv	s5,a0
    8000510c:	00058993          	mv	s3,a1
    80005110:	00000493          	li	s1,0
    80005114:	00001937          	lui	s2,0x1
    80005118:	00048593          	mv	a1,s1
    8000511c:	000a8513          	mv	a0,s5
    80005120:	c69fd0ef          	jal	80002d88 <walk_lookup>
    80005124:	06050c63          	beqz	a0,8000519c <uvmcopy+0xc4>
    80005128:	00053b83          	ld	s7,0(a0)
    8000512c:	001bf793          	and	a5,s7,1
    80005130:	06078663          	beqz	a5,8000519c <uvmcopy+0xc4>
    80005134:	00abd593          	srl	a1,s7,0xa
    80005138:	00c59413          	sll	s0,a1,0xc
    8000513c:	b49fd0ef          	jal	80002c84 <alloc_page>
    80005140:	3ffbfb93          	and	s7,s7,1023
    80005144:	00050b13          	mv	s6,a0
    80005148:	04050a63          	beqz	a0,8000519c <uvmcopy+0xc4>
    8000514c:	01250833          	add	a6,a0,s2
    80005150:	00050793          	mv	a5,a0
    80005154:	40a405b3          	sub	a1,s0,a0
    80005158:	00f58733          	add	a4,a1,a5
    8000515c:	00074703          	lbu	a4,0(a4) # 1000 <_entry-0x7ffff000>
    80005160:	00178793          	add	a5,a5,1
    80005164:	fee78fa3          	sb	a4,-1(a5)
    80005168:	ff0798e3          	bne	a5,a6,80005158 <uvmcopy+0x80>
    8000516c:	000b8693          	mv	a3,s7
    80005170:	000b0613          	mv	a2,s6
    80005174:	00048593          	mv	a1,s1
    80005178:	00098513          	mv	a0,s3
    8000517c:	db1fd0ef          	jal	80002f2c <map_page>
    80005180:	00051a63          	bnez	a0,80005194 <uvmcopy+0xbc>
    80005184:	012484b3          	add	s1,s1,s2
    80005188:	f944e8e3          	bltu	s1,s4,80005118 <uvmcopy+0x40>
    8000518c:	00000513          	li	a0,0
    80005190:	0240006f          	j	800051b4 <uvmcopy+0xdc>
    80005194:	000b0513          	mv	a0,s6
    80005198:	b09fd0ef          	jal	80002ca0 <free_page>
    8000519c:	00098513          	mv	a0,s3
    800051a0:	00100693          	li	a3,1
    800051a4:	00c4d613          	srl	a2,s1,0xc
    800051a8:	00000593          	li	a1,0
    800051ac:	ca5fd0ef          	jal	80002e50 <uvmunmap.part.0>
    800051b0:	fff00513          	li	a0,-1
    800051b4:	04813083          	ld	ra,72(sp)
    800051b8:	04013403          	ld	s0,64(sp)
    800051bc:	03813483          	ld	s1,56(sp)
    800051c0:	03013903          	ld	s2,48(sp)
    800051c4:	02813983          	ld	s3,40(sp)
    800051c8:	02013a03          	ld	s4,32(sp)
    800051cc:	01813a83          	ld	s5,24(sp)
    800051d0:	01013b03          	ld	s6,16(sp)
    800051d4:	00813b83          	ld	s7,8(sp)
    800051d8:	05010113          	add	sp,sp,80
    800051dc:	00008067          	ret
    800051e0:	00000513          	li	a0,0
    800051e4:	00008067          	ret

00000000800051e8 <handle_timer_interrupt>:
    800051e8:	ff010113          	add	sp,sp,-16
    800051ec:	00423597          	auipc	a1,0x423
    800051f0:	aec5b583          	ld	a1,-1300(a1) # 80427cd8 <ticks>
    800051f4:	00006517          	auipc	a0,0x6
    800051f8:	26c50513          	add	a0,a0,620 # 8000b460 <digits+0x288>
    800051fc:	00113423          	sd	ra,8(sp)
    80005200:	e68fd0ef          	jal	80002868 <printf>
    80005204:	00813083          	ld	ra,8(sp)
    80005208:	00100793          	li	a5,1
    8000520c:	00423717          	auipc	a4,0x423
    80005210:	aef72023          	sw	a5,-1312(a4) # 80427cec <need_resched>
    80005214:	01010113          	add	sp,sp,16
    80005218:	00008067          	ret

000000008000521c <handle_external_interrupt>:
    8000521c:	00006517          	auipc	a0,0x6
    80005220:	26c50513          	add	a0,a0,620 # 8000b488 <digits+0x2b0>
    80005224:	e44fd06f          	j	80002868 <printf>

0000000080005228 <handle_software_interrupt>:
    80005228:	00006517          	auipc	a0,0x6
    8000522c:	29050513          	add	a0,a0,656 # 8000b4b8 <digits+0x2e0>
    80005230:	e38fd06f          	j	80002868 <printf>

0000000080005234 <get_ticks>:
    80005234:	00423517          	auipc	a0,0x423
    80005238:	aa453503          	ld	a0,-1372(a0) # 80427cd8 <ticks>
    8000523c:	00008067          	ret

0000000080005240 <machine_timer_handler>:
    80005240:	00423797          	auipc	a5,0x423
    80005244:	a9078793          	add	a5,a5,-1392 # 80427cd0 <m_mode_ticks>
    80005248:	0007b703          	ld	a4,0(a5)
    8000524c:	ff010113          	add	sp,sp,-16
    80005250:	00113423          	sd	ra,8(sp)
    80005254:	00170713          	add	a4,a4,1
    80005258:	00e7b023          	sd	a4,0(a5)
    8000525c:	00423697          	auipc	a3,0x423
    80005260:	a7c68693          	add	a3,a3,-1412 # 80427cd8 <ticks>
    80005264:	0006b703          	ld	a4,0(a3)
    80005268:	00006517          	auipc	a0,0x6
    8000526c:	28050513          	add	a0,a0,640 # 8000b4e8 <digits+0x310>
    80005270:	00170713          	add	a4,a4,1
    80005274:	00e6b023          	sd	a4,0(a3)
    80005278:	0007b583          	ld	a1,0(a5)
    8000527c:	decfd0ef          	jal	80002868 <printf>
    80005280:	0200c7b7          	lui	a5,0x200c
    80005284:	ff87b783          	ld	a5,-8(a5) # 200bff8 <_entry-0x7dff4008>
    80005288:	000f4737          	lui	a4,0xf4
    8000528c:	00813083          	ld	ra,8(sp)
    80005290:	24070713          	add	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005294:	00e787b3          	add	a5,a5,a4
    80005298:	02004737          	lui	a4,0x2004
    8000529c:	00f73023          	sd	a5,0(a4) # 2004000 <_entry-0x7dffc000>
    800052a0:	01010113          	add	sp,sp,16
    800052a4:	00008067          	ret

00000000800052a8 <alloc_trapframe>:
    800052a8:	0040f597          	auipc	a1,0x40f
    800052ac:	f7858593          	add	a1,a1,-136 # 80414220 <trapframe_used>
    800052b0:	00058793          	mv	a5,a1
    800052b4:	00000713          	li	a4,0
    800052b8:	10000613          	li	a2,256
    800052bc:	00c0006f          	j	800052c8 <alloc_trapframe+0x20>
    800052c0:	0017071b          	addw	a4,a4,1
    800052c4:	02c70e63          	beq	a4,a2,80005300 <alloc_trapframe+0x58>
    800052c8:	0007a683          	lw	a3,0(a5)
    800052cc:	00478793          	add	a5,a5,4
    800052d0:	fe0698e3          	bnez	a3,800052c0 <alloc_trapframe+0x18>
    800052d4:	00271793          	sll	a5,a4,0x2
    800052d8:	00471513          	sll	a0,a4,0x4
    800052dc:	00f585b3          	add	a1,a1,a5
    800052e0:	00e50533          	add	a0,a0,a4
    800052e4:	00100793          	li	a5,1
    800052e8:	00f5a023          	sw	a5,0(a1)
    800052ec:	00451513          	sll	a0,a0,0x4
    800052f0:	0040f797          	auipc	a5,0x40f
    800052f4:	3b078793          	add	a5,a5,944 # 804146a0 <trapframe_pool>
    800052f8:	00f50533          	add	a0,a0,a5
    800052fc:	00008067          	ret
    80005300:	00000513          	li	a0,0
    80005304:	00008067          	ret

0000000080005308 <free_trapframe>:
    80005308:	0040f797          	auipc	a5,0x40f
    8000530c:	39878793          	add	a5,a5,920 # 804146a0 <trapframe_pool>
    80005310:	02f56c63          	bltu	a0,a5,80005348 <free_trapframe+0x40>
    80005314:	00420717          	auipc	a4,0x420
    80005318:	38c70713          	add	a4,a4,908 # 804256a0 <cpus>
    8000531c:	02e57663          	bgeu	a0,a4,80005348 <free_trapframe+0x40>
    80005320:	40f507b3          	sub	a5,a0,a5
    80005324:	00007717          	auipc	a4,0x7
    80005328:	ce473703          	ld	a4,-796(a4) # 8000c008 <user_test_syscalls_bin_len+0x8>
    8000532c:	4047d793          	sra	a5,a5,0x4
    80005330:	02e787b3          	mul	a5,a5,a4
    80005334:	0040f717          	auipc	a4,0x40f
    80005338:	eec70713          	add	a4,a4,-276 # 80414220 <trapframe_used>
    8000533c:	00279793          	sll	a5,a5,0x2
    80005340:	00f707b3          	add	a5,a4,a5
    80005344:	0007a023          	sw	zero,0(a5)
    80005348:	00008067          	ret

000000008000534c <intr_on>:
    8000534c:	100027f3          	csrr	a5,sstatus
    80005350:	0027e793          	or	a5,a5,2
    80005354:	10079073          	csrw	sstatus,a5
    80005358:	00008067          	ret

000000008000535c <intr_off>:
    8000535c:	100027f3          	csrr	a5,sstatus
    80005360:	ffd7f793          	and	a5,a5,-3
    80005364:	10079073          	csrw	sstatus,a5
    80005368:	00008067          	ret

000000008000536c <intr_get>:
    8000536c:	10002573          	csrr	a0,sstatus
    80005370:	00155513          	srl	a0,a0,0x1
    80005374:	00157513          	and	a0,a0,1
    80005378:	00008067          	ret

000000008000537c <set_stvec>:
    8000537c:	00a585b3          	add	a1,a1,a0
    80005380:	10559073          	csrw	stvec,a1
    80005384:	00008067          	ret

0000000080005388 <trap_init>:
    80005388:	ff010113          	add	sp,sp,-16
    8000538c:	00006517          	auipc	a0,0x6
    80005390:	18c50513          	add	a0,a0,396 # 8000b518 <digits+0x340>
    80005394:	00113423          	sd	ra,8(sp)
    80005398:	841fd0ef          	jal	80002bd8 <uart_puts>
    8000539c:	0040f617          	auipc	a2,0x40f
    800053a0:	e8460613          	add	a2,a2,-380 # 80414220 <trapframe_used>
    800053a4:	00060793          	mv	a5,a2
    800053a8:	0040f717          	auipc	a4,0x40f
    800053ac:	27870713          	add	a4,a4,632 # 80414620 <trap_handlers>
    800053b0:	0007a023          	sw	zero,0(a5)
    800053b4:	00478793          	add	a5,a5,4
    800053b8:	fee79ce3          	bne	a5,a4,800053b0 <trap_init+0x28>
    800053bc:	0040f797          	auipc	a5,0x40f
    800053c0:	26478793          	add	a5,a5,612 # 80414620 <trap_handlers>
    800053c4:	0040f697          	auipc	a3,0x40f
    800053c8:	2dc68693          	add	a3,a3,732 # 804146a0 <trapframe_pool>
    800053cc:	00078713          	mv	a4,a5
    800053d0:	00073023          	sd	zero,0(a4)
    800053d4:	00870713          	add	a4,a4,8
    800053d8:	fee69ce3          	bne	a3,a4,800053d0 <trap_init+0x48>
    800053dc:	00000717          	auipc	a4,0x0
    800053e0:	e0c70713          	add	a4,a4,-500 # 800051e8 <handle_timer_interrupt>
    800053e4:	42e63423          	sd	a4,1064(a2)
    800053e8:	00000717          	auipc	a4,0x0
    800053ec:	e3470713          	add	a4,a4,-460 # 8000521c <handle_external_interrupt>
    800053f0:	44e63423          	sd	a4,1096(a2)
    800053f4:	00000717          	auipc	a4,0x0
    800053f8:	e3470713          	add	a4,a4,-460 # 80005228 <handle_software_interrupt>
    800053fc:	40e63423          	sd	a4,1032(a2)
    80005400:	00000593          	li	a1,0
    80005404:	0007b703          	ld	a4,0(a5)
    80005408:	00878793          	add	a5,a5,8
    8000540c:	00070463          	beqz	a4,80005414 <trap_init+0x8c>
    80005410:	0015859b          	addw	a1,a1,1
    80005414:	fef698e3          	bne	a3,a5,80005404 <trap_init+0x7c>
    80005418:	00006517          	auipc	a0,0x6
    8000541c:	12850513          	add	a0,a0,296 # 8000b540 <digits+0x368>
    80005420:	c48fd0ef          	jal	80002868 <printf>
    80005424:	00813083          	ld	ra,8(sp)
    80005428:	00006517          	auipc	a0,0x6
    8000542c:	14850513          	add	a0,a0,328 # 8000b570 <digits+0x398>
    80005430:	01010113          	add	sp,sp,16
    80005434:	fa4fd06f          	j	80002bd8 <uart_puts>

0000000080005438 <trap_init_hart>:
    80005438:	ff010113          	add	sp,sp,-16
    8000543c:	00006517          	auipc	a0,0x6
    80005440:	15450513          	add	a0,a0,340 # 8000b590 <digits+0x3b8>
    80005444:	00113423          	sd	ra,8(sp)
    80005448:	f90fd0ef          	jal	80002bd8 <uart_puts>
    8000544c:	00001797          	auipc	a5,0x1
    80005450:	7b478793          	add	a5,a5,1972 # 80006c00 <kernelvec>
    80005454:	10579073          	csrw	stvec,a5
    80005458:	104027f3          	csrr	a5,sie
    8000545c:	2227e793          	or	a5,a5,546
    80005460:	10479073          	csrw	sie,a5
    80005464:	100027f3          	csrr	a5,sstatus
    80005468:	0027e793          	or	a5,a5,2
    8000546c:	10079073          	csrw	sstatus,a5
    80005470:	00813083          	ld	ra,8(sp)
    80005474:	00006517          	auipc	a0,0x6
    80005478:	14450513          	add	a0,a0,324 # 8000b5b8 <digits+0x3e0>
    8000547c:	01010113          	add	sp,sp,16
    80005480:	f58fd06f          	j	80002bd8 <uart_puts>

0000000080005484 <set_next_timer>:
    80005484:	0200c7b7          	lui	a5,0x200c
    80005488:	ff87b583          	ld	a1,-8(a5) # 200bff8 <_entry-0x7dff4008>
    8000548c:	000f4637          	lui	a2,0xf4
    80005490:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005494:	00c58633          	add	a2,a1,a2
    80005498:	020047b7          	lui	a5,0x2004
    8000549c:	00c7b023          	sd	a2,0(a5) # 2004000 <_entry-0x7dffc000>
    800054a0:	00006517          	auipc	a0,0x6
    800054a4:	14050513          	add	a0,a0,320 # 8000b5e0 <digits+0x408>
    800054a8:	bc0fd06f          	j	80002868 <printf>

00000000800054ac <timerinit>:
    800054ac:	ff010113          	add	sp,sp,-16
    800054b0:	00006517          	auipc	a0,0x6
    800054b4:	16050513          	add	a0,a0,352 # 8000b610 <digits+0x438>
    800054b8:	00113423          	sd	ra,8(sp)
    800054bc:	f1cfd0ef          	jal	80002bd8 <uart_puts>
    800054c0:	0200c7b7          	lui	a5,0x200c
    800054c4:	ff87b583          	ld	a1,-8(a5) # 200bff8 <_entry-0x7dff4008>
    800054c8:	000f4637          	lui	a2,0xf4
    800054cc:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800054d0:	00c58633          	add	a2,a1,a2
    800054d4:	020047b7          	lui	a5,0x2004
    800054d8:	00c7b023          	sd	a2,0(a5) # 2004000 <_entry-0x7dffc000>
    800054dc:	00006517          	auipc	a0,0x6
    800054e0:	10450513          	add	a0,a0,260 # 8000b5e0 <digits+0x408>
    800054e4:	b84fd0ef          	jal	80002868 <printf>
    800054e8:	00813083          	ld	ra,8(sp)
    800054ec:	00006517          	auipc	a0,0x6
    800054f0:	14450513          	add	a0,a0,324 # 8000b630 <digits+0x458>
    800054f4:	01010113          	add	sp,sp,16
    800054f8:	ee0fd06f          	j	80002bd8 <uart_puts>

00000000800054fc <devintr>:
    800054fc:	142025f3          	csrr	a1,scause
    80005500:	1005da63          	bgez	a1,80005614 <devintr+0x118>
    80005504:	ff010113          	add	sp,sp,-16
    80005508:	00113423          	sd	ra,8(sp)
    8000550c:	00813023          	sd	s0,0(sp)
    80005510:	00f5f593          	and	a1,a1,15
    80005514:	00500793          	li	a5,5
    80005518:	08f58663          	beq	a1,a5,800055a4 <devintr+0xa8>
    8000551c:	00900793          	li	a5,9
    80005520:	06f58263          	beq	a1,a5,80005584 <devintr+0x88>
    80005524:	00100793          	li	a5,1
    80005528:	02f58263          	beq	a1,a5,8000554c <devintr+0x50>
    8000552c:	00006517          	auipc	a0,0x6
    80005530:	18c50513          	add	a0,a0,396 # 8000b6b8 <digits+0x4e0>
    80005534:	b34fd0ef          	jal	80002868 <printf>
    80005538:	00813083          	ld	ra,8(sp)
    8000553c:	00013403          	ld	s0,0(sp)
    80005540:	00000513          	li	a0,0
    80005544:	01010113          	add	sp,sp,16
    80005548:	00008067          	ret
    8000554c:	00006517          	auipc	a0,0x6
    80005550:	14c50513          	add	a0,a0,332 # 8000b698 <digits+0x4c0>
    80005554:	e84fd0ef          	jal	80002bd8 <uart_puts>
    80005558:	144027f3          	csrr	a5,sip
    8000555c:	ffd7f793          	and	a5,a5,-3
    80005560:	14479073          	csrw	sip,a5
    80005564:	00006517          	auipc	a0,0x6
    80005568:	f5450513          	add	a0,a0,-172 # 8000b4b8 <digits+0x2e0>
    8000556c:	afcfd0ef          	jal	80002868 <printf>
    80005570:	00100513          	li	a0,1
    80005574:	00813083          	ld	ra,8(sp)
    80005578:	00013403          	ld	s0,0(sp)
    8000557c:	01010113          	add	sp,sp,16
    80005580:	00008067          	ret
    80005584:	00006517          	auipc	a0,0x6
    80005588:	0f450513          	add	a0,a0,244 # 8000b678 <digits+0x4a0>
    8000558c:	e4cfd0ef          	jal	80002bd8 <uart_puts>
    80005590:	00006517          	auipc	a0,0x6
    80005594:	ef850513          	add	a0,a0,-264 # 8000b488 <digits+0x2b0>
    80005598:	ad0fd0ef          	jal	80002868 <printf>
    8000559c:	00100513          	li	a0,1
    800055a0:	fd5ff06f          	j	80005574 <devintr+0x78>
    800055a4:	00422417          	auipc	s0,0x422
    800055a8:	73440413          	add	s0,s0,1844 # 80427cd8 <ticks>
    800055ac:	00043783          	ld	a5,0(s0)
    800055b0:	000f4637          	lui	a2,0xf4
    800055b4:	24060613          	add	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800055b8:	00178793          	add	a5,a5,1
    800055bc:	00f43023          	sd	a5,0(s0)
    800055c0:	0200c7b7          	lui	a5,0x200c
    800055c4:	ff87b583          	ld	a1,-8(a5) # 200bff8 <_entry-0x7dff4008>
    800055c8:	020047b7          	lui	a5,0x2004
    800055cc:	00006517          	auipc	a0,0x6
    800055d0:	01450513          	add	a0,a0,20 # 8000b5e0 <digits+0x408>
    800055d4:	00c58633          	add	a2,a1,a2
    800055d8:	00c7b023          	sd	a2,0(a5) # 2004000 <_entry-0x7dffc000>
    800055dc:	a8cfd0ef          	jal	80002868 <printf>
    800055e0:	00043583          	ld	a1,0(s0)
    800055e4:	00006517          	auipc	a0,0x6
    800055e8:	06c50513          	add	a0,a0,108 # 8000b650 <digits+0x478>
    800055ec:	a7cfd0ef          	jal	80002868 <printf>
    800055f0:	00043583          	ld	a1,0(s0)
    800055f4:	00006517          	auipc	a0,0x6
    800055f8:	e6c50513          	add	a0,a0,-404 # 8000b460 <digits+0x288>
    800055fc:	a6cfd0ef          	jal	80002868 <printf>
    80005600:	00100793          	li	a5,1
    80005604:	00422717          	auipc	a4,0x422
    80005608:	6ef72423          	sw	a5,1768(a4) # 80427cec <need_resched>
    8000560c:	00100513          	li	a0,1
    80005610:	f65ff06f          	j	80005574 <devintr+0x78>
    80005614:	00000513          	li	a0,0
    80005618:	00008067          	ret

000000008000561c <usertrap>:
    8000561c:	142025f3          	csrr	a1,scause
    80005620:	0405c463          	bltz	a1,80005668 <usertrap+0x4c>
    80005624:	00d00793          	li	a5,13
    80005628:	02b7e063          	bltu	a5,a1,80005648 <usertrap+0x2c>
    8000562c:	00b00793          	li	a5,11
    80005630:	02b7e663          	bltu	a5,a1,8000565c <usertrap+0x40>
    80005634:	00800793          	li	a5,8
    80005638:	00f59c63          	bne	a1,a5,80005650 <usertrap+0x34>
    8000563c:	00006517          	auipc	a0,0x6
    80005640:	0c450513          	add	a0,a0,196 # 8000b700 <digits+0x528>
    80005644:	d94fd06f          	j	80002bd8 <uart_puts>
    80005648:	00f00793          	li	a5,15
    8000564c:	00f58863          	beq	a1,a5,8000565c <usertrap+0x40>
    80005650:	00006517          	auipc	a0,0x6
    80005654:	0e850513          	add	a0,a0,232 # 8000b738 <digits+0x560>
    80005658:	a10fd06f          	j	80002868 <printf>
    8000565c:	00006517          	auipc	a0,0x6
    80005660:	0bc50513          	add	a0,a0,188 # 8000b718 <digits+0x540>
    80005664:	d74fd06f          	j	80002bd8 <uart_puts>
    80005668:	ff010113          	add	sp,sp,-16
    8000566c:	00113423          	sd	ra,8(sp)
    80005670:	e8dff0ef          	jal	800054fc <devintr>
    80005674:	00050863          	beqz	a0,80005684 <usertrap+0x68>
    80005678:	00813083          	ld	ra,8(sp)
    8000567c:	01010113          	add	sp,sp,16
    80005680:	00008067          	ret
    80005684:	00813083          	ld	ra,8(sp)
    80005688:	00006517          	auipc	a0,0x6
    8000568c:	05050513          	add	a0,a0,80 # 8000b6d8 <digits+0x500>
    80005690:	01010113          	add	sp,sp,16
    80005694:	9d4fd06f          	j	80002868 <printf>

0000000080005698 <handle_syscall>:
    80005698:	06050a63          	beqz	a0,8000570c <handle_syscall+0x74>
    8000569c:	ff010113          	add	sp,sp,-16
    800056a0:	00813023          	sd	s0,0(sp)
    800056a4:	08853403          	ld	s0,136(a0)
    800056a8:	00006517          	auipc	a0,0x6
    800056ac:	0f050513          	add	a0,a0,240 # 8000b798 <digits+0x5c0>
    800056b0:	00113423          	sd	ra,8(sp)
    800056b4:	00040593          	mv	a1,s0
    800056b8:	9b0fd0ef          	jal	80002868 <printf>
    800056bc:	00200793          	li	a5,2
    800056c0:	06f40a63          	beq	s0,a5,80005734 <handle_syscall+0x9c>
    800056c4:	0287e463          	bltu	a5,s0,800056ec <handle_syscall+0x54>
    800056c8:	00006517          	auipc	a0,0x6
    800056cc:	11850513          	add	a0,a0,280 # 8000b7e0 <digits+0x608>
    800056d0:	02041663          	bnez	s0,800056fc <handle_syscall+0x64>
    800056d4:	00013403          	ld	s0,0(sp)
    800056d8:	00813083          	ld	ra,8(sp)
    800056dc:	00006517          	auipc	a0,0x6
    800056e0:	0e450513          	add	a0,a0,228 # 8000b7c0 <digits+0x5e8>
    800056e4:	01010113          	add	sp,sp,16
    800056e8:	980fd06f          	j	80002868 <printf>
    800056ec:	00300793          	li	a5,3
    800056f0:	00006517          	auipc	a0,0x6
    800056f4:	13050513          	add	a0,a0,304 # 8000b820 <digits+0x648>
    800056f8:	02f41063          	bne	s0,a5,80005718 <handle_syscall+0x80>
    800056fc:	00013403          	ld	s0,0(sp)
    80005700:	00813083          	ld	ra,8(sp)
    80005704:	01010113          	add	sp,sp,16
    80005708:	960fd06f          	j	80002868 <printf>
    8000570c:	00006517          	auipc	a0,0x6
    80005710:	05c50513          	add	a0,a0,92 # 8000b768 <digits+0x590>
    80005714:	cc4fd06f          	j	80002bd8 <uart_puts>
    80005718:	00040593          	mv	a1,s0
    8000571c:	00013403          	ld	s0,0(sp)
    80005720:	00813083          	ld	ra,8(sp)
    80005724:	00006517          	auipc	a0,0x6
    80005728:	11c50513          	add	a0,a0,284 # 8000b840 <digits+0x668>
    8000572c:	01010113          	add	sp,sp,16
    80005730:	938fd06f          	j	80002868 <printf>
    80005734:	00013403          	ld	s0,0(sp)
    80005738:	00813083          	ld	ra,8(sp)
    8000573c:	00006517          	auipc	a0,0x6
    80005740:	0c450513          	add	a0,a0,196 # 8000b800 <digits+0x628>
    80005744:	01010113          	add	sp,sp,16
    80005748:	920fd06f          	j	80002868 <printf>

000000008000574c <handle_exception>:
    8000574c:	14202773          	csrr	a4,scause
    80005750:	141025f3          	csrr	a1,sepc
    80005754:	00f00793          	li	a5,15
    80005758:	16e7e263          	bltu	a5,a4,800058bc <handle_exception+0x170>
    8000575c:	00006697          	auipc	a3,0x6
    80005760:	3b068693          	add	a3,a3,944 # 8000bb0c <digits+0x934>
    80005764:	00271793          	sll	a5,a4,0x2
    80005768:	00d787b3          	add	a5,a5,a3
    8000576c:	0007a783          	lw	a5,0(a5)
    80005770:	ff010113          	add	sp,sp,-16
    80005774:	00813023          	sd	s0,0(sp)
    80005778:	00d787b3          	add	a5,a5,a3
    8000577c:	00113423          	sd	ra,8(sp)
    80005780:	00050413          	mv	s0,a0
    80005784:	00078067          	jr	a5
    80005788:	00013403          	ld	s0,0(sp)
    8000578c:	00813083          	ld	ra,8(sp)
    80005790:	00058613          	mv	a2,a1
    80005794:	00070593          	mv	a1,a4
    80005798:	00006517          	auipc	a0,0x6
    8000579c:	32050513          	add	a0,a0,800 # 8000bab8 <digits+0x8e0>
    800057a0:	01010113          	add	sp,sp,16
    800057a4:	8c4fd06f          	j	80002868 <printf>
    800057a8:	00006517          	auipc	a0,0x6
    800057ac:	1a850513          	add	a0,a0,424 # 8000b950 <digits+0x778>
    800057b0:	8b8fd0ef          	jal	80002868 <printf>
    800057b4:	10040e63          	beqz	s0,800058d0 <handle_exception+0x184>
    800057b8:	10043583          	ld	a1,256(s0)
    800057bc:	00006517          	auipc	a0,0x6
    800057c0:	1f450513          	add	a0,a0,500 # 8000b9b0 <digits+0x7d8>
    800057c4:	00013403          	ld	s0,0(sp)
    800057c8:	00813083          	ld	ra,8(sp)
    800057cc:	01010113          	add	sp,sp,16
    800057d0:	898fd06f          	j	80002868 <printf>
    800057d4:	00006517          	auipc	a0,0x6
    800057d8:	20c50513          	add	a0,a0,524 # 8000b9e0 <digits+0x808>
    800057dc:	88cfd0ef          	jal	80002868 <printf>
    800057e0:	00006517          	auipc	a0,0x6
    800057e4:	22050513          	add	a0,a0,544 # 8000ba00 <digits+0x828>
    800057e8:	08040c63          	beqz	s0,80005880 <handle_exception+0x134>
    800057ec:	10043583          	ld	a1,256(s0)
    800057f0:	00006517          	auipc	a0,0x6
    800057f4:	24050513          	add	a0,a0,576 # 8000ba30 <digits+0x858>
    800057f8:	fcdff06f          	j	800057c4 <handle_exception+0x78>
    800057fc:	00013403          	ld	s0,0(sp)
    80005800:	00813083          	ld	ra,8(sp)
    80005804:	00006517          	auipc	a0,0x6
    80005808:	25450513          	add	a0,a0,596 # 8000ba58 <digits+0x880>
    8000580c:	01010113          	add	sp,sp,16
    80005810:	858fd06f          	j	80002868 <printf>
    80005814:	00013403          	ld	s0,0(sp)
    80005818:	00813083          	ld	ra,8(sp)
    8000581c:	00006517          	auipc	a0,0x6
    80005820:	26c50513          	add	a0,a0,620 # 8000ba88 <digits+0x8b0>
    80005824:	01010113          	add	sp,sp,16
    80005828:	840fd06f          	j	80002868 <printf>
    8000582c:	00013403          	ld	s0,0(sp)
    80005830:	00813083          	ld	ra,8(sp)
    80005834:	01010113          	add	sp,sp,16
    80005838:	e61ff06f          	j	80005698 <handle_syscall>
    8000583c:	00006517          	auipc	a0,0x6
    80005840:	02450513          	add	a0,a0,36 # 8000b860 <digits+0x688>
    80005844:	824fd0ef          	jal	80002868 <printf>
    80005848:	02040863          	beqz	s0,80005878 <handle_exception+0x12c>
    8000584c:	143025f3          	csrr	a1,stval
    80005850:	00013403          	ld	s0,0(sp)
    80005854:	00813083          	ld	ra,8(sp)
    80005858:	00006517          	auipc	a0,0x6
    8000585c:	06850513          	add	a0,a0,104 # 8000b8c0 <digits+0x6e8>
    80005860:	01010113          	add	sp,sp,16
    80005864:	804fd06f          	j	80002868 <printf>
    80005868:	00006517          	auipc	a0,0x6
    8000586c:	08850513          	add	a0,a0,136 # 8000b8f0 <digits+0x718>
    80005870:	ff9fc0ef          	jal	80002868 <printf>
    80005874:	fc041ce3          	bnez	s0,8000584c <handle_exception+0x100>
    80005878:	00006517          	auipc	a0,0x6
    8000587c:	01050513          	add	a0,a0,16 # 8000b888 <digits+0x6b0>
    80005880:	00013403          	ld	s0,0(sp)
    80005884:	00813083          	ld	ra,8(sp)
    80005888:	01010113          	add	sp,sp,16
    8000588c:	b4cfd06f          	j	80002bd8 <uart_puts>
    80005890:	00006517          	auipc	a0,0x6
    80005894:	07850513          	add	a0,a0,120 # 8000b908 <digits+0x730>
    80005898:	fd1fc0ef          	jal	80002868 <printf>
    8000589c:	fc040ee3          	beqz	s0,80005878 <handle_exception+0x12c>
    800058a0:	143025f3          	csrr	a1,stval
    800058a4:	00013403          	ld	s0,0(sp)
    800058a8:	00813083          	ld	ra,8(sp)
    800058ac:	00006517          	auipc	a0,0x6
    800058b0:	07c50513          	add	a0,a0,124 # 8000b928 <digits+0x750>
    800058b4:	01010113          	add	sp,sp,16
    800058b8:	fb1fc06f          	j	80002868 <printf>
    800058bc:	00058613          	mv	a2,a1
    800058c0:	00006517          	auipc	a0,0x6
    800058c4:	1f850513          	add	a0,a0,504 # 8000bab8 <digits+0x8e0>
    800058c8:	00070593          	mv	a1,a4
    800058cc:	f9dfc06f          	j	80002868 <printf>
    800058d0:	00006517          	auipc	a0,0x6
    800058d4:	0a850513          	add	a0,a0,168 # 8000b978 <digits+0x7a0>
    800058d8:	fa9ff06f          	j	80005880 <handle_exception+0x134>

00000000800058dc <kerneltrap>:
    800058dc:	ff010113          	add	sp,sp,-16
    800058e0:	00113423          	sd	ra,8(sp)
    800058e4:	00813023          	sd	s0,0(sp)
    800058e8:	14202473          	csrr	s0,scause
    800058ec:	14102573          	csrr	a0,sepc
    800058f0:	00044a63          	bltz	s0,80005904 <kerneltrap+0x28>
    800058f4:	00013403          	ld	s0,0(sp)
    800058f8:	00813083          	ld	ra,8(sp)
    800058fc:	01010113          	add	sp,sp,16
    80005900:	e4dff06f          	j	8000574c <handle_exception>
    80005904:	bf9ff0ef          	jal	800054fc <devintr>
    80005908:	00050a63          	beqz	a0,8000591c <kerneltrap+0x40>
    8000590c:	00813083          	ld	ra,8(sp)
    80005910:	00013403          	ld	s0,0(sp)
    80005914:	01010113          	add	sp,sp,16
    80005918:	00008067          	ret
    8000591c:	00f47593          	and	a1,s0,15
    80005920:	00013403          	ld	s0,0(sp)
    80005924:	00813083          	ld	ra,8(sp)
    80005928:	00006517          	auipc	a0,0x6
    8000592c:	1b850513          	add	a0,a0,440 # 8000bae0 <digits+0x908>
    80005930:	01010113          	add	sp,sp,16
    80005934:	f35fc06f          	j	80002868 <printf>

0000000080005938 <handle_trap_page_fault>:
    80005938:	00058793          	mv	a5,a1
    8000593c:	02050263          	beqz	a0,80005960 <handle_trap_page_fault+0x28>
    80005940:	143025f3          	csrr	a1,stval
    80005944:	00078863          	beqz	a5,80005954 <handle_trap_page_fault+0x1c>
    80005948:	00006517          	auipc	a0,0x6
    8000594c:	fe050513          	add	a0,a0,-32 # 8000b928 <digits+0x750>
    80005950:	f19fc06f          	j	80002868 <printf>
    80005954:	00006517          	auipc	a0,0x6
    80005958:	f6c50513          	add	a0,a0,-148 # 8000b8c0 <digits+0x6e8>
    8000595c:	f0dfc06f          	j	80002868 <printf>
    80005960:	00006517          	auipc	a0,0x6
    80005964:	f2850513          	add	a0,a0,-216 # 8000b888 <digits+0x6b0>
    80005968:	a70fd06f          	j	80002bd8 <uart_puts>

000000008000596c <handle_illegal_instruction>:
    8000596c:	00050a63          	beqz	a0,80005980 <handle_illegal_instruction+0x14>
    80005970:	10053583          	ld	a1,256(a0)
    80005974:	00006517          	auipc	a0,0x6
    80005978:	03c50513          	add	a0,a0,60 # 8000b9b0 <digits+0x7d8>
    8000597c:	eedfc06f          	j	80002868 <printf>
    80005980:	00006517          	auipc	a0,0x6
    80005984:	ff850513          	add	a0,a0,-8 # 8000b978 <digits+0x7a0>
    80005988:	a50fd06f          	j	80002bd8 <uart_puts>

000000008000598c <handle_breakpoint>:
    8000598c:	00050a63          	beqz	a0,800059a0 <handle_breakpoint+0x14>
    80005990:	10053583          	ld	a1,256(a0)
    80005994:	00006517          	auipc	a0,0x6
    80005998:	09c50513          	add	a0,a0,156 # 8000ba30 <digits+0x858>
    8000599c:	ecdfc06f          	j	80002868 <printf>
    800059a0:	00006517          	auipc	a0,0x6
    800059a4:	06050513          	add	a0,a0,96 # 8000ba00 <digits+0x828>
    800059a8:	a30fd06f          	j	80002bd8 <uart_puts>

00000000800059ac <proc_init>:
    800059ac:	ff010113          	add	sp,sp,-16
    800059b0:	00006517          	auipc	a0,0x6
    800059b4:	1a050513          	add	a0,a0,416 # 8000bb50 <digits+0x978>
    800059b8:	00113423          	sd	ra,8(sp)
    800059bc:	a1cfd0ef          	jal	80002bd8 <uart_puts>
    800059c0:	00420797          	auipc	a5,0x420
    800059c4:	d6078793          	add	a5,a5,-672 # 80425720 <proc>
    800059c8:	00421697          	auipc	a3,0x421
    800059cc:	9d868693          	add	a3,a3,-1576 # 804263a0 <fds>
    800059d0:	00078713          	mv	a4,a5
    800059d4:	00073023          	sd	zero,0(a4)
    800059d8:	00870713          	add	a4,a4,8
    800059dc:	fed71ce3          	bne	a4,a3,800059d4 <proc_init+0x28>
    800059e0:	00100713          	li	a4,1
    800059e4:	00007617          	auipc	a2,0x7
    800059e8:	6ae62623          	sw	a4,1708(a2) # 8000d090 <nextpid>
    800059ec:	00422717          	auipc	a4,0x422
    800059f0:	30073223          	sd	zero,772(a4) # 80427cf0 <current_proc>
    800059f4:	0007a023          	sw	zero,0(a5)
    800059f8:	0007a223          	sw	zero,4(a5)
    800059fc:	0007a423          	sw	zero,8(a5)
    80005a00:	0007a623          	sw	zero,12(a5)
    80005a04:	0c878793          	add	a5,a5,200
    80005a08:	fed796e3          	bne	a5,a3,800059f4 <proc_init+0x48>
    80005a0c:	00813083          	ld	ra,8(sp)
    80005a10:	00006517          	auipc	a0,0x6
    80005a14:	16850513          	add	a0,a0,360 # 8000bb78 <digits+0x9a0>
    80005a18:	01010113          	add	sp,sp,16
    80005a1c:	9bcfd06f          	j	80002bd8 <uart_puts>

0000000080005a20 <alloc_proc>:
    80005a20:	fd010113          	add	sp,sp,-48
    80005a24:	02113423          	sd	ra,40(sp)
    80005a28:	02813023          	sd	s0,32(sp)
    80005a2c:	00913c23          	sd	s1,24(sp)
    80005a30:	01213823          	sd	s2,16(sp)
    80005a34:	01313423          	sd	s3,8(sp)
    80005a38:	00422717          	auipc	a4,0x422
    80005a3c:	2b070713          	add	a4,a4,688 # 80427ce8 <proc_lock>
    80005a40:	00100693          	li	a3,1
    80005a44:	00068793          	mv	a5,a3
    80005a48:	0cf727af          	amoswap.w.aq	a5,a5,(a4)
    80005a4c:	0007879b          	sext.w	a5,a5
    80005a50:	fe079ae3          	bnez	a5,80005a44 <alloc_proc+0x24>
    80005a54:	00420997          	auipc	s3,0x420
    80005a58:	ccc98993          	add	s3,s3,-820 # 80425720 <proc>
    80005a5c:	00098793          	mv	a5,s3
    80005a60:	00000413          	li	s0,0
    80005a64:	01000613          	li	a2,16
    80005a68:	0007a683          	lw	a3,0(a5)
    80005a6c:	0c878793          	add	a5,a5,200
    80005a70:	02068463          	beqz	a3,80005a98 <alloc_proc+0x78>
    80005a74:	0014041b          	addw	s0,s0,1
    80005a78:	fec418e3          	bne	s0,a2,80005a68 <alloc_proc+0x48>
    80005a7c:	0f50000f          	fence	iorw,ow
    80005a80:	0807202f          	amoswap.w	zero,zero,(a4)
    80005a84:	00006517          	auipc	a0,0x6
    80005a88:	11c50513          	add	a0,a0,284 # 8000bba0 <digits+0x9c8>
    80005a8c:	94cfd0ef          	jal	80002bd8 <uart_puts>
    80005a90:	00000913          	li	s2,0
    80005a94:	0cc0006f          	j	80005b60 <alloc_proc+0x140>
    80005a98:	0c800493          	li	s1,200
    80005a9c:	029404b3          	mul	s1,s0,s1
    80005aa0:	00007697          	auipc	a3,0x7
    80005aa4:	5f068693          	add	a3,a3,1520 # 8000d090 <nextpid>
    80005aa8:	0006a783          	lw	a5,0(a3)
    80005aac:	0017861b          	addw	a2,a5,1
    80005ab0:	00c6a023          	sw	a2,0(a3)
    80005ab4:	00100693          	li	a3,1
    80005ab8:	00998933          	add	s2,s3,s1
    80005abc:	00d92023          	sw	a3,0(s2) # 1000 <_entry-0x7ffff000>
    80005ac0:	00f92223          	sw	a5,4(s2)
    80005ac4:	00093423          	sd	zero,8(s2)
    80005ac8:	00093823          	sd	zero,16(s2)
    80005acc:	0a093823          	sd	zero,176(s2)
    80005ad0:	0a093c23          	sd	zero,184(s2)
    80005ad4:	02093023          	sd	zero,32(s2)
    80005ad8:	0f50000f          	fence	iorw,ow
    80005adc:	0807202f          	amoswap.w	zero,zero,(a4)
    80005ae0:	fc8ff0ef          	jal	800052a8 <alloc_trapframe>
    80005ae4:	02a93823          	sd	a0,48(s2)
    80005ae8:	08050c63          	beqz	a0,80005b80 <alloc_proc+0x160>
    80005aec:	998fd0ef          	jal	80002c84 <alloc_page>
    80005af0:	000017b7          	lui	a5,0x1
    80005af4:	02a93423          	sd	a0,40(s2)
    80005af8:	00f507b3          	add	a5,a0,a5
    80005afc:	0c050263          	beqz	a0,80005bc0 <alloc_proc+0x1a0>
    80005b00:	00050023          	sb	zero,0(a0)
    80005b04:	00150513          	add	a0,a0,1
    80005b08:	fef51ce3          	bne	a0,a5,80005b00 <alloc_proc+0xe0>
    80005b0c:	04048793          	add	a5,s1,64 # 1040 <_entry-0x7fffefc0>
    80005b10:	00f987b3          	add	a5,s3,a5
    80005b14:	07078713          	add	a4,a5,112 # 1070 <_entry-0x7fffef90>
    80005b18:	0007b023          	sd	zero,0(a5)
    80005b1c:	00878793          	add	a5,a5,8
    80005b20:	fee79ce3          	bne	a5,a4,80005b18 <alloc_proc+0xf8>
    80005b24:	0c800793          	li	a5,200
    80005b28:	02f40433          	mul	s0,s0,a5
    80005b2c:	00001737          	lui	a4,0x1
    80005b30:	00090513          	mv	a0,s2
    80005b34:	008989b3          	add	s3,s3,s0
    80005b38:	0289b783          	ld	a5,40(s3)
    80005b3c:	00e787b3          	add	a5,a5,a4
    80005b40:	04f9b423          	sd	a5,72(s3)
    80005b44:	c94ff0ef          	jal	80004fd8 <proc_pagetable>
    80005b48:	00a9bc23          	sd	a0,24(s3)
    80005b4c:	04050663          	beqz	a0,80005b98 <alloc_proc+0x178>
    80005b50:	0049a583          	lw	a1,4(s3)
    80005b54:	00006517          	auipc	a0,0x6
    80005b58:	0e450513          	add	a0,a0,228 # 8000bc38 <digits+0xa60>
    80005b5c:	d0dfc0ef          	jal	80002868 <printf>
    80005b60:	02813083          	ld	ra,40(sp)
    80005b64:	02013403          	ld	s0,32(sp)
    80005b68:	01813483          	ld	s1,24(sp)
    80005b6c:	00813983          	ld	s3,8(sp)
    80005b70:	00090513          	mv	a0,s2
    80005b74:	01013903          	ld	s2,16(sp)
    80005b78:	03010113          	add	sp,sp,48
    80005b7c:	00008067          	ret
    80005b80:	00006517          	auipc	a0,0x6
    80005b84:	04050513          	add	a0,a0,64 # 8000bbc0 <digits+0x9e8>
    80005b88:	850fd0ef          	jal	80002bd8 <uart_puts>
    80005b8c:	00092023          	sw	zero,0(s2)
    80005b90:	00000913          	li	s2,0
    80005b94:	fcdff06f          	j	80005b60 <alloc_proc+0x140>
    80005b98:	00006517          	auipc	a0,0x6
    80005b9c:	07850513          	add	a0,a0,120 # 8000bc10 <digits+0xa38>
    80005ba0:	838fd0ef          	jal	80002bd8 <uart_puts>
    80005ba4:	0289b503          	ld	a0,40(s3)
    80005ba8:	00000913          	li	s2,0
    80005bac:	8f4fd0ef          	jal	80002ca0 <free_page>
    80005bb0:	0309b503          	ld	a0,48(s3)
    80005bb4:	f54ff0ef          	jal	80005308 <free_trapframe>
    80005bb8:	0009a023          	sw	zero,0(s3)
    80005bbc:	fa5ff06f          	j	80005b60 <alloc_proc+0x140>
    80005bc0:	00006517          	auipc	a0,0x6
    80005bc4:	02850513          	add	a0,a0,40 # 8000bbe8 <digits+0xa10>
    80005bc8:	810fd0ef          	jal	80002bd8 <uart_puts>
    80005bcc:	03093503          	ld	a0,48(s2)
    80005bd0:	f38ff0ef          	jal	80005308 <free_trapframe>
    80005bd4:	00092023          	sw	zero,0(s2)
    80005bd8:	00000913          	li	s2,0
    80005bdc:	f85ff06f          	j	80005b60 <alloc_proc+0x140>

0000000080005be0 <free_proc>:
    80005be0:	06050863          	beqz	a0,80005c50 <free_proc+0x70>
    80005be4:	ff010113          	add	sp,sp,-16
    80005be8:	00813023          	sd	s0,0(sp)
    80005bec:	00050413          	mv	s0,a0
    80005bf0:	03053503          	ld	a0,48(a0)
    80005bf4:	00113423          	sd	ra,8(sp)
    80005bf8:	00050663          	beqz	a0,80005c04 <free_proc+0x24>
    80005bfc:	f0cff0ef          	jal	80005308 <free_trapframe>
    80005c00:	02043823          	sd	zero,48(s0)
    80005c04:	02843503          	ld	a0,40(s0)
    80005c08:	00050663          	beqz	a0,80005c14 <free_proc+0x34>
    80005c0c:	894fd0ef          	jal	80002ca0 <free_page>
    80005c10:	02043423          	sd	zero,40(s0)
    80005c14:	01843503          	ld	a0,24(s0)
    80005c18:	00050863          	beqz	a0,80005c28 <free_proc+0x48>
    80005c1c:	02043583          	ld	a1,32(s0)
    80005c20:	c18ff0ef          	jal	80005038 <proc_freepagetable>
    80005c24:	00043c23          	sd	zero,24(s0)
    80005c28:	00043023          	sd	zero,0(s0)
    80005c2c:	00813083          	ld	ra,8(sp)
    80005c30:	02043023          	sd	zero,32(s0)
    80005c34:	0a043823          	sd	zero,176(s0)
    80005c38:	0a043c23          	sd	zero,184(s0)
    80005c3c:	00043823          	sd	zero,16(s0)
    80005c40:	00042423          	sw	zero,8(s0)
    80005c44:	00013403          	ld	s0,0(sp)
    80005c48:	01010113          	add	sp,sp,16
    80005c4c:	00008067          	ret
    80005c50:	00008067          	ret

0000000080005c54 <find_proc>:
    80005c54:	00420597          	auipc	a1,0x420
    80005c58:	acc58593          	add	a1,a1,-1332 # 80425720 <proc>
    80005c5c:	00058793          	mv	a5,a1
    80005c60:	00000713          	li	a4,0
    80005c64:	01000613          	li	a2,16
    80005c68:	0100006f          	j	80005c78 <find_proc+0x24>
    80005c6c:	0017071b          	addw	a4,a4,1 # 1001 <_entry-0x7fffefff>
    80005c70:	0c878793          	add	a5,a5,200
    80005c74:	02c70263          	beq	a4,a2,80005c98 <find_proc+0x44>
    80005c78:	0047a683          	lw	a3,4(a5)
    80005c7c:	fea698e3          	bne	a3,a0,80005c6c <find_proc+0x18>
    80005c80:	0007a683          	lw	a3,0(a5)
    80005c84:	fe0684e3          	beqz	a3,80005c6c <find_proc+0x18>
    80005c88:	0c800793          	li	a5,200
    80005c8c:	02f70733          	mul	a4,a4,a5
    80005c90:	00e58533          	add	a0,a1,a4
    80005c94:	00008067          	ret
    80005c98:	00000513          	li	a0,0
    80005c9c:	00008067          	ret

0000000080005ca0 <proc_set_kernel_stack>:
    80005ca0:	00050a63          	beqz	a0,80005cb4 <proc_set_kernel_stack+0x14>
    80005ca4:	000017b7          	lui	a5,0x1
    80005ca8:	00f587b3          	add	a5,a1,a5
    80005cac:	02b53423          	sd	a1,40(a0)
    80005cb0:	04f53423          	sd	a5,72(a0)
    80005cb4:	00008067          	ret

0000000080005cb8 <proc_mark_runnable>:
    80005cb8:	02050263          	beqz	a0,80005cdc <proc_mark_runnable+0x24>
    80005cbc:	00052783          	lw	a5,0(a0)
    80005cc0:	00100713          	li	a4,1
    80005cc4:	ffe7869b          	addw	a3,a5,-2 # ffe <_entry-0x7ffff002>
    80005cc8:	00d77a63          	bgeu	a4,a3,80005cdc <proc_mark_runnable+0x24>
    80005ccc:	00500713          	li	a4,5
    80005cd0:	00e78663          	beq	a5,a4,80005cdc <proc_mark_runnable+0x24>
    80005cd4:	00200793          	li	a5,2
    80005cd8:	00f52023          	sw	a5,0(a0)
    80005cdc:	00008067          	ret

0000000080005ce0 <proc_mark_sleeping>:
    80005ce0:	00050863          	beqz	a0,80005cf0 <proc_mark_sleeping+0x10>
    80005ce4:	00052703          	lw	a4,0(a0)
    80005ce8:	00300793          	li	a5,3
    80005cec:	00f70463          	beq	a4,a5,80005cf4 <proc_mark_sleeping+0x14>
    80005cf0:	00008067          	ret
    80005cf4:	00400793          	li	a5,4
    80005cf8:	00f52023          	sw	a5,0(a0)
    80005cfc:	0ab53c23          	sd	a1,184(a0)
    80005d00:	00008067          	ret

0000000080005d04 <proc_mark_zombie>:
    80005d04:	00050c63          	beqz	a0,80005d1c <proc_mark_zombie+0x18>
    80005d08:	00052703          	lw	a4,0(a0)
    80005d0c:	00500793          	li	a5,5
    80005d10:	00f70663          	beq	a4,a5,80005d1c <proc_mark_zombie+0x18>
    80005d14:	00f52023          	sw	a5,0(a0)
    80005d18:	00b52823          	sw	a1,16(a0)
    80005d1c:	00008067          	ret

0000000080005d20 <get_pid>:
    80005d20:	00422797          	auipc	a5,0x422
    80005d24:	fd07b783          	ld	a5,-48(a5) # 80427cf0 <current_proc>
    80005d28:	00078663          	beqz	a5,80005d34 <get_pid+0x14>
    80005d2c:	0047a503          	lw	a0,4(a5)
    80005d30:	00008067          	ret
    80005d34:	fff00513          	li	a0,-1
    80005d38:	00008067          	ret

0000000080005d3c <get_current_proc>:
    80005d3c:	00422517          	auipc	a0,0x422
    80005d40:	fb453503          	ld	a0,-76(a0) # 80427cf0 <current_proc>
    80005d44:	00008067          	ret

0000000080005d48 <set_current_proc>:
    80005d48:	00422797          	auipc	a5,0x422
    80005d4c:	faa7b423          	sd	a0,-88(a5) # 80427cf0 <current_proc>
    80005d50:	00008067          	ret

0000000080005d54 <get_uid>:
    80005d54:	00422797          	auipc	a5,0x422
    80005d58:	f9c7b783          	ld	a5,-100(a5) # 80427cf0 <current_proc>
    80005d5c:	00000513          	li	a0,0
    80005d60:	00078463          	beqz	a5,80005d68 <get_uid+0x14>
    80005d64:	00c7a503          	lw	a0,12(a5)
    80005d68:	00008067          	ret

0000000080005d6c <set_uid>:
    80005d6c:	ff010113          	add	sp,sp,-16
    80005d70:	00113423          	sd	ra,8(sp)
    80005d74:	00813023          	sd	s0,0(sp)
    80005d78:	00422797          	auipc	a5,0x422
    80005d7c:	f787b783          	ld	a5,-136(a5) # 80427cf0 <current_proc>
    80005d80:	04078863          	beqz	a5,80005dd0 <set_uid+0x64>
    80005d84:	00c7a403          	lw	s0,12(a5)
    80005d88:	04041863          	bnez	s0,80005dd8 <set_uid+0x6c>
    80005d8c:	00700713          	li	a4,7
    80005d90:	00050593          	mv	a1,a0
    80005d94:	02a76663          	bltu	a4,a0,80005dc0 <set_uid+0x54>
    80005d98:	0047a603          	lw	a2,4(a5)
    80005d9c:	00a7a623          	sw	a0,12(a5)
    80005da0:	00006517          	auipc	a0,0x6
    80005da4:	f2050513          	add	a0,a0,-224 # 8000bcc0 <digits+0xae8>
    80005da8:	ac1fc0ef          	jal	80002868 <printf>
    80005dac:	00813083          	ld	ra,8(sp)
    80005db0:	00040513          	mv	a0,s0
    80005db4:	00013403          	ld	s0,0(sp)
    80005db8:	01010113          	add	sp,sp,16
    80005dbc:	00008067          	ret
    80005dc0:	00700613          	li	a2,7
    80005dc4:	00006517          	auipc	a0,0x6
    80005dc8:	ed450513          	add	a0,a0,-300 # 8000bc98 <digits+0xac0>
    80005dcc:	a9dfc0ef          	jal	80002868 <printf>
    80005dd0:	fff00413          	li	s0,-1
    80005dd4:	fd9ff06f          	j	80005dac <set_uid+0x40>
    80005dd8:	00006517          	auipc	a0,0x6
    80005ddc:	e8850513          	add	a0,a0,-376 # 8000bc60 <digits+0xa88>
    80005de0:	a89fc0ef          	jal	80002868 <printf>
    80005de4:	fff00413          	li	s0,-1
    80005de8:	fc5ff06f          	j	80005dac <set_uid+0x40>

0000000080005dec <count_user_procs>:
    80005dec:	00050593          	mv	a1,a0
    80005df0:	00422697          	auipc	a3,0x422
    80005df4:	ef868693          	add	a3,a3,-264 # 80427ce8 <proc_lock>
    80005df8:	00100713          	li	a4,1
    80005dfc:	00070793          	mv	a5,a4
    80005e00:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
    80005e04:	0007879b          	sext.w	a5,a5
    80005e08:	fe079ae3          	bnez	a5,80005dfc <count_user_procs+0x10>
    80005e0c:	00420797          	auipc	a5,0x420
    80005e10:	91478793          	add	a5,a5,-1772 # 80425720 <proc>
    80005e14:	00420617          	auipc	a2,0x420
    80005e18:	58c60613          	add	a2,a2,1420 # 804263a0 <fds>
    80005e1c:	00000513          	li	a0,0
    80005e20:	0007a703          	lw	a4,0(a5)
    80005e24:	00070863          	beqz	a4,80005e34 <count_user_procs+0x48>
    80005e28:	00c7a703          	lw	a4,12(a5)
    80005e2c:	00b71463          	bne	a4,a1,80005e34 <count_user_procs+0x48>
    80005e30:	0015051b          	addw	a0,a0,1
    80005e34:	0c878793          	add	a5,a5,200
    80005e38:	fef614e3          	bne	a2,a5,80005e20 <count_user_procs+0x34>
    80005e3c:	0f50000f          	fence	iorw,ow
    80005e40:	0806a02f          	amoswap.w	zero,zero,(a3)
    80005e44:	00008067          	ret

0000000080005e48 <can_fork>:
    80005e48:	00050593          	mv	a1,a0
    80005e4c:	00422697          	auipc	a3,0x422
    80005e50:	e9c68693          	add	a3,a3,-356 # 80427ce8 <proc_lock>
    80005e54:	00100713          	li	a4,1
    80005e58:	00070793          	mv	a5,a4
    80005e5c:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
    80005e60:	0007879b          	sext.w	a5,a5
    80005e64:	fe079ae3          	bnez	a5,80005e58 <can_fork+0x10>
    80005e68:	00420797          	auipc	a5,0x420
    80005e6c:	8b878793          	add	a5,a5,-1864 # 80425720 <proc>
    80005e70:	00420817          	auipc	a6,0x420
    80005e74:	53080813          	add	a6,a6,1328 # 804263a0 <fds>
    80005e78:	00000613          	li	a2,0
    80005e7c:	0007a703          	lw	a4,0(a5)
    80005e80:	00070863          	beqz	a4,80005e90 <can_fork+0x48>
    80005e84:	00c7a703          	lw	a4,12(a5)
    80005e88:	00b71463          	bne	a4,a1,80005e90 <can_fork+0x48>
    80005e8c:	0016061b          	addw	a2,a2,1
    80005e90:	0c878793          	add	a5,a5,200
    80005e94:	ff0794e3          	bne	a5,a6,80005e7c <can_fork+0x34>
    80005e98:	0f50000f          	fence	iorw,ow
    80005e9c:	0806a02f          	amoswap.w	zero,zero,(a3)
    80005ea0:	00300793          	li	a5,3
    80005ea4:	00100513          	li	a0,1
    80005ea8:	00c7c463          	blt	a5,a2,80005eb0 <can_fork+0x68>
    80005eac:	00008067          	ret
    80005eb0:	ff010113          	add	sp,sp,-16
    80005eb4:	00400693          	li	a3,4
    80005eb8:	00006517          	auipc	a0,0x6
    80005ebc:	e3850513          	add	a0,a0,-456 # 8000bcf0 <digits+0xb18>
    80005ec0:	00113423          	sd	ra,8(sp)
    80005ec4:	9a5fc0ef          	jal	80002868 <printf>
    80005ec8:	00813083          	ld	ra,8(sp)
    80005ecc:	00000513          	li	a0,0
    80005ed0:	01010113          	add	sp,sp,16
    80005ed4:	00008067          	ret

0000000080005ed8 <setup_user_stack>:
    80005ed8:	08050c63          	beqz	a0,80005f70 <setup_user_stack+0x98>
    80005edc:	01853783          	ld	a5,24(a0)
    80005ee0:	fe010113          	add	sp,sp,-32
    80005ee4:	00813823          	sd	s0,16(sp)
    80005ee8:	00113c23          	sd	ra,24(sp)
    80005eec:	00913423          	sd	s1,8(sp)
    80005ef0:	00050413          	mv	s0,a0
    80005ef4:	06078a63          	beqz	a5,80005f68 <setup_user_stack+0x90>
    80005ef8:	d8dfc0ef          	jal	80002c84 <alloc_page>
    80005efc:	00050493          	mv	s1,a0
    80005f00:	06050463          	beqz	a0,80005f68 <setup_user_stack+0x90>
    80005f04:	00001737          	lui	a4,0x1
    80005f08:	00e50733          	add	a4,a0,a4
    80005f0c:	00050793          	mv	a5,a0
    80005f10:	00078023          	sb	zero,0(a5)
    80005f14:	00178793          	add	a5,a5,1
    80005f18:	fee79ce3          	bne	a5,a4,80005f10 <setup_user_stack+0x38>
    80005f1c:	040005b7          	lui	a1,0x4000
    80005f20:	01843503          	ld	a0,24(s0)
    80005f24:	ffd58593          	add	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80005f28:	01600693          	li	a3,22
    80005f2c:	00048613          	mv	a2,s1
    80005f30:	00c59593          	sll	a1,a1,0xc
    80005f34:	ff9fc0ef          	jal	80002f2c <map_page>
    80005f38:	02051463          	bnez	a0,80005f60 <setup_user_stack+0x88>
    80005f3c:	020007b7          	lui	a5,0x2000
    80005f40:	fff78793          	add	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80005f44:	00d79793          	sll	a5,a5,0xd
    80005f48:	02f43c23          	sd	a5,56(s0)
    80005f4c:	01813083          	ld	ra,24(sp)
    80005f50:	01013403          	ld	s0,16(sp)
    80005f54:	00813483          	ld	s1,8(sp)
    80005f58:	02010113          	add	sp,sp,32
    80005f5c:	00008067          	ret
    80005f60:	00048513          	mv	a0,s1
    80005f64:	d3dfc0ef          	jal	80002ca0 <free_page>
    80005f68:	fff00513          	li	a0,-1
    80005f6c:	fe1ff06f          	j	80005f4c <setup_user_stack+0x74>
    80005f70:	fff00513          	li	a0,-1
    80005f74:	00008067          	ret

0000000080005f78 <load_user_program>:
    80005f78:	0e050063          	beqz	a0,80006058 <load_user_program+0xe0>
    80005f7c:	fd010113          	add	sp,sp,-48
    80005f80:	01213823          	sd	s2,16(sp)
    80005f84:	02113423          	sd	ra,40(sp)
    80005f88:	02813023          	sd	s0,32(sp)
    80005f8c:	00913c23          	sd	s1,24(sp)
    80005f90:	01313423          	sd	s3,8(sp)
    80005f94:	01413023          	sd	s4,0(sp)
    80005f98:	00058913          	mv	s2,a1
    80005f9c:	0a058a63          	beqz	a1,80006050 <load_user_program+0xd8>
    80005fa0:	00060493          	mv	s1,a2
    80005fa4:	0a060663          	beqz	a2,80006050 <load_user_program+0xd8>
    80005fa8:	02053a03          	ld	s4,32(a0)
    80005fac:	00050413          	mv	s0,a0
    80005fb0:	01853503          	ld	a0,24(a0)
    80005fb4:	01460633          	add	a2,a2,s4
    80005fb8:	000a0593          	mv	a1,s4
    80005fbc:	b59fe0ef          	jal	80004b14 <uvmalloc>
    80005fc0:	00050993          	mv	s3,a0
    80005fc4:	08050663          	beqz	a0,80006050 <load_user_program+0xd8>
    80005fc8:	01843503          	ld	a0,24(s0)
    80005fcc:	03343023          	sd	s3,32(s0)
    80005fd0:	00048693          	mv	a3,s1
    80005fd4:	00090613          	mv	a2,s2
    80005fd8:	00000593          	li	a1,0
    80005fdc:	999fe0ef          	jal	80004974 <copyout>
    80005fe0:	04054e63          	bltz	a0,8000603c <load_user_program+0xc4>
    80005fe4:	00040513          	mv	a0,s0
    80005fe8:	ef1ff0ef          	jal	80005ed8 <setup_user_stack>
    80005fec:	04054863          	bltz	a0,8000603c <load_user_program+0xc4>
    80005ff0:	03043783          	ld	a5,48(s0)
    80005ff4:	11078713          	add	a4,a5,272
    80005ff8:	02078063          	beqz	a5,80006018 <load_user_program+0xa0>
    80005ffc:	00078023          	sb	zero,0(a5)
    80006000:	00178793          	add	a5,a5,1
    80006004:	fee79ce3          	bne	a5,a4,80005ffc <load_user_program+0x84>
    80006008:	03043783          	ld	a5,48(s0)
    8000600c:	03843703          	ld	a4,56(s0)
    80006010:	1007b023          	sd	zero,256(a5)
    80006014:	00e7b823          	sd	a4,16(a5)
    80006018:	00000513          	li	a0,0
    8000601c:	02813083          	ld	ra,40(sp)
    80006020:	02013403          	ld	s0,32(sp)
    80006024:	01813483          	ld	s1,24(sp)
    80006028:	01013903          	ld	s2,16(sp)
    8000602c:	00813983          	ld	s3,8(sp)
    80006030:	00013a03          	ld	s4,0(sp)
    80006034:	03010113          	add	sp,sp,48
    80006038:	00008067          	ret
    8000603c:	01843503          	ld	a0,24(s0)
    80006040:	000a0613          	mv	a2,s4
    80006044:	00098593          	mv	a1,s3
    80006048:	a55fe0ef          	jal	80004a9c <uvmdealloc>
    8000604c:	03443023          	sd	s4,32(s0)
    80006050:	fff00513          	li	a0,-1
    80006054:	fc9ff06f          	j	8000601c <load_user_program+0xa4>
    80006058:	fff00513          	li	a0,-1
    8000605c:	00008067          	ret

0000000080006060 <scheduler>:
    80006060:	f9010113          	add	sp,sp,-112
    80006064:	06813023          	sd	s0,96(sp)
    80006068:	00422417          	auipc	s0,0x422
    8000606c:	c7c40413          	add	s0,s0,-900 # 80427ce4 <scheduler_initialized>
    80006070:	00042783          	lw	a5,0(s0)
    80006074:	06113423          	sd	ra,104(sp)
    80006078:	04913c23          	sd	s1,88(sp)
    8000607c:	05213823          	sd	s2,80(sp)
    80006080:	05313423          	sd	s3,72(sp)
    80006084:	05413023          	sd	s4,64(sp)
    80006088:	03513c23          	sd	s5,56(sp)
    8000608c:	03613823          	sd	s6,48(sp)
    80006090:	03713423          	sd	s7,40(sp)
    80006094:	03813023          	sd	s8,32(sp)
    80006098:	01913c23          	sd	s9,24(sp)
    8000609c:	01a13823          	sd	s10,16(sp)
    800060a0:	01b13423          	sd	s11,8(sp)
    800060a4:	10078063          	beqz	a5,800061a4 <scheduler+0x144>
    800060a8:	00422497          	auipc	s1,0x422
    800060ac:	c3848493          	add	s1,s1,-968 # 80427ce0 <last_index.0>
    800060b0:	0041fc97          	auipc	s9,0x41f
    800060b4:	670c8c93          	add	s9,s9,1648 # 80425720 <proc>
    800060b8:	0041fa97          	auipc	s5,0x41f
    800060bc:	5e8a8a93          	add	s5,s5,1512 # 804256a0 <cpus>
    800060c0:	00422a17          	auipc	s4,0x422
    800060c4:	c30a0a13          	add	s4,s4,-976 # 80427cf0 <current_proc>
    800060c8:	0c800d93          	li	s11,200
    800060cc:	00200d13          	li	s10,2
    800060d0:	00300993          	li	s3,3
    800060d4:	00006917          	auipc	s2,0x6
    800060d8:	c7490913          	add	s2,s2,-908 # 8000bd48 <digits+0xb70>
    800060dc:	0041fb17          	auipc	s6,0x41f
    800060e0:	5d4b0b13          	add	s6,s6,1492 # 804256b0 <scheduler_context>
    800060e4:	a68ff0ef          	jal	8000534c <intr_on>
    800060e8:	0004a783          	lw	a5,0(s1)
    800060ec:	0107869b          	addw	a3,a5,16
    800060f0:	0080006f          	j	800060f8 <scheduler+0x98>
    800060f4:	fef688e3          	beq	a3,a5,800060e4 <scheduler+0x84>
    800060f8:	41f7d71b          	sraw	a4,a5,0x1f
    800060fc:	01c7571b          	srlw	a4,a4,0x1c
    80006100:	00f7043b          	addw	s0,a4,a5
    80006104:	00f47413          	and	s0,s0,15
    80006108:	40e40bbb          	subw	s7,s0,a4
    8000610c:	000b8413          	mv	s0,s7
    80006110:	03bb8bb3          	mul	s7,s7,s11
    80006114:	0017879b          	addw	a5,a5,1
    80006118:	017c8c33          	add	s8,s9,s7
    8000611c:	000c2703          	lw	a4,0(s8)
    80006120:	fda71ae3          	bne	a4,s10,800060f4 <scheduler+0x94>
    80006124:	004c2583          	lw	a1,4(s8)
    80006128:	00090513          	mv	a0,s2
    8000612c:	013c2023          	sw	s3,0(s8)
    80006130:	018ab023          	sd	s8,0(s5)
    80006134:	018a3023          	sd	s8,0(s4)
    80006138:	00422797          	auipc	a5,0x422
    8000613c:	ba07aa23          	sw	zero,-1100(a5) # 80427cec <need_resched>
    80006140:	f28fc0ef          	jal	80002868 <printf>
    80006144:	030c3503          	ld	a0,48(s8)
    80006148:	04050263          	beqz	a0,8000618c <scheduler+0x12c>
    8000614c:	018c3583          	ld	a1,24(s8)
    80006150:	02058e63          	beqz	a1,8000618c <scheduler+0x12c>
    80006154:	00d010ef          	jal	80007960 <trapret>
    80006158:	9f4ff0ef          	jal	8000534c <intr_on>
    8000615c:	0014041b          	addw	s0,s0,1
    80006160:	41f4571b          	sraw	a4,s0,0x1f
    80006164:	01c7571b          	srlw	a4,a4,0x1c
    80006168:	00e4043b          	addw	s0,s0,a4
    8000616c:	00f47793          	and	a5,s0,15
    80006170:	40e787bb          	subw	a5,a5,a4
    80006174:	00f4a023          	sw	a5,0(s1)
    80006178:	0041f717          	auipc	a4,0x41f
    8000617c:	52073423          	sd	zero,1320(a4) # 804256a0 <cpus>
    80006180:	00422717          	auipc	a4,0x422
    80006184:	b6073823          	sd	zero,-1168(a4) # 80427cf0 <current_proc>
    80006188:	f5dff06f          	j	800060e4 <scheduler+0x84>
    8000618c:	9d0ff0ef          	jal	8000535c <intr_off>
    80006190:	040b8593          	add	a1,s7,64 # 1040 <_entry-0x7fffefc0>
    80006194:	00bc85b3          	add	a1,s9,a1
    80006198:	000b0513          	mv	a0,s6
    8000619c:	4c5000ef          	jal	80006e60 <switch_context>
    800061a0:	fb9ff06f          	j	80006158 <scheduler+0xf8>
    800061a4:	00006517          	auipc	a0,0x6
    800061a8:	b8450513          	add	a0,a0,-1148 # 8000bd28 <digits+0xb50>
    800061ac:	a2dfc0ef          	jal	80002bd8 <uart_puts>
    800061b0:	00100793          	li	a5,1
    800061b4:	00f42023          	sw	a5,0(s0)
    800061b8:	ef1ff06f          	j	800060a8 <scheduler+0x48>

00000000800061bc <yield>:
    800061bc:	fe010113          	add	sp,sp,-32
    800061c0:	00813823          	sd	s0,16(sp)
    800061c4:	00113c23          	sd	ra,24(sp)
    800061c8:	00913423          	sd	s1,8(sp)
    800061cc:	00422417          	auipc	s0,0x422
    800061d0:	b2443403          	ld	s0,-1244(s0) # 80427cf0 <current_proc>
    800061d4:	06040263          	beqz	s0,80006238 <yield+0x7c>
    800061d8:	994ff0ef          	jal	8000536c <intr_get>
    800061dc:	00050493          	mv	s1,a0
    800061e0:	97cff0ef          	jal	8000535c <intr_off>
    800061e4:	00422717          	auipc	a4,0x422
    800061e8:	b0470713          	add	a4,a4,-1276 # 80427ce8 <proc_lock>
    800061ec:	00100693          	li	a3,1
    800061f0:	00068793          	mv	a5,a3
    800061f4:	0cf727af          	amoswap.w.aq	a5,a5,(a4)
    800061f8:	0007879b          	sext.w	a5,a5
    800061fc:	fe079ae3          	bnez	a5,800061f0 <yield+0x34>
    80006200:	00042683          	lw	a3,0(s0)
    80006204:	00300793          	li	a5,3
    80006208:	04f68263          	beq	a3,a5,8000624c <yield+0x90>
    8000620c:	0f50000f          	fence	iorw,ow
    80006210:	0807202f          	amoswap.w	zero,zero,(a4)
    80006214:	00442583          	lw	a1,4(s0)
    80006218:	00006517          	auipc	a0,0x6
    8000621c:	b6050513          	add	a0,a0,-1184 # 8000bd78 <digits+0xba0>
    80006220:	e48fc0ef          	jal	80002868 <printf>
    80006224:	0041f597          	auipc	a1,0x41f
    80006228:	48c58593          	add	a1,a1,1164 # 804256b0 <scheduler_context>
    8000622c:	04040513          	add	a0,s0,64
    80006230:	431000ef          	jal	80006e60 <switch_context>
    80006234:	02049263          	bnez	s1,80006258 <yield+0x9c>
    80006238:	01813083          	ld	ra,24(sp)
    8000623c:	01013403          	ld	s0,16(sp)
    80006240:	00813483          	ld	s1,8(sp)
    80006244:	02010113          	add	sp,sp,32
    80006248:	00008067          	ret
    8000624c:	00200793          	li	a5,2
    80006250:	00f42023          	sw	a5,0(s0)
    80006254:	fb9ff06f          	j	8000620c <yield+0x50>
    80006258:	01013403          	ld	s0,16(sp)
    8000625c:	01813083          	ld	ra,24(sp)
    80006260:	00813483          	ld	s1,8(sp)
    80006264:	02010113          	add	sp,sp,32
    80006268:	8e4ff06f          	j	8000534c <intr_on>

000000008000626c <fork>:
    8000626c:	fe010113          	add	sp,sp,-32
    80006270:	01213023          	sd	s2,0(sp)
    80006274:	00113c23          	sd	ra,24(sp)
    80006278:	00813823          	sd	s0,16(sp)
    8000627c:	00913423          	sd	s1,8(sp)
    80006280:	00422917          	auipc	s2,0x422
    80006284:	a7093903          	ld	s2,-1424(s2) # 80427cf0 <current_proc>
    80006288:	18090663          	beqz	s2,80006414 <fork+0x1a8>
    8000628c:	00c92583          	lw	a1,12(s2)
    80006290:	00422417          	auipc	s0,0x422
    80006294:	a5840413          	add	s0,s0,-1448 # 80427ce8 <proc_lock>
    80006298:	00100713          	li	a4,1
    8000629c:	00070793          	mv	a5,a4
    800062a0:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    800062a4:	0007879b          	sext.w	a5,a5
    800062a8:	fe079ae3          	bnez	a5,8000629c <fork+0x30>
    800062ac:	0041f797          	auipc	a5,0x41f
    800062b0:	47478793          	add	a5,a5,1140 # 80425720 <proc>
    800062b4:	00420697          	auipc	a3,0x420
    800062b8:	0ec68693          	add	a3,a3,236 # 804263a0 <fds>
    800062bc:	00000613          	li	a2,0
    800062c0:	0007a703          	lw	a4,0(a5)
    800062c4:	00070863          	beqz	a4,800062d4 <fork+0x68>
    800062c8:	00c7a703          	lw	a4,12(a5)
    800062cc:	00b71463          	bne	a4,a1,800062d4 <fork+0x68>
    800062d0:	0016061b          	addw	a2,a2,1
    800062d4:	0c878793          	add	a5,a5,200
    800062d8:	fef694e3          	bne	a3,a5,800062c0 <fork+0x54>
    800062dc:	0f50000f          	fence	iorw,ow
    800062e0:	0804202f          	amoswap.w	zero,zero,(s0)
    800062e4:	00300793          	li	a5,3
    800062e8:	0ec7c263          	blt	a5,a2,800063cc <fork+0x160>
    800062ec:	f34ff0ef          	jal	80005a20 <alloc_proc>
    800062f0:	00050493          	mv	s1,a0
    800062f4:	12050a63          	beqz	a0,80006428 <fork+0x1bc>
    800062f8:	00c92783          	lw	a5,12(s2)
    800062fc:	01853583          	ld	a1,24(a0)
    80006300:	02093603          	ld	a2,32(s2)
    80006304:	01893503          	ld	a0,24(s2)
    80006308:	00f4a623          	sw	a5,12(s1)
    8000630c:	dcdfe0ef          	jal	800050d8 <uvmcopy>
    80006310:	0e054463          	bltz	a0,800063f8 <fork+0x18c>
    80006314:	02093783          	ld	a5,32(s2)
    80006318:	00100713          	li	a4,1
    8000631c:	02f4b023          	sd	a5,32(s1)
    80006320:	00070793          	mv	a5,a4
    80006324:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    80006328:	0007879b          	sext.w	a5,a5
    8000632c:	fe079ae3          	bnez	a5,80006320 <fork+0xb4>
    80006330:	00492783          	lw	a5,4(s2)
    80006334:	0b24b823          	sd	s2,176(s1)
    80006338:	00f4a423          	sw	a5,8(s1)
    8000633c:	0f50000f          	fence	iorw,ow
    80006340:	0804202f          	amoswap.w	zero,zero,(s0)
    80006344:	03093783          	ld	a5,48(s2)
    80006348:	02078663          	beqz	a5,80006374 <fork+0x108>
    8000634c:	0304b703          	ld	a4,48(s1)
    80006350:	02070263          	beqz	a4,80006374 <fork+0x108>
    80006354:	11078613          	add	a2,a5,272
    80006358:	0007c683          	lbu	a3,0(a5)
    8000635c:	00178793          	add	a5,a5,1
    80006360:	00170713          	add	a4,a4,1
    80006364:	fed70fa3          	sb	a3,-1(a4)
    80006368:	fec798e3          	bne	a5,a2,80006358 <fork+0xec>
    8000636c:	0304b783          	ld	a5,48(s1)
    80006370:	0407b823          	sd	zero,80(a5)
    80006374:	00100713          	li	a4,1
    80006378:	00070793          	mv	a5,a4
    8000637c:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    80006380:	0007879b          	sext.w	a5,a5
    80006384:	fe079ae3          	bnez	a5,80006378 <fork+0x10c>
    80006388:	00200793          	li	a5,2
    8000638c:	00f4a023          	sw	a5,0(s1)
    80006390:	0f50000f          	fence	iorw,ow
    80006394:	0804202f          	amoswap.w	zero,zero,(s0)
    80006398:	00c4a683          	lw	a3,12(s1)
    8000639c:	00492603          	lw	a2,4(s2)
    800063a0:	0044a583          	lw	a1,4(s1)
    800063a4:	00006517          	auipc	a0,0x6
    800063a8:	a7450513          	add	a0,a0,-1420 # 8000be18 <digits+0xc40>
    800063ac:	cbcfc0ef          	jal	80002868 <printf>
    800063b0:	01813083          	ld	ra,24(sp)
    800063b4:	01013403          	ld	s0,16(sp)
    800063b8:	0044a503          	lw	a0,4(s1)
    800063bc:	00013903          	ld	s2,0(sp)
    800063c0:	00813483          	ld	s1,8(sp)
    800063c4:	02010113          	add	sp,sp,32
    800063c8:	00008067          	ret
    800063cc:	00400693          	li	a3,4
    800063d0:	00006517          	auipc	a0,0x6
    800063d4:	92050513          	add	a0,a0,-1760 # 8000bcf0 <digits+0xb18>
    800063d8:	c90fc0ef          	jal	80002868 <printf>
    800063dc:	fff00513          	li	a0,-1
    800063e0:	01813083          	ld	ra,24(sp)
    800063e4:	01013403          	ld	s0,16(sp)
    800063e8:	00813483          	ld	s1,8(sp)
    800063ec:	00013903          	ld	s2,0(sp)
    800063f0:	02010113          	add	sp,sp,32
    800063f4:	00008067          	ret
    800063f8:	00006517          	auipc	a0,0x6
    800063fc:	9f850513          	add	a0,a0,-1544 # 8000bdf0 <digits+0xc18>
    80006400:	fd8fc0ef          	jal	80002bd8 <uart_puts>
    80006404:	00048513          	mv	a0,s1
    80006408:	fd8ff0ef          	jal	80005be0 <free_proc>
    8000640c:	fff00513          	li	a0,-1
    80006410:	fd1ff06f          	j	800063e0 <fork+0x174>
    80006414:	00006517          	auipc	a0,0x6
    80006418:	98450513          	add	a0,a0,-1660 # 8000bd98 <digits+0xbc0>
    8000641c:	fbcfc0ef          	jal	80002bd8 <uart_puts>
    80006420:	fff00513          	li	a0,-1
    80006424:	fbdff06f          	j	800063e0 <fork+0x174>
    80006428:	00006517          	auipc	a0,0x6
    8000642c:	99850513          	add	a0,a0,-1640 # 8000bdc0 <digits+0xbe8>
    80006430:	fa8fc0ef          	jal	80002bd8 <uart_puts>
    80006434:	fff00513          	li	a0,-1
    80006438:	fa9ff06f          	j	800063e0 <fork+0x174>

000000008000643c <growproc>:
    8000643c:	ff010113          	add	sp,sp,-16
    80006440:	00813023          	sd	s0,0(sp)
    80006444:	00113423          	sd	ra,8(sp)
    80006448:	00422417          	auipc	s0,0x422
    8000644c:	8a843403          	ld	s0,-1880(s0) # 80427cf0 <current_proc>
    80006450:	04040063          	beqz	s0,80006490 <growproc+0x54>
    80006454:	02043583          	ld	a1,32(s0)
    80006458:	00050613          	mv	a2,a0
    8000645c:	02a04063          	bgtz	a0,8000647c <growproc+0x40>
    80006460:	02051c63          	bnez	a0,80006498 <growproc+0x5c>
    80006464:	02b43023          	sd	a1,32(s0)
    80006468:	00000513          	li	a0,0
    8000646c:	00813083          	ld	ra,8(sp)
    80006470:	00013403          	ld	s0,0(sp)
    80006474:	01010113          	add	sp,sp,16
    80006478:	00008067          	ret
    8000647c:	01843503          	ld	a0,24(s0)
    80006480:	00b60633          	add	a2,a2,a1
    80006484:	e90fe0ef          	jal	80004b14 <uvmalloc>
    80006488:	00050593          	mv	a1,a0
    8000648c:	fc051ce3          	bnez	a0,80006464 <growproc+0x28>
    80006490:	fff00513          	li	a0,-1
    80006494:	fd9ff06f          	j	8000646c <growproc+0x30>
    80006498:	01843503          	ld	a0,24(s0)
    8000649c:	00b60633          	add	a2,a2,a1
    800064a0:	dfcfe0ef          	jal	80004a9c <uvmdealloc>
    800064a4:	00050593          	mv	a1,a0
    800064a8:	fbdff06f          	j	80006464 <growproc+0x28>

00000000800064ac <exit>:
    800064ac:	00422697          	auipc	a3,0x422
    800064b0:	8446b683          	ld	a3,-1980(a3) # 80427cf0 <current_proc>
    800064b4:	08068e63          	beqz	a3,80006550 <exit+0xa4>
    800064b8:	ff010113          	add	sp,sp,-16
    800064bc:	00813023          	sd	s0,0(sp)
    800064c0:	00113423          	sd	ra,8(sp)
    800064c4:	00050613          	mv	a2,a0
    800064c8:	00422417          	auipc	s0,0x422
    800064cc:	82040413          	add	s0,s0,-2016 # 80427ce8 <proc_lock>
    800064d0:	00100713          	li	a4,1
    800064d4:	00070793          	mv	a5,a4
    800064d8:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    800064dc:	0007879b          	sext.w	a5,a5
    800064e0:	fe079ae3          	bnez	a5,800064d4 <exit+0x28>
    800064e4:	00500793          	li	a5,5
    800064e8:	00f6a023          	sw	a5,0(a3)
    800064ec:	00c6a823          	sw	a2,16(a3)
    800064f0:	0041f797          	auipc	a5,0x41f
    800064f4:	2e078793          	add	a5,a5,736 # 804257d0 <proc+0xb0>
    800064f8:	00420597          	auipc	a1,0x420
    800064fc:	f5858593          	add	a1,a1,-168 # 80426450 <fds+0xb0>
    80006500:	00100513          	li	a0,1
    80006504:	00c0006f          	j	80006510 <exit+0x64>
    80006508:	0c878793          	add	a5,a5,200
    8000650c:	00b78e63          	beq	a5,a1,80006528 <exit+0x7c>
    80006510:	0007b703          	ld	a4,0(a5)
    80006514:	fed71ae3          	bne	a4,a3,80006508 <exit+0x5c>
    80006518:	0007b023          	sd	zero,0(a5)
    8000651c:	f4a7ac23          	sw	a0,-168(a5)
    80006520:	0c878793          	add	a5,a5,200
    80006524:	feb796e3          	bne	a5,a1,80006510 <exit+0x64>
    80006528:	0046a583          	lw	a1,4(a3)
    8000652c:	00006517          	auipc	a0,0x6
    80006530:	92450513          	add	a0,a0,-1756 # 8000be50 <digits+0xc78>
    80006534:	b34fc0ef          	jal	80002868 <printf>
    80006538:	0f50000f          	fence	iorw,ow
    8000653c:	0804202f          	amoswap.w	zero,zero,(s0)
    80006540:	00013403          	ld	s0,0(sp)
    80006544:	00813083          	ld	ra,8(sp)
    80006548:	01010113          	add	sp,sp,16
    8000654c:	c71ff06f          	j	800061bc <yield>
    80006550:	00008067          	ret

0000000080006554 <wait>:
    80006554:	fb010113          	add	sp,sp,-80
    80006558:	01813023          	sd	s8,0(sp)
    8000655c:	00421c17          	auipc	s8,0x421
    80006560:	794c0c13          	add	s8,s8,1940 # 80427cf0 <current_proc>
    80006564:	02913c23          	sd	s1,56(sp)
    80006568:	000c3483          	ld	s1,0(s8)
    8000656c:	04113423          	sd	ra,72(sp)
    80006570:	04813023          	sd	s0,64(sp)
    80006574:	03213823          	sd	s2,48(sp)
    80006578:	03313423          	sd	s3,40(sp)
    8000657c:	03413023          	sd	s4,32(sp)
    80006580:	01513c23          	sd	s5,24(sp)
    80006584:	01613823          	sd	s6,16(sp)
    80006588:	01713423          	sd	s7,8(sp)
    8000658c:	10048063          	beqz	s1,8000668c <wait+0x138>
    80006590:	00050913          	mv	s2,a0
    80006594:	00421417          	auipc	s0,0x421
    80006598:	75440413          	add	s0,s0,1876 # 80427ce8 <proc_lock>
    8000659c:	00100a13          	li	s4,1
    800065a0:	00500b93          	li	s7,5
    800065a4:	01000a93          	li	s5,16
    800065a8:	00420b17          	auipc	s6,0x420
    800065ac:	df8b0b13          	add	s6,s6,-520 # 804263a0 <fds>
    800065b0:	00400993          	li	s3,4
    800065b4:	000a0793          	mv	a5,s4
    800065b8:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    800065bc:	0007879b          	sext.w	a5,a5
    800065c0:	fe079ae3          	bnez	a5,800065b4 <wait+0x60>
    800065c4:	0041f797          	auipc	a5,0x41f
    800065c8:	15c78793          	add	a5,a5,348 # 80425720 <proc>
    800065cc:	00078593          	mv	a1,a5
    800065d0:	00078713          	mv	a4,a5
    800065d4:	00000693          	li	a3,0
    800065d8:	0100006f          	j	800065e8 <wait+0x94>
    800065dc:	0016869b          	addw	a3,a3,1
    800065e0:	0c870713          	add	a4,a4,200
    800065e4:	09568863          	beq	a3,s5,80006674 <wait+0x120>
    800065e8:	0b073603          	ld	a2,176(a4)
    800065ec:	fe9618e3          	bne	a2,s1,800065dc <wait+0x88>
    800065f0:	00072603          	lw	a2,0(a4)
    800065f4:	ff7614e3          	bne	a2,s7,800065dc <wait+0x88>
    800065f8:	0c800793          	li	a5,200
    800065fc:	02f686b3          	mul	a3,a3,a5
    80006600:	00d58533          	add	a0,a1,a3
    80006604:	00452483          	lw	s1,4(a0)
    80006608:	00090663          	beqz	s2,80006614 <wait+0xc0>
    8000660c:	01052783          	lw	a5,16(a0)
    80006610:	00f92023          	sw	a5,0(s2)
    80006614:	dccff0ef          	jal	80005be0 <free_proc>
    80006618:	00048593          	mv	a1,s1
    8000661c:	00006517          	auipc	a0,0x6
    80006620:	86450513          	add	a0,a0,-1948 # 8000be80 <digits+0xca8>
    80006624:	a44fc0ef          	jal	80002868 <printf>
    80006628:	0f50000f          	fence	iorw,ow
    8000662c:	0804202f          	amoswap.w	zero,zero,(s0)
    80006630:	04813083          	ld	ra,72(sp)
    80006634:	04013403          	ld	s0,64(sp)
    80006638:	03013903          	ld	s2,48(sp)
    8000663c:	02813983          	ld	s3,40(sp)
    80006640:	02013a03          	ld	s4,32(sp)
    80006644:	01813a83          	ld	s5,24(sp)
    80006648:	01013b03          	ld	s6,16(sp)
    8000664c:	00813b83          	ld	s7,8(sp)
    80006650:	00013c03          	ld	s8,0(sp)
    80006654:	00048513          	mv	a0,s1
    80006658:	03813483          	ld	s1,56(sp)
    8000665c:	05010113          	add	sp,sp,80
    80006660:	00008067          	ret
    80006664:	0007a703          	lw	a4,0(a5)
    80006668:	02071663          	bnez	a4,80006694 <wait+0x140>
    8000666c:	0c878793          	add	a5,a5,200
    80006670:	01678a63          	beq	a5,s6,80006684 <wait+0x130>
    80006674:	0b07b703          	ld	a4,176(a5)
    80006678:	fe9706e3          	beq	a4,s1,80006664 <wait+0x110>
    8000667c:	0c878793          	add	a5,a5,200
    80006680:	ff679ae3          	bne	a5,s6,80006674 <wait+0x120>
    80006684:	0f50000f          	fence	iorw,ow
    80006688:	0804202f          	amoswap.w	zero,zero,(s0)
    8000668c:	fff00493          	li	s1,-1
    80006690:	fa1ff06f          	j	80006630 <wait+0xdc>
    80006694:	0f50000f          	fence	iorw,ow
    80006698:	0804202f          	amoswap.w	zero,zero,(s0)
    8000669c:	000c3703          	ld	a4,0(s8)
    800066a0:	f0070ae3          	beqz	a4,800065b4 <wait+0x60>
    800066a4:	000a0793          	mv	a5,s4
    800066a8:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    800066ac:	0007879b          	sext.w	a5,a5
    800066b0:	fe079ae3          	bnez	a5,800066a4 <wait+0x150>
    800066b4:	01372023          	sw	s3,0(a4)
    800066b8:	0a973c23          	sd	s1,184(a4)
    800066bc:	0f50000f          	fence	iorw,ow
    800066c0:	0804202f          	amoswap.w	zero,zero,(s0)
    800066c4:	af9ff0ef          	jal	800061bc <yield>
    800066c8:	eedff06f          	j	800065b4 <wait+0x60>

00000000800066cc <kill>:
    800066cc:	0041f597          	auipc	a1,0x41f
    800066d0:	05458593          	add	a1,a1,84 # 80425720 <proc>
    800066d4:	00058793          	mv	a5,a1
    800066d8:	00000713          	li	a4,0
    800066dc:	01000613          	li	a2,16
    800066e0:	0100006f          	j	800066f0 <kill+0x24>
    800066e4:	0017071b          	addw	a4,a4,1
    800066e8:	0c878793          	add	a5,a5,200
    800066ec:	06c70263          	beq	a4,a2,80006750 <kill+0x84>
    800066f0:	0047a683          	lw	a3,4(a5)
    800066f4:	fea698e3          	bne	a3,a0,800066e4 <kill+0x18>
    800066f8:	0007a683          	lw	a3,0(a5)
    800066fc:	fe0684e3          	beqz	a3,800066e4 <kill+0x18>
    80006700:	00421697          	auipc	a3,0x421
    80006704:	5e868693          	add	a3,a3,1512 # 80427ce8 <proc_lock>
    80006708:	00100613          	li	a2,1
    8000670c:	00060793          	mv	a5,a2
    80006710:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
    80006714:	0007879b          	sext.w	a5,a5
    80006718:	fe079ae3          	bnez	a5,8000670c <kill+0x40>
    8000671c:	0c800793          	li	a5,200
    80006720:	02f70733          	mul	a4,a4,a5
    80006724:	00100613          	li	a2,1
    80006728:	00400793          	li	a5,4
    8000672c:	00e585b3          	add	a1,a1,a4
    80006730:	0005a703          	lw	a4,0(a1)
    80006734:	00c5aa23          	sw	a2,20(a1)
    80006738:	00f71663          	bne	a4,a5,80006744 <kill+0x78>
    8000673c:	00200793          	li	a5,2
    80006740:	00f5a023          	sw	a5,0(a1)
    80006744:	0f50000f          	fence	iorw,ow
    80006748:	0806a02f          	amoswap.w	zero,zero,(a3)
    8000674c:	00008067          	ret
    80006750:	00008067          	ret

0000000080006754 <sleep>:
    80006754:	00421617          	auipc	a2,0x421
    80006758:	59c63603          	ld	a2,1436(a2) # 80427cf0 <current_proc>
    8000675c:	02060c63          	beqz	a2,80006794 <sleep+0x40>
    80006760:	00421717          	auipc	a4,0x421
    80006764:	58870713          	add	a4,a4,1416 # 80427ce8 <proc_lock>
    80006768:	00100693          	li	a3,1
    8000676c:	00068793          	mv	a5,a3
    80006770:	0cf727af          	amoswap.w.aq	a5,a5,(a4)
    80006774:	0007879b          	sext.w	a5,a5
    80006778:	fe079ae3          	bnez	a5,8000676c <sleep+0x18>
    8000677c:	00400793          	li	a5,4
    80006780:	00f62023          	sw	a5,0(a2)
    80006784:	0aa63c23          	sd	a0,184(a2)
    80006788:	0f50000f          	fence	iorw,ow
    8000678c:	0807202f          	amoswap.w	zero,zero,(a4)
    80006790:	a2dff06f          	j	800061bc <yield>
    80006794:	00008067          	ret

0000000080006798 <wakeup>:
    80006798:	00421697          	auipc	a3,0x421
    8000679c:	55068693          	add	a3,a3,1360 # 80427ce8 <proc_lock>
    800067a0:	00100713          	li	a4,1
    800067a4:	00070793          	mv	a5,a4
    800067a8:	0cf6a7af          	amoswap.w.aq	a5,a5,(a3)
    800067ac:	0007879b          	sext.w	a5,a5
    800067b0:	fe079ae3          	bnez	a5,800067a4 <wakeup+0xc>
    800067b4:	0041f797          	auipc	a5,0x41f
    800067b8:	f6c78793          	add	a5,a5,-148 # 80425720 <proc>
    800067bc:	00420597          	auipc	a1,0x420
    800067c0:	be458593          	add	a1,a1,-1052 # 804263a0 <fds>
    800067c4:	00400613          	li	a2,4
    800067c8:	00200813          	li	a6,2
    800067cc:	00c0006f          	j	800067d8 <wakeup+0x40>
    800067d0:	0c878793          	add	a5,a5,200
    800067d4:	02f58063          	beq	a1,a5,800067f4 <wakeup+0x5c>
    800067d8:	0007a703          	lw	a4,0(a5)
    800067dc:	fec71ae3          	bne	a4,a2,800067d0 <wakeup+0x38>
    800067e0:	0b87b703          	ld	a4,184(a5)
    800067e4:	fea716e3          	bne	a4,a0,800067d0 <wakeup+0x38>
    800067e8:	0107a023          	sw	a6,0(a5)
    800067ec:	0c878793          	add	a5,a5,200
    800067f0:	fef594e3          	bne	a1,a5,800067d8 <wakeup+0x40>
    800067f4:	0f50000f          	fence	iorw,ow
    800067f8:	0806a02f          	amoswap.w	zero,zero,(a3)
    800067fc:	00008067          	ret

0000000080006800 <wakeup_one>:
    80006800:	00421617          	auipc	a2,0x421
    80006804:	4e860613          	add	a2,a2,1256 # 80427ce8 <proc_lock>
    80006808:	00100713          	li	a4,1
    8000680c:	00070793          	mv	a5,a4
    80006810:	0cf627af          	amoswap.w.aq	a5,a5,(a2)
    80006814:	0007879b          	sext.w	a5,a5
    80006818:	fe079ae3          	bnez	a5,8000680c <wakeup_one+0xc>
    8000681c:	0041f897          	auipc	a7,0x41f
    80006820:	f0488893          	add	a7,a7,-252 # 80425720 <proc>
    80006824:	00088793          	mv	a5,a7
    80006828:	00000713          	li	a4,0
    8000682c:	00400593          	li	a1,4
    80006830:	01000813          	li	a6,16
    80006834:	0100006f          	j	80006844 <wakeup_one+0x44>
    80006838:	0017071b          	addw	a4,a4,1
    8000683c:	0c878793          	add	a5,a5,200
    80006840:	03070463          	beq	a4,a6,80006868 <wakeup_one+0x68>
    80006844:	0007a683          	lw	a3,0(a5)
    80006848:	feb698e3          	bne	a3,a1,80006838 <wakeup_one+0x38>
    8000684c:	0b87b683          	ld	a3,184(a5)
    80006850:	fea694e3          	bne	a3,a0,80006838 <wakeup_one+0x38>
    80006854:	0c800793          	li	a5,200
    80006858:	02f70733          	mul	a4,a4,a5
    8000685c:	00200793          	li	a5,2
    80006860:	00e888b3          	add	a7,a7,a4
    80006864:	00f8a023          	sw	a5,0(a7)
    80006868:	0f50000f          	fence	iorw,ow
    8000686c:	0806202f          	amoswap.w	zero,zero,(a2)
    80006870:	00008067          	ret

0000000080006874 <sem_init>:
    80006874:	00050a63          	beqz	a0,80006888 <sem_init+0x14>
    80006878:	00b52023          	sw	a1,0(a0)
    8000687c:	00a53423          	sd	a0,8(a0)
    80006880:	00053823          	sd	zero,16(a0)
    80006884:	00053c23          	sd	zero,24(a0)
    80006888:	00008067          	ret

000000008000688c <sem_wait>:
    8000688c:	10050c63          	beqz	a0,800069a4 <sem_wait+0x118>
    80006890:	fc010113          	add	sp,sp,-64
    80006894:	01313c23          	sd	s3,24(sp)
    80006898:	02113c23          	sd	ra,56(sp)
    8000689c:	02813823          	sd	s0,48(sp)
    800068a0:	02913423          	sd	s1,40(sp)
    800068a4:	03213023          	sd	s2,32(sp)
    800068a8:	01413823          	sd	s4,16(sp)
    800068ac:	01513423          	sd	s5,8(sp)
    800068b0:	00421997          	auipc	s3,0x421
    800068b4:	4409b983          	ld	s3,1088(s3) # 80427cf0 <current_proc>
    800068b8:	0a098e63          	beqz	s3,80006974 <sem_wait+0xe8>
    800068bc:	00050913          	mv	s2,a0
    800068c0:	00421417          	auipc	s0,0x421
    800068c4:	42840413          	add	s0,s0,1064 # 80427ce8 <proc_lock>
    800068c8:	00100713          	li	a4,1
    800068cc:	00070793          	mv	a5,a4
    800068d0:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    800068d4:	0007879b          	sext.w	a5,a5
    800068d8:	fe079ae3          	bnez	a5,800068cc <sem_wait+0x40>
    800068dc:	00092783          	lw	a5,0(s2)
    800068e0:	06f04a63          	bgtz	a5,80006954 <sem_wait+0xc8>
    800068e4:	00400a93          	li	s5,4
    800068e8:	00005a17          	auipc	s4,0x5
    800068ec:	5b8a0a13          	add	s4,s4,1464 # 8000bea0 <digits+0xcc8>
    800068f0:	00100493          	li	s1,1
    800068f4:	b90fc0ef          	jal	80002c84 <alloc_page>
    800068f8:	00050e63          	beqz	a0,80006914 <sem_wait+0x88>
    800068fc:	01893783          	ld	a5,24(s2)
    80006900:	01353023          	sd	s3,0(a0)
    80006904:	00053423          	sd	zero,8(a0)
    80006908:	08078863          	beqz	a5,80006998 <sem_wait+0x10c>
    8000690c:	00a7b423          	sd	a0,8(a5)
    80006910:	00a93c23          	sd	a0,24(s2)
    80006914:	00893783          	ld	a5,8(s2)
    80006918:	0159a023          	sw	s5,0(s3)
    8000691c:	0af9bc23          	sd	a5,184(s3)
    80006920:	0f50000f          	fence	iorw,ow
    80006924:	0804202f          	amoswap.w	zero,zero,(s0)
    80006928:	00092603          	lw	a2,0(s2)
    8000692c:	0049a583          	lw	a1,4(s3)
    80006930:	000a0513          	mv	a0,s4
    80006934:	f35fb0ef          	jal	80002868 <printf>
    80006938:	885ff0ef          	jal	800061bc <yield>
    8000693c:	00048793          	mv	a5,s1
    80006940:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    80006944:	0007879b          	sext.w	a5,a5
    80006948:	fe079ae3          	bnez	a5,8000693c <sem_wait+0xb0>
    8000694c:	00092783          	lw	a5,0(s2)
    80006950:	faf052e3          	blez	a5,800068f4 <sem_wait+0x68>
    80006954:	0049a583          	lw	a1,4(s3)
    80006958:	fff7861b          	addw	a2,a5,-1
    8000695c:	00c92023          	sw	a2,0(s2)
    80006960:	00005517          	auipc	a0,0x5
    80006964:	57050513          	add	a0,a0,1392 # 8000bed0 <digits+0xcf8>
    80006968:	f01fb0ef          	jal	80002868 <printf>
    8000696c:	0f50000f          	fence	iorw,ow
    80006970:	0804202f          	amoswap.w	zero,zero,(s0)
    80006974:	03813083          	ld	ra,56(sp)
    80006978:	03013403          	ld	s0,48(sp)
    8000697c:	02813483          	ld	s1,40(sp)
    80006980:	02013903          	ld	s2,32(sp)
    80006984:	01813983          	ld	s3,24(sp)
    80006988:	01013a03          	ld	s4,16(sp)
    8000698c:	00813a83          	ld	s5,8(sp)
    80006990:	04010113          	add	sp,sp,64
    80006994:	00008067          	ret
    80006998:	00a93c23          	sd	a0,24(s2)
    8000699c:	00a93823          	sd	a0,16(s2)
    800069a0:	f75ff06f          	j	80006914 <sem_wait+0x88>
    800069a4:	00008067          	ret

00000000800069a8 <sem_post>:
    800069a8:	08050e63          	beqz	a0,80006a44 <sem_post+0x9c>
    800069ac:	fe010113          	add	sp,sp,-32
    800069b0:	00813823          	sd	s0,16(sp)
    800069b4:	00913423          	sd	s1,8(sp)
    800069b8:	00113c23          	sd	ra,24(sp)
    800069bc:	01213023          	sd	s2,0(sp)
    800069c0:	00050493          	mv	s1,a0
    800069c4:	00421417          	auipc	s0,0x421
    800069c8:	32440413          	add	s0,s0,804 # 80427ce8 <proc_lock>
    800069cc:	00100713          	li	a4,1
    800069d0:	00070793          	mv	a5,a4
    800069d4:	0cf427af          	amoswap.w.aq	a5,a5,(s0)
    800069d8:	0007879b          	sext.w	a5,a5
    800069dc:	fe079ae3          	bnez	a5,800069d0 <sem_post+0x28>
    800069e0:	0004a583          	lw	a1,0(s1)
    800069e4:	00005517          	auipc	a0,0x5
    800069e8:	51c50513          	add	a0,a0,1308 # 8000bf00 <digits+0xd28>
    800069ec:	0015859b          	addw	a1,a1,1
    800069f0:	00b4a023          	sw	a1,0(s1)
    800069f4:	e75fb0ef          	jal	80002868 <printf>
    800069f8:	0104b503          	ld	a0,16(s1)
    800069fc:	02050463          	beqz	a0,80006a24 <sem_post+0x7c>
    80006a00:	00853783          	ld	a5,8(a0)
    80006a04:	00053903          	ld	s2,0(a0)
    80006a08:	00f4b823          	sd	a5,16(s1)
    80006a0c:	02078e63          	beqz	a5,80006a48 <sem_post+0xa0>
    80006a10:	a90fc0ef          	jal	80002ca0 <free_page>
    80006a14:	00090863          	beqz	s2,80006a24 <sem_post+0x7c>
    80006a18:	00092703          	lw	a4,0(s2)
    80006a1c:	00400793          	li	a5,4
    80006a20:	02f70c63          	beq	a4,a5,80006a58 <sem_post+0xb0>
    80006a24:	0f50000f          	fence	iorw,ow
    80006a28:	0804202f          	amoswap.w	zero,zero,(s0)
    80006a2c:	01813083          	ld	ra,24(sp)
    80006a30:	01013403          	ld	s0,16(sp)
    80006a34:	00813483          	ld	s1,8(sp)
    80006a38:	00013903          	ld	s2,0(sp)
    80006a3c:	02010113          	add	sp,sp,32
    80006a40:	00008067          	ret
    80006a44:	00008067          	ret
    80006a48:	0004bc23          	sd	zero,24(s1)
    80006a4c:	a54fc0ef          	jal	80002ca0 <free_page>
    80006a50:	fc0914e3          	bnez	s2,80006a18 <sem_post+0x70>
    80006a54:	fd1ff06f          	j	80006a24 <sem_post+0x7c>
    80006a58:	0b893703          	ld	a4,184(s2)
    80006a5c:	0084b783          	ld	a5,8(s1)
    80006a60:	fcf712e3          	bne	a4,a5,80006a24 <sem_post+0x7c>
    80006a64:	00492583          	lw	a1,4(s2)
    80006a68:	00200793          	li	a5,2
    80006a6c:	00f92023          	sw	a5,0(s2)
    80006a70:	0a093c23          	sd	zero,184(s2)
    80006a74:	00005517          	auipc	a0,0x5
    80006a78:	4bc50513          	add	a0,a0,1212 # 8000bf30 <digits+0xd58>
    80006a7c:	dedfb0ef          	jal	80002868 <printf>
    80006a80:	fa5ff06f          	j	80006a24 <sem_post+0x7c>

0000000080006a84 <sem_trywait>:
    80006a84:	04050463          	beqz	a0,80006acc <sem_trywait+0x48>
    80006a88:	00421717          	auipc	a4,0x421
    80006a8c:	26070713          	add	a4,a4,608 # 80427ce8 <proc_lock>
    80006a90:	00100693          	li	a3,1
    80006a94:	00068793          	mv	a5,a3
    80006a98:	0cf727af          	amoswap.w.aq	a5,a5,(a4)
    80006a9c:	0007879b          	sext.w	a5,a5
    80006aa0:	fe079ae3          	bnez	a5,80006a94 <sem_trywait+0x10>
    80006aa4:	00052783          	lw	a5,0(a0)
    80006aa8:	00f05e63          	blez	a5,80006ac4 <sem_trywait+0x40>
    80006aac:	fff7879b          	addw	a5,a5,-1
    80006ab0:	00f52023          	sw	a5,0(a0)
    80006ab4:	0f50000f          	fence	iorw,ow
    80006ab8:	0807202f          	amoswap.w	zero,zero,(a4)
    80006abc:	00000513          	li	a0,0
    80006ac0:	00008067          	ret
    80006ac4:	0f50000f          	fence	iorw,ow
    80006ac8:	0807202f          	amoswap.w	zero,zero,(a4)
    80006acc:	fff00513          	li	a0,-1
    80006ad0:	00008067          	ret

0000000080006ad4 <myproc>:
    80006ad4:	00421517          	auipc	a0,0x421
    80006ad8:	21c53503          	ld	a0,540(a0) # 80427cf0 <current_proc>
    80006adc:	00008067          	ret

0000000080006ae0 <machinevec>:
    80006ae0:	f0810113          	add	sp,sp,-248
    80006ae4:	00113023          	sd	ra,0(sp)
    80006ae8:	00313823          	sd	gp,16(sp)
    80006aec:	00413c23          	sd	tp,24(sp)
    80006af0:	02513023          	sd	t0,32(sp)
    80006af4:	02613423          	sd	t1,40(sp)
    80006af8:	02713823          	sd	t2,48(sp)
    80006afc:	02813c23          	sd	s0,56(sp)
    80006b00:	04913023          	sd	s1,64(sp)
    80006b04:	04a13423          	sd	a0,72(sp)
    80006b08:	04b13823          	sd	a1,80(sp)
    80006b0c:	04c13c23          	sd	a2,88(sp)
    80006b10:	06d13023          	sd	a3,96(sp)
    80006b14:	06e13423          	sd	a4,104(sp)
    80006b18:	06f13823          	sd	a5,112(sp)
    80006b1c:	07013c23          	sd	a6,120(sp)
    80006b20:	09113023          	sd	a7,128(sp)
    80006b24:	09213423          	sd	s2,136(sp)
    80006b28:	09313823          	sd	s3,144(sp)
    80006b2c:	09413c23          	sd	s4,152(sp)
    80006b30:	0b513023          	sd	s5,160(sp)
    80006b34:	0b613423          	sd	s6,168(sp)
    80006b38:	0b713823          	sd	s7,176(sp)
    80006b3c:	0b813c23          	sd	s8,184(sp)
    80006b40:	0d913023          	sd	s9,192(sp)
    80006b44:	0da13423          	sd	s10,200(sp)
    80006b48:	0db13823          	sd	s11,208(sp)
    80006b4c:	0dc13c23          	sd	t3,216(sp)
    80006b50:	0fd13023          	sd	t4,224(sp)
    80006b54:	0fe13423          	sd	t5,232(sp)
    80006b58:	0ff13823          	sd	t6,240(sp)
    80006b5c:	0f810293          	add	t0,sp,248
    80006b60:	00513423          	sd	t0,8(sp)
    80006b64:	34202573          	csrr	a0,mcause
    80006b68:	fff0029b          	addw	t0,zero,-1
    80006b6c:	03f29293          	sll	t0,t0,0x3f
    80006b70:	00728293          	add	t0,t0,7
    80006b74:	00551663          	bne	a0,t0,80006b80 <interrupt_return>
    80006b78:	ec8fe0ef          	jal	80005240 <machine_timer_handler>
    80006b7c:	0040006f          	j	80006b80 <interrupt_return>

0000000080006b80 <interrupt_return>:
    80006b80:	00013083          	ld	ra,0(sp)
    80006b84:	01013183          	ld	gp,16(sp)
    80006b88:	01813203          	ld	tp,24(sp)
    80006b8c:	02013283          	ld	t0,32(sp)
    80006b90:	02813303          	ld	t1,40(sp)
    80006b94:	03013383          	ld	t2,48(sp)
    80006b98:	03813403          	ld	s0,56(sp)
    80006b9c:	04013483          	ld	s1,64(sp)
    80006ba0:	04813503          	ld	a0,72(sp)
    80006ba4:	05013583          	ld	a1,80(sp)
    80006ba8:	05813603          	ld	a2,88(sp)
    80006bac:	06013683          	ld	a3,96(sp)
    80006bb0:	06813703          	ld	a4,104(sp)
    80006bb4:	07013783          	ld	a5,112(sp)
    80006bb8:	07813803          	ld	a6,120(sp)
    80006bbc:	08013883          	ld	a7,128(sp)
    80006bc0:	08813903          	ld	s2,136(sp)
    80006bc4:	09013983          	ld	s3,144(sp)
    80006bc8:	09813a03          	ld	s4,152(sp)
    80006bcc:	0a013a83          	ld	s5,160(sp)
    80006bd0:	0a813b03          	ld	s6,168(sp)
    80006bd4:	0b013b83          	ld	s7,176(sp)
    80006bd8:	0b813c03          	ld	s8,184(sp)
    80006bdc:	0c013c83          	ld	s9,192(sp)
    80006be0:	0c813d03          	ld	s10,200(sp)
    80006be4:	0d013d83          	ld	s11,208(sp)
    80006be8:	0d813e03          	ld	t3,216(sp)
    80006bec:	0e013e83          	ld	t4,224(sp)
    80006bf0:	0e813f03          	ld	t5,232(sp)
    80006bf4:	0f013f83          	ld	t6,240(sp)
    80006bf8:	00813103          	ld	sp,8(sp)
    80006bfc:	30200073          	mret

0000000080006c00 <kernelvec>:
    80006c00:	ef010113          	add	sp,sp,-272
    80006c04:	00013023          	sd	zero,0(sp)
    80006c08:	00113423          	sd	ra,8(sp)
    80006c0c:	00313c23          	sd	gp,24(sp)
    80006c10:	02413023          	sd	tp,32(sp)
    80006c14:	02513423          	sd	t0,40(sp)
    80006c18:	02613823          	sd	t1,48(sp)
    80006c1c:	02713c23          	sd	t2,56(sp)
    80006c20:	04813023          	sd	s0,64(sp)
    80006c24:	04913423          	sd	s1,72(sp)
    80006c28:	04a13823          	sd	a0,80(sp)
    80006c2c:	04b13c23          	sd	a1,88(sp)
    80006c30:	06c13023          	sd	a2,96(sp)
    80006c34:	06d13423          	sd	a3,104(sp)
    80006c38:	06e13823          	sd	a4,112(sp)
    80006c3c:	06f13c23          	sd	a5,120(sp)
    80006c40:	09013023          	sd	a6,128(sp)
    80006c44:	09113423          	sd	a7,136(sp)
    80006c48:	09213823          	sd	s2,144(sp)
    80006c4c:	09313c23          	sd	s3,152(sp)
    80006c50:	0b413023          	sd	s4,160(sp)
    80006c54:	0b513423          	sd	s5,168(sp)
    80006c58:	0b613823          	sd	s6,176(sp)
    80006c5c:	0b713c23          	sd	s7,184(sp)
    80006c60:	0d813023          	sd	s8,192(sp)
    80006c64:	0d913423          	sd	s9,200(sp)
    80006c68:	0da13823          	sd	s10,208(sp)
    80006c6c:	0db13c23          	sd	s11,216(sp)
    80006c70:	0fc13023          	sd	t3,224(sp)
    80006c74:	0fd13423          	sd	t4,232(sp)
    80006c78:	0fe13823          	sd	t5,240(sp)
    80006c7c:	0ff13c23          	sd	t6,248(sp)
    80006c80:	11010293          	add	t0,sp,272
    80006c84:	00513823          	sd	t0,16(sp)
    80006c88:	141022f3          	csrr	t0,sepc
    80006c8c:	10513023          	sd	t0,256(sp)
    80006c90:	142022f3          	csrr	t0,scause
    80006c94:	10513423          	sd	t0,264(sp)
    80006c98:	c45fe0ef          	jal	800058dc <kerneltrap>
    80006c9c:	00813083          	ld	ra,8(sp)
    80006ca0:	01813183          	ld	gp,24(sp)
    80006ca4:	02013203          	ld	tp,32(sp)
    80006ca8:	02813283          	ld	t0,40(sp)
    80006cac:	03013303          	ld	t1,48(sp)
    80006cb0:	03813383          	ld	t2,56(sp)
    80006cb4:	04013403          	ld	s0,64(sp)
    80006cb8:	04813483          	ld	s1,72(sp)
    80006cbc:	05013503          	ld	a0,80(sp)
    80006cc0:	05813583          	ld	a1,88(sp)
    80006cc4:	06013603          	ld	a2,96(sp)
    80006cc8:	06813683          	ld	a3,104(sp)
    80006ccc:	07013703          	ld	a4,112(sp)
    80006cd0:	07813783          	ld	a5,120(sp)
    80006cd4:	08013803          	ld	a6,128(sp)
    80006cd8:	08813883          	ld	a7,136(sp)
    80006cdc:	09013903          	ld	s2,144(sp)
    80006ce0:	09813983          	ld	s3,152(sp)
    80006ce4:	0a013a03          	ld	s4,160(sp)
    80006ce8:	0a813a83          	ld	s5,168(sp)
    80006cec:	0b013b03          	ld	s6,176(sp)
    80006cf0:	0b813b83          	ld	s7,184(sp)
    80006cf4:	0c013c03          	ld	s8,192(sp)
    80006cf8:	0c813c83          	ld	s9,200(sp)
    80006cfc:	0d013d03          	ld	s10,208(sp)
    80006d00:	0d813d83          	ld	s11,216(sp)
    80006d04:	0e013e03          	ld	t3,224(sp)
    80006d08:	0e813e83          	ld	t4,232(sp)
    80006d0c:	0f013f03          	ld	t5,240(sp)
    80006d10:	0f813f83          	ld	t6,248(sp)
    80006d14:	10013283          	ld	t0,256(sp)
    80006d18:	14129073          	csrw	sepc,t0
    80006d1c:	10813283          	ld	t0,264(sp)
    80006d20:	14229073          	csrw	scause,t0
    80006d24:	01013103          	ld	sp,16(sp)
    80006d28:	10200073          	sret
    80006d2c:	0000                	.2byte	0x0
	...

0000000080006d30 <uservec>:
    80006d30:	00010293          	mv	t0,sp
    80006d34:	ef010113          	add	sp,sp,-272
    80006d38:	00513823          	sd	t0,16(sp)
    80006d3c:	00113423          	sd	ra,8(sp)
    80006d40:	00313c23          	sd	gp,24(sp)
    80006d44:	02413023          	sd	tp,32(sp)
    80006d48:	02513423          	sd	t0,40(sp)
    80006d4c:	02613823          	sd	t1,48(sp)
    80006d50:	02713c23          	sd	t2,56(sp)
    80006d54:	04813023          	sd	s0,64(sp)
    80006d58:	04913423          	sd	s1,72(sp)
    80006d5c:	04a13823          	sd	a0,80(sp)
    80006d60:	04b13c23          	sd	a1,88(sp)
    80006d64:	06c13023          	sd	a2,96(sp)
    80006d68:	06d13423          	sd	a3,104(sp)
    80006d6c:	06e13823          	sd	a4,112(sp)
    80006d70:	06f13c23          	sd	a5,120(sp)
    80006d74:	09013023          	sd	a6,128(sp)
    80006d78:	09113423          	sd	a7,136(sp)
    80006d7c:	09213823          	sd	s2,144(sp)
    80006d80:	09313c23          	sd	s3,152(sp)
    80006d84:	0b413023          	sd	s4,160(sp)
    80006d88:	0b513423          	sd	s5,168(sp)
    80006d8c:	0b613823          	sd	s6,176(sp)
    80006d90:	0b713c23          	sd	s7,184(sp)
    80006d94:	0d813023          	sd	s8,192(sp)
    80006d98:	0d913423          	sd	s9,200(sp)
    80006d9c:	0da13823          	sd	s10,208(sp)
    80006da0:	0db13c23          	sd	s11,216(sp)
    80006da4:	0fc13023          	sd	t3,224(sp)
    80006da8:	0fd13423          	sd	t4,232(sp)
    80006dac:	0fe13823          	sd	t5,240(sp)
    80006db0:	0ff13c23          	sd	t6,248(sp)
    80006db4:	10002373          	csrr	t1,sstatus
    80006db8:	10613023          	sd	t1,256(sp)
    80006dbc:	14102373          	csrr	t1,sepc
    80006dc0:	10613423          	sd	t1,264(sp)
    80006dc4:	859fe0ef          	jal	8000561c <usertrap>
    80006dc8:	00813083          	ld	ra,8(sp)
    80006dcc:	01813183          	ld	gp,24(sp)
    80006dd0:	02013203          	ld	tp,32(sp)
    80006dd4:	02813283          	ld	t0,40(sp)
    80006dd8:	03013303          	ld	t1,48(sp)
    80006ddc:	03813383          	ld	t2,56(sp)
    80006de0:	04013403          	ld	s0,64(sp)
    80006de4:	04813483          	ld	s1,72(sp)
    80006de8:	05013503          	ld	a0,80(sp)
    80006dec:	05813583          	ld	a1,88(sp)
    80006df0:	06013603          	ld	a2,96(sp)
    80006df4:	06813683          	ld	a3,104(sp)
    80006df8:	07013703          	ld	a4,112(sp)
    80006dfc:	07813783          	ld	a5,120(sp)
    80006e00:	08013803          	ld	a6,128(sp)
    80006e04:	08813883          	ld	a7,136(sp)
    80006e08:	09013903          	ld	s2,144(sp)
    80006e0c:	09813983          	ld	s3,152(sp)
    80006e10:	0a013a03          	ld	s4,160(sp)
    80006e14:	0a813a83          	ld	s5,168(sp)
    80006e18:	0b013b03          	ld	s6,176(sp)
    80006e1c:	0b813b83          	ld	s7,184(sp)
    80006e20:	0c013c03          	ld	s8,192(sp)
    80006e24:	0c813c83          	ld	s9,200(sp)
    80006e28:	0d013d03          	ld	s10,208(sp)
    80006e2c:	0d813d83          	ld	s11,216(sp)
    80006e30:	0e013e03          	ld	t3,224(sp)
    80006e34:	0e813e83          	ld	t4,232(sp)
    80006e38:	0f013f03          	ld	t5,240(sp)
    80006e3c:	0f813f83          	ld	t6,248(sp)
    80006e40:	10013303          	ld	t1,256(sp)
    80006e44:	10031073          	csrw	sstatus,t1
    80006e48:	10813303          	ld	t1,264(sp)
    80006e4c:	14131073          	csrw	sepc,t1
    80006e50:	01013103          	ld	sp,16(sp)
    80006e54:	10200073          	sret
	...

0000000080006e60 <switch_context>:
    80006e60:	00153023          	sd	ra,0(a0)
    80006e64:	00253423          	sd	sp,8(a0)
    80006e68:	00853823          	sd	s0,16(a0)
    80006e6c:	00953c23          	sd	s1,24(a0)
    80006e70:	03253023          	sd	s2,32(a0)
    80006e74:	03353423          	sd	s3,40(a0)
    80006e78:	03453823          	sd	s4,48(a0)
    80006e7c:	03553c23          	sd	s5,56(a0)
    80006e80:	05653023          	sd	s6,64(a0)
    80006e84:	05753423          	sd	s7,72(a0)
    80006e88:	05853823          	sd	s8,80(a0)
    80006e8c:	05953c23          	sd	s9,88(a0)
    80006e90:	07a53023          	sd	s10,96(a0)
    80006e94:	07b53423          	sd	s11,104(a0)
    80006e98:	0005b083          	ld	ra,0(a1)
    80006e9c:	0085b103          	ld	sp,8(a1)
    80006ea0:	0105b403          	ld	s0,16(a1)
    80006ea4:	0185b483          	ld	s1,24(a1)
    80006ea8:	0205b903          	ld	s2,32(a1)
    80006eac:	0285b983          	ld	s3,40(a1)
    80006eb0:	0305ba03          	ld	s4,48(a1)
    80006eb4:	0385ba83          	ld	s5,56(a1)
    80006eb8:	0405bb03          	ld	s6,64(a1)
    80006ebc:	0485bb83          	ld	s7,72(a1)
    80006ec0:	0505bc03          	ld	s8,80(a1)
    80006ec4:	0585bc83          	ld	s9,88(a1)
    80006ec8:	0605bd03          	ld	s10,96(a1)
    80006ecc:	0685bd83          	ld	s11,104(a1)
    80006ed0:	00008067          	ret

0000000080006ed4 <sys_getpid>:
    80006ed4:	ff010113          	add	sp,sp,-16
    80006ed8:	00113423          	sd	ra,8(sp)
    80006edc:	bf9ff0ef          	jal	80006ad4 <myproc>
    80006ee0:	00050a63          	beqz	a0,80006ef4 <sys_getpid+0x20>
    80006ee4:	00452503          	lw	a0,4(a0)
    80006ee8:	00813083          	ld	ra,8(sp)
    80006eec:	01010113          	add	sp,sp,16
    80006ef0:	00008067          	ret
    80006ef4:	fff00513          	li	a0,-1
    80006ef8:	ff1ff06f          	j	80006ee8 <sys_getpid+0x14>

0000000080006efc <sys_close>:
    80006efc:	ff010113          	add	sp,sp,-16
    80006f00:	00113423          	sd	ra,8(sp)
    80006f04:	bd1ff0ef          	jal	80006ad4 <myproc>
    80006f08:	00050e63          	beqz	a0,80006f24 <sys_close+0x28>
    80006f0c:	03053783          	ld	a5,48(a0)
    80006f10:	00078a63          	beqz	a5,80006f24 <sys_close+0x28>
    80006f14:	00813083          	ld	ra,8(sp)
    80006f18:	0507a503          	lw	a0,80(a5)
    80006f1c:	01010113          	add	sp,sp,16
    80006f20:	7a80006f          	j	800076c8 <fs_close>
    80006f24:	00813083          	ld	ra,8(sp)
    80006f28:	fff00513          	li	a0,-1
    80006f2c:	01010113          	add	sp,sp,16
    80006f30:	00008067          	ret

0000000080006f34 <sys_read>:
    80006f34:	ee010113          	add	sp,sp,-288
    80006f38:	10113c23          	sd	ra,280(sp)
    80006f3c:	10813823          	sd	s0,272(sp)
    80006f40:	10913423          	sd	s1,264(sp)
    80006f44:	b91ff0ef          	jal	80006ad4 <myproc>
    80006f48:	0a050463          	beqz	a0,80006ff0 <sys_read+0xbc>
    80006f4c:	03053783          	ld	a5,48(a0)
    80006f50:	0a078063          	beqz	a5,80006ff0 <sys_read+0xbc>
    80006f54:	0507b483          	ld	s1,80(a5)
    80006f58:	b7dff0ef          	jal	80006ad4 <myproc>
    80006f5c:	08050a63          	beqz	a0,80006ff0 <sys_read+0xbc>
    80006f60:	03053783          	ld	a5,48(a0)
    80006f64:	08078663          	beqz	a5,80006ff0 <sys_read+0xbc>
    80006f68:	0587b403          	ld	s0,88(a5)
    80006f6c:	b69ff0ef          	jal	80006ad4 <myproc>
    80006f70:	08050063          	beqz	a0,80006ff0 <sys_read+0xbc>
    80006f74:	03053783          	ld	a5,48(a0)
    80006f78:	06078c63          	beqz	a5,80006ff0 <sys_read+0xbc>
    80006f7c:	0607a783          	lw	a5,96(a5)
    80006f80:	00000513          	li	a0,0
    80006f84:	04f05063          	blez	a5,80006fc4 <sys_read+0x90>
    80006f88:	10000713          	li	a4,256
    80006f8c:	0007861b          	sext.w	a2,a5
    80006f90:	04f74463          	blt	a4,a5,80006fd8 <sys_read+0xa4>
    80006f94:	00010593          	mv	a1,sp
    80006f98:	0004851b          	sext.w	a0,s1
    80006f9c:	768000ef          	jal	80007704 <fs_read>
    80006fa0:	02a05263          	blez	a0,80006fc4 <sys_read+0x90>
    80006fa4:	00010793          	mv	a5,sp
    80006fa8:	00a10633          	add	a2,sp,a0
    80006fac:	40f405b3          	sub	a1,s0,a5
    80006fb0:	0007c683          	lbu	a3,0(a5)
    80006fb4:	00f58733          	add	a4,a1,a5
    80006fb8:	00178793          	add	a5,a5,1
    80006fbc:	00d70023          	sb	a3,0(a4)
    80006fc0:	fec798e3          	bne	a5,a2,80006fb0 <sys_read+0x7c>
    80006fc4:	11813083          	ld	ra,280(sp)
    80006fc8:	11013403          	ld	s0,272(sp)
    80006fcc:	10813483          	ld	s1,264(sp)
    80006fd0:	12010113          	add	sp,sp,288
    80006fd4:	00008067          	ret
    80006fd8:	10000613          	li	a2,256
    80006fdc:	00010593          	mv	a1,sp
    80006fe0:	0004851b          	sext.w	a0,s1
    80006fe4:	720000ef          	jal	80007704 <fs_read>
    80006fe8:	faa04ee3          	bgtz	a0,80006fa4 <sys_read+0x70>
    80006fec:	fd9ff06f          	j	80006fc4 <sys_read+0x90>
    80006ff0:	fff00513          	li	a0,-1
    80006ff4:	fd1ff06f          	j	80006fc4 <sys_read+0x90>

0000000080006ff8 <get_syscall_arg>:
    80006ff8:	fe010113          	add	sp,sp,-32
    80006ffc:	00813823          	sd	s0,16(sp)
    80007000:	00913423          	sd	s1,8(sp)
    80007004:	00113c23          	sd	ra,24(sp)
    80007008:	00050413          	mv	s0,a0
    8000700c:	00058493          	mv	s1,a1
    80007010:	ac5ff0ef          	jal	80006ad4 <myproc>
    80007014:	06050c63          	beqz	a0,8000708c <get_syscall_arg+0x94>
    80007018:	03053683          	ld	a3,48(a0)
    8000701c:	06068863          	beqz	a3,8000708c <get_syscall_arg+0x94>
    80007020:	00500793          	li	a5,5
    80007024:	0687e463          	bltu	a5,s0,8000708c <get_syscall_arg+0x94>
    80007028:	00005717          	auipc	a4,0x5
    8000702c:	f2870713          	add	a4,a4,-216 # 8000bf50 <digits+0xd78>
    80007030:	00241413          	sll	s0,s0,0x2
    80007034:	00e40433          	add	s0,s0,a4
    80007038:	00042783          	lw	a5,0(s0)
    8000703c:	00e787b3          	add	a5,a5,a4
    80007040:	00078067          	jr	a5
    80007044:	0706b783          	ld	a5,112(a3)
    80007048:	00f4b023          	sd	a5,0(s1)
    8000704c:	00000513          	li	a0,0
    80007050:	01813083          	ld	ra,24(sp)
    80007054:	01013403          	ld	s0,16(sp)
    80007058:	00813483          	ld	s1,8(sp)
    8000705c:	02010113          	add	sp,sp,32
    80007060:	00008067          	ret
    80007064:	0786b783          	ld	a5,120(a3)
    80007068:	fe1ff06f          	j	80007048 <get_syscall_arg+0x50>
    8000706c:	0506b783          	ld	a5,80(a3)
    80007070:	fd9ff06f          	j	80007048 <get_syscall_arg+0x50>
    80007074:	0586b783          	ld	a5,88(a3)
    80007078:	fd1ff06f          	j	80007048 <get_syscall_arg+0x50>
    8000707c:	0606b783          	ld	a5,96(a3)
    80007080:	fc9ff06f          	j	80007048 <get_syscall_arg+0x50>
    80007084:	0686b783          	ld	a5,104(a3)
    80007088:	fc1ff06f          	j	80007048 <get_syscall_arg+0x50>
    8000708c:	fff00513          	li	a0,-1
    80007090:	fc1ff06f          	j	80007050 <get_syscall_arg+0x58>

0000000080007094 <get_user_string>:
    80007094:	0a050663          	beqz	a0,80007140 <get_user_string+0xac>
    80007098:	fe010113          	add	sp,sp,-32
    8000709c:	00913423          	sd	s1,8(sp)
    800070a0:	00113c23          	sd	ra,24(sp)
    800070a4:	00813823          	sd	s0,16(sp)
    800070a8:	01213023          	sd	s2,0(sp)
    800070ac:	00058493          	mv	s1,a1
    800070b0:	08058463          	beqz	a1,80007138 <get_user_string+0xa4>
    800070b4:	00060913          	mv	s2,a2
    800070b8:	08c05063          	blez	a2,80007138 <get_user_string+0xa4>
    800070bc:	00050413          	mv	s0,a0
    800070c0:	a15ff0ef          	jal	80006ad4 <myproc>
    800070c4:	02053783          	ld	a5,32(a0)
    800070c8:	00140713          	add	a4,s0,1
    800070cc:	00040513          	mv	a0,s0
    800070d0:	06f47463          	bgeu	s0,a5,80007138 <get_user_string+0xa4>
    800070d4:	06e7e263          	bltu	a5,a4,80007138 <get_user_string+0xa4>
    800070d8:	fff9081b          	addw	a6,s2,-1
    800070dc:	02080a63          	beqz	a6,80007110 <get_user_string+0x7c>
    800070e0:	00048793          	mv	a5,s1
    800070e4:	00000713          	li	a4,0
    800070e8:	00c0006f          	j	800070f4 <get_user_string+0x60>
    800070ec:	0017071b          	addw	a4,a4,1
    800070f0:	00e80c63          	beq	a6,a4,80007108 <get_user_string+0x74>
    800070f4:	00054683          	lbu	a3,0(a0)
    800070f8:	00178793          	add	a5,a5,1
    800070fc:	00150513          	add	a0,a0,1
    80007100:	fed78fa3          	sb	a3,-1(a5)
    80007104:	fe0694e3          	bnez	a3,800070ec <get_user_string+0x58>
    80007108:	03274463          	blt	a4,s2,80007130 <get_user_string+0x9c>
    8000710c:	010484b3          	add	s1,s1,a6
    80007110:	00048023          	sb	zero,0(s1)
    80007114:	00000513          	li	a0,0
    80007118:	01813083          	ld	ra,24(sp)
    8000711c:	01013403          	ld	s0,16(sp)
    80007120:	00813483          	ld	s1,8(sp)
    80007124:	00013903          	ld	s2,0(sp)
    80007128:	02010113          	add	sp,sp,32
    8000712c:	00008067          	ret
    80007130:	00e484b3          	add	s1,s1,a4
    80007134:	fddff06f          	j	80007110 <get_user_string+0x7c>
    80007138:	fff00513          	li	a0,-1
    8000713c:	fddff06f          	j	80007118 <get_user_string+0x84>
    80007140:	fff00513          	li	a0,-1
    80007144:	00008067          	ret

0000000080007148 <sys_open>:
    80007148:	f7010113          	add	sp,sp,-144
    8000714c:	08113423          	sd	ra,136(sp)
    80007150:	08813023          	sd	s0,128(sp)
    80007154:	981ff0ef          	jal	80006ad4 <myproc>
    80007158:	04050a63          	beqz	a0,800071ac <sys_open+0x64>
    8000715c:	03053783          	ld	a5,48(a0)
    80007160:	04078663          	beqz	a5,800071ac <sys_open+0x64>
    80007164:	0507b403          	ld	s0,80(a5)
    80007168:	96dff0ef          	jal	80006ad4 <myproc>
    8000716c:	04050063          	beqz	a0,800071ac <sys_open+0x64>
    80007170:	03053783          	ld	a5,48(a0)
    80007174:	02078c63          	beqz	a5,800071ac <sys_open+0x64>
    80007178:	00040513          	mv	a0,s0
    8000717c:	08000613          	li	a2,128
    80007180:	00010593          	mv	a1,sp
    80007184:	0587b403          	ld	s0,88(a5)
    80007188:	f0dff0ef          	jal	80007094 <get_user_string>
    8000718c:	02054063          	bltz	a0,800071ac <sys_open+0x64>
    80007190:	00147593          	and	a1,s0,1
    80007194:	00010513          	mv	a0,sp
    80007198:	3b8000ef          	jal	80007550 <fs_open>
    8000719c:	08813083          	ld	ra,136(sp)
    800071a0:	08013403          	ld	s0,128(sp)
    800071a4:	09010113          	add	sp,sp,144
    800071a8:	00008067          	ret
    800071ac:	fff00513          	li	a0,-1
    800071b0:	fedff06f          	j	8000719c <sys_open+0x54>

00000000800071b4 <sys_unlink>:
    800071b4:	f7010113          	add	sp,sp,-144
    800071b8:	08113423          	sd	ra,136(sp)
    800071bc:	919ff0ef          	jal	80006ad4 <myproc>
    800071c0:	02050a63          	beqz	a0,800071f4 <sys_unlink+0x40>
    800071c4:	03053783          	ld	a5,48(a0)
    800071c8:	02078663          	beqz	a5,800071f4 <sys_unlink+0x40>
    800071cc:	0507b503          	ld	a0,80(a5)
    800071d0:	08000613          	li	a2,128
    800071d4:	00010593          	mv	a1,sp
    800071d8:	ebdff0ef          	jal	80007094 <get_user_string>
    800071dc:	00054c63          	bltz	a0,800071f4 <sys_unlink+0x40>
    800071e0:	00010513          	mv	a0,sp
    800071e4:	730000ef          	jal	80007914 <fs_unlink>
    800071e8:	08813083          	ld	ra,136(sp)
    800071ec:	09010113          	add	sp,sp,144
    800071f0:	00008067          	ret
    800071f4:	fff00513          	li	a0,-1
    800071f8:	ff1ff06f          	j	800071e8 <sys_unlink+0x34>

00000000800071fc <get_user_buffer>:
    800071fc:	08050263          	beqz	a0,80007280 <get_user_buffer+0x84>
    80007200:	fe010113          	add	sp,sp,-32
    80007204:	00913423          	sd	s1,8(sp)
    80007208:	00113c23          	sd	ra,24(sp)
    8000720c:	00813823          	sd	s0,16(sp)
    80007210:	01213023          	sd	s2,0(sp)
    80007214:	00058493          	mv	s1,a1
    80007218:	06058063          	beqz	a1,80007278 <get_user_buffer+0x7c>
    8000721c:	00060913          	mv	s2,a2
    80007220:	04c05c63          	blez	a2,80007278 <get_user_buffer+0x7c>
    80007224:	00050413          	mv	s0,a0
    80007228:	8adff0ef          	jal	80006ad4 <myproc>
    8000722c:	02053783          	ld	a5,32(a0)
    80007230:	01240633          	add	a2,s0,s2
    80007234:	00040513          	mv	a0,s0
    80007238:	04f47063          	bgeu	s0,a5,80007278 <get_user_buffer+0x7c>
    8000723c:	02c7ee63          	bltu	a5,a2,80007278 <get_user_buffer+0x7c>
    80007240:	02c47c63          	bgeu	s0,a2,80007278 <get_user_buffer+0x7c>
    80007244:	00048593          	mv	a1,s1
    80007248:	00054783          	lbu	a5,0(a0)
    8000724c:	00150513          	add	a0,a0,1
    80007250:	00158593          	add	a1,a1,1
    80007254:	fef58fa3          	sb	a5,-1(a1)
    80007258:	fea618e3          	bne	a2,a0,80007248 <get_user_buffer+0x4c>
    8000725c:	00000513          	li	a0,0
    80007260:	01813083          	ld	ra,24(sp)
    80007264:	01013403          	ld	s0,16(sp)
    80007268:	00813483          	ld	s1,8(sp)
    8000726c:	00013903          	ld	s2,0(sp)
    80007270:	02010113          	add	sp,sp,32
    80007274:	00008067          	ret
    80007278:	fff00513          	li	a0,-1
    8000727c:	fe5ff06f          	j	80007260 <get_user_buffer+0x64>
    80007280:	fff00513          	li	a0,-1
    80007284:	00008067          	ret

0000000080007288 <sys_write>:
    80007288:	ed010113          	add	sp,sp,-304
    8000728c:	12113423          	sd	ra,296(sp)
    80007290:	12813023          	sd	s0,288(sp)
    80007294:	10913c23          	sd	s1,280(sp)
    80007298:	11213823          	sd	s2,272(sp)
    8000729c:	11313423          	sd	s3,264(sp)
    800072a0:	835ff0ef          	jal	80006ad4 <myproc>
    800072a4:	10050663          	beqz	a0,800073b0 <sys_write+0x128>
    800072a8:	03053783          	ld	a5,48(a0)
    800072ac:	10078263          	beqz	a5,800073b0 <sys_write+0x128>
    800072b0:	0507b483          	ld	s1,80(a5)
    800072b4:	821ff0ef          	jal	80006ad4 <myproc>
    800072b8:	0e050c63          	beqz	a0,800073b0 <sys_write+0x128>
    800072bc:	03053783          	ld	a5,48(a0)
    800072c0:	0e078863          	beqz	a5,800073b0 <sys_write+0x128>
    800072c4:	0587b983          	ld	s3,88(a5)
    800072c8:	80dff0ef          	jal	80006ad4 <myproc>
    800072cc:	0e050263          	beqz	a0,800073b0 <sys_write+0x128>
    800072d0:	03053783          	ld	a5,48(a0)
    800072d4:	0c078e63          	beqz	a5,800073b0 <sys_write+0x128>
    800072d8:	0004891b          	sext.w	s2,s1
    800072dc:	0607b403          	ld	s0,96(a5)
    800072e0:	0c094863          	bltz	s2,800073b0 <sys_write+0x128>
    800072e4:	0004041b          	sext.w	s0,s0
    800072e8:	0c044463          	bltz	s0,800073b0 <sys_write+0x128>
    800072ec:	02041263          	bnez	s0,80007310 <sys_write+0x88>
    800072f0:	12813083          	ld	ra,296(sp)
    800072f4:	00040513          	mv	a0,s0
    800072f8:	12013403          	ld	s0,288(sp)
    800072fc:	11813483          	ld	s1,280(sp)
    80007300:	11013903          	ld	s2,272(sp)
    80007304:	10813983          	ld	s3,264(sp)
    80007308:	13010113          	add	sp,sp,304
    8000730c:	00008067          	ret
    80007310:	10000713          	li	a4,256
    80007314:	00040793          	mv	a5,s0
    80007318:	00875463          	bge	a4,s0,80007320 <sys_write+0x98>
    8000731c:	10000793          	li	a5,256
    80007320:	0007841b          	sext.w	s0,a5
    80007324:	00040613          	mv	a2,s0
    80007328:	00010593          	mv	a1,sp
    8000732c:	00098513          	mv	a0,s3
    80007330:	ecdff0ef          	jal	800071fc <get_user_buffer>
    80007334:	06054e63          	bltz	a0,800073b0 <sys_write+0x128>
    80007338:	fff4849b          	addw	s1,s1,-1
    8000733c:	00100793          	li	a5,1
    80007340:	0297fc63          	bgeu	a5,s1,80007378 <sys_write+0xf0>
    80007344:	00040613          	mv	a2,s0
    80007348:	00010593          	mv	a1,sp
    8000734c:	00090513          	mv	a0,s2
    80007350:	4c4000ef          	jal	80007814 <fs_write>
    80007354:	00050413          	mv	s0,a0
    80007358:	12813083          	ld	ra,296(sp)
    8000735c:	00040513          	mv	a0,s0
    80007360:	12013403          	ld	s0,288(sp)
    80007364:	11813483          	ld	s1,280(sp)
    80007368:	11013903          	ld	s2,272(sp)
    8000736c:	10813983          	ld	s3,264(sp)
    80007370:	13010113          	add	sp,sp,304
    80007374:	00008067          	ret
    80007378:	00010493          	mv	s1,sp
    8000737c:	00848933          	add	s2,s1,s0
    80007380:	0004c503          	lbu	a0,0(s1)
    80007384:	00148493          	add	s1,s1,1
    80007388:	839fb0ef          	jal	80002bc0 <uart_putc>
    8000738c:	fe991ae3          	bne	s2,s1,80007380 <sys_write+0xf8>
    80007390:	12813083          	ld	ra,296(sp)
    80007394:	00040513          	mv	a0,s0
    80007398:	12013403          	ld	s0,288(sp)
    8000739c:	11813483          	ld	s1,280(sp)
    800073a0:	11013903          	ld	s2,272(sp)
    800073a4:	10813983          	ld	s3,264(sp)
    800073a8:	13010113          	add	sp,sp,304
    800073ac:	00008067          	ret
    800073b0:	fff00413          	li	s0,-1
    800073b4:	f3dff06f          	j	800072f0 <sys_write+0x68>

00000000800073b8 <check_user_ptr>:
    800073b8:	fe010113          	add	sp,sp,-32
    800073bc:	00813823          	sd	s0,16(sp)
    800073c0:	00913423          	sd	s1,8(sp)
    800073c4:	00050413          	mv	s0,a0
    800073c8:	00058493          	mv	s1,a1
    800073cc:	00113c23          	sd	ra,24(sp)
    800073d0:	f04ff0ef          	jal	80006ad4 <myproc>
    800073d4:	02053783          	ld	a5,32(a0)
    800073d8:	008485b3          	add	a1,s1,s0
    800073dc:	02f47263          	bgeu	s0,a5,80007400 <check_user_ptr+0x48>
    800073e0:	02b7e063          	bltu	a5,a1,80007400 <check_user_ptr+0x48>
    800073e4:	00b43533          	sltu	a0,s0,a1
    800073e8:	fff5051b          	addw	a0,a0,-1
    800073ec:	01813083          	ld	ra,24(sp)
    800073f0:	01013403          	ld	s0,16(sp)
    800073f4:	00813483          	ld	s1,8(sp)
    800073f8:	02010113          	add	sp,sp,32
    800073fc:	00008067          	ret
    80007400:	fff00513          	li	a0,-1
    80007404:	fe9ff06f          	j	800073ec <check_user_ptr+0x34>

0000000080007408 <syscall_dispatch>:
    80007408:	fe010113          	add	sp,sp,-32
    8000740c:	00813823          	sd	s0,16(sp)
    80007410:	00913423          	sd	s1,8(sp)
    80007414:	00113c23          	sd	ra,24(sp)
    80007418:	ebcff0ef          	jal	80006ad4 <myproc>
    8000741c:	03053703          	ld	a4,48(a0)
    80007420:	03f00793          	li	a5,63
    80007424:	00050413          	mv	s0,a0
    80007428:	08872483          	lw	s1,136(a4)
    8000742c:	0697e063          	bltu	a5,s1,8000748c <syscall_dispatch+0x84>
    80007430:	00005517          	auipc	a0,0x5
    80007434:	b5850513          	add	a0,a0,-1192 # 8000bf88 <digits+0xdb0>
    80007438:	fa0fb0ef          	jal	80002bd8 <uart_puts>
    8000743c:	00149793          	sll	a5,s1,0x1
    80007440:	009787b3          	add	a5,a5,s1
    80007444:	00379793          	sll	a5,a5,0x3
    80007448:	00006497          	auipc	s1,0x6
    8000744c:	bb848493          	add	s1,s1,-1096 # 8000d000 <syscall_table>
    80007450:	00f484b3          	add	s1,s1,a5
    80007454:	0084b503          	ld	a0,8(s1)
    80007458:	f80fb0ef          	jal	80002bd8 <uart_puts>
    8000745c:	00002517          	auipc	a0,0x2
    80007460:	48c50513          	add	a0,a0,1164 # 800098e8 <rodata_start+0x18e8>
    80007464:	f74fb0ef          	jal	80002bd8 <uart_puts>
    80007468:	0004b783          	ld	a5,0(s1)
    8000746c:	000780e7          	jalr	a5
    80007470:	03043783          	ld	a5,48(s0)
    80007474:	01813083          	ld	ra,24(sp)
    80007478:	01013403          	ld	s0,16(sp)
    8000747c:	04a7b823          	sd	a0,80(a5)
    80007480:	00813483          	ld	s1,8(sp)
    80007484:	02010113          	add	sp,sp,32
    80007488:	00008067          	ret
    8000748c:	00005517          	auipc	a0,0x5
    80007490:	adc50513          	add	a0,a0,-1316 # 8000bf68 <digits+0xd90>
    80007494:	f44fb0ef          	jal	80002bd8 <uart_puts>
    80007498:	03043783          	ld	a5,48(s0)
    8000749c:	01813083          	ld	ra,24(sp)
    800074a0:	01013403          	ld	s0,16(sp)
    800074a4:	fff00713          	li	a4,-1
    800074a8:	04e7b823          	sd	a4,80(a5)
    800074ac:	00813483          	ld	s1,8(sp)
    800074b0:	02010113          	add	sp,sp,32
    800074b4:	00008067          	ret

00000000800074b8 <find_file>:
    800074b8:	00050313          	mv	t1,a0
    800074bc:	0041f597          	auipc	a1,0x41f
    800074c0:	1e458593          	add	a1,a1,484 # 804266a0 <files>
    800074c4:	00000513          	li	a0,0
    800074c8:	04030813          	add	a6,t1,64 # fffffffffffff040 <bss_end+0xffffffff7fbd7348>
    800074cc:	04000893          	li	a7,64
    800074d0:	0100006f          	j	800074e0 <find_file+0x28>
    800074d4:	0015051b          	addw	a0,a0,1
    800074d8:	05858593          	add	a1,a1,88
    800074dc:	03150e63          	beq	a0,a7,80007518 <find_file+0x60>
    800074e0:	0505a783          	lw	a5,80(a1)
    800074e4:	fe0788e3          	beqz	a5,800074d4 <find_file+0x1c>
    800074e8:	00030793          	mv	a5,t1
    800074ec:	00058713          	mv	a4,a1
    800074f0:	0080006f          	j	800074f8 <find_file+0x40>
    800074f4:	03078063          	beq	a5,a6,80007514 <find_file+0x5c>
    800074f8:	00074683          	lbu	a3,0(a4)
    800074fc:	0007c603          	lbu	a2,0(a5)
    80007500:	00170713          	add	a4,a4,1
    80007504:	00178793          	add	a5,a5,1
    80007508:	fcc696e3          	bne	a3,a2,800074d4 <find_file+0x1c>
    8000750c:	fe0694e3          	bnez	a3,800074f4 <find_file+0x3c>
    80007510:	00008067          	ret
    80007514:	00008067          	ret
    80007518:	fff00513          	li	a0,-1
    8000751c:	00008067          	ret

0000000080007520 <fs_init>:
    80007520:	0041f797          	auipc	a5,0x41f
    80007524:	1d078793          	add	a5,a5,464 # 804266f0 <files+0x50>
    80007528:	0041f717          	auipc	a4,0x41f
    8000752c:	e7870713          	add	a4,a4,-392 # 804263a0 <fds>
    80007530:	00420697          	auipc	a3,0x420
    80007534:	7c068693          	add	a3,a3,1984 # 80427cf0 <current_proc>
    80007538:	0007a023          	sw	zero,0(a5)
    8000753c:	00072023          	sw	zero,0(a4)
    80007540:	05878793          	add	a5,a5,88
    80007544:	00c70713          	add	a4,a4,12
    80007548:	fed798e3          	bne	a5,a3,80007538 <fs_init+0x18>
    8000754c:	00008067          	ret

0000000080007550 <fs_open>:
    80007550:	fe010113          	add	sp,sp,-32
    80007554:	00813823          	sd	s0,16(sp)
    80007558:	00913423          	sd	s1,8(sp)
    8000755c:	01213023          	sd	s2,0(sp)
    80007560:	00113c23          	sd	ra,24(sp)
    80007564:	00050413          	mv	s0,a0
    80007568:	00058913          	mv	s2,a1
    8000756c:	f4dff0ef          	jal	800074b8 <find_file>
    80007570:	00050493          	mv	s1,a0
    80007574:	06054463          	bltz	a0,800075dc <fs_open+0x8c>
    80007578:	0041f617          	auipc	a2,0x41f
    8000757c:	e2860613          	add	a2,a2,-472 # 804263a0 <fds>
    80007580:	00060793          	mv	a5,a2
    80007584:	00000513          	li	a0,0
    80007588:	04000693          	li	a3,64
    8000758c:	00c0006f          	j	80007598 <fs_open+0x48>
    80007590:	0015051b          	addw	a0,a0,1
    80007594:	04d50663          	beq	a0,a3,800075e0 <fs_open+0x90>
    80007598:	0007a703          	lw	a4,0(a5)
    8000759c:	00c78793          	add	a5,a5,12
    800075a0:	fe0718e3          	bnez	a4,80007590 <fs_open+0x40>
    800075a4:	00151793          	sll	a5,a0,0x1
    800075a8:	00a787b3          	add	a5,a5,a0
    800075ac:	01813083          	ld	ra,24(sp)
    800075b0:	01013403          	ld	s0,16(sp)
    800075b4:	00279793          	sll	a5,a5,0x2
    800075b8:	00f607b3          	add	a5,a2,a5
    800075bc:	00100713          	li	a4,1
    800075c0:	0097a223          	sw	s1,4(a5)
    800075c4:	00e7a023          	sw	a4,0(a5)
    800075c8:	0007a423          	sw	zero,8(a5)
    800075cc:	00813483          	ld	s1,8(sp)
    800075d0:	00013903          	ld	s2,0(sp)
    800075d4:	02010113          	add	sp,sp,32
    800075d8:	00008067          	ret
    800075dc:	02091063          	bnez	s2,800075fc <fs_open+0xac>
    800075e0:	fff00513          	li	a0,-1
    800075e4:	01813083          	ld	ra,24(sp)
    800075e8:	01013403          	ld	s0,16(sp)
    800075ec:	00813483          	ld	s1,8(sp)
    800075f0:	00013903          	ld	s2,0(sp)
    800075f4:	02010113          	add	sp,sp,32
    800075f8:	00008067          	ret
    800075fc:	0041f797          	auipc	a5,0x41f
    80007600:	0f478793          	add	a5,a5,244 # 804266f0 <files+0x50>
    80007604:	00000493          	li	s1,0
    80007608:	04000693          	li	a3,64
    8000760c:	00c0006f          	j	80007618 <fs_open+0xc8>
    80007610:	0014849b          	addw	s1,s1,1
    80007614:	fcd486e3          	beq	s1,a3,800075e0 <fs_open+0x90>
    80007618:	0007a703          	lw	a4,0(a5)
    8000761c:	05878793          	add	a5,a5,88
    80007620:	fe0718e3          	bnez	a4,80007610 <fs_open+0xc0>
    80007624:	05800713          	li	a4,88
    80007628:	02e48733          	mul	a4,s1,a4
    8000762c:	00040793          	mv	a5,s0
    80007630:	0041f417          	auipc	s0,0x41f
    80007634:	07040413          	add	s0,s0,112 # 804266a0 <files>
    80007638:	04078613          	add	a2,a5,64
    8000763c:	00e40733          	add	a4,s0,a4
    80007640:	0080006f          	j	80007648 <fs_open+0xf8>
    80007644:	00c78c63          	beq	a5,a2,8000765c <fs_open+0x10c>
    80007648:	0007c683          	lbu	a3,0(a5)
    8000764c:	00170713          	add	a4,a4,1
    80007650:	00178793          	add	a5,a5,1
    80007654:	fed70fa3          	sb	a3,-1(a4)
    80007658:	fe0696e3          	bnez	a3,80007644 <fs_open+0xf4>
    8000765c:	05800913          	li	s2,88
    80007660:	03248933          	mul	s2,s1,s2
    80007664:	0041f797          	auipc	a5,0x41f
    80007668:	08478793          	add	a5,a5,132 # 804266e8 <files+0x48>
    8000766c:	00100713          	li	a4,1
    80007670:	02c71713          	sll	a4,a4,0x2c
    80007674:	00f907b3          	add	a5,s2,a5
    80007678:	00e7b023          	sd	a4,0(a5)
    8000767c:	e08fb0ef          	jal	80002c84 <alloc_page>
    80007680:	00001737          	lui	a4,0x1
    80007684:	00050793          	mv	a5,a0
    80007688:	00e50733          	add	a4,a0,a4
    8000768c:	02050663          	beqz	a0,800076b8 <fs_open+0x168>
    80007690:	00078023          	sb	zero,0(a5)
    80007694:	00178793          	add	a5,a5,1
    80007698:	fef71ce3          	bne	a4,a5,80007690 <fs_open+0x140>
    8000769c:	05800793          	li	a5,88
    800076a0:	02f487b3          	mul	a5,s1,a5
    800076a4:	00f40433          	add	s0,s0,a5
    800076a8:	00100793          	li	a5,1
    800076ac:	04a43023          	sd	a0,64(s0)
    800076b0:	04f42823          	sw	a5,80(s0)
    800076b4:	ec5ff06f          	j	80007578 <fs_open+0x28>
    800076b8:	01240433          	add	s0,s0,s2
    800076bc:	04043023          	sd	zero,64(s0)
    800076c0:	fff00513          	li	a0,-1
    800076c4:	f21ff06f          	j	800075e4 <fs_open+0x94>

00000000800076c8 <fs_close>:
    800076c8:	03f00793          	li	a5,63
    800076cc:	02a7e863          	bltu	a5,a0,800076fc <fs_close+0x34>
    800076d0:	00151793          	sll	a5,a0,0x1
    800076d4:	00a787b3          	add	a5,a5,a0
    800076d8:	0041f717          	auipc	a4,0x41f
    800076dc:	cc870713          	add	a4,a4,-824 # 804263a0 <fds>
    800076e0:	00279793          	sll	a5,a5,0x2
    800076e4:	00f707b3          	add	a5,a4,a5
    800076e8:	0007a703          	lw	a4,0(a5)
    800076ec:	00070863          	beqz	a4,800076fc <fs_close+0x34>
    800076f0:	0007a023          	sw	zero,0(a5)
    800076f4:	00000513          	li	a0,0
    800076f8:	00008067          	ret
    800076fc:	fff00513          	li	a0,-1
    80007700:	00008067          	ret

0000000080007704 <fs_read>:
    80007704:	03f00793          	li	a5,63
    80007708:	00050893          	mv	a7,a0
    8000770c:	0ea7ec63          	bltu	a5,a0,80007804 <fs_read+0x100>
    80007710:	00151e13          	sll	t3,a0,0x1
    80007714:	00ae07b3          	add	a5,t3,a0
    80007718:	0041fe97          	auipc	t4,0x41f
    8000771c:	c88e8e93          	add	t4,t4,-888 # 804263a0 <fds>
    80007720:	00279793          	sll	a5,a5,0x2
    80007724:	00fe87b3          	add	a5,t4,a5
    80007728:	0007a703          	lw	a4,0(a5)
    8000772c:	0c070c63          	beqz	a4,80007804 <fs_read+0x100>
    80007730:	0047a683          	lw	a3,4(a5)
    80007734:	05800713          	li	a4,88
    80007738:	0041f817          	auipc	a6,0x41f
    8000773c:	f6880813          	add	a6,a6,-152 # 804266a0 <files>
    80007740:	02e68733          	mul	a4,a3,a4
    80007744:	00e80733          	add	a4,a6,a4
    80007748:	05072503          	lw	a0,80(a4)
    8000774c:	0a050c63          	beqz	a0,80007804 <fs_read+0x100>
    80007750:	0087a783          	lw	a5,8(a5)
    80007754:	04872703          	lw	a4,72(a4)
    80007758:	00000513          	li	a0,0
    8000775c:	0ae7f663          	bgeu	a5,a4,80007808 <fs_read+0x104>
    80007760:	40f7053b          	subw	a0,a4,a5
    80007764:	00050713          	mv	a4,a0
    80007768:	0aa64263          	blt	a2,a0,8000780c <fs_read+0x108>
    8000776c:	0007051b          	sext.w	a0,a4
    80007770:	06050e63          	beqz	a0,800077ec <fs_read+0xe8>
    80007774:	05800713          	li	a4,88
    80007778:	02e686b3          	mul	a3,a3,a4
    8000777c:	02079793          	sll	a5,a5,0x20
    80007780:	0207d793          	srl	a5,a5,0x20
    80007784:	011e0333          	add	t1,t3,a7
    80007788:	00231313          	sll	t1,t1,0x2
    8000778c:	00100713          	li	a4,1
    80007790:	006e8333          	add	t1,t4,t1
    80007794:	00d80833          	add	a6,a6,a3
    80007798:	04083683          	ld	a3,64(a6)
    8000779c:	00f687b3          	add	a5,a3,a5
    800077a0:	0007c783          	lbu	a5,0(a5)
    800077a4:	00f58023          	sb	a5,0(a1)
    800077a8:	02e50a63          	beq	a0,a4,800077dc <fs_read+0xd8>
    800077ac:	00832783          	lw	a5,8(t1)
    800077b0:	04083683          	ld	a3,64(a6)
    800077b4:	00e58633          	add	a2,a1,a4
    800077b8:	00e787bb          	addw	a5,a5,a4
    800077bc:	02079793          	sll	a5,a5,0x20
    800077c0:	0207d793          	srl	a5,a5,0x20
    800077c4:	00f687b3          	add	a5,a3,a5
    800077c8:	0007c683          	lbu	a3,0(a5)
    800077cc:	00170713          	add	a4,a4,1
    800077d0:	0007079b          	sext.w	a5,a4
    800077d4:	00d60023          	sb	a3,0(a2)
    800077d8:	fca7eae3          	bltu	a5,a0,800077ac <fs_read+0xa8>
    800077dc:	011e07b3          	add	a5,t3,a7
    800077e0:	00279793          	sll	a5,a5,0x2
    800077e4:	00fe87b3          	add	a5,t4,a5
    800077e8:	0087a783          	lw	a5,8(a5)
    800077ec:	011e0e33          	add	t3,t3,a7
    800077f0:	002e1e13          	sll	t3,t3,0x2
    800077f4:	01ce8eb3          	add	t4,t4,t3
    800077f8:	00f507bb          	addw	a5,a0,a5
    800077fc:	00fea423          	sw	a5,8(t4)
    80007800:	00008067          	ret
    80007804:	fff00513          	li	a0,-1
    80007808:	00008067          	ret
    8000780c:	00060713          	mv	a4,a2
    80007810:	f5dff06f          	j	8000776c <fs_read+0x68>

0000000080007814 <fs_write>:
    80007814:	03f00793          	li	a5,63
    80007818:	00050f13          	mv	t5,a0
    8000781c:	0ea7e863          	bltu	a5,a0,8000790c <fs_write+0xf8>
    80007820:	00151513          	sll	a0,a0,0x1
    80007824:	01e50833          	add	a6,a0,t5
    80007828:	0041fe17          	auipc	t3,0x41f
    8000782c:	b78e0e13          	add	t3,t3,-1160 # 804263a0 <fds>
    80007830:	00281813          	sll	a6,a6,0x2
    80007834:	010e0833          	add	a6,t3,a6
    80007838:	00082783          	lw	a5,0(a6)
    8000783c:	0c078863          	beqz	a5,8000790c <fs_write+0xf8>
    80007840:	00482f83          	lw	t6,4(a6)
    80007844:	05800893          	li	a7,88
    80007848:	0041fe97          	auipc	t4,0x41f
    8000784c:	e58e8e93          	add	t4,t4,-424 # 804266a0 <files>
    80007850:	031f88b3          	mul	a7,t6,a7
    80007854:	011e88b3          	add	a7,t4,a7
    80007858:	0508a783          	lw	a5,80(a7)
    8000785c:	0a078863          	beqz	a5,8000790c <fs_write+0xf8>
    80007860:	00882303          	lw	t1,8(a6)
    80007864:	04c8a703          	lw	a4,76(a7)
    80007868:	0006029b          	sext.w	t0,a2
    8000786c:	00c307bb          	addw	a5,t1,a2
    80007870:	08f76e63          	bltu	a4,a5,8000790c <fs_write+0xf8>
    80007874:	06c05463          	blez	a2,800078dc <fs_write+0xc8>
    80007878:	0408b783          	ld	a5,64(a7)
    8000787c:	0005c703          	lbu	a4,0(a1)
    80007880:	02031313          	sll	t1,t1,0x20
    80007884:	02035313          	srl	t1,t1,0x20
    80007888:	006787b3          	add	a5,a5,t1
    8000788c:	00e78023          	sb	a4,0(a5)
    80007890:	00100713          	li	a4,1
    80007894:	02e60a63          	beq	a2,a4,800078c8 <fs_write+0xb4>
    80007898:	00882783          	lw	a5,8(a6)
    8000789c:	0408b683          	ld	a3,64(a7)
    800078a0:	00e58333          	add	t1,a1,a4
    800078a4:	00e787bb          	addw	a5,a5,a4
    800078a8:	00034303          	lbu	t1,0(t1)
    800078ac:	02079793          	sll	a5,a5,0x20
    800078b0:	0207d793          	srl	a5,a5,0x20
    800078b4:	00f687b3          	add	a5,a3,a5
    800078b8:	00170713          	add	a4,a4,1
    800078bc:	00678023          	sb	t1,0(a5)
    800078c0:	0007079b          	sext.w	a5,a4
    800078c4:	fcc7cae3          	blt	a5,a2,80007898 <fs_write+0x84>
    800078c8:	01e507b3          	add	a5,a0,t5
    800078cc:	00279793          	sll	a5,a5,0x2
    800078d0:	00fe07b3          	add	a5,t3,a5
    800078d4:	0087a783          	lw	a5,8(a5)
    800078d8:	005787bb          	addw	a5,a5,t0
    800078dc:	05800713          	li	a4,88
    800078e0:	02ef86b3          	mul	a3,t6,a4
    800078e4:	01e50533          	add	a0,a0,t5
    800078e8:	00251513          	sll	a0,a0,0x2
    800078ec:	00ae0733          	add	a4,t3,a0
    800078f0:	00f72423          	sw	a5,8(a4)
    800078f4:	00de8733          	add	a4,t4,a3
    800078f8:	04872683          	lw	a3,72(a4)
    800078fc:	00f6f463          	bgeu	a3,a5,80007904 <fs_write+0xf0>
    80007900:	04f72423          	sw	a5,72(a4)
    80007904:	00060513          	mv	a0,a2
    80007908:	00008067          	ret
    8000790c:	fff00513          	li	a0,-1
    80007910:	00008067          	ret

0000000080007914 <fs_unlink>:
    80007914:	ff010113          	add	sp,sp,-16
    80007918:	00113423          	sd	ra,8(sp)
    8000791c:	b9dff0ef          	jal	800074b8 <find_file>
    80007920:	02054a63          	bltz	a0,80007954 <fs_unlink+0x40>
    80007924:	05800793          	li	a5,88
    80007928:	02f507b3          	mul	a5,a0,a5
    8000792c:	0041f717          	auipc	a4,0x41f
    80007930:	d7470713          	add	a4,a4,-652 # 804266a0 <files>
    80007934:	00000513          	li	a0,0
    80007938:	00f707b3          	add	a5,a4,a5
    8000793c:	0407a823          	sw	zero,80(a5)
    80007940:	0407a423          	sw	zero,72(a5)
    80007944:	00078023          	sb	zero,0(a5)
    80007948:	00813083          	ld	ra,8(sp)
    8000794c:	01010113          	add	sp,sp,16
    80007950:	00008067          	ret
    80007954:	fff00513          	li	a0,-1
    80007958:	ff1ff06f          	j	80007948 <fs_unlink+0x34>
    8000795c:	0000                	.2byte	0x0
	...

0000000080007960 <trapret>:
    80007960:	00058293          	mv	t0,a1
    80007964:	18029073          	csrw	satp,t0
    80007968:	12000073          	sfence.vma
    8000796c:	10200073          	sret
    80007970:	0000                	.2byte	0x0
	...
