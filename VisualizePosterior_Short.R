library(tidyverse)
library(gganimate)
library(RColorBrewer)

posterior <- read_csv("~/Documents/Projects/Models/ImageInference/ImageInference/Posterior_States_Trial B.csv")

mapheight = posterior$MapHeight[1]
mapwidth = posterior$MapWidth[1]

scene_x = posterior$Scene[1] %% mapwidth + 1
scene_y = ceiling(posterior$Scene[1]/mapwidth)

States <- posterior %>%
  filter(Probability>0) %>%
  rownames_to_column("Id") %>% gather(Step,State,Obs0:(ncol(posterior)+1)) %>%
  separate(Step,into=c("Discard","Time"),sep=3) %>%
  dplyr::select(-Discard) %>%
  mutate(Time=as.numeric(Time),
         y=ceiling(State/mapwidth),
         x=State%%mapwidth+1) %>% mutate(Id=as.numeric(Id))

myPalette <- colorRampPalette(rev(brewer.pal(11,"Spectral")))
sc <- scale_colour_gradientn(colours = myPalette(100), limits=c(0,15))

Threshhold <- 0 #Only plot trajectories with probability higher than this:
States %>% filter(Probability>=Threshhold) %>% arrange(Probability,Time) %>%
  ggplot(aes(x,y))+
  geom_path(aes(group=Id,color=Time,alpha=Probability+0.75),
            position=position_jitter(height=0.25,width=0.25))+
  geom_point(aes(color=Time,alpha=Probability+0.75))+
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
  #geom_point(aes(x=scene_x,y=scene_y),size = 6, pch = 19,colour="#000000")+
  geom_point(data=data.frame(xv=c(2.5,2.5,9.5,9.5),yv=c(2.5,9.5,2.5,9.5)),aes(xv,yv),size=0.1)

sc <- scale_colour_gradientn(colours = myPalette(100), limits=c(min(States$Probability),max(States$Probability)))
States %>% filter(Probability>=Threshhold) %>% arrange(Probability,Time) %>%
  ggplot(aes(x,y))+
  geom_path(aes(group=Id,color=Probability,alpha=Probability+0.75),
            position=position_jitter(height=0.25,width=0.25))+
  geom_point(colour="gray")+
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
  #geom_point(aes(x=scene_x,y=scene_y),size = 6, pch = 19)+
  geom_point(data=data.frame(xv=c(2.5,2.5,9.5,9.5),yv=c(2.5,9.5,2.5,9.5)),aes(xv,yv),size=0.1)
