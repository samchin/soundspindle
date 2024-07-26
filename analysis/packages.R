requiredPackages = c("lme4", "modelsummary", "sjPlot", "emmeans", "car", "psych",
                      "caret", "marginaleffects", "DHARMa", "modelsummary", "tidyverse", "ggsignif", "dplyr") #dplyr should be at the end

for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}

