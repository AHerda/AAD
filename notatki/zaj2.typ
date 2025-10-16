#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Wykład 2\ Uczenie nadzorowane],
  date: datetime.today().display(),
)

= Zbiór danych z etykietami

$ D = {(dash(x)^((1)), y_((1))), dots.c, (dash(x)^((n)), y^((n)))} $
/ $dash(x)^((i)) = (x_1^((i)), dots.c, x_p^((i)))$: cechy, zmienne wyjaśinające, predyktory
/ $y^((i))$: etykieta, zmienna wyjaśniająca

#underline[Problem:] wyznaczyć ukrytą relację (ang. underlying realtion) $f$
$ y^((i)) = f(dash(x)^((i))) + epsilon^((i)) $
/ $epsilon^((i))$: szum

== Etykieta

/ Regresja: zmienna ciągła
/ Klasyfikacja: zmienna dyskretna

= Statistical learning vs Machine Learning

#table(align: left, columns: (1fr, 1fr),
  table.header([Statistical learning], [Machine learning]),
  [
    - proste modele z mocnym wsparciem teoretycznym, np. regresja liniowa,
    - łatwa interpretacja modelu, modele parametryczne
  ],
  [
    - złożone modele, weryfikowane empirycznie, np. _KNN_, _DT_
    - zazwyczaj nieparametryczne lub z dużą ilością parametrów
  ],
  [
    - łatwe wnioskowanie,
    - nie wymaga mocy obliczeniowej
  ],
  [
    - duża moc predykcyjna
    - nie wymaha założeń o danych
  ],
  [
    - słaba moc predykcyjna,
    - wymaga silnych założeń o danych,
    - wymaga aby szum ($epsilon$) miał rozkład normalny
  ],
  [
    - trudne w interpreacji (black box),
    - wymaga dużej mocy obliczeniowej
  ]
)

#sym.arrow.squiggly wnioskowanie (ang. inference)\
#sym.arrow.squiggly predykcja, przewidywanie


= Przygotowanie danych

+ Brakujące dane
  - usuwanie obserwacji,
  - zastępowanie:
    - średnią
    - medianą
    - dominantą dla danych dyskretnych
    - losowanie zgodne z rozkładem
    - dodatkowa etykieta "unknown"
+ Usuwanie podejrzanych obserwacji
  - outlier (nietypowy),
  - high leverage points,
  - histogram etykiet
+ Inżynieria cech
  - dostosować dane, tak by predykcja była łatwiejsza
+ Podział danych
  - część treningowa $approx 75%$,
  - część walidacyjna $approx 15%$,
  - część testowa $approx 10%$,
  - typowo podział jest losowy

= Bład średnio kwadratowy (ang. MSE - Mean Square Error)

$ "MSE" &= EE((hat(f)(dash(x)^((0))) - y^((0)))^2)\
&= "Bias"(hat(f)(dash(x)^((0))))^2 + "Var"(hat(f)^2(dash(x)^((0)))) + "Var"(epsilon) $

$ "Bias"(hat(f)(dash(x)^((0))) = EE(f(dash(x)^((0))) - hat(f)(dash(x)^((0)))) $
