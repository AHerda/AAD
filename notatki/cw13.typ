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
