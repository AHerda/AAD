#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 4],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: datetime.today().display(),
)

= Zadanie 13 - Prawdopodobieństwo prawdziwej wartości w przedziale

Jako że $e_i ~ cal(N)(0, sigma^2)$ oraz są niezależne, to zgodnie z własnościami rozkładu normalnego, estymator $hat(beta)_1$ również ma rozkład normalny z wartością oczekiwaną równą $beta_1$ oraz wariancją $"Var"(hat(beta)_1)$.

== Reguła trzech sigm

Reguła trzech sigm mówi, że w rozkładzie normalnym ok. $99.7%$ masy leży w przedziale $EE[X] plus.minus 3 sigma_X$ dla każdej zmiennej losowej $X ~ cal(N)(EE[X], sigma_X)$. Dla $EE[X] plus.minus 2 sigma_X$ mamy ok. $95%$. 

To tylko krótkie heurystyczne odwołanie do „regułki $68 - 95 - 99.7$” dla rozkładu normalnego ($1sigma approx 68%, space 2sigma approx 95%, space 3sigma approx 99.7%$).

== Ustandaryzowana zmienna

Niech $ Z = (hat(beta)_1 - beta_1) / (sqrt("Var"(hat(beta)_1))) ~ cal(N)(0, 1) $

Wtedy:
$ Pr(|hat(beta)_1 - beta_1| <= 2 sqrt("Var"(hat(beta)_1))) = Pr(|Z| <= 2) $

Ze wzoru na gęstosć prawdopodobieństwa w standardowym rozkładzie normalnym mamy:
$ Pr(|Z| <= 2) &= integral_(-2)^(2) phi(x) d x\ &= Phi(2) - Phi(-2)\ &= Phi(2) - (1 - Phi(2))\ &= 2 Phi(2) - 1\ &= 0.9545 $

= Zadanie 14 - Wzór na estymatory parametrów w modelu regresji liniowej z $k + 1$ parametrami

== Teza

Estymatory: $ hat(beta) = vec(hat(beta)_0, hat(beta)_1, dots.v, hat(beta)_k) in RR^(k+1) $
Wzór:
$ hat(beta) = (X^T X)^(-1) X^T arrow(y) $
gdzie $X$ to macierz danych a $arrow(y)$ to wektor odpowiedzi.

== Dowód

$ y  = f(x) + epsilon $
$ f(x) = beta_0 + beta_1 x_1 + beta_2 x_2 + dots + beta_k x_k $
$ hat(y) = hat(beta)_0 + hat(beta)_1 x_1 + dots + hat(beta)_k x_k $

$ arrow(y) = vec(y_1, y_2, dots.v, y_n), space X = mat(1, x_11, x_12, dots, x_(1k); 1, x_21, x_22, dots, x_(2k); dots.v, dots.v, dots.v, dots.down, dots.v; 1, x_(n 1), x_(n 2), dots, x_(n k)), space beta = vec(beta_0, beta_1, dots.v, beta_k), space epsilon = vec(epsilon_1, epsilon_2, dots.v, epsilon_n) $

$ arrow(y) = X beta + epsilon\ arrow.double.b\
vec(y_1, y_2, dots.v, y_n) = vec(beta_0 + beta_1 x_11 + dots + beta_k x_(1k) + epsilon_1, beta_0 + beta_1 x_21 + dots + beta_k x_(2k) + epsilon_2, dots.v, beta_0 + beta_1 x_(n 1) + dots + beta_k x_(n k) + epsilon_n) $

$ epsilon = arrow(y) - hat(y) and "RSS" = sum_(i=1)^n epsilon_i^2 = epsilon^T epsilon\ arrow.double.b $
$ "RSS" &= (arrow(y) - hat(y))^T (arrow(y) - hat(y))\ J(hat(beta)) &= (arrow(y) - X hat(beta))^T (arrow(y) - X hat(beta))\ &= (arrow(y)^T - hat(beta)^T X^T) (arrow(y) - X hat(beta))\ &= arrow(y)^T arrow(y) - arrow(y)^T X hat(beta) - hat(beta)^T X^T arrow(y) + X^T hat(beta)^T X hat(beta)\ &= arrow(y)^T arrow(y) - 2 arrow(y)^T X hat(beta) + hat(beta)^T X^T X hat(beta)\ $

Chcemy najmniejszą wartość RSS. Liczymy pochodną cząstkową po $hat(beta)$ i przyrównujemy do zera:
$ (partial J) / (partial hat(beta)) &= 2 X^T X hat(beta) - 2 X^T arrow(y) = 0\
X^T X hat(beta) &= X^T arrow(y)\
hat(beta) &= (X^T X)^(-1) X^T arrow(y) $