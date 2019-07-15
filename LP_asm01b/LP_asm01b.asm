.586														; система команд (процессор Pentium)
.model flat, stdcall										; модель памяти, соглашение о вызовах
includelib kernel32.lib										; компановщику: компоновать с kernel32
includelib ..\Debug\LP_asm01a.lib

ExitProcess PROTO: DWORD									; прототип функции для завершения процесса Windows 
GetStdHandle PROTO: DWORD									; получить handle вывода на консоль 
															; (принимает константное значение -10 ввод, -11 вывод, -12 ошибка устройства вывода)
WriteConsoleA PROTO: DWORD,: DWORD,: DWORD,: DWORD,: DWORD	; вывод на консоль (стандартная ф-ия)
SetConsoleTitleA PROTO: DWORD								; прототип ф-ии устанавливающей заголовок консольного окна (функция стандартная)

getmin PROTO :DWORD, :DWORD
getmax PROTO :DWORD, :DWORD

.stack 4096													; выделение стека объёмом 4 мегабайта

.const														; константы
	consoleTitle byte 'LP_asm01', 0							; строка, первый элемент данные + нулевой бит
	handleOutput sdword -11									; код на запрос разрешения вывода в консоль
	array sdword 11, 2, 0, 14, 2, -8, 54, 3, 23, 27			; массив заполненый 10-ю значениями
	text byte 'getmax-getmin =', 0							; строка для вывода ответа	

.data
	consoleHandle dword 0h									; состояние консоли
	max sdword ?
	min sdword ?
	result sdword ?
	resultString byte 4 dup(0)

.code

int_to_char PROC uses eax ebx ecx edi esi,
                              pstr: dword,      ; адрес строки для результата
                              intfield: dword   ; преобразуемое число

  mov edi, pstr                ; адрес результата в edi
  mov esi, 0                   ; количество символов результата
  mov eax, intfield           ; число в eax
  cdq                          ; распространение знака eax на edx
  mov ebx, 10                  ; десятичная система счисления 
  idiv ebx                     ; eax = eax/edx остаток в edx
  test eax, 80000000h           ; проверка на отрицательность
  jz plus                      ; на метку plus, если положительный 
  neg eax                      ; eax = -eax
  neg edx                      ; edx = -edx
  mov cl, '-'                  ; первый символ результата '-'
  mov [edi], cl                ; запись ^ по адресу в edi
  inc edi                      ; ++edi т.е. адрес для вывода символа рез-та
plus:                          ; разложение на степени 10
  push dx                      ; остаток в стек
  inc esi                      ; ++esi т.е. кол-ва символов рез-та
  test eax,eax                 ; eax == 0 ???
  jz fin                       ; да - то на fin
  cdq                          ; распространение знака с eax на edx
  idiv ebx                     ; eax = eax/ebx, остаток в  edx
  jmp plus                     ; переход на plus
fin:
  mov ecx,esi                  ; кол-во не 0вых остатков = кол-ву символов рез-та??????
write:                         ; запись результата
  pop bx                       ; остаток из стека в bx
  add bl,'0'                   ; формирование символа в bl
  mov [edi],bl                 ; пересылка символа из bl на адрес рез-та
  inc edi                      ; ++edi т.е. адрес для вывода символа рез-та
  loop write                   ; if(-ecx) > 0 goto write 

   ret
int_to_char ENDP

main PROC										        ; точка входа main
												        
	push offset consoleTitle					        ; помещаем в стек параметр функции SetConsoleTitle строку
	call SetConsoleTitleA						        ; вызываем функцию устанвки заголовка окна
												        
	push handleOutput							        ; помещаем в стек код ращзрешения на вывод в консоли
	call GetStdHandle							        ; вызываем ф-ию проверки разрешения на вывод
	mov consoleHandle, eax						        ; копируем полученное разрешение из регистра eax
												        
    push lengthof array                                 ;
    push offset array                                   ; помещаем массив в стек
    call getmin											; вызов процедуры getmin
    mov min, eax										; результат в min

	push lengthof array									;
    push offset array									; помещаем массив в стек
    call getmax											; вызов процедуры getmax
    mov max, eax										; результат в max
	sub eax, min										; 
	mov result, eax										;

	push 0												; можно отправлять нули, нужно для ф-ии вывода в консоль
	push 0												; можно отправлять нули, нужно для ф-ии вывода в консоль
	push sizeof text									; размер массива в стек
	push offset text									; указатель на начало строки в стек
	push consoleHandle									; полученное разрешение
	call WriteConsoleA 

	push result
	push offset resultString 
	call int_to_char

	push 0												; можно отправлять нули, нужно для ф-ии вывода в консоль
	push 0												; можно отправлять нули, нужно для ф-ии вывода в консоль
	push sizeof resultString 							; размер массива в стек
	push offset resultString							; указатель на начало строки в стек
	push consoleHandle									; полученное разрешение
	call WriteConsoleA 

	push 0												; помещаем в стек код завершения процесса Windows
	call ExitProcess									; завершение процесса Windows
main ENDP												; конец процедуры
end main			