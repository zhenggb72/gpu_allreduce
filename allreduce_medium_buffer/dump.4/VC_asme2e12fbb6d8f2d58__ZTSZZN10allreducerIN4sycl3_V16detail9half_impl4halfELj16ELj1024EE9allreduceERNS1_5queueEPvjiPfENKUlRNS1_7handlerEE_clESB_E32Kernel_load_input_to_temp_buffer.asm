//.kernel _ZTSZZN10allreducerIN4sycl3_V16detail9half_impl4halfELj16ELj1024EE9allreduceERNS1_5queueEPvjiPfENKUlRNS1_7handlerEE_clESB_E32Kernel_load_input_to_temp_buffer
//.platform PVCXT
//.thread_config numGRF=128, numAcc=4, numSWSB=16
//.options_string "-enableHalfLSC -dumpcommonisa -output -binary -abiver 2 "
//.full_options "-abiver 2 -output -binary -dumpcommonisa -enableHalfLSC "
//.instCount 614
//.RA type	HYBRID_RA
//.git-hash 29084021c0fef93003a60e7818a898bae752fd9f

//.declare BuiltInR0 (0)  rf=r size=64 type=ud align=32 words (r0.0) IsBuiltin
//.declare  (1)  rf=r size=64 type=ud alias=BuiltInR0+0 align=32 words (r0.0) IsBuiltin
//.declare BuiltinA0 (2)  rf=a size=4 type=ud align=1 words (a0.0) IsBuiltin
//.declare BuiltinA0Dot2 (3)  rf=a size=4 type=ud align=1 words (a0.2) IsBuiltin
//.declare %null (9)  rf=r size=4 type=ud align=2 words
//.declare %local_id_x (12)  rf=r size=4 type=ud align=2 words (r2.8)
//.declare %local_id_y (13)  rf=r size=4 type=ud align=2 words (r2.9)
//.declare %local_size_x (14)  rf=r size=4 type=ud align=2 words (r2.4)
//.declare %local_size_y (15)  rf=r size=4 type=ud align=2 words (r2.5)
//.declare %group_id_x (16)  rf=r size=4 type=ud align=2 words (r0.1)
//.declare %group_id_y (17)  rf=r size=4 type=ud align=2 words (r0.6)
//.declare %group_id_z (18)  rf=r size=4 type=ud align=2 words (r0.7)
//.declare %group_count_x (19)  rf=r size=4 type=ud align=2 words (r2.6)
//.declare %group_count_y (20)  rf=r size=4 type=ud align=2 words (r2.7)
//.declare %tsc (21)  rf=r size=20 type=ud align=2 words
//.declare %arg (22)  rf=r size=0 type=ud align=32 words (r26.0)
//.declare %retval (23)  rf=r size=0 type=ud align=32 words (r26.0) Output
//.declare %sp (24)  rf=r size=8 type=uq align=4 words (r127.3)
//.declare %fp (25)  rf=r size=8 type=uq align=4 words (r127.2)
//.declare %sr0 (26)  rf=r size=16 type=ud align=2 words
//.declare %cr0 (27)  rf=r size=12 type=ud align=2 words
//.declare %ce0 (28)  rf=r size=4 type=ud align=2 words
//.declare %dbg0 (29)  rf=r size=8 type=ud align=2 words
//.declare implBufPtr (31)  rf=r size=8 type=uq align=4 words (r126.0)
//.declare localIdBufPtr (32)  rf=r size=8 type=uq align=4 words (r126.3)
//.declare %msg0 (33)  rf=r size=12 type=ud align=2 words
//.declare V32 (38)  rf=r size=4 type=d align=2 words (r2.6)
//.declare V33 (39)  rf=r size=4 type=d align=2 words (r2.7)
//.declare V34 (40)  rf=r size=4 type=d align=2 words (r2.8)
//.declare V35 (41)  rf=r size=8 type=uq align=4 words (r2.5)
//.declare V36 (42)  rf=r size=4 type=d align=2 words (r2.12)
//.declare V37 (43)  rf=r size=4 type=d align=2 words (r2.13)
//.declare V39 (45)  rf=r size=4 type=d align=2 words (r6.0)
//.declare V40 (46)  rf=r size=4 type=d align=2 words (r6.1)
//.declare V41 (47)  rf=r size=4 type=d align=2 words (r6.2)
//.declare V42 (48)  rf=r size=4 type=d align=2 words (r6.3)
//.declare V43 (49)  rf=r size=6 type=w align=1 words (r1.0)
//.declare V44 (50)  rf=r size=12 type=d align=2 words (r2.0)
//.declare V45 (51)  rf=r size=8 type=q align=4 words (r2.2)
//.declare V46 (52)  rf=r size=8 type=uq align=4 words (r4.1)
//.declare V47 (53)  rf=r size=8 type=uq align=4 words (r4.2)
//.declare V48 (54)  rf=r size=8 type=uq align=4 words (r4.3)
//.declare V49 (55)  rf=r size=8 type=uq align=4 words (r4.4)
//.declare V50 (56)  rf=r size=8 type=uq align=4 words (r4.5)
//.declare V51 (57)  rf=r size=8 type=uq align=4 words (r4.6)
//.declare V52 (58)  rf=r size=8 type=uq align=4 words (r4.7)
//.declare V53 (59)  rf=r size=8 type=uq align=4 words (r5.1)
//.declare V54 (60)  rf=r size=8 type=uq align=4 words (r5.2)
//.declare V55 (61)  rf=r size=8 type=uq align=4 words (r5.3)
//.declare V56 (62)  rf=r size=8 type=uq align=4 words (r5.4)
//.declare V57 (63)  rf=r size=8 type=uq align=4 words (r5.5)
//.declare V58 (64)  rf=r size=8 type=uq align=4 words (r5.6)
//.declare V59 (65)  rf=r size=8 type=uq align=4 words (r5.7)
//.declare V60 (66)  rf=r size=4 type=d align=2 words (r1.3)
//.declare V61 (67)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V62 (68)  rf=r size=4 type=d align=2 words (r2.3)
//.declare V65 (71)  rf=r size=8 type=q align=32 words (r36.0)
//.declare V67 (73)  rf=r size=8 type=q align=32 words (r110.0)
//.declare V68 (74)  rf=r size=8 type=q align=32 words (r38.0)
//.declare V69 (75)  rf=r size=8 type=uq align=32 words (r4.0)
//.declare V70 (76)  rf=r size=8 type=q align=32 words (r40.0)
//.declare V71 (77)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V72 (78)  rf=r size=8 type=q align=32 words (r42.0)
//.declare V73 (79)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V74 (80)  rf=r size=8 type=q align=32 words (r44.0)
//.declare V75 (81)  rf=r size=8 type=q align=32 words (r12.0)
//.declare V76 (82)  rf=r size=8 type=q align=32 words (r46.0)
//.declare V77 (83)  rf=r size=8 type=q align=32 words (r14.0)
//.declare V78 (84)  rf=r size=8 type=q align=32 words (r48.0)
//.declare V79 (85)  rf=r size=8 type=q align=32 words (r16.0)
//.declare V80 (86)  rf=r size=8 type=q align=32 words (r50.0)
//.declare V81 (87)  rf=r size=8 type=q align=32 words (r18.0)
//.declare V82 (88)  rf=r size=8 type=q align=32 words (r52.0)
//.declare V83 (89)  rf=r size=8 type=q align=32 words (r20.0)
//.declare V84 (90)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V85 (91)  rf=r size=8 type=uq align=32 words (r5.0)
//.declare V86 (92)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V87 (93)  rf=r size=8 type=q align=32 words (r22.0)
//.declare V88 (94)  rf=r size=8 type=q align=32 words (r12.0)
//.declare V89 (95)  rf=r size=8 type=q align=32 words (r24.0)
//.declare V90 (96)  rf=r size=8 type=q align=32 words (r14.0)
//.declare V91 (97)  rf=r size=8 type=q align=32 words (r26.0)
//.declare V92 (98)  rf=r size=8 type=q align=32 words (r16.0)
//.declare V93 (99)  rf=r size=8 type=q align=32 words (r28.0)
//.declare V94 (100)  rf=r size=8 type=q align=32 words (r18.0)
//.declare V95 (101)  rf=r size=8 type=q align=32 words (r30.0)
//.declare V96 (102)  rf=r size=8 type=q align=32 words (r20.0)
//.declare V97 (103)  rf=r size=8 type=q align=32 words (r32.0)
//.declare V98 (104)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V99 (105)  rf=r size=8 type=q align=32 words (r34.0)
//.declare V100 (106)  rf=r size=4 type=d align=2 words (r4.2)
//.declare V101 (107)  rf=r size=8 type=q align=4 words (r1.1)
//.declare V102 (108)  rf=r size=8 type=q align=32 words (r4.0)
//.declare V103 (109)  rf=r size=4 type=d align=32 words (r123.0)
//.declare P1 (110)  rf=f1  size=2 type=uw align=1 words (f0.1)
//.declare V104 (111)  rf=r size=4 type=d align=2 words (r4.5)
//.declare V105 (112)  rf=r size=4 type=d align=2 words (r4.4)
//.declare V106 (113)  rf=r size=4 type=d align=2 words (r4.3)
//.declare V107 (114)  rf=r size=8 type=d align=4 words (r4.6)
//.declare V108 (115)  rf=r size=8 type=d align=4 words (r4.8)
//.declare V109 (116)  rf=r size=4 type=d align=32 words (r5.0)
//.declare V110 (117)  rf=r size=4 type=d align=2 words (r4.15)
//.declare V111 (118)  rf=r size=4 type=d align=2 words (r4.14)
//.declare V112 (119)  rf=r size=4 type=d align=2 words (r4.13)
//.declare V113 (120)  rf=r size=4 type=d align=2 words (r4.12)
//.declare V114 (121)  rf=r size=8 type=q align=4 words (r4.5)
//.declare V115 (122)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V116 (123)  rf=r size=8 type=q align=4 words (r5.6)
//.declare V117 (124)  rf=r size=4 type=d align=2 words (r2.3)
//.declare V118 (125)  rf=r size=8 type=q align=4 words (r5.5)
//.declare V119 (126)  rf=r size=4 type=d align=2 words (r3.0)
//.declare V120 (127)  rf=r size=8 type=q align=4 words (r5.4)
//.declare V121 (128)  rf=r size=4 type=d align=2 words (r6.1)
//.declare V122 (129)  rf=r size=8 type=q align=4 words (r5.3)
//.declare V123 (130)  rf=r size=4 type=d align=2 words (r7.0)
//.declare V124 (131)  rf=r size=8 type=q align=4 words (r5.2)
//.declare V125 (132)  rf=r size=128 type=d align=32 words (r8.0)
//.declare V126 (133)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V127 (134)  rf=r size=8 type=d align=4 words (r5.2)
//.declare P2 (135)  rf=f1  size=2 type=uw align=1 words (f1.0)
//.declare P3 (136)  rf=f1  size=2 type=uw align=1 words (f0.0)
//.declare P4 (137)  rf=f1  size=2 type=uw align=1 words (f3.1)
//.declare P5 (138)  rf=f1  size=2 type=uw align=1 words (f0.0)
//.declare P6 (139)  rf=f1  size=2 type=uw align=1 words (f0.0)
//.declare P7 (140)  rf=f1  size=2 type=uw align=1 words (f3.1)
//.declare P8 (141)  rf=f1  size=2 type=uw align=1 words (f3.0)
//.declare P9 (142)  rf=f1  size=2 type=uw align=1 words (f2.1)
//.declare P10 (143)  rf=f1  size=2 type=uw align=1 words (f2.0)
//.declare V128 (144)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V129 (145)  rf=r size=4 type=d align=2 words (r1.2)
//.declare P11 (146)  rf=f1  size=2 type=uw align=1 words (f1.1)
//.declare V130 (147)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V131 (148)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V132 (149)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V133 (150)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V134 (151)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V135 (152)  rf=r size=8 type=q align=32 words (r11.0)
//.declare V136 (153)  rf=r size=8 type=q align=32 words (r12.0)
//.declare V137 (154)  rf=r size=8 type=q align=32 words (r13.0)
//.declare V138 (155)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V139 (156)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V140 (157)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V141 (158)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V142 (159)  rf=r size=8 type=q align=32 words (r11.0)
//.declare V143 (160)  rf=r size=8 type=q align=32 words (r12.0)
//.declare V144 (161)  rf=r size=8 type=q align=32 words (r13.0)
//.declare V145 (162)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V146 (163)  rf=r size=8 type=q align=4 words (r5.3)
//.declare P12 (164)  rf=f1  size=2 type=uw align=1 words (f0.1)
//.declare V147 (165)  rf=r size=8 type=q align=4 words (r5.4)
//.declare V148 (166)  rf=r size=8 type=q align=4 words (r1.2)
//.declare V149 (167)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V150 (168)  rf=r size=256 type=hf align=32 words (r7.0)
//.declare V151 (169)  rf=r size=8 type=w align=4 words (r1.4)
//.declare V152 (170)  rf=r size=2 type=w align=1 words (r2.6)
//.declare A0 (171)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare P13 (172)  rf=f1  size=2 type=uw align=1 words (f3.0)
//.declare P14 (173)  rf=f1  size=2 type=uw align=1 words (f2.1)
//.declare P15 (174)  rf=f1  size=2 type=uw align=1 words (f3.1)
//.declare V153 (175)  rf=r size=4096 type=hf align=32 words (r14.0)
//.declare V154 (176)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V155 (177)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V156 (178)  rf=r size=8 type=q align=4 words (r2.7)
//.declare V157 (179)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V158 (180)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V159 (181)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V160 (182)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V161 (183)  rf=r size=8 type=q align=32 words (r11.0)
//.declare V162 (184)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V163 (185)  rf=r size=8 type=q align=32 words (r12.0)
//.declare V164 (186)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V165 (187)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V166 (188)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V167 (189)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V168 (190)  rf=r size=8 type=q align=32 words (r11.0)
//.declare V169 (191)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V170 (192)  rf=r size=8 type=q align=32 words (r12.0)
//.declare P16 (193)  rf=f1  size=2 type=uw align=1 words (f1.0)
//.declare V171 (194)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V172 (195)  rf=r size=4 type=d align=2 words (r1.2)
//.declare P17 (196)  rf=f1  size=2 type=uw align=1 words (f0.1)
//.declare V173 (197)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V174 (198)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V175 (199)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V176 (200)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V177 (201)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V178 (202)  rf=r size=8 type=q align=32 words (r11.0)
//.declare V179 (203)  rf=r size=8 type=q align=32 words (r12.0)
//.declare V180 (204)  rf=r size=8 type=q align=32 words (r13.0)
//.declare V181 (205)  rf=r size=8 type=q align=4 words (r5.2)
//.declare P18 (206)  rf=f1  size=2 type=uw align=1 words (f0.0)
//.declare V182 (207)  rf=r size=8 type=q align=4 words (r5.4)
//.declare V183 (208)  rf=r size=8 type=q align=4 words (r1.2)
//.declare V184 (209)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V185 (210)  rf=r size=256 type=hf align=32 words (r7.0)
//.declare V186 (211)  rf=r size=8 type=w align=4 words (r1.4)
//.declare V187 (212)  rf=r size=2 type=w align=1 words (r2.6)
//.declare A1 (213)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare P19 (214)  rf=f1  size=2 type=uw align=1 words (f2.0)
//.declare P20 (215)  rf=f1  size=2 type=uw align=1 words (f1.1)
//.declare P21 (216)  rf=f1  size=2 type=uw align=1 words (f3.0)
//.declare V188 (217)  rf=r size=2048 type=hf align=32 words (r78.0)
//.declare V189 (218)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V190 (219)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V191 (220)  rf=r size=8 type=q align=4 words (r2.7)
//.declare V192 (221)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V193 (222)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V194 (223)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V195 (224)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V196 (225)  rf=r size=8 type=q align=32 words (r11.0)
//.declare V197 (226)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V198 (227)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V199 (228)  rf=r size=4 type=d align=2 words (r1.2)
//.declare P22 (229)  rf=f1  size=2 type=uw align=1 words (f3.1)
//.declare V200 (230)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V201 (231)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V202 (232)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V203 (233)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V204 (234)  rf=r size=8 type=q align=32 words (r10.0)
//.declare V205 (235)  rf=r size=8 type=q align=32 words (r11.0)
//.declare V206 (236)  rf=r size=8 type=q align=4 words (r5.2)
//.declare P23 (237)  rf=f1  size=2 type=uw align=1 words (f3.0)
//.declare V207 (238)  rf=r size=8 type=q align=4 words (r5.3)
//.declare V208 (239)  rf=r size=8 type=q align=4 words (r1.2)
//.declare V209 (240)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V210 (241)  rf=r size=256 type=hf align=32 words (r7.0)
//.declare V211 (242)  rf=r size=8 type=w align=4 words (r1.4)
//.declare V212 (243)  rf=r size=2 type=w align=1 words (r2.6)
//.declare A2 (244)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare P24 (245)  rf=f1  size=2 type=uw align=1 words (f1.0)
//.declare P25 (246)  rf=f1  size=2 type=uw align=1 words (f0.1)
//.declare P26 (247)  rf=f1  size=2 type=uw align=1 words (f2.1)
//.declare V213 (248)  rf=r size=1536 type=hf align=32 words (r12.0)
//.declare V214 (249)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V215 (250)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V216 (251)  rf=r size=8 type=q align=4 words (r2.7)
//.declare V217 (252)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V218 (253)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V219 (254)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V220 (255)  rf=r size=8 type=q align=32 words (r10.0)
//.declare P27 (256)  rf=f1  size=2 type=uw align=1 words (f2.1)
//.declare P28 (257)  rf=f1  size=2 type=uw align=1 words (f2.0)
//.declare V221 (258)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V222 (259)  rf=r size=4 type=d align=2 words (r1.2)
//.declare P29 (260)  rf=f1  size=2 type=uw align=1 words (f1.1)
//.declare V223 (261)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V224 (262)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V225 (263)  rf=r size=8 type=q align=4 words (r5.2)
//.declare P30 (264)  rf=f1  size=2 type=uw align=1 words (f1.0)
//.declare V226 (265)  rf=r size=8 type=q align=4 words (r5.3)
//.declare V227 (266)  rf=r size=8 type=q align=4 words (r1.2)
//.declare V228 (267)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V229 (268)  rf=r size=256 type=hf align=32 words (r7.0)
//.declare V230 (269)  rf=r size=8 type=w align=4 words (r1.4)
//.declare V231 (270)  rf=r size=2 type=w align=1 words (r2.6)
//.declare A3 (271)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare P31 (272)  rf=f1  size=2 type=uw align=1 words (f0.0)
//.declare P32 (273)  rf=f1  size=2 type=uw align=1 words (f3.1)
//.declare P33 (274)  rf=f1  size=2 type=uw align=1 words (f2.0)
//.declare V232 (275)  rf=r size=512 type=hf align=32 words (r115.0)
//.declare V233 (276)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V234 (277)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V235 (278)  rf=r size=8 type=q align=4 words (r2.7)
//.declare V236 (279)  rf=r size=4 type=d align=2 words (r2.0)
//.declare V237 (280)  rf=r size=4 type=d align=2 words (r1.2)
//.declare P34 (281)  rf=f1  size=2 type=uw align=1 words (f0.1)
//.declare V238 (282)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V239 (283)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V240 (284)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V241 (285)  rf=r size=8 type=q align=32 words (r9.0)
//.declare V242 (286)  rf=r size=8 type=q align=4 words (r5.2)
//.declare P35 (287)  rf=f1  size=2 type=uw align=1 words (f0.0)
//.declare V243 (288)  rf=r size=8 type=q align=4 words (r5.3)
//.declare V244 (289)  rf=r size=8 type=q align=4 words (r1.2)
//.declare V245 (290)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V246 (291)  rf=r size=256 type=hf align=32 words (r7.0)
//.declare V247 (292)  rf=r size=8 type=w align=4 words (r1.4)
//.declare V248 (293)  rf=r size=2 type=w align=1 words (r2.6)
//.declare A4 (294)  rf=a size=2 type=uw align=1 words (a0.0)
//.declare P36 (295)  rf=f1  size=2 type=uw align=1 words (f3.0)
//.declare P37 (296)  rf=f1  size=2 type=uw align=1 words (f2.1)
//.declare P38 (297)  rf=f1  size=2 type=uw align=1 words (f1.1)
//.declare V249 (298)  rf=r size=1024 type=hf align=32 words (r36.0)
//.declare V250 (299)  rf=r size=8 type=q align=32 words (r8.0)
//.declare V251 (300)  rf=r size=4 type=d align=2 words (r1.2)
//.declare V252 (301)  rf=r size=8 type=q align=4 words (r2.7)
//.declare V253 (302)  rf=r size=8 type=q align=32 words (r3.0)
//.declare V254 (303)  rf=r size=8 type=q align=32 words (r7.0)
//.declare V255 (304)  rf=r size=8 type=uq align=32 words (r2.0)
//.declare V256 (305)  rf=r size=256 type=hf align=32 words (r111.0)
//.declare P39 (306)  rf=f1  size=2 type=uw align=1 words (f2.0)
//.declare P40 (307)  rf=f1  size=2 type=uw align=1 words (f1.1)
//.declare P41 (308)  rf=f1  size=2 type=uw align=1 words (f1.0)
//.declare V257 (309)  rf=r size=8 type=uq alias=V67+0 align=4 words (r110.0)
//.declare V258 (310)  rf=r size=8 type=uq alias=V71+0 align=4 words (r8.0)
//.declare V259 (311)  rf=r size=8 type=uq alias=V73+0 align=4 words (r10.0)
//.declare V260 (312)  rf=r size=8 type=uq alias=V75+0 align=4 words (r12.0)
//.declare V261 (313)  rf=r size=8 type=uq alias=V77+0 align=4 words (r14.0)
//.declare V262 (314)  rf=r size=8 type=uq alias=V79+0 align=4 words (r16.0)
//.declare V263 (315)  rf=r size=8 type=uq alias=V81+0 align=4 words (r18.0)
//.declare V264 (316)  rf=r size=8 type=uq alias=V83+0 align=4 words (r20.0)
//.declare V265 (317)  rf=r size=8 type=uq alias=V87+0 align=4 words (r22.0)
//.declare V266 (318)  rf=r size=8 type=uq alias=V89+0 align=4 words (r24.0)
//.declare V267 (319)  rf=r size=8 type=uq alias=V91+0 align=4 words (r26.0)
//.declare V268 (320)  rf=r size=8 type=uq alias=V93+0 align=4 words (r28.0)
//.declare V269 (321)  rf=r size=8 type=uq alias=V95+0 align=4 words (r30.0)
//.declare V270 (322)  rf=r size=8 type=uq alias=V97+0 align=4 words (r32.0)
//.declare V271 (323)  rf=r size=8 type=uq alias=V99+0 align=4 words (r34.0)
//.declare V272 (324)  rf=r size=4 type=ud alias=V61+0 align=2 words (r1.2)
//.declare V273 (325)  rf=r size=16 type=ud alias=%sr0+0 align=2 words
//.declare V274 (326)  rf=r size=4 type=ud alias=V60+0 align=2 words (r1.3)
//.declare V275 (327)  rf=r size=4 type=ud alias=V62+0 align=2 words (r2.3)
//.declare V276 (328)  rf=r size=4 type=d alias=V62+0 align=2 words (r2.3)
//.declare V277 (329)  rf=r size=8 type=q alias=%sp+0 align=4 words (r127.3)
//.declare V278 (330)  rf=r size=8 type=q alias=V45+0 align=4 words (r2.2)
//.declare V279 (331)  rf=r size=8 type=q alias=%fp+0 align=4 words (r127.2)
//.declare V280 (332)  rf=r size=8 type=q alias=%sp+0 align=4 words (r127.3)
//.declare V281 (333)  rf=r size=8 type=q alias=%sp+0 align=4 words (r127.3)
//.declare V282 (334)  rf=r size=8 type=q alias=%sp+0 align=4 words (r127.3)
//.declare V283 (335)  rf=r size=8 type=q alias=V65+0 align=4 words (r36.0)
//.declare V284 (336)  rf=r size=8 type=uq alias=V65+0 align=4 words (r36.0)
//.declare V285 (337)  rf=r size=8 type=uq alias=V68+0 align=4 words (r38.0)
//.declare V286 (338)  rf=r size=8 type=q alias=V69+0 align=4 words (r4.0)
//.declare V287 (339)  rf=r size=8 type=uq alias=V70+0 align=4 words (r40.0)
//.declare V288 (340)  rf=r size=8 type=uq alias=V72+0 align=4 words (r42.0)
//.declare V289 (341)  rf=r size=8 type=uq alias=V74+0 align=4 words (r44.0)
//.declare V290 (342)  rf=r size=8 type=uq alias=V76+0 align=4 words (r46.0)
//.declare V291 (343)  rf=r size=8 type=uq alias=V78+0 align=4 words (r48.0)
//.declare V292 (344)  rf=r size=8 type=uq alias=V80+0 align=4 words (r50.0)
//.declare V293 (345)  rf=r size=8 type=uq alias=V82+0 align=4 words (r52.0)
//.declare V294 (346)  rf=r size=8 type=uq alias=V84+0 align=4 words (r8.0)
//.declare V295 (347)  rf=r size=8 type=q alias=V85+0 align=4 words (r5.0)
//.declare V296 (348)  rf=r size=8 type=uq alias=V86+0 align=4 words (r10.0)
//.declare V297 (349)  rf=r size=8 type=uq alias=V88+0 align=4 words (r12.0)
//.declare V298 (350)  rf=r size=8 type=uq alias=V90+0 align=4 words (r14.0)
//.declare V299 (351)  rf=r size=8 type=uq alias=V92+0 align=4 words (r16.0)
//.declare V300 (352)  rf=r size=8 type=uq alias=V94+0 align=4 words (r18.0)
//.declare V301 (353)  rf=r size=8 type=uq alias=V96+0 align=4 words (r20.0)
//.declare V302 (354)  rf=r size=8 type=uq alias=V98+0 align=4 words (r8.0)
//.declare V303 (355)  rf=r size=4 type=d alias=V109+0 align=2 words (r5.0)
//.declare V304 (356)  rf=r size=12 type=d alias=V44+0 align=2 words (r2.0)
//.declare V305 (357)  rf=r size=4 type=d alias=V100+0 align=2 words (r4.2)
//.declare V306 (358)  rf=r size=6 type=uw alias=V43+0 align=1 words (r1.0)
//.declare V307 (359)  rf=r size=4 type=ud alias=V39+0 align=2 words (r6.0)
//.declare V308 (360)  rf=r size=8 type=q alias=V101+0 align=4 words (r1.1)
//.declare V309 (361)  rf=r size=8 type=q alias=V102+0 align=4 words (r4.0)
//.declare V310 (362)  rf=r size=8 type=q alias=V68+0 align=4 words (r38.0)
//.declare V311 (363)  rf=r size=4 type=d alias=V103+0 align=2 words (r123.0)
//.declare V312 (364)  rf=r size=4 type=d alias=V42+0 align=2 words (r6.3)
//.declare V313 (365)  rf=r size=4 type=d alias=V41+0 align=2 words (r6.2)
//.declare V314 (366)  rf=r size=4 type=d alias=V32+0 align=2 words (r2.6)
//.declare V315 (367)  rf=r size=4 type=d alias=V104+0 align=2 words (r4.5)
//.declare V316 (368)  rf=r size=4 type=d alias=V34+0 align=2 words (r2.8)
//.declare V317 (369)  rf=r size=4 type=ud alias=V105+0 align=2 words (r4.4)
//.declare V318 (370)  rf=r size=4 type=ud alias=V104+0 align=2 words (r4.5)
//.declare V319 (371)  rf=r size=4 type=d alias=V106+0 align=2 words (r4.3)
//.declare V320 (372)  rf=r size=4 type=d alias=V36+0 align=2 words (r2.12)
//.declare V321 (373)  rf=r size=8 type=q alias=V107+0 align=4 words (r4.3)
//.declare V322 (374)  rf=r size=4 type=ud alias=V33+0 align=2 words (r2.7)
//.declare V323 (375)  rf=r size=8 type=q alias=V108+0 align=4 words (r4.4)
//.declare V324 (376)  rf=r size=4 type=ud alias=V32+0 align=2 words (r2.6)
//.declare V325 (377)  rf=r size=4 type=d alias=V113+0 align=2 words (r4.12)
//.declare V326 (378)  rf=r size=4 type=d alias=V112+0 align=2 words (r4.13)
//.declare V327 (379)  rf=r size=4 type=d alias=V111+0 align=2 words (r4.14)
//.declare V328 (380)  rf=r size=4 type=d alias=V110+0 align=2 words (r4.15)
//.declare V329 (381)  rf=r size=4 type=ud alias=V115+0 align=2 words (r1.2)
//.declare V330 (382)  rf=r size=4 type=ud alias=V109+0 align=2 words (r5.0)
//.declare V331 (383)  rf=r size=4 type=ud alias=V117+0 align=2 words (r2.3)
//.declare V332 (384)  rf=r size=4 type=ud alias=V110+0 align=2 words (r4.15)
//.declare V333 (385)  rf=r size=4 type=ud alias=V119+0 align=2 words (r3.0)
//.declare V334 (386)  rf=r size=4 type=ud alias=V111+0 align=2 words (r4.14)
//.declare V335 (387)  rf=r size=4 type=ud alias=V121+0 align=2 words (r6.1)
//.declare V336 (388)  rf=r size=4 type=ud alias=V112+0 align=2 words (r4.13)
//.declare V337 (389)  rf=r size=4 type=ud alias=V123+0 align=2 words (r7.0)
//.declare V338 (390)  rf=r size=4 type=ud alias=V113+0 align=2 words (r4.12)
//.declare V339 (391)  rf=r size=128 type=ud alias=V125+0 align=32 words (r8.0)
//.declare V340 (392)  rf=r size=8 type=ud alias=V114+0 align=2 words (r4.10)
//.declare V341 (393)  rf=r size=4 type=d alias=V126+0 align=2 words (r1.2)
//.declare V342 (394)  rf=r size=8 type=d alias=V114+0 align=2 words (r4.10)
//.declare V343 (395)  rf=r size=8 type=d alias=V127+0 align=2 words (r5.2)
//.declare V344 (396)  rf=r size=128 type=d alias=V125+0 align=32 words (r8.0)
//.declare V345 (397)  rf=r size=8 type=q alias=V127+0 align=4 words (r5.1)
//.declare V346 (398)  rf=r size=4 type=ud alias=V100+0 align=2 words (r4.2)
//.declare V347 (399)  rf=r size=8 type=ud alias=V127+0 align=2 words (r5.2)
//.declare V348 (400)  rf=r size=8 type=ud alias=V107+0 align=2 words (r4.6)
//.declare V349 (401)  rf=r size=8 type=d alias=V107+0 align=2 words (r4.6)
//.declare V350 (402)  rf=r size=4 type=d alias=V105+0 align=2 words (r4.4)
//.declare V351 (403)  rf=r size=4 type=d alias=V128+0 align=2 words (r2.0)
//.declare V352 (404)  rf=r size=4 type=d alias=V37+0 align=2 words (r2.13)
//.declare V353 (405)  rf=r size=4 type=d alias=V129+0 align=2 words (r1.2)
//.declare V354 (406)  rf=r size=4 type=ud alias=V128+0 align=2 words (r2.0)
//.declare V355 (407)  rf=r size=4 type=ud alias=V129+0 align=2 words (r1.2)
//.declare V356 (408)  rf=r size=4 type=ud alias=V36+0 align=2 words (r2.12)
//.declare V357 (409)  rf=r size=8 type=q alias=V146+0 align=4 words (r5.3)
//.declare V358 (410)  rf=r size=8 type=q alias=V130+0 align=4 words (r3.0)
//.declare V359 (411)  rf=r size=8 type=q alias=V67+0 align=4 words (r110.0)
//.declare V360 (412)  rf=r size=4096 type=d alias=V153+0 align=32 words (r14.0)
//.declare V361 (413)  rf=r size=8 type=uq alias=V130+0 align=4 words (r3.0)
//.declare V362 (414)  rf=r size=8 type=uq alias=V131+0 align=4 words (r7.0)
//.declare V363 (415)  rf=r size=8 type=uq alias=V132+0 align=4 words (r8.0)
//.declare V364 (416)  rf=r size=8 type=uq alias=V133+0 align=4 words (r9.0)
//.declare V365 (417)  rf=r size=8 type=uq alias=V134+0 align=4 words (r10.0)
//.declare V366 (418)  rf=r size=8 type=uq alias=V135+0 align=4 words (r11.0)
//.declare V367 (419)  rf=r size=8 type=uq alias=V136+0 align=4 words (r12.0)
//.declare V368 (420)  rf=r size=8 type=uq alias=V137+0 align=4 words (r13.0)
//.declare V369 (421)  rf=r size=8 type=uq alias=V138+0 align=4 words (r7.0)
//.declare V370 (422)  rf=r size=8 type=uq alias=V139+0 align=4 words (r8.0)
//.declare V371 (423)  rf=r size=8 type=uq alias=V140+0 align=4 words (r9.0)
//.declare V372 (424)  rf=r size=8 type=uq alias=V141+0 align=4 words (r10.0)
//.declare V373 (425)  rf=r size=8 type=uq alias=V142+0 align=4 words (r11.0)
//.declare V374 (426)  rf=r size=8 type=uq alias=V143+0 align=4 words (r12.0)
//.declare V375 (427)  rf=r size=8 type=uq alias=V144+0 align=4 words (r13.0)
//.declare V376 (428)  rf=r size=8 type=uq alias=V145+0 align=4 words (r7.0)
//.declare V377 (429)  rf=r size=8 type=q alias=V151+0 align=4 words (r1.1)
//.declare V378 (430)  rf=r size=8 type=q alias=V147+0 align=4 words (r5.4)
//.declare V379 (431)  rf=r size=8 type=q alias=V148+0 align=4 words (r1.2)
//.declare V380 (432)  rf=r size=8 type=q alias=V149+0 align=4 words (r3.0)
//.declare V381 (433)  rf=r size=256 type=d alias=V150+0 align=32 words (r7.0)
//.declare V382 (434)  rf=r size=8 type=uq alias=V149+0 align=4 words (r3.0)
//.declare V383 (435)  rf=r size=2 type=w alias=V152+0 align=1 words (r2.6)
//.declare V384 (436)  rf=r size=8 type=w alias=V151+0 align=1 words (r1.4)
//.declare V385 (437)  rf=r size=2 type=uw alias=V152+0 align=1 words (r2.6)
//.declare V386 (438)  rf=r size=8 type=d alias=V147+0 align=2 words (r5.8)
//.declare V387 (439)  rf=r size=8 type=d alias=V124+0 align=2 words (r5.4)
//.declare V388 (440)  rf=r size=8 type=uq alias=V102+0 align=4 words (r4.0)
//.declare V389 (441)  rf=r size=4 type=d alias=V155+0 align=2 words (r1.2)
//.declare V390 (442)  rf=r size=4 type=ud alias=V155+0 align=2 words (r1.2)
//.declare V391 (443)  rf=r size=8 type=q alias=V156+0 align=4 words (r2.7)
//.declare V392 (444)  rf=r size=8 type=q alias=V255+0 align=4 words (r2.0)
//.declare V393 (445)  rf=r size=8 type=q alias=V154+0 align=4 words (r8.0)
//.declare V394 (446)  rf=r size=8 type=uq alias=V255+0 align=4 words (r2.0)
//.declare V395 (447)  rf=r size=8 type=uq alias=V157+0 align=4 words (r3.0)
//.declare V396 (448)  rf=r size=8 type=uq alias=V158+0 align=4 words (r7.0)
//.declare V397 (449)  rf=r size=8 type=uq alias=V159+0 align=4 words (r9.0)
//.declare V398 (450)  rf=r size=8 type=uq alias=V160+0 align=4 words (r10.0)
//.declare V399 (451)  rf=r size=8 type=uq alias=V161+0 align=4 words (r11.0)
//.declare V400 (452)  rf=r size=8 type=uq alias=V162+0 align=4 words (r8.0)
//.declare V401 (453)  rf=r size=8 type=uq alias=V163+0 align=4 words (r12.0)
//.declare V402 (454)  rf=r size=8 type=uq alias=V164+0 align=4 words (r3.0)
//.declare V403 (455)  rf=r size=8 type=uq alias=V165+0 align=4 words (r7.0)
//.declare V404 (456)  rf=r size=8 type=uq alias=V166+0 align=4 words (r9.0)
//.declare V405 (457)  rf=r size=8 type=uq alias=V167+0 align=4 words (r10.0)
//.declare V406 (458)  rf=r size=8 type=uq alias=V168+0 align=4 words (r11.0)
//.declare V407 (459)  rf=r size=8 type=uq alias=V169+0 align=4 words (r8.0)
//.declare V408 (460)  rf=r size=8 type=uq alias=V170+0 align=4 words (r12.0)
//.declare V409 (461)  rf=r size=4 type=d alias=V171+0 align=2 words (r2.0)
//.declare V410 (462)  rf=r size=4 type=d alias=V172+0 align=2 words (r1.2)
//.declare V411 (463)  rf=r size=4 type=ud alias=V171+0 align=2 words (r2.0)
//.declare V412 (464)  rf=r size=4 type=ud alias=V172+0 align=2 words (r1.2)
//.declare V413 (465)  rf=r size=8 type=q alias=V181+0 align=4 words (r5.2)
//.declare V414 (466)  rf=r size=8 type=q alias=V173+0 align=4 words (r3.0)
//.declare V415 (467)  rf=r size=2048 type=d alias=V188+0 align=32 words (r78.0)
//.declare V416 (468)  rf=r size=8 type=uq alias=V173+0 align=4 words (r3.0)
//.declare V417 (469)  rf=r size=8 type=uq alias=V174+0 align=4 words (r7.0)
//.declare V418 (470)  rf=r size=8 type=uq alias=V175+0 align=4 words (r8.0)
//.declare V419 (471)  rf=r size=8 type=uq alias=V176+0 align=4 words (r9.0)
//.declare V420 (472)  rf=r size=8 type=uq alias=V177+0 align=4 words (r10.0)
//.declare V421 (473)  rf=r size=8 type=uq alias=V178+0 align=4 words (r11.0)
//.declare V422 (474)  rf=r size=8 type=uq alias=V179+0 align=4 words (r12.0)
//.declare V423 (475)  rf=r size=8 type=uq alias=V180+0 align=4 words (r13.0)
//.declare V424 (476)  rf=r size=8 type=q alias=V186+0 align=4 words (r1.1)
//.declare V425 (477)  rf=r size=8 type=q alias=V182+0 align=4 words (r5.4)
//.declare V426 (478)  rf=r size=8 type=q alias=V183+0 align=4 words (r1.2)
//.declare V427 (479)  rf=r size=8 type=q alias=V184+0 align=4 words (r3.0)
//.declare V428 (480)  rf=r size=256 type=d alias=V185+0 align=32 words (r7.0)
//.declare V429 (481)  rf=r size=8 type=uq alias=V184+0 align=4 words (r3.0)
//.declare V430 (482)  rf=r size=2 type=w alias=V187+0 align=1 words (r2.6)
//.declare V431 (483)  rf=r size=8 type=w alias=V186+0 align=1 words (r1.4)
//.declare V432 (484)  rf=r size=2 type=uw alias=V187+0 align=1 words (r2.6)
//.declare V433 (485)  rf=r size=8 type=d alias=V182+0 align=2 words (r5.8)
//.declare V434 (486)  rf=r size=8 type=d alias=V122+0 align=2 words (r5.6)
//.declare V435 (487)  rf=r size=4 type=d alias=V190+0 align=2 words (r1.2)
//.declare V436 (488)  rf=r size=4 type=ud alias=V190+0 align=2 words (r1.2)
//.declare V437 (489)  rf=r size=8 type=q alias=V191+0 align=4 words (r2.7)
//.declare V438 (490)  rf=r size=8 type=q alias=V189+0 align=4 words (r8.0)
//.declare V439 (491)  rf=r size=8 type=uq alias=V192+0 align=4 words (r3.0)
//.declare V440 (492)  rf=r size=8 type=uq alias=V193+0 align=4 words (r7.0)
//.declare V441 (493)  rf=r size=8 type=uq alias=V194+0 align=4 words (r9.0)
//.declare V442 (494)  rf=r size=8 type=uq alias=V195+0 align=4 words (r10.0)
//.declare V443 (495)  rf=r size=8 type=uq alias=V196+0 align=4 words (r11.0)
//.declare V444 (496)  rf=r size=8 type=uq alias=V197+0 align=4 words (r8.0)
//.declare V445 (497)  rf=r size=4 type=d alias=V198+0 align=2 words (r2.0)
//.declare V446 (498)  rf=r size=4 type=d alias=V199+0 align=2 words (r1.2)
//.declare V447 (499)  rf=r size=4 type=ud alias=V198+0 align=2 words (r2.0)
//.declare V448 (500)  rf=r size=4 type=ud alias=V199+0 align=2 words (r1.2)
//.declare V449 (501)  rf=r size=8 type=q alias=V206+0 align=4 words (r5.2)
//.declare V450 (502)  rf=r size=8 type=q alias=V200+0 align=4 words (r3.0)
//.declare V451 (503)  rf=r size=1536 type=d alias=V213+0 align=32 words (r12.0)
//.declare V452 (504)  rf=r size=8 type=uq alias=V200+0 align=4 words (r3.0)
//.declare V453 (505)  rf=r size=8 type=uq alias=V201+0 align=4 words (r7.0)
//.declare V454 (506)  rf=r size=8 type=uq alias=V202+0 align=4 words (r8.0)
//.declare V455 (507)  rf=r size=8 type=uq alias=V203+0 align=4 words (r9.0)
//.declare V456 (508)  rf=r size=8 type=uq alias=V204+0 align=4 words (r10.0)
//.declare V457 (509)  rf=r size=8 type=uq alias=V205+0 align=4 words (r11.0)
//.declare V458 (510)  rf=r size=8 type=q alias=V211+0 align=4 words (r1.1)
//.declare V459 (511)  rf=r size=8 type=q alias=V207+0 align=4 words (r5.3)
//.declare V460 (512)  rf=r size=8 type=q alias=V208+0 align=4 words (r1.2)
//.declare V461 (513)  rf=r size=8 type=q alias=V209+0 align=4 words (r3.0)
//.declare V462 (514)  rf=r size=256 type=d alias=V210+0 align=32 words (r7.0)
//.declare V463 (515)  rf=r size=8 type=uq alias=V209+0 align=4 words (r3.0)
//.declare V464 (516)  rf=r size=2 type=w alias=V212+0 align=1 words (r2.6)
//.declare V465 (517)  rf=r size=8 type=w alias=V211+0 align=1 words (r1.4)
//.declare V466 (518)  rf=r size=2 type=uw alias=V212+0 align=1 words (r2.6)
//.declare V467 (519)  rf=r size=8 type=d alias=V207+0 align=2 words (r5.6)
//.declare V468 (520)  rf=r size=8 type=d alias=V120+0 align=2 words (r5.8)
//.declare V469 (521)  rf=r size=4 type=d alias=V215+0 align=2 words (r1.2)
//.declare V470 (522)  rf=r size=4 type=ud alias=V215+0 align=2 words (r1.2)
//.declare V471 (523)  rf=r size=8 type=q alias=V216+0 align=4 words (r2.7)
//.declare V472 (524)  rf=r size=8 type=q alias=V214+0 align=4 words (r8.0)
//.declare V473 (525)  rf=r size=8 type=uq alias=V217+0 align=4 words (r3.0)
//.declare V474 (526)  rf=r size=8 type=uq alias=V218+0 align=4 words (r7.0)
//.declare V475 (527)  rf=r size=8 type=uq alias=V219+0 align=4 words (r9.0)
//.declare V476 (528)  rf=r size=8 type=uq alias=V220+0 align=4 words (r10.0)
//.declare V477 (529)  rf=r size=4 type=d alias=V221+0 align=2 words (r2.0)
//.declare V478 (530)  rf=r size=4 type=d alias=V222+0 align=2 words (r1.2)
//.declare V479 (531)  rf=r size=4 type=ud alias=V221+0 align=2 words (r2.0)
//.declare V480 (532)  rf=r size=4 type=ud alias=V222+0 align=2 words (r1.2)
//.declare V481 (533)  rf=r size=8 type=q alias=V225+0 align=4 words (r5.2)
//.declare V482 (534)  rf=r size=8 type=q alias=V223+0 align=4 words (r3.0)
//.declare V483 (535)  rf=r size=512 type=d alias=V232+0 align=32 words (r115.0)
//.declare V484 (536)  rf=r size=8 type=uq alias=V223+0 align=4 words (r3.0)
//.declare V485 (537)  rf=r size=8 type=uq alias=V224+0 align=4 words (r7.0)
//.declare V486 (538)  rf=r size=8 type=q alias=V230+0 align=4 words (r1.1)
//.declare V487 (539)  rf=r size=8 type=q alias=V226+0 align=4 words (r5.3)
//.declare V488 (540)  rf=r size=8 type=q alias=V227+0 align=4 words (r1.2)
//.declare V489 (541)  rf=r size=8 type=q alias=V228+0 align=4 words (r3.0)
//.declare V490 (542)  rf=r size=256 type=d alias=V229+0 align=32 words (r7.0)
//.declare V491 (543)  rf=r size=8 type=uq alias=V228+0 align=4 words (r3.0)
//.declare V492 (544)  rf=r size=2 type=w alias=V231+0 align=1 words (r2.6)
//.declare V493 (545)  rf=r size=8 type=w alias=V230+0 align=1 words (r1.4)
//.declare V494 (546)  rf=r size=2 type=uw alias=V231+0 align=1 words (r2.6)
//.declare V495 (547)  rf=r size=8 type=d alias=V226+0 align=2 words (r5.6)
//.declare V496 (548)  rf=r size=8 type=d alias=V116+0 align=2 words (r5.12)
//.declare V497 (549)  rf=r size=4 type=d alias=V234+0 align=2 words (r1.2)
//.declare V498 (550)  rf=r size=4 type=ud alias=V234+0 align=2 words (r1.2)
//.declare V499 (551)  rf=r size=8 type=q alias=V235+0 align=4 words (r2.7)
//.declare V500 (552)  rf=r size=8 type=q alias=V233+0 align=4 words (r8.0)
//.declare V501 (553)  rf=r size=4 type=d alias=V236+0 align=2 words (r2.0)
//.declare V502 (554)  rf=r size=4 type=d alias=V237+0 align=2 words (r1.2)
//.declare V503 (555)  rf=r size=4 type=ud alias=V236+0 align=2 words (r2.0)
//.declare V504 (556)  rf=r size=4 type=ud alias=V237+0 align=2 words (r1.2)
//.declare V505 (557)  rf=r size=8 type=q alias=V242+0 align=4 words (r5.2)
//.declare V506 (558)  rf=r size=8 type=q alias=V238+0 align=4 words (r3.0)
//.declare V507 (559)  rf=r size=1024 type=d alias=V249+0 align=32 words (r36.0)
//.declare V508 (560)  rf=r size=8 type=uq alias=V238+0 align=4 words (r3.0)
//.declare V509 (561)  rf=r size=8 type=uq alias=V239+0 align=4 words (r7.0)
//.declare V510 (562)  rf=r size=8 type=uq alias=V240+0 align=4 words (r8.0)
//.declare V511 (563)  rf=r size=8 type=uq alias=V241+0 align=4 words (r9.0)
//.declare V512 (564)  rf=r size=8 type=q alias=V247+0 align=4 words (r1.1)
//.declare V513 (565)  rf=r size=8 type=q alias=V243+0 align=4 words (r5.3)
//.declare V514 (566)  rf=r size=8 type=q alias=V244+0 align=4 words (r1.2)
//.declare V515 (567)  rf=r size=8 type=q alias=V245+0 align=4 words (r3.0)
//.declare V516 (568)  rf=r size=256 type=d alias=V246+0 align=32 words (r7.0)
//.declare V517 (569)  rf=r size=8 type=uq alias=V245+0 align=4 words (r3.0)
//.declare V518 (570)  rf=r size=2 type=w alias=V248+0 align=1 words (r2.6)
//.declare V519 (571)  rf=r size=8 type=w alias=V247+0 align=1 words (r1.4)
//.declare V520 (572)  rf=r size=2 type=uw alias=V248+0 align=1 words (r2.6)
//.declare V521 (573)  rf=r size=8 type=d alias=V243+0 align=2 words (r5.6)
//.declare V522 (574)  rf=r size=8 type=d alias=V118+0 align=2 words (r5.10)
//.declare V523 (575)  rf=r size=4 type=d alias=V251+0 align=2 words (r1.2)
//.declare V524 (576)  rf=r size=4 type=ud alias=V251+0 align=2 words (r1.2)
//.declare V525 (577)  rf=r size=8 type=q alias=V252+0 align=4 words (r2.7)
//.declare V526 (578)  rf=r size=8 type=q alias=V250+0 align=4 words (r8.0)
//.declare V527 (579)  rf=r size=8 type=uq alias=V253+0 align=4 words (r3.0)
//.declare V528 (580)  rf=r size=8 type=uq alias=V254+0 align=4 words (r7.0)
//.declare V529 (581)  rf=r size=256 type=d alias=V256+0 align=32 words (r111.0)
//.declare V530 (582)  rf=r size=8 type=q alias=V114+0 align=4 words (r4.5)
//.declare V531 (583)  rf=r size=8 type=d alias=V108+0 align=2 words (r4.8)
//.declare  (584)  rf=r size=64 type=ud align=32 words (r127.0)
//.declare  (585)  rf=r size=2 type=uw align=1 words (r2.7)
//.declare  (586)  rf=r size=2 type=uw align=1 words (r3.0)
//.declare  (587)  rf=r size=4 type=ud align=2 words (r1.4)
//.declare  (588)  rf=r size=4 type=ud align=2 words (r2.9)
//.declare  (589)  rf=r size=2 type=uw align=1 words (r2.6)
//.declare  (591)  rf=r size=64 type=d align=32 words (r1.0)
//.declare  (592)  rf=r size=64 type=d align=32 words (r2.0)
//.declare  (593)  rf=r size=64 type=d align=32 words (r3.0)
//.declare  (594)  rf=r size=64 type=d align=32 words (r6.0)
//.declare  (595)  rf=r size=64 type=d align=32 words (r7.0)
//.declare  (596)  rf=r size=64 type=d align=32 words (r8.0)
//.declare  (597)  rf=r size=64 type=d align=32 words (r9.0)
//.declare  (598)  rf=r size=64 type=d align=32 words (r10.0)
//.declare  (599)  rf=r size=64 type=d align=32 words (r11.0)
//.declare  (600)  rf=r size=64 type=d align=32 words (r12.0)
//.declare  (601)  rf=r size=64 type=d align=32 words (r13.0)
//.declare  (602)  rf=r size=64 type=d align=32 words (r14.0)
//.declare  (603)  rf=r size=64 type=d align=32 words (r16.0)
//.declare  (604)  rf=r size=64 type=d align=32 words (r18.0)
//.declare  (605)  rf=r size=64 type=d align=32 words (r20.0)
//.declare  (606)  rf=r size=64 type=d align=32 words (r22.0)
//.declare  (607)  rf=r size=64 type=d align=32 words (r24.0)
//.declare  (608)  rf=r size=64 type=d align=32 words (r26.0)
//.declare  (609)  rf=r size=64 type=d align=32 words (r28.0)
//.declare  (610)  rf=r size=64 type=d align=32 words (r30.0)
//.declare  (611)  rf=r size=64 type=d align=32 words (r32.0)
//.declare  (612)  rf=r size=64 type=d align=32 words (r34.0)
//.declare  (613)  rf=r size=64 type=d align=32 words (r36.0)
//.declare  (614)  rf=r size=64 type=d align=32 words (r38.0)
//.declare  (615)  rf=r size=64 type=d align=32 words (r40.0)
//.declare  (616)  rf=r size=64 type=d align=32 words (r42.0)
//.declare  (617)  rf=r size=64 type=d align=32 words (r44.0)
//.declare  (618)  rf=r size=64 type=d align=32 words (r46.0)
//.declare  (619)  rf=r size=64 type=d align=32 words (r48.0)
//.declare  (620)  rf=r size=64 type=d align=32 words (r50.0)
//.declare  (621)  rf=r size=64 type=d align=32 words (r52.0)
//.declare r0 (622)  rf=r size=64 type=ud align=32 words (r0.0)
//.declare rtmp (623)  rf=r size=64 type=ud align=32 words (r127.0)
//.declare  (624)  rf=r size=64 type=ud align=32 words (r1.0)
//.declare  (625)  rf=r size=256 type=ud align=32 words (r2.0)
//.declare  (626)  rf=r size=4 type=ud align=2 words (r126.0)
//.declare  (627)  rf=r size=32 type=ud align=2 words (r6.0)

