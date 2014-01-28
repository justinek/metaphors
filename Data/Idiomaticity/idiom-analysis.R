ngrams <- read.csv("animal-words-counts-clean.csv")
ngrams$prob <- ngrams$is_a_frequency / ngrams$frequency
ngrams <- ngrams[with(ngrams, order(-prob)), ]
#ngrams <- ngrams[with(ngrams, order(-is_a_frequency)), ]
