#' Find all minimally-consistent covers of a set subject to constraints specified by a DAG
#'
#' @param S A matrix whose columns are the elements to be covered, and whose rows are the available subsets from which to build the covers
#' @param G The adjacency matrix specifying the DAG
#' @param delimsep The delimeter for reading a text file
#' @param maxrank The maximum rank community to consider
#' @param verbose Controls level of output
#' @return A list all minimally consistent covers and their s.flags and x.flags
#'
#' @usage
#' dagmin(S,G)
#'
#' @export
dagmin <- function(S, G, delimsep = ',', maxrank = NULL, verbose = FALSE) {

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









