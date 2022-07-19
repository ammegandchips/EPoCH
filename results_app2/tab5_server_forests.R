
##################
# Exposure tree  #
##################

exposure_hierarchy_tab5 <- c("exposure_class", "person_exposed","exposure_subclass", "exposure_time","exposure_type", "exposure_source","model", "exposure_dose")
output$exposure_tree_tab5 <- renderTree({
  df <- loaded_data()$all_res[,exposure_hierarchy_tab5]
  exposure_tree_tab5 <- dfToTree(df, exposure_hierarchy_tab5)
  #shiny tree must have a selected element to return the tree in input
  attr(exposure_tree_tab5[[1]],"stselected") <- TRUE
  exposure_tree_tab5
})

exposure_selected_slice_tab5<- reactive({
  if (input$load_results==1){
    lapply(get_selected(input$exposure_tree_tab5,format="slices"),function(node){treeToDf(node,exposure_hierarchy_tab5)})
  } else{
    "None"
  }
})

output$exposure_message_tab5 <- renderText({
  print(exposure_selected_slice_tab5()[[1]])
  ifelse(ncol(exposure_selected_slice_tab5()[[1]])<7,
         "Select more sub-classes for exposure (follow the branch all the way to the end)",
         "")
})

all_selected_exposures_tab5 <- reactive({
  exposure_type_tab5 <- exposure_selected_slice_tab5()[[1]][1]
  exposure_class_tab5 <- exposure_selected_slice_tab5()[[1]][2]
  c(exposure_type_tab5,exposure_class_tab5)
})

output$all_selected_exposures_text_tab5 <-renderText({
  paste(all_selected_exposures_tab5())
})

#################################################
# Outcome tree updated after exposure selected  #
#################################################

