library(tidyverse)
library(googledrive)

# Pull the spreadsheet down from Google Drive
drive_download(
  "w251_final_model_notes",
  path = "C:\\Users\\stack\\Downloads\\modelnotes.csv",
  overwrite = TRUE
)

# Read in the downloaded CSv and convert to tibble
df = tbl_df(read_csv("C:\\Users\\stack\\Downloads\\modelnotes.csv"))

# Relabel the model to combine dataset name and filter out the data I want
df2 <- df %>%
  filter(Run.By == "Mike") %>%
  rowwise %>%
  mutate(
    Model = case_when(
      substr(Model,1,1) == "m" ~ "MN224",
      substr(Model,1,1) == "i" ~ "IV3",
      TRUE ~ Model
    ),
    Label = ifelse(Tuning.Notes == "Default",
                   paste(Model, Data.Set, sep = "-"),
                   paste(Model, "-", Data.Set, "*", sep = "")
    )
  ) %>%
  select(Label, Run.Time, Accuracy.Train, Accuracy.Val, CrossEntropy.Train, CrossEntropy.Val, Final.Test.Accuracy) %>%
  arrange(Label)
  
# Plot the final test accuracy
ggplot(df2, aes(Label, Final.Test.Accuracy)) + 
  geom_bar(stat = "identity") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), axis.title.y = element_blank()) + 
  labs(title="Final Test Accuracy", x = "Model - Dataset")

# Reformat the dataset for plotting Train and Val Cross Entropy
df3 = df2 %>% 
  rename(Train = CrossEntropy.Train, Val = CrossEntropy.Val) %>%
  gather(key="Type", value = "CrossEntropy", Train, Val) %>%
    select(Label, Type, CrossEntropy)

# Plot Train and Val Cross Entropy
ggplot(df3, aes(x = Label, y = CrossEntropy, fill=factor(Type))) + 
  geom_bar(stat = "identity", position = "dodge") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), axis.title.y = element_blank(),
        legend.title = element_blank()) + 
  labs(title="Cross Entropy", x = "Model - Dataset")
  