
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

      # br() element to introduce extra vertical spacing ----
      br(),
      br(),

      # input
      tags$p("Instructions: Below, enter or select values required to perform the analysis. Default
             values are shown. Then press 'Run'. Navigate through
             the different tabs to the right to explore the results.
             PLEASE NOTE: running might take long. See raw output in the bottom tabs and visualizations in the top tabs."),

      # br() element to introduce extra vertical spacing ----
      br(),


      # input
      shinyalert::useShinyalert(force = TRUE),  # Set up shinyalert
      uiOutput("tab2"),
      actionButton(inputId = "sample_data1",
                   label = "Dataset 1 Details"),
      uiOutput("tab1"),
      actionButton(inputId = "sample_data2",
                   label = "Dataset 2 Details"),
      fileInput(inputId = "file1",
                label = "Select a CNV call dataset to visualize. File should be in .csv format with rows corresponding to CNVs and columns to chromosome number, start position, end position, and type.",
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

      # br() element to introduce extra vertical spacing ----
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
    if (! is.null(input$file1))
      as.data.frame(read.csv(input$file1$datapath,
                             sep = ",",
                             header = TRUE,
                             row.names = 1))
  })

  # Calculate information criteria value
  startcalculation <- eventReactive(eventExpr = input$run_button, {

    TestingPackage::InfCriteriaCalculation(
      loglikelihood = as.numeric(input$logL),
      nClusters = as.numeric(input$nClusters),
      dimensionality = as.numeric(input$dimensionality),
      observations = as.numeric(input$observations),
      probability = as.numeric(unlist(strsplit(input$probability, ","))))

  })



  # Plotting CNV size distribution
  output$plotCNVsize <- renderPlot({
    if (! is.null(startcalculation))
      psychCNVassoc::plotCNVsize(CNV_call =  temp, chromosome_number = temp)
  })


  # Plotting RNAseq dataset
  output$plotCNVGeneImpact <- renderPlot({
    if (! is.null(startcalculation)) {
      psychCNVassoc::plotCNVsize(genic_CNV_count =  temp, total_CNV_count = temp)
    }
  })

  output$gene_list <- renderUI({
    if (! is.null(startcalculation)) {
      # Example list items
      listItems <- psychCNVassoc::getCNVgenes(CNV_call = temp, chromosome_number = temp, reference_genome = temp, show_piechart = FALSE)

      # Create an unordered list
      ul(
        lapply(listItems, function(item) {
          li(item)
        })
      )
    }
  })

  output$diseaseAssocTbl <- renderTable({
    psychCNVassoc::getDiseaseAssoc(gene_list = temp)
  })


  # URLs for downloading data
  url1 <- a("Example Dataset 2", href="https://raw.githubusercontent.com/anjalisilva/TestingPackage/master/inst/extdata/GeneCountsData2.csv")
  output$tab1 <- renderUI({
    tagList("Download:", url1)
  })

  observeEvent(input$data2, {
    # Show a modal when the button is pressed
    shinyalert(title = "Example Dataset 2",
               text = "An RNAseq experiment conductd using bean plants from 2016 in Canada. This dataset has n = 30 genes along rows and d = 3 conditions or samples along columns. Data was generated at the University of Guelph, Canada in 2016. To save the file (from Chrome), click on link, then right click, select 'Save As...' and then save as a .csv file.
               Citation: Silva, A. (2020) TestingPackage: An Example R Package For BCB410H. Unpublished. URL https://github.com/anjalisilva/TestingPackage",
               type = "info")
  })

  url2 <- a("Example Dataset 1", href="https://drive.google.com/file/d/1jMBTPpsBwaigjR3mO49AMYDxzjVnNiAv/view?usp=sharing")
  output$tab2 <- renderUI({
    tagList("Download:", url2)
  })

  observeEvent(input$data1, {
    # Show a modal when the button is pressed
    shinyalert(title = "Example Dataset 1",
               text = "This is a simulated dataset generated from mixtures of multivariate Poisson log-normal
               distributions with G = 2 components. It has a size of n = 1000 observations along rows and d = 6
               samples along columns. Data was generated January, 2022. To save the file, click on link, then click 'Download' from the top right side.
               Citation: Silva, A., S. J. Rothstein, P. D. McNicholas, and S. Subedi (2019). A multivariate Poisson-log normal
               mixture model for clustering transcriptome sequencing data. BMC Bioinformatics. 2019;20(1):394. URL https://pubmed.ncbi.nlm.nih.gov/31311497/",
               type = "info")
  })


}

# Create Shiny app
shiny::shinyApp(ui, server)

# [END]
