tabPanel(title="Exposure Coef Plots",value="tab4",
         fluidRow(
           wellPanel(fluidRow(
                      column(3,
                             h4("1. Do you want to compare exposures on the same or different axis?"),
                             radioButtons("sameordifferentaxis",label=NULL,choices = c("Same","Different")),
                        h4("2. How many comparisons do you want to make?"),
                        radioButtons("n_comparisons",label=NULL,choices = "Load results first")
                        ),
                     column(3,
                            h4("3. Which comparisons?"),
                            actionButton("tab4GoA",label="Generate selection trees"),
                        uiOutput("exposure_trees")
                     ),
                      column(3,
                             h4("4. Which outcome class and type?"),
                             shinyTree("outcome_tree",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner()
                      ),
                     column(3,
                            h4("5. Click when ready"),
                            actionButton("tab4GoB",label="Generate plot")
                            )
                    )
                    ),
           fluidRow(
           column(width=11,align="center",
                        span(textOutput("exposure_message1"), style="color:red"),
                        span(textOutput("exposure_message2"), style="color:red"),
                        span(textOutput("exposure_message3"), style="color:red"),
                        span(textOutput("exposure_message4"), style="color:red"),
                        span(textOutput("outcome_message"), style="color:red"),
                        tableOutput("all_selected_exposures_df"),
                        textOutput("all_selected_outcomes_text"),
                        plotlyOutput("CoefficientPlot",height=1000)
                      )
                    )
           )
)
