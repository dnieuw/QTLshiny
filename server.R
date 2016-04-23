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


mstmap <- reactive({
  if (is.null(geno()))
    return(NULL)
  mapobject <- mstmap.cross(geno(), bychr = FALSE, dist.fun = input$mapping, 
                        trace = FALSE, id = "RILs",
                        p.value = 10^-input$split)
  names(mapobject$geno) <- paste0("LG",seq_along(mapobject$geno))
  mapobject
  })
  
## Plot of raw data
output$raw_plot <- iplotMap_render({
  if (is.null(geno()))
    return(NULL)
  iplotMap(geno())
})


output$rf_plot <- renderPlot({
  if (is.null(mstmap()))
    return(NULL)
  ## A very crappy 'progress 'I am busy' indicator for 5 secs.. 
  progress <- shiny::Progress$new(session, min=1, max=5)
  on.exit(progress$close())
  progress$set(message = 'Calculation in progress')
  for (i in 1:5) {
    progress$set(value = i)
    Sys.sleep(0.5)
  }
  rf.cross <- est.rf(mstmap())
  heatMap(rf.cross)
})

output$qc_plot <- renderPlot({
  suppressWarnings(profileMark(mstmap(), stat.type = input$qcType, id =
              "RILs", type = "a"))
})



## Plot of mst ordered data
output$map_plot <- renderPlot({
  if (is.null(mstmap()))
    return(NULL)
  plotMap(mstmap())
})

output$selectUI1 <- renderUI({ 
    if (is.null(geno()))
    return(NULL)
    selectInput("trait", "Select trait", names(geno()$pheno))
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


