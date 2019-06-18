library(tidyverse)

# Loads all time inferences and merge them into a single file

# Load everything ------------------------------------------
directory = "~/Documents/Projects/Models/ImageInference/ImageInference/"

setwd(directory)

TimePredictions <- data.frame(Files = list.files("ModelPredictions/")) %>%
  mutate(States=str_detect(Files,"Time")) %>% tbl_df %>% filter(States)

timeposterior <- do.call(bind_rows,lapply(TimePredictions$Files,function(x){
  mutate(read_csv(paste("ModelPredictions/",x,sep=""),
                  col_types=cols()),Trial=gsub("_Time_Estimates.csv","",x))}))

timeposterior <- timeposterior %>% group_by(Time,Trial) %>% summarise(Probability=sum(Probability)) %>%
  ungroup %>% mutate(Time=Time*2)

timeposterior %>% ggplot(aes(Time,Probability))+geom_bar(stat="identity")+facet_wrap(~Trial)+
  theme_classic()+scale_x_continuous(limits=c(0,100))

write.csv(timeposterior, "Time_Inference.csv", quote=F, row.names = F)
