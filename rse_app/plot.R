library(shiny)
library(tidyverse)
library(plotly)
library(shinycssloaders)
library(shinyjs)
library(shinyTree)
library(RColorBrewer)
library(stringr)

graph_colours = "Dark2"

# Introduce a function to allow horizontal line plotting in plot_ly
hline <- function(y = 0, colour = "#898989") {
  list(type = "line", x0 = 0, x1 = 1,
       xref = "paper", y0 = y, y1 = y,
       line = list(color = colour, dash="dash")
  )
}

vline <- function(x = 0, colour = "#898989") {
  list(type = "line", x0 = x, x1 = x,
       yref = "paper", y0 = 0, y1 = 1,
       line = list(color = colour, dash="dash")
  )
}

plot_df_manhattan <- function(fig, df, x_data, label) {
  fig <- fig %>%
    add_markers(name = label, x = jitter(as.numeric(as.factor(df[[x_data]])), amount=0.3), y =-log10(df$p),
                color = as.character(df[[x_data]]),
                marker = list(size = 6), alpha=0.5,
                hoverinfo = "text",
                text = paste0("<b>Exposure class</b>: ",df$exposure_class,
                               "<br><b>Exposure type</b>: ",df$exposure_subclass_time_dose,
                               "<br><b>Outcome class</b>: ",df$outcome_class,
                               "<br><b>Outcome type</b>: ",df$outcome_subclass_time,
                               "<br><b>Cohorts</b>: ",df$cohorts,
                               "<br><b>Parent Exposed</b>: ",df$person_exposed,
                               "<br><b>Total N</b>: ",df$total_n,
                               "<br><b>Estimate</b>: ",df$est,
                               "<br><b>p value</b>: ",df$p),
                showlegend = FALSE)
}

create_manhattan_plot <- function(df, height, x_data, x_label) {
  adj_pthreshold <- 0.05/nrow(df)
  df_mother <- df[df$person_exposed=="mother",]
  df_father <- df[df$person_exposed=="father",]
  fig <- plot_ly(height = height, colors = graph_colours)
  fig <- plot_df_manhattan(fig, df_mother, x_data, label="Mother")
  fig <- plot_df_manhattan(fig, df_father, x_data, label="Father")
  lmap_mother <- length(unique(df_mother[[x_data]]))
  lmap_father <- length(unique(df_father[[x_data]]))
  fig <- fig %>% layout(shapes = list(hline(-log10(adj_pthreshold))),
                        xaxis = list(title = x_label,
                                     ticktext = str_to_sentence(unique(df[[x_data]])),
                                     tickvals = unique(as.numeric(as.factor(df[[x_data]]))),
                                     tickmode = "array"),
                        updatemenus = list(
                                    list(
                                      active = -1,
                                      type = 'buttons',
                                      buttons = list(
                                        list(label = "Mother",
                                             method = "update",
                                             args = list(list(visible = c(rep(TRUE,lmap_mother), rep(FALSE,lmap_father))))),
                                        list(label = "Father",
                                             method = "update",
                                             args = list(list(visible = c(rep(FALSE,lmap_mother), rep(TRUE,lmap_father))))),
                                        list(label = "Both",
                                             method = "update",
                                             args = list(list(visible = c(TRUE))))
                                      )
                                    )
                                  )

                        ) %>%
    config(toImageButtonOptions = list(format = "png", scale = 5))
}

