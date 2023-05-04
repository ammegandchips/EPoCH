ui <- fluidPage(
  tabsetPanel(
    id="navbar",
    source("tab1_ui_home.R",local=T)$value,
    source("tab2_ui_exposures.R",local=T)$value,
    source("tab3_ui_outcomes.R",local=T)$value,
    source("tab4_ui_coefplots.R",local=T)$value,
    source("tab5_ui_forests.R",local=T)$value,
    source("tab6_ui_download.R",local=T)$value
  )
)
