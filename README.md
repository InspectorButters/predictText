# predictText Application
This app prompts a user to type a word or phrase and then predicts (1) the next word and (if necessary, 2) autocompletion of incomplete words https://herget.shinyapps.io/textprediction/ ; a brief presentation of the application is available at http://rpubs.com/rbherget/277680 . 

The predictText application allows the user to type in phrases, then seeks to (1) predict the next word  and (2) if applicable, autocomplete an unfinished word.  These outputs are discussed in greater detail below.

The following paragraphs discuss the application development process, including data characteristics, corpus creation and model selection.

# Data Overview 
Data for this project provided by SwiftKey via Coursera, and is available for download at: https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip .

Included in the data are 12 txt files: Three distinct source types (news, blogs and twitter) in four distinct languages (German, English, Finnish and Russian). For this project, only the three English files are used.

# Loading, Cleanup & Reading into R 
The large size and nature of these files created challenges when reading into R. Notable difficulty was encountered when reading the “news” file into R. Using the readLines function alone was unable to overcome missing end-of-line (EOL) markers that plagued that document. To handle this missing EOL problem, we read the document through opening a connection (con). Though not necessary, this
technique is applied to the other two documents (blogs and twitter) for consistency.
 
# Corpus Creation & Tokenization 
tba

# Modeling 


This application uses an n-gram, which offers benefits of simplicity and scalability.  Specifically, the Katz backoff model variant, which estimates conditional probability of a word given its history in the n-gram, is the basis of the selection algorithm. With user experience in mind, this method allows for reduced app size resulting in a fairly fast runtime.

