import pandas as pd
import numpy as np
import time
import itertools
import plotly.express as px
import matplotlib.pyplot as plt
from sklearn.datasets import fetch_openml
from collections import Counter
from itertools import combinations, chain

# ==========================================
# IMPLEMENTACJA APRIORI
# ==========================================

class CustomApriori:
    def __init__(self, min_support=0.1, min_confidence=0.5, with_pruning=True):
        self.min_support = min_support
        self.min_confidence = min_confidence
        self.with_pruning = with_pruning
        self.stats = {
            'total_candidates': 0, 
            'frequent_itemsets_count': 0,
            'max_itemset_size': 0,
        }

    def get_support(self, itemset, transactions_sets):
        count = sum(1 for t_set in transactions_sets if itemset.issubset(t_set))
        return count / len(transactions_sets)

    def get_frequent_singletons(self, transactions):
        item_counts = Counter(chain.from_iterable(transactions))
        n_transactions = len(transactions)
        frequent = {
            frozenset([item]): count / n_transactions
            for item, count in item_counts.items()
            if (count / n_transactions) >= self.min_support
        }
        self.stats['total_candidates'] += len(item_counts)
        return frequent

    def apriori_gen(self, prev_frequent, k):
        candidates = {
            s1 | s2 for s1, s2 in combinations(prev_frequent.keys(), 2)
            if len(s1 | s2) == k
        }
        if self.with_pruning:
            candidates = {
                cand for cand in candidates
                if all((cand - {item}) in prev_frequent for item in cand)
            }
        self.stats['total_candidates'] += len(candidates)
        return candidates

    def find_frequent_itemsets(self, transactions, transactions_sets):
        current_frequent = self.get_frequent_singletons(transactions)
        frequent_itemsets = dict(current_frequent)
        k = 1
        while current_frequent:
            k += 1
            candidates = self.apriori_gen(current_frequent, k)

            if not candidates:
                break

            current_frequent = {
                can: supp for can in candidates
                if (supp := self.get_support(can, transactions_sets)) >= self.min_support
            }
            frequent_itemsets.update(current_frequent)

        self.stats.update({
            'frequent_itemsets_count': len(frequent_itemsets),
            'max_itemset_size': k - 1 if current_frequent or k > 1 else 0
        })

        return frequent_itemsets

    def generate_rules(self, frequent_itemsets):
        rules = []
        for itemset, support in frequent_itemsets.items():
            if len(itemset) < 2:
                continue
            for i in range(1, len(itemset)):
                for ant_tuple in combinations(itemset, i):
                    antecedent = frozenset(ant_tuple)
                    consequent = itemset - antecedent
                    supp_a = frequent_itemsets.get(antecedent)
                    supp_c = frequent_itemsets.get(consequent)

                    if not supp_a or not supp_c:
                        continue

                    confidence = support / supp_a

                    if confidence >= self.min_confidence:
                        rules.append({
                            'antecedent': antecedent,
                            'consequent': consequent,
                            'support': support,
                            'confidence': confidence,
                            'lift': confidence / supp_c
                        })
        return sorted(rules, key=lambda x: x['lift'], reverse=True)

# ==========================================
# Przygotowanie danych
# ==========================================

# A chess endgame data set representing the positions on the board of the white king, the white rook,
# and the black king. The task is to determine the optimum number of turn required for white to win the game,
# which can be a draw if it takes more than sixteen turns.
print("Pobieranie danych King-Rook-vs-King (ID: 46173)...")
data = fetch_openml(data_id=46173, parser='auto')
df = pd.DataFrame(data.data, columns=data.feature_names)
df["Game"] = data.target
df['Game'] = df['Game'].apply(lambda x: x.replace("zero", "win"))
for i in ["sixteen", "eleven", "twelve", "thirteen", "fourteen", "fifteen"]:
    df['Game'] = df['Game'].apply(lambda x: x.replace(i, f"win_in_more_than_teen"))
for i in ["ten", "six", "seven", "eight", "nine"]:
    df['Game'] = df['Game'].apply(lambda x: x.replace(i, "win_in_ten"))
for i in ["five", "one", "two", "three", "four"]:
    df['Game'] = df['Game'].apply(lambda x: x.replace(i, "win_in_five"))

transactions_sets = [
    {f"{col}={val}" for col, val in zip(df.columns, row)}
    for row in df.to_numpy()
]
transactions = [list(s) for s in transactions_sets]

min_support = 0.1
min_confidence = 0.5

apriori = CustomApriori(min_support=min_support, min_confidence=min_confidence)

start = time.time()

frequent_itemsets = apriori.find_frequent_itemsets(transactions, transactions_sets)
rules = apriori.generate_rules(frequent_itemsets)

duration = time.time() - start

print("\n" + "="*50)
print(f"{'RAPORT ANALIZY ASOCJACJI':^50}")
print("="*50)

