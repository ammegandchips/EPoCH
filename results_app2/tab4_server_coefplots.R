##############################################################
# Outcome radio buttons are defined under tab1_server_home.R #
##############################################################

###########################
# Generate exposure trees #
###########################

# Create exposure hierarchy for trees
exposure_hierarchy <- c("exposure_class", "person_exposed","exposure_subclass", "exposure_time","exposure_type", "exposure_source","model", "exposure_dose")
tree_names <- paste0("exposure_tree",1:4)
all_trees_and_headings <- vector("list",4)

# When number of comparisons selected and GO button pressed, generate the required number of shiny trees
observeEvent(input$tab4GoA,{
  if(input$load_results==0){
    showModal(modalDialog("You must load the data first"))
  }else{
  all_trees_and_headings <- all_trees_and_headings[1:as.numeric(input$n_comparisons)]
  
  # Exposure variable 1
  output$exposure_tree1 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })
  
  # Exposure variable 2
  output$exposure_tree2 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })

  # Exposure variable 3
  output$exposure_tree3 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })
  
  # Exposure variable 4
  output$exposure_tree4 <- renderTree({
    df <- loaded_data()$all_res[,exposure_hierarchy]
    exposure_tree <- dfToTree(df, exposure_hierarchy)
    #shiny tree must have a selected element to return the tree in input
    attr(exposure_tree[[1]],"stselected") <- TRUE
    exposure_tree
  })

  for(i in 1:length(all_trees_and_headings)){
    all_trees_and_headings[[i]][[1]] = h4(paste0("Select comparison ",i))
    all_trees_and_headings[[i]][[2]] = shinyTree(tree_names[i],unique=TRUE,theme="proton") %>% shinycssloaders::withSpinner()
  }
  
  
output$exposure_trees <- renderUI({
      tagList(all_trees_and_headings)
      })
}
})

##################################
# Summarise selected comparisons #
##################################

