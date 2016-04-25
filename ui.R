shinyUI(
  navbarPage("", inverse = TRUE, theme = shinytheme("cerulean"),
    tabPanel(div(h3("Upload data")),
      sidebarLayout(
        sidebarPanel(
          fileInput('file1', 'Upload a cross file',
            accept = '.csv')
        ),
        mainPanel(
          iplotMap_output('raw_plot')
        )
      )
    ),
    tabPanel(div(h3("Quality plots")),
             tabsetPanel(
               tabPanel("Genomepostion(bp) versus Centimorgan(cM)",
                        sidebarLayout(
                          sidebarPanel(
                            uiOutput("chromSlider")
                          ),
                          mainPanel(
                            ggiraphOutput("chromFacetPlot", width="100%", height="800px")
                          )
                        )
               ),
               tabPanel("Genotype Tabel",
                        sidebarLayout(
                          sidebarPanel(
                            
                          ),
                          mainPanel(
                            DT::dataTableOutput("genotable")
                          )
                        )
               ),
               tabPanel("Table")
             )
    ),
    tabPanel(div(h3("Genetic map")),
             tabsetPanel(
               tabPanel("Genetic map",
                sidebarLayout(
                  sidebarPanel(
                    selectInput('mapping',
                                label = 'Mapping function',
                                choices = c("kosambi","haldane")
                             ),
                    br(),
                    sliderInput('split',
                                 label = 'Clustering -log10(P)',
                             min = 3, max = 10,
                             value = 6.4, step = 0.1
                    )
                   ),
                  mainPanel(
                    plotOutput('map_plot')
                  )
                )
               ),
               tabPanel("Recombination Frequency",
                 sidebarLayout(
                   sidebarPanel(
                     selectInput('mapping',
                             label = 'Mapping function',
                              choices = c("kosambi","haldane")
                            ),
                            br(),
                            sliderInput('split',
                                        label = 'Clustering -log10(P)',
                                        min = 3, max = 10,
                                        value = 6.4, step = 0.1
                            )
                          ),
                          mainPanel(
                            plotOutput('rf_plot')
                          )
                        )
               ),
               tabPanel("Map QC",
                        sidebarLayout(
                          sidebarPanel(
                            selectizeInput('qcType',
                                    label = 'Mapping function',
                                    choices = c("dxo","seg.dist")
                            )
                          ),
                          mainPanel(
                           plotOutput('qc_plot')
                          )
                        )
                )
             )
             ),
    tabPanel(div(h3("QTL mapping")),
      sidebarLayout(
        sidebarPanel(
          selectizeInput('e2','Interval mapping',
            choices = c("Interval mapping","Stepwise")
          ),
          htmlOutput("selectUI1")
        ),
        mainPanel(
          # iplotScanone_output('scanone', width = "100%", height = "580")
          plotOutput('scanone')
        )
      )
    ),
    tabPanel(div(h3("About")),
             mainPanel(
               includeMarkdown("about.Rmd")   
             )
    )
    )
  )
