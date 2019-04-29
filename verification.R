# Ganesh Arvapalli

# JackOfClubs.github.io

# 5-card draw simulator

# DataReading -------------------------------------------------------------

# https://www.openml.org/d/1567
x<-read.csv("php33Mc7a.csv", header = T)
colnames(x)<-c("S1","R1","S2","R2","S3","R3","S4","R4","S5","R5","CLASS")

suits<-c("Hearts", "Spades", "Diamonds", "Clubs")
results<-c("High card", "One pair", "Two pairs", "Three of a kind", "Straight",
           "Flush", "Full house","Four of a kind", "Straight flush", "Royal flush")

y<-x[,ncol(x)]
x<-x[,1:(ncol(x)-1)]

# Function Setup --------------------------------------------------------

areCardsInHand <- function(cards, hand) {
  present <- matrix(nrow = nrow(cards), data = 0)
  for(i in 1:dim(cards)[1]) {
    for(j in seq(from=1, to=ncol(hand), by=2)) {
      if(all(cards[i,] == hand[,j:(j+1)])) {
        present[i]<-1
        break
      }
    }
  }
  if(all(present == 1)) {
    return(T)
  }
  return(F)
}


# Analysis --------------------------------------------------------------

# print(areCardsInHand(as.matrix(rbind(c(2, 5), c(3,12))), x[1,]))

# If you won, what was the distribution of the winning hand's classification?
# Based on a single bootstrap sample of 5000

cards<-as.matrix(rbind(c(2, 1), c(2, 13)))
indices<-c()
boot_samp_idx <- sample(1:nrow(x), 5000, replace=T)
boot_samp <- x[c(boot_samp_idx),]
for(i in 1:nrow(boot_samp)) {
  if(areCardsInHand(cards, boot_samp[i,])) {
    indices<-rbind(indices, c(boot_samp_idx[i], y[boot_samp_idx[i]]))
  }
}

print(indices)
sprintf("Win Score: %f", mean(indices[,2]))

