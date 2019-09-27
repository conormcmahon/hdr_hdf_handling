# Generate .tif output files from .hdr (proprietary) file inputs 

library(raster)
library(rgdal)
library(tools)

path = "E:/swshivers/SERDP_residualFractionAnalysis/Vandenburg/LC08_L1TP_042036_20130605_20170310_01_T1_sr__envi_crop_SMA_20190319T14H30M29S"  # "E:/swshivers/SERDP/Vandenburg/"
setwd(path)

file.names <- dir(path, pattern ="_envi")