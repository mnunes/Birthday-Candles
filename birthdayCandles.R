ti <- proc.time()

library(ggplot2)

age  <- 1:100
repl <- 50000
sim  <- as.data.frame(matrix(NA, ncol=length(age), nrow=repl))
colnames(sim) <- as.character(age)

for (j in age){
  
  for (i in 1:repl){
    
    total <- j
    try   <- 1
    
  	while (total > 1){
      blow  <- sample(1:total, 1)
      total <- total - blow
      try   <- try + 1
    }
  
  	sim[i, j] <- try
  	
  }

}

proc.time()-ti

result <- as.data.frame(matrix(NA, ncol=4, nrow=length(age)))

q025 <- function(x) {return(quantile(x, probs=.025))}
q975 <- function(x) {return(quantile(x, probs=.975))}

result[, 1] <- age
result[, 2] <- apply(sim, 2, q025)
result[, 3] <- apply(sim, 2, mean)
result[, 4] <- apply(sim, 2, q975)

names(result) <- c("Age", "LimInf", "Average", "LimSup")

ggplot(result, aes(age)) + geom_line(aes(y=LimInf, colour="LimInf")) + geom_line(aes(y=Average, colour="Average")) + geom_line(aes(y=LimSup, colour="LimSup")) + ylim(0, 10) + theme_bw()
