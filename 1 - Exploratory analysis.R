rm(list=ls())
library(PrevMap)
library(mgcv)
library(ggplot2)
library(splines)
tz <- read.csv("TZ_2015.csv")

tz$logit <- log((tz$Pf+0.5)/(tz$Ex-tz$Pf+0.5))
tz$'log-Population' <- tz$log.Population <- log(tz$Population)
tz$'log-Precipitation' <- tz$log.Precipitation <- log(tz$Precipitation)

tz$logit <- log((tz$Pf+0.5)/(tz$Ex-tz$Pf+0.5))
tz$log.Population <- log(tz$Population)
tz$log.Precipitation <- log(tz$Precipitation)

# Temperature
plot.temp <- ggplot(tz, aes(x = Temperature, 
                            y = logit)) + geom_point() +
  labs(x="Temperature",y="Empirical logit")+
  stat_smooth(method = "gam", formula = y ~ s(x),se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x,
              col="green",lty="dashed",se=FALSE)

# EVI
plot.evi <- ggplot(tz, aes(x = EVI, 
                           y = logit)) + geom_point() +
  labs(x="EVI",y="Empirical logit")+
  stat_smooth(method = "gam", formula = y ~ s(x),se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x + I((x-0.35)*(x>0.35)),
              col="red",lty="dashed",se=FALSE)

# NTL
plot.ntl <- ggplot(tz, aes(x = NTL, 
                           y = logit)) + geom_point() +
  labs(x="Night-time light",y="Empirical logit")+
  stat_smooth(method = "gam", formula = y ~ s(x),se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x + I((x-9)*(x>9)),
              col="red",lty="dashed",se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x ,
              col="green",lty="dashed",se=FALSE)

# Population
plot.pop <- ggplot(tz, aes(x = log.Population, 
                           y = logit)) + geom_point() +
  labs(x="log-Population",y="Empirical logit")+
  stat_smooth(method = "gam", formula = y ~ s(x),se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x ,
              col="green",lty="dashed",se=FALSE)


# Precipitation
plot.prec <- ggplot(tz, aes(x = log.Precipitation, 
                            y = logit)) + geom_point() +
  labs(x="log-Precipitation",y="Empirical logit")+
  stat_smooth(method = "gam", formula = y ~ s(x),se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x +
                I((x-6.85)*(x>6.85)),
              col="red",lty="dashed",se=FALSE)+
  stat_smooth(method = "lm", formula = y ~ x,
              col="green",lty="dashed",se=FALSE)

library(ggcorrplot)
var.names <- c("Temperature",
               "EVI","NTL","log-Population","log-Precipitation")

plot.cor <- ggcorrplot(corr = cor(tz[,var.names]),
                       type = "lower",
                       ggtheme = ggplot2::theme_minimal,
                       hc.order = FALSE,
                       show.diag = FALSE,
                       outline.col = "white",
                       lab = TRUE,
                       legend.title = "Correlation",
                       tl.cex = 11, tl.srt = 55)

library(gridExtra)
grid.arrange(plot.temp,plot.evi,
             plot.pop,plot.ntl,
             plot.prec,plot.cor)

# Testing for residual spatial correlation
# using the variogram
spat.corr.diagnostic(Pf ~ Temperature+
                       EVI+I((EVI-0.36)*(EVI-0.35))+
                       NTL+I((NTL-9)*(NTL>9))+
                       log.Population+
                       log.Precipitation+I((log.Precipitation-6.85)*
                                           (log.Precipitation>6.85)),
                     units.m = ~ Ex,
                     coords = ~utm_x+utm_y,
                     likelihood = "Binomial",
                     data=tz)
