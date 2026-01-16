#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 13],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [16 stycznia 2025 r.],
)

= Ćwiczenie 46 -- Idea algorytmu Apriori

/ Algorytm Apriori: klasyczny algorytm służący do znajdowania częstych zbiorów elementów (frequent itemsets) w transakcyjnych bazach danych.

== Właściwość Apriori (Anti-monotonicity)
Kluczowa dla działania algorytmu jest zasada:
#quote(block: true)[
  _Jeśli zbiór elementów jest częsty, to każdy jego podzbiór musi być częsty. I odwrotnie: jeśli zbiór jest rzadki, to każdy jego nadzbiór również jest rzadki._
]
Dzięki tej właściwości możemy drastycznie ograniczyć przestrzeń poszukiwań (tzw. _pruning_). Jeśli zbiór $"A, B"$ jest rzadki, nie musimy sprawdzać $"A, B, C"$, ponieważ on również musi być rzadki.

== Proces generowania kandydatów
Algorytm działa iteracyjnie (poziomami $k = 1, 2, dots$):
+ / _Łączenie (Join)_: Kandydaci o rozmiarze $k$ ($C_k$) są generowani poprzez łączenie częstych zbiorów o rozmiarze $k-1$ ($L_(k-1)$). Łączymy dwa zbiory $X, Y in L_(k-1)$ tylko wtedy, gdy ich pierwsze $k-2$ elementy są identyczne (zakładając porządek leksykograficzny).
+ / _Przycinanie (Prune)_: Dla każdego wygenerowanego kandydata sprawdzamy, czy *wszystkie* jego podzbiory o rozmiarze $k-1$ znajdują się w $L_(k-1)$. Jeśli którykolwiek podzbiór nie jest częsty, kandydat jest usuwany zgodnie z właściwością Apriori.



= Ćwiczenie 47 -- Oznaczenie węzłów kraty (M, D, C, R)

*Dane:*
- Liczba transakcji ($N$): 10
- Próg wsparcia: $30% arrow 3$ transakcje.

*Analiza liczności zbiorów (Support count):*

#align(center)[
#show "R": set text(red)
#show "M": set text(green.darken(10%))
#show "D": set text(blue)
#show "C": set text(yellow.darken(30%))
#table(
  columns: (auto, auto, auto),
  inset: 5pt,
  align: center,
  table.header([*Zbiór*], [*Liczność*], [*Status*]),
  [{a}], [5], [D],
  [{b}], [7], [D],
  [{c}], [5], [D],
  [{d}], [9], [D],
  [{e}], [6], [C],
  [{ab}], [3], [M],
  [{ac}], [2], [R],
  [{ad}], [4], [C],
  [{ae}], [4], [C],
  [{bc}], [3], [M],
  [{bd}], [6], [D],
  [{be}], [4], [C],
  [{cd}], [4], [M],
  [{ce}], [2], [R],
  [{de}], [6], [D],
  [{abc}], [1], [R],
  [{abd}], [2], [R],
  [{abe}], [2], [R],
  [{acd}], [1], [R],
  [{ace}], [1], [R],
  [{ade}], [4], [M],
  [{bcd}], [2], [R],
  [{bce}], [1], [R],
  [{bde}], [4], [M],
  [{cde}], [2], [R],
  [{abcd}], [0], [R],
  [{abce}], [0], [R],
  [{abde}], [2], [R],
  [{acde}], [1], [R],
  [{bcde}], [1], [R],
  [{abcde}], [0], [R],
)]

*Oznaczenia:*
  - / M (Maksymalny): Częsty, brak częstych nadzbiorów.
  - / D (Domknięty): Częsty, brak nadzbiorów o _tym samym_ wsparciu (Maksymalne też są domknięte, ale tutaj rozróżniamy je dla precyzji, przypisując M do tych na granicy "częstości").
  - / C: Częsty, nie M i nie D.
  - / R (Rzadki): Poniżej progu.

