#import "template.typ": *

#show: project.with(
  title: [Algorytmiczna Analiza Danych\ Zajęcia 0\ Wprowadzenie],
  date: datetime.today().display(),
  authors: ((name: "Adrian Herda", affiliation: "Politechnika Wrocławska"),),
)

= Inforamcje organizacyjne
Wszystko jest na stronie!!!
- Zasoby
- Literatura
- Konsultacje

Ćwiczenia w formie deklaracyjnej
- za 100% można dostać przepis

= Techniki analizy danych w zależności od reprezentacji danych

== Bazy danych
- SQL, BI
- MongoDB
- Wektorowe bazy danych
- Grafowe bazy danych

== Inne
- CSU
- Excel

== Grafy
- PageBreak
- Algorytmy grafowe
- Wyznaczanie wezłów centralnych

== Strumienie danych
- HyperLogLog
- Algorytm próbkowania
- Analiza częstości
- Spark, Hadop (?), Kafka (?)

== Grafika

= Dane tbaleryczne
#table(align: left, columns: (1fr, 1fr),
  table.header([Z etykietami], [Bez etykiet]),
  [
    - Satisfied learning #sym.tilde 1950,\
      np. regresja liniowa, regresja logistyczna
    - Machine learning #sym.tilde 1990, \
      np. drzewo decyzyjne, k-najbliższych sąsiadów, sieci neuronowe, SVM
    - Deep learning #sym.tilde 2012,
  ],
  [
    - klasteryzacja, detekcja anomalii
    - reguły asocjacyjne, np. APRIORI
      $ "pieluszka" + "mleko" -> "piwo" $
    - PCA (principal component analysis), mapy cieplne
    - autoenkodery
  ]
)

= Różnica _machine learning_ oraz _deep learning_

== #sym.tilde 1950 - pomysł na AI
Input:
- Dane
- Reguły
Output:
- Odpowiedzi

idea:\
AI wyłoni się z dużej ilości reguł (system ekspercki) \
problemy:
+ cena wysoka - wymaga pracy prgramistów i ekspertów
+ trudne do stworzenia - eksperci nie chcą kub nie umieją pisać reguł

== #sym.tilde 1990 - ML
Input:
- Dane #sym.arrow ekstrakcja cech (eksperci)
- Odpowiedzi (etykiety)
Output:
- reguły (wytrenowny model)

idea:\
Przykłady zamist ekspertów\
problemy:\
Nadaje się tylko do prostych zadań z niewielką liczbą cech, w przeciwnym przypadku potrzebna jest inżynieria cech (ang. feature engineering) oraz pre-processing\
Czyli eksperci są niezbędni

== #sym.tilde 2012 - Deep Learning

Input:
- Dane #sym.arrow automatic feature extraction
- Etykiety
Output:
- Model

idea:\
Złożone problemy bez wiedzy ekspertów \

