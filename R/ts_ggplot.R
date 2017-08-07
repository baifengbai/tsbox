#' ggplot Theme for tsbox
#' 
#' @param base_family base font family
#' @param base_size base font size
#' @param ... aruments passed to subfunctions
#' @examples
#' library(tsbox)
#' df <- ts_df(ts_c(total = ldeaths, female = fdeaths, male = mdeaths))
#'  \dontrun{
#' ggplot(df, aes(x = Index, y = Value, color = Series)) + 
#'   geom_line() +
#'   ggtitle('Deaths by lung diseases', subtitle = 'United Kindom, per year') + 
#'   theme_ts() + 
#'   scale_color_tsbox() 
#' 
#' ggsave("myfig.pdf", width = 8, height = 5)
#' browseURL("myfig.pdf")
#' }
#' @export
theme_ts <- function(base_family = getOption("ts_font", ""), base_size = 12){
  # 'Source Sans Pro'  # does not work on mac
  # 'Slabo 13px'

  half_line <- base_size/2
  ggplot2::theme_minimal(base_family = base_family, base_size = base_size) +
  ggplot2::theme(
        
        # line = ggplot2::element_line(color = "grey30", size = 0.4),
        axis.title.x = ggplot2::element_blank(),
        axis.title.y = ggplot2::element_blank(),
        plot.title = ggplot2::element_text(color = "grey10", face = "bold", margin = ggplot2::margin(t = half_line * 2, b = half_line * 0.7), hjust = 0, size = ggplot2::rel(1.2)),
        plot.subtitle = ggplot2::element_text(color = "grey10", margin = ggplot2::margin(t = 0, b = half_line * 1.2), size = ggplot2::rel(0.9), hjust = 0),
        plot.caption = ggplot2::element_text(color = "grey50", margin = ggplot2::margin(t = 0, b = half_line * 1.2), size = ggplot2::rel(0.8)),

        # panel.grid = ggplot2::element_line(colour = NULL, linetype = 3), 
        # panel.grid.major = ggplot2::element_line(colour = "grey10"), 
        panel.grid = ggplot2::element_line(size = 0.2), 
        # panel.grid.major.x = ggplot2::element_blank(), 
        # panel.grid.minor = ggplot2::element_blank(),

        axis.text = ggplot2::element_text(color = "grey10", size = ggplot2::rel(0.7)),
        legend.title = ggplot2::element_blank(),
        legend.text = ggplot2::element_text(color = "grey10", size = ggplot2::rel(0.9)),
        legend.position = "bottom",
        legend.direction = "horizontal"

        # axis.ticks.x = ggplot2::element_line(color = "grey10"),
        # axis.ticks.y = ggplot2::element_blank(),
        # panel.border = ggplot2::element_blank(),
        # axis.line.x =  ggplot2::element_line()
    )
}

# #' @export
# #' @rdname theme_ts
# theme_ts_scatter <- function(){
#   theme_ts() +
#   theme(axis.title.x = element_text(margin = margin(8, 0, 0, 0), size = 10),
#         axis.title.y = element_text(margin = margin(0, 8, 0, 0), angle = 90, size = 10),
#         panel.grid.major.x = element_line(colour = "black"), 
#         axis.line.x =  element_blank(),
#         axis.ticks.x = element_blank()
#     )
# }


#' @export
#' @rdname theme_ts
colors_tsbox <- function(){
      c(
  "#4D4D4D",
"#5DA5DA",
"#FAA43A",
"#60BD68",
"#F15854",
"#B276B2",
"#DECF3F",
"#F17CB0",
"#B2912F",
"#4afff0", "#34bdcc", "#4f61a1", "#461e78", "#440a4f", "#c3fbc4",
"#85f9d6", "#79c7ad", "#a6cc7a", "#dfff7b",
"#8d7b88", "#4e414f", "#baadb5", "#2d2538", "#837a80", "#fff68f",
"#800080", "#f8b1cc", "#c29bff", "#8d0808"
)
}

#' @export
#' @rdname theme_ts
scale_color_tsbox <- function(...) {
    stopifnot(requireNamespace("ggplot2"))
    ggplot2::discrete_scale("colour", "ds", scales::manual_pal(colors_tsbox()), ...)
}

#' @export
#' @rdname theme_ts
scale_fill_tsbox <- function (...) {
    stopifnot(requireNamespace("ggplot2"))
    ggplot2::discrete_scale("fill", "ds", scales::manual_pal(colors_tsbox()), ...)
}



