import pandas as pd
import numpy as np
import time
import matplotlib.pyplot as plt
import seaborn as sns
import plotly.graph_objects as go
from mlxtend.frequent_patterns import apriori, association_rules
from mlxtend.preprocessing import TransactionEncoder

# --- Generowanie Danych ---
dataset = [['Mleko', 'Chleb', 'Masło', 'Jajka'],
           ['Mleko', 'Chleb', 'Masło'],
           ['Mleko', 'Jajka', 'Jabłka'],
           ['Chleb', 'Masło', 'Jabłka'],
           ['Mleko', 'Chleb', 'Masło', 'Jajka', 'Jabłka'],
           ['Chleb', 'Masło'],
           ['Mleko', 'Jajka'],
           ['Mleko', 'Chleb', 'Jajka', 'Masło'],
           ['Chleb', 'Masło', 'Jabłka'],
           ['Mleko', 'Chleb', 'Masło', 'Jajka', 'Cukier']] * 50  # Powielenie dla większej skali

te = TransactionEncoder()
te_ary = te.fit(dataset).transform(dataset)
df = pd.DataFrame(te_ary, columns=te.columns_)

# --- Podpunkt A: Algorytm Apriori i Reguły ---
min_sup = 0.4
min_conf = 0.7

frequent_itemsets = apriori(df, min_support=min_sup, use_colnames=True)
rules = association_rules(frequent_itemsets, metric="confidence", min_threshold=min_conf)

print("Częste zestawy cech (head):")
print(frequent_itemsets.head())
print("\nReguły asocjacyjne (head):")
print(rules[['antecedents', 'consequents', 'support', 'confidence', 'lift']].head())

# --- Podpunkt B: Parallel Categories Diagram ---
# Wybór top 10 reguł do wizualizacji
top_rules = rules.sort_values('confidence', ascending=False).head(10)

# Przygotowanie danych do Plotly
source = [str(list(x)[0]) for x in top_rules['antecedents']]
target = [str(list(x)[0]) for x in top_rules['consequents']]
count = top_rules['support'] * len(df)

fig = go.Figure(go.Parcats(
    dimensions=[
        {'label': 'Antecedents (Poprzednik)', 'values': source},
        {'label': 'Consequents (Następnik)', 'values': target}
    ],
    counts=count,
    line={'color': top_rules['confidence'], 'colorscale': 'Viridis'}
))
fig.update_layout(title='Diagram Równoległych Kategorii dla Reguł Asocjacyjnych')
# fig.show() # Odkomentuj, aby wyświetlić interaktywny wykres

# --- Podpunkt C: Analiza wydajności i kandydatów ---
support_range = np.linspace(0.1, 0.9, 9)
times = []
itemset_counts = []
max_sizes = []
candidates_no_pruning = [] # Teoretyczna liczba (2^k - 1) - symulacja

for sup in support_range:
    start_time = time.time()
    fi = apriori(df, min_support=sup, use_colnames=True)
    end_time = time.time()

    times.append(end_time - start_time)
    itemset_counts.append(len(fi))
    max_sizes.append(fi['itemsets'].apply(len).max() if not fi.empty else 0)

    # Estymacja kandydatów bez przycinania (dla uproszczenia suma kombinacji dla max rozmiaru)
    # W rzeczywistości to suma po k (n choose k). Tu użyjemy uproszczonej metryki logicznej.
    n_features = df.shape[1]
    theoretical_max = sum([np.math.comb(n_features, k) for k in range(1, int(max_sizes[-1])+1)]) if max_sizes[-1] > 0 else 0
    candidates_no_pruning.append(theoretical_max)

fig, axes = plt.subplots(2, 2, figsize=(14, 10))

# Czas vs Support
sns.lineplot(x=support_range, y=times, marker='o', ax=axes[0, 0])
axes[0, 0].set_title('Czas działania vs Min Support')
axes[0, 0].set_xlabel('Min Support')
axes[0, 0].set_ylabel('Czas (s)')
axes[0, 0].invert_xaxis() # Mniejszy support = trudniej

# Liczba częstych zestawów vs Support
sns.lineplot(x=support_range, y=itemset_counts, marker='s', color='green', ax=axes[0, 1])
axes[0, 1].set_title('Liczba częstych zestawów vs Min Support')
axes[0, 1].set_xlabel('Min Support')
axes[0, 1].invert_xaxis()

# Kandydaci teoretyczni vs z przycinaniem
axes[1, 0].plot(support_range, candidates_no_pruning, label='Bez przycinania (teoria)', linestyle='--')
axes[1, 0].plot(support_range, itemset_counts, label='Z przycinaniem (Apriori)', marker='o')
axes[1, 0].set_title('Redukcja przestrzeni poszukiwań (Skala Log)')
axes[1, 0].set_yscale('log')
axes[1, 0].set_xlabel('Min Support')
axes[1, 0].legend()
axes[1, 0].invert_xaxis()

# Max rozmiar zestawu vs Support
sns.lineplot(x=support_range, y=max_sizes, marker='^', color='orange', ax=axes[1, 1])
axes[1, 1].set_title('Maksymalny rozmiar zestawu vs Min Support')
axes[1, 1].set_xlabel('Min Support')
axes[1, 1].invert_xaxis()

plt.tight_layout()
plt.show()