// .inputs
// +----------+----------+--------+----------+------------------+
// | id       | type     |  bytes | at       | from             |
// +----------+----------+--------+----------+------------------+
// | V43      | :w x 3   |    0x6 | r1       | pti[tid]+0x0     |
// | V44      | :d x 3   |    0xC | r2       | cti+0x0          |
// | V45      | :q       |    0x8 | r2+0x10  | cti+0x10         |
// | V32      | :d       |    0x4 | r2+0x18  | cti+0x18         |
// | V33      | :d       |    0x4 | r2+0x1C  | cti+0x1C         |
// | V34      | :d       |    0x4 | r2+0x20  | cti+0x20         |
// | V35      | :uq      |    0x8 | r2+0x28  | cti+0x28         |
// | V36      | :d       |    0x4 | r2+0x30  | cti+0x30         |
// | V37      | :d       |    0x4 | r2+0x34  | cti+0x34         |
// | V69      | :uq      |    0x8 | r4       | cti+0x80         |
// | V46      | :uq      |    0x8 | r4+0x8   | cti+0x88         |
// | V47      | :uq      |    0x8 | r4+0x10  | cti+0x90         |
// | V48      | :uq      |    0x8 | r4+0x18  | cti+0x98         |
// | V49      | :uq      |    0x8 | r4+0x20  | cti+0xA0         |
// | V50      | :uq      |    0x8 | r4+0x28  | cti+0xA8         |
// | V51      | :uq      |    0x8 | r4+0x30  | cti+0xB0         |
// | V52      | :uq      |    0x8 | r4+0x38  | cti+0xB8         |
// | V85      | :uq      |    0x8 | r5       | cti+0xC0         |
// | V53      | :uq      |    0x8 | r5+0x8   | cti+0xC8         |
// | V54      | :uq      |    0x8 | r5+0x10  | cti+0xD0         |
// | V55      | :uq      |    0x8 | r5+0x18  | cti+0xD8         |
// | V56      | :uq      |    0x8 | r5+0x20  | cti+0xE0         |
// | V57      | :uq      |    0x8 | r5+0x28  | cti+0xE8         |
// | V58      | :uq      |    0x8 | r5+0x30  | cti+0xF0         |
// | V59      | :uq      |    0x8 | r5+0x38  | cti+0xF8         |
// | V39      | :d       |    0x4 | r6       | cti+0x100        |
// | V40      | :d       |    0x4 | r6+0x4   | cti+0x104        |
// | V41      | :d       |    0x4 | r6+0x8   | cti+0x108        |
// | V42      | :d       |    0x4 | r6+0xC   | cti+0x10C        |
// +----------+----------+--------+----------+------------------+


