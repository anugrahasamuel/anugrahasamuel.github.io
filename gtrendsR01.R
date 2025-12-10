## EPPS 6302 Methods of Data Collection and Production
## Google Trends with R

# install.packages("gtrendsR")   # run once in the Console, not every time
library(gtrendsR)

# --- Part 1: Trump / Harris / election (prof's code, just cleaned a bit) ----
TrumpHarrisElection <- gtrends(
  c("Trump", "Harris", "election"),
  onlyInterest = TRUE,
  geo   = "US",
  gprop = "web",
  time  = "today+5-y",   # last five years
  category = 0
)

the_df <- TrumpHarrisElection$interest_over_time
plot(TrumpHarrisElection)

# --- SMALL ADDITION FOR ASSIGNMENT: SAVE DATA -------------------------------
# (this is the only real change you need)

if (!dir.exists("data")) dir.create("data")

# save as CSV
write.csv(
  the_df,
  file = "data/gtrends_trump_harris_election.csv",
  row.names = FALSE
)

# save as R format
saveRDS(
  the_df,
  file = "data/gtrends_trump_harris_election.rds"
)

# --- Part 2: rest of prof's examples (leave as is) --------------------------

tg <- gtrends("tariff", time = "all")

# Example: Tariff, China military, Taiwan 
plot(gtrends(c("tariff"), time = "all"))
data("countries")
plot(gtrends(c("tariff"), geo = "GB", time = "all"))
plot(gtrends(c("tariff"), geo = c("US","GB","TW"), time = "all"))

tg_iot <- tg$interest_over_time
tct <- gtrends(c("tariff","China military", "Taiwan"), time = "all")
tct <- data.frame(tct$interest_over_time)
plot(gtrends(c("tariff","China military", "Taiwan"), time = "all"))
