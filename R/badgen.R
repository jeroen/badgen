#' Generate badges
#'
#' @export
#' @param label text for left part of the badge
#' @param status text for right part of the badge
#' @param color background for status part
#' @param labelColor background for label part
#' @param style one of 'classic' or 'flat'
#' @param scale resize badge, default size is 1
#' @examples
#' svg <- badgen("yolo", "success!", style = 'flat')
#' \dontrun{
#' writeLines(svg, 'test.svg')
#' browseURL('test.svg')
#'
#' # Convert svg to bitmap
#' rsvg::rsvg_png('test.svg', 'test.png')
#' browseURL('test.png')}
#'
#' # Add an svg icon to the badge
#' rlogo <- readLines('https://www.r-project.org/logo/Rlogo.svg')
#' svg2 <- badgen('mypkg', 'awesome', scale = 4, svg_icon = rlogo)
#'
#' \dontrun{
#' writeLines(svg2, 'test2.svg')
#' browseURL('test2.svg')}
badgen <- function(label, status = 'v1.2.3', color = 'green', labelColor = '555', style = 'classic', scale = 1, svg_icon = NULL){
  style <- match.arg(style, c("classic", "flat"))
  args <- list(
    label = label,
    status = status,
    color = color,
    labelColor = labelColor,
    style = style,
    scale = scale
  )
  if(length(svg_icon)){
    buf <- jsonlite::base64_enc(charToRaw(paste(svg_icon, collapse = '\n')))
    args$icon <- paste0('data:image/svg+xml;base64,', buf)
  }
  ctx$call('badgen', args)
}

#' @importFrom V8 v8
.onLoad <- function(lib, pkg){
  assign("ctx", V8::v8("window"), environment(.onLoad))
  ctx$source(system.file("js/badgen.js", package = pkg))
}
