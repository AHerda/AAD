#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 9],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [5 grudnia 2025 r.],
)

= Ćwiczenie 32 -- Klasyfikacja wieloklasowa a entropia krzyżowa

W problemie klasyfikacji wieloklasowej (gdzie mamy $K$ klas), zmienną celu dla $i$-tej obserwacji możemy zapisać jako wektor one-hot $bold(y)^((i)) = [y_1^((i)), ..., y_K^((i))]$, gdzie $y_k^((i)) = 1$ jeśli obserwacja należy do klasy $k$, a $0$ w przeciwnym razie. Model przewiduje prawdopodobieństwa $hat(y)_k^((i))$ (np. za pomocą funkcji Softmax).

Funkcja wiarygodności (Likelihood) dla $N$ niezależnych obserwacji ma postać:

$ L(theta) = product_(i=1)^N product_(k=1)^K (hat(y)_k^((i)))^(y_k^((i))) $

Aby ułatwić optymalizację, stosujemy logarytm naturalny wiarygodności (Log-Likelihood):

$ ln L(theta) = ln (product_(i=1)^N product_(k=1)^K (hat(y)_k^((i)))^(y_k^((i)))) = sum_(i=1)^N sum_(k=1)^K y_k^((i)) ln(hat(y)_k^((i))) $

Maksymalizacja funkcji wiarygodności jest równoważna minimalizacji jej odwrotności ze znakiem minus (negative log-likelihood):

$ "NLL" = - sum_(i=1)^N sum_(k=1)^K y_k^((i)) ln(hat(y)_k^((i))) $

Powyższy wzór to nic innego jak suma *entropii krzyżowych* pomiędzy rozkładem rzeczywistym $y$ a przewidywanym $hat(y)$. Zatem maksymalizacja wiarygodności w klasyfikacji wieloklasowej jest tożsama z minimalizacją entropii krzyżowej.

= Ćwiczenie 34 -- Entropia, Entropia Krzyżowa i Dywergencja KL

Niech $P$ będzie prawdziwym rozkładem prawdopodobieństwa, a $Q$ rozkładem aproksymującym (modelowanym). Zdefiniujmy miary dla zmiennych dyskretnych:

+ / Entropia Shannona ($H(P)$): Miara niepewności lub ilości informacji zawartej w rozkładzie $P$. $ H(P) = - sum_x P(x) log P(x) $

+ / Entropia krzyżowa ($H(P, Q)$): Średnia liczba bitów potrzebna do zakodowania zdarzeń z rozkładu $P$ przy użyciu kodowania optymalnego dla rozkładu $Q$. $ H(P, Q) = - sum_x P(x) log Q(x) $

+ / Dywergencja Kullbacka-Leiblera ($D_"KL"(P || Q)$): Miara "odległości" (straty informacji) przy zastąpieniu prawdziwego rozkładu $P$ rozkładem $Q$. $ D_"KL"(P || Q) = sum_x P(x) log(P(x)/Q(x)) $

== Związek między miarami
Rozpisując wzór na dywergencję KL:
$ D_"KL"(P || Q) &= sum_x P(x) (log P(x) - log Q(x)) \
&= sum_x P(x) log P(x) - sum_x P(x) log Q(x) \
&= -H(P) + H(P, Q) $

Stąd otrzymujemy kluczową zależność:
$ H(P, Q) = H(P) + D_"KL"(P || Q) $

Interpretacja: Entropia krzyżowa to entropia własna danych plus "kara" (dywergencja KL) za niedopasowanie modelu $Q$ do rzeczywistości $P$.

= Ćwiczenie 35 -- Entropia różniczkowa

== Definicja
Dla zmiennej losowej ciągłej $X$ o gęstości prawdopodobieństwa $f(x)$, entropia różniczkowa wynosi:
$ h(X) = - integral_(-infinity)^(infinity) f(x) log f(x) dif x $

== Ujemna wartość entropii różniczkowej
W przeciwieństwie do przypadku dyskretnego, $h(X)$ może być ujemna, ponieważ $f(x)$ może przyjmować wartości $> 1$.
*Przykład:* Rozkład jednostajny na przedziale $[0, a]$, gdzie $a < 1$ (np. $a=0.5$).
$ f(x) = cases(1/a "dla" x in [0, a], 0 "w p.p.") $
$ h(X) = - integral_0^a 1/a log(1/a) dif x = - 1/a log(1/a) dot a = - log(1/a) = log(a) $
Dla $a = 0.5$, $h(X) = log(0.5) < 0$.