create_volcano_plot <- function(df) {
  pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-0.05))]-1
  adj_pthreshold <- 0.05/nrow(df)
  adj_pthreshold_rank <- rank(-log10(df$p))[which.min(abs(df$p-adj_pthreshold))]-1

  ttext <- str_to_sentence(unique(df$person_exposed))
  df %>%
    plot_ly(height = 540, colors=graph_colours) %>%
    add_markers(x = ~est_SDM,y = ~rank(-log10(p)), color = ~outcome_class,
              marker = list(size = 6), alpha=0.5,
              hoverinfo = "text",
              text = ~paste0("<b>Exposure class</b>: ",exposure_class,
                             "<br><b>Exposure type</b>: ",exposure_subclass_time_dose,
                             "<br><b>Outcome class</b>: ",outcome_class,
                             "<br><b>Outcome type</b>: ",outcome_subclass_time,
                             "<br><b>Cohorts</b>: ",cohorts,
                             "<br><b>Total N</b>: ",total_n,
                             "<br><b>Estimate</b>: ",est,
                             "<br><b>p value</b>: ",p),
              showlegend = FALSE) %>%
    add_annotations(text = ttext,
                    x = 0.5,
                    y = 1,
                    yref = "paper",
                    xref = "paper",
                    xanchor = "left",
                    yanchor = "top",
                    showarrow = FALSE) %>%
    layout(xaxis = list(title = "Standardised effect estimate",
                        range = list(-0.75, 0.75)),
           yaxis = list(title = "Ranked -log10(P)",
                        rangemode = "tozero")) %>%
    config(toImageButtonOptions = list(format = "png", scale = 5))
}


create_coeff_plot <- function(df, ydat, title) {
  if("binary" %in% df$outcome_type){
    df[,grep(colnames(df),pattern="est|ucl|lcl")] <- exp(df[,grep(colnames(df),pattern="est|ucl|lcl")])
    xtitle <- "Odds Ratio"
    x_origin = 1
  } else {
    xtitle <- "Std Dev. Difference"
    x_origin = 0
  }

  df %>%
    plot_ly(height = max(20*length(ydat)+50, 300)) %>%
    add_trace(x = ~est,y = match(df$outcome_linker, ydat), color = ~outcome_linker,
              type = "scatter",
              hoverinfo = "text",
              error_x = list(type = "data",
                             symmetric = TRUE,
                             array = ~1.96*se),
              text = ~paste0("<b>Exposure class</b>: ",exposure_class,
                               "<br><b>Outcome class</b>: ",outcome_class,
                               "<br><b>Cohorts</b>: ",cohorts,
                               "<br><b>Total N</b>: ",total_n,
                               "<br><b>Estimate</b>: ",est,
                               "<br><b>p value</b>: ",p),
              showlegend = FALSE) %>%
    add_annotations(text = str_to_sentence(title), font = list(size=10),
                    x = x_origin, y = length(ydat)+6.5,
                    yref = "y", xref = "x",
                    xanchor = "middle", yanchor = "top",
                    showarrow = FALSE) %>%

    layout(shapes = list(vline(x_origin)),
           xaxis = list(title = xtitle)) %>%
    config(toImageButtonOptions = list(format = "png", scale = 5))
}

create_forest_plot <- function(df) {
  if (all(df$binary)) {
    df[,grep(colnames(df),pattern="est|ucl|lcl")] <- exp(df[,grep(colnames(df),pattern="est|ucl|lcl")])
    xtitle <- "Odds Ratio"
    x_origin = 1
    x_range = list(0.25, 3.5)
  } else {
    xtitle <- "Std Dev. Difference"
    x_origin = 0
    x_range = list(-1.85, 1.85)
  }

  y_range = list(-1, length(df$cohort+2))

  df %>%
    plot_ly(width=650) %>%
    add_trace(x = ~est,y = ~cohort, color = ~cohort=="meta",
              fill = ~cohort=="meta", size = ~point_size,
              type = "scatter", hoverinfo = "text",
              error_x = list(type = "data",
                             symmetric = TRUE,
                             array = ~1.96*se,
                             width=5),
              text = paste0("<br><b>Sample size</b>: ",df$n,
                            "<br><b>Estimate</b>: ",df$est,
                            "<br><b>p value</b>: ",df$p,
                            "<br><b>Upper 95% CI</b>: ",df$uci,
                            "<br><b>Lower 95% CI</b>: ",df$lci),
              showlegend = FALSE) %>%
    layout(shapes = list(vline(df$est[df$cohort=="meta"])),
           xaxis = list(title = xtitle),
           yaxis = list(title = " ", range = y_range,
                        tickfont = list(size = 16))) %>%
    config(toImageButtonOptions = list(format = "png", scale = 5))

}