// B000: Preds:{},  Succs:{B001}
per_thread_prolog:
(W)     mov (16|M0)              r127.0<1>:ud  0x0:ud                              {A@1}             //  ALU pipe: int; 
(W)     and (1|M0)               r127.2<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud                       //  ALU pipe: int; 
(W)     and (1|M0)               r127.0<1>:uw  r0.4<0;1,0>:uw    0xFF:uw                             //  ALU pipe: int; 
(W)     add (1|M0)               r127.2<1>:ud  r127.2<0;1,0>:ud  0x120:ud              {I@2}         //  ALU pipe: int; 
(W)     mad (1|M0)               r127.0<1>:ud  r127.2<0;0>:ud    r127.0<0;0>:uw    0x40:uw              {I@1} //  ALU pipe: int; 
(W)     load.ugm.d32x16t.a32.ca.ca (1|M0)  r1:1 bti[255][r127:1]   {A@1,$0} // ex_desc:0xFF000000; desc:0x6218D500 // 
        nop                                                                                          // 
        nop                                                                                          // 
// B001: Preds:{B000},  Succs:{B002}
// cross_thread_prolog:
(W)     and (1|M0)               r127.0<1>:ud  r0.0<0;1,0>:ud    0xFFFFFFC0:ud              {$0.src} //  ALU pipe: int; 
(W)     load.ugm.d32x64t.a32.ca.ca (1|M0)  r2:4 bti[255][r127:1]   {A@1,$1} // ex_desc:0xFF000000; desc:0x6248F500 // 
(W)     add (1|M0)               r126.0<1>:ud  r127.0<0;1,0>:ud  0x100:uw                            //  ALU pipe: int; 
(W)     load.ugm.d32x8t.a32.ca.ca (1|M0)  r6:1  bti[255][r126:1]   {I@1,$2} // ex_desc:0xFF000000; desc:0x6218C500 // 
// B002: Preds:{B001},  Succs:{B003, B044}
// _ZTSZZN10allreducerIN4sycl3_V16detail9half_impl4halfELj16ELj1024EE9allreduceERNS1_5queueEPvjiPfENKUlRNS1_7handlerEE_clESB_E32Kernel_load_input_to_temp_buffer_BB_0:
        mov (1|M0)               r110.0<1>:uq  r2.5<0;1,0>:uq                   {Compacted,$1.dst}   //  ALU pipe: int; $1
        mov (1|M0)               r8.0<1>:uq    r4.1<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $2
        mov (1|M0)               r10.0<1>:uq   r4.2<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $3
        mov (1|M0)               r12.0<1>:uq   r4.3<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $4
        mov (1|M0)               r14.0<1>:uq   r4.4<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $5
        mov (1|M0)               r16.0<1>:uq   r4.5<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $6
        mov (1|M0)               r18.0<1>:uq   r4.6<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $7
        mov (1|M0)               r20.0<1>:uq   r4.7<0;1,0>:uq                                        //  ALU pipe: int; $8
        mov (1|M0)               r22.0<1>:uq   r5.1<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $9
        mov (1|M0)               r24.0<1>:uq   r5.2<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $10
        mov (1|M0)               r26.0<1>:uq   r5.3<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $11
        mov (1|M0)               r28.0<1>:uq   r5.4<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $12
        mov (1|M0)               r30.0<1>:uq   r5.5<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $13
        mov (1|M0)               r32.0<1>:uq   r5.6<0;1,0>:uq                   {Compacted}          //  ALU pipe: int; $14
        mov (1|M0)               r34.0<1>:uq   r5.7<0;1,0>:uq                                        //  ALU pipe: int; $15
        shr (1|M0)               r1.2<1>:ud    sr0.0<0;1,0>:ud   0x2:uw              {A@1,$0.dst}    //  ALU pipe: int; $16
        and (1|M0)               r1.3<1>:ud    sr0.0<0;1,0>:ud   0x3F:uw              {A@1}          //  ALU pipe: int; $17
