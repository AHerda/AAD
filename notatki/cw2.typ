#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 2],
  //title: "Article\ntemplate\ntemplate 2",
  authors: (
    (name: "Adrian Herda", affiliation: "Informatyka Algorytmiczna, Politechnika Wrocławska"),
  ),
  date: "14 października 2025 r.",
)

= Zadanie 1
Wyjaśnij, czy dany scenariusz jest związany z problemem klasyfikacji, czy regresji,
oraz wskaż, czy bardziej interesuje nas wnioskowanie (ang. inference), czy przewidywanie (ang. prediction).
Podaj rozmiar próby $n$ i liczbę predyktorów $p$

== Podpunkt a) wynagrodzenie prezesa a czynniki firmowe
*Typ problemu*: problem regresji - wynagrodzenie to zmienna ciągła\
*Cel*: wnioskowanie - chcemy zrozumieć zależności a nie przewidzieć przyszłe zarobki prezesów\
*Rozmiar próby $n$*: 500 - liczba firm\
*Liczba predyktorów $p$*: 3 - zysk, liczba pracowników, branża - predyktory do dane które pozwalają na znalezienie korelacji

== Podpunkt b) wprowadzenie nowego produktu na rynek
*Typ problemu*: problem klasyfikacji - kategoryzujemy produkty na te które odniosły sukces lub porażkę, są dwie klasy\
*Cel*: przewidywanie - chcemy przewidzieć jak produkt poradzi sobie na rynku\
*Rozmiar próby $n$*: 20 - liczba podobnych produktów\
*Liczba predyktorów $p$*: 3 - cena, cena bezpośredniej konkurencji, budżet marketingowy

== Podpunkt c) prognozowanie zmian kursu dolara
*Typ problemu*: problem regresji - procentowe zmiany kursu to wartość liniowa\
*Cel*: przewidywanie - _"prognoza"_ to próba przewidzenia danych w przyszłości\
*Rozmiar próby $n$*: 52 - liczba tygodni w roku\
*Liczba predyktorów $p$*: 4 - liczba porównywanych rynków akcji: USA, Wielka Brytania, Niemcy, Japonia

= Zadanie 2
Praktyczne zastosowania uczenia maszynowego: dla każdego z poniższych punktów
zaproponuj dwa niesztampowe praktyczne zastosowania. Opisz jakie dane są potrzebne w wybranych
zastosowaniach, np. jakie cechy (ang. features) mogą zostać użyte jako predyktory, a jakie odpowiedzi,
czy potrzebna jest duża liczba obserwacji.

== Klasyfikacja

=== Przykład 1 - rozpoznawanie rodzajów wina
- Predykory:
  - gęstość / lepkość
  - zapach
  - kolor
  - smak
- Odpowiedzi
  - rodzaje wina

Potrzebna jest duża ilość obserwacji ze względu na ilość rodzajów wina oraz ze względu na podobieństwo niektórych rodzajów.

=== Przykład 2 - klasyfikacja emocji w rozmowach telefonicznych z klientami <p2>
- Predyktory:
  - ton mowy
  - tempo mowy
  - używane wyrażenia
  - głośność
- Odpowiedzi
  - odpowiedzi na pytanie o zadowolenie z obsługi (bardzo pozytywne, pozytywne, neutralne, negatywne, bardzo negatywne)

Potrzebna jest duża ilość danych ponieważ ludzkie emocje są bardzo skomplikowane i często niezrozumiałe nawet dla nas samych. Nawet do setek tysięcy

== Regresja

=== Przykład 1 - Szacowanie wieku człowieka na podstawie zdjęcia (np takiego do ID)
- Predyktory:
  - kolor włosów
  - zmarszczki
  - proporcje oczu do głowy (szczególnie u dzieci)
  - kolor skóry
  - przebarwienia
- Odpowiedzi:
  - wiek

Potrzebne może być nawet do dziesiątek tysięcy obserwacji może być potrzebne gdyż fizjologia ludzka jest skomplikowana

=== Przykład 2 - Prognozowanie czasu rozkładu biodegradowalnych materiałów
- Predyktory:
  - skład chemiczny
  - gęstość
  - porowatość
  - temperatura
  - wilgotność
  - rodzaj środowiska (gleba, woda, kompost).
