##############################################################
# Outcome radio buttons are defined under tab1_server_home.R #
##############################################################

##################
# EXPOSURE TREES #
##################

# Create exposure hierarchy for trees
exposure_hierarchy <- c("exposure_class", "person_exposed","exposure_subclass", "exposure_time","exposure_type", "exposure_source", "exposure_dose","model")

# Exposure variable 1
output$exposure_tree1 <- renderTree({
  df <- loaded_data()$all_res[,exposure_hierarchy]
  exposure_tree <- dfToTree(df, exposure_hierarchy)
  #shiny tree must have a selected element to return the tree in input
  attr(exposure_tree[[1]],"stselected") <- TRUE
  exposure_tree
})
exposure_selected_slice1<- reactive({
  if (is.null(input$exposure_tree1)){
    "None"
  } else{
    lapply(get_selected(input$exposure_tree1,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  }
})
output$exposure_selected_slice_df1 <- renderTable({
  exposure_selected_slice1()
})
output$exposure_message1 <- renderText({
  ifelse(ncol(exposure_selected_slice1()[[1]])<8,
         "Select more sub-classes for variable 1 (follow the branch all the way to the end)",
         "")
})

# Exposure variable 2
output$exposure_tree2 <- renderTree({
  df <- loaded_data()$all_res[,exposure_hierarchy]
  exposure_tree <- dfToTree(df, exposure_hierarchy)
  #shiny tree must have a selected element to return the tree in input
  attr(exposure_tree[[1]],"stselected") <- TRUE
  exposure_tree
})
exposure_selected_slice2<- reactive({
  if (is.null(input$exposure_tree2)){
    "None"
  } else{
    lapply(get_selected(input$exposure_tree2,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  }
})
output$exposure_selected_slice_df2 <- renderTable({
  exposure_selected_slice2()
})
output$exposure_message2 <- renderText({
  ifelse(ncol(exposure_selected_slice2()[[1]])<8,
         "Select more sub-classes for variable 2 (follow the branch all the way to the end)",
         "")
})

# Exposure variable 3
output$exposure_tree3 <- renderTree({
  df <- loaded_data()$all_res[,exposure_hierarchy]
  exposure_tree <- dfToTree(df, exposure_hierarchy)
  #shiny tree must have a selected element to return the tree in input
  attr(exposure_tree[[1]],"stselected") <- TRUE
  exposure_tree
})
exposure_selected_slice3<- reactive({
  if (is.null(input$exposure_tree2)){
    "None"
  } else{
    lapply(get_selected(input$exposure_tree3,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  }
})
output$exposure_selected_slice_df3 <- renderTable({
  exposure_selected_slice3()
})
output$exposure_message3 <- renderText({
  ifelse(ncol(exposure_selected_slice2()[[1]])<8,
         "Select more sub-classes for variable 3 (follow the branch all the way to the end)",
         "")
})

# Exposure variable 4
output$exposure_tree4 <- renderTree({
  df <- loaded_data()$all_res[,exposure_hierarchy]
  exposure_tree <- dfToTree(df, exposure_hierarchy)
  #shiny tree must have a selected element to return the tree in input
  attr(exposure_tree[[1]],"stselected") <- TRUE
  exposure_tree
})
exposure_selected_slice4<- reactive({
  if (is.null(input$exposure_tree4)){
    "None"
  } else{
    lapply(get_selected(input$exposure_tree4,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  }
})
output$exposure_selected_slice_df4 <- renderTable({
  exposure_selected_slice4()
})
output$exposure_message4 <- renderText({
  ifelse(ncol(exposure_selected_slice2()[[1]])<8,
         "Select more sub-classes for variable 4 (follow the branch all the way to the end)",
         "")
})

##################
# COEF PLOT CODE #
##################

