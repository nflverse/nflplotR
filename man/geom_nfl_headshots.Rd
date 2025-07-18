% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/geom_nfl_headshots.R
\name{geom_nfl_headshots}
\alias{geom_nfl_headshots}
\title{ggplot2 Layer for Visualizing NFL Player Headshots}
\usage{
geom_nfl_headshots(
  mapping = NULL,
  data = NULL,
  stat = "identity",
  position = "identity",
  ...,
  na.rm = FALSE,
  show.legend = FALSE,
  inherit.aes = TRUE
)
}
\arguments{
\item{mapping}{Set of aesthetic mappings created by \code{\link[ggplot2:aes]{aes()}}. If specified and
\code{inherit.aes = TRUE} (the default), it is combined with the default mapping
at the top level of the plot. You must supply \code{mapping} if there is no plot
mapping.}

\item{data}{The data to be displayed in this layer. There are three
options:

If \code{NULL}, the default, the data is inherited from the plot
data as specified in the call to \code{\link[ggplot2:ggplot]{ggplot()}}.

A \code{data.frame}, or other object, will override the plot
data. All objects will be fortified to produce a data frame. See
\code{\link[ggplot2:fortify]{fortify()}} for which variables will be created.

A \code{function} will be called with a single argument,
the plot data. The return value must be a \code{data.frame}, and
will be used as the layer data. A \code{function} can be created
from a \code{formula} (e.g. \code{~ head(.x, 10)}).}

\item{stat}{The statistical transformation to use on the data for this layer.
When using a \verb{geom_*()} function to construct a layer, the \code{stat}
argument can be used to override the default coupling between geoms and
stats. The \code{stat} argument accepts the following:
\itemize{
\item A \code{Stat} ggproto subclass, for example \code{StatCount}.
\item A string naming the stat. To give the stat as a string, strip the
function name of the \code{stat_} prefix. For example, to use \code{stat_count()},
give the stat as \code{"count"}.
\item For more information and other ways to specify the stat, see the
\link[ggplot2:layer_stats]{layer stat} documentation.
}}

\item{position}{A position adjustment to use on the data for this layer. This
can be used in various ways, including to prevent overplotting and
improving the display. The \code{position} argument accepts the following:
\itemize{
\item The result of calling a position function, such as \code{position_jitter()}.
This method allows for passing extra arguments to the position.
\item A string naming the position adjustment. To give the position as a
string, strip the function name of the \code{position_} prefix. For example,
to use \code{position_jitter()}, give the position as \code{"jitter"}.
\item For more information and other ways to specify the position, see the
\link[ggplot2:layer_positions]{layer position} documentation.
}}

\item{...}{Other arguments passed on to \code{\link[ggplot2:layer]{ggplot2::layer()}}. These are
often aesthetics, used to set an aesthetic to a fixed value. See the below
section "Aesthetics" for a full list of possible arguments.}

\item{na.rm}{If \code{FALSE}, the default, missing values are removed with
a warning. If \code{TRUE}, missing values are silently removed.}

\item{show.legend}{logical. Should this layer be included in the legends?
\code{NA}, the default, includes if any aesthetics are mapped.
\code{FALSE} never includes, and \code{TRUE} always includes.
It can also be a named logical vector to finely select the aesthetics to
display. To include legend keys for all levels, even
when no data exists, use \code{TRUE}.  If \code{NA}, all levels are shown in legend,
but unobserved levels are omitted.}

\item{inherit.aes}{If \code{FALSE}, overrides the default aesthetics,
rather than combining with them. This is most useful for helper functions
that define both data and aesthetics and shouldn't inherit behaviour from
the default plot specification, e.g. \code{\link[ggplot2:annotation_borders]{annotation_borders()}}.}
}
\value{
A ggplot2 layer (\code{\link[ggplot2:layer]{ggplot2::layer()}}) that can be added to a plot
created with \code{\link[ggplot2:ggplot]{ggplot2::ggplot()}}.
}
\description{
This geom is used to plot NFL player headshots instead
of points in a ggplot. It requires x, y aesthetics as well as a valid NFL
player gsis id.
}
\section{Aesthetics}{

\code{geom_nfl_headshots()} understands the following aesthetics (required aesthetics have no default value):
\describe{
\item{\code{x}}{The x-coordinate. Required.}
\item{\code{y}}{The y-coordinate. Required.}
\item{\code{player_gsis}}{The players' NFL gsis id. Required.}
\item{\code{alpha = NULL}}{The alpha channel, i.e. transparency level, as a numerical value between 0 and 1.}
\item{\code{colour = NULL}}{The image will be colorized with this colour. Use the special character \code{"b/w"} to set it to black and white. For more information on valid colour names in ggplot2 see \url{https://ggplot2.tidyverse.org/articles/ggplot2-specs.html?q=colour#colour-and-fill}}
\item{\code{angle = 0}}{The angle of the image as a numerical value between 0° and 360°.}
\item{\code{hjust = 0.5}}{The horizontal adjustment relative to the given x coordinate. Must be a numerical value between 0 and 1.}
\item{\code{vjust = 0.5}}{The vertical adjustment relative to the given y coordinate. Must be a numerical value between 0 and 1.}
\item{\code{width = 1.0}}{The desired width of the image in \code{npc} (Normalised Parent Coordinates).
The default value is set to 1.0 which is \emph{big} but it is necessary
because all used values are computed relative to the default.
A typical size is \code{width = 0.075} (see below examples).}
\item{\code{height = 1.0}}{The desired height of the image in \code{npc} (Normalised Parent Coordinates).
The default value is set to 1.0 which is \emph{big} but it is necessary
because all used values are computed relative to the default.
A typical size is \code{height = 0.1} (see below examples).}
}
}

\examples{
\donttest{
library(nflplotR)
library(ggplot2)
# Silence an nflreadr message that is irrelevant here
old <- options(nflreadr.cache_warning = FALSE)

df <- data.frame(
  a = rep(1:3, 3),
  b = sort(rep(1:3, 3), decreasing = TRUE),
  player_gsis = c("00-0033873",
                  "00-0026498",
                  "00-0035228",
                  "00-0031237",
                  "00-0036355",
                  "00-0019596",
                  "00-0033077",
                  "00-0012345",
                  "00-0031280"),
  player_name = c("P.Mahomes",
                  "M.Stafford",
                  "K.Murray",
                  "T.Bridgewater",
                  "J.Herbert",
                  "T.Brady",
                  "D.Prescott",
                  "Non.Match",
                  "D.Carr")
)

# set a custom fill colour for one player
df$colour <- ifelse(df$a == 2 & df$b == 2, NA, "b/w")

# scatterplot of the headshots
ggplot(df, aes(x = a, y = b)) +
  geom_nfl_headshots(aes(player_gsis = player_gsis), height = 0.2) +
  geom_label(aes(label = player_name), nudge_y = -0.35, alpha = 0.5) +
  coord_cartesian(xlim = c(0.75, 3.25), ylim = c(0.7, 3.25)) +
  theme_void()

# apply alpha as constant
ggplot(df, aes(x = a, y = b)) +
  geom_nfl_headshots(aes(player_gsis = player_gsis), height = 0.2, alpha = 0.5) +
  geom_label(aes(label = player_name), nudge_y = -0.35, alpha = 0.5) +
  coord_cartesian(xlim = c(0.75, 3.25), ylim = c(0.7, 3.25)) +
  theme_void()

# apply colour as an aesthetic
ggplot(df, aes(x = a, y = b)) +
  geom_nfl_headshots(aes(player_gsis = player_gsis, colour = colour), height = 0.2) +
  geom_label(aes(label = player_name), nudge_y = -0.35, alpha = 0.5) +
  coord_cartesian(xlim = c(0.75, 3.25), ylim = c(0.7, 3.25)) +
  scale_colour_identity() +
  theme_void()

# Restore old options
options(old)
}
}
