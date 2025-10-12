def tf(word, document):
    return document.count(word)

def idf(word, book):
    import math
    num_documents_with_word = sum(1 for doc in book if word in doc)
    return math.log(len(book) / (1 + num_documents_with_word))

def zad7(word, documents, book):
    chapters_weights = []
    for document in documents:
        weight = tf(word, document) * idf(word, book)
        chapters_weights.append(weight)
    chapters_weights.sort(reverse=True)
    return chapters_weights
