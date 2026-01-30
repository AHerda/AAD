#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 15],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [30 stycznia 2025 r.],
)

= Ćwiczenie 54 -- Algorytm K-Means

== Działanie algorytmu <alg>

Algorytm k-means służy do podziały zbiotu na $k$ rozłącznych klastrów. Jego działanie można opisać w następujących krokach:

+ / Inicjalizacja: Wybierz losowow $k$ punktów ze zbiotu danych. Posłóża one za początkowe centroidy.
+ / Przypisanie: Dla każdego punktu w zbiorze danych oblicz jego odlgłości do wszystkich $k$ centroidów. Przypisz punkt do klastra, reprezentowanego przez centroid, do którego ma najmniejszą odległość.
+ / Aktualizacja: Oblicz współrzędne centroidóko średnią arytmetycznąwszystkich punktów przypisanych do danego klastra.
+ / Powtórzenie: Powtarzaj kroki 2 i 3, aż do spełnienia warunku stopu.

== Złożoność obliczeniowa
- *Czasowa:* $O(t dot k dot n dot d)$, gdzie:
  - $t$: liczba iteracji,
  - $k$: liczba klastrów,
  - $n$: liczba punktów danych,
  - $d$: wymiarowość danych.
  Zazwyczaj $k, t, d lt.double n$, więc algorytm jest liniowy względem liczby punktów.
- *Pamięciowa:* $O((n + k) dot d)$ ponieważ musimy przechwywać $d$ parametrów, jeden na każdy wymiar, dla każdego punktu i centroidu.

== Dlaczego Potrzebne jest wielokrotne uruchomienie

Algorytm jest heurystyką, to oznacza że nie gwarantuje znalezienia globalnego minimum. Ponad to algorytm bazuje na wybiorze lsoowym początkowych centroidów a jako że wynik końcowy jest w dużej mierze zależny od początkowych wartości, to jest też zależny od tej losowości. Kilkukrotne uruchomienie z różnymi losowymi inicjalizacjami zwiększa szansę na znalezienie optymalnego podziału.

== Pechowy wybór centroidów

*Przykład:* Załóżmy że są dwa naturalne klastry punktów na wykresie, jeśli dwa początkowe centroidy znajdą się w klastrze A, to K-Means nie zmieni tego i podzieli A na dwa klastry a B przypisze do jednego z nich, co jest oczywiście błędne.

= Ćwiczenie 55 -- Dowód na postać centroidu

#enum(numbering: "a)")[
  #theorem[$sum_(i=1)^k sum_(x in C_i) (x - c_i)^2$, centroid ma postać średniej punktów w klastrze]
  #proof[
    Funkcja kosztu dla dowolnego klastra $i$ to: $ J(c_i) = sum_(x in C_i) (x - c_i)^2 $
    Aby znaleźć minimum, obliczamy pochodną po $c$ i przyrównujemy do $0$.

    $ (d J) / (d c_i) &= sum_(x in C_i) (x^2 - 2 x c_i + c_i^2)'\ &= sum_(x in C_i) (-2x + 2c_i)\ &= 2 dot |C_i| dot c_i - 2 dot sum_(x in C_i) x = 0\ cancel(2) dot |C_i| dot c_i &= cancel(2) dot sum_(x in C_i) x\ c_i &= 1 / (|C_i|) sum_(x in C_i) x $
  ]
][
  #theorem[$sum_(i=1)^k sum_(x in C_i) |x - c_i|$, centroid ma postać mediany punktów w klastrze]

  Podobnie jak w podpunkcie a) obliczamy pochodną kosztu centroidu $c_i$: $ J(c_i) = sum_(x in C_i) |x - c_i| $
  $ (d J) / (d c) &= sum_(x in C) d / (d c) |x - c_i|\ &= sum_(x in C) -s g n(x - c_i) = 0 $ Suma znaków wyrażeń $x - c_i$ będzie równa zeru tylko i wyłącznie wtedy kiedy będzie tyle samo wyrażeń $-1$ czyli $x < c_i$ co wyrażeń $+1$ produkowanych przez $x > c_i$:
  $ |{x in C_i: x < c_i}| = |{x in C_i: x > c_i}| $
  a to z kolei znaczy że $c_i$ dzieli zbiór punktów $C_i$ idealnie na poł co jest definicją mediany.
]