- Odpowiedź:
  - czas rozkładu

Potrzebne będą setki eksperymentów laboratoryjnych i terenowych.

== Analiza klastrów

=== Przykład 1 - Grupowanie utworów muzyczny według klas np. nastroju czy gatunku (np. Spotify)
- Predyktory:
  - tempo
  - tonacja
  - analiza tekstu - używane słowa i wyrażenia
  - głośność
  - użyte instrumenty
  - użyte narzędzia modyfikowania dźwięku
- Odpowiedzi: brak klastrowanie odbywa się bez nadzoru i tworzy własne klasy / etykiety.
- Przykładowe etykiety nadane przez algorytm: muzyka melancholijna, wesoła, skoczna, buntownicza

Setki tysięcy lub nawet miliony utworów będą potrzebne by znaleźć widocznie wyróżniające się klastry.

=== Przykład 2 - Podział klientów sklepu na grupy o podobnych zainteresowaniach
- Predyktory:
  - średnia wartość zakupów
  - częstotliwość zakupów
  - najczęściej kupowane i przeglądane oferty
  - ocena satysfakcji klienta
  - lokalizacja klienta (może być nie dokładna, np. region - ciepły czy zimny)
- Odpowiedzi: brak klastrowanie odbywa się bez nadzoru i tworzy własne klasy / etykiety.
- Przykładowe etykiety nadane przez algorytm: klient zainteresowany ciuchami zimowymi / letnimi, wędkarz, sportowiec, kolekcjoner butów, stały klient, klient jednorazowy

Setki tysięcy klientów będą potrzebne by znaleźć wyróżniające się klastry.

= Zadanie 3 - uczenie statystyczne - parametryczne a nieparametryczne

Opisz różnice między parametrycznym a nieparametrycznym podejściem do uczenia statystycznego. Jakie są wady i zalety podejścia parametrycznego w porównaniu do podejścia nieparametrycznego?

== Parametryczne

Zakłada pewien rozkład danych, za pomocą skończonej (nie ogromnej) ilości parametrów. Umożliwia stosunkowo łatwą analizę modelu ale sprawia że jest ona tylko przybliżeniem. To podejście jest też mniej elastyczne i jest podatne na błędy związane z biasem.

== Nieparametryczna

Nie wymaga założeń co do rozkładu danych . Model uczy się bardziej elastycznie dopasowując się do obserwacji. Dzięki temu otrzymujemy mniejszy bias ale możliwym jest zbytnio dopasować model do danych (ang. overfitting). Podejście to wymaga dużej liczby obserwacji i przez to jest bardziej kosztowne niż podejście parametryczne.

#pagebreak()
== Zalety i wady

#table(columns: (auto, 1fr, 1fr),
  table.header([], [Uczenie parametryczne], [Uczenie nieparamteryczne]),
  [Zalety],
  [
    - mały wariancja
    - łatwość analizy i interpretacji modelu
    - niski koszt obliczeń
  ],
  [
    - mały bias
    - duża elastyczność i dopasowanie do danych
    - Nie wymaga założeń o danych
  ],
  [Wady],
  [
    - duży bias
    - mała elastyczność
    - słaba moc predykcyjna
    - wymaga założeń o danych
  ],
  [
    - duża wariancja
    - niezrozumiały sposób działania (black box)
    - duży koszt obliczeń
  ],
)

= Zadanie 4 - zbiór treningowy dla metody $K$ najbliższych sąsiadów (ang. $K$-nearest neighbors)

== a) odległość euklidesowa dla każdego punktu
+ $sqrt(0^2 + 3^2 + 0^2) = sqrt(9) = 3$,
+ $sqrt(2^2 + 0^2 + 0^2) = sqrt(4) = 2$,
+ $sqrt(0^2 + 1^2 + 3^2) = sqrt(10)$,
+ $sqrt(0^2 + 1^2 + 2^2) = sqrt(5)$,
+ $sqrt((-1)^2 + 0^2 + 1^2) = sqrt(2)$,
+ $sqrt(1^2 + 1^2 + 1^2) = sqrt(3)$

== b) predykcja dla $K = 1$

Bierzemy najbliższego sąsiada którym jest obserwacja $5$ i bierzemy jego odpowiedź #sym.arrow #text(green)[*_Green_*]

