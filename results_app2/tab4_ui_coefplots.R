tabPanel(title="Exposure Coef Plots",value="tab4",
         sidebarLayout(
           sidebarPanel(
             radioButtons("out_class_expcoef",label=NULL,choices = "Load results first")
           ),
           mainPanel()
         )
)