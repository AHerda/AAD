import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_wine
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.ensemble import IsolationForest
from sklearn.metrics import silhouette_score, confusion_matrix
from scipy.cluster.hierarchy import dendrogram, linkage

# --- Ładowanie i przygotowanie danych ---
data = load_wine()
X = pd.DataFrame(data.data, columns=data.feature_names)
y_true = data.target
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

# Funkcja pomocnicza: Purity Score
def purity_score(y_true, y_pred):
    cm = confusion_matrix(y_true, y_pred)
    return np.sum(np.amax(cm, axis=0)) / np.sum(cm)

# --- Podpunkt A: Analiza Klastrów (Elbow, Purity, Anomalie) ---
k_values = range(2, 9)
inertias = []
purities = []
anomalies_counts = []

print(f"Prawdziwa liczba klas w zbiorze: {len(np.unique(y_true))}")

for k in k_values:
    # Klasteryzacja
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels_k = kmeans.fit_predict(X_scaled)
    inertias.append(kmeans.inertia_)
    purities.append(purity_score(y_true, labels_k))

    # Detekcja anomalii (Isolation Forest)
    iso = IsolationForest(contamination=0.05, random_state=42)
    anomalies = iso.fit_predict(X_scaled)
    anomalies_counts.append(np.sum(anomalies == -1)) # -1 to anomalia

# Wykresy dla podpunktu A
fig, ax1 = plt.subplots(figsize=(10, 5))
ax1.set_xlabel('Liczba klastrów (k)')
ax1.set_ylabel('Inertia (WCSS)', color='tab:blue')
ax1.plot(k_values, inertias, 'o-', color='tab:blue', label='Inertia (Elbow)')
ax1.tick_params(axis='y', labelcolor='tab:blue')

ax2 = ax1.twinx()
ax2.set_ylabel('Purity Score', color='tab:green')
ax2.plot(k_values, purities, 's--', color='tab:green', label='Purity')
ax2.tick_params(axis='y', labelcolor='tab:green')

plt.title('Metoda Łokcia i Purity Score')
plt.show()

# Wybór optymalnego k (wiemy, że to 3, ale sprawdźmy elbow method)
best_k = 3
print(f"\nAnaliza dla wybranego k={best_k}:")

# --- Podpunkt B: Porównanie Oryginał vs PCA ---
# 1. Oryginał
kmeans_orig = KMeans(n_clusters=best_k, random_state=42, n_init=10).fit(X_scaled)
sil_orig = silhouette_score(X_scaled, kmeans_orig.labels_)
pur_orig = purity_score(y_true, kmeans_orig.labels_)

# 2. PCA (redukcja do 2 wymiarów)
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)
kmeans_pca = KMeans(n_clusters=best_k, random_state=42, n_init=10).fit(X_pca)
sil_pca = silhouette_score(X_pca, kmeans_pca.labels_)
pur_pca = purity_score(y_true, kmeans_pca.labels_)

results_df = pd.DataFrame({
    'Metric': ['Silhouette Score', 'Purity Score'],
    'Original Data (13D)': [sil_orig, pur_orig],
    'PCA Data (2D)': [sil_pca, pur_pca]
})
print(results_df)

# --- Podpunkt C: Cechy kluczowe (Heatmapa i Biplot) ---
# Dendrogram + Heatmapa
# Bierzemy próbkę losową dla czytelności
sample_idx = np.random.choice(X_scaled.shape[0], 40, replace=False)
sns.clustermap(X.iloc[sample_idx], standard_scale=1, method='ward', cmap='viridis', figsize=(10, 10))
plt.title('Heatmapa z Dendrogramem (Próbka)')
plt.show()

# Biplot PCA
def biplot(score, coeff, labels=None):
    plt.figure(figsize=(10, 8))
    xs = score[:,0]
    ys = score[:,1]
    n = coeff.shape[0]
    scalex = 1.0/(xs.max() - xs.min())
    scaley = 1.0/(ys.max() - ys.min())

    # Punkty
    scatter = plt.scatter(xs * scalex, ys * scaley, c=y_true, cmap='Set1')

    # Wektory cech
    for i in range(n):
        plt.arrow(0, 0, coeff[i,0], coeff[i,1], color='r', alpha=0.5)
        if labels is None:
            plt.text(coeff[i,0]* 1.15, coeff[i,1] * 1.15, "Var"+str(i+1), color='g', ha='center', va='center')
        else:
            plt.text(coeff[i,0]* 1.15, coeff[i,1] * 1.15, labels[i], color='g', ha='center', va='center')

    plt.xlabel("PC1")
    plt.ylabel("PC2")
    plt.grid()
    plt.title("PCA Biplot: Klastry + Wpływ Cech")
    plt.show()

biplot(X_pca, pca.components_.T, labels=X.columns)