*Wynikowa klasyfikacja węzłów:*
  - *M:* $"ab", "bc", "cd", "ade", "bde"$
  - *D:* $"a", "b", "c", "d", "bd", "de"$
  - *C:* $"e", "ad", "ae", "be"$
  - *R:* $"ac", "ce"$ oraz wszystkie zbiory 3-elementowe inne niż $"ade", "bde"$ i wszystkie 4-elementowe.



= Ćwiczenie 48 -- Intuicje: Maksymalne vs Domknięte

== Maksymalny zbiór częsty:
  - *Intuicja:* Jest to "granica" zbiorów częstych. Najdłuższe możliwe kombinacje, które są jeszcze częste.
  - *Cel:* Kompaktowa reprezentacja wszystkich częstych zbiorów. Jeśli znamy zbiory maksymalne, wiemy, że każdy ich podzbiór też jest częsty.
  - *Wada:* Tracimy informację o dokładnej liczności podzbiorów (kompresja stratna).

== Domknięty zbiór częsty:
  - *Intuicja:* Zbiór, który "maksymalizuje" przedmioty dla danej grupy transakcji. Dodanie czegokolwiek do tego zbioru spowodowałoby spadek wsparcia (występowanie w mniejszej liczbie transakcji).
  - *Cel:* Pozwala na odtworzenie dokładnego wsparcia wszystkich częstych podzbiorów bez skanowania bazy (kompresja bezstratna). Wsparcie dowolnego zbioru $X$ jest równe wsparciu jego najmniejszego domkniętego nadzbioru.

*Relacja:*
$ "Maksymalne" subset.eq "Domknięte" subset.eq "Częste" $
Każdy maksymalny zbiór jest domknięty, ale nie każdy domknięty jest maksymalny.



= Ćwiczenie 49 -- Złożoność Algorytmu Apriori

Niech $d$ to liczba unikalnych przedmiotów, $N$ to liczba transakcji, a $w$ to maksymalna szerokość transakcji.

1.  *Złożoność czasowa:*
  Głównym kosztem jest zliczanie wsparcia dla kandydatów $C_k$. W najgorszym przypadku algorytm generuje $O(2^d)$ kandydatów.
  Koszt zliczania to:
  $ O(sum_k |C_k| dot N dot w) $
  W praktyce często upraszcza się to do $O(2^d)$, co wskazuje na wykładniczą złożoność względem liczby produktów.

2.  *Złożoność pamięciowa:*
  Wymaga przechowywania kandydatów na danym poziomie oraz liczników.
  $ O(max_k |C_k|) $
  W najgorszym przypadku (gdy $k approx d/2$) pamięć rośnie wykładniczo.

*Wpływ progu wsparcia ($"Support"_(min)$):*
Tak, próg ma krytyczny wpływ.
- *Zmniejszanie $"Support"_(min)$:* Powoduje gwałtowny wzrost liczby częstych zbiorów i kandydatów.
- *Negatywne konsekwencje:* Wykładniczy wzrost czasu obliczeń i zapotrzebowania na pamięć. Może dojść do wygenerowania tak dużej liczby kandydatów na poziomie 2 (pary), że algorytm nie zmieści się w pamięci RAM.



= Ćwiczenie 50 -- Liczba reguł asocjacyjnych

Mamy $d$ zmiennych. Reguła ma postać $X -> Y$, gdzie $X, Y subset.eq I$, $X inter Y = emptyset$, $X != emptyset$, $Y != emptyset$.

Dla każdego z $d$ elementów mamy 3 możliwości:
1.  Element jest w antecedencie ($X$).
2.  Element jest w następniku ($Y$).
3.  Element nie występuje w regule (nie jest ani w $X$, ani w $Y$).

Daje to $3^d$ kombinacji. Należy jednak odjąć przypadki niepoprawne:
- *Zbiór $X$ jest pusty:* Elementy mogą być tylko w $Y$ lub "nigdzie" (2 opcje). Jest to $2^d$ przypadków.
- *Zbiór $Y$ jest pusty:* Elementy mogą być tylko w $X$ lub "nigdzie" (2 opcje). Jest to $2^d$ przypadków.
- Odejmując $2^d + 2^d$, dwukrotnie odjęliśmy przypadek, gdzie zarówno $X$ jak i $Y$ są puste (wszystkie elementy są "nigdzie"). Należy go dodać ($+1$).

