
library(shiny)
library(shinyalert)

# Define UI
ui <- fluidPage(

  # Change title
  titlePanel("Disease Association Analysis of Copy Number Variants"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      tags$b("Description: TestingPackage is an R package to ..."),

      # vertical spacing
      br(),
      br(),

      # instructions
      tags$p("Instructions: Below, enter or select values required to perform the analysis. Default
             values are shown. Then press 'Run'. Navigate through
             the different tabs to the right to explore the results.
             PLEASE NOTE: running might take long. See raw output in the bottom tabs and visualizations in the top tabs."),

      # vertical spacing
      br(),


      # input
      shinyalert::useShinyalert(force = TRUE),  # Set up shinyalert

      fileInput(inputId = "input_file",
                label = " TELL USER THEY CAN FIND IT ON GITHUB INST/EXTDATA
                Select a CNV call dataset to visualize. File should be in .csv format with rows corresponding to CNVs and columns to chromosome number, start position, end position, and type.",
                accept = c(".csv")),
      actionButton(inputId = "view_summary_button",
                   label = "View Summary"),

      tags$p("Select parameters for annotating CNVs with genes:"),

      textInput(inputId = "chromosome_number",
                label = "Optionally enter the chromosome name for which you would like to see results (1-22, X, Y):",
                value = NULL),
      selectInput(inputId = "reference_genome",
                label = "Enter the name of the reference genome to be used for annotating the CNVs with genes.
                This should match the genome that was used for CNV calling:",
                choices = c("GRCh38", "GRCh37")),

      br(),
      tags$p("Select parameters for wordcloud of associated diseases:"),

      numericInput(inputId = "remove_most_freq",
                label = "Optionally enter the number of top terms to remove from the wordcloud.
                This should be a positive integer:",
                0),

      # vertical spacing
      br(),

      # actionButton

      actionButton(inputId = "other_button",
                   label = "Run")

    ),



    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "tabs",
                  tabPanel("Plot of CNV size distribution",
                           p("Instructions: Enter values and click 'View Summary' at the bottom left side."),
                           br(),
                           plotOutput("plotCNVsize")),
                  tabPanel("Piechart: Genic vs Non-Genic CNVs",
                           p("Instructions: Enter values and click 'Run' at the bottom left side."),
                           br(),
                           plotOutput("plotCNVgeneImpact")),
                  tabPanel("Disease Wordcloud",
                           p("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Wordcloud of genes frequently associated with the genes found in CNVs:"),
                           br(),
                           br(),
                           wordcloud2Output("diseaseWordcloud")),
                  tabPanel("Gene Wordcloud",
                           p("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Wordcloud of genes found in CNVs that are frequently associated with psychiatric diseases:"),
                           br(),
                           br(),
                           wordcloud2Output("geneWordcloud"))
      ),
      br(),
      br(),

      tabsetPanel(type = "tabs",
                  tabPanel("List of genes encompassed by CNVs",
                           p("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Raw list of genes encompassed by input CNVs:"),
                           br(),
                           DT::dataTableOutput("gene_list")),
                  tabPanel("Gene-Disease Association Table",
                           p("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Raw table of gene-disease associations:"),
                           br(),
                           DT::dataTableOutput("diseaseAssocTbl"))
      )

    )
  )
)