(W)     mov (1|M0)               r1.4<1>:ud    0xFFFFFFC0:ud                              {A@1}      //  ALU pipe: int; $18
(W)     mov (1|M0)               r2.9<1>:ud    0xFFFFFFF8:ud                                         //  ALU pipe: int; $21
        bfn.(s0&s1|s2) (1|M0)    r1.2<1>:ud    r1.2<0;0>:ud      r1.4<0;0>:ud      r1.3<0>:ud       {I@2} //  ALU pipe: int; $18
        cmp (1|M0)    (gt)f0.1   null<1>:d     r2.6<0;1,0>:d     0:w                                 //  ALU pipe: int; $68
        shr (1|M0)               r2.3<1>:ud    r1.2<0;1,0>:ud    0x1:uw              {I@2}           //  ALU pipe: int; $19
        and (1|M0)               r1.2<1>:ud    r1.2<0;1,0>:ud    0x7:uw              {Compacted}     //  ALU pipe: int; $20
        bfn.(s0&s1|s2) (1|M0)    r2.3<1>:ud    r2.3<0;0>:ud      r2.9<0;0>:ud      r1.2<0>:ud       {I@1} //  ALU pipe: int; $21
        shl (1|M0)               r1.1<1>:q     r6.0<0;1,0>:ud    3:w               {Compacted,$2.dst} //  ALU pipe: int; $65
        and (1|M0)               r2.3<1>:ud    r2.3<0;1,0>:ud    0xFFF:uw              {I@2}         //  ALU pipe: int; $22
        mul (1|M0)               r2.3<1>:d     r2.3<0;1,0>:d     144:w               {I@1}           //  ALU pipe: int; $23
        add (1|M0)               r127.3<1>:q   r2.3<0;1,0>:ud    r2.2<0;1,0>:q    {I@1}              //  ALU pipe: int; $24
        mov (1|M0)               r127.2<1>:q   r127.3<0;1,0>:q                  {I@1}                //  ALU pipe: int; $25
        mov (1|M0)               r36.0<1>:q    r127.2<0;1,0>:q                  {Compacted,I@1}      //  ALU pipe: int; $26
        add (1|M0)               r38.0<1>:uq   r36.0<0;1,0>:uq   0x8:uw              {I@1}           //  ALU pipe: int; $29
        add (1|M0)               r40.0<1>:uq   r36.0<0;1,0>:uq   16:w                                //  ALU pipe: int; $31
        store.ugm.d64.a64 (1|M0)  [r36:2]       r110:2             {$3} // ex_desc:0x0; desc:0x4000784 // $28
        store.ugm.d64.a64 (1|M0)  [r38:2]       r4:2               {I@2,$4} // ex_desc:0x0; desc:0x4000784 // $30
        store.ugm.d64.a64 (1|M0)  [r40:2]       r8:2               {I@1,$5} // ex_desc:0x0; desc:0x4000784 // $32
        add (1|M0)               r42.0<1>:uq   r36.0<0;1,0>:uq   24:w                                //  ALU pipe: int; $33
        add (1|M0)               r44.0<1>:uq   r36.0<0;1,0>:uq   32:w                                //  ALU pipe: int; $35
        add (1|M0)               r46.0<1>:uq   r36.0<0;1,0>:uq   40:w                                //  ALU pipe: int; $37
        add (1|M0)               r48.0<1>:uq   r36.0<0;1,0>:uq   48:w                                //  ALU pipe: int; $39
        add (1|M0)               r50.0<1>:uq   r36.0<0;1,0>:uq   56:w                                //  ALU pipe: int; $41
        add (1|M0)               r52.0<1>:uq   r36.0<0;1,0>:uq   64:w                                //  ALU pipe: int; $43
        add (1|M0)               r8.0<1>:uq    r36.0<0;1,0>:uq   72:w               {$5.src}         //  ALU pipe: int; $45
        store.ugm.d64.a64 (1|M0)  [r42:2]       r10:2              {I@7,$6} // ex_desc:0x0; desc:0x4000784 // $34
        store.ugm.d64.a64 (1|M0)  [r44:2]       r12:2              {I@6,$7} // ex_desc:0x0; desc:0x4000784 // $36
        store.ugm.d64.a64 (1|M0)  [r46:2]       r14:2              {I@5,$8} // ex_desc:0x0; desc:0x4000784 // $38
        store.ugm.d64.a64 (1|M0)  [r48:2]       r16:2              {I@4,$9} // ex_desc:0x0; desc:0x4000784 // $40
        store.ugm.d64.a64 (1|M0)  [r50:2]       r18:2              {I@3,$10} // ex_desc:0x0; desc:0x4000784 // $42
        store.ugm.d64.a64 (1|M0)  [r52:2]       r20:2              {I@2,$11} // ex_desc:0x0; desc:0x4000784 // $44
        store.ugm.d64.a64 (1|M0)  [r8:2]        r5:2               {I@1,$12} // ex_desc:0x0; desc:0x4000784 // $46
        sync.nop                             null                             {Compacted,$12.src}    // $61
        mov (1|M0)               r5.0<1>:d     r0.1<0;1,0>:ud                   {$4.src}             //  ALU pipe: int; $61
        add (1|M0)               r10.0<1>:uq   r36.0<0;1,0>:uq   80:w               {$6.src}         //  ALU pipe: int; $47
(W)     mul (1|M0)               acc0.0<1>:d   r5.0<0;1,0>:d     r2.0<0;1,0>:uw   {Compacted,I@2}    //  ALU pipe: int; $62
        add (1|M0)               r12.0<1>:uq   r36.0<0;1,0>:uq   88:w               {$7.src}         //  ALU pipe: int; $49
        add (1|M0)               r14.0<1>:uq   r36.0<0;1,0>:uq   96:w               {$8.src}         //  ALU pipe: int; $51
        add (1|M0)               r16.0<1>:uq   r36.0<0;1,0>:uq   104:w               {$9.src}        //  ALU pipe: int; $53
        add (1|M0)               r18.0<1>:uq   r36.0<0;1,0>:uq   112:w               {$10.src}       //  ALU pipe: int; $55
        add (1|M0)               r20.0<1>:uq   r36.0<0;1,0>:uq   120:w               {$11.src}       //  ALU pipe: int; $57
        add (1|M0)               r8.0<1>:uq    r36.0<0;1,0>:uq   128:w                               //  ALU pipe: int; $59
        macl (1|M0)              r5.0<1>:d     r5.0<0;1,0>:d     r2.0<0;1,0>:d    {Compacted}        //  ALU pipe: int; $63
(W)     mul (1|M0)               acc0.0<1>:d   r6.3<0;1,0>:d     r6.4<0;1,0>:uw   {Compacted}        //  ALU pipe: int; $67
        store.ugm.d64.a64 (1|M0)  [r10:2]       r22:2              {I@7,$13} // ex_desc:0x0; desc:0x4000784 // $48
        store.ugm.d64.a64 (1|M0)  [r12:2]       r24:2              {I@7,$14} // ex_desc:0x0; desc:0x4000784 // $50
        store.ugm.d64.a64 (1|M0)  [r14:2]       r26:2              {I@7,$15} // ex_desc:0x0; desc:0x4000784 // $52
        store.ugm.d64.a64 (1|M0)  [r16:2]       r28:2              {I@6,$0} // ex_desc:0x0; desc:0x4000784 // $54
        store.ugm.d64.a64 (1|M0)  [r18:2]       r30:2              {I@5,$1} // ex_desc:0x0; desc:0x4000784 // $56
        store.ugm.d64.a64 (1|M0)  [r20:2]       r32:2              {I@4,$2} // ex_desc:0x0; desc:0x4000784 // $58
        store.ugm.d64.a64 (1|M0)  [r8:2]        r34:2              {I@3,$3} // ex_desc:0x0; desc:0x4000784 // $60
        add (1|M0)               r127.3<1>:q   r36.0<0;1,0>:q    144:w                               //  ALU pipe: int; $27
        add (1|M0)               r4.0<1>:q     r38.0<0;1,0>:q    r1.1<0;1,0>:q    {Compacted}        //  ALU pipe: int; $66
        add (1|M0)               r4.2<1>:d     r5.0<0;1,0>:d     r1.0<0;1,0>:uw   {I@4}              //  ALU pipe: int; $63
        macl (1|M0)              r123.0<1>:d   r6.3<0;1,0>:d     r6.2<0;1,0>:d    {Compacted}        //  ALU pipe: int; $68
