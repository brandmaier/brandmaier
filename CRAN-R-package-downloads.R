# Install and load required package
#install.packages("cranlogs")
library(cranlogs)
library(ggplot2)
library(tidyverse)

# Retrieve daily download data for last 2 years
end_date <- as.Date(format(Sys.Date(), "%Y-%m-01")) - 1
start_date <- end_date - (365*3) # about 3 years

daily <- cran_downloads(packages = c("semtree","pdc","reproducibleRchunks","ggx"), from = start_date, to = end_date)

# Summarize to monthly totals
monthly <- daily %>%
  dplyr::mutate(month = format(date, "%Y-%m")) %>%
  dplyr::group_by(month, package) %>%
  dplyr::summarize(total = sum(count))

# Convert month to Date format
monthly$month <- as.Date(paste0(monthly$month, "-01"))

# Plot
ggplot(monthly, aes(x = month, y = total, group=package, color=package)) +
  geom_smooth(linewidth = 1) +
  geom_point(aes(color=package)) +
  labs(title = "Monthly Downloads of R packages (RStudio CRAN mirror)",
       x = "Month",
       y = "Downloads") +
  theme_minimal()

ggsave(filename="rpackage_downloads.png",width = 8, height=4)

