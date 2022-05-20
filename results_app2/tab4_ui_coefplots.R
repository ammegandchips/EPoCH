tabPanel(title="Exposure Coef Plots",value="tab4",
         tabsetPanel(
           tabPanel("Select data to plot",
                    sidebarLayout(
                      sidebarPanel(
                        h4("Select comparison 1"),
                        shinyTree("exposure_tree1",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
                        h4("Select comparison 2"),
                        shinyTree("exposure_tree2",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
                        h4("Select comparison 3"),
                        shinyTree("exposure_tree3",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
                        h4("Select comparison 4"),
                        shinyTree("exposure_tree4",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
                      ),
                      mainPanel(
                        radioButtons("out_class_expcoef",label=NULL,choices = "Load results first")
                      )
                    )
           ),
           tabPanel("View plot",
                    
                    sidebarLayout(
                      sidebarPanel(
                        
                      ),
                      mainPanel(
                        span(textOutput("exposure_message1"), style="color:red"),
                        tableOutput("exposure_selected_slice_df1"),
                        span(textOutput("exposure_message2"), style="color:red"),
                        tableOutput("exposure_selected_slice_df2"),
                        span(textOutput("exposure_message3"), style="color:red"),
                        tableOutput("exposure_selected_slice_df3"),
                        span(textOutput("exposure_message4"), style="color:red"),
                        tableOutput("exposure_selected_slice_df4")
                      )
                    )
           )
         )
)