(W&~f0.1) jmpi                               BB_1                                                    //  ALU pipe: int; $69
// B003: Preds:{B002},  Succs:{B004}
_L_k1_0_:
        add3 (1|M0)              r5.0<1>:d     r5.0<0;0>:d       r2.13<0;0>:d      r1.0<0>:uw        //  ALU pipe: int; $75
        add (1|M0)               r4.5<1>:d     r2.8<0;1,0>:d     -2:w                                //  ALU pipe: int; $70
        add (1|M0)               r4.3<1>:d     r2.12<0;1,0>:d    127:w                               //  ALU pipe: int; $72
        mul (1|M0)               r4.12<1>:d    r5.0<0;1,0>:d     -2048:w               {I@3}         //  ALU pipe: int; $76
        mul (1|M0)               r4.13<1>:d    r5.0<0;1,0>:d     -1024:w                             //  ALU pipe: int; $78
        mul (1|M0)               r4.14<1>:d    r5.0<0;1,0>:d     -768:w                              //  ALU pipe: int; $80
        mul (1|M0)               r4.15<1>:d    r5.0<0;1,0>:d     -512:w                              //  ALU pipe: int; $82
        mul (1|M0)               r5.0<1>:d     r5.0<0;1,0>:d     -256:w               {Compacted}    //  ALU pipe: int; $84
        mov (1|M0)               r4.3<1>:q     r2.7<0;1,0>:ud                                        //  ALU pipe: int; $73
        mov (1|M0)               r4.4<1>:q     r2.6<0;1,0>:ud                                        //  ALU pipe: int; $74
        mov (1|M0)               r4.5<1>:q     0:w                                                   //  ALU pipe: int; $86
        rol (1|M0)               r4.4<1>:ud    r4.5<0;1,0>:ud    0x1F:uw              {I@7}          //  ALU pipe: int; $71
        add (1|M0)               r4.12<1>:d    r4.12<0;1,0>:d    r4.3<0;1,0>:d    {I@7}              //  ALU pipe: int; $77
        add (1|M0)               r4.13<1>:d    r4.13<0;1,0>:d    r4.3<0;1,0>:d    {I@7}              //  ALU pipe: int; $79
        add (1|M0)               r4.14<1>:d    r4.14<0;1,0>:d    r4.3<0;1,0>:d    {I@7}              //  ALU pipe: int; $81
        add (1|M0)               r4.15<1>:d    r4.15<0;1,0>:d    r4.3<0;1,0>:d    {I@7}              //  ALU pipe: int; $83
        add (1|M0)               r5.0<1>:d     r5.0<0;1,0>:d     r4.3<0;1,0>:d    {Compacted,I@7}    //  ALU pipe: int; $85
// B004: Preds:{B043, B003},  Succs:{B005, B044}
BB_2:
        shr (1|M0)               r1.2<1>:ud    r5.0<0;1,0>:ud    0x7:uw              {Compacted,I@1} //  ALU pipe: int; $88
        mul (1|M0)               acc0.0<1>:ud  r4.10<0;1,0>:ud   0xE00:uw                            //  ALU pipe: int; $103
        sel (1|M0)    (ge)f0.0   r1.2<1>:ud    r1.2<0;1,0>:ud    0x1:uw              {I@2}           //  ALU pipe: int; $89
        sync.allrd                           ($5,$8,$15)                                             // 
        mach (1|M0)              r9.0<1>:ud    r4.10<0;1,0>:ud   0xE00:ud              {Compacted,$3.src} //  ALU pipe: int; 
        mov (1|M0)               r5.6<1>:q     r1.2<0;1,0>:ud                   {I@2}                //  ALU pipe: int; $90
        sync.nop                             null                             {Compacted,$6.src}     // 
        mov (1|M0)               r8.0<1>:ud    acc0.0<0;1,0>:ud                 {$2.src}             //  ALU pipe: int; 
        mul (1|M0)               r1.2<1>:d     r4.11<0;1,0>:d    3584:w                              //  ALU pipe: int; $104
        mov (1|M0)               r5.2<1>:d     r8.0<0;1,0>:d                    {Compacted,I@2}      //  ALU pipe: int; $105
        add (1|M0)               r5.3<1>:d     r1.2<0;1,0>:d     r9.0<0;1,0>:d    {I@2}              //  ALU pipe: int; $106
        shr (1|M0)               r2.3<1>:ud    r4.15<0;1,0>:ud   0x7:uw              {$7.src}        //  ALU pipe: int; $91
        add (1|M0)               r5.1<1>:q     r5.1<0;1,0>:q     r4.2<0;1,0>:ud   {Compacted,I@2}    //  ALU pipe: int; $107
        sync.allrd                           ($9,$12)                                                // $94
        shr (1|M0)               r3.0<1>:ud    r4.14<0;1,0>:ud   0x7:uw              {$1.src}        //  ALU pipe: int; $94
        cmp (1|M0)    (lt)f0.0   null<1>:ud    r5.2<0;1,0>:ud    r4.6<0;1,0>:ud   {I@2}              //  ALU pipe: int; $109
        sel (1|M0)    (ge)f0.0   r2.3<1>:ud    r2.3<0;1,0>:ud    0x1:uw                              //  ALU pipe: int; $92
        cmp (1|M0)    (lt)f1.0   null<1>:ud    r5.3<0;1,0>:ud    r4.7<0;1,0>:ud                      //  ALU pipe: int; $108
        sel (1|M0)    (ge)f0.0   r3.0<1>:ud    r3.0<0;1,0>:ud    0x1:uw              {I@4}           //  ALU pipe: int; $95
(f0.0)  cmp (1|M0)    (eq)f0.0   null<1>:d     r5.3<0;1,0>:d     r4.7<0;1,0>:d                       //  ALU pipe: int; $110
        mov (1|M0)               r5.5<1>:q     r2.3<0;1,0>:ud                   {I@4}                //  ALU pipe: int; $93
(W)     mov (1|M0)               r2.6<1>:hf    0x1:hf                              {I@1}             //  ALU pipe: float; $112
        mov (1|M0)               r5.4<1>:q     r3.0<0;1,0>:ud                                        //  ALU pipe: int; $96
(f0.0)  sel (1|M0)               r2.7<1>:uw    r2.6<0;1,0>:uw    0x0:uw              {F@1}           //  ALU pipe: int; $112
(f1.0)  sel (1|M0)               r3.0<1>:uw    r2.6<0;1,0>:uw    0x0:uw                              //  ALU pipe: int; $112
        shr (1|M0)               r6.1<1>:ud    r4.13<0;1,0>:ud   0x7:uw                              //  ALU pipe: int; $97
        sync.allrd                           ($13,$14)                                               // $100
        shr (1|M0)               r7.0<1>:ud    r4.12<0;1,0>:ud   0x7:uw              {Compacted,$11.src} //  ALU pipe: int; $100
        or (1|M0)     (ne)f0.0   null<1>:uw    r2.7<0;1,0>:uw    r3.0<0;1,0>:uw   {I@3}              //  ALU pipe: int; $112
        sel (1|M0)    (ge)f0.0   r6.1<1>:ud    r6.1<0;1,0>:ud    0x1:uw              {I@3}           //  ALU pipe: int; $98
        sel (1|M0)    (ge)f0.0   r7.0<1>:ud    r7.0<0;1,0>:ud    0x1:uw              {I@3}           //  ALU pipe: int; $101
        mov (1|M0)               r5.3<1>:q     r6.1<0;1,0>:ud                   {I@2}                //  ALU pipe: int; $99
        mov (1|M0)               r5.2<1>:q     r7.0<0;1,0>:ud                   {I@2}                //  ALU pipe: int; $102
(W&~f0.0) jmpi                               BB_1                                                    //  ALU pipe: int; $113
// B005: Preds:{B004},  Succs:{B006, B028}
_L_k1_1_:
        cmp (1|M0)    (lt)f3.1   null<1>:d     r4.4<0;1,0>:d     2:w                                 //  ALU pipe: int; $114
(W&f3.1) jmpi                                BB_3                                                    //  ALU pipe: int; $115
// B006: Preds:{B005},  Succs:{B007, B022}
_L_k1_2_:
        cmp (1|M0)    (eq)f3.0   null<1>:d     r4.5<0;1,0>:d     4:w                                 //  ALU pipe: int; $116
(W&f3.0) jmpi                                BB_4                                                    //  ALU pipe: int; $117
// B007: Preds:{B006},  Succs:{B008, B015}
_L_k1_3_:
        cmp (1|M0)    (lt)f2.1   null<1>:d     r4.4<0;1,0>:d     7:w                                 //  ALU pipe: int; $118
(W&f2.1) jmpi                                BB_5                                                    //  ALU pipe: int; $119
// B008: Preds:{B007},  Succs:{B009, B043}
_L_k1_4_:
        cmp (1|M0)    (eq)f2.0   null<1>:d     r4.5<0;1,0>:d     14:w                                //  ALU pipe: int; $120
