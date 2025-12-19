#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 12],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [9 stycznia 2025 r.],
)


= Zadanie 43 -- Obliczenia PCA

Dane są punkty: $(2, 3), (3, 4), (4, 5), (5, 6), (6, 7)$. Liczba obserwacji $n = 5$.

== Średnia każdej zmiennej

Obliczamy średnie arytmetyczne dla $X$ i $Y$:

$ dash(X) = (2 + 3 + 4 + 5 + 6) / 5 = 20 / 5 = 4 $
$ dash(Y) = (3 + 4 + 5 + 6 + 7) / 5 = 25 / 5 = 5 $

== Macierz kowariancji

Najpierw centrujemy dane (odejmujemy średnie od każdej obserwacji):
$ X_c = [-2, -1, 0, 1, 2] $
$ Y_c = [-2, -1, 0, 1, 2] $

Wzór na kowariancję dla próbki (dzielenie przez $n-1$):
$ "Cov"(A, B) = (sum_(i=1)^n (a_i - dash(a))(b_i - dash(b))) / (n-1) $

Obliczamy wariancje i kowariancję (gdzie $n-1 = 4$):
$ s_X^2 &= ((-2)^2 + (-1)^2 + 0^2 + 1^2 + 2^2) / 4 = (4+1+0+1+4)/4 = 10/4 = 2.5 \
s_Y^2 &= ((-2)^2 + (-1)^2 + 0^2 + 1^2 + 2^2) / 4 = 10/4 = 2.5 \
"Cov"(X, Y) &= ((-2)(-2) + (-1)(-1) + 0 + 1(1) + 2(2)) / 4 = (4+1+0+1+4)/4 = 2.5 $

Macierz kowariancji $C$:
$ C = mat(2.5, 2.5; 2.5, 2.5) $

== Wartości własne i wektory własne

Rozwiązujemy równanie charakterystyczne $det(C - lambda I) = 0$:
$ det mat(2.5 - lambda, 2.5; 2.5, 2.5 - lambda) = 0 \
(2.5 - lambda)^2 - 2.5^2 = 0 \
(2.5 - lambda - 2.5)(2.5 - lambda + 2.5) = 0 \
-lambda(5 - lambda) = 0 $

Wartości własne to:
$ lambda_1 = 5, quad lambda_2 = 0 $

Wyznaczamy wektory własne:
\ \
*Dla $lambda_1 = 5$:*
$ mat(2.5 - 5, 2.5; 2.5, 2.5 - 5) vec(x, y) &= vec(0, 0)\ mat(-2.5, 2.5; 2.5, -2.5) vec(x, y) &= vec(0, 0) $
Równanie: $-2.5x + 2.5y = 0 arrow x = y$.
Znormalizowany wektor własny: $ v_1 = vec(1/sqrt(2), 1/sqrt(2)) or v_1 = vec(- 1/ sqrt(2), -1 / sqrt(2)) $

*Dla $lambda_2 = 0$:*
$ mat(2.5, 2.5; 2.5, 2.5) vec(x, y) = vec(0, 0) arrow x = -y $
Znormalizowany wektor własny: $ v_2 = vec(1/sqrt(2), -1/sqrt(2)) or v_2 = vec(-1 / sqrt(2), 1 / sqrt(2)) $

== Interpretacja

*Wybór głównych składowych:*
Całkowita wariancja wynosi $lambda_1 + lambda_2 = 5 + 0 = 5$.
* Pierwsza składowa ($P C 1$, związana z $lambda_1$) wyjaśnia $5/5 = 100\%$ wariancji.
* Druga składowa ($P C 2$, związana z $lambda_2$) wyjaśnia $0\%$ wariancji.

*Decyzja:* Należy wybrać tylko *pierwszą główną składową*.
*Uzasadnienie:* Wszystkie punkty leżą idealnie na prostej ($y = x + 1$). Redukcja do jednego wymiaru nie powoduje żadnej utraty informacji. Druga składowa jest zbędna (szum wynosi zero).

*Analiza przypadku odstającego: punkt (6, 7) zamieniony na (6, 107)*

Zastąpienie punktu $(6, 7)$ punktem $(6, 107)$ drastycznie zmienia sytuację:
+ / Średnia: Średnia $Y$ znacznie wzrośnie.
+ / Wariancja: Wariancja zmiennej $Y$ stanie się ogromna w porównaniu do wariancji $X$.
+ / Kierunek: Główna składowa (PC1) obróci się i będzie prawie równoległa do osi $Y$ (ponieważ tam jest teraz największa zmienność).
+ / Wynik: PCA jest bardzo wrażliwe na wartości odstające (outliers), ponieważ opiera się na kowariancji/wariancji (kwadratach odchyleń). Ten jeden punkt zdominuje wynik analizy.


