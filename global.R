library(shiny)
library(shinydashboard)
library(tidyverse)
library(nnet)

cancer <- read.csv("risk_factors_cervical_cancer.csv")

cancer <- cancer %>% 
  mutate_if(is.character, as.factor) %>% 
  mutate_if(is.integer, as.factor)


cancer <- cancer %>% 
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

cancer[cancer == "?"] <- NA


cancerfinal <- drop_na(cancer)


cancerfinal$Smokes <- factor(cancerfinal$Smokes)
cancerfinal$Hormonal.Contraceptives <- factor(cancerfinal$Hormonal.Contraceptives)
cancerfinal$IUD <- factor(cancerfinal$IUD)
cancerfinal$STDs <- factor(cancerfinal$STDs)
cancerfinal$STDs.cervical.condylomatosis <- factor(cancerfinal$STDs.cervical.condylomatosis)
cancerfinal$STDs.condylomatosis <- factor(cancerfinal$STDs.condylomatosis)
cancerfinal$STDs.vaginal.condylomatosis <- factor(cancerfinal$STDs.vaginal.condylomatosis)
cancerfinal$STDs.vulvo.perineal.condylomatosis <- factor(cancerfinal$STDs.vulvo.perineal.condylomatosis)
cancerfinal$STDs.syphilis <- factor(cancerfinal$STDs.syphilis)
cancerfinal$STDs.pelvic.inflammatory.disease <- factor(cancerfinal$STDs.pelvic.inflammatory.disease)
cancerfinal$STDs.genital.herpes <- factor(cancerfinal$STDs.genital.herpes)
cancerfinal$STDs.molluscum.contagiosum <- factor(cancerfinal$STDs.molluscum.contagiosum)
cancerfinal$STDs.AIDS <- factor(cancerfinal$STDs.AIDS)
cancerfinal$STDs.HIV <- factor(cancerfinal$STDs.HIV)
cancerfinal$STDs.Hepatitis.B <- factor(cancerfinal$STDs.Hepatitis.B)
cancerfinal$STDs.HPV <- factor(cancerfinal$STDs.HPV)

cancerfinal <- cancerfinal %>% 
  mutate(STDs..Time.since.first.diagnosis = as.integer(STDs..Time.since.first.diagnosis)) %>% 
  mutate(STDs..Time.since.last.diagnosis = as.integer(STDs..Time.since.last.diagnosis))

library(rsample)
set.seed(100)


idx <- initial_split(data = cancerfinal, strata = Biopsy, prop = 0.7)
test <- testing(idx)
train <- training(idx)

colnames(cancerfinal)


test_x <- test %>% 
  select_if(is.numeric)
test_y <- test %>%
  select_if(is.factor)
train_x <- train %>% 
  select_if(is.numeric)
train_y <- train %>% 
  select_if(is.factor)

train_x <-  scale(train_x)
test_x <- scale(test_x,
                center = attr(train_x, "scaled:center"),
                scale = attr(train_x, "scaled:scale"))

my_model <- readRDS("knnmodel.rds")

cd <- read_csv("Cleaned-Data.csv")

cd1 = data.frame(cd, check.names = T) %>% subset(select = -c(Country, None_Sympton, None_Experiencing))

cd1 <-cd1 %>% 
  mutate_if(is.numeric, as.factor)

#change the severity into a new variable, 1 = None, 2 = Mild, 3 = Moderate, 4 = Severe
cd1$severity = ifelse(cd1$Severity_None==1, 1, ifelse(cd1$Severity_Mild==1, 2, ifelse(cd1$Severity_Moderate==1, 3, ifelse(cd1$Severity_Severe==1, 4, 0))))

#change severity into factor variable
cd1$ordseverity = factor(cd1$severity, labels = c('none', 'mild', 'moderate', 'severe'), order = T)

cd1 <- cd1 %>% 
  mutate(ordseverity = as.factor(ordseverity))


cd1 = subset(cd1, select = -c(Severity_Mild, Severity_None, Severity_Severe, Severity_Moderate, severity) )


#Dividing data into training and test set
#Random sampling 
samplesize = 0.70*nrow(cd1)
set.seed(100)
index = sample(seq_len(nrow(cd1)), size = samplesize)
#Creating training and test set 
datatrain = cd1[index,]
datatest = cd1[-index,]


my_model <- readRDS("knnmodel.rds")

my_model1 <- readRDS("model.rds")