print(f"\n[1] KONFIGURACJA I WYDAJNOŚĆ")
print(f"  • Wsparcie (min_supp):   {min_support:<10} |  Czas: {duration:.4f}s")
print(f"  • Ufność (min_conf):     {min_confidence:<10} |  Zbiory: {len(frequent_itemsets)}")
print(f"  • Maks. rozmiar zbioru:  {apriori.stats['max_itemset_size']:<10} |  Kandydaci: {apriori.stats['total_candidates']}")

print(f"\n[2] TOP 10 NAJCZĘSTSZYCH ZBIORÓW")
print(f"  {'Zbiór':<50} | {'Wsparcie':<10}")
print(f"  {'-'*50}-+-{'-'*10}")

sorted_itemsets = sorted(frequent_itemsets.items(), key=lambda x: x[1], reverse=True)
for itemset, support in sorted_itemsets[:10]:
    items_str = ", ".join(list(itemset))
    print(f"  {items_str:<50} | {support:.3f}")

print(f"\n[3] TOP 10 REGUŁ (WEDŁUG WSKAŹNIKA LIFT)")
header = f"{'Lp.':<3} {'Reguła':<40} | {'Supp':<5} | {'Conf':<5} | {'Lift':<5}"
print(f"  {header}")
print(f"  {'-' * 45}+{'-' * 7}+{'-' * 7}+{'-' * 7}")

for i, rule in enumerate(rules[:10], 1):
    ant = ", ".join(rule['antecedent'])
    cons = ", ".join(rule['consequent'])
    rule_str = f"{ant} -> {cons}"

    if len(rule_str) > 38:
        rule_str = rule_str[:35] + "..."

    print(f"  {i:>2}. {rule_str:<40} | {rule['support']:.3f} | {rule['confidence']:.3f} | {rule['lift']:.3f}")

print("\n" + "="*50)

# ==========================================
# Parallel Categories Diagram
# ==========================================

df_temp = df[['White_king_col', 'White_king_row', 'White_rook_col', 'White_rook_row', 'Black_king_col', 'Black_king_row', 'Game']].copy()
df_temp['win_code'] = df_temp['Game'].map({'win': 0, 'win_in_more_than_teen': 1, 'win_in_ten': 2, 'win_in_five': 3, 'draw': 4})

# template - full diagram
# fig1 = px.parallel_categories(
#     df_temp,
#     dimensions=['White_king_col', 'White_king_row', 'White_rook_col', 'White_rook_row', 'Black_king_col', 'Black_king_row', 'Game'],
#     color='win_code',
#     color_continuous_scale=px.colors.sequential.Viridis,
#     labels={
#         'White_king_col': 'Kolumna białego króla',
#         'White_king_row': 'Rząd białego króla',
#         'White_rook_col': 'Kolumna białej wieży',
#         'White_rook_row': 'Rząd białej wieży',
#         'Black_king_col': 'Kolumna czarnego króla',
#         'Black_king_row': 'Rząd czarnego króla',
#         'Game': 'Wynik gry'
#     },
#     title='Diagram Równoległych Kategorii dla pozycji końcowych Król i Wieża vs Król'
# )

# fig1.update_layout(
#     font=dict(size=11),
#     title_font_size=16,
#     coloraxis_colorbar=dict(title='Wynik gry', tickvals=[0, 1, 2, 3, 4], ticktext=['Wygrana', 'Wygrana >10', 'Wygrana ≤10', 'Wygrana ≤5', 'Remis'])
# )

# fig1.show()
fig1 = px.parallel_categories(
    df_temp,
    dimensions=['White_king_col', 'White_king_row', 'Game'],
    color='win_code',
    color_continuous_scale=px.colors.sequential.Viridis,
    labels={
        'White_king_col': 'Kolumna białego króla',
        'White_king_row': 'Rząd białego króla',
        'White_rook_col': 'Kolumna białej wieży',
        'White_rook_row': 'Rząd białej wieży',
        'Black_king_col': 'Kolumna czarnego króla',
        'Black_king_row': 'Rząd czarnego króla',
        'Game': 'Wynik gry'
    },
    title='Diagram Równoległych Kategorii dla pozycji końcowych Król i Wieża vs Król'
)

fig1.update_layout(
    font=dict(size=11),
    title_font_size=16,
    coloraxis_colorbar=dict(title='Wynik gry', tickvals=[0, 1, 2, 3, 4], ticktext=['Wygrana', 'Wygrana >10', 'Wygrana ≤10', 'Wygrana ≤5', 'Remis'])
)

fig1.show()
fig1 = px.parallel_categories(
    df_temp,
    dimensions=['Black_king_col', 'Black_king_row', 'Game'],
    color='win_code',
    color_continuous_scale=px.colors.sequential.Viridis,
    labels={
        'White_king_col': 'Kolumna białego króla',
        'White_king_row': 'Rząd białego króla',
        'White_rook_col': 'Kolumna białej wieży',
        'White_rook_row': 'Rząd białej wieży',
        'Black_king_col': 'Kolumna czarnego króla',
        'Black_king_row': 'Rząd czarnego króla',
        'Game': 'Wynik gry'
    },
    title='Diagram Równoległych Kategorii dla pozycji końcowych Król i Wieża vs Król'
)

