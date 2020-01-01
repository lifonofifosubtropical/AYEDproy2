.section .data

modo:   .asciz "rb"
modo1:  .asciz "w"
cad1:   .asciz "Ingrese ruta de archivo a decodificar: "
cad2:   .asciz "%s"
cad3:   .asciz "%d\n"
cad4:   .asciz "archivo inválido"
cad5:   .asciz "Ingrese nombre de archivo de salida:"
cad6:   .asciz "Desea decodificar otro archivo? S/N"
cad7:   .asciz "%c"
cad8:   .asciz "¡Hasta pronto!"
cad11:  .asciz "%c"
cad12:  .asciz "Respuesta inválida"
ascii: .byte -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1, -1, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1, -1, 26, 27, 28, 29, 30,31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1 

.section .bss

.comm nombreIn,255,1
.comm nombreOut,259,1
.comm char 1,1
.comm aux 4,8
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

    //Apertura de archivo entrada
    movq $nombreIn, %rdi
    leaq modo(%rip), %rsi
    xorq %rax, %rax
    call fopen
    movq %rax, filein(%rip)

    //Apertura archivo de salida 
    movq $nombreOut, %rdi
    leaq modo1(%rip), %rsi
    xorq %rax, %rax
    call fopen
    movq %rax, fileout(%rip)

    //total
    xorq %rbx, %rbx
    //contador
    xorq %r12, %r12

    //Obtener chars-------------------
for:

    movq filein(%rip), %rdi
    call fgetc
    movb %al, char(%rip)

    //Mientras no estemos en el fin de archivo:
    movq filein(%rip), %rdi
    call feof@plt
    cmpl $0, %eax
    jne end

    //Si el caracter no pertenece a la base 64 se ignora
    xorq %rax, %rax
    movb char(%rip), %al
    movb ascii(, %rax, 1), %al
    cmpb $-1, %al
    je if

    movl %eax, aux(, %r12, 4)
    incq %r12

//Cuando se hayan leído 4-------------
if:
    cmpq $4, %r12
    jne for 

    //cont
    xorq %r12, %r12

    //Se unen los bytes en el registro %rbx

    xorq %r10, %r10
    movl aux, %r10d
    shll $18, %r10d
    addl %r10d, %ebx

    incq %r12

    xorq %r10, %r10
    movl aux(,%r12,4), %r10d
    shll $12, %r10d
    addl %r10d, %ebx

    incq %r12

    xorq %r10, %r10
    movl aux(,%r12,4), %r10d
    shll $6, %r10d
    addl %r10d, %ebx

    incq %r12

    xorq %r10, %r10
    movl aux(,%r12,4), %r10d
    addl %r10d, %ebx

    //Imprimir los caracteres obtenidos de los 3 conjuntos de bytes

    movl %ebx, %ecx
    shrl $16, %ecx

    movl %ecx, %edi    
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc

    movl %ebx, %ecx
    shll $16, %ecx
    shrl $24, %ecx

    movl %ecx, %edi    
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc


    movl %ebx, %ecx
    shll $24, %ecx
    shrl $24, %ecx

    movl %ecx, %edi    
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc

    //Reiniciando contadores
    xorq %r12, %r12
    xorq %rbx, %rbx
    jmp for 

end:
	//Si no quedaron caracteres por evaluar, es decir, el número de bytes del archivo era múltiplo de 4, finaliza la codificación
    cmpq $0, %r12
    je close

    	//Si quedaron 12 bits:
        cmpq $2, %r12
        jne else

        xorq %rbx, %rbx
        xorq %r12, %r12

        xorq %r10, %r10
        movl aux, %r10d
        shll $6, %r10d
        addl %r10d, %ebx

        incq %r12

        xorq %r10, %r10
        movl aux(,%r12,4), %r10d
        addl %r10d, %ebx

        //imprime 6 bits más 2 0s

        movl %ebx, %ecx
        shrl $4, %ecx

        movl %ecx, %edi    
        movq fileout(%rip),%rsi   
        xorq %rax, %rax
        call fputc

        jmp close

//Si quedaron 3 conjuntos de 6 bits:
else:

    xorq %rbx, %rbx
    xorq %r12, %r12

    xorq %r10, %r10
    movl aux, %r10d
    shll $12, %r10d
    addl %r10d, %ebx

    incq %r12

    xorq %r10, %r10
    movl aux(,%r12,4), %r10d
    shll $6, %r10d
    addl %r10d, %ebx

    incq %r12

    xorq %r10, %r10
    movl aux(,%r12,4), %r10d
    addl %r10d, %ebx

    //imprime el primer byte contenido

    movl %ebx, %ecx
    shrl $10, %ecx

    movl %ecx, %edi
    movq fileout(%rip),%rsi   
    xorq %rax, %rax
    call fputc
    //Si el segundo no es 0 se imprime y se ignoran los bits desplazados
    movl %ebx, %ecx
    shrl $2, %ecx
    andl $255, %ecx

    cmpl $0, %ecx
    je close

    movl %ecx, %edi    
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

	//Si la respuesta es no salta a ext, en otro caso a elseif
if1:

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
