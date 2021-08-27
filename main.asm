				   EXPORT Ana_Program

Delay_suresi       EQU  0x239A95;8mhz/3(clock sinyali)=2.333.333=0x239A95
RCC                EQU  0x40021000 ;RCC nin adresi
Port_A             EQU  0x40010800 ;Port c nin adresi
RCC_CR             EQU  0x40021000
RCC_CFGR           EQU  0x40021000
FLASH_ACR          EQU  0x40022000
Port_A0            EQU  0x4001080C

				   AREA Bolum3, CODE, READONLY

Ana_Program						                              
  ;*****************************************************************************CLOCK CONFIGURATION 128MHZ				   
				     ;1014:     FLASH->ACR |= FLASH_ACR_PRFTBE; 
  ;1015:  
  ;1016:     /* Flash 2 wait state */ 
                   LDR      r0,=FLASH_ACR  
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x10
                   LDR      r1,=FLASH_ACR  
                   STR      r0,[r1,#0x00]
  ;1017:     FLASH->ACR &= (uint32_t)((uint32_t)~FLASH_ACR_LATENCY); 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   BIC      r0,r0,#0x03
                   STR      r0,[r1,#0x00]
  ;1018:     FLASH->ACR |= (uint32_t)FLASH_ACR_LATENCY_2;     
  ;1019:  
  ;1020:   
  ;1021:     /* HCLK = SYSCLK */ 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x02
                   STR      r0,[r1,#0x00]
	     ;5:                         RCC->CR |= 0x00030000;//Pll ON 
     ;6:            // while(!(RCC->CR & 0x20000))//hse ON
                   LDR      r0,=RCC_CR
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x10000
                   LDR      r1,=RCC_CR
                   STR      r0,[r1,#0x00] 				   
  ;12:       RCC->CFGR |= 0x00000400;  //apb1 /2 DIVIDE 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x400                                              
                   STR      r0,[r1,#0x04]		
  ;1054:     RCC->CFGR &= (uint32_t)((uint32_t)~(RCC_CFGR_PLLSRC | RCC_CFGR_PLLXTPRE | 
  ;1055:                                         RCC_CFGR_PLLMULL)); 
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   BIC      r0,r0,#0x3F0000
                   STR      r0,[r1,#0x04]				   		   
    ;10:       RCC->CFGR |= 0x001C0000;  //PLLMUL X9 =PLLMUL X16
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x380000;PLLMUL X16 
                   STR      r0,[r1,#0x04]
    ;13:       RCC->CFGR |= 0x00000002; //PLL   System clock
    ;14:                          
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x02
                   STR      r0,[r1,#0x04]
	;10:       RCC->CFGR |= 0x001C0000;  //PLL entry clock source
                   MOV      r0,r1
                   LDR      r0,[r0,#0x04]
                   ORR      r0,r0,#0x10000
                   STR      r0,[r1,#0x04]			   
				   ;  1060:     RCC->CR |= RCC_CR_PLLON; 
 ; 1061:  
 ; 1062:     /* Wait till PLL is ready */ PLLON: PLL enable
                   MOV      r0,r1
                   LDR      r0,[r0,#0x00]
                   ORR      r0,r0,#0x1000000
                   STR      r0,[r1,#0x00]
	;11:       RCC->CFGR |= 0x00000080;  //ahb prescaler 
       ;            MOV      r0,r1
      ;             LDR      r0,[r0,#0x04]
      ;             ORR      r0,r0,#0x90
     ;              STR      r0,[r1,#0x04]
;*****************************************************************************CLOCK CONFIGURATION 128MHZ	
  ; apb2 aktif (CLOCK ayarlamasi)
				   MOV r0, #0x04 
				   LDR r1, =RCC 
                   STR r0, [r1, #0x18] ;RCC_AHB2ENR ADRESI

                               ; pc13 çikis olarak ayarlandi
				   MOV r0, #0x03 
				   LDR r1, =Port_A
                   STR r0, [r1, #0x00] ; pa13 cikis olarak ayarlandi
                   LDR r1,=Port_A0 
                               
; pc13 ledi açik/kapali
dongu
    ;12:                 GPIOA->ODR  = 0x1; 
                   MOVS     r0,#0x01
                   STR      r0,[r1,#0x00]
   ; 13:                 GPIOA->ODR  = 0x0; 
                   MOVS     r0,#0x00
                   STR      r0,[r1,#0x00]
					
                   B dongu ;döngüyü tekrarla
							   
				   ALIGN
							   
				   END
								   
								   
