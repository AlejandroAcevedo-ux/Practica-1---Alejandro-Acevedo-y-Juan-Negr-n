:- use_module(library(readutil)).
:- use_module(library(lists), [sum_list/2]).

% Hechos
periodo(262, '2026-2').
periodo(271, '2027-1').
periodo(272, '2027-2').
periodo(281, '2028-1').
periodo(282, '2028-2').
periodo(291, '2029-1').
periodo(292, '2029-2').

% Reglas
descomponer_codigo(Codigo, Prefijo, ValorCategoria, Numero) :-
    integer(Codigo),
    Codigo >= 10000000,
    Codigo =< 99999999,
    Prefijo is Codigo // 100000,
    ValorCategoria is (Codigo // 1000) mod 100,
    Numero is Codigo mod 1000.

divisor_propio(Numero, Divisor) :-
    Max is Numero - 1,
    between(1, Max, Divisor),
    0 is Numero mod Divisor.

suma_div_propios(Numero, Suma) :-
    findall(Divisor, divisor_propio(Numero, Divisor), Divisores),
    sum_list(Divisores, Suma).

clasificar(Numero, Suma, 'Administrative') :-
    Suma > Numero.

clasificar(Numero, Suma, 'Engineering') :-
    Suma =:= Numero.

clasificar(Numero, Suma, 'Humanities') :-
    Suma < Numero.

paridad(Codigo, even) :-
    0 is Codigo mod 2.

paridad(Codigo, odd) :-
    1 is Codigo mod 2.


datos_estudiante(Prefijo, ValorCategoria, Numero,
                 Periodo, Categoria, Consecutivo) :-
    periodo(Prefijo, Periodo),
    between(1, 99, ValorCategoria),
    suma_div_propios(ValorCategoria, Suma),
    clasificar(ValorCategoria, Suma, Categoria),
    between(1, 999, Numero),
    atom_number(TextoNumero, Numero),
    atom_concat(num, TextoNumero, Consecutivo).

% Caso 1: El codigo esta en el archivo
codigo_estudiante(Codigo, Periodo, Categoria, Consecutivo, Paridad) :-
    integer(Codigo),
    descomponer_codigo(Codigo, Prefijo, ValorCategoria, Numero),
    datos_estudiante(Prefijo, ValorCategoria, Numero,
                     Periodo, Categoria, Consecutivo),
    paridad(Codigo, Paridad).
    
% Caso 2: El codigo es una variable.
codigo_estudiante(Codigo, Periodo, Categoria, Consecutivo, Paridad) :-
    var(Codigo),
    datos_estudiante(Prefijo, ValorCategoria, Numero,
                     Periodo, Categoria, Consecutivo),
    Codigo is Prefijo * 100000 + ValorCategoria * 1000 + Numero,
    paridad(Codigo, Paridad).


mostrar_codigo(Codigo) :-
    codigo_estudiante(Codigo, Periodo, Categoria, Consecutivo, Paridad),
    format('~w ~w ~w ~w~n', [Periodo, Categoria, Consecutivo, Paridad]).


% Abrir y cerrar los archivos
procesar_archivo(ArchivoEntrada, ArchivoSalida) :-
    open(ArchivoEntrada, read, Entrada, [encoding(utf8)]),
    open(ArchivoSalida, write, Salida, [encoding(utf8)]),
    procesar_lineas(Entrada, Salida),
    close(Salida),
    close(Entrada).



procesar_lineas(Entrada, Salida) :-
    read_line_to_string(Entrada, Linea),
    (   Linea == end_of_file ->  
        true
    ;   
        procesar_linea(Linea, Salida),
        procesar_lineas(Entrada, Salida)
    ).
    
% Evaluar la validez del codigo
procesar_linea(Texto, Salida) :-
    (   texto_codigo(Texto, Codigo),
        codigo_estudiante(Codigo, Periodo, Categoria, Consecutivo, Paridad)
    ->
        format(Salida, '~w ~w ~w ~w~n',
               [Periodo, Categoria, Consecutivo, Paridad])
    ;
        format(Salida, 'ERROR codigo_invalido: ~s~n', [Texto])
    ).



% Comprobación del texto para rechazar codigos no validos
texto_codigo(Texto, Codigo) :-
    string_length(Texto, 8),
    string_codes(Texto, Caracteres),
    solo_digitos(Caracteres),
    number_string(Codigo, Texto).


solo_digitos([]).
solo_digitos([Caracter | Resto]) :-
    between(0'0, 0'9, Caracter),
    solo_digitos(Resto).

% Ejecución de la lectura y la escritura.
main :-
    procesar_archivo('codigos.txt', 'estudiantes.txt'),
    writeln('Archivo generado.\n').
    
:- initialization(prolog).
