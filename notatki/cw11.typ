#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Ćwiczenia 11],
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
  date: [19 grudnia 2025 r.],
)

= Zadanie 40 -- Współczynnik Giniego

/ Współczynnik Giniego: to statystyczna miara koncentracji (nierówności) rozkładu dochodów lub bogactwa w danym społeczeństwie. Przyjmuje wartości od 0 do 1 (lub od 0% do 100%).

- / 0 (Idealna równość): Każdy obywatel ma dokładnie taki sam dochód.
- / 1 (Idealna nierówność): Jedna osoba posiada cały dochód kraju, a reszta nie posiada nic.

== Intuicja geometryczna (Krzywa Lorenza)
Współczynnik Giniego oblicza się na podstawie wykresu, gdzie na osi X mamy skumulowany odsetek populacji, a na osi Y skumulowany odsetek dochodu.



+ / Linia 45 stopni: To linia idealnej równości.
+ / Krzywa Lorenza: Rzeczywisty rozkład dochodów w populacji.
+ / Obliczanie: Jeśli oznaczymy pole między linią 45 stopni a Krzywą Lorenza jako $A$, a pole pod Krzywą Lorenza jako $B$, współczynnik Giniego ($G$) wyraża się wzorem: $ G = A / (A + B) $

== Pozycja Polski w OECD
Polska na tle krajów OECD prezentuje się jako kraj o *średnio-niskich* nierównościach, szczególnie po uwzględnieniu transferów społecznych:

- *Przed transferami i podatkami:* Współczynnik Giniego w Polsce jest relatywnie wysoki (podobnie jak w większości krajów rozwiniętych), co wynika z rynkowego zróżnicowania płac.
- *Po transferach i podatkach:* Polska odnotowuje jeden z większych spadków współczynnika w OECD. Obecnie wartość ta oscyluje wokół *$0.27 - 0.28$*, co plasuje Polskę poniżej średniej OECD (czyli jesteśmy krajem o mniejszych nierównościach niż np. USA, Wielka Brytania czy kraje bałtyckie).

== Poziom graniczny napięć społecznych
W literaturze ekonomicznej i socjologicznej (m.in. ONZ) przyjmuje się często, że wartości współczynnika Giniego powyżej *$0.40$* stanowią "czerwoną linię". Przekroczenie tego poziomu sugeruje głębokie nierówności, które mogą prowadzić do destabilizacji politycznej, protestów i wzrostu przestępczości.


= Zadanie 41 -- Algorytm Random Forest

Random Forest to metoda zespołowa (ensemble learning) oparta na budowie wielu drzew decyzyjnych i agregacji ich wyników.

== Pseudokod
+ Dla $b = 1$ do $B$ (liczba drzew):
  - Wylosuj próbkę bootstrapową $Z^*$ z danych treningowych (losowanie ze zwracaniem).
  - Wyhoduj drzewo $T_b$ na podstawie próbki $Z^*$:
    - Powtarzaj, aż osiągniesz minimalny rozmiar liścia:
      - Wybierz losowo $m$ zmiennych spośród wszystkich $p$ predyktorów.
      - Wybierz najlepszą zmienną i punkt podziału spośród $m$ zmiennych.
      - Podziel węzeł na dwa węzły potomne.
+ Zwróć zespół drzew ${T_b}_1^B$.

== Predykcja
- / Klasyfikacja: Głosowanie większościowe (Majority Vote) - klasa najczęściej wskazywana przez drzewa.
- / Regresja: Średnia arytmetyczna z przewidywań wszystkich $B$ drzew.

= Ćwiczenie 42 -- Algorytm Boosting (Regresja)

W przeciwieństwie do Random Forest, Boosting buduje drzewa sekwencyjnie. Każde kolejne drzewo uczy się na błędach (resztach) swoich poprzedników.

== Pseudokod (na podstawie ISL)
+ Ustaw $hat(f)(x) = 0$ oraz reszty $r_i = y_i$ dla wszystkich obserwacji w zbiorze treningowym.
+ Dla $b = 1, 2, dots, B$:
  - Dopasuj drzewo $hat(f)^b$ z $d$ podziałami (liczba liści = $d+1$) do danych treningowych $(X, r)$.
  - Zaktualizuj model główny, dodając nową wersję drzewa z parametrem uczenia (shrinkage) $lambda$:
    $ hat(f)(x) arrow.l hat(f)(x) + lambda hat(f)^b(x) $
  - Zaktualizuj reszty:
    $ r_i arrow.l r_i - lambda hat(f)^b(x_i) $
+ Zwróć model końcowy: $hat(f)(x) = sum_(b=1)^B lambda hat(f)^b(x)$.

== Wyjaśnienie kluczowych parametrów
- / $B$ (Liczba drzew): Zbyt duża może prowadzić do overfittingu (inaczej niż w RF).
- / $lambda$ (Shrinkage): Mała wartość (np. 0.01) spowalnia naukę, wymagając więcej drzew, ale zazwyczaj poprawia generalizację.
- / $d$ (Liczba podziałów): Kontroluje złożoność każdego drzewa (często wystarczają bardzo proste drzewa, tzw. stumps, gdzie $d=1$).
