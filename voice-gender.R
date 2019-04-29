# Ganesh Arvapalli
# https://www.kaggle.com/primaryobjects/voicegender

library("e1071")
library("kernlab")
library("tidyverse")
library("ggplot2")
library("ROCR")


x<-read.csv("voice.csv", header = T)
y<-x$label

# Create train/test split
train_idx<-sample(nrow(x), replace=F, size=nrow(x)*0.8)
x.train<-x[train_idx,-ncol(x)]
y.train<-y[train_idx]

x.test<-x[-(train_idx),-ncol(x)]
y.test<-y[-(train_idx)]

# Create dataframe
dat = data.frame(x.train, y.train)

# Fit SVM model
fit <- svm(y.train ~ ., data=x.train, probability=T)

# Predict on training dataset
fit.classes <- predict(fit, x.test, label.ordering=c("male", "female"))
fit.prob <- predict(fit, type="prob", newdata=x.test, probability = TRUE, label.ordering=c("male", "female"))

# Plot on first two dimensions
pcad <- prcomp(data.frame(x.test), scale=T)
classPlot<-ggplot(pcad, aes(x=PC1, y=PC2, color=fit.classes)) + geom_point() +
  ggtitle("Voice Data along First Two Principal Components") +
  theme(plot.title = element_text(hjust = 0.5))
# print(classPlot)

fit.prob.rocr <- prediction(attr(fit.prob, "probabilities")[,2], y.test, label.ordering=c("male", "female"))
fit.perf <- performance(fit.prob.rocr, "tpr","fpr")
rocData <- data.frame(fit.perf@x.values, fit.perf@y.values)
colnames(rocData) <- c("FPR", "TPR")
rocPlot <- ggplot(rocData, aes(x=FPR, y=TPR)) + geom_line() + ggtitle("ROC of SVM Classifier on Voice Gender Data") + theme(plot.title = element_text(hjust = 0.5))
print(rocPlot)
auc <-performance(fit.prob.rocr, "auc")
auc <- auc@y.values
