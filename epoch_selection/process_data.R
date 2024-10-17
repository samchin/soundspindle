source("packages_and_functions.R")

output_0 <- read.csv("output.csv")
output_1 <- read.csv("output_part1.csv")

output_0 <- clean_output(output_0)
output_1 <- clean_output(output_1)
criteron <- read.csv("new_sleep_segments.csv")

# show there are no overlaps between 1 and 0 
overlapping_rows <- find_overlapping_rows(output_1, output_0)
print(overlapping_rows)
overlapping_rows <- find_overlapping_rows(criteron, output_0)
print(overlapping_rows)
overlapping_rows <- find_overlapping_rows(criteron, output_1)
print(overlapping_rows)

# combine all of the existing stuff
combined_output <- bind_rows(criteron, output_0)
combined_output <- bind_rows(combined_output, output_1)

# get the megalist
output_all <- read.csv("Sleep stage data.csv")

# quantify the overlap
overlapping_rows <- find_overlapping_rows(combined_output, output_all)
print(overlapping_rows)
print(nrow(overlapping_rows))

# identify the non-overlap
non_overlap_result <- find_non_overlapping_rows(combined_output, output_all)
print("Non-overlapping rows in combined_outputs:")
print(non_overlap_result$non_overlapping_df1)

selectable_list <- non_overlap_result$non_overlapping_df2

random_sample <- selectable_list %>%
  sample_n(120, replace = FALSE)  %>%
  arrange(subject)
# Display the sampled rows
print(random_sample)


