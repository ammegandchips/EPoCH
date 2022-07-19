
shinyServer(function(input, output, session) {
  source("tab1_server_home.R",local=T)$value
  source("tab2_server_exposures.R",local=T)$value 
  source("tab3_server_outcomes.R",local=T)$value 
  source("tab4_server_coefplots.R",local=T)$value
  source("tab5_server_forests.R",local=T)$value 
})
