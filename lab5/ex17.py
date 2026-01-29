import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn.datasets import load_wine
from sklearn.preprocessing import StandardScaler
from sklearn.cluster import KMeans
from sklearn.decomposition import PCA
from sklearn.ensemble import IsolationForest
from sklearn.metrics import silhouette_score, confusion_matrix, silhouette_score, adjusted_rand_score, normalized_mutual_info_score
from scipy.cluster.hierarchy import dendrogram, linkage

# --- Ładowanie i przygotowanie danych ---
data = load_wine()

X = pd.DataFrame(data.data, columns=data.feature_names)
y_true = data.target
scaler = StandardScaler()
X_scaled = scaler.fit_transform(X)

feature_names = data.feature_names
target_names = data.target_names

print(f"Rozmiar zbioru: {X.shape}")
print(f"Liczba klas (etykiet): {len(np.unique(y_true))}")
print(f"Rozkład klas: {np.bincount(y_true)}")
print(f"\nCechy: {feature_names}")

# Funkcja pomocnicza: Purity Score
def purity_score(y_true, y_pred):
    cm = confusion_matrix(y_true, y_pred)
    return np.sum(np.amax(cm, axis=0)) / np.sum(cm)

iso = IsolationForest(contamination=0.05, random_state=42)
global_anomalies = iso.fit_predict(X_scaled)
anomalies_mask = (global_anomalies == -1)

# --- Podpunkt A: Analiza Klastrów (Elbow, Purity, Anomalie) ---
k_values = range(2, 9)
inertias = []
purities = []
cluster_outliers_counts = []

print(f"Prawdziwa liczba klas w zbiorze: {len(np.unique(y_true))}")

for k in k_values:
    # Klasteryzacja
    kmeans = KMeans(n_clusters=k, random_state=42, n_init=10)
    labels_k = kmeans.fit_predict(X_scaled)
    inertias.append(kmeans.inertia_)
    purities.append(purity_score(y_true, labels_k))

    # Detekcja anomalii (Isolation Forest)
    all_distances = kmeans.transform(X_scaled)
    min_distances = np.min(all_distances, axis=1)
    threshold = np.mean(min_distances) + 2.0 * np.std(min_distances)
    cluster_outliers_per_class = []
    for class_label in np.unique(y_true):
        class_mask = (y_true == class_label)
        outliers_in_class = np.sum(min_distances[class_mask] > threshold)
        cluster_outliers_per_class.append(outliers_in_class)
    cluster_outliers_counts.append(cluster_outliers_per_class)

# Wykresy dla podpunktu A
fig, (ax1, ax2) = plt.subplots(1, 2, figsize=(15, 6))

# Wykres 1: Elbow Method & Purity
color = 'tab:orange'
ax1.set_xlabel('Liczba klastrów (k)')
ax1.set_ylabel('Inertia (Elbow)')
ax1.plot(k_values, inertias, 'o-', color=color, label='Inertia')
ax1.tick_params(axis='y', labelcolor=color)
ax1.grid(True, alpha=0.3)

ax1_twin = ax1.twinx()
color = 'tab:green'
ax1_twin.set_ylabel('Purity Score')
ax1_twin.plot(k_values, purities, 's--', color=color, label='Purity')
ax1_twin.tick_params(axis='y', labelcolor=color)
ax1.set_title('Jakość Klastrów: Elbow vs Purity')

# Wykres 2: Anomalie
ax2.plot(k_values, np.sum(cluster_outliers_counts, axis=1), 'd-', color='tab:red', label='Cluster Outliers (Dist > mean+2std)')
for class_idx in range(len(np.unique(y_true))):
    ax2.plot(k_values, [counts[class_idx] for counts in cluster_outliers_counts], 'd-', label=f'Class {class_idx} Outliers')
