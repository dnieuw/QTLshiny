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

	output$chromSlider <- renderUI({
		sliderInput.custom(inputId="chromInput", label="Chromosome :", value=c(2,4), min=0, max=13, custom.ticks=c("1a","1b","2","3","4","5","6","7","8","9","10","11","12"))
	})

	output$chromInput <- renderPrint({input$chromInput})

	output$chromFacetPlot <- renderggiraph({
		min <- as.numeric(input$chromInput[1])
		max <- as.numeric(input$chromInput[2])
		plot <- LGChrom.facetplot(posmap,min,max)
		ggiraph(code = {print(plot)}, zoom_max = 2, tooltip_offx = 20, tooltip_offy = -10, hover_css = "fill:black;stroke-width:1px;stroke:wheat;cursor:pointer;alpha:1;")
	})


	alleleTable <- reactive({
		inFile <- input$file1
		if (is.null(inFile))
		return(NULL)
		table <- geno()$geno$"1a"$data
		table[is.na(table)] <- "NA"
		table[which(table==1)] <- "Allele A"
		table[which(table==2)] <- "Homozygote"
		table[which(table==3)] <- "Allele B"
		return(table)
	})

	# Filter data based on selections
	output$genotable <- DT::renderDataTable(DT::datatable(alleleTable()) %>% 
	  formatStyle(colnames(alleleTable()),
	  	fontWeight = 'bold',
	    backgroundColor = styleEqual(c("Allele A","Homozygote","Allele B","NA"),c("#004CC7","#008A05","#C70D00","#737373")),#BLUE,GREEN,RED,GRAY
	    color = styleEqual(c("Allele A","Homozygote","Allele B","NA"),c("black","black","black","white"))
	  )
	)
})

