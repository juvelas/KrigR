% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/Kriging.R
\name{krigR}
\alias{krigR}
\title{(multi-core) Kriging}
\usage{
krigR(
  Data = NULL,
  Covariates_coarse = NULL,
  Covariates_fine = NULL,
  KrigingEquation = "ERA ~ DEM",
  Cores = detectCores(),
  Dir = getwd(),
  FileName,
  Keep_Temporary = TRUE,
  SingularTry = 10,
  Variable,
  Type,
  DataSet,
  DateStart,
  DateStop,
  TResolution,
  TStep,
  FUN = "mean",
  Extent,
  Buffer = 0.5,
  ID = "ID",
  API_Key,
  API_User,
  Target_res,
  nmax = Inf,
  ...
)
}
\arguments{
\item{Data}{Raster file which is to be downscaled.}

\item{Covariates_coarse}{Raster file containing covariates at training resolution.}

\item{Covariates_fine}{Raster file containing covariates at target resolution.}

\item{KrigingEquation}{Formula or character string specifying which covariates to use and how. Layer names in Covariates_coarse and Covariates_fine need to match Parameters in this formula. Needs to start with "X ~ ". X can read anything you like.}

\item{Cores}{Numeric. How many cores to use. If you want output to your console during the process, use Cores == 1. Parallel processing is carried out when Cores is bigger than 1. Default is detecting all cores of your machine.}

\item{Dir}{Optional. Directory specifying where to place final kriged product. Default is current working directory.}

\item{FileName}{Optional. A file name for the netcdf produced. Default is a combination parameters in the function call.}

\item{Keep_Temporary}{Logical, whether to delete individual kriging products of layers in Data after processing. Default is TRUE.}

\item{SingularTry}{Numeric. How often to try kriging of each layer of the input. This usually gets around issues of singular covariance matrices in the kriging process, but takes some time. Default is 10}

\item{Variable}{Optional, calls download_DEM(). ERA5(Land)-contained climate variable. See output of Variable_List() for possible values.}

\item{Type}{Optional. Whether to download reanalysis ('reanalysis') or ensemble ('ensemble_members', 'ensemble_mean', or 'ensemble_spread') data. Passed on to download_ERA.}

\item{DataSet}{Optional. Which ERA5 data set to download data from. 'era5' or 'era5-land'. Passed on to download_ERA.}

\item{DateStart}{Optional. Date ('YYYY-MM-DD') at which to start time series of downloaded data. Passed on to download_ERA.}

\item{DateStop}{Optional. Date ('YYYY-MM-DD') at which to stop time series of downloaded data. Passed on to download_ERA.}

\item{TResolution}{Optional. Temporal resolution of final product. hour', 'day', 'month'. Passed on to download_ERA.}

\item{TStep}{Optional. Which time steps (numeric) to consider for temporal resolution. Passed on to download_ERA.}

\item{FUN}{Optional. A raster calculation argument as passed to `raster::stackApply()`. This controls what kind of data to obtain for temporal aggregates of reanalysis data. Specify 'mean' (default) for mean values, 'min' for minimum values, and 'max' for maximum values, among others.}

\item{Extent}{Optional, download data according to rectangular bounding box. specify as extent() object or as a raster, a SpatialPolygonsDataFrame object, or a data.frame object. If Extent is a SpatialPolygonsDataFrame, this will be treated as a shapefile and the output will be cropped and masked to this shapefile. If Extent is a data.frame of geo-referenced point records, it needs to contain Lat and Lon columns as well as a non-repeating ID-column. Passed on to download_ERA and download_DEM.}

\item{Buffer}{Optional. Identifies how big a rectangular buffer to draw around points if Extent is a data frame of points. Buffer is expressed as centessimal degrees. Passed on to download_ERA and download_DEM.}

\item{ID}{Optional. Identifies which column in Extent to use for creation of individual buffers if Extent is a data.frame. Passed on to download_ERA and download_DEM.}

\item{API_Key}{Optional. ECMWF cds API key. Passed on to download_ERA.}

\item{API_User}{Optional. ECMWF cds user number. Passed on to download_ERA.}

\item{Target_res}{Optional. The target resolution for the kriging step (i.e. which resolution to downscale to). An object as specified/produced by raster::res(). Passed on to download_DEM.}

\item{nmax}{Optional. Controls local kriging. Number of nearest observations to be used kriging of each observation. Default is to use all available (Inf). You can specify as a number (numeric) or as "Opt" which prompts krigR to identify a suitable number of nmax given the resolution of your data.}

\item{...}{further arguments passed to automap::autoKrige and/or gstat::krige. Does not work with multi-core kriging for now.}
}
\value{
A list object containing the downscaled data as well as the standard error for downscaling as well as the call to the krigR function, and two NETCDF (.nc) file in the specified directory which are the two data contents of the aforementioned list. A temporary directory is populated with individual NETCDF (.nc) files throughout the runtime of krigR which is deleted upon completion if Keep_Temporary = TRUE and all layers in the Data raster object were kriged successfully.
}
\description{
This function statistically downscales input data using covariate data and the kriging methodology. The function can be run in two ways:
\enumerate{
\item \strong{By Itself}: Use the arguments Data, Covariates_coarse, Covariates_fine when you already have raster files for your data which is to be downscaled as well as covariate raster data.
\item \strong{From Scratch}: Use the arguments Variable, Type, DataSet, DateStart, DateStop, TResolution, TStep, Extent, Dir, FileName, API_Key, API_User, and arget_res. By doing so, krigR will call the functions download_ERA() and download_DEM() for one coherent kriging workflow. Note that this process does not work when targetting UERRA data.
}
Use optional arguments such as Dir, FileName, Keep_Temporary, SingularTry, KrigingEquation and Cores for ease of use, substitution of non-GMTED2010 covariates, and parallel processing.
}
\examples{
\dontrun{
# Downloading and downscaling ERA5-Land air temperature reanalysis data in monthly intervals for the entire year of 2000 for Germany. API User and Key in this example are non-functional. Substitute with your user number and key to run this example.
krigR(Variable = '2m_temperature', Type = 'reanalysis', DataSet = 'era5-land', DateStart = '2000-01-01', DateStop = '2000-12-31', TResolution = 'month', TStep = 1, Extent = extent(6,15,47,55), API_User = NULL, API_Key = NULL, Target_res = .01, Cores = 4, FileName = "KrigingOutput.nc", Dir = file.path(getwd(), "KrigRTesting"))
}

}
