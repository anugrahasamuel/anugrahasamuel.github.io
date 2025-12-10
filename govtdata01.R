## Scraping Government data - Foreign Relations Committee
## Website: GovInfo (https://www.govinfo.gov/app/search/)

gc(reset = TRUE)

library(purrr)
library(magrittr)
library(rjson)
library(jsonlite)
library(data.table)
library(readr)
library(dplyr)

## 1. Set working directory to your website project
## (you can also set this via RStudio Session > Set Working Directory)
setwd("~/anugrahasamuel.github.io")

## 2. Read the search results you downloaded from govinfo
##    (Export results as CSV and JSON from the govinfo search for
##     the Foreign Relations Committee and save to the data/ folder)

govfiles  <- read.csv(
  file = "data/govinfo_foreign_relations_results.csv",
  skip = 2
)

gf_list1  <- jsonlite::read_json(
  "data/govinfo_foreign_relations_results.json"
)

## Extract list of results from JSON
govfiles3 <- gf_list1$resultSet |> dplyr::bind_rows()

## 3. Prepare IDs and PDF links
govfiles$id        <- govfiles$packageId
pdf_govfiles_url   <- govfiles3$pdfLink
pdf_govfiles_id    <- govfiles3$index

## 4. Directory to save the PDFs
##    This is relative to your Quarto project so they get copied
##    to the website via `resources: - files/*` in _quarto.yml
save_dir <- "files/"
if (!dir.exists(save_dir)) dir.create(save_dir)

## 5. Function to download one PDF
download_govfiles_pdf <- function(url, id) {
  tryCatch({
    destfile <- file.path(save_dir, paste0("foreign_relations_", id, ".pdf"))
    download.file(url, destfile = destfile, mode = "wb")
    Sys.sleep(runif(1, 1, 3))  # be polite to the server
    paste("Successfully downloaded:", url)
  },
  error = function(e) {
    paste("Failed to download:", url, "Error:", e$message)
  })
}

## 6. Download ONLY the first 10 most recent documents
start.time <- Sys.time()
message("Starting downloads for first 10 Foreign Relations Committee PDFs")

n_download <- min(10, length(pdf_govfiles_url))

results <- purrr::map_chr(
  1:n_download,
  ~ download_govfiles_pdf(pdf_govfiles_url[.], pdf_govfiles_id[.])
)

message("Finished downloads")
end.time <- Sys.time()
time.taken <- end.time - start.time

time.taken
results
