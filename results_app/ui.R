
ui<-fluidPage(
    useShinyjs(),
    
    # Application title
    headerPanel(img(src='logo.png', align = "center",height="50%",width="50%")),
 
    # Organise into three tabs

    tabsetPanel(
        id="navbar",
    # Home tab
    tabPanel(title="Home", value="hometab",h1("Welcome to the EPoCH study results app!"),
             mainPanel(
               "The Exploring Prenatal Influence On Childhood Health (EPoCH) study uses data from multiple European birth cohorts to explore associations between parental health behaviours in the prenatal period and childhood health.",
               "You can use this app to look up the results of the study. Use the tabs above to select the data you're interested in seeing.", 
              "Exposures are maternal or paternal/partner smoking, alcohol consumption, caffeine consumption, diet or physical activity around the time of pregnancy.",
               "Child health outcomes are grouped into categories: body size and composition, psychosocial and cognitive traits, immunological traits and cardiometabolic traits. You can either look up all the associations for one exposure (tab 1), all the associations for one outcome (tab 2) or the association between one specified exposure and one specified outcome (tab 3).",
               "You can find out more information about EPoCH at our website [link] and on our Open Science Framework site [link]. All analysis code is provided here [github link].",
               "If you find this site useful and use it in your work, please cite it: xxx.",
               "This app was developed by Gemma Sharp [link] at the University of Bristol MRC Integrative Epidemiology Unit [link]."
               )
               
             ),
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
                                      choices = c("Model 1","Model 2", "Model 3","Model 4"))
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
                                      choices = c("Model 1","Model 2", "Model 3", "Model 4"))
                     ),
                     mainPanel(
                         # Display selected outcome
                         textOutput("outcome_message"),
                         tableOutput("outcome_selected_slice_df"),
                         plotlyOutput("tab2_plot_binary",height="auto") %>% shinycssloaders::withSpinner(),
                         plotlyOutput("tab2_plot_numeric",height="auto") %>% shinycssloaders::withSpinner()
                     )
                 )),
        #Tab 3: look up both
 tabPanel(title="Find exposures associated with a specified outcome", value="tab2", h1("Look-up outcome"),
           sidebarLayout(    
             sidebarPanel(
               h4("Select specific exposure"),
#               shinyTree("exposure_tree",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
               h5("Select specific outcome") #need comma here
#               shinyTree("outcome_tree",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
             ),
             mainPanel(
               # Display selected outcome
#               span(textOutput("exposure_message"), style="color:red"),
#               textOutput("outcome_message")
#  #             plotlyOutput("tab2_plot_binary",height="auto") %>% shinycssloaders::withSpinner(),
# #              plotlyOutput("tab2_plot_numeric",height="auto") %>% shinycssloaders::withSpinner()
            )
           ))
         )

    )