(W&~f2.0) jmpi                               BB_6                                                    //  ALU pipe: int; $121
// B009: Preds:{B008},  Succs:{B010, B011}
_L_k1_5_:
        add (1|M0)               r2.0<1>:d     r5.2<0;1,0>:d     r2.13<0;1,0>:d                      //  ALU pipe: int; $122
        shl (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     11:w               {Compacted,I@1}  //  ALU pipe: int; $123
        add (1|M0)               r1.2<1>:d     r2.0<0;1,0>:d     2048:w               {I@1}          //  ALU pipe: int; $124
        mov (1|M0)               r5.3<1>:q     r2.0<0;1,0>:ud                                        //  ALU pipe: int; $125
        cmp (1|M0)    (gt)f1.1   null<1>:ud    r1.2<0;1,0>:ud    r2.12<0;1,0>:ud  {I@2}              //  ALU pipe: int; $126
(W&f1.1) jmpi                                BB_7                                                    //  ALU pipe: int; $127
// B010: Preds:{B009},  Succs:{B014}
_L_k1_6_:
        shl (1|M0)               r5.3<1>:q     r5.3<0;1,0>:q     1:w               {I@3}             //  ALU pipe: int; $128
        add (1|M0)               r3.0<1>:q     r110.0<0;1,0>:q   r5.3<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $129
        add (1|M0)               r7.0<1>:uq    r3.0<0;1,0>:uq    0x100:uw              {I@1}         //  ALU pipe: int; $131
        add (1|M0)               r8.0<1>:uq    r3.0<0;1,0>:uq    0x200:uw                            //  ALU pipe: int; $133
        load.ugm.d32x64t.a64 (1|M0)  r18:4      [r7:1]             {I@2,$4} // ex_desc:0x0; desc:0x240F580 // $132
        add (1|M0)               r9.0<1>:uq    r3.0<0;1,0>:uq    0x300:uw                            //  ALU pipe: int; $135
        sync.allrd                           ($3,$7,$10)                 {Compacted}                 // $137
        add (1|M0)               r10.0<1>:uq   r3.0<0;1,0>:uq    0x400:uw              {$13.src}     //  ALU pipe: int; $137
        add (1|M0)               r11.0<1>:uq   r3.0<0;1,0>:uq    0x500:uw              {$14.src}     //  ALU pipe: int; $139
        sync.nop                             null                             {Compacted,$0.src}     // $141
        add (1|M0)               r12.0<1>:uq   r3.0<0;1,0>:uq    0x600:uw              {$14.src}     //  ALU pipe: int; $141
        add (1|M0)               r13.0<1>:uq   r3.0<0;1,0>:uq    0x700:uw                            //  ALU pipe: int; $143
        add (1|M0)               r7.0<1>:uq    r3.0<0;1,0>:uq    0x800:uw              {$4.src}      //  ALU pipe: int; $145
        load.ugm.d32x64t.a64 (1|M0)  r22:4      [r8:1]             {I@7,$5} // ex_desc:0x0; desc:0x240F580 // $134
        load.ugm.d32x64t.a64 (1|M0)  r26:4      [r9:1]             {I@6,$6} // ex_desc:0x0; desc:0x240F580 // $136
        load.ugm.d32x64t.a64 (1|M0)  r30:4      [r10:1]            {I@5,$7} // ex_desc:0x0; desc:0x240F580 // $138
        load.ugm.d32x64t.a64 (1|M0)  r34:4      [r11:1]            {I@4,$8} // ex_desc:0x0; desc:0x240F580 // $140
        load.ugm.d32x64t.a64 (1|M0)  r38:4      [r12:1]            {I@3,$9} // ex_desc:0x0; desc:0x240F580 // $142
        load.ugm.d32x64t.a64 (1|M0)  r42:4      [r13:1]            {I@2,$10} // ex_desc:0x0; desc:0x240F580 // $144
        load.ugm.d32x64t.a64 (1|M0)  r46:4      [r7:1]             {I@1,$11} // ex_desc:0x0; desc:0x240F580 // $146
        add (1|M0)               r8.0<1>:uq    r3.0<0;1,0>:uq    0x900:uw              {$5.src}      //  ALU pipe: int; $147
        add (1|M0)               r9.0<1>:uq    r3.0<0;1,0>:uq    0xA00:uw              {$6.src}      //  ALU pipe: int; $149
        add (1|M0)               r10.0<1>:uq   r3.0<0;1,0>:uq    0xB00:uw              {$7.src}      //  ALU pipe: int; $151
        add (1|M0)               r11.0<1>:uq   r3.0<0;1,0>:uq    0xC00:uw              {$8.src}      //  ALU pipe: int; $153
        add (1|M0)               r12.0<1>:uq   r3.0<0;1,0>:uq    0xD00:uw              {$9.src}      //  ALU pipe: int; $155
        add (1|M0)               r13.0<1>:uq   r3.0<0;1,0>:uq    0xE00:uw              {$10.src}     //  ALU pipe: int; $157
        add (1|M0)               r7.0<1>:uq    r3.0<0;1,0>:uq    0xF00:uw              {$11.src}     //  ALU pipe: int; $159
        load.ugm.d32x64t.a64 (1|M0)  r14:4      [r3:1]             {$12} // ex_desc:0x0; desc:0x240F580 // $130
        load.ugm.d32x64t.a64 (1|M0)  r50:4      [r8:1]             {I@7,$13} // ex_desc:0x0; desc:0x240F580 // $148
        load.ugm.d32x64t.a64 (1|M0)  r54:4      [r9:1]             {I@6,$0} // ex_desc:0x0; desc:0x240F580 // $150
        load.ugm.d32x64t.a64 (1|M0)  r58:4      [r10:1]            {I@5,$1} // ex_desc:0x0; desc:0x240F580 // $152
        load.ugm.d32x64t.a64 (1|M0)  r62:4      [r11:1]            {I@4,$2} // ex_desc:0x0; desc:0x240F580 // $154
        load.ugm.d32x64t.a64 (1|M0)  r66:4      [r12:1]            {I@3,$14} // ex_desc:0x0; desc:0x240F580 // $156
        load.ugm.d32x64t.a64 (1|M0)  r70:4      [r13:1]            {I@2,$3} // ex_desc:0x0; desc:0x240F580 // $158
        load.ugm.d32x64t.a64 (1|M0)  r74:4      [r7:1]             {I@1,$15} // ex_desc:0x0; desc:0x240F580 // $160
(W)     jmpi                                 BB_8                                                    // $161
// B011: Preds:{B009},  Succs:{B012, B014}
BB_7:
        add (1|M0)               r2.0<1>:d     r4.3<0;1,0>:d     -r2.0<0;1,0>:d                      //  ALU pipe: int; $163
        mov (32|M0)              r14.0<1>:d    0:w                               {Compacted,$15.src} //  ALU pipe: int; $166
        cmp (1|M0)    (lt)f0.1   null<1>:ud    r2.0<0;1,0>:ud    0x80:uw              {I@2}          //  ALU pipe: int; $167
        mov (32|M0)              r16.0<1>:d    0:w                               {Compacted,$0.src}  //  ALU pipe: int; $168
        mov (32|M0)              r18.0<1>:d    0:w                               {Compacted,$1.src}  //  ALU pipe: int; $169
        mov (32|M0)              r20.0<1>:d    0:w                               {Compacted,$2.src}  //  ALU pipe: int; $170
        mov (32|M0)              r22.0<1>:d    0:w                               {Compacted,$13.src} //  ALU pipe: int; $171
        mov (32|M0)              r24.0<1>:d    0:w                               {Compacted,$14.src} //  ALU pipe: int; $172
        mov (32|M0)              r26.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $173
        mov (32|M0)              r28.0<1>:d    0:w                               {Compacted,$10.src} //  ALU pipe: int; $174
        mov (32|M0)              r30.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $175
        mov (32|M0)              r32.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $176
        mov (32|M0)              r34.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $177
        mov (32|M0)              r36.0<1>:d    0:w                               {Compacted,$3.src}  //  ALU pipe: int; $178
        mov (32|M0)              r38.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $179
        mov (32|M0)              r40.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $180
        mov (32|M0)              r42.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $181
        mov (32|M0)              r44.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $182
        mov (32|M0)              r46.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $183
        mov (32|M0)              r48.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $184
        mov (32|M0)              r50.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $185
        mov (32|M0)              r52.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $186
        mov (32|M0)              r54.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $187
        mov (32|M0)              r56.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $188
        mov (32|M0)              r58.0<1>:d    0:w                               {Compacted,$3.src}  //  ALU pipe: int; $189
        mov (32|M0)              r60.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $190
        mov (32|M0)              r62.0<1>:d    0:w                               {Compacted,$14.src} //  ALU pipe: int; $191
        mov (32|M0)              r64.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $192
        mov (32|M0)              r66.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $193
        mov (32|M0)              r68.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $194
        mov (32|M0)              r70.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $195
        mov (32|M0)              r72.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $196
        mov (32|M0)              r74.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $197
        mov (32|M0)              r76.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $198
        shl (1|M0)               r5.3<1>:q     r5.3<0;1,0>:q     1:w                                 //  ALU pipe: int; $164
        add (1|M0)               r5.3<1>:q     r110.0<0;1,0>:q   r5.3<0;1,0>:q    {I@1}              //  ALU pipe: int; $165
(W&f0.1) jmpi                                BB_8                                                    //  ALU pipe: int; $199
// B012: Preds:{B011},  Succs:{B013}
_L_k1_7_:
        mov (1|M0)               r5.4<1>:q     0:w                                                   //  ALU pipe: int; $200
// B013: Preds:{B013, B012},  Succs:{B014, B013}
BB_9:
        shl (1|M0)               r1.1<1>:q     r5.4<0;1,0>:q     7:w               {I@1}             //  ALU pipe: int; $202
        add (1|M0)               r5.4<1>:q     r5.4<0;1,0>:q     1:w                                 //  ALU pipe: int; $213
        shl (1|M0)               r1.2<1>:q     r1.1<0;1,0>:q     1:w               {I@2}             //  ALU pipe: int; $203
        shl (1|M0)               r2.6<1>:w     r1.4<0;1,0>:w     1:w                                 //  ALU pipe: int; $207
        add (1|M0)               r3.0<1>:q     r5.3<0;1,0>:q     r1.2<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $204
        cmp (1|M0)    (eq)f3.1   null<1>:d     r5.8<0;1,0>:d     r5.4<0;1,0>:d                       //  ALU pipe: int; $214
        load.ugm.d32x64t.a64 (1|M0)  r7:4       [r3:1]             {I@2,$4} // ex_desc:0x0; desc:0x240F580 // $206
        add (1|M0)               a0.0<1>:uw    r2.6<0;1,0>:uw    0x380:uw              {A@1}         //  ALU pipe: int; $208
(f3.1)  cmp (1|M0)    (eq)f3.1   null<1>:d     r5.9<0;1,0>:d     r5.5<0;1,0>:d                       //  ALU pipe: int; $215
        mov (32|M0)              r[a0.0]<1>:uw  r7.0<1;1,0>:uw                  {$4.dst}             //  ALU pipe: int; $209
        mov (32|M0)              r[a0.0,64]<1>:uw  r8.0<1;1,0>:uw                                    //  ALU pipe: int; $210
        mov (32|M0)              r[a0.0,128]<1>:uw  r9.0<1;1,0>:uw                                   //  ALU pipe: int; $211
        mov (32|M0)              r[a0.0,192]<1>:uw  r10.0<1;1,0>:uw                                  //  ALU pipe: int; $212
(W&~f3.1) jmpi                               BB_9                                                    //  ALU pipe: int; $217
// B014: Preds:{B013, B011, B010},  Succs:{B042}
BB_8:
        load.ugm.d64.a64 (1|M0)   r8:2          [r4:2]             {A@3,$5} // ex_desc:0x0; desc:0x4200780 // $220
        shl (1|M0)               r1.2<1>:d     r5.2<0;1,0>:d     12:w               {Compacted}      //  ALU pipe: int; $221
        sync.nop                             null                             {Compacted,I@3}        // $256
        sync.nop                             null                             {Compacted,$3.src}     // $256
        mov (32|M0)              r111.0<1>:uw  r74.0<1;1,0>:uw                  {$15.dst}            //  ALU pipe: int; $256
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     r123.0<0;1,0>:d  {Compacted,I@2}    //  ALU pipe: int; $222
        mov (32|M0)              r112.0<1>:hf  r75.0<1;1,0>:hf                                       //  ALU pipe: float; $257
        shl (1|M0)               r2.7<1>:q     r1.2<0;1,0>:ud    1:w               {I@1}             //  ALU pipe: int; $224
        mov (32|M0)              r113.0<1>:hf  r76.0<1;1,0>:hf                                       //  ALU pipe: float; $258
        mov (32|M0)              r114.0<1>:hf  r77.0<1;1,0>:hf                                       //  ALU pipe: float; $259
        sync.nop                             null                             {Compacted,I@1}        // $225
        add (1|M0)               r2.0<1>:q     r8.0<0;1,0>:q     r2.7<0;1,0>:q    {Compacted,$5.dst} //  ALU pipe: int; $225
        sync.nop                             null                             {Compacted,I@1}        // $227
        add (1|M0)               r3.0<1>:uq    r2.0<0;1,0>:uq    0x100:uw              {$12.src}     //  ALU pipe: int; $227
        add (1|M0)               r7.0<1>:uq    r2.0<0;1,0>:uq    0x200:uw                            //  ALU pipe: int; $229
        add (1|M0)               r9.0<1>:uq    r2.0<0;1,0>:uq    0x300:uw                            //  ALU pipe: int; $231
        sync.nop                             null                             {Compacted,$7.src}     // $233
        add (1|M0)               r10.0<1>:uq   r2.0<0;1,0>:uq    0x400:uw              {$1.src}      //  ALU pipe: int; $233
        sync.nop                             null                             {Compacted,$4.src}     // $235
        add (1|M0)               r11.0<1>:uq   r2.0<0;1,0>:uq    0x500:uw              {$2.src}      //  ALU pipe: int; $235
        add (1|M0)               r8.0<1>:uq    r2.0<0;1,0>:uq    0x600:uw                            //  ALU pipe: int; $237
        add (1|M0)               r12.0<1>:uq   r2.0<0;1,0>:uq    0x700:uw              {$14.src}     //  ALU pipe: int; $239
        store.ugm.d32x64t.a64 (1|M0)  [r2:1]    r14:4              {$12} // ex_desc:0x0; desc:0x200F584 // $226
        sync.nop                             null                             {Compacted,$4.dst}     // $228
        store.ugm.d32x64t.a64 (1|M0)  [r3:1]    r18:4              {I@7,$6} // ex_desc:0x0; desc:0x200F584 // $228
        sync.nop                             null                             {Compacted,$5.dst}     // $230
        store.ugm.d32x64t.a64 (1|M0)  [r7:1]    r22:4              {I@6,$8} // ex_desc:0x0; desc:0x200F584 // $230
        sync.nop                             null                             {Compacted,$6.dst}     // $232
        store.ugm.d32x64t.a64 (1|M0)  [r9:1]    r26:4              {I@5,$10} // ex_desc:0x0; desc:0x200F584 // $232
        sync.nop                             null                             {Compacted,$7.dst}     // $234
        store.ugm.d32x64t.a64 (1|M0)  [r10:1]   r30:4              {I@4,$11} // ex_desc:0x0; desc:0x200F584 // $234
        sync.nop                             null                             {Compacted,$8.dst}     // $236
        store.ugm.d32x64t.a64 (1|M0)  [r11:1]   r34:4              {I@3,$13} // ex_desc:0x0; desc:0x200F584 // $236
        sync.nop                             null                             {Compacted,$9.dst}     // $238
        store.ugm.d32x64t.a64 (1|M0)  [r8:1]    r38:4              {I@2,$1} // ex_desc:0x0; desc:0x200F584 // $238
        sync.nop                             null                             {Compacted,$10.dst}    // $240
        store.ugm.d32x64t.a64 (1|M0)  [r12:1]   r42:4              {I@1,$0} // ex_desc:0x0; desc:0x200F584 // $240
        add (1|M0)               r3.0<1>:uq    r2.0<0;1,0>:uq    0x800:uw                            //  ALU pipe: int; $241
        add (1|M0)               r7.0<1>:uq    r2.0<0;1,0>:uq    0x900:uw                            //  ALU pipe: int; $243
        add (1|M0)               r9.0<1>:uq    r2.0<0;1,0>:uq    0xA00:uw                            //  ALU pipe: int; $245
        add (1|M0)               r10.0<1>:uq   r2.0<0;1,0>:uq    0xB00:uw              {$11.src}     //  ALU pipe: int; $247
        add (1|M0)               r11.0<1>:uq   r2.0<0;1,0>:uq    0xC00:uw              {$13.src}     //  ALU pipe: int; $249
        add (1|M0)               r8.0<1>:uq    r2.0<0;1,0>:uq    0xD00:uw              {$1.src}      //  ALU pipe: int; $251
        add (1|M0)               r12.0<1>:uq   r2.0<0;1,0>:uq    0xE00:uw              {$0.src}      //  ALU pipe: int; $253
        sync.nop                             null                             {Compacted,$11.dst}    // $242
        store.ugm.d32x64t.a64 (1|M0)  [r3:1]    r46:4              {I@7,$7} // ex_desc:0x0; desc:0x200F584 // $242
        sync.nop                             null                             {Compacted,$13.dst}    // $244
        store.ugm.d32x64t.a64 (1|M0)  [r7:1]    r50:4              {I@6,$9} // ex_desc:0x0; desc:0x200F584 // $244
        sync.nop                             null                             {Compacted,$0.dst}     // $246
        store.ugm.d32x64t.a64 (1|M0)  [r9:1]    r54:4              {I@5,$15} // ex_desc:0x0; desc:0x200F584 // $246
        sync.nop                             null                             {Compacted,$1.dst}     // $248
        store.ugm.d32x64t.a64 (1|M0)  [r10:1]   r58:4              {I@4,$3} // ex_desc:0x0; desc:0x200F584 // $248
        sync.nop                             null                             {Compacted,$2.dst}     // $250
        store.ugm.d32x64t.a64 (1|M0)  [r11:1]   r62:4              {I@3,$14} // ex_desc:0x0; desc:0x200F584 // $250
        sync.nop                             null                             {Compacted,$14.dst}    // $252
        store.ugm.d32x64t.a64 (1|M0)  [r8:1]    r66:4              {I@2,$2} // ex_desc:0x0; desc:0x200F584 // $252
        sync.nop                             null                             {Compacted,$3.dst}     // $254
        store.ugm.d32x64t.a64 (1|M0)  [r12:1]   r70:4              {I@1,$0} // ex_desc:0x0; desc:0x200F584 // $254
        add (1|M0)               r2.0<1>:uq    r2.0<0;1,0>:uq    0xF00:uw              {$12.src}     //  ALU pipe: int; $255
(W)     jmpi                                 BB_10                                                   // $260
// B015: Preds:{B007},  Succs:{B016, B043}
BB_5:
        cmp (1|M0)    (eq)f1.0   null<1>:d     r4.5<0;1,0>:d     6:w                                 //  ALU pipe: int; $262
(W&~f1.0) jmpi                               BB_6                                                    //  ALU pipe: int; $263
// B016: Preds:{B015},  Succs:{B017, B018}
_L_k1_8_:
        add (1|M0)               r2.0<1>:d     r5.2<0;1,0>:d     r2.13<0;1,0>:d                      //  ALU pipe: int; $264
        shl (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     10:w               {Compacted,I@1}  //  ALU pipe: int; $265
        add (1|M0)               r1.2<1>:d     r2.0<0;1,0>:d     1024:w               {Compacted,I@1} //  ALU pipe: int; $266
        mov (1|M0)               r5.2<1>:q     r2.0<0;1,0>:ud                                        //  ALU pipe: int; $267
        cmp (1|M0)    (gt)f0.1   null<1>:ud    r1.2<0;1,0>:ud    r2.12<0;1,0>:ud  {I@2}              //  ALU pipe: int; $268
(W&f0.1) jmpi                                BB_11                                                   //  ALU pipe: int; $269
// B017: Preds:{B016},  Succs:{B021}
_L_k1_9_:
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted,I@3}   //  ALU pipe: int; $270
        add (1|M0)               r3.0<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $271
        add (1|M0)               r7.0<1>:uq    r3.0<0;1,0>:uq    0x100:uw              {I@1}         //  ALU pipe: int; $273
        add (1|M0)               r8.0<1>:uq    r3.0<0;1,0>:uq    0x200:uw                            //  ALU pipe: int; $275
        add (1|M0)               r9.0<1>:uq    r3.0<0;1,0>:uq    0x300:uw                            //  ALU pipe: int; $277
        sync.allrd                           ($3,$7,$10)                 {Compacted}                 // $279
        add (1|M0)               r10.0<1>:uq   r3.0<0;1,0>:uq    0x400:uw              {$13.src}     //  ALU pipe: int; $279
        sync.nop                             null                             {Compacted,$4.src}     // $281
        add (1|M0)               r11.0<1>:uq   r3.0<0;1,0>:uq    0x500:uw              {$14.src}     //  ALU pipe: int; $281
        sync.nop                             null                             {Compacted,$0.src}     // $283
        add (1|M0)               r12.0<1>:uq   r3.0<0;1,0>:uq    0x600:uw              {$14.src}     //  ALU pipe: int; $283
        add (1|M0)               r13.0<1>:uq   r3.0<0;1,0>:uq    0x700:uw                            //  ALU pipe: int; $285
        load.ugm.d32x64t.a64 (1|M0)  r78:4      [r3:1]             {$4} // ex_desc:0x0; desc:0x240F580 // $272
        load.ugm.d32x64t.a64 (1|M0)  r82:4      [r7:1]             {I@7,$5} // ex_desc:0x0; desc:0x240F580 // $274
        load.ugm.d32x64t.a64 (1|M0)  r86:4      [r8:1]             {I@6,$12} // ex_desc:0x0; desc:0x240F580 // $276
        load.ugm.d32x64t.a64 (1|M0)  r90:4      [r9:1]             {I@5,$6} // ex_desc:0x0; desc:0x240F580 // $278
        load.ugm.d32x64t.a64 (1|M0)  r94:4      [r10:1]            {I@4,$8} // ex_desc:0x0; desc:0x240F580 // $280
        load.ugm.d32x64t.a64 (1|M0)  r98:4      [r11:1]            {I@3,$10} // ex_desc:0x0; desc:0x240F580 // $282
        load.ugm.d32x64t.a64 (1|M0)  r102:4     [r12:1]            {I@2,$11} // ex_desc:0x0; desc:0x240F580 // $284
        load.ugm.d32x64t.a64 (1|M0)  r106:4     [r13:1]            {I@1,$13} // ex_desc:0x0; desc:0x240F580 // $286
(W)     jmpi                                 BB_12                                                   // $287
// B018: Preds:{B016},  Succs:{B019, B021}
BB_11:
        add (1|M0)               r2.0<1>:d     r4.3<0;1,0>:d     -r2.0<0;1,0>:d                      //  ALU pipe: int; $289
        mov (32|M0)              r78.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $292
        cmp (1|M0)    (lt)f0.0   null<1>:ud    r2.0<0;1,0>:ud    0x80:uw              {I@2}          //  ALU pipe: int; $308
        mov (32|M0)              r80.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $293
        mov (32|M0)              r82.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $294
        mov (32|M0)              r84.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $295
        mov (32|M0)              r86.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $296
        mov (32|M0)              r88.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $297
        mov (32|M0)              r90.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $298
        mov (32|M0)              r92.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $299
        mov (32|M0)              r94.0<1>:d    0:w                               {Compacted,$7.src}  //  ALU pipe: int; $300
        mov (32|M0)              r96.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $301
        mov (32|M0)              r98.0<1>:d    0:w                               {Compacted,$4.src}  //  ALU pipe: int; $302
        mov (32|M0)              r100.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $303
        mov (32|M0)              r102.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $304
        mov (32|M0)              r104.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $305
        mov (32|M0)              r106.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $306
        mov (32|M0)              r108.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $307
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted}       //  ALU pipe: int; $290
        add (1|M0)               r5.2<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $291
(W&f0.0) jmpi                                BB_12                                                   //  ALU pipe: int; $309
// B019: Preds:{B018},  Succs:{B020}
_L_k1_10_:
        mov (1|M0)               r5.4<1>:q     0:w                                                   //  ALU pipe: int; $310
// B020: Preds:{B020, B019},  Succs:{B021, B020}
BB_13:
        shl (1|M0)               r1.1<1>:q     r5.4<0;1,0>:q     7:w               {I@1}             //  ALU pipe: int; $312
        add (1|M0)               r5.4<1>:q     r5.4<0;1,0>:q     1:w                                 //  ALU pipe: int; $323
        shl (1|M0)               r1.2<1>:q     r1.1<0;1,0>:q     1:w               {I@2}             //  ALU pipe: int; $313
        shl (1|M0)               r2.6<1>:w     r1.4<0;1,0>:w     1:w                                 //  ALU pipe: int; $317
        add (1|M0)               r3.0<1>:q     r5.2<0;1,0>:q     r1.2<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $314
        cmp (1|M0)    (eq)f3.0   null<1>:d     r5.9<0;1,0>:d     r5.7<0;1,0>:d                       //  ALU pipe: int; $324
        load.ugm.d32x64t.a64 (1|M0)  r7:4       [r3:1]             {I@2,$9} // ex_desc:0x0; desc:0x240F580 // $316
        add (1|M0)               a0.0<1>:uw    r2.6<0;1,0>:uw    0x1380:uw              {A@1}        //  ALU pipe: int; $318
