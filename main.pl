:- use_module(library(clpfd)).
:- use_module(library(apply)).
:- use_module(library(lists)).

% Predicados Auxiliares
xor(A,A,0).
xor(A,B,1):-
    A \= B.

xor_array([],[],[]).
xor_array([A|As],[B|Bs],[R|Rs]):-
    xor(A,B,R),
    xor_array(As,Bs,Rs).

make_zeroes(_,0,[]).
make_zeroes(X,N1,[X|L]) :-
  N1 > 0, N is N1 - 1,
  make_zeroes(X,N,L).

fill_array_to_6_bits(A,B):- 
    length(A,L),
    L =:= 6,
    append(A,[],B).
fill_array_to_6_bits(A,B):-
    length(A,L),
    L < 6,
    X is 6-L,
    make_zeroes(0,X,R),
    append(R,A,B).    

dec2bin(0,[0]).
dec2bin(1,[1]).
dec2bin(N,L):- 
    N > 1,
    X is N mod 2,
    Y is N // 2,  
    dec2bin(Y,L1), 
    append(L1, [X], L).

bin2dec(Bits, N) :-
    bind2dec_min(Bits, 0,N, N).

bind2dec_min([], N,N, _M).
bind2dec_min([Bit|Bits], N0,N, M) :-
    Bit in 0..1,
    N1 #= N0*2 + Bit,
    M #>= N1,
    bind2dec_min(Bits, N1,N, M).

invert([],Z,Z).
invert([H|T],Z,Acc) :-
    invert(T,Z,[H|Acc]).

invert_list([],[]).
invert_list([L|Ls],[R|Rs]):-
    invert(L,R,[]),
    invert_list(Ls,Rs).

convert_num_list([],[]).
convert_num_list([NUM|NUMS],[B|Bs]):-
    dec2bin(NUM,B),
    convert_num_list(NUMS,Bs).

convert_bin_list([],[]).
convert_bin_list([B|Bs],[R|Rs]):-
    bin2dec(B,R),
    convert_bin_list(Bs,Rs).

remove_all(_, [], []).
remove_all(X, [X|T], L):- remove_all(X, T, L), !.
remove_all(X, [H|T], [H|L]):- remove_all(X, T, L ).

count([],_,0).
count([X|T],X,Y):- count(T,X,Z), Y is 1+Z.
count([X1|T],X,Z):- X1\=X,count(T,X,Z).

countall(List,X,C) :-
    sort(List,List1),
    member(X,List1),
    count(List,X,C).

% Predicado para avaliar os índices(em binário) que pertencem a cada grupo de busca.
get_group_bin(_,[],[]).
get_group_bin(N,[B|Bs],[G|Gs]):-
    ( nth0(N,B,1) -> 
        append(B,[],G)
    ;
        append(['NONE'],[],G)
    ),
    get_group_bin(N,Bs,Gs).

% Predicado para avaliar os avaliar os índices que pertencem a cada grupo de busca.
% Utiliza do predicado get_group_bin e converte para decimal.
get_members_of_group(N,R):-
    numlist(0,63,NUMS),
    convert_num_list(NUMS,BITS),
    invert_list(BITS,I_BITS),
    get_group_bin(N,I_BITS,GROUP_W_ERRORS),
    remove_all(['NONE'],GROUP_W_ERRORS,GROUP),
    invert_list(GROUP, GROUP_BIN),
    convert_bin_list(GROUP_BIN,R).

% Predicado para pegar os valores dos membros do grupo baseado no índice.
get_members_values([],_,[]).
get_members_values([MEMBER|MEMBERS],VALUES,[R|Rs]):-
    nth0(MEMBER,VALUES,R),
    get_members_values(MEMBERS,VALUES,Rs).

% Predicado que avalia a paridade de cada grupo. O conceito de paridade é usado em relação
% ao número de moedas com valor 1(CARA).
get_group_parity(N,T,P):-
    get_members_of_group(N,MEMBERS),
    get_members_values(MEMBERS,T,VALUES),
    countall(VALUES,1,INSTANCES),
    P is INSTANCES mod 2.

% Predicado que avalia a paridade de todos os grupos.
% Apenas um auxiliador para reunir os predicados retornados em get_group_parity.
get_parity_array(T,A):-
    get_group_parity(5,T,A5),
    get_group_parity(4,T,A4),
    get_group_parity(3,T,A3),
    get_group_parity(2,T,A2),
    get_group_parity(1,T,A1),
    get_group_parity(0,T,A0),
    append([A5,A4,A3,A2,A1,A0],[],A).
    

% Predicado principal.
% Utilizado pelo prisioneiro para descobrir qual moeda deve virar.
get_coin_to_flip(T,C,N):-
    get_parity_array(T,ARRAY),
    dec2bin(C,C_BIN),
    fill_array_to_6_bits(C_BIN,C_BIN_6),
    xor_array(ARRAY,C_BIN_6,BIN_CHANGE),
    bin2dec(BIN_CHANGE,N),
    write('RESULTADO:'),writeln(N).

% Utilizado pelo segundo prisioneiro para receber encontrar onde está a chave.
% Esse predicado é chamado após o primeiro prisioneiro ter virado a moeda.
% Serve mais para ilustrar que a moeda virada era a moeda correta.
solution(T,S):-
    get_parity_array(T,A),
    bin2dec(A,S),
    write('A CHAVE ESTÁ NA CASA: '), writeln(S).