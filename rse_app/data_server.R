source("data.R")

# when the user clicks the button to load the data...
loaded_data <- observeEvent(input$load_results,{
  # the data will load from dropbox (with a message explaining what's happening)
  showModal(modalDialog("Loading data"))
  loaded_data <- import_data_local(global_data)

  #Generate a dataframe matching the model names to their IDs (essentially "Model 1a" to "model1a" etc)
  model_n = 1 # was 4
  model_l = 2 # was 3
  global_data$df_models <- data.frame(name=paste0("Model ",as.vector(outer(1:model_n, letters[1:model_l], paste0))),
                        shortname=paste0("model",as.vector(outer(1:model_n, letters[1:model_l], paste0)))
                                     )

  updateSelectizeInput(inputId = "exposure_choice", selected = 'All',
                       choices = str_to_sentence(append(global_data$exp_classes, 'All', after=0)))

  updateSelectizeInput(inputId = "outcome_choice", selected = 'All',
                       choices = str_to_sentence(append(global_data$out_classes, 'All', after=0)))

  updateSelectizeInput(inputId = "model_choice", choices = global_data$df_models$name,
                       selected = global_data$df_models$name[1])

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
  global_data$data_is_loaded = TRUE
  global_data$data <- loaded_data
})

# Coefficient plot data organisation
observeEvent(input$exposure_choice,{
  coeff_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "coeff_person",
                       choices = list("Mother", "Father"),
                       selected = "Select person exposed")
  updateSelectizeInput(session, inputId = "coeff_subclass",
                       choices = list('----------'),selected = '----------')
  updateSelectizeInput(inputId = "coeff_exptime",
                       choices = list('----------'),selected = '----------')
})

observeEvent(input$coeff_person,{
  coeff_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "coeff_subclass",
                       choices = unique(str_to_sentence(
    coeff_dat$exposure_subclass[coeff_dat$exposure_class==tolower(input$exposure_choice)&
                                coeff_dat$person_exposed==tolower(input$coeff_person)]
                                       )),
                       selected = '----------')
})

observeEvent(input$coeff_subclass,{
  coeff_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "coeff_exptime",
                       choices = unique(str_to_sentence(
    coeff_dat$exposure_time[coeff_dat$exposure_class==tolower(input$exposure_choice)&
                            coeff_dat$person_exposed==tolower(input$coeff_person)&
                            coeff_dat$exposure_subclass==tolower(input$coeff_subclass)])),
                       selected = '----------')
})

observeEvent(input$coeff_exptime,{
  coeff_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "coeff_explink",
                       choices = unique(
    coeff_dat$exposure_linker[coeff_dat$exposure_class==tolower(input$exposure_choice)&
                              coeff_dat$person_exposed==tolower(input$coeff_person)&
                              coeff_dat$exposure_subclass==tolower(input$coeff_subclass)&
                              coeff_dat$exposure_time==tolower(input$coeff_exptime)]
                                       ),
                       selected = unique(
    coeff_dat$exposure_linker[coeff_dat$exposure_class==tolower(input$exposure_choice)&
                              coeff_dat$person_exposed==tolower(input$coeff_person)&
                              coeff_dat$exposure_subclass==tolower(input$coeff_subclass)&
                              coeff_dat$exposure_time==tolower(input$coeff_exptime)])[1]
                              )
})

observeEvent(input$add_comp,{

  if (input$outcome_choice == "All") {
    showModal(modalDialog("Please select an outcome for comparison"))
  } else if (length(global_data$data$all_res$outcome_linker[
        global_data$data$all_res$outcome_class==tolower(input$outcome_choice)&
        global_data$data$all_res$exposure_linker==tolower(input$coeff_explink)]) == 0) {
    showModal(modalDialog("No data available for this exposure linker"))
  } else if (length(global_data$coeff_linkers$Linker) == 4){
    showModal(modalDialog("Maximum of 4 comparisons can be made"))
  } else {
    ldf_len = length(global_data$coeff_linkers$Linker)
    global_data$coeff_linkers$Linker[ldf_len + 1] <- input$coeff_explink
  }
})


