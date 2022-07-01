tabPanel(title="Exposure Coef Plots",value="tab4",
         tabsetPanel(
           tabPanel("Select data to plot",
                    fluidRow(
                      column(3,
                        h4("How many comparisons do you want to make?"),
                        radioButtons("n_comparisons",label=NULL,choices = "Load results first"),
                        actionButton("go4",label="Generate selection trees"),
                        uiOutput("exposure_trees")
                     ),
                      column(3,offset = 1,
                             h4("Select output"),
                             radioButtons("out_class_expcoef",label=NULL,choices = "Load results first")
                      ),
                     column(3,
                            h4("Press when ready"),
                            actionButton("go5",label="Generate plot")
                            )
                    )
           ),
           tabPanel("View plot",
                    
                    sidebarLayout(
                      sidebarPanel(
                        
                      ),
                      mainPanel(
                        span(textOutput("exposure_message1"), style="color:red"),
                        span(textOutput("exposure_message2"), style="color:red"),
                        span(textOutput("exposure_message3"), style="color:red"),
                        span(textOutput("exposure_message4"), style="color:red"),
                        tableOutput("all_selected_exposures_df")
                      )
                    )
           )
         )
)
