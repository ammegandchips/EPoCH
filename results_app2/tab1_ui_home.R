tabPanel(title="Home",value="tab1",
         sidebarLayout(
           sidebarPanel(
             actionButton("load_results","Click to load results"),
           ),
           mainPanel(
             textOutput('Text')
           )
         )
)