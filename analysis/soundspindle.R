source("packages.R")
source("data_cleaning.R")


my_theme <- theme_minimal() + theme(plot.title = element_text(size=20,hjust = 0.5),
                  axis.title.x = element_text(size = 20),
                  axis.title.y = element_text(size = 20),
                  legend.title = element_text(size = 18),
                  legend.text = element_text(size = 15),
                  legend.position='top', 
                  legend.justification='center',
                  legend.direction='horizontal',
                  axis.text = element_text(size = 16, color = "grey30"))

#FIG:kappa_exp
ggplot(df_wide, aes(x = as.factor(num_staged), y =kappa, fill = as.factor(condition))) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Kappa by Experience Level",
       y = "Kappa") +
  scale_x_discrete("Number of Polysomnograms Scored", labels=c("More than 80" =  "80+")) +
  scale_fill_discrete("", labels = c("sound" = "No Sound", "visual only" = "Sound")) +
  geom_errorbar(stat="summary", width=.2, position=position_dodge(.9)) +
  geom_signif(
    y_position = c(0.4), xmin = c(0.7), xmax = c(1.3), 
                   annotation = c("*"), tip_length = 0.03, map_signif_level = TRUE, textsize= 11) +
  my_theme
ggsave("Images/kappa_exp.png", width = 6.10, height = 6.48, units = "in")


# KAPPA DIFF - REGRESSION -------------------------------------------------
df_diff <- df_wide %>%
  group_by(pid) %>%
  mutate(kappa_difference = kappa[condition == "sound"] - kappa[condition == "visual only"]) %>%
  ungroup()

df_diff$num_staged <- replace(df$num_staged, df$num_staged == "More than 80", "80+")
datasummary_skim(df_diff)

df_diff <- df_diff[!duplicated(df_diff$pid), ]

datasummary_skim(df_diff)

exp_kappa_diff <- lm(
  kappa_difference ~ num_staged,
  data = df_diff)

summary(exp_kappa_diff)
datasummary_skim(df_diff)
# view(df_diff$kappa_difference)

p1 <- plot_model(exp_kappa_diff, type = "pred", terms = c("num_staged"), 
           show.data = TRUE, dot.size = 4, show.p = TRUE, 
           ci.lvl = NA, show.values = TRUE, pred.type = "fe",
           title = "Regression of Num Staged on Kappa Difference ", 
           base = theme_minimal())


#FIG:kappa_diff_reg
p1  +  labs(title = "Effect of Sound Varies by \nSleep Staging Experience", 
                  y = "Kappa Diff (sound-visual)", x = "Number of Polysomnograms Scored") + my_theme

ggsave("Images/kappa_diff_reg.png", width = 6.10, height = 6.48, units = "in")


# regress on CORRECT (WIDE) --------------------
# wide <- lm(
#   correct ~ condition + num_staged,
#   data = df_wide)
# 
# summary(wide)
# 
# #regress on KAPPA (WIDE) ------------------------------------------------
# kappa_wide<- lm(
#   kappa ~ condition + num_staged,
#   data = df_wide)
# summary(kappa_wide)

# KAPPA DIFF - WILCOXON SIGNED RANK TEST ---------------------------
visual_only <- df_wide %>% filter(condition == "visual only")


audio_visual <- df_wide %>% filter(condition == "sound")

# datasummary_skim(visual_only)
result = wilcox.test(visual_only$kappa, audio_visual$kappa, paired = TRUE)
result     

visual_only_new <- visual_only %>% filter(num_staged  == "1-10")
audio_visual_new <- audio_visual %>% filter(num_staged == "1-10")

datasummary_skim(visual_only_new)

sig_result = wilcox.test(visual_only_new$kappa, audio_visual_new$kappa, paired = TRUE)
sig_result 

# colnames(df_wide)

TLX <- c("TLX_effort", "TLX_mental", "TLX_annoyed", "TLX_pace", "TLX_success", "TLX_physical")
# NASA TLX -- WILCOXON SIGNED RANK

for(i in seq_along(TLX)){
  print(TLX[i])
  # result = wilcox.test(visual_only[[ TLX[i] ]], audio_visual[[ TLX[i] ]], paired = TRUE)
  result = t.test(visual_only[[ TLX[i] ]], audio_visual[[ TLX[i] ]], paired = TRUE)
  print(result)
  
}


tlx_df <- df_wide %>%
  pivot_longer(
    cols = starts_with("TLX_"),
    names_to = "TLX",
    values_to = "rating"
  )

tlx_df$TLX <- factor(tlx_df$TLX, levels = c("TLX_mental", "TLX_physical", "TLX_pace", "TLX_success", "TLX_effort",  "TLX_annoyed"))

