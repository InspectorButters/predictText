library(shiny)

shinyUI(fluidPage(
  navbarPage("predictText",
             tabPanel("Home",
                      sidebarLayout(
                        sidebarPanel(
                          h4('Input Text:'), 
                          tags$textarea(id="text_in", rows=2, cols=30),
                          
                          HTML("<br><br>"),
                          
                          radioButtons("suggestions", label = h4("Number of Predictions:"),
                                       choices = list("1 Word" = 1, 
                                                      "2 Words" = 2,
                                                      "3 Words" = 3,
                                                      "4 Words" = 4,
                                                      "5 Words" = 5))),
                        mainPanel(
                          h4("Next Word"),
                          verbatimTextOutput('word.next'),
                          HTML("<br>"),
                          h4("Word Autocomplete"),
                          verbatimTextOutput('word.current')
                        )
                      )
             ),
             tabPanel("About",
                      mainPanel(
                          h4("Instructions"),
                              HTML("<br>"),
                              HTML("<b>Input Text</b>: Enter the word or phrase for which the subsequent word is predicted."),
                              HTML("<b>Number of Predictions</b>: Select the maximum number of possible next words to be predicted."),
                              HTML("<br><br>"),
                              HTML("From these two inputs, <i>Next Word</i> and <i>Autocomplete</i> outputs are generated."),
                              HTML("<br><br>"),
                          
                          h4("Source Code"),
                              HTML("<br>"),
                              HTML("The source code, along with detail explainations of the code, is available at https://github.com/InspectorButters/predictText")
                          
                      )
             )
  )
))