Zatem liczba reguł:
$ |R| = 3^d - (2^d + 2^d - 1) = 3^d - 2 dot 2^d + 1 = 3^d - 2^(d+1) + 1 $
#h(1fr) $qed$



= Ćwiczenie 51 -- Przechodniość reguł

*Pytanie:* Czy jeśli $"Conf"(A -> B) > "próg"$ i $"Conf"(B -> C) > "próg"$, to $"Conf"(A -> C)$ musi być wysokie?

*Odpowiedź:* *Nie.* Reguły asocjacyjne nie są przechodnie.

*Przykład:*
Rozważmy 100 transakcji.
- $A$ występuje w 10 transakcjach.
- $B$ występuje w 10 transakcjach.
- $C$ występuje w 10 transakcjach.
- $A$ i $B$ współwystępują w 9 transakcjach ($A -> B$, conf = 0.9).
- $B$ i $C$ współwystępują w 9 transakcjach ($B -> C$, conf = 0.9).
- Jednak zbiory $"A, B"$ oraz $"B, C"$ mogą "wymijać się" wewnątrz $B$ tak bardzo, jak to możliwe. W skrajnym przypadku część wspólna $A$ i $C$ może być za mała.
#align(center)[#table(
  columns: 12,
  [A], [A], [A], [A], [A], [A], [A], [A], [A], [A], [], [],
  [], [B], [B], [B], [B], [B], [B], [B], [B], [B], [B], [],
  [], [], [C], [C], [C], [C], [C], [C], [C], [C], [C], [C],
)]
W powyższym przykładzie $"Conf"(A -> B) = 0.9$ oraz $"Conf"(B -> C) = 0.9$, ale $"Conf"(A -> C) = 0.8$. Dla $"Conf"_min in (0.8, 0.9)$ reguła przechodznia $A -> C$ ma mniejszą ufność.



= Ćwiczenie 52 -- Dowód nierówności

*Założenie:* Ufność reguły $A -> B$ jest mniejsza niż wsparcie $B$, co zapisujemy jako:
$ "Conf"(A -> B) < "Supp"(B) $

W języku prawdopodobieństwa warunkowego oznacza to:
$ P(B|A) < P(B) $
(Obecność A zmniejsza prawdopodobieństwo wystąpienia B — korelacja ujemna).

Chcemy udowodnić, że dla $dash(A)$ ("brak $A$"):
- a) $"Conf"(dash(A) -> B) > "Conf"(A -> B)$
- b) $"Conf"(dash(A) -> B) > "Supp"(B)$

*Kolejność dowodzenia:* Najpierw udowodnimy podpunkt *b)*, ponieważ podpunkt *a)* wynika z niego bezpośrednio.

== Podpunkt b)
#theorem[ $"Conf"(dash(A) -> B) > "Supp"(B)$]

#proof[
Skorzystajmy z Prawa Prawdopodobieństwa Całkowitego dla zdarzenia $B$. Prawdopodobieństwo $P(B)$ jest średnią ważoną prawdopodobieństw warunkowych:
$ P(B) &= P(B|A)P(A) + P(B|dash(A))P(dash(A))\
P(B) &= P(B|A)P(A) + P(B|dash(A))(1 - P(A))\
P(B) - P(B|A)P(A) &= P(B|dash(A))(1 - P(A)) $

$ P(B|A) < P(B)\ arrow.double.b\ P(B|A) = P(B) - epsilon, space 0 < epsilon < 1 $

Podstawiając do lewej strony równania:
$ P(B) - (P(B) - epsilon)P(A) &= P(B) - P(B)P(A) + epsilon P(A) \
&= P(B)(1 - P(A)) + epsilon P(A) $

$ P(B)(1 - P(A)) + epsilon P(A) = P(B|dash(A))(1 - P(A)) $

Dzielimy obie strony przez $(1 - P(A))$ (zakładając, że $P(A) != 1$):
$ P(B) + (epsilon P(A))/(1 - P(A)) = P(B|dash(A)) $

