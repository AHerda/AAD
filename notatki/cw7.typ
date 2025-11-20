#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 7],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [21 listopada 2025 r.],
)

= Zadanie 24 -- Ocena modelu w problemie klasyfikacji

== Oznaczenia

Stosujemy następujące oznaczenia w macierzy pomyłek:
- *TP* (True Positive): Prawdziwie pozytywne.
- *TN* (True Negative): Prawdziwie negatywne.
- *FP* (False Positive): Fałszywie pozytywne (błąd I rodzaju).
- *FN* (False Negative): Fałszywie negatywne (błąd II rodzaju).

== a) Metryki: Accuracy, Precision, Recall oraz F1

=== Definicje metryk

+ / Accuracy (Dokładność): Określa, jak często model ma rację.
  $ "Accuracy" = (T P + T N) / (T P + T N + F P + F N) $

+ / Precision (Precyzja): Określa wiarygodność pozytywnej predykcji (ile z przewidzianych "jedynek" to faktycznie "jedynki").
  $ "Precision" = (T P) / (T P + F P) $

+ / Recall (Czułość): Określa zdolność modelu do wykrywania klasy pozytywnej (ile faktycznych "jedynek" udało się znaleźć).
  $ "Recall" = (T P) / (T P + F N) $

+ / F1-Score: Średnia harmoniczna precyzji i czułości. Jest lepszą miarą niż Accuracy przy niezbalansowanych danych.
  $ F 1 = 2 dot (("Precision" dot "Recall") / ("Precision" + "Recall")) $

=== Przykład

Testujemy wykrywacz choroby (10 chorych, 90 zdrowych). Model wykrył 8 chorych, ale też błędnie wskazał 10 zdrowych jako chorych.
- $"Accuracy" = (8+80)/100 = 0.88$
- $"Precision" = 8/(8+10) approx 0.44$
- $"Recall" = 8/(8+2) = 0.80$

== b) Różnica wersji _micro_ od _macro_

- / Macro Average: Liczymy metrykę (np. F1) dla każdej klasy osobno, a potem wyciągamy z nich średnią. Traktuje każdą klasę równoważnie (dobre do wykrywania błędów w rzadkich klasach).
- / Micro Average: Sumujemy wszystkie TP, FP, FN globalnie i liczymy metrykę raz. W klasyfikacji wieloklasowej (single-label) Micro-F1 jest równoważne Accuracy. Faworyzuje klasy większościowe.

*Przykład:* Klasa A (100 próbek, model idealny), Klasa B (10 próbek, model tragiczny).
- *Micro* będzie wysokie (zdominowane przez A).
- *Macro* będzie niskie (uwidoczni błąd na B).

== c) Potoczne rozumienie a definicja

- / Accuracy: Potocznie "jakość". W _ML_ może być mylące - model przewidujący zawsze brak rzadkiego zdarzenia (np. wygrana w lotto) ma 99.9% accuracy, a jest bezużyteczny.
- / Precision: Potocznie kojarzy się z "dokładnością pomiaru". W ML to "brak fałszywych alarmów".

= Zadanie 25 -- Naiwny Klasyfikator Bayesa

== Definicja
/ Naiwny klasyfikator Bayesa: model probabilistyczny oparty na twierdzeniu Bayesa, który zakłada *warunkową niezależność* cech ($x_i$) od siebie przy znanej klasie ($C_k$).
Warto go stosować, gdy mamy mało danych (szybka zbieżność), bardzo wysoki wymiar danych (np. tekst) lub potrzebujemy szybkiego modelu bazowego.

== Dowód wzoru
#theorem[$
  Pr(C_k | x_1, dots.c, x_n) = 1/Pr(x) Pr(C_k) product_(i=1)^n Pr(x_i | C_k)
$]

#proof[
  Wychodzimy z twierdzenia Bayesa:
  $ Pr(C_k | x) = (Pr(x | C_k) Pr(C_k)) / Pr(x) $

  Gdzie $x = (x_1, ..., x_n)$.
  W liczniku mamy prawdopodobieństwo łączne $Pr(x_1, ..., x_n | C_k)$. Stosujemy "naiwne" założenie o niezależności cech:
  $ Pr(x_1, ..., x_n | C_k) approx product_(i=1)^n Pr(x_i | C_k) $

  Podstawiając do licznika:
  $ Pr(C_k | x) = (Pr(C_k) product_(i=1)^n Pr(x_i | C_k)) / Pr(x) $
  $ Pr(C_k | x) = 1/Pr(x) Pr(C_k) product_(i=1)^n Pr(x_i | C_k) $

  Mianownik $Pr(x)$ jest sumą po wszystkich klasach (z prawa całkowitego prawdopodobieństwa):
  $ Pr(x) = sum_k Pr(x | C_k)Pr(C_k) = sum_k ( Pr(C_k) product_(i=1)^n Pr(x_i | C_k) ) $
]