(f3.0)  cmp (1|M0)    (eq)f3.0   null<1>:d     r5.8<0;1,0>:d     r5.6<0;1,0>:d                       //  ALU pipe: int; $325
        mov (32|M0)              r[a0.0]<1>:uw  r7.0<1;1,0>:uw                  {$9.dst}             //  ALU pipe: int; $319
        mov (32|M0)              r[a0.0,64]<1>:uw  r8.0<1;1,0>:uw                                    //  ALU pipe: int; $320
        mov (32|M0)              r[a0.0,128]<1>:uw  r9.0<1;1,0>:uw                                   //  ALU pipe: int; $321
        mov (32|M0)              r[a0.0,192]<1>:uw  r10.0<1;1,0>:uw                                  //  ALU pipe: int; $322
(W&~f3.0) jmpi                               BB_13                                                   //  ALU pipe: int; $327
// B021: Preds:{B020, B018, B017},  Succs:{B042}
BB_12:
        load.ugm.d64.a64 (1|M0)   r8:2          [r4:2]             {A@3,$15} // ex_desc:0x0; desc:0x4200780 // $330
        shl (1|M0)               r1.2<1>:d     r5.2<0;1,0>:d     11:w               {Compacted}      //  ALU pipe: int; $331
        sync.nop                             null                             {Compacted,I@3}        // $350
        sync.nop                             null                             {Compacted,$3.src}     // $350
        mov (32|M0)              r111.0<1>:uw  r106.0<1;1,0>:uw                 {$13.dst}            //  ALU pipe: int; $350
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     r123.0<0;1,0>:d  {Compacted,I@2}    //  ALU pipe: int; $332
        mov (32|M0)              r112.0<1>:hf  r107.0<1;1,0>:hf                                      //  ALU pipe: float; $351
        shl (1|M0)               r2.7<1>:q     r1.2<0;1,0>:ud    1:w               {I@1}             //  ALU pipe: int; $334
        mov (32|M0)              r113.0<1>:hf  r108.0<1;1,0>:hf                                      //  ALU pipe: float; $352
        mov (32|M0)              r114.0<1>:hf  r109.0<1;1,0>:hf                                      //  ALU pipe: float; $353
        sync.nop                             null                             {Compacted,I@1}        // $335
        add (1|M0)               r2.0<1>:q     r8.0<0;1,0>:q     r2.7<0;1,0>:q    {Compacted,$15.dst} //  ALU pipe: int; $335
        sync.nop                             null                             {Compacted,I@1}        // $337
        add (1|M0)               r3.0<1>:uq    r2.0<0;1,0>:uq    0x100:uw              {$4.src}      //  ALU pipe: int; $337
        add (1|M0)               r7.0<1>:uq    r2.0<0;1,0>:uq    0x200:uw              {$5.src}      //  ALU pipe: int; $339
        add (1|M0)               r9.0<1>:uq    r2.0<0;1,0>:uq    0x300:uw                            //  ALU pipe: int; $341
        sync.allrd                           ($8,$10)                 {Compacted}                    // $343
        add (1|M0)               r10.0<1>:uq   r2.0<0;1,0>:uq    0x400:uw              {$13.src}     //  ALU pipe: int; $343
        add (1|M0)               r11.0<1>:uq   r2.0<0;1,0>:uq    0x500:uw              {$14.src}     //  ALU pipe: int; $345
        add (1|M0)               r8.0<1>:uq    r2.0<0;1,0>:uq    0x600:uw                            //  ALU pipe: int; $347
        store.ugm.d32x64t.a64 (1|M0)  [r2:1]    r78:4              {$4} // ex_desc:0x0; desc:0x200F584 // $336
        sync.nop                             null                             {Compacted,$5.dst}     // $338
        store.ugm.d32x64t.a64 (1|M0)  [r3:1]    r82:4              {I@6,$1} // ex_desc:0x0; desc:0x200F584 // $338
        sync.nop                             null                             {Compacted,$12.dst}    // $340
        store.ugm.d32x64t.a64 (1|M0)  [r7:1]    r86:4              {I@5,$11} // ex_desc:0x0; desc:0x200F584 // $340
        sync.nop                             null                             {Compacted,$6.dst}     // $342
        store.ugm.d32x64t.a64 (1|M0)  [r9:1]    r90:4              {I@4,$5} // ex_desc:0x0; desc:0x200F584 // $342
        sync.nop                             null                             {Compacted,$8.dst}     // $344
        store.ugm.d32x64t.a64 (1|M0)  [r10:1]   r94:4              {I@3,$7} // ex_desc:0x0; desc:0x200F584 // $344
        sync.nop                             null                             {Compacted,$10.dst}    // $346
        store.ugm.d32x64t.a64 (1|M0)  [r11:1]   r98:4              {I@2,$4} // ex_desc:0x0; desc:0x200F584 // $346
        sync.nop                             null                             {Compacted,$11.dst}    // $348
        store.ugm.d32x64t.a64 (1|M0)  [r8:1]    r102:4             {I@1,$6} // ex_desc:0x0; desc:0x200F584 // $348
        add (1|M0)               r2.0<1>:uq    r2.0<0;1,0>:uq    0x700:uw              {$4.src}      //  ALU pipe: int; $349
(W)     jmpi                                 BB_10                                                   // $354
// B022: Preds:{B006},  Succs:{B023, B024}
BB_4:
        add (1|M0)               r2.0<1>:d     r5.2<0;1,0>:d     r2.13<0;1,0>:d                      //  ALU pipe: int; $356
        mul (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     768:w               {Compacted,I@1} //  ALU pipe: int; $357
        add (1|M0)               r1.2<1>:d     r2.0<0;1,0>:d     768:w               {Compacted,I@1} //  ALU pipe: int; $358
        mov (1|M0)               r5.2<1>:q     r2.0<0;1,0>:ud                                        //  ALU pipe: int; $359
        cmp (1|M0)    (gt)f3.1   null<1>:ud    r1.2<0;1,0>:ud    r2.12<0;1,0>:ud  {I@2}              //  ALU pipe: int; $360
(W&f3.1) jmpi                                BB_14                                                   //  ALU pipe: int; $361
// B023: Preds:{B022},  Succs:{B027}
_L_k1_11_:
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted,I@3}   //  ALU pipe: int; $362
        add (1|M0)               r3.0<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $363
        add (1|M0)               r7.0<1>:uq    r3.0<0;1,0>:uq    0x100:uw              {I@1}         //  ALU pipe: int; $365
        add (1|M0)               r8.0<1>:uq    r3.0<0;1,0>:uq    0x200:uw                            //  ALU pipe: int; $367
        add (1|M0)               r9.0<1>:uq    r3.0<0;1,0>:uq    0x300:uw                            //  ALU pipe: int; $369
        sync.allrd                           ($3,$7,$10)                 {Compacted}                 // $371
        add (1|M0)               r10.0<1>:uq   r3.0<0;1,0>:uq    0x400:uw              {$13.src}     //  ALU pipe: int; $371
        sync.nop                             null                             {Compacted,$4.src}     // $373
        add (1|M0)               r11.0<1>:uq   r3.0<0;1,0>:uq    0x500:uw              {$14.src}     //  ALU pipe: int; $373
        load.ugm.d32x64t.a64 (1|M0)  r12:4      [r3:1]             {$3} // ex_desc:0x0; desc:0x240F580 // $364
        load.ugm.d32x64t.a64 (1|M0)  r16:4      [r7:1]             {I@5,$14} // ex_desc:0x0; desc:0x240F580 // $366
        load.ugm.d32x64t.a64 (1|M0)  r20:4      [r8:1]             {I@4,$2} // ex_desc:0x0; desc:0x240F580 // $368
        load.ugm.d32x64t.a64 (1|M0)  r24:4      [r9:1]             {I@3,$0} // ex_desc:0x0; desc:0x240F580 // $370
        load.ugm.d32x64t.a64 (1|M0)  r28:4      [r10:1]            {I@2,$10} // ex_desc:0x0; desc:0x240F580 // $372
        load.ugm.d32x64t.a64 (1|M0)  r32:4      [r11:1]            {I@1,$1} // ex_desc:0x0; desc:0x240F580 // $374
(W)     jmpi                                 BB_15                                                   // $375
// B024: Preds:{B022},  Succs:{B025, B027}
BB_14:
        add (1|M0)               r2.0<1>:d     r4.3<0;1,0>:d     -r2.0<0;1,0>:d                      //  ALU pipe: int; $377
        sync.nop                             null                             {Compacted,$0.src}     // $380
        mov (32|M0)              r12.0<1>:d    0:w                               {Compacted,$14.src} //  ALU pipe: int; $380
        cmp (1|M0)    (lt)f3.0   null<1>:ud    r2.0<0;1,0>:ud    0x80:uw              {I@2}          //  ALU pipe: int; $392
        mov (32|M0)              r14.0<1>:d    0:w                               {Compacted,$15.src} //  ALU pipe: int; $381
        mov (32|M0)              r16.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $382
        mov (32|M0)              r18.0<1>:d    0:w                               {Compacted,$1.src}  //  ALU pipe: int; $383
        mov (32|M0)              r20.0<1>:d    0:w                               {Compacted,$2.src}  //  ALU pipe: int; $384
        mov (32|M0)              r22.0<1>:d    0:w                               {Compacted,$13.src} //  ALU pipe: int; $385
        mov (32|M0)              r24.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $386
        mov (32|M0)              r26.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $387
        mov (32|M0)              r28.0<1>:d    0:w                               {Compacted,$10.src} //  ALU pipe: int; $388
        mov (32|M0)              r30.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $389
        mov (32|M0)              r32.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $390
        mov (32|M0)              r34.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $391
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted}       //  ALU pipe: int; $378
        add (1|M0)               r5.2<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $379
(W&f3.0) jmpi                                BB_15                                                   //  ALU pipe: int; $393
// B025: Preds:{B024},  Succs:{B026}
_L_k1_12_:
        mov (1|M0)               r5.3<1>:q     0:w                                                   //  ALU pipe: int; $394
// B026: Preds:{B026, B025},  Succs:{B027, B026}
BB_16:
        shl (1|M0)               r1.1<1>:q     r5.3<0;1,0>:q     7:w               {I@1}             //  ALU pipe: int; $396
        add (1|M0)               r5.3<1>:q     r5.3<0;1,0>:q     1:w                                 //  ALU pipe: int; $407
        shl (1|M0)               r1.2<1>:q     r1.1<0;1,0>:q     1:w               {I@2}             //  ALU pipe: int; $397
        shl (1|M0)               r2.6<1>:w     r1.4<0;1,0>:w     1:w                                 //  ALU pipe: int; $401
        add (1|M0)               r3.0<1>:q     r5.2<0;1,0>:q     r1.2<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $398
        cmp (1|M0)    (eq)f2.1   null<1>:d     r5.7<0;1,0>:d     r5.9<0;1,0>:d                       //  ALU pipe: int; $408
        load.ugm.d32x64t.a64 (1|M0)  r7:4       [r3:1]             {I@2,$9} // ex_desc:0x0; desc:0x240F580 // $400
        add (1|M0)               a0.0<1>:uw    r2.6<0;1,0>:uw    0x300:uw              {A@1}         //  ALU pipe: int; $402
(f2.1)  cmp (1|M0)    (eq)f2.1   null<1>:d     r5.6<0;1,0>:d     r5.8<0;1,0>:d                       //  ALU pipe: int; $409
        mov (32|M0)              r[a0.0]<1>:uw  r7.0<1;1,0>:uw                  {$9.dst}             //  ALU pipe: int; $403
        mov (32|M0)              r[a0.0,64]<1>:uw  r8.0<1;1,0>:uw                                    //  ALU pipe: int; $404
        mov (32|M0)              r[a0.0,128]<1>:uw  r9.0<1;1,0>:uw                                   //  ALU pipe: int; $405
        mov (32|M0)              r[a0.0,192]<1>:uw  r10.0<1;1,0>:uw                                  //  ALU pipe: int; $406
(W&~f2.1) jmpi                               BB_16                                                   //  ALU pipe: int; $411
// B027: Preds:{B026, B024, B023},  Succs:{B042}
BB_15:
        load.ugm.d64.a64 (1|M0)   r8:2          [r4:2]             {A@3,$15} // ex_desc:0x0; desc:0x4200780 // $414
        mul (1|M0)               r1.2<1>:d     r5.2<0;1,0>:d     1536:w               {Compacted}    //  ALU pipe: int; $415
        sync.nop                             null                             {Compacted,I@3}        // $430
        sync.nop                             null                             {Compacted,$3.src}     // $430
        mov (32|M0)              r111.0<1>:uw  r32.0<1;1,0>:uw                  {$1.dst}             //  ALU pipe: int; $430
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     r123.0<0;1,0>:d  {Compacted,I@2}    //  ALU pipe: int; $416
        mov (32|M0)              r112.0<1>:hf  r33.0<1;1,0>:hf                                       //  ALU pipe: float; $431
        shl (1|M0)               r2.7<1>:q     r1.2<0;1,0>:ud    1:w               {I@1}             //  ALU pipe: int; $418
        mov (32|M0)              r113.0<1>:hf  r34.0<1;1,0>:hf                                       //  ALU pipe: float; $432
        mov (32|M0)              r114.0<1>:hf  r35.0<1;1,0>:hf                                       //  ALU pipe: float; $433
        sync.nop                             null                             {Compacted,I@1}        // $419
        add (1|M0)               r2.0<1>:q     r8.0<0;1,0>:q     r2.7<0;1,0>:q    {Compacted,$15.dst} //  ALU pipe: int; $419
        sync.nop                             null                             {Compacted,I@1}        // $421
        add (1|M0)               r3.0<1>:uq    r2.0<0;1,0>:uq    0x100:uw                            //  ALU pipe: int; $421
        add (1|M0)               r7.0<1>:uq    r2.0<0;1,0>:uq    0x200:uw              {$14.src}     //  ALU pipe: int; $423
        add (1|M0)               r9.0<1>:uq    r2.0<0;1,0>:uq    0x300:uw                            //  ALU pipe: int; $425
        sync.nop                             null                             {Compacted,$10.src}    // $427
        add (1|M0)               r10.0<1>:uq   r2.0<0;1,0>:uq    0x400:uw              {$7.src}      //  ALU pipe: int; $427
        store.ugm.d32x64t.a64 (1|M0)  [r2:1]    r12:4              {$3} // ex_desc:0x0; desc:0x200F584 // $420
        sync.nop                             null                             {Compacted,$14.dst}    // $422
        store.ugm.d32x64t.a64 (1|M0)  [r3:1]    r16:4              {I@4,$12} // ex_desc:0x0; desc:0x200F584 // $422
        sync.nop                             null                             {Compacted,$2.dst}     // $424
        store.ugm.d32x64t.a64 (1|M0)  [r7:1]    r20:4              {I@3,$13} // ex_desc:0x0; desc:0x200F584 // $424
        sync.nop                             null                             {Compacted,$0.dst}     // $426
        store.ugm.d32x64t.a64 (1|M0)  [r9:1]    r24:4              {I@2,$8} // ex_desc:0x0; desc:0x200F584 // $426
        store.ugm.d32x64t.a64 (1|M0)  [r10:1]   r28:4              {I@1,$10} // ex_desc:0x0; desc:0x200F584 // $428
        add (1|M0)               r2.0<1>:uq    r2.0<0;1,0>:uq    0x500:uw              {$3.src}      //  ALU pipe: int; $429
(W)     jmpi                                 BB_10                                                   // $434
// B028: Preds:{B005},  Succs:{B029, B036}
BB_3:
        cmp (1|M0)    (eq)f2.1   null<1>:d     r4.5<0;1,0>:d     2:w                                 //  ALU pipe: int; $436
(W&f2.1) jmpi                                BB_17                                                   //  ALU pipe: int; $437
// B029: Preds:{B028},  Succs:{B030, B043}
_L_k1_13_:
        cmp (1|M0)    (eq)f2.0   null<1>:d     r4.5<0;1,0>:d     0:w                                 //  ALU pipe: int; $438
