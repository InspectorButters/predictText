# predictText Application
This app prompts a user to type a word or phrase and then predicts (1) the next word and (if necessary, 2) autocompletion of incomplete words https://herget.shinyapps.io/textprediction/ ; a brief presentation of the application is available at http://rpubs.com/rbherget/277680 . 

The predictText app...

# Data Overview 
tba
 
# Corpus Creation & Tokenization 
tba

# Modeling 


This application uses an n-gram, which offers benefits of simplicity and scalability.  Specifically, the Katz backoff model variant, which estimates conditional probability of a word given its history in the n-gram, is the basis of the selection algorithm. With user experience in mind, this method allows for reduced app size resulting in a fairly fast runtime.

