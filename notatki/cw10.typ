#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 10],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [12 grudnia 2025 r.],
)

= Ćwiczenie 37-- Własności próby bootstrapowej

Niech $X$ oznacza liczbę unikalnych obserwacji w próbce bootstrapowej rozmiaru $n$.

== Wartość oczekiwana $X$

Zdefiniujmy zmienną indykatorową $I_j$ dla $j$-tej obserwacji z oryginalnej próby (gdzie $j = 1, ..., n$):
$ I_j = cases(1 & "jeśli obserwacja" j "znalazła się w próbie bootstrapowej", 0 & "w przeciwnym wypadku") $

Liczba unikalnych obserwacji to suma indykatorów: $X = sum_(j=1)^n I_j$.

Prawdopodobieństwo, że konkretna obserwacja $j$ *nie* zostanie wylosowana w pojedynczym losowaniu wynosi $(1 - 1/n)$. Ponieważ próba bootstrapowa polega na $n$-krotnym losowaniu ze zwracaniem, prawdopodobieństwo, że obserwacja $j$ nie znajdzie się w całej próbie wynosi:
$ P(I_j = 0) = (1 - 1/n)^n $

Zatem prawdopodobieństwo, że obserwacja $j$ znajdzie się w próbie (jest unikalna) to:
$ EE[I_j] = P(I_j = 1) = 1 - (1 - 1/n)^n $

Korzystając z liniowości wartości oczekiwanej:
$ EE[X] = EE[sum_(j=1)^n I_j] = sum_(j=1)^n EE[I_j] = n dot (1 - (1 - 1/n)^n) $

Dla dużych $n$, korzystając z granicy $lim_(n->infinity) (1 - a/n)^n = e^(-a)$:
$ EE[X] approx n(1 - e^(-1)) approx 0.632n $

== Wariancja $X$

Wariancję sumy zmiennych zależnych wyrażamy wzorem:
$ "Var"(X) = sum_(j=1)^n "Var"(I_j) + sum_(j != k) "Cov"(I_j, I_k) $

*Wariancja pojedynczego indykatora:*
$ "Var"(I_j) &= EE[I_j^2] - EE[I_j]^2\ &= EE[I_j] - EE[I_j]^2\ &= EE[I_j](1 - EE[I_j])\ &= (1 - (1 - 1/n)^n)(1 - 1/n)^n $

*Kowariancja:*
$ "Cov"(I_j, I_k) = E[I_j I_k] - E[I_j]E[I_k] $
$ E[I_j I_k] &= 1 dot P(j in S and k in S) + 0 dot P(j in S and k in S)\ &= P(j in S and k in S) $ to prawdopodobieństwo, że *zarówno* $j$ jak i $k$ są w próbie. Łatwiej policzyć to przez dopełnienie:
$ P(j in S and k in S) = 1 - P(j in.not S or k in.not S) $
$ = 1 - [P(j in.not S) + P(k in.not S) - P(j in.not S and k in.not S)] $
Gdzie $P(j in.not S and k in.not S) = (1 - 2/n)^n$.

Po podstawieniu i uproszczeniu dla dużych $n$, otrzymujemy przybliżenie:
$ "Var"(X) approx n [e^(-1)(1 - e^(-1)) - n(e^(-1) - e^(-2))] $
W praktyce dla dużych $n$ wariancja ta dąży do:
$ "Var"(X) approx n dot e^(-1)(1 - e^(-1)) approx n dot 0.233 $

== Odsetek unikalnych obserwacji i jego wariancja

Niech $hat(p)$ będzie odsetkiem unikalnych obserwacji: $hat(p) = X/n$.\
=== Średnia
$ E[hat(p)] = E[X/n] = 1/n E[X] = 1 - (1 - 1/n)^n approx 1 - e^(-1) approx 0.632 $

=== Wariancja
$ "Var"(hat(p)) = "Var"(X/n) = 1/n^2 "Var"(X) $
Dla dużych $n$, wariancja odsetka maleje rzędu $1/n$.

== Prawdopodobieństwo braku obserwacji w $k$ próbkach

Prawdopodobieństwo, że dana obserwacja nie znajdzie się w jednej próbie bootstrapowej wynosi $(1 - 1/n)^n approx e^(-1)$.
Ponieważ próbki są generowane niezależnie, prawdopodobieństwo, że obserwacja nie znajdzie się w żadnej z $k$ próbek wynosi:
$ P("brak w " k " próbkach") = [(1 - 1/n)^n]^k approx (e^(-1))^k = e^(-k) $

= Ćwiczenie 38 -- Konstrukcja drzewa i predyktory kategoryczne

== Konstrukcja drzewa
Drzewa decyzyjne konstruowane są zazwyczaj za pomocą algorytmu zachłannego (np. CART, C4.5). Proces polega na rekurencyjnym podziale przestrzeni cech na prostokątne regiony. W każdym kroku wybierana jest zmienna oraz punkt podziału, które najlepiej rozdzielają dane względem zmiennej celu (minimalizując np. RSS dla regresji lub wskaźnik Giniego/entropię dla klasyfikacji).

== Problem z predyktorem kategorycznym
Dla predyktora kategorycznego z $q$ możliwymi nieuporządkowanymi wartościami, podział polega na przydzieleniu pewnego podzbioru wartości do lewego węzła, a reszty do prawego.

