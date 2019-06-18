library(tidyverse)

# Loads all goal inferences files and combines them into a single

# Load everything ------------------------------------------
directory = "~/Documents/Projects/Models/ImageInference/ImageInference/"

setwd(directory)

GoalPredictions <- data.frame(Files = list.files("ModelPredictions/")) %>%
  mutate(States=str_detect(Files,"Goal")) %>% tbl_df %>% filter(States)

goalposterior <- do.call(bind_rows,lapply(GoalPredictions$Files,function(x){
  mutate(read_csv(paste("ModelPredictions/",x,sep=""),
                  col_types=cols()),Trial=gsub("_Goal_Posterior.csv","",x))})) %>%
  mutate(GoalLetter=factor(Goal))

levels(goalposterior$GoalLetter) = c("A", "C", "B")

write.csv(goalposterior, "Goal_Inference.csv", quote=F, row.names = F)
