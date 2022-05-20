output$Text2 <- renderText({paste("All",length(loaded_data()),"objects have been generated")})

## when the user clicks "visualise results"...
observeEvent(input$tab2Go,{
  ## if the data hasn't been loaded, they get an error message...
  if(exists("loaded_data()")==F){
    showModal(modalDialog("Data hasn't been loaded. Go back to the Home tab and load the data first."))
    reset("tab2Go")
  }
  ## but if it HAS been loaded, they get a message saying that the visualisations are being generated...
  if(length(loaded_data())==4){
    showModal(modalDialog("Generating visualisations"))
  ## then the visualisations appear...
    ## a manhattan plot
output$exposureManhattanPlot <- renderPlotly({
    model <- df_models$shortname[df_models$name == input$model]
    dat <- loaded_data()$all_res[which(loaded_data()$all_res$model==model),]
    df <- create_exposure_manhattan_dfs(input$exp_class,dat)
    create_exposure_manhattan_plot(df)
  })
    ## and a volcano plot
output$exposureVolcanoPlot <- renderPlotly({
  model <- df_models$shortname[df_models$name == input$model]
  dat <- loaded_data()$all_res[which(loaded_data()$all_res$model==model),]
  df <- create_exposure_volcano_dfs(input$exp_class,dat)
  create_exposure_volcano_plot(df)
})
}
})

