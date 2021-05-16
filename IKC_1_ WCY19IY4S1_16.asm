.model small
.stack 100h
.data
	nazwa db 'Prog_dst',13,10,'$'
	autor db 'Wojciech Zalewski WCY19IY4S1',13,10,'$'
	polecenie db 'Wprowadz komunikat do zaszyfrowania(max. 20 znakow)',13,10,'$'
	komunikat1 db 13,10,'Zaszyfrowany tekst to: ',13,10,'$'
	komunikat2 db 13,10,'Koniec pracy programu',13,10,'$'

	usun db 32,8,'$'          ; uzywane w funkcji backspace
	tekst db 20 dup(?)        ; wpisywany tekst
	ilosc_znakow dw 0         ; ilosc wpisanych znaków
.code
start:
	mov ax, seg nazwa         ; wczytaj stringa z nazwa programu
	mov ds, ax
	mov dx, offset nazwa

	mov ah, 9	          ; wyswietl nazwe programu
	int 21h

	mov ax, seg autor         ; wczytaj stringa z informacjami autora
	mov ds, ax
	mov dx, offset autor

	mov ah, 9                 ; wyswietl informacje autora
	int 21h

	mov ax, seg polecenie     ; wczytaj stringa z poleceniem
	mov ds, ax
	mov dx, offset polecenie

	mov ah, 9                 ; wyswietl polecenie
	int 21h

	mov cx, 0 		  ; inicjalizacja licznika
czytanie:
	mov ah, 1                 ; pobierz znak
	int 21h

	cmp al, 13		  ; sprawdz czy wcisnieto enter
	je ustaw_ilosc

	cmp al, 8		  ; sprawdz czy wcisnieto backspace
	je cofnij

	cmp cx, 20                ; sprawdz czy osiagnieto limit znakow
	jae czytanie

	mov si, cx                ; zapisanie litery w pamieci
	mov bx, offset tekst
	mov byte ptr [bx+si], al

	add cl, 1                 ; iteracja petli
	jmp czytanie
; koniec czytania

ustaw_ilosc:
	mov ilosc_znakow, cx      ; zapisz ilosc iteracji petli
	mov cx, 0

	mov ax, seg komunikat1    ; wczytaj komunikat
	mov ds, ax
	mov dx, offset komunikat1
	
	mov ah, 9                 ; wyswietl komunikat
	int 21h
; koniec ustawiania ilosci

szyfr:
	mov si, cx                ; wczytanie znaku
	mov bx, offset tekst
	mov dl, bye ptr [bx+si]
	
	add dl, 1                 ; zaszyfrowanie znaku
	
	mov ah, 2                 ; wyswietlanie zaszyfrowanego znaku
	int 21h

	add cx, 1                 ; iteracja petli
	cmp cx, ilosc_znakow
	jne szyfr
; koniec szyfru
	
	mov ax, seg komunikat2    ; wczytanie komunikatu konczacego program
	mov ds, ax
	mov dx, offset komunikat2

	mov ah, 9                 ; wyswietlanie komunikatu
	int 21h

	mov ah, 4ch               ; zakonczenie programu
	int 21h

cofnij:                           ; funkcja obslugujaca backspace
	cmp cx, 0                 ; nic nie rob jesli licznik jest wyzerowany
	je czytanie
	
	sub cx, 1                 ; zmniejsz licznik o 1
	
	mov ax, seg usun          ; usuniecie ostatniego znaku
	mov ds, ax
	mov dx, offset usun
	mov ah,9
	int 21h

	jmp czytanie              ; powrot do petli
; koniec funkcji cofnij

end start                         ; koniec programu
end

	