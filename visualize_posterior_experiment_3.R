library(tidyverse)
# library(gganimate)
library(RColorBrewer)
library(ggimage)

# Set working directory.
# directory <- "~/Documents/Projects/Models/ImageInference/ImageInference/"
directory <- "D:/Research/ImageInference/"
setwd(directory)

# Source the file with all of the map data.
# source("stimuli/experiment_3/map_specifications.R")

# Only plot trajectories with probability higher than the threshold.
threshold <- 0.001

# Read in the full set of state inferences.
# StatePredictions <- data.frame(Files=list.files("data/experiment_3/model/predictions/Manhattan/no_path_prior_2/")) %>%
StatePredictions <- data.frame(Files=list.files("data/experiment_3/model/predictions/Manhattan/")) %>%
  # mutate(States=str_detect(Files, "States_Posterior_one_agent")) %>%
  mutate(States=str_detect(Files, "States_Posterior_two_agents")) %>%
  tbl_df %>% 
  filter(States)

fullposterior <- do.call(bind_rows, 
                         lapply(StatePredictions$Files, 
                                function(x) {
                                  # mutate(read_csv(paste("data/experiment_3/model/predictions/Manhattan/no_path_prior_2/", x, sep=""),
                                  mutate(read_csv(paste("data/experiment_3/model/predictions/Manhattan/", x, sep=""),
                                                  col_types=cols()), 
                                         Trial=x)
                                }))

map_height = fullposterior$MapHeight[1]
map_width = fullposterior$MapWidth[1]

# Define how we want to plot each path.
PlotPath <- function(m) {
  posterior <- fullposterior %>%
    mutate(Trial=as.character(Trial)) %>%
    # filter(Trial==paste(maps[m], "_States_Posterior_one_agent.csv", sep="")) %>% 
    filter(Trial==paste("P2_2", "_States_Posterior_two_agents.csv", sep="")) %>%
    # filter(Trial==paste("P2_2", "_States_Posterior_one_agent.csv", sep="")) %>%
    # filter(Trial==paste("D2_2", "_States_Posterior_two_agents.csv", sep="")) %>%
    dplyr::select(-Trial)
  
  scene_x_0 = posterior$Scene0[1] %% map_width + 1
  scene_y_0 = ceiling(posterior$Scene0[1]/map_width)
  scene_x_1 = posterior$Scene1[1] %% map_width + 1
  scene_y_1 = ceiling(posterior$Scene1[1]/map_width)
  
  # For two agents
  temp = posterior %>%
    filter(Probability>0) %>%
    rownames_to_column("Id") %>% 
    # gather(Step, State, Obs1_21:29) %>%
    gather(Step, State, paste("Obs1", as.character(0:21), sep="_")) %>%
    select(Id, MapHeight, MapWidth, Scene0, Scene1, Probability, Step, State)
    
  States <- posterior %>%
    filter(Probability>0) %>%
    rownames_to_column("Id") %>% 
    # gather(Step, State, paste("Obs", as.character(0:21), sep="")) %>% # For one agent
    gather(Step, State, paste("Obs0", as.character(0:21), sep="_")) %>% # For two agents
    select(Id, MapHeight, MapWidth, Scene0, Scene1, Probability, Step, State) %>%
    rbind(temp) %>% # For two agents
    separate(Step, into=c("Discard", "Agent_Time"), sep=3) %>% # for two agents
    # separate(Step, into=c("Discard", "Time"), sep=3) %>% # For one agent
    separate(Agent_Time, into=c("Agent", "Time"), sep=2) %>% # For two agents
    dplyr::select(-Discard) %>%
    mutate(Time=as.numeric(Time)) %>%
    arrange(Id, Time) %>%
    mutate(y=ceiling(State/MapWidth),
           x=State%%MapWidth+1) %>% 
    mutate(Id=as.numeric(Id))
  
  myPalette <- colorRampPalette(rev(brewer.pal(11, "Spectral")))
  sc <- scale_colour_gradientn(colours=myPalette(100), limits=c(0,15))
  
  crumbs = data.frame(x_0=scene_x_0,
                      y_0=scene_y_0,
                      x_1=scene_x_1,
                      y_1=scene_y_1,
                      filename="stimuli/experiment_1/crumbs.png")
  

  # Color path based on time.
  plot = States %>% 
    # filter(Probability>=threshold) %>%
    filter(Id==26115) %>%
    arrange(Probability, Time) %>%
    ggplot() +
    geom_path(aes(x=x, y=y, group=Id, color=Time, alpha=Probability+0.75),
              position=position_jitter(height=0.1, width=0.1)) + 
    geom_point(aes(x=x, y=y, color=Time, alpha=Probability+0.75)) + 
    scale_x_continuous(name="", limits=c(0, map_width+1)) +
    scale_y_reverse(name="", limits=c(map_height+1, 1)) +
    theme_void() +
    facet_wrap(~Agent) +
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
    geom_image(data=crumbs, aes(x=scene_x_0, y=scene_y_0, image=filename), size=0.1) +
    geom_image(data=crumbs, aes(x=scene_x_1, y=scene_y_1, image=filename), size=0.1) +
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
  plot
  
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
