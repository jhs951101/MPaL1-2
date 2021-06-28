        NAME    main
        
        PUBLIC  __iar_program_start
        
        SECTION .intvec : CODE (2)
        THUMB
        
__iar_program_start
        B       main

        
        SECTION .text : CODE (2)
        THUMB

main
        NOP
        LDR r1, =Hello  ; 레지스터 R1이 Hello 에서 H를 가리킴
        LDR r2, =World  ; 레지스터 R2가 World 에서 W를 가리킴
        SUB r1, r1, #1
        SUB r2, r2, #1  /* 아래의 LDRB 명령문이 진행되면 1이 먼저 증가해서
                           첫 번째 문자가 아닌 다음 문자를 가리키게 되므로
                           사전에 1을 뻄으로써 후에 첫번째 문자를 가리키게 할 수 있음 */
        MOV r4, r1  /* 나중에 strcat() 한 결과를 확인해야 하므로
                       초기의 레지스터 R1의 값을 저장해놓음 (나중에 다시 불러올 것임) */

PREPARE
        LDRB r0, [r1], #1  ; 레지스터 R1의 주소 값을 1만큼 증가시킨 후 R0에 값을 대입함
        CMP r0, #0
        BNE PREPARE  ; 레지스터 R0의 값이 0이 되지 않는 한 계속 위로 분기함
        
        SUB r1, r1, #2  ; \n의 값에서부터 덮어씌우기 위해 2만큼 뺐음

STRCAT 
        LDRB r0, [r2], #1  ; 레지스터 R2의 주소 값을 1만큼 증가시킨 후 R0에 값을 대입함
        STRB r0, [r1], #1  /* 레지스터 R1의 주소 값을 1만큼 증가시킨 후
                              불러온 R0의 값을 R1 쪽에 대입함으로써 문자열 2개를 붙일 수 있음 */
        CMP r0, #0
        BNE STRCAT  ; 레지스터 R0의 값이 0이 되지 않는 한 계속 위로 분기함
        
        MOV r1, r4  ; 초기의 레지스터 R1의 값이 저장된 R4로부터 값을 다시 불러옴
        
RESULT
        LDRB r0, [r1], #1  /* R0의 값을 하나씩 확인하면
                              H e l l o w o r l d /n 의 값이
                              16진수 형태로 하나씩 등장하는 것을 볼 수 있음,
                              따라서 이것이 바로 strcat() 한 올바른 결과임 */
        CMP r0, #0
        
        BNE RESULT
        BEQ EXIT  ; 결과 값을 모두 보여주었다면 프로그램이 종료됨
        
DATA
Hello DCB "Hello\n",0  ; Hello 문자열
World DCB "World\n",0  ; World 문자열
        
EXIT
        END