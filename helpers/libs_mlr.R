# --- Needed R packages ----
packages = c("checkmate",  "devtools", "Rcpp", "ParamHelpers", "mlr", "ecr",
  "OpenML", "magrittr", "data.table", "farff", "ranger", "mlrCPO", "parallelMap", 
  "xgboost", "BBmisc", "rjson", "Metrics", "foreach", "prediction", "rgl", 
  "randomForest", "pracma", "parallelMap", "keras", "irace", "ggplot2", 
  "plot3Drgl", "latex2exp", "scatterplot3d", "ggrepel", "reticulate",
  "datarium", "dplyr", "roxygen2", "gridExtra", "Formula", "StatMatch", 
  "keras", "purrr", "e1071", "stringr", 
  "xtable", "ggpubr", "tidyr", # Packages for evaluation of benchmark results
  "GGally", "fmsb", "ggExtra", "metR", "mvtnorm") # Packages for study and applications

source("../helpers/keras_mlr_learner.R")

new.packages = packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)
sapply(packages, require, character.only = TRUE)

# #--- Load respositories mosmafs and iml ----
if ("mosmafs" %in% installed.packages()) {
  library("mosmafs")
} else {
  devtools::install_github("compstat-lmu/mosmafs", ref = "mosmafs-package")
}

load_all(file.path("../iml"))
