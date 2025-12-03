import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.model_selection import KFold, cross_val_score
from sklearn.linear_model import LogisticRegression
from sklearn.tree import DecisionTreeClassifier
from sklearn.ensemble import RandomForestClassifier
from sklearn.neighbors import KNeighborsClassifier
from sklearn.preprocessing import StandardScaler, LabelEncoder

# Ustawienie stylu wykresów
sns.set_theme(style="whitegrid")

# 1. Wczytanie danych
# Usuwamy pierwszą kolumnę (indeks), jeśli plik ma format R-owy z numeracją wierszy
try:
    df = pd.read_csv('Credit.csv', index_col=0)
except FileNotFoundError:
    print("Błąd: Nie znaleziono pliku Credit.csv.")
    # Tutaj normalnie kończymy, ale dla ciągłości kodu założymy strukturę danych
    exit()

# 2. Preprocessing wstępny (konwersja zmiennych kategorycznych)
# Kodujemy zmienne tekstowe na liczby (Gender, Student, Married, Ethnicity)
le = LabelEncoder()
categorical_cols = ['Gender', 'Student', 'Married', 'Ethnicity']
for col in categorical_cols:
    if col in df.columns:
        df[col] = le.fit_transform(df[col])

# Zbiór danych jest gotowy do podziału na zadania
print("Podgląd danych:")
print(df.head())


# --- Konfiguracja modeli i walidacji ---
models = [
    ('LogReg', LogisticRegression(max_iter=5000)), # Zwiększone iteracje dla zbieżności
    ('KNN-5', KNeighborsClassifier(n_neighbors=5)),
    ('KNN-15', KNeighborsClassifier(n_neighbors=15)),
    ('Tree-Depth3', DecisionTreeClassifier(max_depth=3)),
    ('Tree-Depth10', DecisionTreeClassifier(max_depth=10)),
    ('RandForest', RandomForestClassifier(n_estimators=50, random_state=42))
]

# Funkcja pomocnicza do oceny modeli
def evaluate_models(X, y, models, problem_name):
    results = []
    names = []
    scoring = 'accuracy'

    # KFold: 10 podziałów, tasowanie danych
    kfold = KFold(n_splits=10, shuffle=True, random_state=42)

    print(f"\n--- Wyniki dla problemu: {problem_name} ---")
    for name, model in models:
        cv_results = cross_val_score(model, X, y, cv=kfold, scoring=scoring)
        results.append(cv_results)
        names.append(name)
        print(f"{name}: średnia dokł. = {cv_results.mean():.4f} (+/- {cv_results.std():.4f})")

    return names, results

# --- Zadanie 12a: Czy Income > 50? ---
df_a = df.copy()
# Tworzymy nową zmienną celu
df_a['HighIncome'] = (df_a['Income'] > 50).astype(int)
# Usuwamy oryginalne Income oraz ID (jeśli zostało)
X_a = df_a.drop(['Income', 'HighIncome'], axis=1)
y_a = df_a['HighIncome']

# Skalowanie danych (ważne dla KNN i Regresji Logistycznej)
scaler = StandardScaler()
X_a_scaled = pd.DataFrame(scaler.fit_transform(X_a), columns=X_a.columns)

names_a, results_a = evaluate_models(X_a_scaled, y_a, models, "a) Income > 50")

# --- Zadanie 12b: Ile kart kredytowych? ---
df_b = df.copy()
# Cel: liczba kart (traktujemy jako klasyfikację wieloklasową)
y_b = df_b['Cards']
X_b = df_b.drop(['Cards'], axis=1) # Income zostaje, usuwamy cel

# Skalowanie
X_b_scaled = pd.DataFrame(scaler.fit_transform(X_b), columns=X_b.columns)

names_b, results_b = evaluate_models(X_b_scaled, y_b, models, "b) Liczba kart")

# --- Rysowanie Box-plotów ---
fig, axes = plt.subplots(1, 2, figsize=(16, 6))

# Wykres dla a)
axes[0].boxplot(results_a, tick_labels=names_a)
axes[0].set_title('Dokładność modeli: Dochód > 50')
axes[0].set_ylabel('Accuracy')
axes[0].tick_params(axis='x', rotation=45)

# Wykres dla b)
axes[1].boxplot(results_b, tick_labels=names_b)
axes[1].set_title('Dokładność modeli: Liczba kart')
axes[1].set_ylabel('Accuracy')
axes[1].tick_params(axis='x', rotation=45)

plt.tight_layout()
plt.savefig("plots/ex12_model_comparison.png")
