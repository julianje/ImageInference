library(tidyverse)
library(gganimate)
library(RColorBrewer)

# Load everything ------------------------------------------
Threshhold <- 0.005 #Only plot trajectories with probability higher than this:
TrialName = "UN_DX_A"

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
  
  myPalette <- colorRampPalette(rev(brewer.pal(11,"Spectral")))
  sc <- scale_colour_gradientn(colours = myPalette(100), limits=c(0,15))
  
  # color path based on time:
  States %>% filter(Probability>=Threshhold) %>% arrange(Probability,Time) %>%
    ggplot()+
    geom_path(aes(x=x,y=y,group=Id,color=Time,alpha=Probability+0.75),
              position=position_jitter(height=0.25,width=0.25))+
    geom_point(aes(x=x,y=y,color=Time,alpha=Probability+0.75))+
    scale_x_continuous("",limits=c(0,mapwidth+1))+
    scale_y_reverse("",limits=c(mapheight+1,1))+
    theme_void()+theme(legend.title=element_blank(),
                          legend.position = "none",
                          axis.title.x=element_blank(),
                          axis.text.x=element_blank(),
                          axis.ticks.x=element_blank(),
                          axis.title.y=element_blank(),
                          axis.text.y=element_blank(),
                          axis.ticks.y=element_blank())+sc+coord_fixed()+
    geom_point(aes(x=scene_x,y=scene_y),size = 6, pch = 19,colour="#000000")+
    geom_point(data=data.frame(xv=c(2.5,2.5,9.5,9.5),yv=c(2.5,9.5,2.5,9.5)),aes(xv,yv),size=0.1)+
    geom_rect(data=data.frame(x1=c(2.5,2.5,8.5),x2=c(3.5,3.5,9.5),y1=c(2.5,8.5,2.5),y2=c(3.5,9.5,3.5),id=c("a","b","c")),
              aes(xmin=x1,xmax=x2,ymin=y1,ymax=y2,fill=id),alpha=1)+
    scale_fill_manual(values=c("#FF8F66","#8293FF","#7AB532"))
  ggsave(paste("Visualizations/",gsub("States_Posterior.csv",Threshhold,trialname),".png",sep=""))
}

sapply(unique(fullposterior$Trial),PlotPath)

