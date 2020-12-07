
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
                                      choices = c("Model 1","Model 2", "Model 3")),
                         textInput("xmin_numeric_tab1","X-axis minimum value if outcome is numeric", value=-1),
                         textInput("xmax_numeric_tab1","X-axis maximum value if outcome is numeric",value=1),
                         textInput("xmin_binary_tab1","X-axis minimum value if outcome is binary", value=0.1),
                         textInput("xmax_binary_tab1","X-axis maximum value if outcome is binary",value=10)
                     ),
                     mainPanel(
                         # Display selected exposure
                         span(textOutput("exposure_message"), style="color:red"),
                         span(textOutput("ordinal_message"), style="color:red"),
#                         tableOutput("exposure_selected_slice_df"),
#                         textOutput("height_plot_tab1"),
                         plotOutput("tab1_plot",height="auto") %>% shinycssloaders::withSpinner()
                     )
                 )),
    #Tab 2: look-up outcome
        tabPanel(title="Find exposures associated with a specified outcome", value="tab2", h1("Look-up outcome"),
                 sidebarLayout(    
                     sidebarPanel(
                         h5("Select general exposure class"),
                         radioButtons("general_exposure_class",label=NULL,
                                      choices = unique(key$exposure_class)),
                         h5("Select specific outcome"),
                         shinyTree("outcome_tree",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
                         h5("Additional settings"),
                         radioButtons("selected_model_tab2",label="Which model?",
                                      choices = c("Model 1","Model 2", "Model 3")),
                         textInput("xmin_tab2","X-axis minimum value", value=-1),
                         textInput("xmax_tab2","X-axis maximum value",value=1)
                     ),
                     mainPanel(
                         # Display selected outcome
                         textOutput("outcome_message"),
                         tableOutput("outcome_selected_slice_df")
                     )
                 ))
        )

    
    
    )