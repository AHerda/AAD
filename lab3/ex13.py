import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
# from matplotlib.colors import ListedColormap
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

# --- Zadanie 12a: Czy Income > 50? ---
df_a = df.copy()
# Tworzymy nową zmienną celu
df_a['HighIncome'] = (df_a['Income'] > 50).astype(int)

# --- Zadanie 12b: Ile kart kredytowych? ---
df_b = df.copy()

def plot_decision_boundary(model, X, y, ax, title):
    # Konwersja do numpy array
    X = X.values
    y = y.values

    # Trenujemy model na tylko dwóch cechach
    model.fit(X, y)

    # Tworzenie siatki punktów (meshgrid)
    x_min, x_max = X[:, 0].min() - 1, X[:, 0].max() + 1
    y_min, y_max = X[:, 1].min() - 1, X[:, 1].max() + 1
    h = (x_max / x_min)/100 if x_min != 0 else 0.1 # krok siatki
    h = 50 # Stały krok dla czytelności przy dużych liczbach
    xx, yy = np.meshgrid(np.arange(x_min, x_max, h),
                         np.arange(y_min, y_max, h))

    # Predykcja dla każdego punktu siatki
    Z = model.predict(np.c_[xx.ravel(), yy.ravel()])
    Z = Z.reshape(xx.shape)

    # Rysowanie konturów
    # Używamy wielu kolorów (cmap='viridis' lub custom)
    ax.contourf(xx, yy, Z, alpha=0.3, cmap=plt.cm.coolwarm)

    # Rysowanie punktów danych
    scatter = ax.scatter(X[:, 0], X[:, 1], c=y, s=20, edgecolor='k', cmap=plt.cm.coolwarm)

    ax.set_xlabel('Limit')
    ax.set_ylabel('Balance')
    ax.set_title(title)

# Wybór cech (Limit i Balance)
features_cols = ['Limit', 'Balance']

# Wybór modeli do wizualizacji (np. KNN i Drzewo)
viz_models = [
    ('KNN-15', KNeighborsClassifier(n_neighbors=15)),
    ('RandomForest', RandomForestClassifier(n_estimators=50, max_depth=5, random_state=42))
]

fig, axes = plt.subplots(2, 2, figsize=(14, 12))

# --- Wizualizacja dla zadania a) Income > 50 ---
X_vis_a = df_a[features_cols]
y_vis_a = df_a['HighIncome']

plot_decision_boundary(viz_models[0][1], X_vis_a, y_vis_a, axes[0, 0], f"Zad A: {viz_models[0][0]}")
plot_decision_boundary(viz_models[1][1], X_vis_a, y_vis_a, axes[0, 1], f"Zad A: {viz_models[1][0]}")

# --- Wizualizacja dla zadania b) Liczba kart ---
X_vis_b = df_b[features_cols]
y_vis_b = df_b['Cards']

plot_decision_boundary(viz_models[0][1], X_vis_b, y_vis_b, axes[1, 0], f"Zad B: {viz_models[0][0]}")
plot_decision_boundary(viz_models[1][1], X_vis_b, y_vis_b, axes[1, 1], f"Zad B: {viz_models[1][0]}")

plt.tight_layout()
plt.savefig("plots/ex13_decision_boundaries.png")

# Czy jesteś w stanie zaproponować sensowne granice decyzyjne dla problemu z punktu b)?
# Najprawdopodobniej nie.
# Natura danych: Liczba posiadanych kart kredytowych (Cards) zazwyczaj nie zależy w sposób liniowy ani geometryczny od Limit i Balance w tak wyraźny sposób, jak np. Rating kredytowy.
# Wizualizacja: Na wykresach dla punktu b) zobaczysz prawdopodobnie "mozaikę" lub bardzo poszarpane, nieregularne wyspy kolorów (szczególnie przy KNN). Oznacza to, że model próbuje dopasować się do szumu w danych (overfitting).
# Wnioski: Granice decyzyjne dla liczby kart oparte tylko na dwóch zmiennych będą wyglądać chaotycznie, co sugeruje, że albo te dwie zmienne nie wystarczają do predykcji, albo problem jest z natury trudny do separacji w przestrzeni 2D. W przeciwieństwie do problemu a) (Income > 50), gdzie Limit jest silnie skorelowany z dochodem, przez co granica powinna być dość wyraźna i liniowa (lub bliska liniowej).