== c) predykcja dla $K = 3$

Bierzemy $3$ najbliższych sąsiadów którymi są obserwacje $5 -> "Green"$, $6 -> "Red"$ oraz $2 -> "Red"$ i bierzemy najpopularniejszą odpowiedź wśród tych obserwacji #sym.arrow #text(red)[*_Red_*]

== d) lepsze małe czy duże wartości $K$ dla silnie nieliniowej granicy decyzyjnej Bayesa
Jeśli granica decyzyjna Bayesa jest silnie nieliniowa (czyli prawdziwa granica między klasami jest bardzo złożona), to potrzebujemy bardziej elastycznego modelu, aby tę złożoność uchwycić. Małe wartości $𝐾$ dają klasyfikatorowi _KNN_ większą elastyczność (niższy bias, wyższa wariancja) i pozwalają na odwzorowanie skomplikowanych, lokalnych zależności. Dlatego przy silnie nieliniowej granicy Bayesa zwykle lepiej sprawdzą się małe wartości $𝐾$. (Przy przeciwnym założeniu — gładkiej granicy — większe $K$ redukuje wariancję i może dać lepsze wyniki).

= Zadanie 5 - Wartość oczekiwana i wariancja sumy zmiennych losowych

$ "Cov"(X, Y) = 0 $<eq1>

== a) $EE(X + Y) = EE(X) + EE(Y)$
#proof[$
  EE(X + Y) &= sum_x sum_y (x + y)Pr(X = x, Y = y)\
  &= sum_x sum_y x dot Pr(X = x, Y = y) + sum_x sum_y y dot Pr(X = x, Y = y)\
  &= sum_x x dot (sum_y dot Pr(X = x, Y = y)) + sum_y y dot (sum_x dot Pr(X = x, Y = y))\
  &= sum_x x dot Pr(X = x) + sum_y y dot Pr(Y = y)\
  &= EE(X) + EE(Y)
$]

== b) $"Var"(X + Y) = "Var"(X) + "Var"(Y)$
#proof[$
  "Var"(X) = EE[(X - EE(X))^2] and (1)\ arrow.b.double $$
  "Var"(X + Y) &= EE[(X + Y - EE(X + Y))^2] \
  &= EE[((X - EE(X)) + (Y - EE(Y)))^2]\
  &= EE[(X - EE(X))^2 + (Y - EE(Y))^2 + 2 dot (X - EE(X)) dot (Y - EE(Y))]\
  &= EE[(X - EE(X))^2] + EE[(Y - EE(Y))^2] + EE[2 dot (X - EE(X)) dot (Y - EE(Y))]\
  &= "Var"(X) + "Var"(Y) + underbrace(2 dot "Cov"(X, Y), 0)\
  &= "Var"(X) + "Var"(Y)
$]

= Zadanie 6 - Przypomnienie estymatrów, jego bias'u i wariancji wrac z przykładami

Przypomnij, co to jest estymator oraz co to jest obciążenie (ang. bias) i wariancja
estymatora. Podaj przykłady estymatorów obciążonych i nieobciążonych

== Definicje

/ Estymator: To funkcja mająca za zadanie przybliżyć (wyestymować) wybrany parametr. $ theta approx hat(theta)(X_1, X_2, dots.c, X_n) $
/ Bias estymatora: Jest wartość opisująca tendencje estymatora do zawyżania lub zaniżania wartości estymowanej $ "Bias"(hat(theta)) = EE(hat(theta)) - theta $
  - Estymator nazywamy obciążonym gdy $"Bias"(hat(theta)) != 0$
  - Estymator nazywamy nieobciążonym gdy $"Bias"(hat(theta)) = 0 => EE(hat(theta)) = theta$
/ Wariancja estymatora: służy ocenianiu jak daleko, zazwyczaj, będzie estymator od estymowanej wartości $ "Var"(hat(theta)) = EE((EE(hat(theta)) - hat(theta))^2) $
/ MSE: Mean Square Error (ang. Błąd średniokwadratowy) tak samo jak wariancja $ "MSE"(hat(theta)) = EE((hat(theta)(X) - theta)^2) $

== Przykłady