observeEvent(input$clear_comps,{
    global_data$coeff_linkers <- NULL
})


output$showActiveLinkers <- renderTable({
  global_data$coeff_linkers
})

# Forest plot data organisation
observeEvent(input$exposure_choice,{
  coeff_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "forest_person",
                       choices = list("Mother", "Father"),
                       selected = "Select person exposed")
  updateSelectizeInput(session, inputId = "coeff_subclass",
                       choices = list('----------'),selected = '----------')
  updateSelectizeInput(inputId = "coeff_exptime",
                       choices = list('----------'),selected = '----------')
})

observeEvent(input$forest_person,{
  forest_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "forest_subclass",
                       choices = unique(str_to_sentence(
    forest_dat$exposure_subclass[forest_dat$exposure_class==tolower(input$exposure_choice)&
                                forest_dat$person_exposed==tolower(input$forest_person)]
                                       )),
                       selected = '----------')
})

observeEvent(input$forest_subclass,{
  forest_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "forest_exptime",
                       choices = unique(str_to_sentence(
    forest_dat$exposure_time[forest_dat$exposure_class==tolower(input$exposure_choice)&
                            forest_dat$person_exposed==tolower(input$forest_person)&
                            forest_dat$exposure_subclass==tolower(input$forest_subclass)])),
                       selected = '----------')
})

observeEvent(input$outcome_choice,{
  forest_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "forest_outcometype",
                       choices = unique(str_to_sentence(
    forest_dat$outcome_subclass1[forest_dat$exposure_class==tolower(input$exposure_choice)&
                                 forest_dat$person_exposed==tolower(input$forest_person)&
                                 forest_dat$exposure_subclass==tolower(input$forest_subclass)&
                                 forest_dat$exposure_time==tolower(input$forest_exptime)&
                                 forest_dat$outcome_class==tolower(input$outcome_choice)]
                                       ),
                       selected = '----------')
                              )
})

observeEvent(input$forest_exptime,{
  forest_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "forest_explink",
                       choices = unique(
    forest_dat$exposure_linker[forest_dat$exposure_class==tolower(input$exposure_choice)&
                              forest_dat$person_exposed==tolower(input$forest_person)&
                              forest_dat$exposure_subclass==tolower(input$forest_subclass)&
                              forest_dat$exposure_time==tolower(input$forest_exptime)]
                                       ),
                       selected = unique(
    forest_dat$exposure_linker[forest_dat$exposure_class==tolower(input$exposure_choice)&
                              forest_dat$person_exposed==tolower(input$forest_person)&
                              forest_dat$exposure_subclass==tolower(input$forest_subclass)&
                              forest_dat$exposure_time==tolower(input$forest_exptime)])[1]
                              )
})

observeEvent(input$forest_outcometype,{
  forest_dat <- global_data$data$all_res
  updateSelectizeInput(session, inputId = "forest_outlink",
                       choices = unique(
    forest_dat$outcome_linker[forest_dat$exposure_class==tolower(input$exposure_choice)&
                                 forest_dat$person_exposed==tolower(input$forest_person)&
                                 forest_dat$exposure_subclass==tolower(input$forest_subclass)&
                                 forest_dat$exposure_time==tolower(input$forest_exptime)&
                                 forest_dat$outcome_class==tolower(input$outcome_choice)&
                                 forest_dat$outcome_subclass1==tolower(input$forest_outcometype)]
                                       ),
                       selected = unique(
    forest_dat$outcome_linker[forest_dat$exposure_class==tolower(input$exposure_choice)&
                                 forest_dat$person_exposed==tolower(input$forest_person)&
                                 forest_dat$exposure_subclass==tolower(input$forest_subclass)&
                                 forest_dat$exposure_time==tolower(input$forest_exptime)&
                                 forest_dat$outcome_class==tolower(input$outcome_choice)&
                                 forest_dat$outcome_subclass1==tolower(input$forest_outcometype)])[1]
                              )
})

output$showForestLinkers <- renderTable({
  forest_tab <- data.frame(Kind=c("Exposure", "Outcome"),
                           Linker=c(input$forest_explink, input$forest_outlink))
  print(forest_tab)
  forest_tab
})