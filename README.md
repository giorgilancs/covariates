This contains files that allows to reproduce the exploratory analysis, 
parameter estimation and spatial prediction for the geostatistical model 
containing all the coviariates presented in the paper "Model building and assessment of the impact of 
covariates for disease prevalence mapping in low-resource settings: to explain and to predict."

The files are:
- "1 - Exploratory analysis.R" is the R script for: exploring relationships between
covariates and prevalence; testing for residual spatial correlation.

- "2 - Parameter estimation.R" is the R script for carrying out the fitting of the 
geostatistical model using the Monte carlo maximum likelihood method.

- "3 - Spatial prediction.R" is the R sripts for carrying out the spatial prediction
of prevalence over a regular grid.

- "TZ_2015.csv" is the file containing the data. Each row corresponds to a sampled 
community with total number of tested people ("Ex"), nuber of positive cases ("Pf") and
geographical locations. The column "utm_x" is the x-coordinate and "utm_y" is the y-coordinate
in UTM; longitude and latitude are also reported in "Long" and "Lat", respectively. 
The name of the covariates in the data correspond to the same names and abbreviation used in 
the main manuscript. 

- "TZ_2015_fit.RData" is an R object containing the fitted geostatistical model that is loaded within 
 the R code of "3 - Spatial prediction.R".

- "pred_objects.RData" is an R object containing the prediction locations and the values of the covariates
at those locations, that are used in "3 - Spatial prediction.R".