p <- ggplot(tlx_df, aes(y= rating, x=TLX, fill = condition))

p + geom_boxplot() + labs(title = "TLX Ratings By Condition", y = "Rating") +
  scale_fill_discrete("", labels = c("visual only" = "No Sound", "sound" = "Sound")) +
  scale_x_discrete("TLX Axis", 
                   labels=c("TLX_effort" = "Effort", "TLX_mental" = "Mental \nDemand", 
                            "TLX_annoyed" = "Frustration ", "TLX_pace" = "Temporal \n Demand",
                            "TLX_success" = "Performance",
                            "TLX_physical" = "Physical \n Demand" )) + theme_minimal() + 
  theme(plot.title = element_text(size=20,hjust = 0.5),
        axis.title.x = element_text(size = 20, margin = margin(t = 15, r = 0, b = 0, l = 0)),
        axis.title.y = element_text(size = 20),
        legend.title = element_text(size = 18),
        legend.text = element_text(size = 14),
        legend.position='top', 
        legend.justification='center',
        legend.direction='horizontal',
        axis.text = element_text(size = 14, color = "grey30"))


ggsave("Images/TLX_box.png", width = 7.5, height = 6.48, units = "in")



# CORRECT STAGE-----------------------------------------------------------

# plot_frq(df_long$correctStage, type = c("histogram"), show.values = FALSE, show.n = FALSE, show.prc = FALSE)

datasummary_skim(df_long)

conf_matrix <- confusionMatrix(data = as.factor(df_long$userStage), reference = as.factor(df_long$correctStage))
conf_matrix

correct <- lme4::glmer(
  isCorrect ~ sound + num_staged + (1 | pid),
  data = df_long,
  family = binomial(link = "logit"),  #using binomial
)

summary(correct)

plot_correct = plot_model(correct, type = "pred", terms = c("sound"), 
           show.data = FALSE, dot.size = 0.01, 
           pred.type = "fe", jitter = 0.02,
           title = "Linear Mixed Model of Adding Sound to Correct", 
           base = theme_minimal())  

plot_correct

plot_predictions(correct, condition = c("sound"))

plot_predictions(correct, condition = c("sound")) + 
  scale_x_discrete(breaks = 0:1,  labels=c("No Sound \n(visual-only)", "Sound \n(audio-visual)")) + 
  labs(title = "Predictions of General Linear Mixed Effects \nModel of Sound on Likelihood of Correctness", 
       y = "Likelihood of Correct Response", x = "Presence of Sound") +
  theme(plot.title = element_text(size=22),
        axis.title.x = element_text(size = 20),
        axis.title.y = element_text(size = 20),
        axis.text = element_text(size = 21, color = "grey60"))


correct %>% emmeans::emmeans(~ sound, type="response") %>% pairs(type = "response")
correct %>% emmeans::emmeans(~ sound, type="response")

# [VOID] EXPERIENCE LEVEL ON KAPPA -------------------------------------------------

exp_kappa <- lmer(
  kappa ~ condition + (1|pid) + (1 | num_staged),
  data = df,
)

summary(exp_kappa)

plot_model(exp_kappa, type = "pred", terms = c("num_staged", "condition"), 
           show.data = TRUE, dot.size = 1, show.intercept = TRUE,
           pred.type = "fe", jitter = 0.02,
           title = "Linear Mixed Model of Adding Sound to Correct", 
           base = theme_minimal())

# plot_predictions(exp_kappa, condition = c("condition"))


# CORRECT STAGE W/ STAGE INTERACTION -----------------------------------------------------------

df_long$correctStage <- as.factor(df_long$correctStage)
  
# correct <- lme4::glmer(
  # isCorrect ~ sound*correctStage +  (1 | pid) + (1|num_staged),
  # isCorrect ~ 1 + sound + correctStage + sound:correctStage +  (1 + experience| pid) + (1|num_staged),
  #^ adding experience is a random slope
  
  # isCorrect ~ 1 + sound + correctStage + sound:correctStage +  (1 | pid) + (1|num_staged),
  
  # data = df_long,
  # family = binomial(link = "logit"),  #using binomial)

summary(correct)

plot_model(correct, type = "pred", terms = c("sound","correctStage"), 
           show.data = FALSE, dot.size = 0.01, 
           pred.type = "fe", jitter = 0.02,
           title = "Linear Mixed Model of Adding Sound to Correct", 
           base = theme_minimal())

plot_predictions(correct, condition = c("sound", "correctStage"))


#correct %>% emmeans::emmeans(~ sound, type="response") %>% pairs(type = "response")
preds <- correct %>% emmeans::emmeans( ~ sound | correctStage, type="response") 
preds
preds2 <- contrast(preds, method = "pairwise") #%>% summary(infer = TRUE)
preds2 <- rbind(preds2)
diff <- contrast(preds2, method = "pairwise") %>% summary(infer = TRUE)
diff

