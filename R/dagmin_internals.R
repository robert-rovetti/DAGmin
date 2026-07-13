
#' Internal helper function for getting input data
#'
#' @param input Either an existing matrix or a filename containing matrix in delimited text format
#' @param delimsep The delimeter for reading a text file
#' @return The requested matrix
#' @examples
#' getinput(input, delimsep)
.getinput <- function(input, delimsep) {

  if (is.matrix(input)) {return(input)}
  if (!is.character(input)) {stop("Input must be a matrix or a quoted filepath.")}
  if (!file.exists(input)) {stop("Filepath does not exist.")}
  filedata <- read.delim(input, sep = delimsep, header=FALSE, row.names=NULL)
  return(as.matrix(filedata))

}



#' Internal helper function for validating input data
#'
#' @param S The family of subsets
#' @param G The adjacency matrix
#' @return No return value.  Stops program if validation not successful.
#' @examples
#' validate(S,G)
.validate <- function(S,G){

  if (dim(G)[1] != dim(G)[2])         {stop("Adjacency matrix not square.")}
  if (dim(S)[1] != dim(G)[1])         {stop("Number of subsets in S does not match number of nodes in G.")}
  if (!all(S %in% c(0,1)))            {stop("Values in S other than 0 or 1.")}
  if (!(is.integer(G) & all(G >= 0))) {stop("Values in G other than 0 or positive integers.")}
  if (!.isdag(G))                     {stop("G does not represent a valid DAG.")}
  if (!all(colSums(S)>0))             {stop("Full coverage is not possible in S (at least one column lacks a 1).")}

}


#' TBD
#'
#' @param G The DAG
#' @param i Node number
#' @return TBD
#' @examples
#' TRAVERSE(G, i)
.traverse <- function(G, i) {

  deplst <- c(i)

  for (j in 1:ncol(G)) {                                 #for each dependency j of node i
    if (G[i,j]>0) {deplst <- c(deplst, .traverse(G,j))}   #follow the rabbit down the hole
  }

  return(unique(deplst))
}


#' From a community, get the indices representing elder nodes
#'
#' @param A A community
#' @param G the DAG
#' @return Return the vector of elder nodes of A
#' @examples
#' GETELDERS(A, H)
.getelders <- function(A, G) {

  if(length(A)==1) {return (A)}

  p <- A[Rfast::colsums(G[A,A])==0]

  return(p)

}




#' Determines if one community is a superset of another
#'
#' @param a A community, possibly a subset of b
#' @param b The reference community
#' @return TRUE if a is a superset of b;  FALSE otherwise
#' @examples
#' ISSUPERSET(a, b)
.issuperset <- function(a,b) {

  #supersets in X.  a,b are 0,1-vectors whose columns are X

  mindiff <- min(a - b)

  if (mindiff > -1)     {return(TRUE)}   #a is a superset of b
  else                  {return(FALSE)}  #a is NOT a superset of b
}




#' Determines if a specified community is "well-formed"
#'
#' @param tr A community
#' @param j The rank of the community
#' @param G The DAG
#' @param P matrix P
#' @return TRUE if tr is well-formed;  FALSE otherwise
#' @examples
#' ISWELLFORMED(tr,j,G,P)
.iswellformed <- function(tr,j,G,P) {

  if (length(tr) <= 1)  {return(TRUE)}
  if (length(P)  != j)  {return(FALSE)}

  Tab <- tabulate(G[tr,tr])

  if (length(Tab) <= 1) {return(TRUE)}
  else                  {return((max(Tab[-1]) <= 1))}

}



#' User utility to determine if a specified community is a valid cover
#'
#' @param tr A community
#' @param S The subset family
#' @return TRUE if tr is a cover of S;  FALSE otherwise
#' @examples
#' ISCOVER(tr, S)
#' @export
.iscover <- function(tr, S) {

  if (length(tr)==1)    {m <- min(S[tr,])}
  else                  {m <- min(colSums(S[tr,]))}

  if (m>0)              {return(TRUE)}
  else                  {return(FALSE)}
}









#' Determines if given adjacency matrix represents a DAG
#'
#' @param G An adjacency matrix
#' @return TRUE if A represents a DAG;  FALSE otherwise
#' @examples
#' ISDAG(G)
.isdag <- function(G) {

  # works by computing the path matrix H

  n <- dim(G)[1]
  H <- matrix(0, nrow=n, ncol=n)

  for (m in 1:n) {
    HH <- diag(n)
    for (k in 1:m) {HH <- HH %*% G}
    H <- H + HH
  }

  return(all(diag(H)==0))

}


#' Returns the S-flags for a given community
#'
#' @param C A community
#' @param S The family of subsets
#' @return Returns a table with members of S marked for each cover
#' @examples
#' SFLAGS(C,S)
.sflags <- function(C,S) {

  thisfun <- function(z) {
    x = rep(0,nrow(S))
    x[z] = 1
    x
  }

  return(t(sapply(C, thisfun)))

}


#' Returns the X-flags for a given community
#'
#' @param C A community
#' @param S The family of subsets
#' @return Returns a table with members of X marked for each cover
#' @examples
#' XFLAGS(C,S)
.xflags <- function(C,S) {

  thisfun <- function(z) {
    out <- S[z,]
    rownames(out) <- z
    out <- out[order(as.numeric(z)), ]
    return(out)
  }

  return(lapply(C, thisfun))

}





# This doesn't seem to be any faster than internal sort function, will keep here for now
# call is in the form D <- D[UNIQUELIST(D)]
#
# UNIQUELIST <- function(L){
#
#   n <- length(L)
#   if (n==1) {return(1)}
#
#   m <- rep(0, n)
#
#   for (i in 1:(n-1)) {
#     if (m[i]==0) {
#       for (j in (i+1):n) {
#         if (setequal(L[[i]], L[[j]])) {
#           m[j] <- 1
#         }
#       }
#     }
#   }
#
#   s <- which(m==0)
#
#   return(s)
#
# }
