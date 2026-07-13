
S <- as.matrix(read.csv('S.csv', header=FALSE, row.names=NULL))
G <- as.matrix(read.csv('G.csv', header=FALSE, row.names=NULL))

results <- dagmin(S,G)