# RXN TIME -----------------------------------------------------------

rxn_time <- lme4::glmer(
  timeSpent ~ (sound*correctStage) + (1 | pid) + (1|num_staged), data = correct_df,
  family = gaussian(link="log"))
summary(rxn_time)

plot(rxn_time)

hist(df_long$timeSpent[df_long$timeSpent], breaks=100)


plot_predictions(rxn_time, condition = c("sound"))
plot_predictions(rxn_time, condition = c("sound", "correctStage"))
datasummary_skim(df_long)


# GRAPH FOR RANK CORRECT TIME ---------------------------

#FIG:percent_correct
ggplot(df_long, aes(x = as.factor(correctStage), y =isCorrect, fill = as.factor(sound))) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Percent Correct Response by Sleep Stage",
       y = "Likelihood of Correct Response") +
   scale_x_discrete("Sleep Stage", labels=c("0" = "WAKE", "1" = "N1",
                                                  "2" = "N2", "3" = "N3", "5" = "REM")) +
   scale_fill_discrete("", labels = c("0" = "No Sound", "1" = "Sound")) +
   my_theme
ggsave("Images/percent_correct.png", width = 6.10, height = 6.48, units = "in")

#FIG:correct_combined
ggplot(df_long, aes(x = as.factor(sound), y =isCorrect, fill = as.factor(sound))) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Percent Correct Response",
       y = "Likelihood of Correct Response") +
  scale_x_discrete("Condition", labels=c("0" = "No Sound \n(visual only)", "1" = "Sound")) +
  my_theme + theme(legend.position="none")
ggsave("Images/correct_combined.png", width = 6.10, height = 6.48, units = "in") 

datasummary_skim(df_long)

# WILCOXON SIGNED RANK REACTION TIME BY STAGE---------------------------

for(i in 0:5){

mean_cor_stage_visual <- df_long %>% 
  filter(sound == 0) %>%
  filter(correctStage == i) %>%
  group_by(pid) %>%
  dplyr::summarise(n = n(), cor = mean(isCorrect))

mean_cor_stage_sound <- df_long %>% 
  filter(sound == 1) %>%
  filter(correctStage == i) %>%
  group_by(pid) %>%
  dplyr::summarise(n = n(), cor = mean(isCorrect))

mean_cor_stage_sound <- mean_cor_stage_sound[mean_cor_stage_sound$pid %in% mean_cor_stage_visual$pid,]
mean_cor_stage_visual <- mean_cor_stage_visual[mean_cor_stage_visual$pid %in% mean_cor_stage_sound$pid,]

# plot_frq(mean_cor_stage_visual, type = c("histogram"))

result = wilcox.test(mean_cor_stage_sound$cor, mean_cor_stage_visual$cor, paired = TRUE)
print("~~~~~~~~~~~~")
print(i)
print(result)
}

# WILCOXON SIGNED RANK REACTION TIME ---------------------------

# correct_df -----------------------------------------------------------

correct_df <- df_long %>% filter(isCorrect == 1) 

plot_frq(correct_df$timeSpent, type = c("histogram"))

mean_timeSpent <- mean(correct_df$timeSpent, na.rm = TRUE)
sd_timeSpent <- sd(correct_df$timeSpent, na.rm = TRUE)

# Determine the upper and lower bounds
lower_bound <- mean_timeSpent - 2 * sd_timeSpent
upper_bound <- mean_timeSpent + 2 * sd_timeSpent

# Filter the dataframe to remove outliers
correct_df <- correct_df[correct_df$timeSpent >= lower_bound & correct_df$timeSpent <= upper_bound, ]

plot_frq(correct_df$timeSpent, type = c("histogram"))

mean_rxn_visual <- correct_df %>% 
  filter(sound == 0) %>%
  group_by(as.factor(pid)) %>%
  dplyr::summarise(n = n(),rxn = mean(timeSpent))

# gut check for the wilcoxon signed rank
mean_rxn_visual %>% dplyr::summarise(mean(rxn), sd(rxn))

plot_frq(mean_rxn_visual$rxn, type = c("histogram"))

mean_rxn_sound <- correct_df %>% 
  filter(sound == 1) %>%
  group_by(as.factor(pid)) %>%
  dplyr::summarise(n = n(), rxn = mean(timeSpent))

mean_rxn_sound %>% dplyr::summarise(mean(rxn), sd(rxn))

plot_frq(mean_rxn_sound$rxn, type = c("histogram"))

