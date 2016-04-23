shinyServer(function(input, output, session) {
  
geno <- reactive({
    
    inFile <- input$file1
    if (is.null(inFile))
      return(NULL)
    read.cross(format = "csv",
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


  })
  

