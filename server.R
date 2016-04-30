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
	validate(
		need(input$file1 != "", "Please upload a cross file")
	)
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

	output$scanone <- renderPlot({
		validate(
			need(input$file1 != "", "Please upload a cross file")
		)
		plot(s1())
	})

	output$chromSlider <- renderUI({
		sliderInput.custom(inputId="chromInput", label="Chromosome :", value=c(2,4), min=0, max=13, custom.ticks=c("1a","1b","2","3","4","5","6","7","8","9","10","11","12"))
	})
	
	output$chromInput <- renderPrint({input$chromInput})
	
	output$chromFacetPlot <- renderggiraph({
		validate(
			need(input$file1 != "", "Please upload a cross file")
		)
		min <- as.numeric(input$chromInput[1])
		max <- as.numeric(input$chromInput[2])
		plot <- LGChrom.facetplot(posmap,min,max, cross = geno())
		ggiraph(code = {print(plot)}, zoom_max = 2, tooltip_offx = 20, tooltip_offy = -10, hover_css = "fill:black;stroke-width:1px;stroke:wheat;cursor:pointer;alpha:1;")
	})
	
	output$chromSlider <- renderUI({
		sliderInput.custom(inputId="chromInput", label="Chromosome :", value=c(2,4), min=0, max=13, custom.ticks=c("1a","1b","2","3","4","5","6","7","8","9","10","11","12"))
	})

	output$chromSelect <- renderUI({
		selectizeInput(inputId="chromSelect", 
			label = "Select Chromosome", 
    		choices = names(geno()$geno)
    	)
	})

	output$markerSelect <- renderUI({
		selectizeInput(inputId="markerSelect", 
			label = 'Select a marker to compare', 
			choices = colnames(geno()$geno[[input$chromSelect]]$data), 
			multiple = TRUE
      )
	})

	alleleTable <- reactive({
		validate(
			need(input$file1 != "", "Please upload a cross file"),
			need(input$markerSelect != "NULL" , "Please select a set of markers")
		)
		table <- t(geno()$geno[[input$chromSelect]]$data[,input$markerSelect])
		colnames(table) <- seq(ncol(table))
		table[is.na(table)] <- "NA"
		table[which(table==1)] <- "A"
		table[which(table==2)] <- "H"
		table[which(table==3)] <- "B"
		return(table)
	})
	
	# Filter data based on selections
	output$genotable <- DT::renderDataTable(DT::datatable(alleleTable(),
		extensions = "FixedColumns",
		options = list(
    		dom = 't',
   			scrollX = TRUE,
   			scrollY = "600px",
    		fixedColumns = TRUE,
    		scrollCollapse = TRUE,
    		paging = FALSE
  		)
	) 
	%>% 
	formatStyle(colnames(alleleTable()),
			fontWeight = 'bold',
			backgroundColor = styleEqual(c("A","H","B","NA"),c("#004CC7","#008A05","#C70D00","#737373")),#BLUE,GREEN,RED,GRAY
			color = styleEqual(c("A","H","B","NA"),c("black","black","black","white"))
		)
	)
})


