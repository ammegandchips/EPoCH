# when the user clicks the button to load the data...

loaded_data <- eventReactive(input$load_results,{
  # the data will load from dropbox (with a message explaining what's happening)
  showModal(modalDialog("Loading data"))
  dropbox_links <- c("https://www.dropbox.com/s/amagzojd4xmj66l/metaphewas_model1a_extracted.RDS?dl=1",
                     "https://www.dropbox.com/s/3ey11hxpqlo6i2h/metaphewas_model1b_extracted.RDS?dl=1"
  )
  all_res <- lapply(dropbox_links,function(x) readRDS(url(x)))
  # a bit of tidying will happen (stick it all together, make lists of unique exposure and outcome classes, make a tibble of unique combinations, put everything in a list and name the objects)
  all_res <- bind_rows(all_res)
  exp_classes <- unique(all_res$exposure_class)
  out_classes <- unique(all_res$outcome_class)
  all_res_tib <- as_tibble(unique(all_res[,c("exposure_class", "exposure_subclass", "person_exposed", "exposure_time", "exposure_type", "exposure_source", "exposure_dose", "model")]))
  loaded_data <- list(all_res,exp_classes,out_classes,all_res_tib)
  names(loaded_data) <- c("all_res","exp_classes","out_classes","all_res_tib")

  # And the rest of the input options will be updated based on the data
  updateRadioButtons(session, "exp_class",
                     choices = loaded_data$exp_classes)
  updateRadioButtons(session, "out_class",
                     choices = loaded_data$out_classes)
  updateRadioButtons(session, "n_comparisons",
                     choices = 1:4)
  # The message about loading the data will be removed
  removeModal()
  # And loaded_data will be returned for use elsewhere in the app
  loaded_data
})

# Then there will be a message to say that the data has been loaded
output$Text <- renderText({paste("All",length(loaded_data()),"objects have been generated")})