= Zadanie 26 -- Klasyfikacja Spam vs Nie-spam

Dane:
- $N = 1000$ e-maili.
- Klasa $C_1$ (Spam): 100 e-maili (wszystkie $x_1=1, x_2=1$).
- Klasa $C_2$ (Nie-spam): 900 e-maili (450: $x_1=1, x_2=0$ oraz 450: $x_1=0, x_2=1$).

Szukamy predykcji dla nowego e-maila $x = (x_1=1, x_2=1)$.

+ *Prawdopodobieństwa a priori (Priors):*
  $ Pr(C_1) = 100/1000 = 0.1 $
  $ Pr(C_2) = 900/1000 = 0.9 $
+ *Prawdopodobieństwa warunkowe (Likelihoods):*\
  - Dla $C_1$ (Spam):
    - $Pr(x_1=1 | C_1) = 100/100 = 1$
    - $Pr(x_2=1 | C_1) = 100/100 = 1$

  - Dla $C_2$ (Nie-spam):
    - $Pr(x_1=1 | C_2) = 450/900 = 0.5$
    - $Pr(x_2=1 | C_2) = 450/900 = 0.5$

+ *Obliczenia dla nowego e-maila (licznik wzoru Bayesa):*
  - Dla Spamu:
    $ L(C_1) = Pr(C_1) dot Pr(x_1=1|C_1) dot Pr(x_2=1|C_1) = 0.1 dot 1 dot 1 = 0.1 $

  - Dla Nie-spamu:
    $ L(C_2) = Pr(C_2) dot Pr(x_1=1|C_2) dot Pr(x_2=1|C_2) = 0.9 dot 0.5 dot 0.5 = 0.225 $

+ *Normalizacja i wynik:*\
  Evidence $Pr(x) = 1 dot 1 dot 0.1 + 0.5 dot 0.5 dot 0.9 = 0.1 + 0.225 = 0.325$.

  $ Pr(C_1 | x) = 0.1 / 0.325 approx 0.308 $
  $ Pr(C_2 | x) = 0.225 / 0.325 approx 0.692 $

*Odp:* Prawdopodobieństwo, że to Spam wynosi ok. 30.8%, a że Nie-spam ok. 69.2%.

= Zadanie 27 -- Regresja Logistyczna

== a) Dlaczego nie regresja liniowa?

- Predykcje mogą wykraczać poza przedział $[0, 1]$.
- Zależność rzadko jest liniowa (często przyjmuje kształt litery S).
- Niespełnione założenie o stałej wariancji reszt (heteroskedastyczność).

== b) Obliczenie szans (Odds)

Dane: $p = 0.75$.
$ "Odds" = p / (1-p) = 0.75 / (1 - 0.75) = 0.75 / 0.25 = 3 $
Szanse wynoszą 3 do 1.

== c) Dowód równoważności z Log-Odds

Model: $ Pr(X) = e^(beta_0 + beta_1 X) / (1 + e^(beta_0 + beta_1 X)) $
Oznaczmy $z = beta_0 + beta_1 X$. Wtedy $p = e^z / (1+e^z)$.

+ Obliczamy $1-p$:
  $ 1 - p = 1 - e^z / (1+e^z) = (1 + e^z - e^z) / (1+e^z) = 1 / (1+e^z) $

+ Dzielimy $p$ przez $1-p$:
  $ p / (1-p) = (e^z / (1+e^z)) / (1 / (1+e^z)) = (e^z / cancel(1+e^z)) dot  (cancel(1+e^z) / 1) = e^z $

+ Logarytmujemy obustronnie:
  $ ln(p / (1-p)) = ln(e^z) = z $

Podstawiając $z$:
  $ ln(Pr(X) / (1-Pr(X))) = beta_0 + beta_1 X $

== d) Zależność sigma a logit

Funkcja logistyczna $sigma(x)$ i funkcja logit $l(p)$ są *funkcjami odwrotnymi*.

$ sigma(x) = e^x / (1+e^x) " (odwzorowuje " RR arrow (0,1) ) $
$ l(p) = ln(p / (1-p)) " (odwzorowuje " (0,1) arrow RR ) $

Zachodzi: $ l(sigma(x)) = x $ oraz $ sigma(l(p)) = p $.
