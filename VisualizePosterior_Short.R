library(tidyverse)
library(gganimate)
library(RColorBrewer)

# Load everything ------------------------------------------
Threshhold <- 0.0003 #Only plot trajectories with probability higher than this:
TrialName = "Trial C"

directory = "~/Documents/Projects/Models/ImageInference/ImageInference/"

statesfile = paste(directory,TrialName,"_States_Posterior.csv",sep="")
goalfile = paste(directory,TrialName,"_Goal_Posterior.csv",sep="")
timefile = paste(directory,TrialName,"_Time_Estimates.csv",sep="")

posterior <- read_csv(statesfile,col_types = cols())
goals <- read_csv(goalfile, col_types = cols())
time <- read_csv(timefile, col_types = cols())

mapheight = posterior$MapHeight[1]
mapwidth = posterior$MapWidth[1]

# Visualize goal inference -------------------------------
goals %>% ggplot(aes(Goal,Probability))+geom_bar(stat="identity")+
  theme_classic()+scale_y_continuous(limits=c(0,1.01))+
  theme(aspect.ratio=1)+ggtitle(TrialName)

# Visualize time -----------------------------------
time %>% group_by(Time) %>% summarise(Probability=sum(Probability)) %>%
  ggplot(aes(Time,Probability))+geom_bar(stat="identity")+
  theme_classic()+scale_y_continuous(limits=c(0,1.01),breaks=c(0,0.5,1))+
  scale_x_continuous(limits=c(0,100))+
  theme(aspect.ratio=1)+ggtitle(paste("Time estimate: ",TrialName,sep=""))

# Visualize starting pont -------------------------------
States %>% filter(Time==0) %>% group_by(State) %>%
  summarise(Probability=sum(Probability)) %>%
  ggplot(aes(factor(State),Probability))+geom_bar(stat="identity")+
  theme_classic()+scale_x_discrete("Starting point")+
  scale_y_continuous("Probability",limits=c(0,1.01))+
  ggtitle("Inferred starting point")

# Visualize inferred path --------------------------------
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

# color path based on probability
scb <- scale_colour_gradientn(colours = myPalette(100), limits=c(min(States$Probability),max(States$Probability)))
States %>% filter(Probability>=Threshhold) %>% arrange(Probability,Time) %>%
  ggplot()+
  geom_path(aes(x=x,y=y,group=Id,color=Probability,alpha=Probability+0.75),
            position=position_jitter(height=0.2,width=0.2))+
  geom_point(aes(x=x,y=y),colour="gray")+
  scale_x_continuous("",limits=c(0,mapwidth+1))+
  scale_y_reverse("",limits=c(mapheight+1,1))+
  theme_void()+theme(legend.title=element_blank(),
                     legend.position = "none",
                     axis.title.x=element_blank(),
                     axis.text.x=element_blank(),
                     axis.ticks.x=element_blank(),
                     axis.title.y=element_blank(),
                     axis.text.y=element_blank(),
                     axis.ticks.y=element_blank())+scb+coord_fixed()+
  geom_point(aes(x=scene_x,y=scene_y),size = 5, colour="#22231E")+
  geom_point(data=data.frame(xv=c(2.5,2.5,9.5,9.5),yv=c(2.5,9.5,2.5,9.5)),aes(xv,yv),size=0.1)+
  geom_rect(data=data.frame(x1=c(2.5,2.5,8.5),x2=c(3.5,3.5,9.5),y1=c(2.5,8.5,2.5),y2=c(3.5,9.5,3.5),id=c("a","b","c")),
            aes(xmin=x1,xmax=x2,ymin=y1,ymax=y2,fill=id),alpha=1)+
  scale_fill_manual(values=c("#FF8F66","#8293FF","#7AB532"))

# Visualize density of actions over time:
scc <- scale_fill_gradientn(colours = myPalette(100), limits=c(0,1))
States %>% group_by(Time,y,x) %>% summarise(Probability=sum(Probability)) %>%
  ggplot(aes(x,y,fill=Probability))+geom_tile()+facet_wrap(~Time)+
  scale_x_continuous("",limits=c(2,9.51))+
  scale_y_reverse("",limits=c(10.5,2))+scc+
  geom_hline(yintercept=2:9+0.5)+
  geom_vline(xintercept=2:9+0.5)+
  geom_text(aes(x,y,label=round(Probability,2)))