= Ćwiczenie 56 -- DBSCAN

== Działanie DBSCAN
DBSCAN (Density-Based Spatial Clustering of Applications with Noise) grupuje punkty na podstawie gęstości ich rozmieszczenia.
+ Dla każdego punktu sprawdzamy jego $epsilon$-sąsiedztwo.
+ Jeśli punkt ma co najmniej _MinPts_ sąsiadów, staje się *rdzeniem* (core point) i tworzy nowy klaster.
+ Do klastra dołączane są wszystkie punkty osiągalne gęstościowo (sąsiedzi rdzenia, sąsiedzi ich sąsiadów itd.).
+ Punkty, które nie są rdzeniami, ale leżą w sąsiedztwie rdzenia, to *punkty brzegowe*.
+ Punkty nieprzypisane do żadnego klastra to *szum* (noise).

== Ustalanie parametrów
- *MinPts:* Zazwyczaj ustala się jako $2 dot d$ (gdzie $d$ to wymiar danych). Dla większych zbiorów z szumem warto zwiększyć tę wartość.
- *$epsilon$ (epsilon):* Stosuje się metodę *k-distance graph*. Obliczamy odległość każdego punktu do jego $k$-tego najbliższego sąsiada (gdzie $k = "MinPts"-1$). Sortujemy te odległości i wykreślamy. Punkt "kolanka" (gwałtownego wzrostu wykresu) wskazuje optymalne $epsilon$.

== Porównanie k-means i DBSCAN

#table(
  columns: (auto, auto),
  inset: 10pt,
  align: horizon,
  row-gutter: (3pt, 0pt),
  table.header(
    [*k-means*], [*DBSCAN*]
  ),
  [Wymaga podania liczby klastrów $k$.], [Sam ustala liczbę klastrów.],
  [Zakłada kulisty kształt klastrów.], [Wykrywa klastry o dowolnych kształtach.],
  [Wrażliwy na szum (przypisuje wszystko).], [Odporny na szum (oznacza jako noise).],
  [Szybki ($O(n)$).], [Wolniejszy w pesymistycznym przypadku ($O(n^2)$), ale $O(n log n)$ z indeksowaniem.],
  [Działa dobrze, gdy gęstość jest zmienna.], [Problemy przy klastrach o bardzo różnej gęstości.]
)

== Co lepsze dla dokumentów (dane wielowymiarowe)?
Dla zbioru dokumentów (bardzo wysoki wymiar, rzadkie dane) zazwyczaj *k-means* (często w wariancie sferycznym lub z metryką cosinusową) okazuje się skuteczniejszy.
DBSCAN w bardzo wielu wymiarach cierpi na "klątwę wymiarowości" – odległości między wszystkimi punktami stają się do siebie zbliżone, co utrudnia dobranie sensownego $epsilon$ i odróżnienie gęstych regionów od rzadkich.

= Ćwiczenie 57 — Klasteryzacja hierarchiczna

== Działanie
Klasteryzacja hierarchiczna (aglomeracyjna) zaczyna od sytuacji, gdzie każdy punkt jest osobnym klastrem. W każdym kroku łączy dwa najbliższe klastry w jeden, aż wszystkie punkty znajdą się w jednym klastrze. Wynikiem jest dendrogram (drzewo połączeń).

=== Single Linkage
Odległość między klastrami to odległość między *najbliższymi* punktami z tych klastrów.
+ Najmniejsze odległości to 2 (pary {1,3} oraz {8,10}). Łączymy je.
  - Klastry: ${1,3}, {8,10}, {16}$.
+ Odległości między nowymi klastrami:
  - $d({1,3}, {8,10}) = d(3,8) = 5$
  - $d({8,10}, {16}) = d(10,16) = 6$
  Najmniejsza to 5. Łączymy ${1,3}$ i ${8,10}$.
  - Klastry: ${1,3,8,10}, {16}$.
+ Łączymy wszystko z ${16}$. Odległość: $d(10,16) = 6$.

#import "@preview/cetz:0.4.2": canvas, draw
#import "@preview/cetz-plot:0.1.3": plot