exposure_selected_slice1<- reactive({
  lapply(get_selected(input$exposure_tree1,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
})

output$exposure_message1 <- renderText({
  ifelse(ncol(exposure_selected_slice1()[[1]])<7,
         "Select more sub-classes for variable 1 (follow the branch all the way to the end)",
         "")
})

exposure_selected_slice2<- reactive({
  if (input$load_results==1){
    if(2 %in% 1:input$n_comparisons){
    lapply(get_selected(input$exposure_tree2,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
  } else{
    "None"
  }
  }
})

output$exposure_message2 <- renderText({
  ifelse(ncol(exposure_selected_slice2()[[1]])<7,
         "Select more sub-classes for variable 2 (follow the branch all the way to the end)",
         "")
})

exposure_selected_slice3<- reactive({
  if (input$load_results==1){
    if(3 %in% 1:input$n_comparisons){
      lapply(get_selected(input$exposure_tree3,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
    } else{
      "None"
    }
  }
})

output$exposure_message3 <- renderText({
  ifelse(ncol(exposure_selected_slice3()[[1]])<7,
         "Select more sub-classes for variable 3 (follow the branch all the way to the end)",
         "")
})

exposure_selected_slice4<- reactive({
  if (input$load_results==1){
    if(4 %in% 1:input$n_comparisons){
      lapply(get_selected(input$exposure_tree4,format="slices"),function(node){treeToDf(node,exposure_hierarchy)})
    } else{
      "None"
    }
  }
})

output$exposure_message4 <- renderText({
  ifelse(ncol(exposure_selected_slice4()[[1]])<7,
         "Select more sub-classes for variable 4 (follow the branch all the way to the end)",
         "")
})

all_selected_exposures <- reactive({
  all_exposures_list <-list(exposure_selected_slice1(),
                            exposure_selected_slice2(),
                            exposure_selected_slice3(),
                            exposure_selected_slice4())
  all_exposures_list <- lapply(all_exposures_list,as.data.frame)
  
  all_exposures_list <- lapply(all_exposures_list,function(x){
    x<-rev(x)
    colnames(x) <- exposure_hierarchy[1:ncol(x)]
    x
  })
  
  all_exposures<-bind_rows(all_exposures_list)
  all_exposures[all_exposures=="None"]<-NA
  all_exposures<-as.data.frame(t(all_exposures))
  row.names(all_exposures)<-exposure_hierarchy[1:nrow(all_exposures)]
  colnames(all_exposures)<-paste("Comparison",1:4)
  all_exposures
})

output$all_selected_exposures_df <-renderTable({
  all_selected_exposures()
  },
  rownames=TRUE)


##################
# COEF PLOT CODE #
##################

## when the user clicks "Generate plot"...
observeEvent(input$tab4GoB,{
  ## if the data hasn't been loaded, they get an error message...
  if(input$load_results==0){
    showModal(modalDialog("You must load the data first"))
    reset("tab4GoB")
  }
    # if the data have been loaded...
    if(input$load_results==1){
      print("You've loaded the data!")
      #check whether the trees have been generated
      if(input$tab4GoA==0){
        showModal(modalDialog("You must generate the trees first"))
        reset("tab4GoB")
      }
      if(input$tab4GoA==1){
        print("you've generated the trees!!!")
        print(input$n_comparisons)
        # we make a list of the commands needed to find out whether all the trees have had nodes selected right to the end of the branches
        tmp_list <- unlist(lapply(1:input$n_comparisons,function(i){paste0("try(ncol(exposure_selected_slice",i,"()[[1]])<7)")}))
        print(tmp_list)
        #then we evaluate those commands (giving a logical vector telling us whether any of them are incomplete)
        tmp_list <- unlist(lapply(tmp_list,function(x){eval(parse(text=x))}))
        print(tmp_list)
        #if at least one of the trees is incomplete, an error message is generated
          if(TRUE %in% tmp_list){
          showModal(modalDialog("You need to select more nodes of the tree(s)"))
          reset("tab4GoB")
  ## but if that's all ok, they get a message saying that the visualisations are being generated...
  }else{
    showModal(modalDialog("Visualisations are shown on the next tab"))
    ## then the visualisations appear...
    output$CoefficientPlot <- renderPlotly({
      df <- all_selected_exposures()
      print(dim(df))
      print(df)
      models <- as.character(df["model",])
      print(models)
      df<-as.data.frame(t(df))
      print(df)
      exposure_linkers <- paste(df$exposure_class,df$exposure_subclass,df$exposure_time,df$person_exposed,df$exposure_type,df$exposure_source,sep="-")
      if("exposure_dose" %in% colnames(df)){
      print(df$exposure_dose)
      df$exposure_dose[is.na(df$exposure_dose)]<-"NA"
      }
      if("exposure_dose" %in% colnames(df)==F){
        df$exposure_dose<-"NA"
      }
      exposure_linkers <- paste(exposure_linkers,df$exposure_dose)
      exposure_linkers <- exposure_linkers[is.na(models)==F]
      print(exposure_linkers)
      dat <- lapply(1:length(exposure_linkers),function(i){
        loaded_data()$all_res[which(loaded_data()$all_res$model==models[i]&
                                      loaded_data()$all_res$exposure_linker==exposure_linkers[i]),]
      })
      names(dat) <- paste("Comparison",1:length(exposure_linkers))
      dat<-bind_rows(dat,.id="comparison")
      print(dim(dat))
      dat <- dat[dat$outcome_class==input$out_class_expcoef,]
      print(dim(dat))
      print(head(dat))
      print(table(dat$comparison))
      dat$lcl <- dat$est-(1.96 * dat$se)
      dat$ucl <- dat$est+(1.96 * dat$se)
      coef_plot <- ggplot(dat,aes(x=est,y=outcome_linker,xmin=lcl,xmax=ucl))+
        geom_pointrange()+
        facet_grid(.~comparison)
      ggplotly(coef_plot)
      })
  }
      }
    }
})