(W&~f2.0) jmpi                               BB_6                                                    //  ALU pipe: int; $439
// B030: Preds:{B029},  Succs:{B031, B032}
_L_k1_14_:
        add (1|M0)               r2.0<1>:d     r5.2<0;1,0>:d     r2.13<0;1,0>:d                      //  ALU pipe: int; $440
        shl (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     8:w               {Compacted,I@1}   //  ALU pipe: int; $441
        add (1|M0)               r1.2<1>:d     r2.0<0;1,0>:d     256:w               {Compacted,I@1} //  ALU pipe: int; $442
        mov (1|M0)               r5.2<1>:q     r2.0<0;1,0>:ud                                        //  ALU pipe: int; $443
        cmp (1|M0)    (gt)f1.1   null<1>:ud    r1.2<0;1,0>:ud    r2.12<0;1,0>:ud  {I@2}              //  ALU pipe: int; $444
(W&f1.1) jmpi                                BB_18                                                   //  ALU pipe: int; $445
// B031: Preds:{B030},  Succs:{B035}
_L_k1_15_:
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted,I@3}   //  ALU pipe: int; $446
        add (1|M0)               r3.0<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $447
        add (1|M0)               r7.0<1>:uq    r3.0<0;1,0>:uq    0x100:uw              {I@1}         //  ALU pipe: int; $449
        load.ugm.d32x64t.a64 (1|M0)  r115:4     [r3:1]             {$11} // ex_desc:0x0; desc:0x240F580 // $448
        load.ugm.d32x64t.a64 (1|M0)  r119:4     [r7:1]             {I@1,$5} // ex_desc:0x0; desc:0x240F580 // $450
(W)     jmpi                                 BB_19                                                   // $451
// B032: Preds:{B030},  Succs:{B033, B035}
BB_18:
        add (1|M0)               r2.0<1>:d     r4.3<0;1,0>:d     -r2.0<0;1,0>:d                      //  ALU pipe: int; $453
        mov (32|M0)              r115.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $456
        cmp (1|M0)    (lt)f1.0   null<1>:ud    r2.0<0;1,0>:ud    0x80:uw              {I@2}          //  ALU pipe: int; $460
        mov (32|M0)              r117.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $457
        mov (32|M0)              r119.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $458
        mov (32|M0)              r121.0<1>:d   0:w                               {Compacted}         //  ALU pipe: int; $459
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted}       //  ALU pipe: int; $454
        add (1|M0)               r5.2<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $455
(W&f1.0) jmpi                                BB_19                                                   //  ALU pipe: int; $461
// B033: Preds:{B032},  Succs:{B034}
_L_k1_16_:
        mov (1|M0)               r5.3<1>:q     0:w                                                   //  ALU pipe: int; $462
// B034: Preds:{B034, B033},  Succs:{B035, B034}
BB_20:
        shl (1|M0)               r1.1<1>:q     r5.3<0;1,0>:q     7:w               {I@1}             //  ALU pipe: int; $464
        add (1|M0)               r5.3<1>:q     r5.3<0;1,0>:q     1:w                                 //  ALU pipe: int; $475
        shl (1|M0)               r1.2<1>:q     r1.1<0;1,0>:q     1:w               {I@2}             //  ALU pipe: int; $465
        shl (1|M0)               r2.6<1>:w     r1.4<0;1,0>:w     1:w                                 //  ALU pipe: int; $469
        add (1|M0)               r3.0<1>:q     r5.2<0;1,0>:q     r1.2<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $466
        cmp (1|M0)    (eq)f2.0   null<1>:d     r5.7<0;1,0>:d     r5.13<0;1,0>:d                      //  ALU pipe: int; $476
        load.ugm.d32x64t.a64 (1|M0)  r7:4       [r3:1]             {I@2,$4} // ex_desc:0x0; desc:0x240F580 // $468
        add (1|M0)               a0.0<1>:uw    r2.6<0;1,0>:uw    0x1CC0:uw              {A@1}        //  ALU pipe: int; $470
(f2.0)  cmp (1|M0)    (eq)f2.0   null<1>:d     r5.6<0;1,0>:d     r5.12<0;1,0>:d                      //  ALU pipe: int; $477
        mov (32|M0)              r[a0.0]<1>:uw  r7.0<1;1,0>:uw                  {$4.dst}             //  ALU pipe: int; $471
        mov (32|M0)              r[a0.0,64]<1>:uw  r8.0<1;1,0>:uw                                    //  ALU pipe: int; $472
        mov (32|M0)              r[a0.0,128]<1>:uw  r9.0<1;1,0>:uw                                   //  ALU pipe: int; $473
        mov (32|M0)              r[a0.0,192]<1>:uw  r10.0<1;1,0>:uw                                  //  ALU pipe: int; $474
(W&~f2.0) jmpi                               BB_20                                                   //  ALU pipe: int; $479
// B035: Preds:{B034, B032, B031},  Succs:{B042}
BB_19:
        load.ugm.d64.a64 (1|M0)   r8:2          [r4:2]             {A@3,$6} // ex_desc:0x0; desc:0x4200780 // $482
        shl (1|M0)               r1.2<1>:d     r5.2<0;1,0>:d     9:w               {Compacted}       //  ALU pipe: int; $483
        sync.nop                             null                             {Compacted,I@3}        // $490
        sync.nop                             null                             {Compacted,$3.src}     // $490
        mov (32|M0)              r111.0<1>:uw  r119.0<1;1,0>:uw                 {$5.dst}             //  ALU pipe: int; $490
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     r123.0<0;1,0>:d  {Compacted,I@2}    //  ALU pipe: int; $484
        mov (32|M0)              r112.0<1>:hf  r120.0<1;1,0>:hf                                      //  ALU pipe: float; $491
        shl (1|M0)               r2.7<1>:q     r1.2<0;1,0>:ud    1:w               {I@1}             //  ALU pipe: int; $486
        mov (32|M0)              r113.0<1>:hf  r121.0<1;1,0>:hf                                      //  ALU pipe: float; $492
        mov (32|M0)              r114.0<1>:hf  r122.0<1;1,0>:hf                                      //  ALU pipe: float; $493
        sync.nop                             null                             {Compacted,I@1}        // $487
        add (1|M0)               r2.0<1>:q     r8.0<0;1,0>:q     r2.7<0;1,0>:q    {Compacted,$6.dst} //  ALU pipe: int; $487
        store.ugm.d32x64t.a64 (1|M0)  [r2:1]    r115:4             {I@1,$11} // ex_desc:0x0; desc:0x200F584 // $488
        add (1|M0)               r2.0<1>:uq    r2.0<0;1,0>:uq    0x100:uw              {$11.src}     //  ALU pipe: int; $489
(W)     jmpi                                 BB_10                                                   // $494
// B036: Preds:{B028},  Succs:{B037, B038}
BB_17:
        add (1|M0)               r2.0<1>:d     r5.2<0;1,0>:d     r2.13<0;1,0>:d                      //  ALU pipe: int; $496
        shl (1|M0)               r2.0<1>:d     r2.0<0;1,0>:d     9:w               {Compacted,I@1}   //  ALU pipe: int; $497
        add (1|M0)               r1.2<1>:d     r2.0<0;1,0>:d     512:w               {Compacted,I@1} //  ALU pipe: int; $498
        mov (1|M0)               r5.2<1>:q     r2.0<0;1,0>:ud                                        //  ALU pipe: int; $499
        cmp (1|M0)    (gt)f0.1   null<1>:ud    r1.2<0;1,0>:ud    r2.12<0;1,0>:ud  {I@2}              //  ALU pipe: int; $500
(W&f0.1) jmpi                                BB_21                                                   //  ALU pipe: int; $501
// B037: Preds:{B036},  Succs:{B041}
_L_k1_17_:
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted,I@3}   //  ALU pipe: int; $502
        add (1|M0)               r3.0<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $503
        add (1|M0)               r7.0<1>:uq    r3.0<0;1,0>:uq    0x100:uw              {I@1}         //  ALU pipe: int; $505
        add (1|M0)               r8.0<1>:uq    r3.0<0;1,0>:uq    0x200:uw                            //  ALU pipe: int; $507
        add (1|M0)               r9.0<1>:uq    r3.0<0;1,0>:uq    0x300:uw                            //  ALU pipe: int; $509
        load.ugm.d32x64t.a64 (1|M0)  r36:4      [r3:1]             {$2} // ex_desc:0x0; desc:0x240F580 // $504
        load.ugm.d32x64t.a64 (1|M0)  r40:4      [r7:1]             {I@3,$0} // ex_desc:0x0; desc:0x240F580 // $506
        load.ugm.d32x64t.a64 (1|M0)  r44:4      [r8:1]             {I@2,$1} // ex_desc:0x0; desc:0x240F580 // $508
        load.ugm.d32x64t.a64 (1|M0)  r48:4      [r9:1]             {I@1,$15} // ex_desc:0x0; desc:0x240F580 // $510
(W)     jmpi                                 BB_22                                                   // $511
// B038: Preds:{B036},  Succs:{B039, B041}
BB_21:
        add (1|M0)               r2.0<1>:d     r4.3<0;1,0>:d     -r2.0<0;1,0>:d                      //  ALU pipe: int; $513
        mov (32|M0)              r36.0<1>:d    0:w                               {Compacted,$3.src}  //  ALU pipe: int; $516
        cmp (1|M0)    (lt)f0.0   null<1>:ud    r2.0<0;1,0>:ud    0x80:uw              {I@2}          //  ALU pipe: int; $524
        mov (32|M0)              r38.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $517
        mov (32|M0)              r40.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $518
        mov (32|M0)              r42.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $519
        mov (32|M0)              r44.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $520
        mov (32|M0)              r46.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $521
        mov (32|M0)              r48.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $522
        mov (32|M0)              r50.0<1>:d    0:w                               {Compacted}         //  ALU pipe: int; $523
        shl (1|M0)               r5.2<1>:q     r5.2<0;1,0>:q     1:w               {Compacted}       //  ALU pipe: int; $514
        add (1|M0)               r5.2<1>:q     r110.0<0;1,0>:q   r5.2<0;1,0>:q    {Compacted,I@1}    //  ALU pipe: int; $515
(W&f0.0) jmpi                                BB_22                                                   //  ALU pipe: int; $525
// B039: Preds:{B038},  Succs:{B040}
_L_k1_18_:
        mov (1|M0)               r5.3<1>:q     0:w                                                   //  ALU pipe: int; $526
// B040: Preds:{B040, B039},  Succs:{B041, B040}
BB_23:
        shl (1|M0)               r1.1<1>:q     r5.3<0;1,0>:q     7:w               {I@1}             //  ALU pipe: int; $528
        add (1|M0)               r5.3<1>:q     r5.3<0;1,0>:q     1:w                                 //  ALU pipe: int; $539
        shl (1|M0)               r1.2<1>:q     r1.1<0;1,0>:q     1:w               {I@2}             //  ALU pipe: int; $529
        shl (1|M0)               r2.6<1>:w     r1.4<0;1,0>:w     1:w                                 //  ALU pipe: int; $533
        add (1|M0)               r3.0<1>:q     r5.2<0;1,0>:q     r1.2<0;1,0>:q    {Compacted,I@2}    //  ALU pipe: int; $530
        cmp (1|M0)    (eq)f1.1   null<1>:d     r5.7<0;1,0>:d     r5.11<0;1,0>:d                      //  ALU pipe: int; $540
        load.ugm.d32x64t.a64 (1|M0)  r7:4       [r3:1]             {I@2,$3} // ex_desc:0x0; desc:0x240F580 // $532
        add (1|M0)               a0.0<1>:uw    r2.6<0;1,0>:uw    0x900:uw              {A@1}         //  ALU pipe: int; $534
(f1.1)  cmp (1|M0)    (eq)f1.1   null<1>:d     r5.6<0;1,0>:d     r5.10<0;1,0>:d                      //  ALU pipe: int; $541
        mov (32|M0)              r[a0.0]<1>:uw  r7.0<1;1,0>:uw                  {$3.dst}             //  ALU pipe: int; $535
        mov (32|M0)              r[a0.0,64]<1>:uw  r8.0<1;1,0>:uw                                    //  ALU pipe: int; $536
        mov (32|M0)              r[a0.0,128]<1>:uw  r9.0<1;1,0>:uw                                   //  ALU pipe: int; $537
        mov (32|M0)              r[a0.0,192]<1>:uw  r10.0<1;1,0>:uw                                  //  ALU pipe: int; $538
(W&~f1.1) jmpi                               BB_23                                                   //  ALU pipe: int; $543
// B041: Preds:{B040, B038, B037},  Succs:{B042}
BB_22:
        load.ugm.d64.a64 (1|M0)   r8:2          [r4:2]             {A@3,$12} // ex_desc:0x0; desc:0x4200780 // $546
        shl (1|M0)               r1.2<1>:d     r5.2<0;1,0>:d     10:w               {Compacted}      //  ALU pipe: int; $547
        sync.nop                             null                             {Compacted,I@3}        // $558
        sync.nop                             null                             {Compacted,$3.src}     // $558
        mov (32|M0)              r111.0<1>:uw  r48.0<1;1,0>:uw                  {$15.dst}            //  ALU pipe: int; $558
        add (1|M0)               r1.2<1>:d     r1.2<0;1,0>:d     r123.0<0;1,0>:d  {Compacted,I@2}    //  ALU pipe: int; $548
        mov (32|M0)              r112.0<1>:hf  r49.0<1;1,0>:hf                                       //  ALU pipe: float; $559
        shl (1|M0)               r2.7<1>:q     r1.2<0;1,0>:ud    1:w               {I@1}             //  ALU pipe: int; $550
        mov (32|M0)              r113.0<1>:hf  r50.0<1;1,0>:hf                                       //  ALU pipe: float; $560
        mov (32|M0)              r114.0<1>:hf  r51.0<1;1,0>:hf                                       //  ALU pipe: float; $561
        sync.nop                             null                             {Compacted,I@1}        // $551
        add (1|M0)               r2.0<1>:q     r8.0<0;1,0>:q     r2.7<0;1,0>:q    {Compacted,$12.dst} //  ALU pipe: int; $551
        sync.nop                             null                             {Compacted,I@1}        // $553
        add (1|M0)               r3.0<1>:uq    r2.0<0;1,0>:uq    0x100:uw              {$2.src}      //  ALU pipe: int; $553
        add (1|M0)               r7.0<1>:uq    r2.0<0;1,0>:uq    0x200:uw              {$0.src}      //  ALU pipe: int; $555
        store.ugm.d32x64t.a64 (1|M0)  [r2:1]    r36:4              {$2} // ex_desc:0x0; desc:0x200F584 // $552
        sync.nop                             null                             {Compacted,$0.dst}     // $554
        store.ugm.d32x64t.a64 (1|M0)  [r3:1]    r40:4              {I@2,$9} // ex_desc:0x0; desc:0x200F584 // $554
        sync.nop                             null                             {Compacted,$1.dst}     // $556
        store.ugm.d32x64t.a64 (1|M0)  [r7:1]    r44:4              {I@1,$14} // ex_desc:0x0; desc:0x200F584 // $556
        add (1|M0)               r2.0<1>:uq    r2.0<0;1,0>:uq    0x300:uw              {$2.src}      //  ALU pipe: int; $557
// B042: Preds:{B041, B035, B027, B021, B014},  Succs:{B043}
BB_10:
        store.ugm.d32x64t.a64 (1|M0)  [r2:1]    r111:4             {A@1,$7} // ex_desc:0x0; desc:0x200F584 // $563
// B043: Preds:{B042, B029, B015, B008},  Succs:{B044, B004}
BB_6:
        add (1|M0)               r4.5<1>:q     r4.5<0;1,0>:q     1:w                                 //  ALU pipe: int; $565
        add (1|M0)               r4.12<1>:ud   r4.12<0;1,0>:ud   0xFF900000:ud                       //  ALU pipe: int; $569
        cmp (1|M0)    (eq)f1.0   null<1>:d     r4.11<0;1,0>:d    r4.9<0;1,0>:d    {I@2}              //  ALU pipe: int; $566
        add (1|M0)               r4.13<1>:ud   r4.13<0;1,0>:ud   0xFFC80000:ud                       //  ALU pipe: int; $570
        add (1|M0)               r4.14<1>:ud   r4.14<0;1,0>:ud   0xFFD60000:ud                       //  ALU pipe: int; $571
        add (1|M0)               r4.15<1>:ud   r4.15<0;1,0>:ud   0xFFE40000:ud                       //  ALU pipe: int; $572
(f1.0)  cmp (1|M0)    (eq)f1.0   null<1>:d     r4.10<0;1,0>:d    r4.8<0;1,0>:d                       //  ALU pipe: int; $567
        add (1|M0)               r5.0<1>:ud    r5.0<0;1,0>:ud    0xFFF20000:ud                       //  ALU pipe: int; $573
(W&~f1.0) jmpi                               BB_2                                                    //  ALU pipe: int; $574
// B044: Preds:{B043, B004, B002},  Succs:{}
BB_1:
(W)     mov (16|M0)              r127.0<1>:f   r0.0<1;1,0>:f                    {Compacted}          //  ALU pipe: float; $576
(W)     send.gtwy (1|M0)         null     r127    null:0  0x0            0x02000010           {EOT,F@1,$0} // wr:1+0, rd:0; end of thread // $576
L8168:
        nop                                                                                          // $576


//.BankConflicts: 0
//.ByteRMWs: 0
//


//.numALUInst: 479
//.accSubDef: 0
//.accSubUse: 0
//.accSubCandidateDef: 0
//.accSubCandidateUse: 0
//
//
//.singlePipeAtOneDistNum: 70
//.allAtOneDistNum: 12
//.syncInstCount: 54
//.tokenReuseCount: 72
//.AfterWriteTokenDepCount: 43
//.AfterReadTokenDepCount: 110