#align(center)[#canvas({
  import draw: *

  // Set-up a thin axis style
  set-style(axes: (stroke: .5pt, tick: (stroke: .5pt)),
            legend: (stroke: none, orientation: ttb, item: (spacing: .3), scale: 80%))

  plot.plot(size: (12, 8),
    y-tick-step: 1, y-min: 0, y-max: 7,
    x-tick-step: 1, x-min: -0.5, x-max: 16.5,
    legend: "inner-north",
    {
      plot.add(((1,0),(3,0),(8,0),(10,0),(16,0)), mark: "o", mark-style: (stroke: red, fill: red), style: (stroke: 0pt))
      plot.add(((1,0),(3,2),(3,0)), style: (stroke: red), line: "vh")
      plot.add(((8,0),(10,2),(10,0)), style: (stroke: red), line: "vh")
      plot.add(((2,2),(9,5),(9,2)), style: (stroke: red), line: "vh")
      plot.add((((2 + 9 / 2),5),(16,6),(16,0)), style: (stroke: red), line: "vh")
    })
})]

=== Complete Linkage
Odległość między klastrami to odległość między *najdalszymi* punktami.
+ Najmniejsze odległości to 2. Łączymy {1,3} i {8,10}.
  - Klastry: ${1,3}, {8,10}, {16}$.
+ Aktualizujemy macierz odległości (bierzemy maksimum):
  - $d({1,3}, {8,10}) = d(1,10) = 9$
  - $d({8,10}, {16}) = d(8,16) = 8$
  - $d({1,3}, {16}) = d(1,16) = 15$
  Najmniejsza z tych wartości to 8. Łączymy ${8,10}$ i ${16}$.
  - Klastry: ${1,3}, {8,10,16}$.
+ Łączymy pozostałe dwie grupy. Odległość to $max(d(1,16), d(3,16)) = 15$.

#align(center)[#canvas({
  import draw: *

  // Set-up a thin axis style
  set-style(
    axes: (stroke: .5pt, tick: (stroke: .5pt)),
    legend: (stroke: none, orientation: ttb, item: (spacing: .3),
    scale: 80%)
  )

  plot.plot(size: (12, 8),
    // x-grid: "both", y-grid: "both",
    y-tick-step: 1, y-min: 0, y-max: 16,
    x-tick-step: 1, x-min: -0.5, x-max: 16.5,
    legend: "inner-north",
    {
      plot.add(((1,0),(3,0),(8,0),(10,0),(16,0)), mark: "o", mark-style: (stroke: red, fill: red), style: (stroke: 0pt))
      plot.add(((1,0),(3,2),(3,0)), style: (stroke: red), line: "vh")
      plot.add(((8,0),(10,2),(10,0)), style: (stroke: red), line: "vh")
      plot.add(((9,2),(16,8),(16,0)), style: (stroke: red), line: "vh")
      plot.add(((2,2),(12.5,15),(12.5,8)), style: (stroke: red), line: "vh")
    })
})]

== Ustalanie liczby klastrów z dendrogramu
Należy "ciąć" dendrogram w miejscu,
gdzie występuje najdłuższa pionowa linia (największy skok odległości)
bez przecinania poziomych linii łączenia.
Sugeruje to dużą separację między powstałymi grupami.

= Ćwiczenie 58 -- Wybór metody dla klastrów o nietypowych kształtach

== Poprawne metody:

- *DBSCAN* z odpowiednio dobranymi parametrami:
  DBSCAN grupuje na podstawie gęstości.
  Ponieważ linia i okrąg są gęstymi zbiorami punktów odzielonymi pustą przestrzenią,
  DBSCAN poradzi sobie bez problemów.
- *Klasteryzacja hierarchiczna - single linkage:*
  Efektem algorytmu single linkage jest łąńcuchowanie się punktów.
  Jeśli jakiś punkt nie należy do klastra ale jego bliski sąsiad nazleży,
  to klaster przyjmie też ten punkt nie zwracając uwagi na to jak daleko jest od centroidu.

== Niepoprawne metody:

- *K-Means:* dąży do tworzenia klastrów wypukłych, najlepiej w kształcie okręgu,
  o podobnych wielkościach.
  W tym przypadku linia nie jest okrągła więc K-Means najprawdopodobniej ją podzieli.
- *Klasteryzacja hierarchiczna - complete linkage*: Preferuje małe zwarte zbiory.
  Najprawdopodobniej będzie próbował podzielić linie na mniejsze zbiory.
