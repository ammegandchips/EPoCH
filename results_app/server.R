
shinyServer(function(input, output, session) {
    outcome_hierarchy <- c("outcome_class", "outcome_subclass1", "outcome_subclass2","outcome_time","outcome_type")
    output$outcome_tree <- renderTree({
        df <- key[,outcome_hierarchy]
        outcome_tree <- dfToTree(df, outcome_hierarchy)
        #shiny tree must have a selected element to return the tree in input
        attr(outcome_tree[[1]],"stselected") <- TRUE 
        outcome_tree
    })

# Select specific outcome        
    outcome_selected_slice<- reactive({
        if (is.null(input$outcome_tree)){
            "None"
        } else{
            lapply(get_selected(input$outcome_tree,format="slices"),function(node){treeToDf(node,outcome_hierarchy)})
            }
        })
    
    output$outcome_selected_slice_df <- renderTable({
        outcome_selected_slice()
    })
    
    output$outcome_message <- renderText({
        ifelse(ncol(outcome_selected_slice()[[1]])<5,
               "Select more sub-classes (follow the branch all the way to the end)",
               "")
        })
    
# Select specific exposure    
    exposure_hierarchy <- c("exposure_class", "person_exposed","exposure_subclass", "exposure_time","exposure_type", "exposure_source")
    output$exposure_tree <- renderTree({
        df <- key[,exposure_hierarchy]
        exposure_tree <- dfToTree(df, exposure_hierarchy)
        #shiny tree must have a selected element to return the tree in input
        attr(exposure_tree[[1]],"stselected") <- TRUE 
        exposure_tree
    })
    
    exposure_selected_slice<- reactive({
        if (is.null(input$exposure_tree)){
            "None"
        } else{
            lapply(get_selected(input$exposure_tree,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
        }
    })
    
    output$exposure_selected_slice_df <- renderTable({
        exposure_selected_slice()
    })
    
    output$exposure_message <- renderText({
        ifelse(ncol(exposure_selected_slice()[[1]])<6,
               "Select more sub-classes (follow the branch all the way to the end)",
               "")
    })
    
    output$ordinal_message <- renderText({
      validate(need(ncol(exposure_selected_slice()[[1]])==6,""))
      ifelse((unlist(exposure_selected_slice()[[1]])[2]=="ordinal"&
               unlist(exposure_selected_slice()[[1]])[6]=="physical activity"&
               input$selected_exposure_dose%in%c("not ordinal","heavy","light","moderate"))|
               (unlist(exposure_selected_slice()[[1]])[2]=="ordinal"&
               unlist(exposure_selected_slice()[[1]])[6]%in%c("smoking","alcohol consumption")&
               input$selected_exposure_dose%in%c("not ordinal","somewhat active","active")),
             "You have selected an ordinal exposure, but you have not selected an appropriate dose to compare to the reference. Please check your selections.",
         "")
    })
    
    # Tab 1 plot
    
   make_tab1_plot_data<- reactive({
         key_here <- key[which(key$outcome_class == input$general_outcome_class &
                                    key$exposure_class == unlist(exposure_selected_slice()[[1]])[6] &
                                      key$person_exposed == unlist(exposure_selected_slice()[[1]])[5] &
                                      key$exposure_subclass == unlist(exposure_selected_slice()[[1]])[4] &
                                          key$exposure_time == unlist(exposure_selected_slice()[[1]])[3] &
                                               key$exposure_type == unlist(exposure_selected_slice()[[1]])[2] &
                                                   key$exposure_source == unlist(exposure_selected_slice()[[1]])[1]),]
          if(nrow(key_here)!=0){
              if(input$selected_model_tab1 == "Model 1"){ 
                models <- c("model1a","model1b")
          #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1a_extracted.RDS")
                df_a <- df_model1a
          #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1b_extracted.RDS")
                df_b <- df_model1b
                 }
              if(input$selected_model_tab1 == "Model 2"){ models <- c("model2a","model2b")
              #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")
              df_a <- df_model2a
              #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")
              df_b <- df_model2b
              }
              if(input$selected_model_tab1 == "Model 3"){ models <- c("model3a","model3b")
              #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model3a_extracted.RDS")
              df_a <- df_model3a
              #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model3b_extracted.RDS")
              df_b <- df_model3b
                           }
            if(input$selected_model_tab1 == "Model 4"){ models <- c("model4a","model4b")
            #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model4a_extracted.RDS")
            df_a <- df_model4a
            #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model4b_extracted.RDS")
            df_b <- df_model4b
             }
            df<-bind_rows(df_a,df_b)
            rm(df_a,df_b)
          }
            
         if(nrow(key_here)!=0){  
             
              source("generate_plot_data_tab1.R")
              plot_data_tab1 <- generate_plot_data_tab1(key_here,df,models,unlist(exposure_selected_slice()[[1]])[2],input$selected_exposure_dose)
              
              plot_data_tab1
         }
        })
   
  binary_numeric_both <- reactive({
    if("binary" %in% make_tab1_plot_data()$outcome_type & "numerical" %in% make_tab1_plot_data()$outcome_type){"both"
    }else{
        if("binary" %in% make_tab1_plot_data()$outcome_type){"binary"}
      else{"numerical"}
      }
    })
   
 # if(binary_numeric_both %in% c("both","binary"))
   make_tab1_plot_binary<- reactive({
   source("create_plotly_binary_tab1.R")
   binary_plot <- create_plot_tab1_binary(make_tab1_plot_data())
   })
   
   make_tab1_plot_numeric<- reactive({
     source("create_plotly_numeric_tab1.R")
     numeric_plot <- create_plot_tab1_numeric(make_tab1_plot_data())
   })
   
  height_plot_tab1_binary <- reactive({paste0(75+(length(unique(make_tab1_plot_data()$outcome[make_tab1_plot_data()$outcome_type=="binary"]))*25),"px")})
  output$height_plot_tab1_binary <- reactive({paste0(75+(length(unique(make_tab1_plot_data()$outcome[make_tab1_plot_data()$outcome_type=="binary"]))*25),"px")})
  
  height_plot_tab1_numeric <- reactive({paste0(75+(length(unique(make_tab1_plot_data()$outcome[make_tab1_plot_data()$outcome_type=="numerical"]))*25),"px")})
  output$height_plot_tab1_numeric <- reactive({paste0(75+(length(unique(make_tab1_plot_data()$outcome[make_tab1_plot_data()$outcome_type=="numerical"]))*25),"px")})
  
  
output$tab1_plot_binary <- renderPlotly({
       make_tab1_plot_binary()[[2]]})

output$tab1_plot_numeric <- renderPlotly({
  make_tab1_plot_numeric()[[2]]})


















# Tab 2 plot

make_tab2_plot_data<- reactive({
  key_here <- key[which(key$exposure_class == input$general_exposure_class &
                          key$person_exposed== input$exposed_parent &
                          key$outcome_class == unlist(outcome_selected_slice()[[1]])[5] &
                          key$outcome_subclass1 == unlist(outcome_selected_slice()[[1]])[4] &
                          key$outcome_subclass2 == unlist(outcome_selected_slice()[[1]])[3] &
                          key$outcome_time == unlist(outcome_selected_slice()[[1]])[2] &
                          key$outcome_type == unlist(outcome_selected_slice()[[1]])[1]),]
  if(nrow(key_here)!=0){
    if(input$selected_model_tab1 == "Model 1"){ 
      models <- c("model1a","model1b")
      #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1a_extracted.RDS")
      df_a <- df_model1a
      #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model1b_extracted.RDS")
      df_b <- df_model1b
    }
    if(input$selected_model_tab1 == "Model 2"){ models <- c("model2a","model2b")
    #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2a_extracted.RDS")
    df_a <- df_model2a
    #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model2b_extracted.RDS")
    df_b <- df_model2b
    }
    if(input$selected_model_tab1 == "Model 3"){ models <- c("model3a","model3b")
    #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model3a_extracted.RDS")
    df_a <- df_model3a
    #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model3b_extracted.RDS")
    df_b <- df_model3b
    }
    if(input$selected_model_tab1 == "Model 4"){ models <- c("model4a","model4b")
    #      df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model4a_extracted.RDS")
    df_a <- df_model4a
    #      df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/meta_analysis_results/metaphewas_biball_model4b_extracted.RDS")
    df_b <- df_model4b
    }
    df<-bind_rows(df_a,df_b)
    rm(df_a,df_b)
  }
  
  if(nrow(key_here)!=0){  
    
    source("generate_plot_data_tab2.r")
    plot_data_tab2 <- generate_plot_data_tab2(key_here,df,models)
    
    plot_data_tab2
  }
})

binary_numeric_both <- reactive({
  if("binary" %in% make_tab2_plot_data()$exposure_type & "numerical" %in% make_tab2_plot_data()$exposure_type){"both"
  }else{
    if("binary" %in% make_tab2_plot_data()$exposure_type){"binary"}
    else{"numerical"}
  }
})

# if(binary_numeric_both %in% c("both","binary"))
make_tab2_plot_binary<- reactive({
  source("create_plotly_binary_tab2.R")
  binary_plot <- create_plot_tab2_binary(make_tab2_plot_data())
})

make_tab2_plot_numeric<- reactive({
  source("create_plotly_numeric_tab2.R")
  numeric_plot <- create_plot_tab2_numeric(make_tab2_plot_data())
})

height_plot_tab2_binary <- reactive({paste0(75+(length(unique(make_tab2_plot_data()$exposure[make_tab2_plot_data()$exposure_type=="binary"]))*25),"px")})
output$height_plot_tab2_binary <- reactive({paste0(75+(length(unique(make_tab2_plot_data()$exposure[make_tab2_plot_data()$exposure_type=="binary"]))*25),"px")})

height_plot_tab2_numeric <- reactive({paste0(75+(length(unique(make_tab2_plot_data()$exposure[make_tab2_plot_data()$exposure_type=="numerical"]))*25),"px")})
output$height_plot_tab2_numeric <- reactive({paste0(75+(length(unique(make_tab2_plot_data()$exposure[make_tab2_plot_data()$exposure_type=="numerical"]))*25),"px")})

output$tab2_plot_binary <- renderPlotly({
  make_tab2_plot_binary()[[2]]})

output$tab2_plot_numeric <- renderPlotly({
  make_tab2_plot_numeric()[[2]]})

})
