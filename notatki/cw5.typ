#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 5],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: "7 listopada 2025 r.",
)

= Zadanie 15 - Korelacja

$
"TSS" &= sum_(i=1)^n (Y_i - dash(Y)_i)^2 = S_(y y)\
&= sum_(i=1)^n (Y_i - hat(Y)_i + hat(Y)_i - dash(Y)_i)^2\
&= underbrace(sum_(i=1)^n (Y_i - hat(Y)_i)^2, "RSS") + underbrace(sum_(i=1)^n (hat(Y)_i - dash(Y)_i)^2, "ESS") - 2 underbrace(sum_(i=1)^n (Y_i - hat(Y)_i)(hat(Y)_i - dash(Y)_i), "Własność ortogalności reszt" -> space 0)\
&= "RSS" + "ESS" $

$
  hat(beta)_0 &= dash(Y)_i - hat(beta)_1 dash(X)\
  hat(Y)_i &= hat(beta)_0 + hat(beta)_1 X_i\
  &= (dash(Y)_i - hat(beta)_1 dash(X))) + hat(beta)_1 X_i\
  &= dash(Y)_i + hat(beta)_1 (X_i - dash(X))\
  hat(Y)_i - dash(Y)_i &= hat(beta)_1 (X_i - dash(X))\
  "ESS" &= hat(beta)_1^2 S_(y y)\
  hat(beta)_1 &= S_(x y) / S_(x x)
$

$
  R^2 &= 1 - "RSS" / "TSS"\ &= ("RSS" + "ESS" - "RSS") / "TSS"\ &= "ESS" / "TSS"\ &= (S_(x y) / S_(x x))^2 S_(x x) / S_(y y)\
  &= S_(x y)^2 / (S_(x x) S_(y y))\ &= "Corr"(X, Y)^2
$
#h(1fr) #sym.qed

= Zadanie 16 - t-statystyka i p-wartość

Wyjaśnij czym jest t-statystyka i w jaki sposób możemy jej użyć w kontekście regresji
liniowej. Czym jest p-wartość?

== t-statystyka

t-statystyka to miara używana w statystyce do oceny istotności współczynników regresji w modelu regresji liniowej. Określa, jak wiele standardowych błędów odchyla się estymowany współczynnik od wartości zerowej (hipoteza zerowa). Wzór na t-statystykę dla współczynnika regresji $hat(beta)_j$ jest następujący:
$ t_j = (hat(beta)_j - 0) / "SE"(hat(beta)_j) $
gdzie $"SE"(hat(beta)_j)$ to standardowy błąd estymatora współczynnika regresji $hat(beta)_j$.

== p-wartość

p-wartość to prawdopodobieństwo uzyskania wyników co najmniej tak ekstremalnych jak obserwowane,
zakładając, że hipoteza zerowa jest prawdziwa. W kontekście regresji liniowej,
p-wartość jest używana do oceny istotności statystycznej współczynników regresji.
Niska p-wartość (zazwyczaj poniżej 0.05) sugeruje odrzucenie hipotezy zerowej, co oznacza,
że istnieje statystycznie istotny związek między zmienną niezależną a zmienną zależną.

= Zadanie 17 - Odległość Mahalanobisa

Wyjaśnij czym jest odległość Mahalanobisa i jaki jest jej związek z leverage statistic.

== odpowiedź

Odległość Mahalanobisa to miara odległości między punktem a rozkładem prawdopodobieństwa.
W przeciwieństwie do standardowej odległości euklidesowej,
odległość Mahalanobisa uwzględnia korelacje między zmiennymi i skalę danych. Jest definiowana jako:

$ D_M(x) = sqrt((x - mu)^T S^(-1) (x - mu)) $
gdzie $mu$ to wektor średnich zmiennych, a $S$ to macierz kowariancji.

Odległość Mahalanobisa jest szczególnie użyteczna w kontekście analizy regresji,
ponieważ pozwala na identyfikację obserwacji, które są nietypowe lub odstające w kontekście całego zbioru danych.
Wartości odległości Mahalanobisa mogą być używane do obliczania statystyki leverage,
która mierzy wpływ danej obserwacji na dopasowanie modelu regresji.
Obserwacje o wysokiej odległości Mahalanobisa mogą mieć duży wpływ na estymację współczynników regresji i mogą być potencjalnymi punktami odstającymi.

= Zadanie 18 - Double descent

Na podstawie materiału wideo i rozdziału 10.8 w książce ISL opisz zjawisko double
descent

== Odpowiedź

- W fazie podparametryzowanej („under-parameterized”) - model nie ma wystarczającej mocy,
  by dobrze dopasować dane #sym.arrow testowy błąd jest stosunkowo wysoki, ale spada wraz ze wzrostem złożoności.

- Następnie w okolicy punktu, kiedy liczba parametrów #sym.approx
  liczba próbek (lub model może dokładnie dopasować dane) -
  następuje wzrost błędu testowego (szczyt) z powodu dużej wariancji, niestabilności.

- Potem, w nadparametryzowanej („over-parameterized”) fazie -
  mimo że model może „przeuczyć” dane, okazuje się, że zwiększanie złożoności dalej prowadzi do spadku błędu testowego.
  Model bardzo duży generalizuje lepiej niż średni.
