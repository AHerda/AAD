#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 8],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [28 listopada 2025 r.],
)

= Ćwiczenie 28 -- Wielomianowa regresja logistyczna z modeli binarnych

Aby uzyskać model dla $K$ klas, wykorzystując $K-1$ modeli binarnej regresji logistycznej, stosujemy podejście oparte na *klasie referencyjnej* (bazowej). Załóżmy, że klasa $K$ jest naszą klasą bazową.

Budujemy $K-1$ klasyfikatorów binarnych, gdzie $k$-ty model (dla $k = 1, ..., K-1$) uczy się przewidywać logarytm szansy (log-odds) bycia w klasie $k$ względem klasy $K$:

$ ln(Pr(Y=k) / Pr(Y=K)) = beta_k^T x $

Gdzie $beta_k$ to wektor wag dla klasy $k$. Przekształcając to równanie, otrzymujemy:

$ P(Y=k) = P(Y=K) dot e^(beta_k^T x) $

Ponieważ suma prawdopodobieństw wszystkich klas musi wynosić $1$ ($sum_(j=1)^K Pr(Y=j) = 1$), możemy wyznaczyć $Pr(Y=K)$:

$ Pr(Y=K) + sum_(k=1)^(K-1) Pr(Y=K) dot e^(beta_k^T x) = 1 \
Pr(Y=K) (1 + sum_(k=1)^(K-1) e^(beta_k^T x)) = 1 \
Pr(Y=K) = 1 / (1 + sum_(k=1)^(K-1) e^(beta_k^T x)) $

Dla dowolnego $k < K$ prawdopodobieństwo wynosi zatem:

$ Pr(Y=k) = e^(beta_k^T x) / (1 + sum_(j=1)^(K-1) e^(beta_j^T x)) $

Jest to równoważne funkcji Softmax, gdzie dla klasy referencyjnej przyjmujemy wektor wag $beta_K = 0$ (wektor zerowy).

= Ćwiczenie 29 -- Funkcja Softmax

== Wzór i intuicja
Wzór funkcji Softmax dla $j$-tego elementu wektora $z$:

$ p_j (z) = e^(z_j) / (sum_(k=1)^n e^(z_k)) $

=== Intuicja

Funkcja ta realizuje dwa cele:
+ / Exponentiation ($e^x$): Przekształca logity (które mogą być ujemne) na wartości dodatnie oraz wzmacnia różnice między wartościami (duże wartości stają się znacznie większe od małych).
+ / Normalizacja: Dzielenie przez sumę sprawia, że wszystkie wartości sumują się do 1, tworząc poprawny rozkład prawdopodobieństwa.

=== Dlaczego "ciągły argmax"?

Zwykła funkcja `argmax` zwraca indeks największej wartości (np. wektor one-hot). Jest ona jednak nieciągła i nieróżniczkowalna. Softmax jest jej gładkim przybliżeniem. Jeśli wprowadzimy parametr temperatury $T$ ($z_j / T$) i $T -> 0$, rozkład softmax dąży do rozkładu punktowego (1 dla maksimum, 0 dla reszty), zachowując jednak różniczkowalność, co jest kluczowe dla uczenia sieci metodą spadku gradientu.

== Klasyfikacja wieloetykietowa (Multi-label)
Gdy obserwacja może należeć do kilku klas jednocześnie, Softmax nie jest odpowiedni, ponieważ wymusza sumowanie się prawdopodobieństw do 1 (konkurencja między klasami).

*Rozwiązanie:* Stosuje się funkcję *Sigmoid* ($sigma(z) = 1/(1+e^(-z))$) niezależnie dla każdego wyjścia (dla każdej klasy). Traktujemy to jako $n$ niezależnych problemów klasyfikacji binarnej ("czy należy do klasy A?", "czy należy do klasy B?" itd.). Funkcją kosztu jest wtedy suma binarnych entropii krzyżowych.

= Ćwiczenie 30 -- Macierz Jacobiego funkcji Softmax

Mamy wektor $p(z)$ o składowych $p_j = e^(z_j) / (sum_k e^(z_k))$.

== Macierz Jacobiego
Macierz Jacobiego $J$ ma wymiary $n times n$, a jej element na pozycji $(j, k)$ to pochodna cząstkowa $j$-tego wyjścia po $k$-tym wejściu:

$ J_(j k) = (partial p_j) / (partial z_k) $

Wzór ogólny (z wykorzystaniem delty Kroneckera $delta_(j k)$):

