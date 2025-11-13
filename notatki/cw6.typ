#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 6],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: datetime.today().display("[day].[Month].[year]"),
)

= Zadanie 19

Przypomnij, czym jest estymator największej wiarygodności. Przedstaw i wyjaśnij własności takiego estymatora (w szczególności asymptotyczną nieobciążonść i efektywność).

== Odpowiedź

=== Definicja

Załóżmy, że mamy próbę losową $X_1, dots.c, X_n$ pochodzącą z rozkładu o funkcji gęstości (lub masie prawdopodobieństwa) $f(x;theta)$, gdzie $theta$ to nieznany parametr populacji (np. średnia, wariancja, parametr Bernoulliego itd.).

Funkcja wiarygodności (likelihood function) określa prawdopodobieństwo zaobserwowania danej próby przy danym parametrze $theta$:
$ L(theta) = f(x_1;theta) dot dots dot f(x_n;theta) $
albo w postaci logarytmicznej (częściej stosowanej dla wygody obliczeń):
$ cal(l)(theta) = ln L(theta) = sum_(i = 1)^n ln f(x_i;theta) $
Estymator największej wiarygodności (ENW) to wartość $hat(theta)$, która maksymalizuje funkcję wiarygodności:
$ hat(theta)_"MLE" = max_theta L(theta) $
lub równoważnie:
$ hat(theta)_"MLE" = max_theta cal(l)(theta) $

=== Własności

/ Spójność: Gdy liczba obserwacji $n -> infinity$ to estymator największej wiarygodności zbliża się do prawdziwej wartości parametru $theta$ $ hat(theta)_"MLE" stretch(-->)^P theta $
/ Efektywność: Przy pewnych warunkach estymator największej wiarygodności zbliża się, w dystrybuancie, do rozkładu normalnego: $ sqrt(n)(hat(theta)_"MLE" - theta) tilde cal(N)(0, cal(I)^(-1)) $ gdzie $ cal(I)_(j k) = EE [- (partial^2 f_theta_0 (X_t)) / (partial theta_j partial theta_k)] $
to macierz informacji Fishera.

= Zadanie 20

Załóżmy, że mamy $n$ obserwacji $x_1, dots.c, x_n$ pochodzących z rozkładu normalnego zmiennej losowej $X tilde cal(N)(mu, space sigma^2)$. Wyprowadź estymator największej wiarygodności dla parametru $mu$

== Rozwiązanie

$ f(x_i; mu) = 1/sqrt(2 pi sigma^2) exp(- (x_i - mu)^2/ (2 sigma^2)) $
$
  L(mu) &= product_(i=1)^n f(x_i;mu)\
  cal(l)(mu) &= sum_(i=1)^n ln f(x_i;mu)\
  &= sum_(i=1)^n ln ((2 pi sigma^2)^(-1/2) exp(- (x_i - mu)^2/ (2 sigma^2)))\
  &= sum_(i=1)^n -1/2ln (2 pi sigma^2) - (x_i - mu)^2/ (2 sigma^2)\
  &= -n/2ln (2 pi sigma^2) - 1 / (2 sigma^2) sum_(i=1)^n (x_i - mu)^2
$

Szukamy wartości maksymalnej $cal(l)$ więc liczymy chcemy policzyć $(d cal(l)) / (d mu) = 0$:
$
  (d cal(l)) / (d mu) &= d/(d mu)(- 1 / (2 sigma^2) sum_(i=1)^n (x_i - mu)^2)\
  &= - 1 / (2 sigma^2) d/(d mu) sum_(i=1)^n (x_i^2 - 2 x_i mu + mu^2)\
  &= - 1 / (2 sigma^2) sum_(i=1)^n d/(d mu) (x_i^2 - 2 x_i mu + mu^2)\
  &= - 1 / (2 sigma^2) sum_(i=1)^n (- 2 x_i + 2 mu)\
  &= - 1 / sigma^2 sum_(i=1)^n (- x_i + mu)\
  0 &= 1 / sigma^2 sum_(i=1)^n (mu - x_i)\
  &= sum_(i=1)^n (mu - x_i)\
  &= n mu - sum_(i=1)^n x_i\
  n mu &= sum_(i=1)^n x_i\
  hat(mu)_"MLE" &= 1/n sum_(i=1)^n x_i
