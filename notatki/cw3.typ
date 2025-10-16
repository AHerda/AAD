#import "template.typ": *
#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 3],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: datetime.today().display()
)

= Zadanie 8 - _MSE_ jako suma kwadratu _bias_'u wariancji funckji przybliżającej i wariancji szumu

$ M S E = EE[(y_0 - hat(f)(x_0))^2] = "Bias"(hat(f)(x_0))^2 + "Var"(hat(f)(x_0)) + sigma_epsilon^2 $

== Rozwiązanie

+ $EE[epsilon] = 0 => EE[epsilon]^2 = 0 => sigma_epsilon^2 = EE[epsilon^2]$
+ Szum jest niezależny z żadną inną zmienną
#proof[$
  EE[(y_0 - hat(f)(x_0))^2] &= EE[(f(x_0) + epsilon - hat(f)(x_0))^2] \
  &= EE[(f(x_0) - hat(f)(x_0))^2] + underbrace(EE[epsilon^2], sigma_epsilon^2) + 2EE[(f(x_0) - hat(f)(x_0))epsilon] \
  &= EE[(f(x_0) - hat(f)(x_0))^2] + sigma_epsilon^2 + underbrace(2(f(x_0) - EE[hat(f)(x_0)])EE[epsilon], 0) \
  &= EE[f(x_0)^2 + hat(f)(x_0)^2 - 2f(x_0)hat(f)(x_0)] + sigma_epsilon^2 \
  &= f(x_0)^2 + EE[hat(f)(x_0)^2] - 2f(x_0)EE[hat(f)(x_0)] + sigma_epsilon^2 \
  &= f(x_0)^2 - 2f(x_0)EE[hat(f)(x_0)] + underbrace(EE[hat(f)(x_0)]^2 - EE[hat(f)(x_0)]^2, 0) + EE[hat(f)(x_0)^2] + sigma_epsilon^2 \
  &= (f(x_0) - EE(hat(f)(x_0)))^2 + (EE[hat(f)(x_0)^2] - EE[hat(f)(x_0)]^2) + sigma_epsilon^2 \
  &= "Bias"(hat(f)(x_0))^2 + "Var"(hat(f)(x_0)) + sigma_epsilon^2
$]

== Równowaga bias-variance

W miarę jak model staje się bardziej elastyczny, jego zdolność do uchwycenia złożoności danych rośnie, co prowadzi do zmniejszenia błędu bias. Jednakże, większa elastyczność może również prowadzić do większej wariancji, ponieważ model może zacząć "przeuczać" się na dane treningowe. W rezultacie, istnieje kompromis między bias a wariancją, który należy uwzględnić podczas projektowania modeli.

Optymalny wybór złożoności/regularizacji minimalizuje sumę $"Bias"^2 + "Var"$.\ Składnik $epsilon$ jest nieredukowalny.

= Zadanie 9 - Wykresy względem elastyczności modelu

#let err(x) = 2
#let bias(x) = 10 * calc.pow(calc.e, -0.6 * x) + 1
#let variance(x) = 10 * calc.pow(calc.e, 0.6 * (x - 10)) + 1
#let training_mse(x) = 11 * calc.pow(calc.e, -0.2 * x)
#let test_mse(x) = bias(x) + variance(x) + err(x)

#align(center)[#canvas({
  plot.plot(
    size: (12, 8),
    legend: "inner-north",
    title: "Wykresy względem elastyczności modelu",
    x-label: "Model flexibility",
    y-label: "Value",
    y-min: 0,
    y-max: 15,
    x-tick-step: none,
    y-tick-step: none,
    x-ticks: ((1, "Less flexible"), (9, "More flexible")),
    {
      plot.add(bias, domain: (0, 10), style: (stroke: blue), label: $"Bias"^2$ )
      plot.add(variance, domain: (0, 10), style: (stroke: yellow), label: "Variance" )
      plot.add(training_mse, domain: (0, 10), style: (stroke: green), label: "Training MSE" )
      plot.add(test_mse, domain: (0, 10), style: (stroke: red), label: "Test MSE" )
      plot.add(err, domain: (0, 10), style: (stroke: black, dash: (5,5)), label: "Irreducable Error" )
    }
  )
})]

== Wytłumaczenie każdej funkcji
/ #text(green)[Niebieski]: W miarę jak modele stają się bardziej elastyczne i złożone, błąd treningowy maleje, ale z coraz mniejszym zyskiem.
/ #text(red)[Czerwony]: Często obserwujemy kształt litery U w błędzie na zbiorze walidacyjnym. Jest to kombinacja błędu Bias (obserwowanego przy najmniej elastycznym modelu), błędu Variance (wynikającego z przeuczenia najbardziej elastycznych modeli) oraz składnika błędu nieusuwalnego.
/ #text(blue)[Niebieski]: Składnik błędu Bias, im bardziej elastyczny model tym lepiej się dopasowuje tym mniejszy jest Bias.
/ #text(yellow)[Brązowy]: Składnik błędu Variance. Im bardziej elastyczny model tym większe różnice w wynikach na zbiorze treningowym i walidacyjnym.
/ #text(black)[Czarny]: Składnik błędu nieusuwalnego. Niezmienna wartość szumu.

