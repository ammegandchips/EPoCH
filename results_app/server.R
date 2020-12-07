
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
    exposure_hierarchy <- c("exposure_class", "exposure_subclass", "exposure_time","exposure_type", "exposure_source")
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
        ifelse(ncol(exposure_selected_slice()[[1]])<5,
               "Select more sub-classes (follow the branch all the way to the end)",
               "")
    })
    
    output$ordinal_message <- renderText({
      validate(need(ncol(exposure_selected_slice()[[1]])==5,""))
      ifelse((unlist(exposure_selected_slice()[[1]])[2]=="ordinal"&
               unlist(exposure_selected_slice()[[1]])[5]=="physical activity"&
               input$selected_exposure_dose%in%c("not ordinal","heavy","light","moderate"))|
               (unlist(exposure_selected_slice()[[1]])[2]=="ordinal"&
               unlist(exposure_selected_slice()[[1]])[5]%in%c("smoking","alcohol consumption")&
               input$selected_exposure_dose%in%c("not ordinal","somewhat active","active")),
             "You have selected an ordinal exposure, but you have not selected an appropriate dose to compare to the reference. Please check your selections.",
         "")
    })
    
    # Tab 1 plot
    
   make_tab1_plot<- reactive({
         key_here <- key[which(key$outcome_class == input$general_outcome_class &
                                    key$exposure_class == unlist(exposure_selected_slice()[[1]])[5] &
                                      key$exposure_subclass == unlist(exposure_selected_slice()[[1]])[4] &
                                          key$exposure_time == unlist(exposure_selected_slice()[[1]])[3] &
                                               key$exposure_type == unlist(exposure_selected_slice()[[1]])[2] &
                                                   key$exposure_source == unlist(exposure_selected_slice()[[1]])[1]),]
          if(nrow(key_here)!=0){
              if(input$selected_model_tab1 == "Model 1"){ 
                models <- c("model1a","model1b")
                df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/results/obs_pheWAS_1a_forapp.rds")
                df_a$model <- "model1a"
                df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/results/obs_pheWAS_1b_forapp.rds")
                df_b$model <- "model1b"}
              if(input$selected_model_tab1 == "Model 2"){ models <- c("model2a","model2b")
              df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/results/obs_pheWAS_2a_forapp.rds")
              df_a$model <- "model2a"
              df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/results/obs_pheWAS_2b_forapp.rds")
              df_b$model <- "model2b"}
              if(input$selected_model_tab1 == "Model 3"){ models <- c("model3a","model3b")
              df_a<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/results/obs_pheWAS_3a_forapp.rds")
              df_a$model <- "model3a"
              df_b<-readRDS("/Volumes/MRC-IEU-research/projects/ieu2/p5/015/working/data/alspac/results/obs_pheWAS_3b_forapp.rds")
              df_b$model <- "model3b"}
            df<-bind_rows(df_a,df_b)
            rm(df_a,df_b)
          }
            
         if(nrow(key_here)!=0){  
             
              source("generate_plot_data_tab1.R")
              plot_data_tab1 <- generate_plot_data_tab1(key_here,df,models,unlist(exposure_selected_slice()[[1]])[2],input$selected_exposure_dose)
              source("create_plot_tab1.R")
              create_plot_tab1(plot_data_tab1,input$xmin_numeric_tab1,input$xmax_numeric_tab1,input$xmin_binary_tab1,input$xmax_binary_tab1)
         }
        })
   
  height_plot_tab1 <- reactive({75+(length(unique(make_tab1_plot()[[1]]$outcome))*25)})
  output$height_plot_tab1 <- reactive({75+(length(unique(make_tab1_plot()[[1]]$outcome))*25)})
  
observe({
   output$tab1_plot <- renderPlot({
       make_tab1_plot()[[2]]},height=height_plot_tab1)
    })
})

