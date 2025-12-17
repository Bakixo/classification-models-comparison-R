
library(mice)
library(caret)
library(rpart)
library(rpart.plot)
library(dplyr)
file_path<-file.choose()
data<-read.csv(file_path,header=TRUE,sep=",")
summary(data)
cat_vars<-c("Classification")
data[cat_vars]<-lapply(data[cat_vars],as.factor)
summary(data)

imp<-mice(data,m=1,method="pmm",maxit=5,seed=123)
data_imputed<-complete(imp)

set.seed(123)
train<-data_imputed%>%sample_frac(0.8)
test<-anti_join(data_imputed,train)
summary(test)
#caret
traindex<-createDataPartition(data_imputed$Classification,p=0.8,list=FALSE)
train<-data_imputed[traindex,]
test<-data_imputed[-traindex,]

#karar agacı
tree_model<-rpart(Classification~.,data=train,method="class")
rpart.plot(tree_model,type=3,extra=101)

pred<-predict(tree_model,test,type="class")
conf_mat<-confusionMatrix(pred,test$Classification)

install.packages("randomForest")
library(randomForest)
set.seed(123)
rf_model<-randomForest(Classification~.,data=train,ntree=500,mtry=4,importance=TRUE)
pred_rf<-predict(rf_model,test)
conf_rf<-confusionMatrix(pred_rf,test$Classification)

compare_results<-data.frame(Model=c("Karar agacı","Rastgele orman")
                            ,Dogrululuk=c(conf_mat$overall["Accuracy"],conf_rf$overall["Accuracy"]),
                            Duyarlilik=c(conf_mat$byClass["Sensitivity"],conf_rf$byClass["Sensitivity"]),
                            Ozgulluk=c(conf_mat$byClass["Specificity"],conf_rf$byClass["Specificity"]),
                            kesinlik=c(conf_mat$byClass["Precision"],conf_rf$byClass["Precision"]))

varImpPlot(rf_model,main="Degisken önem grafiği")

new_data <- data.frame(
  Age = 40,
  BMI=20,
  Glucose=83,
  Insulin=19,
  HOMA=5,
  Leptin=29,
  Adiponectin=16,
  Resistin=66,
  MCP.1=519
)
num_vars <- c("Age", "BMI", "Glucose", "Insulin", "HOMA", "Leptin", "Adiponectin", "Resistin", "MCP.1")

scaled_data <- scale(data_imputed[, num_vars])

new_data[num_vars] <- scale(new_data[, num_vars],
                            center = attr(scaled_data, "scaled:center"),
                            scale = attr(scaled_data, "scaled:scale"))

new_data<- scale(new_data,center =attr(scale(data_imputed[,num_vars]),
                                       "scaled:center"),scale =attr(scale(data_imputed), "scaled:scale"))



library(e1071)
nb_model <- naiveBayes(Classification~.,data = train)
pred_nb <- predict(nb_model,test)
conf_nb <- confusionMatrix(pred_nb,test$Classification)


compare_results <- rbind(compare_results,data.frame(Model ="naive bayes",
                                                    Dogrululuk=conf_nb$overall["Accuracy"],
                                                    Duyarlilik=conf_nb$byClass["Sensitivity"],
                                                    Ozgulluk=conf_nb$byClass["Specificity"],
                                                    kesinlik=conf_nb$byClass["Precision"]))


Yorum:
  Sonuçlara göre, karar ağacı modeli en dengeli performansı gösteriyor. Doğruluğu %68 ile en yüksek model. Duyarlılık ve özgüllüğü de iyi bir seviyede. Rastgele orman modeli beklenenden düşük performans sergiliyor ve hem doğruluk hem de diğer metriklerde daha zayıf. Naive Bayes modeli ise duyarlılık açısından çok iyi ama özgüllük açısından zayıf, bu da yanlış pozitiflerin çok olabileceği anlamına geliyor. Genel olarak, daha dengeli ve güvenilir sonuç için karar ağacı modeli tercih edilmelidir.