== Skalowanie zmiennej ($H(a X)$)
Niech $Y = a X$ dla $a > 0$. Gęstość prawdopodobieństwa $Y$ to $f_Y(y) = 1/a f_X(y/a)$.
$ h(Y) &= - integral f_Y(y) log f_Y(y) dif y \
&= - integral 1/a f_X(y/a) log(1/a f_X(y/a)) dif y $
Podstawiając $x = y/a$ (więc $dif y = a dif x$):
$ &= - integral 1/a f_X(x) (log f_X(x) - log a) a dif x \
&= - integral f_X(x) log f_X(x) dif x + log a integral f_X(x) dif x \
&= h(X) + log a $

== Maksymalna entropia rozkładu normalnego
Wiemy, że $D_"KL"(f || g) >= 0$ (Nierówność Gibbsa).
Niech $f(x)$ będzie dowolnym rozkładem o średniej $mu$ i wariancji $sigma^2$, a $g(x)$ będzie rozkładem normalnym $cal(N)(mu, sigma^2)$.

$ D_"KL"(f || g) = integral f(x) log(f(x)/g(x)) dif x = -h(f) - integral f(x) log g(x) dif x >= 0 $
Stąd: $h(f) <= - integral f(x) log g(x) dif x$.

Obliczmy prawą stronę dla $g(x) = frac(1, sqrt(2 pi sigma^2)) exp(- frac((x-mu)^2, 2sigma^2))$:
$ - integral f(x) [ -1/2 log(2 pi sigma^2) - frac((x-mu)^2, 2sigma^2) ] dif x \
= 1/2 log(2 pi sigma^2) integral f(x) dif x + frac(1, 2sigma^2) integral f(x) (x-mu)^2 dif x $
Ponieważ $f$ ma wariancję $sigma^2$, całka $integral f(x)(x-mu)^2 dif x = sigma^2$. Oraz $integral f(x) dif x = 1$.
$ = 1/2 log(2 pi sigma^2) + 1/2 = 1/2 log(2 pi e sigma^2) $
Wartość ta jest dokładnie entropią rozkładu normalnego $h(g)$.
Zatem $h(f) <= h(g)$, co dowodzi, że rozkład normalny ma największą entropię przy ustalonej wariancji.

= Ćwiczenie 36 -- Miary odległości między rozkładami

Oto zestawienie popularnych miar dla rozkładów $P$ i $Q$ (gęstości $p(x)$ i $q(x)$):

#set math.equation(numbering: none)
#table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  [*Miara*], [*Opis i Własności*],

  [*Dywergencja Kullbacka-Leiblera (KL)*\ $ D_"KL"(P || Q) = integral p(x) log(p(x)/q(x)) dif x $],
  [
    - *Intuicja:* Strata informacji przy aproksymacji $P$ przez $Q$.
    - *Własności:* Nieujemna ($>=0$), równa 0 wtw gdy $P=Q$.
    - *Uwaga:* Nie jest metryką (nie jest symetryczna: $D_"KL"(P||Q) != D_"KL"(Q||P)$ i nie spełnia nierówności trójkąta).
  ],

  [*Odległość Hellingera* \ $ H^2(P, Q) = 1/2 integral (sqrt(p(x)) - sqrt(q(x)))^2 dif x $],
  [
    - *Intuicja:* Euklidesowa odległość między pierwiastkami z gęstości.
    - *Własności:* Jest to *metryka*. Przyjmuje wartości w zakresie $[0, 1]$. Jest symetryczna.
    - Przydatna w teorii estymacji i statystyce asymptotycznej.
  ],

  [*Total Variation Distance (TV)* \ $ T V(P, Q) = sup_A |P(A) - Q(A)| \ = 1/2 integral |p(x) - q(x)| dif x $],
  [
    - *Intuicja:* Największa możliwa różnica w prawdopodobieństwie przypisanym temu samemu zdarzeniu przez dwa rozkłady.
    - *Własności:* Jest metryką ($L_1$ norm). Ograniczona $0 <= T V <= 1$.
    - Bardzo restrykcyjna miara zbieżności.
  ],

  [*Odległość Wassersteina (Earth Mover's)* \ $ W(P, Q) = inf_(gamma in Pi(P, Q)) EE_((x, y) ~ gamma) [||x - y||] $],
  [
    - *Intuicja:* Minimalny "koszt" (masa $times$ droga) przesunięcia masy prawdopodobieństwa z rozkładu $P$, by uformować $Q$.
    - *Własności:* Jest metryką. Działa świetnie nawet gdy rozkłady mają rozłączne nośniki (gdzie KL byłoby nieskończone). Kluczowa w GAN-ach (WGAN).
  ]
)