=== Nieobciążony

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Typ estymatora], [Przykład], [Obciążenie]),
  [Średnia z próby], [$hat(mu) = 1/n sum_(i=1)^n X_i$], [$EE(hat(mu)) = mu => "Bias"(hat(mu)) = 0$],
  [Wariancja z $n - 1$], [$hat(sigma)_(n - 1)^2 = 1/ (n-1) sum_(i=1)^n (X_i - dash(X))^2$], [$EE(hat(sigma)_(n-1)^2) = sigma^2 => "Bias"(hat(sigma)_(n-1)^2) = 0$],
)

=== Obciążony

#table(
  columns: (auto, 1fr, 1fr),
  table.header([Typ estymatora], [Przykład], [Obciążenie]),
  [Wariancja z $n$], [$hat(sigma)_n^2 = 1/ n sum_(i=1)^n (X_i - dash(X))^2$], [$EE(hat(sigma)_n^2) = (n-1)/n sigma^2 => "Bias"(hat(sigma)_n^2) = -sigma^2 / n$],
  [$X tilde "Exp"(lambda)$], [MLE $hat(lambda)=1/dash(X)$], [$EE(hat(lambda)) = n / (n-1) => "Bias"(hat(lambda)) = 1/(n-1) lambda$]
)

= Zadanie 7 - dopasowywanie elastyczności modelu do scenariusza

Szukamy odpowiedniego modelu dla problemu związanego z uczeniem nadzorowanym. Dla każdego z punktów od (a) do (d), wskaż, czy ogólnie oczekiwalibyśmy, że mało „elastyczny” model będzie lepszy czy gorsza od bardziej „elastycznego”. Uzasadnij swoją odpowiedź.\
  #h(1em) (a) Rozmiar próby $n$ jest bardzo duży, a liczba predyktorów (and. predictor) $p$ jest mała.\
  #h(1em) (b) Liczba predyktorów $p$ jest bardzo duża, a liczba obserwacji $n$ jest mała.\
  #h(1em) (c) Zależność między predyktorami a odpowiedzią (and. response) wykazuje wyraźnie nieliniowy charakter.\
  #h(1em) (d) Wariancja błędów, tj. $sigma^2 = VV"ar"(epsilon)$, jest bardzo wysoka.\

Sformułuj wnioski dotyczące tego, jakie są zalety i wady bardziej elastycznego modelu, w porównaniu z
mniej elastycznym? W jakich okolicznościach bardziej elastyczny model może być preferowany? Kiedy
preferowany może być mniej elastyczny model?

#table(
  columns: (auto, auto, 1fr),
  table.header([Przypadek], [Elastyczność modelu], [Uzasadnienie]),
  [a) $n$ - duże,\ $p$ - małe], [Bardziej elastyczny], [Elastyczny model może wykorzystać dużą liczbę obserwacji aby dopasować się i dzięki temu obniża bias],
  [b) $n$ - małe\ $p$ - duże], [Mniej elastyczny], [Duża liczba predyktorów grozi overfittingiem, należy najpierw dokonać redukcji wymiaru tak aby $p$ było mniejsze od  $n$ a następnie wykorzystać mniej elastyczny model aby uzyskać model zwiększyć wydajność na małej ilości danych] ,
  [c) silna nieliniowość danych], [Bardziej elastyczny], [Elastyczny model lepiej dopasuje się do danych i lepiej przedstawi nieliniowość, nie uśredniając jej tak jak zrobiłby to model mniej elastyczny],
  [d) Wysoka wariancja szumu], [Mniej elastyczny], [Mniej elastyczny model uśredni dane i zniweluje w ten sposób wysoką wariancję szumu]
)

== Wnioski

#table(columns: (auto, 1fr, 1fr),
  table.header([], [Model mniej elastyczny], [Model bardziej elastyczny]),
  [Zalety],
  [
    - stabilny, z mała wariancją
    - łatwiejszy do interpretacji
    - bardziej odporny na szum
    - sprawdza się lepiej dla małych $n$ względem $p$
  ],
  [
    - niski bias
    - świetny dla dużych $n$
    - uchwyci złożone zależności
  ],
  [Wady],
  [
    - duży bias
    - słaby przy dużej nieliniowości danych
  ],
  [
    - duża wariancja
    - niezrozumiały sposób działania (black box)
    - duży koszt obliczeń
    - kiepski dla małych $n$
    - ryzyko overfittingu
  ],
)
