
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
                label = "Optionally enter the chromosome name for which you would like to see results (1-22, X, Y):"),
      selectInput(inputId = "reference_genome",
                label = "Enter the name of the reference genome to be used for annotating the CNVs with genes.
                This should match the genome that was used for CNV calling:",
                choices = c("GRCh38", "GRCh37")),

      br(),
      tags$p("Select parameters for wordcloud of associated diseases:"),

      numericInput(inputId = "remove_most_freq",
                label = "Optionally enter the number of top terms to remove from the wordcloud.
                This should be a positive integer:"),

      # vertical spacing
      br(),

      # actionButton
      actionButton(inputId = "run_button",
                   label = "Run"),

    ),



    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Tabset w/ plot, summary, and table ----
      tabsetPanel(type = "top_tabs",
                  tabPanel("Plot of CNV size distribution",
                           h3("Instructions: Enter values and click 'View Summary' at the bottom left side."),
                           br(),
                           plotOutput("plotCNVsize")),
                  tabPanel("Piechart: Genic vs Non-Genic CNVs",
                           h3("Instructions: Enter values and click 'Run' at the bottom left side."),
                           br(),
                           plotOutput("plotCNVgeneImpact")),
                  tabPanel("Disease Wordcloud",
                           h3("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Wordcloud of genes frequently associated with the genes found in CNVs:"),
                           br(),
                           br(),
                           plotOutput("diseaseWordcloud")),
                  tabPanel("Gene Wordcloud",
                           h3("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Wordcloud of genes found in CNVs that are frequently associated with psychiatric diseases:"),
                           br(),
                           br(),
                           plotOutput("geneWordcloud"))
      ),

      tabsetPanel(type = "bottom_tabs",
                  tabPanel("List of genes encompassed by CNVs",
                           h3("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Genes encompassed by input CNVs:"),
                           br(),
                           uiOutput("gene_list")),
                  tabPanel("Gene-Disease Association Table",
                           h3("Instructions: Enter values and click 'Run' at the bottom left side."),
                           h3("Table of gene-disease associations:"),
                           br(),
                           tableOutput("diseaseAssocTbl"))
      )

    )
  )
)


# Define server logic
server <- function(input, output) {

  # Save input csv as a reactive
  matrixInput <- eventReactive(eventExpr = input$run_button, {
    if (! is.null(input$input_file))
      as.data.frame(read.csv(input$input_file$datapath,
                             sep = ",",
                             header = TRUE,
                             row.names = 1))
  })


  # return CNV table and input chromosome number
  startSummaryPlot <- eventReactive(eventExpr = input$view_summary_button, {
    if(! is.null(matrixInput())){
      return(list(CNV_call = matrixInput(), chromosome_number = input$chromosome_number))
    }
  })

  # prepare data: gene list, total CNV count, and genic CNV count
  startAnalysis <- eventReactive(eventExpr = input$run_button, {

    psychCNVassoc::getCNVgenes(
      CNV_call = matrixInput(),
      chromosome_number = as.character(input$chromosome_number),
      reference_genome = as.character(input$referennce_genome)
    )

  })

  # prepare data: gene-disease association table
  startDiseaseAssoc <- reactive({
    if (! is.null(startAnalysis())) {
      diseaseAssocResult <- psychCNVassoc::getDiseaseAssoc(gene_list = startAnalysis()$gene_list)
      return(getDiseaseAssocResult)
    }
  })



  # Plotting CNV size distribution
  output$plotCNVsize <- renderPlot({
    if (! is.null(startSummaryPlot)){
      psychCNVassoc::plotCNVsize(CNV_call =  startSummaryPlot()$CNV_call,
                                 chromosome_number = startSummaryPlot()$chromosome_number)
    }
  })


  # Plotting CNV gene impact (genic vs. non-genic)
  output$plotCNVGeneImpact <- renderPlot({
    if (! is.null(startAnalysis)) {
      psychCNVassoc::plotCNVsize(genic_CNV_count = startAnalysis()$count_genic_CNV,
                                 total_CNV_count = startAnalysis()$count_CNV)
    }
  })

  # Output raw list of genes
  output$gene_list <- renderUI({
    if (! is.null(startAnalysis)) {
      listItems <- startAnalysis()$gene_list

      ul(
        lapply(listItems, function(item) {
          li(item)
        })
      )
    }
  })

  # output raw gene-disease association table
  output$diseaseAssocTbl <- renderTable({
    if (! is.null(startDiseaseAssoc())) {
      startDiseaseAssoc()
    }
  })

  # Plot wordcloud of diseases
  output$diseaseWordcloud <- renderPlot({
    if (! is.null(startDiseaseAssoc())) {
      psychCNVassoc::plotDiseaseCloud(disease_assoc_tbl = startDiseaseAssoc())
    }
  })

  # Plot wordcloud of genes
  output$geneWordcloud <- renderPlot({
    if (! is.null(startDiseaseAssoc())) {
      psychCNVassoc::plotGeneCloud(disease_assoc_tbl = startDiseaseAssoc())
    }
  })


}

# Create Shiny app
shiny::shinyApp(ui, server)

# [END]
