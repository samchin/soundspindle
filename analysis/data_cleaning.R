# Read CSV file

# df_wide - WIDE -------------------------------------------------

df_wide <- read.csv("qdf2.csv")

df_wide %>%  mutate(across(
  c("pid", "experience", "condition", "num_staged", "gender", "block",
    "hear_sounds", "sound_useful", "soundOrder"), as.factor))
df_wide %>%  mutate(across(c("kappa", "correct", "Duration", "TLX_mental", 
                             "TLX_physical", "TLX_pace", "TLX_success",
                             "TLX_effort", "TLX_annoyed"), as.numeric))

df_wide <- df_wide %>% filter(condition != "sound training")

df_wide <- df_wide %>% filter(pid != c("412038", "5448691", "8234878", "3395252", "879745"))

print(df_wide$pid)

datasummary_skim(df_wide)


# df_long - LONG -------------------------------------------------

df_long <- read.csv("rdf2.csv")
df_long %>%  mutate(across(c("pid", "experience", "condition", "num_staged", "gender", "userStage", "correctStage"), as.factor))
df_long %>%  mutate(across(c("timeSpent", "isCorrect"), as.numeric))

df_long <- df_long %>% filter(condition != "sound training")



correct_df <- df_long %>% filter(isCorrect == 1)

datasummary_skim(correct_df)
