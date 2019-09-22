library(tidyverse)

# Loads all goal prediction files and combines them into a single

# Load everything ------------------------------------------
# directory = "~/Documents/Projects/Models/ImageInference/ImageInference/"
directory = "D:/Research/ImageInference/"

setwd(directory)

# Combines the goal prediction files for the Manhattan paths.
GoalPredictions <- data.frame(Files = list.files("data/model/predictions/Manhattan/")) %>%
  mutate(States=str_detect(Files,"Goal")) %>% tbl_df %>% filter(States)

goalposterior <- do.call(bind_rows,lapply(GoalPredictions$Files,function(x){
  mutate(read_csv(paste("data/model/predictions/Manhattan/",x,sep=""),
                  col_types=cols()),Trial=gsub("_Goal_Posterior.csv","",x))})) %>%
  mutate(GoalLetter=factor(Goal))

levels(goalposterior$GoalLetter) = c("A", "C", "B")

write.csv(goalposterior, "data/model/predictions/Manhattan/goal_predictions.csv", 
          quote=F, row.names = F)

# Combines the goal prediction files for the diagonal paths.
GoalPredictions <- data.frame(Files = list.files("data/model/predictions/diagonal/")) %>%
  mutate(States=str_detect(Files,"Goal")) %>% tbl_df %>% filter(States)

goalposterior <- do.call(bind_rows,lapply(GoalPredictions$Files,function(x){
  mutate(read_csv(paste("data/model/predictions/diagonal/",x,sep=""),
                  col_types=cols()),Trial=gsub("_Goal_Posterior.csv","",x))})) %>%
  mutate(GoalLetter=factor(Goal))

levels(goalposterior$GoalLetter) = c("A", "C", "B")

write.csv(goalposterior, "data/model/predictions/diagonal/goal_predictions.csv", 
          quote=F, row.names = F)
