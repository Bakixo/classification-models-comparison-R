required_packages <- c(
  "mice",
  "caret",
  "rpart",
  "rpart.plot",
  "dplyr",
  "randomForest",
  "e1071"
)

installed <- rownames(installed.packages())
for (pkg in required_packages) {
  if (!pkg %in% installed) {
    install.packages(pkg, dependencies = TRUE)
  }
}
