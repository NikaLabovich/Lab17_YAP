.586														; ������� ������ (��������� Pentium)
.model flat, stdcall										; ������ ������, ���������� � �������
includelib kernel32.lib										; ������������: ����������� � kernel32
includelib ..\Debug\LP_asm01a.lib

ExitProcess PROTO: DWORD									; �������� ������� ��� ���������� �������� Windows 
GetStdHandle PROTO: DWORD									; �������� handle ������ �� ������� 
															; (��������� ����������� �������� -10 ����, -11 �����, -12 ������ ���������� ������)
WriteConsoleA PROTO: DWORD,: DWORD,: DWORD,: DWORD,: DWORD	; ����� �� ������� (����������� �-��)
SetConsoleTitleA PROTO: DWORD								; �������� �-�� ��������������� ��������� ����������� ���� (������� �����������)

getmin PROTO :DWORD, :DWORD
getmax PROTO :DWORD, :DWORD

.stack 4096													; ��������� ����� ������� 4 ���������

.const														; ���������
	consoleTitle byte 'LP_asm01', 0							; ������, ������ ������� ������ + ������� ���
	handleOutput sdword -11									; ��� �� ������ ���������� ������ � �������
	array sdword 11, 2, 0, 14, 2, -8, 54, 3, 23, 27			; ������ ���������� 10-� ����������
	text byte 'getmax-getmin =', 0							; ������ ��� ������ ������	

.data
	consoleHandle dword 0h									; ��������� �������
	max sdword ?
	min sdword ?
	result sdword ?
	resultString byte 4 dup(0)

.code

int_to_char PROC uses eax ebx ecx edi esi,
                              pstr: dword,      ; ����� ������ ��� ����������
                              intfield: dword   ; ������������� �����

  mov edi, pstr                ; ����� ���������� � edi
  mov esi, 0                   ; ���������� �������� ����������
  mov eax, intfield           ; ����� � eax
  cdq                          ; ��������������� ����� eax �� edx
  mov ebx, 10                  ; ���������� ������� ��������� 
  idiv ebx                     ; eax = eax/edx ������� � edx
  test eax, 80000000h           ; �������� �� ���������������
  jz plus                      ; �� ����� plus, ���� ������������� 
  neg eax                      ; eax = -eax
  neg edx                      ; edx = -edx
  mov cl, '-'                  ; ������ ������ ���������� '-'
  mov [edi], cl                ; ������ ^ �� ������ � edi
  inc edi                      ; ++edi �.�. ����� ��� ������ ������� ���-��
plus:                          ; ���������� �� ������� 10
  push dx                      ; ������� � ����
  inc esi                      ; ++esi �.�. ���-�� �������� ���-��
  test eax,eax                 ; eax == 0 ???
  jz fin                       ; �� - �� �� fin
  cdq                          ; ��������������� ����� � eax �� edx
  idiv ebx                     ; eax = eax/ebx, ������� �  edx
  jmp plus                     ; ������� �� plus
fin:
  mov ecx,esi                  ; ���-�� �� 0��� �������� = ���-�� �������� ���-��??????
write:                         ; ������ ����������
  pop bx                       ; ������� �� ����� � bx
  add bl,'0'                   ; ������������ ������� � bl
  mov [edi],bl                 ; ��������� ������� �� bl �� ����� ���-��
  inc edi                      ; ++edi �.�. ����� ��� ������ ������� ���-��
  loop write                   ; if(-ecx) > 0 goto write 

   ret
int_to_char ENDP

main PROC										        ; ����� ����� main
												        
	push offset consoleTitle					        ; �������� � ���� �������� ������� SetConsoleTitle ������
	call SetConsoleTitleA						        ; �������� ������� �������� ��������� ����
												        
	push handleOutput							        ; �������� � ���� ��� ����������� �� ����� � �������
	call GetStdHandle							        ; �������� �-�� �������� ���������� �� �����
	mov consoleHandle, eax						        ; �������� ���������� ���������� �� �������� eax
												        
    push lengthof array                                 ;
    push offset array                                   ; �������� ������ � ����
    call getmin											; ����� ��������� getmin
    mov min, eax										; ��������� � min

	push lengthof array									;
    push offset array									; �������� ������ � ����
    call getmax											; ����� ��������� getmax
    mov max, eax										; ��������� � max
	sub eax, min										; 
	mov result, eax										;

	push 0												; ����� ���������� ����, ����� ��� �-�� ������ � �������
	push 0												; ����� ���������� ����, ����� ��� �-�� ������ � �������
	push sizeof text									; ������ ������� � ����
	push offset text									; ��������� �� ������ ������ � ����
	push consoleHandle									; ���������� ����������
	call WriteConsoleA 

	push result
	push offset resultString 
	call int_to_char

	push 0												; ����� ���������� ����, ����� ��� �-�� ������ � �������
	push 0												; ����� ���������� ����, ����� ��� �-�� ������ � �������
	push sizeof resultString 							; ������ ������� � ����
	push offset resultString							; ��������� �� ������ ������ � ����
	push consoleHandle									; ���������� ����������
	call WriteConsoleA 

	push 0												; �������� � ���� ��� ���������� �������� Windows
	call ExitProcess									; ���������� �������� Windows
main ENDP												; ����� ���������
end main			