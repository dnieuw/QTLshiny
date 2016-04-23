shinyServer(function(input, output, session) {

  geno <- reactive({

    inFile <- input$file1
    if (is.null(inFile))
    return(NULL)
    read.cross(
      format = "csv",
      file = inFile$datapath,
      genotypes = c("a","h","b"),
      alleles = c("a","b"),
      estimate.map = FALSE,
      BC.gen = 0,
      F.gen = 6
    )
  })


  output$selectUI1 <- renderUI({ 
    if (is.null(geno()))
    return(NULL)
    selectInput("trait", "Select trait", names(geno()$pheno))
  })



  mst <- reactive({
    inFile <- input$file1
    if (is.null(inFile))
    return(NULL)
    mapobject <- mstmap(geno(), id = "RILs")
    mapobject
  })


  output$plot <- iplotMap_render({
    if (is.null(mst()))
    return(NULL)
    iplotMap(mst())
  })

  s1 <- reactive({
    if (is.null(geno()))
    return(NULL)
    scanone(geno(), pheno.col = which(names(geno()$pheno)==input$trait))
  })

  # output$scanone <- iplotScanone_render({
  #   if (is.null(geno()))
  #     return(NULL)
  # iplotScanone(s1())
  # })

  output$scanone <- renderPlot({
    if (is.null(geno()))
    return(NULL)
    plot(s1())
  })



  output$GenPosLG.slider <- renderUI({

    args <- list(inputId="foo", 
      label="Chromosome :", 
      ticks=c("1a","1b","2","3","4","5","6","7","8","9","10","11","12"),
      value=c(2,3))

    args$min <- 1
    args$max <- length(args$ticks)

    if (sessionInfo()$otherPkgs$shiny$Version>="0.11") {
      ticks <- paste0(args$ticks, collapse=',')
      args$ticks <- T
      html <- do.call('sliderInput', args)
      html$children[[2]]$attribs[['data-values']] <- ticks;
    } else {
      html <- do.call('sliderInput', args)
    }
    html
  })
  output$GenPosLG.slider.output <- renderPrint({input$foo})
})