# Define server logic
server <- function(input, output) {

  # Save input csv as a reactive
  viewMatrixInput <- eventReactive(eventExpr = input$view_summary_button, {
    if (! is.null(input$input_file)){
      input_file_df <- as.data.frame(read.csv(input$input_file$datapath,
                                              sep = ",",
                                              header = TRUE,
                                              row.names = NULL))
      return(input_file_df)
    }
  })

  # return CNV table and input chromosome number
  startSummaryPlot <- eventReactive(eventExpr = input$view_summary_button, {
    if (! is.null(viewMatrixInput())){
      if (is.null(input$chromosome_number) || input$chromosome_number == ""){
        chrom_num <- NULL
      } else {
        chrom_num <- input$chromosome_number
      }
      return(list(CNV_call = viewMatrixInput(), chromosome_number = chrom_num))
    }
  })

  # Plotting CNV size distribution
  output$plotCNVsize <- renderPlot({
    if (! is.null(startSummaryPlot())){
      psychCNVassoc::plotCNVsize(CNV_call =  startSummaryPlot()$CNV_call,
                                 chromosome_number = startSummaryPlot()$chromosome_number)
    }
  })


  # Save input csv as a reactive
  analyzeMatrixInput <- eventReactive(eventExpr = input$other_button, {
    if (! is.null(input$input_file)){
      input_file_df2 <- as.data.frame(read.csv(input$input_file$datapath,
                                              sep = ",",
                                              header = TRUE,
                                              row.names = NULL))
      return(input_file_df2)
    }
  })

  # prepare data: gene list, total CNV count, and genic CNV count
  startAnalysis <- eventReactive(eventExpr = input$other_button, {
    if (! is.null(analyzeMatrixInput())){
      if (is.null(input$chromosome_number) || input$chromosome_number == ""){
        chrom_num <- NULL
      } else {
        chrom_num <- as.character(input$chromosome_number)
      }
      result <- psychCNVassoc::getCNVgenes(
        CNV_call = analyzeMatrixInput(),
        chromosome_number = chrom_num,
        reference_genome = as.character(input$reference_genome)
      )
      return(result)
    }
  })

  # Plotting CNV gene impact (genic vs. non-genic)
  output$plotCNVgeneImpact <- renderPlot({
    if (! is.null(startAnalysis())){
      if (is.null(input$chromosome_number) || input$chromosome_number == ""){
        chrom_num <- NULL
      } else {
        chrom_num <- as.character(input$chromosome_number)
      }
      psychCNVassoc::getCNVgenes(
        CNV_call = analyzeMatrixInput(),
        chromosome_number = chrom_num,
        reference_genome = as.character(input$reference_genome),
        show_piechart = TRUE
      )
    }
  })


  # Output raw list of genes
  output$gene_list <- DT::renderDT(DT::datatable({
    if (! is.null(startAnalysis())) {
      df <- data.frame("Genes" = startAnalysis()[[1]])
      names(df) <- "Genes"
      return(df)
    }
  }, options = list(pageLength = 50)))

  # prepare data: gene-disease association table
  startDiseaseAssoc <- reactive({
    if (! is.null(startAnalysis())) {
      diseaseAssocResult <- psychCNVassoc::getDiseaseAssoc(gene_list = startAnalysis()[[1]])
      return(diseaseAssocResult)
    }
  })

  # output raw gene-disease association table
  output$diseaseAssocTbl <- DT::renderDT(DT::datatable({
    if (! is.null(startDiseaseAssoc())) {
      gda_df <- as.data.frame(startDiseaseAssoc())
      return(gda_df)
    }
  }, options = list(pageLength = 50)))

  # Plot wordcloud of diseases
  output$diseaseWordcloud <- renderWordcloud2({
    if (! is.null(startDiseaseAssoc())) {
      wc_output <- psychCNVassoc::plotDiseaseCloud(disease_assoc_tbl = as.data.frame(startDiseaseAssoc()),
                                                   remove_most_freq = input$remove_most_freq)
      d_word_freq <- wc_output$word_freq_df
      if(nrow(d_word_freq) > 0){
        wordcloud2::wordcloud2(d_word_freq[ , c("word", "log_freq")], size = 0.3)
      }
    }
  })


  # Plot wordcloud of genes
  output$geneWordcloud <- renderWordcloud2({
    if (! is.null(startDiseaseAssoc())) {
      wc2_output <- psychCNVassoc::plotGeneCloud(disease_assoc_tbl = as.data.frame(startDiseaseAssoc()))
      g_word_freq <- wc2_output$word_freq_df
      if(nrow(g_word_freq) > 0){
        wordcloud2::wordcloud2(g_word_freq[ , c("word", "log_freq")], size = 0.3)
      }
    }
  })


}

# Create Shiny app
shiny::shinyApp(ui, server)

# [END]