*Liczba możliwych podziałów:*
Aby podzielić zbiór $q$ wartości na dwie niepuste grupy, rozważamy wszystkie możliwe podzbiory. Zbiór $q$-elementowy ma $2^q$ podzbiorów.
1. Odejmujemy zbiór pusty i zbiór pełny (podział musi być na dwie grupy): $2^q - 2$.
2. Ponieważ podział $\{A, B\}$ vs $\{C\}$ jest tożsamy z $\{C\}$ vs $\{A, B\}$, wynik dzielimy przez 2.

Liczba podziałów wynosi:
$ (2^q - 2) / 2 = 2^(q-1) - 1 $

*Problem:* Liczba ta rośnie wykładniczo wraz z $q$. Przeszukiwanie wszystkich podziałów jest obliczeniowo bardzo kosztowne dla dużego $q$. Dodatkowo, zmienne o dużej liczbie kategorii są faworyzowane przez algorytm doboru zmiennych (tzw. bias doboru).

== Rozwiązanie problemu
Dla binarnej klasyfikacji (0/1) lub regresji istnieje efektywne rozwiązanie (Fisher, 1958):
1. Oblicz średnią wartość zmiennej celu dla każdej kategorii predyktora.
2. Uporządkuj kategorie według tych średnich rosnąco.
3. Potraktuj zmienną kategoryczną jak zmienną ciągłą (uporządkowaną) i sprawdzaj podziały tylko wzdłuż tego porządku.
Redukuje to liczbę sprawdzanych podziałów z $2^(q-1)-1$ do $q-1$.

= Ćwiczenie 39 -- Miary jakości podziału

== a) Interpretacja indeksu Giniego

Indeks Giniego dla węzła $m$ zdefiniowany jest jako:
$ G = sum_(k=1)^K p_(m k) (1 - p_(m k)) = 1 - sum_(k=1)^K p_(m k)^2 $
gdzie $p_(m k)$ to frakcja obserwacji klasy $k$ w węźle $m$.

*Interpretacja:*
Indeks Giniego można interpretować jako miarę "nieczystości" węzła. Reprezentuje on oczekiwany poziom błędu, jeśli klasyfikowalibyśmy losowo obserwację z węzła, losując jej etykietę zgodnie z rozkładem klas w tym węźle. Im mniejszy indeks Giniego, tym bardziej "czysty" węzeł (zdominowany przez jedną klasę).

== b) Porównanie podziałów

Mamy problem dwuklasowy (klasy A i B). W korzeniu mamy (400, 400).
Całkowita liczba obserwacji $N = 800$.

- *Analiza Podziału 1:*\
  Tworzy węzły: $N_1 (300, 100)$ oraz $N_2 (100, 300)$.
  - $N_1$ (400 obs): Dominująca klasa A. Błędne: 100 (klasa B).
  - $N_2$ (400 obs): Dominująca klasa B. Błędne: 100 (klasa A).
  - Całkowita liczba błędów: $100 + 100 = 200$.
  - *Odsetek błędnych klasyfikacji:* $200 / 800 =25$.

- *Analiza Podziału 2:*\
  Tworzy węzły: $N_3 (200, 400)$ oraz $N_4 (200, 0)$.
  - $N_3$ (600 obs): Dominująca klasa B. Błędne: 200 (klasa A).
  - $N_4$ (200 obs): Dominująca klasa A. Błędne: 0 (czysty węzeł).
  - Całkowita liczba błędów: $200 + 0 = 200$.
  - *Odsetek błędnych klasyfikacji:* $200 / 800 =25$.

Oba podziały mają ten sam Misclassification Rate ($0.25$).

== Obliczenie Indeksu Giniego

Wzór dla dwóch klas: $2p(1-p)$.

- *Dla Podziału 1:*
  - Węzeł $N_1$ ($p=0.75$): $G_1 = 1 - (0.75^2 + 0.25^2) = 1 - (0.5625 + 0.0625) =375$.
  - Węzeł $N_2$ ($p=0.25$): $G_2 = 1 - (0.25^2 + 0.75^2) =375$.
  - Średni ważony Gini:
  $ G_("split" 1) = 400/800 dot 0.375 + 400/800 dot 0.375 =375 $

- *Dla Podziału 2:*
  - Węzeł $N_3$ (200, 400), $p_A = 1/3, p_B = 2/3$:
  $ G_3 = 1 - ((1/3)^2 + (2/3)^2) = 1 - (1/9 + 4/9) = 4/9 approx 0.444 $
  - Węzeł $N_4$ (200, 0), $p_A = 1$:
  $ G_4 = 1 - (1^2 + 0^2) = 0 $ (węzeł czysty)
  - Średni ważony Gini (wagi: $600/800 = 3/4$ i $200/800 = 1/4$):
  $ G_("split" 2) = 3/4 dot 4/9 + 1/4 dot 0 = 3/9 = 1/3 approx 0.333 $

=== Wniosek

$ G_("split" 2) (0.333) < G_("split" 1) (0.375) $
Indeks Giniego jest niższy dla drugiego podziału, co oznacza, że preferuje on podział, który wydziela czysty węzeł ("pure node"), nawet jeśli globalny błąd klasyfikacji jest taki sam.
