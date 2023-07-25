source("plot.R")

## When the user clicks "visualise results"...
observeEvent(input$plot_data,{
  ## If the data hasn't been loaded, they get an error message...
  if (global_data$data_is_loaded == FALSE) {
    showModal(modalDialog("No data has been loaded."))
  }
  else
  {

  output$exposureManhattanPlot <- renderPlotly({
    model <- global_data$df_models$shortname[global_data$df_models$name == input$model_choice]
    dat <- global_data$data$all_res[which(global_data$data$all_res$model==model),]

    exp_df <- create_exposure_dfs(tolower(input$exposure_choice),dat)
    filtered_df <- create_outcome_dfs(tolower(input$outcome_choice),exp_df)
    if (input$exposure_choice == "All") {
      create_manhattan_plot(filtered_df, input$dimension[2]-110,
                            "exposure_class", "Exposure class")
    } else {
      create_manhattan_plot(filtered_df, input$dimension[2]-110,
                            "exposure_subclass_time_dose", "Exposure type")
    }
    })

  output$outcomeManhattanPlot <- renderPlotly({
    model <- global_data$df_models$shortname[global_data$df_models$name == input$model_choice]
    dat <- global_data$data$all_res[which(global_data$data$all_res$model==model),]

    outc_df <- create_outcome_dfs(tolower(input$outcome_choice),dat)
    filtered_df <- create_exposure_dfs(tolower(input$exposure_choice),outc_df)
    if (input$outcome_choice == "All") {
      create_manhattan_plot(filtered_df, input$dimension[2]-110,
                            "outcome_class", "Outcome class")
    } else {
      create_manhattan_plot(filtered_df, input$dimension[2]-110,
                            "outcome_subclass_time", "Outcome type")
    }
    })

  output$exposureVolcanoPlot <- renderPlotly({
    model <- global_data$df_models$shortname[global_data$df_models$name == input$model_choice]
    dat <- global_data$data$all_res[which(global_data$data$all_res$model==model),]
    exp_df <- create_exposure_dfs(tolower(input$exposure_choice),dat)
    filtered_df <- create_outcome_dfs(tolower(input$outcome_choice),exp_df)
    p_m <- create_volcano_plot(filter(filtered_df, person_exposed=="mother"))
    p_f <- create_volcano_plot(filter(filtered_df, person_exposed=="father"))
    subplot(p_m, p_f, shareY = TRUE, titleX = TRUE)%>%
      layout(xaxis = list(title = "Standardised effect estimate",
                         range = list(-0.75, 0.75)),
             yaxis = list(title = "Ranked -log10(P)"))
    })

  output$outcomeVolcanoPlot <- renderPlotly({
    model <- global_data$df_models$shortname[global_data$df_models$name == input$model_choice]
    dat <- global_data$data$all_res[which(global_data$data$all_res$model==model),]
    outc_df <- create_outcome_dfs(tolower(input$outcome_choice),dat)
    filtered_df <- create_exposure_dfs(tolower(input$exposure_choice),outc_df)
    p_m <- create_volcano_plot(filter(filtered_df, person_exposed=="mother"))
    p_f <- create_volcano_plot(filter(filtered_df, person_exposed=="father"))
    fig <- subplot(p_m, p_f, shareY = TRUE, titleX = TRUE)%>%
      layout(xaxis = list(title = "Standardised effect estimate",
                         range = list(-0.75, 0.75)),
             yaxis = list(title = "Ranked -log10(P)"))
    })

  output$exposureCoeffPlot <- renderPlotly({
    model <- global_data$df_models$shortname[global_data$df_models$name == input$model_choice]
    dat <- global_data$data$all_res[which(global_data$data$all_res$model==model),]
    plots <- list()
    y_data <- c()

    for (l in 1:length(global_data$coeff_linkers$Linker)){
      coeff_filtered <- dat[dat$exposure_linker==tolower(global_data$coeff_linkers$Linker[l]),]
      plot_df <- create_outcome_dfs(tolower(input$outcome_choice),coeff_filtered)
      y_data <- sort(unique(c(y_data, plot_df$outcome_linker)))
    }

    for (l in 1:length(global_data$coeff_linkers$Linker)) {
      coeff_filtered <- dat[dat$exposure_linker==tolower(global_data$coeff_linkers$Linker[l]),]
      plot_df <- create_outcome_dfs(tolower(input$outcome_choice),coeff_filtered)
      plot_title <- str_replace(global_data$coeff_linkers$Linker[l], "self-reported", "self reported")
      plot_title <- str_replace_all(plot_title, "-", "\n")
      plots[[l]] <- create_coeff_plot(plot_df, y_data, plot_title)
    }

    if (length(plots) == 1){
      fig <- subplot(plots[[1]], shareX = TRUE, shareY = TRUE, titleX = TRUE)
    } else if (length(plots) == 2) {
      fig <- subplot(plots[[1]], plots[[2]], shareX = TRUE, shareY = TRUE, titleX = TRUE)
    } else if (length(plots) == 3) {
      fig <- subplot(plots[[1]], plots[[2]], plots[[3]], shareX = TRUE, shareY = TRUE, titleX = TRUE)
    } else if (length(plots) == 4) {
      fig <- subplot(plots[[1]], plots[[2]], plots[[3]], plots[[4]], shareX = TRUE, shareY = TRUE, titleX = TRUE)
    }

    fig <- fig %>% layout(yaxis = list(title = paste("Outcome - ", input$outcome_choice),
                                       showline = FALSE,
                                       ticktext = str_to_sentence(sub(".","",gsub(tolower(input$outcome_choice),
                                                                   "",y_data))),
                                       tickvals = seq.int(1,length(y_data)),
                                       tickmode = "array"))
    })

  output$forestPlot <- renderPlotly({
    model <- global_data$df_models$shortname[global_data$df_models$name == input$model_choice]
    dat <- global_data$data$all_res[which(global_data$data$all_res$model==model),]
    forest_df <- create_forest_dfs(dat, input$forest_explink, input$forest_outlink)
    #print(colnames(dat))
    #cohorts <- grep(",", unique(dat$cohorts), invert = TRUE, value = TRUE)
    #plot <- create_forest_plot(forest_df, cohorts)
    create_forest_plot(forest_df)

    })

  }

})