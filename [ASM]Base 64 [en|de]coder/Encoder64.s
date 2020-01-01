.section .data
modo:   .asciz "rb"
modo1:  .asciz "w"
add1:	.asciz ".b64"
cad1:   .asciz "Ingrese ruta de archivo a codificar: "
cad2:   .asciz "%s"
cad3:   .asciz "%d\n"
cad4:   .asciz "archivo inválido"
cad5:   .asciz "Ingrese nombre de archivo de salida:"
cad6:   .asciz "Desea codificar otro archivo? S/N"
cad7:   .asciz "%c"
cad8:   .asciz "¡Hasta pronto!"
cad9:	.asciz "=="
cad11:	.asciz "%c"
cad12:	.asciz "Respuesta inválida"
b64: .byte 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H','I', 'J', 'K','L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U','V', 'W', 'X','Y', 'Z', 'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '+', '/'

.section .bss
.comm nombreIn,255,1
.comm nombreOut,259,1
.comm char 1,1
.comm aux 3,1
.comm filein 8,8
.comm fileout 8,8

.section .text
.globl main
main:

    pushq %rbp
    movq %rsp, %rbp

    //Se solicita ruta de lectura
    movq $cad1, %rdi    
    xorq %rax, %rax
    call puts

    //Se lee la ruta de archivo
    movq $cad2, %rdi
    movq $nombreIn, %rsi
    xorq %rax, %rax
    call scanf

    //Validar ruta
    movq $nombreIn, %rdi
    movq $4, %rsi
    xorq %rax, %rax
    call access
    cmpq $0, %rax
    jne error

    //Solicitamos nombre de archivo de salida
    movq $cad5, %rdi    
    xorq %rax, %rax
    call puts

    //Recibimos nombre
    movq $cad2, %rdi
    movq $nombreOut, %rsi
    xorq %rax, %rax
    call scanf

    //Validar salida
    movq $nombreOut, %rdi
    movq $0, %rsi
    xorq %rax, %rax
    call access
    cmpb $0, %al 
    je error

    //Agregar extensión
    movq $nombreOut, %rdi
    movq $add1, %rsi
    xorq %rax, %rax
    call strcat

    //Apertura de archivo entrada
    movq $nombreIn, %rdi
    leaq modo(%rip), %rsi
    xorq %rax,%rax
    call fopen
    movq %rax, filein(%rip)

    //Apertura archivo de salida 
    movq $nombreOut, %rdi
    leaq modo1(%rip), %rsi
    xorq %rax, %rax
    call fopen
    movq %rax, fileout(%rip)

    //Contador para el for
    movq filein(%rip), %rdi
    movl $0, %esi
    movq $2, %rdx
    xorq %rax, %rax
    call fseek

    movq filein(%rip), %rdi
    xorq %rax, %rax
    call ftell
    //Condición de parada en rbx
    movq %rax, %rbx
    //Volviendo al inicio del archivo
    movq filein(%rip), %rdi
    xorq %rax, %rax
    call rewind

    //total
    xorq %r13, %r13
    //contador
    xorq %r12, %r12

    //Obtener letras-------------------
do:	   

	movq filein(%rip), %rdi
	xorq %rax, %rax
    call fgetc

    movb %al, aux(,%r12,1)
    incq %r12

    //Cuando se hayan leído 3-------------
    cmpq $3, %r12
    jne while
    movq %rbx, %r15

    xorq %rbx, %rbx
    xorq %rcx, %rcx
    //Se unen los bytes en el registro %rbx
    movb aux, %cl
    shll $16, %ecx
    addq %rcx, %rbx

    movq $1, %r12

    xorq %rcx, %rcx
    movb aux(,%r12,1), %cl
    shlq $8, %rcx
    addq %rcx, %rbx

    incq %r12
    
    xorq %rcx, %rcx
    movb aux(,%r12,1), %cl
    addq %rcx, %rbx

    //Imprimir los 4 caracteres obtenidos usando 6 bits como índice del arreglo b64

    movq %rbx, %rax
    shrq $18, %rax

    movl b64(,%rax,1), %edi
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc
    //máscaras para reducir los shifts
    movq %rbx, %rax
    andq $262143, %rax
    shrq $12, %rax

    movl b64(,%rax,1), %edi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc

    movq %rbx, %rax
    andq $4095, %rax
    shrq $6, %rax

    movl b64(,%rax,1), %edi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc

    movq %rbx, %rax
    andq $63, %rax

    movl b64(,%rax,1), %edi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc
    //Reiniciando contadores
	movq %r15, %rbx
    xorq %r12, %r12
    xorq %r13, %r13
//Si no se ha llegado al final del archivo iterar de nuevo (si %rbx no es 0)
while:
    decq %rbx
    jnz do
    //Si no quedaron caracteres por evaluar, es decir, el número de bytes del archivo era múltiplo de 3, finaliza la codificación
    cmpq $0, %r12
    je close

    //Si quedó un byte:
    cmpq $1, %r12
    jne else

    //Imprime los primeros 6 bits
    xorq %rcx, %rcx
    movb aux, %cl
    shrb $2, %cl

    movl b64(,%rcx,1), %edi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc
    //A los dos desplazados se les agregan 0s al final
    xorq %rcx, %rcx
    movb aux, %cl
    shlb $6, %cl
    andq $255, %rcx
    shrb $2, %cl

    movl b64(,%rcx,1), %edi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc
    //Imprime "=="
    movq $cad9, %rdi
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputs

    jmp close

else:
    //Si quedaron dos caracteres, se unen en %rbx
	xorq %rbx, %rbx
    xorq %rcx, %rcx
    movb aux, %cl
    shlw $8, %cx
    addq %rcx,%rbx

    movq $1, %rdx

    xorq %rcx, %rcx
    movb aux(,%rdx,1), %cl
    addb %cl, %bl

    //Se imprimen los 2 conjuntos de 6 bits contenidos en este 
    movq %rbx, %rax
    shrq $10, %rax
    movl b64(,%rax,1), %edi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc

    movq %rbx, %rax
    andq $1023, %rax
    shrq $4, %rax

    movl b64(,%rax,1), %edi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc

    //Se agregan los dos 0s faltantes a los 4 bits desplazados
    movq %rbx, %rax
    shlq $2, %rax
    andq $63, %rax

    movl b64(,%rax,1), %edi   
  	movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc
    //Se imprime el caracter "="
    movq $61, %rdi   
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc

//Cerrando archivos
close:
    movq filein(%rip), %rdi
    xorq %rax, %rax
    call fclose

    movq fileout(%rip), %rdi
    xorq %rax, %rax
    call fclose

	//flusheando stdin 

while2: 
	xorq %rax, %rax
	call getchar
	cmpq $10, %rax
	jne while2

	//Desea codificar otro?
	movq $cad6, %rdi
	xorq %rax, %rax
	call puts

	xorq %rax, %rax
	call getchar

if1:	
	//Si la respuesta es no salta a ext, en otro caso a elseif
	cmpq $78, %rax
	je ext
	cmpq $110, %rax
	je ext

	jmp elseif
ext:
	movq $cad8, %rdi
	xorq %rax, %rax
	call puts

	jmp quit

elseif:
//Si la respuesta es sí salta a main, si no imprime error
	cmpq $83, %rax
	je main
	cmpq $115, %rax
	je main

	movq $cad12, %rdi
	xorq %rax, %rax
	call puts

quit:
    xorq %rdi, %rdi
    call exit
error:
    movq $cad4, %rdi    
    xorq %rax, %rax
    call puts
    jmp quit
