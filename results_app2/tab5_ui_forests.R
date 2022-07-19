tabPanel(title="Forest plots",value="tab5",
         sidebarLayout(
           sidebarPanel(
             h4("Select exposure and model"),
             shinyTree("exposure_tree_tab5",unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner(),
             h4("Select outcome"),
             h4("Select model")
           ),
           mainPanel()
         )
)