# predictText Application
The predictText application prompts a user to type a word or phrase and then predicts (1) the next word and (if necessary, 2) autocompletion of incomplete words https://herget.shinyapps.io/textprediction/ ; a brief presentation of the application is available at http://rpubs.com/rbherget/277680 . 

The following paragraphs discuss the application development process, including data characteristics, corpus creation and model selection.

# Data Overview 
Data for this project provided by SwiftKey via Coursera, and is available for download at: https://d396qusza40orc.cloudfront.net/dsscapstone/dataset/Coursera-SwiftKey.zip .

Included in the data are 12 txt files: Three distinct source types (news, blogs and twitter) in four distinct languages (German, English, Finnish and Russian). For this project, only the three English files are used.

# Loading, Cleanup & Reading into R 
The large size and nature of these files created challenges when reading into R. Notable difficulty was encountered when reading the “news” file into R. Using the readLines function alone was unable to overcome missing end-of-line (EOL) markers that plagued that document. To handle this missing EOL problem, we read the document through opening a connection (con). Though not necessary, this
technique is applied to the other two documents (blogs and twitter) for consistency.
 
# Corpus Creation & Tokenization 
To create the corpus we leverage the text mining (tm) package. A master corpus will be created by combining samples from the blogs, news and twitter files.

A note on sample size: memory and processing considerations are important at this step. Depending on your system and processing capabilities, you may have to iteratively test sample sizes until a “cannot allocate size of (certain amount)” error messages are overcome. Once a proper sample size is reached, samples are collected from each of the blogs, news and Twitter files and combined into a single sample corpus.

This sample corpus is further polished with the following edits:
- removal of URLs
- removal of special characters (e.g.,@,[,^,\s]+)
- conversion to all lowercase
- removal of punctuation
- removal of numbers
- stripping of excess white space
- formatting to plain text document

# Modeling & Algorithm Overview
This application uses an n-gram, which offers benefits of simplicity and scalability.  Specifically, the Katz backoff model variant, which estimates conditional probability of a word given its history in the n-gram, is the basis of the selection algorithm. With user experience in mind, this method allows for reduced app size resulting in a fairly fast runtime.

The algorithm in the app reads the text input and predicts the next word. Iteratively reading from the longest 5-gram to the shortest 2-gram, predicts the longest, most frequent, n-gram. In cases where no match is found, the algorithm randomly selects the "most-likely" word.