fig1.update_layout(
    font=dict(size=11),
    title_font_size=16,
    coloraxis_colorbar=dict(title='Wynik gry', tickvals=[0, 1, 2, 3, 4], ticktext=['Wygrana', 'Wygrana >10', 'Wygrana ≤10', 'Wygrana ≤5', 'Remis'])
)

fig1.show()
fig1 = px.parallel_categories(
    df_temp,
    dimensions=['White_rook_col', 'White_rook_row', 'Game'],
    color='win_code',
    color_continuous_scale=px.colors.sequential.Viridis,
    labels={
        'White_king_col': 'Kolumna białego króla',
        'White_king_row': 'Rząd białego króla',
        'White_rook_col': 'Kolumna białej wieży',
        'White_rook_row': 'Rząd białej wieży',
        'Black_king_col': 'Kolumna czarnego króla',
        'Black_king_row': 'Rząd czarnego króla',
        'Game': 'Wynik gry'
    },
    title='Diagram Równoległych Kategorii dla pozycji końcowych Król i Wieża vs Król'
)

fig1.update_layout(
    font=dict(size=11),
    title_font_size=16,
    coloraxis_colorbar=dict(title='Wynik gry', tickvals=[0, 1, 2, 3, 4], ticktext=['Wygrana', 'Wygrana >10', 'Wygrana ≤10', 'Wygrana ≤5', 'Remis'])
)

fig1.show()

# ==========================================
# Wykresy zależności wydajności
# ==========================================

support_levels = np.linspace(0.05, 0.50, 39)

res_w_pruning = []
res_wo_pruning = []

for s in support_levels:
    test_model = CustomApriori(min_support=s, min_confidence=0.5, with_pruning=True)
    start = time.time()
    res = test_model.find_frequent_itemsets(transactions, transactions_sets)
    duration = time.time() - start

    res_w_pruning.append([
        s,
        duration,
        test_model.stats['total_candidates'],
        test_model.stats['frequent_itemsets_count'],
        test_model.stats['max_itemset_size']
    ])

    test_model = CustomApriori(min_support=s, min_confidence=0.5, with_pruning=False)
    start = time.time()
    res = test_model.find_frequent_itemsets(transactions, transactions_sets)
    duration = time.time() - start

    res_wo_pruning.append([
        s,
        duration,
        test_model.stats['total_candidates'],
        test_model.stats['frequent_itemsets_count'],
        test_model.stats['max_itemset_size']
    ])

with_df = pd.DataFrame(res_w_pruning, columns=['support', 'time', 'total_candidates', 'frequent_count', 'max_k'])
without_df = pd.DataFrame(res_wo_pruning, columns=['support', 'time', 'total_candidates', 'frequent_count', 'max_k'])

# G===== Wykresy =====
fig_c, axs = plt.subplots(2, 2, figsize=(14, 10))
fig_c.suptitle('Analiza algorytmu Apriori - Wpływ Supportu', fontsize=16)

# 1. Czas działania
axs[0, 0].plot(with_df['support'], with_df['time'], 'r-o', label='/w pruning')
axs[0, 0].plot(without_df['support'], without_df['time'], 'b-s', label='/wo pruning')
axs[0, 0].legend()
axs[0, 0].set_title('Czas działania algorytmu')
axs[0, 0].set_ylabel('Sekundy')

# 2. Kandydaci (Pruning vs No-Pruning)
axs[0, 1].plot(with_df['support'], with_df['total_candidates'], 'r-o', label='/w pruning')
axs[0, 1].plot(without_df['support'], without_df['total_candidates'], 'b-s', label='/wo pruning')
axs[0, 1].set_title('Łączna liczba kandydatów')
axs[0, 1].legend()

# 3. Liczba częstych zestawów
axs[1, 0].plot(with_df['support'], with_df['frequent_count'], 'r-o', label='/w pruning')
axs[1, 0].plot(without_df['support'], without_df['frequent_count'], 'b-s', label='/wo pruning')
axs[1, 0].legend()
axs[1, 0].set_title('Liczba zestawów częstych')

# 4. Maksymalny rozmiar
axs[1, 1].plot(with_df['support'], with_df['max_k'], 'r-o', label='/w pruning')
axs[1, 1].plot(without_df['support'], without_df['max_k'], 'b-s', label='/wo pruning')
axs[1, 1].legend()
axs[1, 1].set_title('Maksymalny rozmiar zbioru (k)')

for ax in axs.flat:
    ax.set_xlabel('Min Support')
    ax.invert_xaxis()
    ax.grid(True, alpha=0.3)

plt.tight_layout(rect=[0, 0.03, 1, 0.95])
plt.savefig('plots/ex16_apriori_analysis.png')
