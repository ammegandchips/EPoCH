
# Load required packages -------------------------------
library(shiny)
library(shinyjs)
library(shinycssloaders)
library(shinyTree)
library(tidyverse)
library(plotly)
library(bslib)

source("data.R")
source("plot.R")

addResourcePath(prefix="img", directoryPath = "./img")

ui <- function(request) {
        fluidPage(title = "EPoCH data analysis tool", id = 'epoch',
                  theme = bs_theme(version = 4, bootswatch = "minty"),#, heading_font = font_google("Segoe UI")),
                  hr(),
        # User Input Section -------------------------------
        sidebarLayout(
                sidebarPanel( width = 3,
                        # Java scriptlet to get window dimensions
                        tags$head(tags$script('
                                var dimension = [0, 0];
                                $(document).on("shiny:connected", function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                                $(window).resize(function(e) {
                                    dimension[0] = window.innerWidth;
                                    dimension[1] = window.innerHeight;
                                    Shiny.onInputChange("dimension", dimension);
                                });
                            ')),
                        # Logo
                        tags$img(src="img/app_logo.png",
                                      width = 185, height = 60, label = tags$h4("logo")),
                        hr(),
                        actionButton("load_results","Click to load results"),
                        hr(),
                        selectizeInput(inputId = "exposure_choice",
                                       label = tags$h4("Exposure type:"),
                                       choices = NULL,
                                       selected = NULL,
                                       multiple = T,
                                       options = list(placeholder = '----------', maxItems = 1)),
                        selectizeInput(inputId = "outcome_choice",
                                       label = tags$h4("Outcome:"),
                                       choices = NULL,
                                       selected = NULL,
                                       multiple = T,
                                       width = "1200px",
                                       options = list(placeholder = '----------', maxItems = 1)),
                        selectizeInput(inputId = "model_choice",
                                       label = tags$h4("Model:"),
                                       choices = NULL,
                                       selected = NULL,
                                       multiple = T,
                                       options = list(placeholder = '----------', maxItems = 1)),
                        hr(),
                        actionButton("plot_data","Visualise data"),
                        hr(),
                        p(HTML("<p>The Exploring Prenatal influences on Childhood Health, or EPoCH, project investigates how parents’
                                lifestyles in the important prenatal period might affect the health of their children. Please visit
                                the <a href='https://epoch.blogs.bristol.ac.uk'>EPoCH website</a> for more information. </p>"),
                          style = "font-size: 85%")
                        ),
                # Output of Plot, Data, and Summary -------------------------------
                mainPanel( width = 9,
                        tabsetPanel(id = 'main_tabs',
                                tabPanel("Plot by exposure", icon = icon("chart-simple"),
                                         tabsetPanel(
                                                tabPanel("Manhattan", icon = icon("chart-simple"),
                                                    textOutput('Text1'),
                                                    plotlyOutput("exposureManhattanPlot", height="100%")
                                                        ),
                                                tabPanel("Volcano",
                                                    plotlyOutput("exposureVolcanoPlot")
                                                        )
                                                  )
                                         ),
                                tabPanel("Plot by Outcome", icon = icon("chart-simple"),
                                         tabsetPanel(
                                                tabPanel("Manhattan",
                                                    textOutput('Text2'),
                                                    plotlyOutput("outcomeManhattanPlot")
                                                        ),
                                                tabPanel("Volcano",
                                                    plotlyOutput("outcomeVolcanoPlot")
                                                        )
                                                  )
                                         ),
                                tabPanel("Plot by exposure coefficient", icon = icon("chart-simple"),
                                    tabsetPanel(
                                        tabPanel("Select comparisons",
                                            inputPanel(
                                            selectizeInput(inputId = "coeff_person",
                                                           label = tags$h4("Person exposed:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           options = list(placeholder = '----------', maxItems = 1)),
                                            selectizeInput(inputId = "coeff_subclass",
                                                           label = tags$h4("Exposure level:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           options = list(placeholder = '----------', maxItems = 1)),
                                            selectizeInput(inputId = "coeff_exptime",
                                                           label = tags$h4("Exposure time:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           options = list(placeholder = '----------', maxItems = 1))),
                                            tags$div(
                                            selectInput(width = "80%", inputId = "coeff_explink",
                                                           label = tags$h4("Exposure linker:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           multiple = F)),
                                            actionButton("add_comp","Add comparison"),
                                            hr(),
                                            uiOutput("showActiveLinkers"),
                                            actionButton("clear_comps","Clear comparisons")),
                                        tabPanel("Plots", icon = icon("chart-simple"),
                                                 plotlyOutput("exposureCoeffPlot"))
                                        )),
                                tabPanel("Forest plots", icon = icon("chart-simple"),
                                    tabsetPanel(
                                        tabPanel("Select comparisons",
                                            inputPanel(selectizeInput(inputId = "forest_person",
                                                           label = tags$h4("Person exposed:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           options = list(placeholder = '----------', maxItems = 1)),
                                            selectizeInput(inputId = "forest_subclass",
                                                           label = tags$h4("Exposure level:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           options = list(placeholder = '----------', maxItems = 1)),
                                            selectizeInput(inputId = "forest_exptime",
                                                           label = tags$h4("Exposure time:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           options = list(placeholder = '----------', maxItems = 1)),
                                            selectizeInput(inputId = "forest_outcometype",
                                                           label = tags$h4("Outcome type:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           options = list(placeholder = '----------', maxItems = 1))
                                                           ),
                                            tags$div(
                                            selectInput(width = "80%", inputId = "forest_explink",
                                                           label = tags$h4("Exposure linker:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           multiple = F),
                                            selectInput(width = "80%", inputId = "forest_outlink",
                                                           label = tags$h4("Outcome linker:"),
                                                           choices = NULL,
                                                           selected = NULL,
                                                           multiple = F))),
                                            tabPanel("Plots", icon = icon("chart-simple"),plotlyOutput("forestPlot"),
                                                     hr(),
                                                     uiOutput("showForestLinkers")),
                                            )
                                    )
                                )
                            )
                      )
)
}

server <- function(input, output, session) {

  global_data <- reactiveValues(data = NULL, data_is_loaded = FALSE,
                                coeff_linkers = NULL)

  source("data_server.R",local=T)$value
  source("plot_server.R",local=T)$value
}

# Load UI and server controls
shinyApp(ui = ui, server = server)