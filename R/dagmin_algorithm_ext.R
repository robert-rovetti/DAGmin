#' Find all rank-1 communities under an extended DAG
#'
#' @param S A matrix whose columns are the elements to be covered, and whose rows are the available subsets from which to build the covers
#' @param G The adjacency matrix specifying the DAG, with added extension codes
#' @param verbose Controls level of output
#' @return A list of all rank-1 communities
#' @examples
#' EXTCOMRANK1(S,G)
.extcomrank1 <- function(S, G, verbose) {

  if (verbose) {cat(sprintf("\nCalculating extended community set\n"))}

  GX <- .extended.G(G, verbose)
  n <- length(GX)
  D <- list()

  for (i in 1:n) {

    Gstar <- GX[[i]]
    Dstar <- .comrank1(S,Gstar)
    D <- c(D, Dstar)
  }

  if (verbose) {cat(sprintf("\nDistilling list ... \n"))}

  #D <- D[UNIQUELIST(D)]  #not needed, reserved for now
  D <- unique(D)

  if (verbose) {cat(sprintf("\nTotal number of unique communities =  %i \n\n", length(D)))}

  return(D)

}



#' Creates a list of all possible partitions of an extended-choice DAG
#'
#' @param G The adjacency matrix specifying the DAG, with added extension codes
#' @param verbose Controls level of output
#' @return A list of all possible standard DAGs (one for each possible partition)
#' @examples
#' EXTENDED.G(G)
.extended.G <- function(G, verbose) {

  if (verbose) {cat(sprintf("\nEnumerating partitioned DAG scenarios ...\n"))}

  #Create table of OR-classes in G, defined by entries in G greater than 1
  #for each class index (i), count the number of members in that class
  M <- sort(unique(c(G)))
  M <- M[M>1]
  Tab <- matrix(0, ncol=2)
  for (i in M){
    Tab <- rbind(Tab, c(i, sum(c(G)==i)))
  }
  Tab <- Tab[-1,]

  #create choice table
  myList <- c()
  for (i in 1:nrow(Tab)) {
    myList <- c(myList, list(which(G==Tab[i,1])))
  }
  P <- expand.grid(myList)


  #assemble into list format
  L <- list()

  for (p in 1:nrow(P)) {

    Gstar <- G
    Gstar[Gstar>1] <- 0
    Gstar[as.numeric(P[p,])] <- 1

    L <- c(L, list(Gstar))
  }

  return(L)
}