#' @rdname ts_plot
#' @export
ts_ggplot <- function (..., title = NULL, subtitle = NULL) {

  stopifnot(requireNamespace("ggplot2"))
  df <- ts_data.frame(ts_c(...))

  time.name = getOption("tsbox.time.name", "time")
  var.name = getOption("tsbox.var.name", "var")
  value.name = getOption("tsbox.value.name", "value")

  df <- df[!is.na(df[, value.name]), ]

  n <- NCOL(df)
  stopifnot(n > 1)
  if (n == 2){
    p <- ggplot2::ggplot(df,  ggplot2::aes_string(x = time.name, y = value.name)) 
  } else if (n > 2){

    # numeric variable 'levels'
    if (class(df[[var.name]]) %in% c("integer", "numeric")){
      df[[var.name]] <- as.character(df[[var.name]])
    }

    if (length(unique(df[[var.name]])) > 29) {
      stop(length(unique(df[[var.name]])), " time series supplied. Maximum is 29.",  call. = FALSE)
    }
    p <-  ggplot2::ggplot(df,  ggplot2::aes_string(x = time.name, y = value.name, color = var.name))
  } 
  p <- p + 
  ggplot2::geom_line() +
  ggplot2::ylab("") + 
  theme_ts() + 
  scale_color_tsbox() 

  if (!is.null(title) | !is.null(subtitle)){
    if (is.null(title)) title <- ""  # subtitle only
    p <- p + ggplot2::ggtitle(label = title, subtitle = subtitle)
  }
  p

}

# UseMethod("ts_ggplot")

# #' @export
# #' @rdname ts_plot
# #' @method ts_ggplot numeric
# ts_ggplot.numeric <- function(..., title = NULL, subtitle = NULL){
#   x <- ts_c(...)
#   ts_ggplot(ts(x), title = title, subtitle = subtitle)
# }

# #' @export
# #' @rdname ts_plot
# #' @method ts_ggplot ts
# ts_ggplot.ts <- function(..., title = NULL, subtitle = NULL){
#   df <- ts_data.frame(ts_c(...))
#   ts_ggplot_core(df, title = title, subtitle = subtitle)
# }
  
# #' @export
# #' @rdname ts_plot
# #' @method ts_ggplot xts
# ts_ggplot.xts <- function(..., title = NULL, subtitle = NULL){
#   df <- ts_data.frame(ts_c(...))
#   ts_ggplot_core(df, title = title, subtitle = subtitle)
# }

# #' @export
# #' @rdname ts_plot
# #' @method ts_ggplot data.frame
# ts_ggplot.data.frame <- function(..., title = NULL, subtitle = NULL){
#   x <- ts_data.frame(ts_c(...))
#   ts_ggplot_core(x, title = title, subtitle = subtitle)
# }

# #' @export
# #' @rdname ts_plot
# #' @method ts_ggplot data.table
# ts_ggplot.data.table <- function(..., title = NULL, subtitle = NULL){

#   # a bit a mystery that ts_data.frame.data.table is not working...
#   x <- ts_data.frame(ts_c(...))  

#   ts_ggplot_core(x, title = title, subtitle = subtitle)
# }

# ts_ggplot_core <- function(df, title = NULL, subtitle = NULL){

#   time.name = getOption("tsbox.time.name", "time")
#   var.name = getOption("tsbox.var.name", "var")
#   value.name = getOption("tsbox.value.name", "value")

#   df <- df[!is.na(df[, value.name]), ]

#   n <- NCOL(df)
#   stopifnot(n > 1)
#   if (n == 2){
#     p <- ggplot(df, aes_string(x = time.name, y = value.name)) 
#   } else if (n > 2){

#     # numeric variable 'levels'
#     if (class(df[[var.name]]) %in% c("integer", "numeric")){
#       df[[var.name]] <- as.character(df[[var.name]])
#     }

#     if (length(unique(df[[var.name]])) > 29) {
#       stop(length(unique(df[[var.name]])), " time series supplied. Maximum is 29.",  call. = FALSE)
#     }
#     p <- ggplot(df, aes_string(x = time.name, y = value.name, color = var.name))
#   } 
#   p <- p + 
#   geom_line() +
#   ylab("") + 
#   theme_ts() + 
#   scale_color_tsbox() 

#   if (!is.null(title) | !is.null(subtitle)){
#     if (is.null(title)) title <- ""  # subtitle only
#     p <- p + ggtitle(label = title, subtitle = subtitle)
#   }
#   p
# }


#' ggsave, optimized for time series
#' 
#' @param filename filename
#' @param width width
#' @param height height
#' @param device device
#' @param ... aruments passed to ggsave
#' @param open should the graph be opened?
#' @examples
#' \dontrun{
#' ts_ggplot(AirPassengers)
#' ts_save()
#' }
#' @export
ts_ggsave <- function(filename = "myfig.pdf", width = 10, height = 5, device = "pdf", ..., open = TRUE){
  filename <- gsub(".pdf$", paste0(".", device), filename)
  stopifnot(requireNamespace("ggplot2"))

  ggplot2::ggsave(filename = filename, width = width, height = height, device = device, ...)

  if (open) browseURL(filename)
}