mean_rxn_stage_sound <- mean_rxn_stage_sound[mean_rxn_stage_sound$pid %in% mean_rxn_stage_visual$pid,]
mean_rxn_stage_visual <- mean_rxn_stage_visual[mean_rxn_stage_visual$pid %in% mean_rxn_stage_sound$pid,]

result = wilcox.test(mean_rxn_sound$rxn, mean_rxn_visual$rxn, paired = TRUE)

result

#FIG:rxn_time

ggplot(correct_df, aes(x = as.factor(correctStage), y =timeSpent, fill = as.factor(sound))) + 
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Reaction Time of Correct Responses", y = "Time Spent in seconds" ) +
  scale_x_discrete("Sleep Stage", labels=c("0" = "WAKE", "1" = "N1", "2" = "N2", "3" = "N3", "5" = "REM")) +
  scale_fill_discrete("", labels = c("0" = "No Sound", "1" = "Sound")) +
  geom_errorbar(stat="summary", width=.2, position=position_dodge(.9)) +
  my_theme 
ggsave("Images/rxn_time.png", width = 6.10, height = 6.48, units = "in")

datasummary_skim(df_long)

# WILCOXON SIGNED RANK TEST RXN TIME BY STAGE ---------------------------

#FIG:rxn_combined
ggplot(correct_df, aes(x = as.factor(sound), y =timeSpent, fill = as.factor(sound))) +
  geom_bar(stat = "summary", fun = "mean", position = "dodge") +
  labs(title = "Reaction Time of Correct Responses \nby Condition",
       y = "Time Spent in seconds") +
  scale_x_discrete("Condition", labels=c("0" = "No Sound \n(visual only)", "1" = "Sound")) +
  my_theme + theme(legend.position="none") +
  geom_errorbar(stat="summary", width=.2, position=position_dodge(.9))
ggsave("Images/rxn_combined.png", width = 6.10, height = 6.48, units = "in") 


datasummary_skim(correct_df)

# Stage = 2 -------------------------

mean_rxn_stage_sound <- correct_df %>% 
    filter(sound == 1) %>%
    filter(correctStage == 2) %>%
    group_by(as.factor(pid)) %>%
    dplyr::summarise(n = n(), rxn = mean(timeSpent))

  
mean_rxn_stage_visual <- correct_df %>% 
    filter(sound == 0) %>%
    filter(correctStage == 2) %>%
    group_by(as.factor(pid)) %>%
    dplyr::summarise(n = n(), rxn = mean(timeSpent))
  datasummary_skim(mean_rxn_stage_visual)
  
  print("Sleep Stage: ")
  print(2)
  print("visual mean")
  print(mean_rxn_stage_visual %>% dplyr::summarise(mean(rxn), sd(rxn)))
  print("sound mean")
  print(mean_rxn_stage_sound %>% dplyr::summarise(mean(rxn), sd(rxn)))
  
  sig_result = wilcox.test(mean_rxn_stage_sound$rxn, mean_rxn_stage_visual$rxn, paired = TRUE)
  print("result: ")
  print(sig_result)

  
# Stage = 0 -------------------------
  mean_rxn_stage_sound <- correct_df %>% 
    filter(sound == 1) %>%
    filter(correctStage == 0) %>%
    group_by(pid) %>%
    dplyr::summarise(n = n(), rxn = mean(timeSpent))
  datasummary_skim(mean_rxn_stage_sound)
  
  mean_rxn_stage_visual <- correct_df %>% 
    # filter(sound == 0) %>%
    filter(correctStage == 0) %>%
    group_by(pid) %>%
    dplyr::summarise(n = n(), rxn = mean(timeSpent))
  datasummary_skim(mean_rxn_stage_visual)
  
  mean_rxn_stage_sound <- mean_rxn_stage_sound[mean_rxn_stage_sound$pid %in% mean_rxn_stage_visual$pid,]
  mean_rxn_stage_visual <- mean_rxn_stage_visual[mean_rxn_stage_visual$pid %in% mean_rxn_stage_sound$pid,]
  
  print("Sleep Stage: ")
  print(i)
  print("visual mean")
  print(mean_rxn_stage_visual %>% dplyr::summarise(mean(rxn), sd(rxn)))
  print("sound mean")
  print(mean_rxn_stage_sound %>% dplyr::summarise(mean(rxn), sd(rxn)))
  
  
  sig_result = wilcox.test(mean_rxn_stage_sound$rxn, mean_rxn_stage_visual$rxn, paired = TRUE)
  print("result: ")
  print(sig_result)



# CLICKS -----------------------------------------------------------
clicks_df <- df_long %>% filter (totalClicks > 0)
datasummary_skim(clicks_df)

clicks <- lme4::lmer(
  clicks ~ sound*correctStage,
  data = clicks_df)

plot_predictions(clicks, condition = c("sound"))

summary(clicks)