$ (partial p_j) / (partial z_k) = p_j (delta_(j k) - p_k) $

Co w rozwinięciu daje:
- Na przekątnej ($j=k$): $p_j (1 - p_j)$
- Poza przekątną ($j != k$): $-p_j p_k$

== Analiza znaków pochodnych
- *Gdy $j = k$:* $(partial p_j) / (partial z_k) = p_j (1 - p_j)$.
    Ponieważ $p_j$ jest prawdopodobieństwem z funkcji Softmax (dla skończonych $z$), to $0 < p_j < 1$. Zatem iloczyn dwóch liczb dodatnich jest *dodatni*.
- *Gdy $j != k$:* $(partial p_j) / (partial z_k) = -p_j p_k$.
    Ponieważ $p_j > 0$ i $p_k > 0$, to ich iloczyn ze znakiem minus jest *ujemny*.

*Konsekwencje:*
Zwiększenie wartości logitu $z_k$ (sygnału dla klasy $k$) powoduje wzrost prawdopodobieństwa tej klasy ($p_k$), ale jednocześnie *obniżenie* prawdopodobieństw wszystkich pozostałych klas ($p_j$). Potwierdza to konkurencyjną naturę Softmaxu - klasy "walczą" o zasoby (sumę równą 1).

= Ćwiczenie 31 -- Gradient Entropii Krzyżowej

Chcemy policzyć $(partial L) / (partial z_i)$, gdzie $L = - sum_k y_k log(p_k(z))$.

Korzystając z reguły łańcuchowej (dla wielu zmiennych):
$ (partial L) / (partial z_i) = sum_(k=1)^n (partial L) / (partial p_k) dot (partial p_k) / (partial z_i) $

+ Pochodna $L$ po $p_k$:
  $ (partial) / (partial p_k) (- sum_j y_j log(p_j)) = - y_k / p_k $
+ Pochodna Softmaxu (z Ćwiczenia 30):
  $ (partial p_k) / (partial z_i) = p_k (delta_(k i) - p_i) $

Podstawiając:
$
  (partial L) / (partial z_i) &= sum_k (- y_k / p_k) dot p_k (delta_(k i) - p_i) \
  &= - sum_k y_k (delta_(k i) - p_i) \
  &= - (y_i (1 - p_i) + sum_(k != i) y_k (-p_i)) \
  &= - (y_i - y_i p_i - sum_(k != i) y_k p_i) \
  &= - (y_i - p_i underbrace(sum_k y_k, "= 1")) \
  &= p_i - y_i
$

*Wynik:*
$ (partial L) / (partial z_i) = p_i - y_i $

*Wykorzystanie:*
Wzór $p_i - y_i$ reprezentuje *błąd predykcji* (różnicę między przewidywanym prawdopodobieństwem a rzeczywistą etykietą). Jest to sygnał błędu przekazywany wstecz (backpropagation) do aktualizacji wag modelu.
- Jeśli $y_i=1$, a model dał $p_i=0.8$, gradient wynosi $-0.2$ (dążymy do zwiększenia $z_i$).
- Jego prostota obliczeniowa sprawia, że połączenie Softmax + Cross-Entropy jest standardem w sieciach neuronowych.

= Ćwiczenie 33 -- Wykres Pudełkowy (Boxplot)

Wykres pudełkowy służy do wizualizacji rozkładu cechy statystycznej i składa się z następujących elementów:

+ *Pudełko (Box):*
  - Dolna krawędź pudełka wyznacza _pierwszy kwartyl (Q1)_ (25. centyl).
  - Górna krawędź wyznacza _trzeci kwartyl (Q3)_ (75. centyl).
  - Wysokość pudełka to _rozstęp międzykwartylowy (IQR = Q3 - Q1)_, w którym znajduje się 50% środkowych obserwacji.

+ *Linia wewnątrz pudełka:*
  - Oznacza _medianę (Q2)_, czyli wartość środkową. Jej położenie wskazuje na skośność rozkładu (np. jeśli jest bliżej dołu, rozkład może być prawoskośny).

+ *Wąsy (Whiskers):*
  - Linie wychodzące z pudełka w górę i w dół.
  - Zazwyczaj sięgają do ostatniego punktu danych mieszczącego się w przedziale $[Q 1 - 1.5 dot I Q R, Q 3 + 1.5 dot I Q R]$.

+ *Punkty poza wąsami (Outliers):*
  - Obserwacje odstające, które wykraczają poza zasięg wąsów. Są zaznaczane jako pojedyncze kropki lub gwiazdki.
