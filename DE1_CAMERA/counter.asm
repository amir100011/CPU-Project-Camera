.data
t0 : .word 0x00000000#init
t1 : .word 0x00000001



.text
lw $t1 , t1

counter:
	add $t0,$t0,$t1

inifinit: beq $zero,$zero,inifinit




   
