
library(shiny)
library(shinyalert)
library(DT)

# Define UI
ui <- fluidPage(

  # Change title
  titlePanel("Disease Association Analysis of Copy Number Variants"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # vertical spacing
      br(),
      br(),

      # instructions
      tags$p("Instructions: Below, upload a CNV dataset, and enter or select values required to perform the analysis.
              Default values are shown. Then press 'Run'. Navigate through
              the different tabs to the right to explore the results."),

      # vertical spacing
      br(),


      # input
      shinyalert::useShinyalert(force = TRUE),  # Set up shinyalert

      fileInput(inputId = "input_file",
                label = "Dataset:",
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
                  tabPanel("About",
                           h2("Description"),
                           p("This is a Shiny App that is part of the psychCNVassoc R package (Uzelac, 2023). psychCNVassoc is an R package developed to streamline preliminary exploratory analysis in
                             psychiatric genetics. It takes human Copy Number Variant (CNV) data as input, identifies genes
                             encompassed by these CNVs, and associates them with psychiatric disorders from the PsyGeNet database.
                             It is intended for investigating how CNVs affect gene expression levels and to see
                             whether the change in copy number of certain genes affect crucial pathways involved in psychiatric
                             disease comorbidities."),
                           br(),
                           h2("Instructions"),
                           h3("Input File"),
                           p("Select a CNV call dataset to visualize. File should be in .csv format with rows corresponding to CNVs and columns to
                              chromosome number, start position, end position, and type. Two example datasets are available for download on the package
                             GitHub in the subdirectory inst/extdata. Follow the provided link to download the datasets: "),
                           a("https://github.com/angelauzelac10/psychCNVassoc/tree/master/inst/extdata", href = "https://github.com/angelauzelac10/psychCNVassoc/tree/master/inst/extdata"),
                           br(),
                           br(),
                           actionButton(inputId = "ds1_details",
                                        label = "sample_CNV_call.csv Details"),
                           actionButton(inputId = "ds2_details",
                                        label = "large_CNV_call.csv Details"),
                           br(),
                           br(),
                           h3("Summary plot"),
                           p("Click on 'View Summary' then on the 'Plot of CNV size distribution' tab to vizualize the size distribution of the CNVs
                           from the input data."),
                           br(),
                           h3("Run the Analysis"),
                           p("Optionally, input values for the chromosome number for which to get the gene list, the reference genome to use for gene annotation,
                             and the number of top terms to be remove from the resulting wordcloud of associated diseases. Then, click 'Run' in the bottom right corner
                             of the sidebar to begin the analysis."),
                           strong("Gene list results"),
                           p("Click on the 'List of genes encompassed by CNVs' tab to view a raw list of genes that are encompassed by the CNVs from the input data,
                             and click on the 'Piechart: Genic vs Non-Genic CNVs' tab to view the number of genic and non-genic CNVs in the dataset."),
                           strong("Disease Association Results"),
                           p("Click on the 'Gene-Disease Association Table' tab to view a raw table of gene-disease associations of genes that have a change in copy
                             number, and click on the 'Disease Wordcloud' or 'Gene Wordcloud' tabs to view which diseases and genes are frequently observed in this table."),
                           br(),
                           h2("Important Note"),
                           p("This package makes use of external packages and therefore will take longer than expected to run. When clicking on each tab,
                             please expect to wait for results to load. The package also requires a stable internet connection as it utilizes the Ensembl
                             website. Occasionally, the Ensembl site is unresponsive and users will not be able to obtain results at this time. In this case,
                             please consider trying again later, or please visit the link below to verify the status of the site:"),
                           a("Ensembl BioMart", href = "https://useast.ensembl.org/info/data/biomart/index.html")
                           ),
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
      df <- data.frame("Genes" = startAnalysis()$gene_list)
      names(df) <- "Genes"
      return(df)
    }
  }, options = list(pageLength = 50)))

  # prepare data: gene-disease association table
  startDiseaseAssoc <- reactive({
    if (! is.null(startAnalysis())) {
      diseaseAssocResult <- psychCNVassoc::getDiseaseAssoc(gene_list = startAnalysis()$gene_list)
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

  observeEvent(input$ds1_details, {
    # Show a modal when the button is pressed
    shinyalert(title = "Small Sample CNV Call Dataset",
               text = "A data frame containing a sample CNV call. Obtained from a sample CNV call dataset
               named ACMG_examples.hg19.bed from the ClassifyCNV package in the /Examples subdirectory. This
               dataset contains a subset of 21 CNV calls described by 4 fields: chromosome name, start position,
               end position, and type (deletion or duplication). The CNV calling was done on Homo sapiens genotype
               data using genome build hg19 and contain autosomes 1-5, 6, 11-3, 15, 17-19, 22, and sex chromosome X.
               Citation: Gurbich, T.A., Ilinsky, V.V. (2020). ClassifyCNV: a tool for clinicalannotation of
               copy-number variants. Sci Rep 10, 20375. https://doi.org/10.1038/s41598-020-76425-3",
               type = "info")
  })

  observeEvent(input$ds2_details, {
    # Show a modal when the button is pressed
    shinyalert(title = "Large Sample CNV Call Dataset",
               text = "A data frame containing a random subset of a sample CNV call. Obtained from a sample CNV call
               dataset named 1000Genomes.hg38.bed from the ClassifyCNV package in the /Examples subdirectory.
               This dataset contains a subset of 10,000 CNV calls described by 4 fields: chromosome name, start position,
               end position, and type (deletion or duplication). The CNV calling was done on Homo sapiens genotype
               data using genome build hg38 and contain autosomes 1-22 and sex chromosome X. Citation: Citation: Gurbich, T.A.,
               Ilinsky, V.V. (2020). ClassifyCNV: a tool for clinicalannotation of
               copy-number variants. Sci Rep 10, 20375. https://doi.org/10.1038/s41598-020-76425-3",
               type = "info")
  })


}

# Create Shiny app
shiny::shinyApp(ui, server)

# [END]
