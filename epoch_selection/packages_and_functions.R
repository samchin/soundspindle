requiredPackages = c("lme4", "modelsummary", "sjPlot", "emmeans", "car", "psych",
                     "caret", "marginaleffects", "DHARMa", "modelsummary", "tidyverse", "ggsignif", "dplyr") #dplyr should be at the end

for(p in requiredPackages){
  if(!require(p,character.only = TRUE)) install.packages(p)
  library(p,character.only = TRUE)
}

clean_output <- function(df) {
  df <- df %>%
    mutate(subject = as.numeric(gsub(".*\\/([0-9]+).*", "\\1", subject))) %>%
    mutate(time = as.numeric(gsub("\\)", "", time)))
  
  return(df)
}

find_overlapping_rows <- function(df1, df2) {
  # Perform an inner join on the subject and time columns
  overlapping_rows <- df1 %>%
    inner_join(df2, by = c("subject", "time"))
  
  # Return the result
  return(overlapping_rows)
}

find_non_overlapping_rows <- function(df1, df2) {
  non_overlapping_df1 <- df1 %>%
    anti_join(df2, by = c("subject", "time"))
  
  non_overlapping_df2 <- df2 %>%
    anti_join(df1, by = c("subject", "time"))
  
  return(list(
    non_overlapping_df1 = non_overlapping_df1,
    non_overlapping_df2 = non_overlapping_df2
  ))
}