$

= Zadanie 21

Rozważmy $n$ niezależnych obserwacji $x_1, dots.c, x_n$, które pochodzą z rozkładu wykładniczego z nieznanym parametrem $lambda$. Wyprowadź estymator największej wiarygodności dla parametru $lambda$.
Wskaż intuicyjnie, dlaczego ten estymator ma sens.

== Rozwiązanie

$ f(x;lambda) = lambda e^(-lambda x) $
$ 
  L(lambda) &= product_(i=1)^n f(x_i;lambda)\
  &= lambda^n exp(-lambda n x_i)\
  &= lambda^n exp(-lambda sum_(i=1)^n x_i)\
  cal(l)(lambda) &= n ln lambda -lambda sum_(i=1)^n x_i\
$
Szukamy wartości maksymalnej $cal(l)$ więc liczymy chcemy policzyć $(d cal(l)) / (d lambda) = 0$:
$
  (d cal(l)) / (d lambda) &= n / lambda - sum_(i=1)^n x_i\
  0 &= n / lambda - sum_(i=1)^n x_i\
  n / lambda &= sum_(i=1)^n x_i\
  hat(lambda)_"MLE" &= n / (sum_(i=1)^n x_i) = 1 / dash(x)
$

= Zadanie 22

Rozważmy $n$ niezależnych obserwacji $x_1, dots.c, x_n$, które pochodzą z rozkładu jednostajnego na przedziale $[0, theta]$, gdzie $theta$ jest nieznanym parametrem. Wyprowadź estymator największej wiarygodności dla parametru $theta$. Wskaż intuicyjnie, dlaczego ten estymator ma sens. Czy ten estymatorjest nieobciążony?

== Rozwiązanie

$ f(x;theta) = 1 / theta 1_[0, theta] (x) $
$
  L(theta) &= product_(i=1)^n 1 / theta bold(1)_[0, theta] (x_i)\
  &= theta^(-n) bold(1)_{forall_i ,space x_i <= theta}\
  &= theta^(-n) bold(1)_{max_i x_i <= theta}\
  &= cases(0", " &max_i x_i > theta, theta^(-n)", " &max_i x_i <= theta", funckja malejąca")
$

Chcąc osiągnąć największe możliwe $L(theta)$ musimy zminimalizować $theta$ tak aby nadal $forall_i x_i <= theta => max_i x_i <= theta$ Więc największa wartosć $L(theta)$ jest osiągana dla: $ hat(theta)_"MLE" = max_i x_i = x_((n)) $

== Czy estymator nieobciążony?

Nie, estymator jest obciążony.

#proof[
  Rozkład $x_((n))$ (maksinmum) dla $x in [0, theta]$:
  $ F_(x_((n)))(x) = P(x_((n)) < x) = (x / theta)^n $
  $
    EE[hat(theta)_"MLE"] = EE[x_((n))] &= integral_0^theta x d F_(x_((n)))(x)\
    &= integral_0^theta x dot n x^(n-1)/theta^n d x\
    &= n/theta^n integral_0^theta x^n d x\
    &= n/theta^n (x^(n + 1) / (n + 1))|^theta_0 \
    &= n/theta^n dot theta^(n + 1) / (n + 1) \
    &= n/(n + 1) theta eq.not theta
  $
  $ "Bias"(hat(theta)_"MLE") &= EE[hat(theta)_"MLE"] - theta\ &=n/(n + 1) theta - theta\ &= - 1 / (n + 1) theta $
]

= Zadanie 23
