def tf(word, document):
    return document.count(word)

def idf(word, book):
    import math
    num_documents_with_word = sum(1 for doc in book if word in doc)
    return math.log(len(book) / (1 + num_documents_with_word))

def zad7(word, documents):
    chapters_weights = []
    for i, document in enumerate(documents):
        weight = tf(word, document) * idf(word, documents)
        chapters_weights.append((i, weight))
    chapters_weights.sort(key=lambda pair: pair[1], reverse=True)
    return chapters_weights