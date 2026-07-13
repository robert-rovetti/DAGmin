#' Find all minimally-consistent covers of a set subject to constraints specified by a DAG
#'
#' @description
#'
#' DAGmin implements an algorithm for the enumeration of all minimally-consistent, DAG-constrained covers
#' (exact or not) of a set X formed from a family S of subsets of X.  The members of S are mapped to nodes
#' of a directed acyclic graph (DAG), and covers must meet three criteria:
#'
#' (1) The union of all subsets contained in a cover is the set X (the coverage property)
#' (2) If i -> j is an edge in the DAG, then any cover that includes subset i must also include subset j (the DAG-consistency property)
#' (3) If any subset is removed from a cover, it breaks properties (1) or (2) or both (the minimality property)
#'
#'
#'
#' @param S A matrix whose columns are the elements to be covered, and whose rows are the available subsets from which to build the covers
#' @param G The adjacency matrix specifying the DAG
#' @param delimsep The delimeter for reading a text file
#' @param maxrank The maximum rank community to consider
#' @param verbose Controls level of output
#' @return A list all minimally consistent covers and their s.flags and x.flags
#' @examples
#' dagmin(S,G)
#' @export
dagmin <- function(S, G, delimsep = ',', maxrank = NULL, verbose = TRUE) {

  #to do:  implement exactonly option

  if (!is.null(maxrank)) {if(!is.integer(maxrank) | (is.integer(maxrank) & maxrank < 1)) {stop("maxrank must be an integer >= 1")}}
  if (!is.logical(verbose) | length(verbose) != 1) {stop("verbose must be a boolean (TRUE or FALSE)")}

  S <- .getinput(S, delimsep)
  G <- .getinput(G, delimsep)

  .validate(S,G)

  covers <- .mcc_enum(S, G, verbose)

  return(list(
    covers = covers,
    S.flags = .sflags(covers, S),
    X.flags = .xflags(covers, S)
  ))

}









