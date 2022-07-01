##############################################################
# Outcome radio buttons are defined under tab1_server_home.R #
##############################################################

###########################
# Generate exposure trees #
###########################

# Create exposure hierarchy for trees
exposure_hierarchy <- c("exposure_class", "person_exposed","exposure_subclass", "exposure_time","exposure_type", "exposure_source","model", "exposure_dose")
tree_names <- paste0("exposure_tree",1:4)
all_trees_and_headings <- vector("list",4)

# When number of comparisons selected and GO button pressed, generate the required number of shiny trees
observeEvent(input$go4,{
  all_trees_and_headings <- all_trees_and_headings[1:as.numeric(input$n_comparisons)]
  
  # Exposure variable 1
  output$exposure_tree1 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })
  
  # Exposure variable 2
  output$exposure_tree2 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })

  # Exposure variable 3
  output$exposure_tree3 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })
  
  # Exposure variable 4
  output$exposure_tree4 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })

  for(i in 1:length(all_trees_and_headings)){
    all_trees_and_headings[[i]][[1]] = h4(paste0("Select comparison ",i))
    all_trees_and_headings[[i]][[2]] = shinyTree(tree_names[i],unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner()
  }
  
  
output$exposure_trees <- renderUI({
      tagList(all_trees_and_headings)
      })

})

##################################
# Summarise selected comparisons #
##################################

exposure_selected_slice1<- reactive({
  lapply(get_selected(input$exposure_tree1,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
})

output$exposure_message1 <- renderText({
  ifelse(ncol(exposure_selected_slice1()[[1]])<8,
         "Select more sub-classes for variable 1 (follow the branch all the way to the end)",
         "")
})

exposure_selected_slice2<- reactive({
  if (2 %in% 1:input$n_comparisons){
    lapply(get_selected(input$exposure_tree2,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  } else{
    "None"
  }
})

output$exposure_message2 <- renderText({
  ifelse(ncol(exposure_selected_slice2()[[1]])<8,
         "Select more sub-classes for variable 2 (follow the branch all the way to the end)",
         "")
})

exposure_selected_slice3<- reactive({
  if (3 %in% 1:input$n_comparisons){
    lapply(get_selected(input$exposure_tree3,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  } else{
    "None"
  }
})

output$exposure_message3 <- renderText({
  ifelse(ncol(exposure_selected_slice3()[[1]])<8,
         "Select more sub-classes for variable 3 (follow the branch all the way to the end)",
         "")
})

exposure_selected_slice4<- reactive({
  if (4 %in% 1:input$n_comparisons){
    lapply(get_selected(input$exposure_tree4,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  } else{
    "None"
  }
})

output$exposure_message4 <- renderText({
  ifelse(ncol(exposure_selected_slice4()[[1]])<8,
         "Select more sub-classes for variable 4 (follow the branch all the way to the end)",
         "")
})

all_selected_exposures <- reactive({
  all_exposures_list <-list(exposure_selected_slice1(),
                            exposure_selected_slice2(),
                            exposure_selected_slice3(),
                            exposure_selected_slice4())
  all_exposures_list <- lapply(all_exposures_list,as.data.frame)
  
  all_exposures_list <- lapply(all_exposures_list,function(x){
    x<-rev(x)
    colnames(x) <- exposure_hierarchy[1:ncol(x)]
    x
  })
  
  all_exposures<-bind_rows(all_exposures_list)
  all_exposures[all_exposures=="None"]<-NA
  all_exposures<-as.data.frame(t(all_exposures))
  row.names(all_exposures)<-exposure_hierarchy[1:nrow(all_exposures)]
  colnames(all_exposures)<-paste("Comparison",1:4)
  all_exposures
})

output$all_selected_exposures_df <-renderTable({
  all_selected_exposures()
  },
  rownames=TRUE)


##################
# COEF PLOT CODE #
##################
# make a df containing all exposures/comparisons X
# When generate plot button is pressed
# subset all_res to just those exposures and the selected outcomes
# draw coef plots
