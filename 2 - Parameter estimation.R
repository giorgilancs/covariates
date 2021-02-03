rm(list=ls())

library(PrevMap)
library(splines)
tz <- read.csv("TZ_2015.csv")
tz$log.Population <- log(tz$Population)
tz$log.Precipitation <- log(tz$Precipitation)

# For a tutorial on the use of PrevMap type the following:
# vignette("PrevMap")

# Obtain starting values for the regression coefficients
glm.fit <- 
  glm(cbind(Pf,Ex-Pf) ~
        Temperature+
        
        EVI+
        I((EVI-0.35)*(EVI>0.35))+
        
        NTL + 
        
        log(Population)+
        
        log(Precipitation),
      family=binomial,data=tz)

summary(glm.fit)

# Monte Carlo maximum likleihood estimation

# Parameters of the importance sampling distribution
par0 <- c(coef(glm.fit),3.5,100,1)

# Number of covariates
p <- length(coef(glm.fit))

fit.MCML <- list()
fit.MCML$log.lik <- Inf
done <- FALSE

# Monte Calo maximum likelihood estimation

# Control parameters of the Monte Carlo algorithm
control.mcmc <- control.mcmc.MCML(n.sim=110000,burnin=10000,
                                  thin=10)

# Fitting of the model
fit.MCML <- 
  binomial.logistic.MCML(Pf ~
                           Temperature+
                           
                           EVI+
                           I((EVI-0.35)*(EVI>0.35))+
                           
                           NTL + 
                           
                           log(Population)+
                           
                           log(Precipitation),
                         par0=par0,
                         start.cov.pars = c(par0[p+2],par0[p+3]/par0[p+1]),
                         coords=~utm_x+utm_y,
                         units.m=~Ex,
                         control.mcmc = control.mcmc,
                         kappa=0.5,method="nlminb",
                         data=tz)

save(fit.MCML,file="TZ_2015_fit.RData")

