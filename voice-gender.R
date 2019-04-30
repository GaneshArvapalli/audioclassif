# Ganesh Arvapalli
# https://www.kaggle.com/primaryobjects/voicegender

library("e1071")
library("kernlab")
library("ggplot2")
library("ggfortify")
library("ROCR")


voiceData<-read.csv("voice.csv", header = T)

# Limit our frequency dist. features to:
# - meanFreq
# - sd
# - median
# - Q25
# - Q75
# - IQR
x<-voiceData[,c(1:6,21)]
y<-x$label

# Create train/test split
train_idx<-sample(nrow(x), replace=F, size=nrow(x)*0.8)
x.train<-x[train_idx,-ncol(x)]
y.train<-as.numeric(y[train_idx]=="male")

x.test<-x[-(train_idx),-ncol(x)]
y.test<-as.numeric(y[-(train_idx)]=="male")

# Create dataframe
dat = data.frame(x.train, y.train)

# Fit SVM model
fit <- svm(y.train ~ ., data=x.train, probability=T)

# Predict on training dataset
fit.classes <- predict(fit, x.test)
fit.prob <- predict(fit, newdata=x.test, type="prob", probability = T)

# Plot on first two dimensions
pcad <- prcomp(data.frame(x.test), scale=T)
classPlot<-ggplot(data=pcad, aes(x=PC1, y=PC2, color=(fit.classes < 0.5))) + geom_point() +
  ggtitle("Voice Data along First Two Principal Components")  + 
  scale_color_discrete(name="Gender", labels=c("Female", "Male")) +
  theme(plot.title = element_text(hjust = 0.5))
# print(classPlot)

# Plot ROC curve and calculate AUC
fit.prob.rocr <- prediction(fit.prob, y.test)
fit.perf <- performance(fit.prob.rocr, "tpr","fpr")
rocData <- data.frame(fit.perf@x.values, fit.perf@y.values)
colnames(rocData) <- c("FPR", "TPR")
rocPlot <- ggplot(data=rocData, aes(x=FPR, y=TPR)) + geom_line() +
  ggtitle("ROC of SVM Classifier on Voice Gender Data") +
  theme(plot.title = element_text(hjust = 0.5))
# print(rocPlot)
auc <-performance(fit.prob.rocr, "auc")
auc <- auc@y.values


predictGender <- function(svm_classifier, x) {
  colnames(x) <- c("meanfreq", "sd", "median", "Q25", "Q75", "IQR")
  gender<-predict(svm_classifier, x)
  print(gender)
  # Threshold determined by using external voice sample.
  # if (gender < 0.375734362365086) {
  if (gender < 0.35) {
    return(paste("Female", gender))
  } else {
    return(paste("Male", gender))
  }
}

# Example
print(predictGender(fit, x.train[1,]))