ax2.axhline(y=np.sum(anomalies_mask), color='gray', linestyle='--', label='Global IsoForest Anomalies (Static)')
ax2.set_xlabel('Liczba klastrów (k)')
ax2.set_ylabel('Liczba punktów odstających')
ax2.set_title('Anomalie: Zależne od k vs Globalne')
ax2.legend()
ax2.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig("plots/ex17_elbow_purity_anomalies.png")

# Wybór optymalnego k (wiemy, że to 3)
best_k = 3
print(f"\nAnaliza dla wybranego k={best_k}:")

# --- Podpunkt B: Porównanie Oryginał vs PCA ---
# 1. Oryginał
kmeans_orig = KMeans(n_clusters=best_k, random_state=42, n_init=10).fit(X_scaled)
sil_orig = silhouette_score(X_scaled, kmeans_orig.labels_)
pur_orig = purity_score(y_true, kmeans_orig.labels_)

# 2. PCA (redukcja do 2 wymiarów)
best_k = 3
pca = PCA(n_components=2)
X_pca = pca.fit_transform(X_scaled)

datasets = {
    'Original (13D)': X_scaled,
    'PCA (2D)': X_pca
}

results = []

for name, data_in in datasets.items():
    km = KMeans(n_clusters=best_k, random_state=42, n_init=10)
    labels = km.fit_predict(data_in)

    # Obliczanie metryk
    metrics = {
        'Dataset': name,
        'Purity': purity_score(y_true, labels),
        'Silhouette': silhouette_score(data_in, labels), # Wyżej = lepiej (-1 do 1)
        'ARI': adjusted_rand_score(y_true, labels), # Wyżej = lepiej (korekta losowości)
        'NMI': normalized_mutual_info_score(y_true, labels), # Wyżej = lepiej
    }
    results.append(metrics)

df_results = pd.DataFrame(results).set_index('Dataset').T
print("\n--- Tabela Porównawcza ---")
print(df_results.round(3))

# --- Podpunkt C: Cechy kluczowe (Heatmapa i Biplot) ---
# Dendrogram + Heatmapa
# Bierzemy próbkę losową dla czytelności
sample_idx = np.random.choice(X_scaled.shape[0], 40, replace=False)
sns.clustermap(X.iloc[sample_idx], standard_scale=1, method='ward', cmap='viridis', figsize=(10, 10))
plt.title('Heatmapa z Dendrogramem (Próbka)')
plt.savefig("plots/ex17_heatmap_dendrogram.png")

km_pca = KMeans(n_clusters=best_k, random_state=42, n_init=10).fit(X_pca)
labels_pca = km_pca.labels_

# Biplot PCA
def biplot(score, coeff, labels=None):
    fig, ax = plt.subplots(1, 1, figsize=(10, 8))
    xs = score[:,0]
    ys = score[:,1]
    n = coeff.shape[0]
    scalex = 1.0/(xs.max() - xs.min())
    scaley = 1.0/(ys.max() - ys.min())
    centers = km_pca.cluster_centers_
    ax.scatter(centers[:, 0] * scalex, centers[:, 1] * scaley, c='red', s=100, marker='X', label='Centroidy')
    ax.legend()

    # Punkty
    scatter = ax.scatter(xs * scalex, ys * scaley, c=labels_pca, cmap='viridis')
    ax.legend(*scatter.legend_elements(), title="Klastry")

    # Wektory cech
    for i in range(n):
        plt.arrow(0, 0, coeff[i,0], coeff[i,1], color='r', alpha=0.5)
        if labels is None:
            plt.text(coeff[i,0]* 1.05, coeff[i,1] * 1.05, "Var"+str(i+1), color='g', ha='center', va='center')
        else:
            plt.text(coeff[i,0]* 1.05, coeff[i,1] * 1.05, labels[i], color='g', ha='center', va='center')

    plt.xlabel("PC1")
    plt.ylabel("PC2")
    plt.grid()
    plt.title("PCA Biplot: Klastry + Wpływ Cech")
    plt.savefig("plots/ex17_biplot.png")

biplot(X_pca, pca.components_.T, labels=X.columns)
