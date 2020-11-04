@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
@Architectures and Operating Systems: Coursework 1
@File name: cw.s
@Description: Performs formatting methods to plain text and encryption and decryption methods to the formatted plain text message.
@StudentId (First student):
@StudentId (Second student): 100227317
@Last time modified: 11/11/2018
@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

.data
.balign 4
print_pk: .asciz "..Private key is:\t%s\n"
print_pk_len: .asciz "..Private key length:\t%d\n"
print_pt: .asciz "..Plain text is:\t"
print_pt_len: .asciz "\n..Plain text length:\t%d\n"
print_rows: .asciz "..Row(s) in matrix:\t%d\n"
print_filler: .asciz "..Filler(s) needed:\t%d\n"
print_matrix_element: .asciz "%c"
print_format_output: .asciz "Output:\t"
print_format_break: .asciz "\n\n"

chararray: .skip 1000
rows: .skip 1
columns: .skip 1
pt_len: .skip 1 @@just store in register 
filler_len: .skip 1


.text
.balign 4
.global main

main:
	PUSH {r4-r12, lr}		@Push r4-r12 and lr into the stack
	MOV r12, r0			@Move r0 into r4 (r0 contains argc)
	MOV r11, r1			@Move r1 into r5 (r1 contains argv)
	LDR r6, [r11, #8]		@load into r7, from standard input #8th word (private key value)
	@Printing Private key value
	@?????????????????DEBUGGING???????????????????????
	MOV r1, r6			@Move r7 into r1 (r1 now contains the private key string)
	LDR r0, adr_print_pk		@Load the address of "print_pk" into r0 (this will print the message)
	BL printf			@Executes the printf function (prints r0 and r1) (Branch with link)
	@??????????????????????????????????????????????????

    	@Printing Private key length
	MOV r7, #0                  	@Private key length counter
	lenPK:
        LDRB r0, [r6], #1       	@Loads into r0 then next char in the private key
        CMP r0, #0              	@If the next char in the private key exists, loop again
	ADDNE r7, r7, #1        	@Incremnet counter (+1)
	BNE lenPK			@???????????????
	LDR r8, =columns		@Load value of "columns" into r8
	STRB r7, [r8]              	@Store in colunm (r8), the private key length (r6)
	@?????????????????DEBUGGING???????????????????????
	LDR r0, adr_print_pk_len	@Load address of "print_pk_len" into r0
	MOV r1, r7			@Move r6 into r1 (r1 will print the private key length)
	BL printf			@Executes printf function (Branch with link)

	@Pushing index into the stack
    	MOV r4, #0 			@Move value 0 to r3 (Loop index)
	SUB sp, sp, r7, LSL #3		@??????????????????????????????

	stack_push_loop:
	CMP r7, r4			@Compare r6 and r3 (termination condition)
	BEQ exit_stack_push		@Branch when CMP is equals, to end1
		STRB r4, [sp, r4]	@Store value of r3 into sp + r3
		ADD r4, r4, #1		@Add 1 to value of r3 (r3 += 1)
		B stack_push_loop	@Branch back to start of loop
	exit_stack_push:

	@Bubble Sort
	@sort indices string at sp
	@String = cmd line input
	@Index = first cmd inpute i.e. the pk dragon
	@r1 -j
	@r2 - i
	@r6 - index[j]
	@r9 - index[j+1]
	@r0 - indexLength - 1
	@r7 - character base address for the string as previously
	@r6 - indexLenth as previously i.e. string length
	@r10 - j+1
	@r11 - string[index[j]]
	@r12 - string[j, 1]]
	LDR r6, [r11, #8] 			@address of cmd line string
	MOV r9, #0
    SUB r0, r7, #1

	firstloop:
	@for (1 = 0; i < indexLength; ++i)******
	CMP r7, r9 					@index i compared with string length
	BEQ exitfirstloop			@if index i = string lenght..
		MOV r1, #0				@set index j to 0

		secondloop:
		@*******for (j = 0; j < indexLength - 1; ++j)******
		CMP r0, r1				@index j compered to string length - 1
		BEQ exitsecondloop		@if index j = string length - 1
			@*******if (String[index[j]] > String[index[j+2]])*********
			LDRB r8, [sp, r1]	@load byte (char) in index j from array (sp)
			ADD r10, r1, #1		@calulate j+1
			LDRB r2, [sp, r10]	@load byte (char) in index j+1 from array (sp)
			LDRB r5, [r6, r8]	@get String[index[j]]
			LDRB r4, [r6, r2]	@get String[index[j+1]]

			CMP r5, r4
			BLE exitifstatement	@if String[index[j+1]] is greater
			@*******index[j] = temp********
			STRB r8, [sp, r10]
			@********index[j+1] = index[j]*******
			STRB r2, [sp, r1]
			exitifstatement:
			ADD r1, r1, #1
			B secondloop
		exitsecondloop:
		ADD r9, r9, #1
		B firstloop
	exitfirstloop:
	MOV r13, sp

   	@print from standard input (plain text) and store in chararry
	@r0 - char from standard input
	@r8 - chararray
	@r6 - char counter
	LDR r8, =chararray			@Load value of "chararray" into r8
	LDR r0, adr_print_pt		@Load the address of "print_pt" into r0
	BL printf					@Executes printf function

	MOV r7, #0					@char counter
	pt_loop:
	BL getchar					@str in r0 value of next char
	CMP r0, #-1					@Compare value in r0 with the value -1
	BEQ pt_exit					@If the next char is EOS, then exit loop
		CMP r0, #65				@Compare value in r0 with value 65
		BLT pt_loop				@If ascii value is less than 65, then ignore
		CMP r0, #122			@Compare value in r0 with value 122
		BGT pt_loop				@If ascii value is more than 122, then ignore
		CMP r0, #90				@Compare value in r0 with value 90
	        ADDLE r0, r0, #32	@acscii value to lowercase
		BLE exitcheck			@if ascii value was capital.. continue
            		CMP r0, #97	@Compare value in r0 with value 97
            		BLT pt_loop	@if the result is a 'special char'.. ignore
		exitcheck:
		ADD r7, r7, #1			@Add 1 to r6 and store answer to r6
		STRB r0, [r8], #1		@Store next char byte in r0 to chararray in r8 (post indexing)
		BL putchar				@Print char in standard output
		B pt_loop				@Branch back to pt_loop
	pt_exit:
	LDR r8, =pt_len				@Load value of "pt_len" into r8
	STRB r7, [r8]				@???????????????????????????????????????
	@?????????????????DEBUGGING???????????????????????
	LDR r0, adr_print_pt_len	@Load address of "print_pt_len" into r0
	MOV r1, r7					@Move r6 into r1 (length of plain text)
	BL printf					@Executes printf function
	@??????????????????????????????????????????????????

	@calulating rows (divison)
	@r6 - pt length
	@r2 - colunms - pk length
	@r1 - rows counter
	LDR r7, =pt_len				@Load value of "pt_len" into r7
	LDRB r6, [r7], #1			@???????????????????????????????????????
	LDR r3, =columns			@Load into r3 the value of "columns" (number of columns)
	LDRB r2, [r3], #1			@?????????????????????????????????????
	MOV r1, #0                  @Move the value 0 into r1 (loop index)
	divloop:
	CMP r6, #1					@Compare r6 with the value 0
	BLT div_exit				@If r6 is less than 0, then branch to div_exit
		SUB r6, r6, r2			@Subtract r2 from r6 and store answer to r6
		ADD r1, r1, #1          @Increments r1 by 1 (row +=1)
		B divloop				@Branch back to divloop
	div_exit:
	LDR r8, =rows				@Load value of "rows" into r8
	STRB r1, [r8]				@Store r1 into r8
	@?????????????????DEBUGGING???????????????????????
	LDR r0, adr_print_rows		@Load the address of "print_rows" into r0
	BL printf					@Executes the printf function
	@??????????????????????????????????????????????????
	MVN r1, r6					@????????????????????????????????????
	ADD r1, r1, #1				@Increments r1 by 1
	LDR r8, =filler_len			@Load value of "filler_len" into r8
	STRB r1, [r8]				@Store register byte r1 into r8
	@?????????????????DEBUGGING???????????????????????
	LDR r0, =print_filler		@Load value of "print_filler" into r0
	BL printf					@Execute printf function
	@??????????????????????????????????????????????????

	LDR r7, [r11, #4]
	LDRB r7, [r7] 
	CMP r7, #48
	BLEQ encrypt
	CMP r7, #49
	BLEQ decrypt

	add sp,sp,r6,lsl #3 @!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Pop indices from the stack
	POP {r4-r12, lr}			@Pop the registers out of the stack
	BX lr

	


decrypt: @ void (arr x) x = order of private key (columns) in sp.
	@Decrypts the encrypted text stored in chararry then prints the plain text via standard output.
	@R2 = private key (columns) order.
	@R3 = next char in plain text. 
	@R5 = loop index for loop_row, row offset value. 
	@R6 = number of columns in matrix.
	@R7 = number of rows in matrix.
	@r8 = chararray (chipher text).
	@R9 = loop index for loop_col_finder, used for comparing current colunm with sorted colunm order.
	@r10 = loop index for loop_col, used genterate colunm order for chiper text

	LDR r8,=chararray 
	ldr r6, =columns			@Load value of "columns" into r7
	ldrb r6, [r6]				@Load r6 into r7
	ldr r7, =rows				@Load value of "rows" into r7
	ldrb r7, [r7]				@Load value of r4 into r7
	MOV r5, #0
	LDR R0, =print_format_output
	BL printf
	loop_row:
	cmp r5, r7
	beq exit_loop_row	
		mov r9, #0
		loop_col_finder:		
		cmp r6, r9
		beq exit_col_finder		
			mov r10, #0 
			loop_col:
			cmp r6, r10
			beq exit_loop_col
				ldrb r2, [sp, r10]
				cmp r9, r2
				bne skip_index
				ldr r0, =print_matrix_element
				mla r3, r7, r10, r5
				ldrb r1, [r8, r3]
				bl printf
				skip_index:
				add r10, r10, #1
				bl loop_col
			exit_loop_col:
			add r9, r9, #1	
			b loop_col_finder
		exit_col_finder:
		add r5, r5, #1
		b loop_row
	exit_loop_row:
	LDR R0, =print_format_break
	BL printf
	pop {r4-r12, lr}			@Pop the registers out of the stack
	bx lr

encrypt:
	@push {r4-r12, lr}			@Push r4-r12 and lr into the stack
	@Adding Fillers into text
	@r8- char array
	@r9 - plain text length
	@r7 - filler length
	@r3 - filler
	ldr r10, =pt_len			@Load value of "pt_len" into r10
	ldrb r9, [r10], #1   					@???????????????????????????????????
	ldr r10, =filler_len		@Load value of "filler_len" into r10
	ldrb r7, [r10]       		@Load r7 into r10 (Load register byte)
	LDR r8,=chararray   		@Load value of "chararray" into r8
	MOV r3, #'x'        		@Move character "x" into r3


	mov r6, #0					@Move value 0 into r6 (loop index)
	filler_loop:
	cmp r6, r7					@Compare r6 with r7
	beq exit_filler_loop		@If comparison is equal, then branch to exit_filler_loop
		strb r3, [r8, r9]	@
		add r9, r9, #1			@Increment r9 by 1 (r9+=1)
		add r6, r6, #1			@Increment r6 by 1 (r6+=1)
		b filler_loop			@Branch back to filler_loop
	exit_filler_loop:

	@Printing the sorted columns
	@r6 = number of columns (6)
	@r10 = loop index for outer loop
	@r2 = current index
	@r9 = first value of current column
	@r4 = number of rows (5)
	@r11 = loop index for inner loop
	@r8 = char array
	LDR R0, =print_format_output
	BL printf
	mov r10, #0 					@r10 loop index
	mov r9, #0						@Move 0 into r9
	ldr r7, =columns				@Load value of "columns" into r7
	ldrb r6, [r7]					@Load r6 into r7
	ldr r7, =rows					@Load value of "rows" into r7
	ldrb r4, [r7]					@Load value of r4 into r7

	loop_encrypt_col:
	cmp r6, r10						@Compare r6 with r10
	beq exit_loop_encrypt_col		@Branch to exit_loop_col when CMP is equal
	ldrb r2, [r13, r10]				@Load r2 with current index????????????????????????????????
		add r9, r9, r2				@Add r9 and r2 and store into r9 (starting element of current column)

		mov r11, #0					@Move 0 into r11 (loop index for inner loop)
		loop_encrypt_row:
		cmp r4, r11					@Compare r4 with r11
		beq exit_loop_encrypt_row	@Branch to exit_loop_row when CMP is equal
			ldrb r1, [r8, r9]		@Load into r1 the current element
			add r9, r9, r6			@Add r9 and r6 and store to r9
			ldr r0, adr_print_matrix_element	@Load into r0 the address of "print_matrix_element"
			bl printf				@Executes printf function
			add r11, r11, #1		@Increments r11 by 1
			b loop_encrypt_row		@Branch back to loop_row
		exit_loop_encrypt_row:
		add r10, r10, #1			@Increments r10 by 1
		mov r9, #0					@Move 0 to r9 (resets r9 to 0)
		b loop_encrypt_col			@Branch back to loop_col
	exit_loop_encrypt_col:
	LDR R0, =print_format_break
	BL printf
	add sp,sp,r6,lsl #3 @!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!Pop indices from the stack
	pop {r4-r12, lr}				@Pop the registers out of the stack
	bx lr




@addressing for efficiency
adr_print_pk: .word print_pk
adr_print_pk_len: .word print_pk_len
adr_print_pt: .word print_pt
adr_print_pt_len: .word print_pt_len
adr_print_rows: .word print_rows
adr_print_matrix_element: .word print_matrix_element

