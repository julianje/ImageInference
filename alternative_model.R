ldata = read.csv("https://stats.idre.ucla.edu/stat/data/binary.csv")

model = glm(admit ~ gre + gpa + rank, data=ldata, family="binomial")
summary(model)

coefs = coef(model)
coefs
exp(coefs)

library(haven)
odata = read_dta("https://stats.idre.ucla.edu/stat/data/ologit.dta")
library(MASS)
odata$apply <- factor(odata$apply)
model <- polr(apply ~ pared + public + gpa, data=odata)
summary(model)

coefs = coef(model)
exp(coefs)

# New
mdata <- read_dta("https://stats.idre.ucla.edu/stat/data/hsbdemo.dta")

library(nnet)
model = multinom(prog ~ ses + write, data=mdata)
summary(model)


# Current model
data_11 = tibble()
for (map in data_9$trial) {
  data_10 = data_9 %>%
    filter(trial==map) %>%
    mutate(max_goal=ifelse(max(mean_A, mean_B, mean_C)==mean_A, 1, 
                           ifelse(max(mean_A, mean_B, mean_C)==mean_B, 2, 3)))
  data_11 = rbind(data_11, data_10)
}

data_11$max_goal = factor(data_11$max_goal)  
data_11$max_goal = relevel(data_11$max_goal, ref=1)

# model = multinom(max_goal ~ A_d + B_d + C_d + `1_d` + `2_d` + `3_d`, data=data_11)
# model = multinom(max_goal ~ A_d * B_d * C_d + `1_d`, data=data_11)
model = multinom(max_goal ~ A_d + B_d + C_d + `1_d` + A_d:`1_d` + B_d:`1_d` + C_d:`1_d`, 
                 data=data_11)
summary(model)

coefs = coef(model)
exp(coefs)

# 1 is goal A
# 2 is goal B vs. A
# 3 is goal C vs. A

z_val = summary(model)$coefficients / summary(model)$standard.errors
z_val

# Compute the p-values.
pnorm(abs(z_val), lower.tail=FALSE) * 2

# Compute the correlation.
predictions = fitted(model)
predictions

data_12 = data_11 %>%
  rename(A=mean_A, B=mean_B, C=mean_C) %>%
  dplyr::select(trial, A, B, C) %>%
  gather(goal, human, A, B, C) %>%
  do(., left_join(., gather(data.frame(trial=data_11$trial,
                   A=predictions[,1],
                   B=predictions[,2],
                   C=predictions[,3]), goal, model, A, B, C)))

# Bootstrap the CI for correlation.
# Define the bootstrap function for the bootstrap statistic.
compute_cor = function(data, indices) {
  return(cor(data$model[indices], data$human[indices]))
}

# Define the bootstrap function to simulate the data.
compute_bootstrap = function(data) {
  # Run the simulations.
  simulations = boot(data=data,
                     statistic=compute_cor,
                     R=10000)
  
  return(boot.ci(simulations, type="bca")$bca)
}

# Compute the bootstrapped 95% CIs.
cor(data_12$model, data_12$human, method="pearson")
cor = compute_bootstrap(data_12)
cor[4]
cor[5]

data_13 = data_12 %>%
  rename(model_alt=model) %>%
  left_join(dplyr::select(filter(data_8, type=="goal"), trial=map, goal=inference, 
                          model_main=model))
  
# Compute 
compute_cor_diff = function(data, indices) {
  cor_alt = cor(data$model_alt[indices], data$human[indices], method="pearson")
  cor_main = cor(data$model_main[indices], data$human[indices], method="pearson")
  return(cor_main-cor_alt)
}

compute_bootstrap = function(data) {
  # Run the simulations.
  simulations = boot(data=data,
                     statistic=compute_cor_diff,
                     R=10000)
  
  return(boot.ci(simulations, type="bca")$bca)
}

cor_diff = compute_bootstrap(data_13)
cor_diff[4]
cor_diff[5]
