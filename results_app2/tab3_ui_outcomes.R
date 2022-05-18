tabPanel(title="Outcome Manhattans",value="tab3",
         # Side bar
         sidebarLayout(
           sidebarPanel(
             radioButtons("out_class",label=NULL,choices = "Load results first"),
             radioButtons("model",label="Which model?",
                          choices = paste0("Model ",as.vector(outer(1:4, letters[1:3], paste0)))),
             actionButton("tab3Go","Visualise results")
           ),
           # Main panel
           mainPanel(
             textOutput('Text3'),
             plotlyOutput("outcomeManhattanPlot", width = "1500px", height = "800px")
           )
         )
)