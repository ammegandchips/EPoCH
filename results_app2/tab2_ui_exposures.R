tabPanel(title="Plot by exposure",value="tab2",
         # Side bar
         sidebarLayout(
           sidebarPanel(
             radioButtons("exp_class",label=NULL,choices = "Load results first"),
             radioButtons("model",label="Which model?",
                          choices = paste0("Model ",as.vector(outer(1:4, letters[1:3], paste0)))),
             actionButton("tab2Go","Visualise results")
           ),
           # Main panel
           mainPanel(
             tabsetPanel(
               tabPanel("Manhattan",
             textOutput('Text2'),
             plotlyOutput("exposureManhattanPlot", width = "1500px", height = "800px")
               ),
             tabPanel("Volcano")
           )
         )
)
)