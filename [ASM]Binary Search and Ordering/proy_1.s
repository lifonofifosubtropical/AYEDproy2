.section .data

nao:
	.asciz "%d\n"
nau:
	.asciz "%d"
str:
	.asciz "%s"
bad:
	.asciz "BADARGS\n"

.section .text
.globl main

main:
	push %rbp
	movq %rsp, %rbp

	lea array(%rip), %r15 #la dirección del arreglo se guarda en r15

	#Verificar que hay un argumento de linea de comandos.
	# Es decir, ARGC debe ser igual a 2.
	cmpl $2, %edi
	jne BA

	# Guardar ARGV[1] en %rcx.
	movq 8(%rsi), %rdi
	xorl %eax, %eax

	call atoi@plt

	movq %rax, %rcx

	#guardar tamaño en r10

	movl length(%rip), %r10d

	movl stride(%rip), %r14d

	xor %r8, %r8


ordenamiento: 

	movq $-1, %r8 

	fori:

		incq %r8
		cmpq %r10, %r8 #condición de parada
		jge BBin

		movq $-1, %r9
	forj:

		incq %r9
		cmpl %r10d, %r9d
		jge fori

		movl (%r15,%r9, 4), %eax
		cmpl (%r15,%r8, 4), %eax
		jle forj

		movl (%r15,%r8, 4), %r11d
		movl %eax, (%r15,%r8, 4)
		movl %r11d, (%r15,%r9, 4)

		jmp forj

BBin:
	#arr en r15
	#sup en r10
	#inf en r8
	#dato en rcx
	#iteraciones en r12

	xor %r12, %r12
	xor %r8, %r8

while: #while(inf<=sup)
	cmpl %r8d, %r10d
	jl ext
	
	#mit=(inf+sup)/2:

	movl %r8d, %ebx #mit en %rbx
	addl %r10d, %ebx
	sarl $1, %ebx
	
	if: #if (A[mit]==dato)
		cmpl (%r15, %rbx, 4), %ecx 
		jne if2

		leaq nao(%rip), %rdi
		movl (%r15, %rbx, 4), %esi
		xor %rax, %rax
		call printf@plt #Imprime el dato

		jmp found

	if2:	#if (A[mit]>dato)

		cmpl (%r15, %rbx, 4), %ecx 
		jge if3

		decl %ebx
		movl %ebx, %r10d #sup = mit - 1
		addl %r8d, %ebx	#mit = (inf+sup)/2
		sarl $1, %ebx
		incl %r12d
		jmp while

	if3:	#if(A[mit]<dato)
		cmpl (%r15, %rbx, 4), %ecx
		jle while

		incl %ebx
		movl %ebx,%r8d #inf = mit + 1
		addl %r10d, %ebx #mit = (inf+sup)/2
		sarl $1, %ebx
		incl %r12d
		jmp while

	ext:
		leaq nao(%rip), %rdi #No se encontró, imprime 0
		xor %rsi, %rsi
		xor %rax, %rax
		call printf@plt
		#numero de iteraciones:
		
		leaq nao(%rip), %rdi
		movq %r12, %rsi
		xor %rax, %rax
		call printf@plt
		
		leave
		ret

	BA:
		leaq str(%rip), %rdi
		leaq bad(%rip), %rsi
		xor %rax, %rax
		call printf@plt
		leave 
		ret

	found:
		#numero de iteraciones:

		leaq nao(%rip), %rdi
		movq %r12, %rsi
		xor %rax, %rax
		call printf@plt

		leave
		ret

