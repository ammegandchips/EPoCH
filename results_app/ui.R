
ui<-fluidPage(
    useShinyjs(),
    
    # Application title
    headerPanel("Associations between prenatal health behaviours (exposures) and child health (outcomes)"),
 
    # Organise into three tabs

    tabsetPanel(
        id="navbar",
    # Tab 1: look-up exposure        
        tabPanel(title="Find outcomes associated with a specified exposure", value="tab1", h1("Look-up exposure"),
                 sidebarLayout(    
                     sidebarPanel(
                         h4("Select specific exposure"),
                         shinyTree("exposure_tree",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
                         h4("Select general outcome class"),
                         radioButtons("general_outcome_class",label=NULL,
                                      choices = unique(key$outcome_class)),
                         h4("Additional settings"),
                         selectInput("selected_exposure_dose","If you have selected an ordinal exposure, what dose do you want to compare to the reference category?",
                                     choices = c("not ordinal","light","moderate","heavy","somewhat active","active")), 
                         radioButtons("selected_model_tab1",label="Which model?",
                                      choices = c("Model 1","Model 2", "Model 3"))
                     ),
                     mainPanel(
                         # Display selected exposure
                         span(textOutput("exposure_message"), style="color:red"),
                         span(textOutput("ordinal_message"), style="color:red"),
 #                        tableOutput("exposure_selected_slice_df"),
  #                       textOutput("height_plot_tab1_binary"),
 #                        textOutput("height_plot_tab1_numeric"),
                         plotlyOutput("tab1_plot_binary",height="auto") %>% shinycssloaders::withSpinner(),
                        plotlyOutput("tab1_plot_numeric",height="auto") %>% shinycssloaders::withSpinner()
                     )
                 )),
    #Tab 2: look-up outcome
        tabPanel(title="Find exposures associated with a specified outcome", value="tab2", h1("Look-up outcome"),
                 sidebarLayout(    
                     sidebarPanel(
                         h5("Select general exposure class"),
                         radioButtons("general_exposure_class",label=NULL,
                                      choices = unique(key$exposure_class)),
                         h5("Select exposed parent"),
                         radioButtons("exposed_parent",label=NULL,
                                      choices = unique(key$person_exposed)),
                         h5("Select specific outcome"),
                         shinyTree("outcome_tree",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
                         h5("Additional settings"),
                         radioButtons("selected_model_tab2",label="Which model?",
                                      choices = c("Model 1","Model 2", "Model 3"))
                     ),
                     mainPanel(
                         # Display selected outcome
                         textOutput("outcome_message"),
                         tableOutput("outcome_selected_slice_df"),
                         plotlyOutput("tab2_plot_binary",height="auto") %>% shinycssloaders::withSpinner(),
                         plotlyOutput("tab2_plot_numeric",height="auto") %>% shinycssloaders::withSpinner()
                     )
                 ))
        )

    )