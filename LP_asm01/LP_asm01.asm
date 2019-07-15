.586														; система команд (процессор Pentium)
.model flat, stdcall										; модель памяти, соглашение о вызовах
includelib kernel32.lib										; компановщику: компоновать с kernel32

ExitProcess PROTO: DWORD									; прототип функции для завершения процесса Windows 

.stack 4096													; выделение стека объёмом 4 мегабайта

.const														; константы
	array sdword 11, 2, 0, 4, 322, 8, 54, 11, 16, 27		; массив заполненый 10-ю значениями

.data
	min sdword ?

.code

getmin PROC start : sdword, amount : dword;
	mov esi, start											; адрес начала массива
	mov ecx, amount											; количество элементов
	mov ebx, [esi]											; количество элементов
Next:														; 
	lodsd													; поместить 4 байт по адресу esi в eax, esi увеличится на 4
	sub ecx, 1												;
	cmp ecx, 0												; проверка, остались ли элементы в массиве
	je Exit													; завершение  перебора, если не осталось
	cmp  ebx, eax											; сравнить с предыдущим результатом
	jl Next													; если полученный байт больше перейти к повторному чтению массива(следующего байта)
	mov ebx, eax											; сохранить новое значение как меньшее
	jmp Next												; перейти к повторному чтению массива(следующего байта)
Exit:														; 
	mov eax, ebx											; наименьшее значение в eax
	ret														; возврат результат в регистре eax
getmin ENDP													;

main PROC													; точка входа main
    push lengthof array										;
    push offset array										; помещаем массив в стек
    call getmin												; вызов процедуры getmin
    mov min, eax											; результат в min

	push 0													; помещаем в стек код завершения процесса Windows
	call ExitProcess										; завершение процесса Windows
main ENDP													; конец процедуры
end main						