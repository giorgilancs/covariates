rm(list=ls())

library(PrevMap)
library(splines)
tz <- read.csv("TZ_2015.csv")

# Loading of the fitted model saved in "2 - Parameter estimation"
load("TZ_2015_fit.RData")

# Loading of the prediction grid ("grid.pred")
# and values of the covariates at prediction locations ("predictors")

load("pred_objects.RData")

predictors$Precipitation <- predictors$Precipitation*365
predictors$log.Population <- log(predictors$Population)
predictors$log.Precipitation <- log(predictors$Precipitation)

# Control parameters of the Monte Carlo Markox chain
control.mcmc <- control.mcmc.MCML(n.sim=110000,
                                  burnin=10000,
                                  thin=10)

# Spatial prediction of prevalence over the prediction locations
pred.MCML <- 
  spatial.pred.binomial.MCML(fit.MCML,grid.pred=grid.pred,
                             predictors = predictors,
                             control.mcmc = control.mcmc,
                             scale.predictions = "prevalence",
                             thresholds = 0.3,
                             scale.thresholds = "prevalence")

# Map of the predicted prevalence 
plot(pred.MCML,type="prevalence",summary="predictions")

# Map of the exceedance probabilities
plot(pred.MCML,summary="exceedance.prob")

