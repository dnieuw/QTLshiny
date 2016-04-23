shinyUI(
  navbarPage("Map construction", inverse = TRUE, theme = shinytheme("cerulean"),
                   tabPanel("Clean data",
                            sidebarLayout(
                              sidebarPanel(
                                fileInput('file1', 'Choose file to upload',
                                          accept = c(
                                            'text/csv',
                                            'text/comma-separated-values',
                                            'text/tab-separated-values',
                                            'text/plain',
                                            '.csv',
                                            '.tsv'
                                          )),
                                br(),
                                selectizeInput('e1',
                                               label = 'Data exploration',
                                               choices = c("Remove duplicates","Filter missing")
                                )),
                              mainPanel(
                                iplotMap_output('plot')
                              )
                   )),
                   tabPanel("Quality plots",
                            renderDataTable("summary")
                   ),
                   tabPanel("Genetic map",
                            renderDataTable("summary")
                   ),
                   tabPanel("QTL mapping",
                            sidebarLayout(
                              sidebarPanel(
                               selectizeInput('e2','Interval mapping',
                                               choices = c("Interval mapping","Stepwise")
                                ),
                              htmlOutput("selectUI1")),
                              mainPanel(
                                # iplotScanone_output('scanone', width = "100%", height = "580")
                                plotOutput('scanone')
                                ))),
                   tabPanel("PDF report",
                            renderDataTable("summary")
                   )
))
