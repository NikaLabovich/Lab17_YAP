.586														; ������� ������ (��������� Pentium)
.model flat, stdcall										; ������ ������, ���������� � �������
includelib kernel32.lib										; ������������: ����������� � kernel32

ExitProcess PROTO: DWORD									; �������� ������� ��� ���������� �������� Windows 

.stack 4096													; ��������� ����� ������� 4 ���������

.const														; ���������
	array sdword 11, 2, 0, 4, 322, 8, 54, 11, 16, 27		; ������ ���������� 10-� ����������

.data
	min sdword ?

.code

getmin PROC start : sdword, amount : dword;
	mov esi, start											; ����� ������ �������
	mov ecx, amount											; ���������� ���������
	mov ebx, [esi]											; ���������� ���������
Next:														; 
	lodsd													; ��������� 4 ���� �� ������ esi � eax, esi ���������� �� 4
	sub ecx, 1												;
	cmp ecx, 0												; ��������, �������� �� �������� � �������
	je Exit													; ����������  ��������, ���� �� ��������
	cmp  ebx, eax											; �������� � ���������� �����������
	jl Next													; ���� ���������� ���� ������ ������� � ���������� ������ �������(���������� �����)
	mov ebx, eax											; ��������� ����� �������� ��� �������
	jmp Next												; ������� � ���������� ������ �������(���������� �����)
Exit:														; 
	mov eax, ebx											; ���������� �������� � eax
	ret														; ������� ��������� � �������� eax
getmin ENDP													;

main PROC													; ����� ����� main
    push lengthof array										;
    push offset array										; �������� ������ � ����
    call getmin												; ����� ��������� getmin
    mov min, eax											; ��������� � min

	push 0													; �������� � ���� ��� ���������� �������� Windows
	call ExitProcess										; ���������� �������� Windows
main ENDP													; ����� ���������
end main						