= Zadanie 10 - Obliczanie wzorów na paremtry modelu linowego <zad10>

== Dane
- $n$ obserwacji: ${(x_1, y_1), dots.c, (x_n, y_n)}$,
- model linowy: $y_i = beta_0 + beta_1 x_i + e_i$

== Cel

Szacujemy $beta_0, beta_1$ poprzez minimalizacje błedu średniokwadraatowego:

$ "MSE"(beta_0, beta_1) = 1/n sum_(i=1)^n (y_i - (hat(beta)_0 + hat(beta)_1 x_i))^2 $

Udowodnij że:
+ $hat(beta)_0 = dash(y) - hat(beta_1) dash(x)$

+ $hat(beta)_1 = (sum_(i=1)^n (x_i - dash(x))(y_i - dash(y))) / (sum_(i=1)^n (x_i - dash(x))^2)$

#proof[
  Różniczkujemy i przyrównujemy do zera:
  $
    partial/(partial hat(beta)_0) "MSE" &= -2/n sum_(i=1)^n (y_i - (hat(beta)_0 + hat(beta)_1 x_i)) = 0 
  $ <beta0>
  $
    partial/(partial hat(beta)_1) "MSE" &= -2/n sum_(i=1)^n x_i (y_i - (hat(beta)_0 + hat(beta)_1 x_i)) = 0
  $ <beta1>

  Z @beta0[równania] mamy:
  $
    sum_(i=1)^n y_i - n hat(beta)_0 - hat(beta)_1 sum_(i=1)^n x_i = 0 \
    n hat(beta)_0 = sum_(i=1)^n y_i - hat(beta)_1 sum_(i=1)^n x_i \
    hat(beta)_0 = dash(y) - hat(beta)_1 dash(x)
  $

  Podstawiając do @beta1[równania] mamy:
  $
    0 &= sum_(i=1)^n x_i y_i - hat(beta)_0 sum_(i=1)^n x_i - hat(beta)_1 sum_(i=1)^n x_i^2 \

    0 &=sum_(i=1)^n x_i y_i - (dash(y) - hat(beta)_1 dash(x)) sum_(i=1)^n x_i - hat(beta)_1 sum_(i=1)^n x_i^2 \

    0 &= sum_(i=1)^n x_i y_i - (dash(y) - hat(beta)_1 dash(x)) dot n dash(x) - hat(beta)_1 sum_(i=1)^n x_i^2 \

    0 &= sum_(i=1)^n x_i y_i - n dash(y) dash(x) + n hat(beta)_1 dash(x)^2 - hat(beta)_1 sum_(i=1)^n x_i^2 \

    hat(beta)_1 (sum_(i=1)^n x_i^2 - n dash(x)^2) &= sum_(i=1)^n x_i y_i - n dash(y) dash(x) \

    hat(beta)_1 (sum_(i=1)^n x_i^2 - 2 n dash(x)^2 + n dash(x)^2) &= sum_(i=1)^n x_i y_i - n dash(y) dash(x) + n dash(y) dash(x) - n dash(y) dash(x) \
    
    hat(beta)_1 (sum_(i=1)^n x_i^2 - sum_(i=1)^n 2 dash(x) x_i + sum_(i=1)^n dash(x)^2) &= sum_(i=1)^n x_i y_i - sum_(i=1)^n dash(y) x_i + sum_(i=1)^n dash(y) dash(x) - sum_(i=1)^n dash(x) y_i \

    hat(beta)_1 sum_(i=1)^n (x_i^2 - 2 dash(x) x_i + dash(x)^2) &= sum_(i=1)^n (x_i y_i - dash(y) x_i) + (dash(y) dash(x) - dash(x) y_i) \

    hat(beta)_1 sum_(i=1)^n (x_i^2 - dash(x)^2)^2 &= sum_(i=1)^n x_i (y_i - dash(y)) - dash(x) (y_i - dash(y)) \

    hat(beta)_1 &= (sum_(i=1)^n (x_i - dash(x)) (y_i - dash(y))) / (sum_(i=1)^n (x_i^2 - dash(x)^2)^2) \
  $
]

== Udowodnij że funkcja ta zawsze przejdzie przez punkt $(dash(x), dash(y))$

#proof[
  Podstawiając $x = dash(x)$ do @beta0[równania] prostej:
  $
    y &= hat(beta)_0 + hat(beta)_1 dash(x) \
    &= (dash(y) - hat(beta)_1 dash(x)) + hat(beta)_1 dash(x) \
    &= dash(y)
  $
]

= Zadanie 11 - Błąd systematyczny, wariancja i błąd standardowy dla estymatorów w modelu liniowym

$ y_i = beta_0 + beta_1 x_i + e_i $

