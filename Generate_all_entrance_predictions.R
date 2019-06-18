library(tidyverse)

# Load everything ------------------------------------------
directory = "~/Documents/Projects/Models/ImageInference/ImageInference/"

setwd(directory)

StatePredictions <- data.frame(Files = list.files("ModelPredictions/")) %>%
  mutate(States=str_detect(Files,"States_Posterior")) %>% tbl_df %>% filter(States)

fullposterior <- do.call(bind_rows,lapply(StatePredictions$Files,function(x){mutate(read_csv(paste("ModelPredictions/",x,sep=""),col_types=cols()),Trial=x)}))

mapheight = fullposterior$MapHeight[1]
mapwidth = fullposterior$MapWidth[1]

PlotPath <- function(trialname){
  posterior <- filter(fullposterior,Trial==trialname) %>% dplyr::select(-Trial)
  
  scene_x = posterior$Scene[1] %% mapwidth + 1
  scene_y = ceiling(posterior$Scene[1]/mapwidth)
  
  States <- posterior %>%
    filter(Probability>0) %>%
    rownames_to_column("Id") %>% gather(Step,State,Obs0:(ncol(posterior)+1)) %>%
    separate(Step,into=c("Discard","Time"),sep=3) %>%
    dplyr::select(-Discard) %>%
    mutate(Time=as.numeric(Time)) %>%
    arrange(Id,Time) %>%
    mutate(y=ceiling(State/MapWidth),
           x=State%%MapWidth+1) %>% mutate(Id=as.numeric(Id))
  
  Entrances <- States %>% filter(Time==0) %>% group_by(State) %>%
    summarise(Probability=sum(Probability)) %>% rename(Entrance=State) %>%
    mutate(TrialName=gsub("_States_Posterior.csv","",trialname))
  return(Entrances)
}

Entrance_posterior <- do.call(bind_rows,lapply(unique(fullposterior$Trial),PlotPath))

write.csv(Entrance_posterior, "Entrance_Inference.csv", quote=F, row.names = F)