Ponieważ $epsilon > 0$ oraz $P(A) >= 0$, ułamek $(epsilon P(A))/(1 - P(A))$ jest liczbą dodatnią. Zatem:
$ P(B|dash(A)) > P(B) $

Co w notacji reguł asocjacyjnych oznacza:
$ "Conf"(dash(A) -> B) > "Supp"(B) $
]

== Podpunkt a)
#theorem[ $"Conf"(dash(A) -> B) > "Conf"(A -> B)$]

#proof[
Korzystamy z własności przechodniości nierówności.

+ Z udowodnionego przed chwilą punktu *b)* wiemy, że:
  $ "Conf"(dash(A) -> B) > "Supp"(B) $

+ Z *założenia* w treści zadania wiemy, że:
  $ "Supp"(B) > "Conf"(A -> B) $

Łącząc te dwa fakty otrzymujemy ciąg nierówności:
$ "Conf"(dash(A) -> B) > "Supp"(B) > "Conf"(A -> B) $

Z czego wynika bezpośrednio:
$ "Conf"(dash(A) -> B) > "Conf"(A -> B) $
]

= Ćwiczenie 53 -- Miary oceny reguł

Poniższa tabela przedstawia definicje miar (gdzie $P(X)$ oznacza $"Supp"(X)$) wraz z ich intuicyjnym znaczeniem.

#set math.equation(numbering: none)
#table(
  columns: (auto, 2fr, 2fr),
  inset: 10pt,
  align: horizon,
  fill: (col, row) => if row == 0 { luma(230) } else { white },
  [*Miara*], [*Definicja / Wzór*], [*Intuicja / Interpretacja*],

  [*Lift* \ (Uniesienie)],
  $ (P(A inter B))/(P(A)P(B)) = ("Conf"(A -> B))/("Supp"(B)) $,
  [O ile razy częściej A i B występują razem, niż gdyby były niezależne? \
  $1$ = brak związku (losowość). \
  $>1$ = A przyciąga B (promocja łączona ma sens).],

  [*Leverage*],
  $ P(A inter B) - P(A)P(B) $,
  [Mierzy "nadwyżkę" transakcji. Ile dokładnie transakcji więcej (lub mniej) obserwujemy w porównaniu do oczekiwań losowych? W przeciwieństwie do Lift, jest to różnica bezwzględna.],

  [*Conviction* \ (Przekonanie)],
  $ (1 - "Supp"(B))/(1 - "Conf"(A -> B)) = (P(A)P(!= B))/(P(A inter != B)) $,
  [Mierzy siłę implikacji. Jak bardzo reguła myliłaby się, gdyby A i B były niezależne? \
  Wartość $infinity$ oznacza, że reguła $A -> B$ jest zawsze prawdziwa (pełna implikacja logiczna).],

  [*Jaccard*],
  $ (P(A inter B))/(P(A union B)) = (P(A inter B))/(P(A) + P(B) - P(A inter B)) $,
  [Podobieństwo zbiorów. Jaki procent transakcji zawierających *przynajmniej jeden* z tych produktów, zawiera *oba*? Ignoruje transakcje, w których nie ma ani A, ani B.],

  [*Cosine*],
  $ (P(A inter B))/(sqrt(P(A)P(B))) $,
  [Podobieństwo geometryczne. Wartość między 0 a 1. Jest to średnia geometryczna z ufności w obie strony ($A -> B$ i $B -> A$). Dobra miara, gdy liczności A i B są podobne.],

  [*Kulczynski*],
  $ (1)/(2) ( P(B|A) + P(A|B) ) $,
  [Średnia arytmetyczna z ufności w obu kierunkach. \
  Neutralizuje problem, gdy jeden produkt jest bardzo popularny, a drugi niszowy (nie faworyzuje żadnej strony).],

  [*Zhang*],
  $ (P(A inter B) - P(A)P(B))/(max(\ P(A inter B)(1-P(A)),\ P(A)(P(B)-P(A inter B))\ )) $,
  [Kompleksowa miara (od -1 do +1). \
  $+1$: Idealna pozytywna asocjacja. \
  $-1$: Idealna negatywna asocjacja (rozłączność). \
  $0$: Brak związku.]
)