Estymaotry jak w modelu z zadania w @zad10[sekcji].\
Oraz niech: $S_(x x) = sum_(i=1)^n (x_i - dash(x))^2$

== Błąd systematyczny

$  E[hat(beta)_0] = beta_0 => "Bias"(hat(beta)_0) = 0 $
$  E[hat(beta)_1] = beta_1 => "Bias"(hat(beta)_1) = 0 $

== Wariancja

*Zmienne $e_i$ dla $i in {1, dots.c, n}$ są niezależżne*

=== Reprezentacja estymatorów za pomocą szumów

$ hat(beta)_1 = beta_1 + (sum_(i=1)^n (x_i - dash(x)) e_i) / S_(x x) $
$ hat(beta)_0 = beta_0 + 1/n sum_(i=1)^n e_i - dash(x) (sum_(i=1)^n (x_i - dash(x))e_i) / S_(x x) $

=== Wariancja estymatorów

$ "Var"(hat(beta)_1) &= "Var"(beta_1 + (sum_(i=1)^n (x_i - dash(x)) e_i) / S_(x x))\
  &= "Var"((sum_(i=1)^n (x_i - dash(x)) e_i) / S_(x x)) \
  &= 1/(S_(x x))^2 "Var"(sum_(i=1)^n (x_i - dash(x)) e_i) \
  &= 1/(S_(x x))^2 sum_(i=1)^n (x_i - dash(x))^2 "Var"(e_i) \
  &= sigma^2 / S_(x x) $

$ "Var"(hat(beta)_0) &= "Var"(beta_0 + 1/n sum_(i=1)^n e_i - dash(x) (sum_(i=1)^n (x_i - dash(x))e_i) / S_(x x)) \
  &= "Var"(1/n sum_(i=1)^n e_i - dash(x) (sum_(i=1)^n (x_i - dash(x))e_i) / S_(x x)) \
  &= "Var"(1/n sum_(i=1)^n e_i) + "Var"(dash(x) (sum_(i=1)^n (x_i - dash(x))e_i) / S_(x x)) - 2 "Cov"(1/n sum_(i=1)^n e_i, dash(x) (sum_(i=1)^n (x_i - dash(x))e_i) / S_(x x)) \
  &= 1/n^2 sum_(i=1)^n "Var"(e_i) + dash(x)^2 / (S_(x x))^2 sum_(i=1)^n (x_i - dash(x))^2 "Var"(e_i) - 2 dash(x) / (n S_(x x)) sum_(i=1)^n (x_i - dash(x)) "Var"(e_i) \
  &= sigma^2 / n + dash(x)^2 sigma^2 / S_(x x) - 2 dash(x) sigma^2 / (n S_(x x)) sum_(i=1)^n (x_i - dash(x)) \
  &= sigma^2 / n + dash(x)^2 sigma^2 / S_(x x) - 2 dash(x) sigma^2 / (n S_(x x)) dot 0 \
  &= sigma^2 / n + dash(x)^2 sigma^2 / S_(x x)\
  &= sigma^2 (1 / n + dash(x)^2 / S_(x x)) $


== Błąd standardowy estymatorów

$ "SE"(hat(beta)_0) = sqrt("Var"(hat(beta)_0)) = sqrt(sigma^2 (1 / n + dash(x)^2 / S_(x x))) = sigma sqrt(1 / n + dash(x)^2 / S_(x x)) $
$ "SE"(hat(beta)_1) = sqrt("Var"(hat(beta)_1)) = sqrt(sigma^2 / S_(x x)) = sigma / sqrt(S_(x x)) $

= Zadanie 12 - Suma zmiennych losowych o rozkadnie normalnym ma rozkad normalnym

+ $X ~ cal(N)(mu_X, sigma_X^2)$
+ $Y ~ cal(N)(mu_Y, sigma_Y^2)$
+ $Z = X + Y$

Udowodnij że $Z ~ cal(N)(mu_Z, sigma_Z^2)$

#proof[
  Funkcje charakterystyczne zmiennych losowych:
  $
    phi_X (t) = exp(i mu_X t - sigma_X^2 t^2 / 2), space
    phi_Y (t) = exp(i mu_Y t - sigma_Y^2 t^2 / 2)
  $
  Zmienna losowa Z jest sumą niezależnych zmiennych losowych X i Y, więc jej funkcja charakterystyczna jest iloczynem funkcji charakterystycznych X i Y:
  $
    phi_Z (t) &= phi_X (t) dot phi_Y (t) \
    &= exp(i mu_X t - sigma_X^2 t^2 / 2) dot exp(i mu_Y t - sigma_Y^2 t^2 / 2)\
    &= exp(i mu_X t - sigma_X^2 t^2 / 2 + i mu_Y t - sigma_Y^2 t^2 / 2) \
    &= exp(i (mu_X + mu_Y) t - (sigma_X^2 + sigma_Y^2) t^2 / 2) \
    &= exp(i mu_Z t - sigma_Z^2 t^2 / 2)
  $
]