function(input, output,session) {
    
    
  options(shiny.maxRequestSize = 800*1024^2)   # This is a number which specifies the maximum web request size, 
  # which serves as a size limit for file uploads. 
  # If unset, the maximum request size defaults to 5MB.
  # The value I have put here is 80MB
  
  
  output$sample_input_data = renderTable({    # show sample of uploaded data
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      input_data =  readr::read_csv(input$file1$datapath, col_names = TRUE)
    }
  })
  
  predictions<-reactive({
    
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      withProgress(message = 'Predictions in progress. Please wait ...', {
        input_data1 =  readr::read_csv(input$file1$datapath, col_names = TRUE)
        input_data1 <- inputdata1 %>% 
          mutate_if(is.numeric, as.factor)
        prediction = predict(my_model1, input_data1)
        return(prediction)
      })
    }
  })
  
  output$Prediction <- renderValueBox({
    valueBox(
      predictions(), icon = icon("virus"),
      "Predictions", 
      color = "blue"
    )
  })
  
  output$sample_input_data2 = renderTable({    # show sample of uploaded data
    inFile2 <- input$file2
    
    if (is.null(inFile2)){
      return(NULL)
    }else{
      input_data2 =  readr::read_csv(input$file2$datapath, col_names = TRUE)
      
    }
  })
  
  predictions2<-reactive({
    
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      withProgress(message = 'Predictions in progress. Please wait ...', {
        input_data2 =  readr::read_csv(input$file1$datapath, col_names = TRUE)
        input_data2 <- input_data2%>% 
          mutate_if(is.character, as.factor) %>% 
          mutate_if(is.integer, as.factor)
        
        
        input_data2 <- input_data2 %>% 
          mutate(Number.of.sexual.partners = as.integer(Number.of.sexual.partners),
                 First.sexual.intercourse = as.integer(First.sexual.intercourse),
                 Num.of.pregnancies = as.integer(Num.of.pregnancies),
                 Smokes..years. = as.numeric(Smokes..years.),
                 Smokes..packs.year. = as.numeric(Smokes..packs.year.),
                 IUD..years. = as.numeric(IUD..years.),
                 STDs..number. = as.integer(STDs..number.),
                 Age = as.integer(Age),
                 Hormonal.Contraceptives..years. = as.numeric(Hormonal.Contraceptives..years.),
                 STDs..Number.of.diagnosis = as.integer(STDs..Number.of.diagnosis)) 
        
        input_data_x <- input_data2 %>% 
          select_if(is.numeric)
        input_data_y <- input_data2 %>% 
          select_if(is.factor)
        prediction = knn(train = train_x, test = input_data_x, cl = train_y$Biopsy, k = 7)
        return(prediction)
      })
    }
  })
  
  output$Prediction2 <- renderValueBox({
    valueBox(
      predictions2(), "Predictions", icon = icon("bacterium"),
      color = "blue"
    )
  })
    
  }
  