= Zadanie 44 -- Ortogonalność wektorów własnych

#theorem[Pokaż, że wektory własne symetrycznej macierzy kowariancji $C$ odpowiadające różnym wartościom własnym $lambda_i != lambda_j$ są ortogonalne.]

#proof[
  Niech $v_i$ oraz $v_j$ będą wektorami własnymi macierzy $C$ odpowiadającymi odpowiednio wartościom własnym $lambda_i$ oraz $lambda_j$. Z definicji mamy:
  $ C v_i = lambda_i v_i quad "oraz" quad C v_j = lambda_j v_j $

  Rozważmy wyrażenie $v_i^T C v_j$. Ponieważ $C v_j = lambda_j v_j$, mamy:
  $ v_i^T C v_j = v_i^T (lambda_j v_j) = lambda_j v_i^T v_j $

  Z drugiej strony, transponując skalar (który jest równy swojej transpozycji) i korzystając z faktu, że macierz kowariancji jest symetryczna ($C = C^T$):
  $ v_i^T C v_j = (v_i^T C v_j)^T = v_j^T C^T v_i = v_j^T C v_i $
  Podstawiając $C v_i = lambda_i v_i$:
  $ v_j^T (lambda_i v_i) = lambda_i v_j^T v_i = lambda_i v_i^T v_j $

  Mamy zatem równość:
  $ lambda_j v_i^T v_j = lambda_i v_i^T v_j $
  Przekształcając:
  $ (lambda_i - lambda_j) v_i^T v_j = 0 $

  Ponieważ z założenia $lambda_i != lambda_j$, to różnica $(lambda_i - lambda_j) != 0$. Aby równanie było prawdziwe, musi zachodzić:
  $ v_i^T v_j = 0 $
  Oznacza to, że wektory $v_i$ i $v_j$ są ortogonalne.
]

= Zadanie 45 -- Prawda czy Fałsz o PCA

#show "PRAWDA": set text(green.darken(10%))
#show "FAŁSZ": set text(red.darken(10%))

Zakładamy, że wartości własne są unikalne.

+ *Dodanie jedynki na końcu każdego punktu próbki nie zmienia wyników przeprowadzenia PCA (z wyjątkiem dodatkowej składowej z wartością własną 0).*

  *Odpowiedź:* *PRAWDA*.
  PCA operuje na macierzy kowariancji (dane scentrowane). Dodanie stałej wartości (np. 1) jako nowej cechy oznacza, że wariancja tej cechy wynosi 0. Po scentrowaniu otrzymamy kolumnę zer. Nie wpłynie to na relacje wariancji między oryginalnymi cechami, a jedynie doda wymiar o zerowej wariancji (wartość własna 0).

+ *Sekwencyjna redukcja wymiarowości ($d -> j -> k$) daje ten sam wynik co bezpośrednia redukcja ($d -> k$).*

  *Odpowiedź:* *PRAWDA*.
  PCA sortuje składowe według wariancji. Wybranie najlepszych $j$ składowych, a następnie wybranie z nich najlepszych $k$ składowych, jest tożsame z wybraniem od razu $k$ najlepszych składowych z pierwotnego zbioru (ponieważ zbiór $k$ najlepszych zawiera się w zbiorze $j$ najlepszych dla $k < j$).

+ *Obrót punktów przed PCA nie zmienia kierunków głównych składowych.*

  *Odpowiedź:* *FAŁSZ*.
  Jeśli obrócimy dane wejściowe, struktura kowariancji się zmienia. Główne składowe (wektory własne) obracają się wraz z danymi. Chociaż *względna* geometria chmury punktów jest taka sama, to wektory własne (które są wyrażone w układzie współrzędnych cech) zmienią swoje współrzędne.

+ *Obrót punktów przed PCA nie zmienia największej wartości własnej.*

  *Odpowiedź:* *PRAWDA*.
  Wartości własne reprezentują wariancję (rozrzut) danych wzdłuż głównych osi. Obrót chmury punktów w przestrzeni nie zmienia "kształtu" tej chmury ani wielkości jej rozrzutu, jedynie jej orientację względem osi. Zatem wielkość maksymalnej wariancji ($lambda_1$) pozostaje taka sama.
