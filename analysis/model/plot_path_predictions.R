library(tidyverse)
library(gganimate)
library(RColorBrewer)

# Set working directory.
# directory <- "~/Documents/Projects/Models/ImageInference/ImageInference/"
directory <- "D:/Research/ImageInference/"
setwd(directory)

# Source the file with all of the map data.
source("stimuli/experiment_1/map_specifications.R")

# Only plot trajectories with probability higher than the threshold.
threshold <- 0.005

# Read in the full set of state inferences.
StatePredictions <- data.frame(Files=list.files("data/model/predictions/Manhattan")) %>%
  mutate(States=str_detect(Files, "States_Posterior")) %>% 
  tbl_df %>% 
  filter(States)

fullposterior <- do.call(bind_rows, 
                         lapply(StatePredictions$Files, 
                                function(x) {
                                  mutate(read_csv(paste("data/model/predictions/Manhattan/", x, sep=""),
                                                  col_types=cols()), 
                                         Trial=x)
                                }))

map_height = fullposterior$MapHeight[1]
map_width = fullposterior$MapWidth[1]

# Define how we want to plot each path.
PlotPath <- function(m) {
  posterior <- fullposterior %>%
    mutate(Trial=as.character(Trial)) %>%
    filter(Trial==paste(maps[m], "_States_Posterior.csv", sep="")) %>% 
    dplyr::select(-Trial)
  
  scene_x = posterior$Scene[1] %% map_width + 1
  scene_y = ceiling(posterior$Scene[1]/map_width)
  
  States <- posterior %>%
    filter(Probability>0) %>%
    rownames_to_column("Id") %>% 
    gather(Step, State, Obs0:(ncol(posterior)+1)) %>%
    separate(Step, into=c("Discard","Time"), sep=3) %>%
    dplyr::select(-Discard) %>%
    mutate(Time=as.numeric(Time)) %>%
    arrange(Id, Time) %>%
    mutate(y=ceiling(State/MapWidth),
           x=State%%MapWidth+1) %>% 
    mutate(Id=as.numeric(Id))
  
  myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
  sc <- scale_colour_gradientn(colours=myPalette(100), limits=c(0,15))
  
  crumbs = data.frame(x=scene_x,
                      y=scene_y,
                      filename="stimuli/experiment_1/crumbs.png")
  
  # Color path based on time.
  plot = States %>% 
    filter(Probability>=threshold) %>% 
    arrange(Probability, Time) %>%
    ggplot() +
    geom_path(aes(x=x, y=y, group=Id, color=Time, alpha=Probability+0.75),
              position=position_jitter(height=0.25, width=0.25)) + 
    geom_point(aes(x=x, y=y, color=Time, alpha=Probability+0.75)) + 
    scale_x_continuous(name="", limits=c(0, map_width+1)) +
    scale_y_reverse(name="", limits=c(map_height+1, 1)) +
    theme_void() +
    theme(legend.title=element_blank(),
          legend.position="none",
          axis.title.x=element_blank(),
          axis.text.x=element_blank(),
          axis.ticks.x=element_blank(),
          axis.title.y=element_blank(),
          axis.text.y=element_blank(),
          axis.ticks.y=element_blank())+
    sc +
    coord_fixed() +
    # geom_point(aes(x=scene_x, y=scene_y), size=6, pch=19, colour="#000000") +
    geom_image(data=crumbs, aes(x=scene_x, y=scene_y, image=filename), size=0.1) +
    geom_point(data=data.frame(xv=c(2.5, 2.5, 9.5, 9.5), 
                               yv=c(2.5, 9.5, 2.5, 9.5)), 
               aes(xv, yv), 
               size=0.1) +
    geom_rect(data=data.frame(x1=c(2.5, 8.5, 2.5), 
                              x2=c(3.5, 9.5, 3.5),
                              y1=c(2.5, 2.5, 8.5),
                              y2=c(3.5, 3.5, 9.5),
                              id=c("A", "B", "C")),
              aes(xmin=x1, xmax=x2, ymin=y1, ymax=y2, fill=id), 
              alpha=1) +
    scale_fill_manual(values=c("#FF8F66", "#8293FF", "#7AB532", "#767171"))
  
  # Add the border to the map.
  for (segment in segments[m][[1]]) {
    plot = plot + segment
  }
  
  # Add the walls to the map.
  for (wall in walls[m][[1]]) {
    plot = plot + wall
  }
  
  # Save the current map.
  ggsave(paste(directory, "data/model/visualizations/", maps[m], "_", threshold, ".pdf", 
               sep=""), 
         plot, device="pdf")
}

# Iterate through each map index.
sapply(c(1:length(maps)), PlotPath)
