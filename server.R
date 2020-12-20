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
        prediction
        
      })
    }
  })
  
  output$Prediction <- renderValueBox({
    valueBox(
      predictions(),
      "", 
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
  
  predictions2 <-reactive({
    
    inFile <- input$file1
    
    if (is.null(inFile)){
      return(NULL)
    }else{
      withProgress(message = 'Predictions in progress. Please wait ...', {
        input_data2 =  readr::read_csv(input$file1$datapath, col_names = TRUE)
        colnames(input_data2) = c("Age", "Number.of.sexual.partners", "First.sexual.intercourse", "Num.of.pregnancies", "Smokes","Smokes..years.",                    
                                  "Smokes..packs.year.","Hormonal.Contraceptives","Hormonal.Contraceptives..years.","IUD","IUD..years.","STDs","STDs..number.","STDs.condylomatosis", "STDs.cervical.condylomatosis",
                                  "STDs.vaginal.condylomatosis", "STDs.vulvo.perineal.condylomatosis", "STDs.syphilis","STDs.pelvic.inflammatory.disease","STDs.genital.herpes","STDs.molluscum.contagiosum","STDs.AIDS",
                                  "STDs.HIV","STDs.Hepatitis.B","STDs.HPV","STDs..Number.of.diagnosis","STDs..Time.since.first.diagnosis","STDs..Time.since.last.diagnosis","Biopsy")
        input_data2$Biopsy = as.factor(input_data2$Biopsy )
        
        levels(input_data2$Biopsy) <- c("1", "0")
        
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
  
        my_model <- readRDS("knnmodel.rds")
        predict(my_model, input_data2)
      
        if (prediction2 == "0")
        {return("No Biopsy")}
        else
        {return("Biopsy")}
      })
    }
  })
  
  output$Prediction2 <- renderValueBox({
    valueBox(
      predictions2(), "",
      color = "blue"
    )
  })
    
  }
  
