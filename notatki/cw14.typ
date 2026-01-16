#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 14],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [23 stycznia 2025 r.],
)

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