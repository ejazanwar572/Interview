import re

def count_word_frequency(paragraph):
    # Convert to lowercase and remove punctuation
    cleaned_paragraph = re.sub(r'[^\w\s]', '', paragraph.lower())
    words = cleaned_paragraph.split()
    
    # Create a dictionary to store word frequencies
    word_freq = {}
    for word in words:
        if word in word_freq:
            word_freq[word] += 1
        else:
            word_freq[word] = 1
    
    return word_freq

paragraph = "Data engineer works with data. Data is important."
print(count_word_frequency(paragraph))