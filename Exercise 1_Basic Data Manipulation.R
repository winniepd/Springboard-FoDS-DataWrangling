library(dplyr)
library(tidyr)

# 0: Load the data in RStudio
refine_original <- read.csv("refine_original.csv")

# 1: Clean up brand names (base R version) 
# refine_original$company[grepl("^a", refine_original$company) | grepl("^A", refine_original$company)] <- "akzo"
# refine_original$company[grepl("^p", refine_original$company) | grepl("^P", refine_original$company) | grepl("^f", refine_original$company)] <- "philips"
# refine_original$company[grepl("^u", refine_original$company) | grepl("^U", refine_original$company)] <- "unilever"
# refine_original$company[grepl("^v", refine_original$company) | grepl("^V", refine_original$company)] <- "van houten"

refine_clean <- refine_original %>% 
  # 1: Clean up brand names
  
  # mutate(
  #   company = case_when(
  #     substr(tolower(.$company), 0, 1) == "a" ~ "akzo", 
  #     substr(tolower(.$company), 0, 1) == "p" | substr(tolower(.$company), 0, 1) == "f" ~ "philips", 
  #     substr(tolower(.$company), 0, 1) == "u" ~ "unilever", 
  #     substr(tolower(.$company), 0, 1) == "v" ~ "van houten"
  #   )
  # ) %>% 
  
  mutate(company = tolower(company)) %>%  
  
  mutate(
    company = case_when(
      substr(.$company, 0, 1) == "a" ~ "akzo",
      substr(.$company, 0, 1) == "p" | substr(.$company, 0, 1) == "f" ~ "philips",
      substr(.$company, 0, 1) == "u" ~ "unilever",
      substr(.$company, 0, 1) == "v" ~ "van houten"
    )
  ) %>% 

  # 2: Separate product code and number
  separate(Product.code...number, c("product_code", "product_number"), sep = "-") %>%
  
  mutate(
    # 3: Add product categories
    product_category = case_when(
      .$product_code == "p" ~ "Smartphone",
      .$product_code == "v" ~ "TV",
      .$product_code == "x" ~ "Laptop",
      .$product_code == "q" ~ "Tablet" 
    ), 
    
    # 4: Add full address for geocoding
    full_address = paste(address, city, country, sep = ", "), 
    
    # 5: Create dummy variables for company and product category
    company_philips = ifelse(company == "philips", 1, 0), 
    company_akzo = ifelse(company == "akzo", 1, 0), 
    company_van_houten = ifelse(company == "van houten", 1, 0), 
    company_unilever = ifelse(company == "unilever", 1, 0), 
  
    product_smartphone = ifelse(product_code == "p", 1, 0), 
    product_tv = ifelse(product_code == "v", 1, 0), 
    product_laptop = ifelse(product_code == "x", 1, 0), 
    product_tablet = ifelse(product_code == "q", 1, 0) 
  ) 

# 6: Submit the project on Github
write.csv(refine_clean, file = "refine_clean.csv", row.names = FALSE)

