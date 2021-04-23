#############################################################################
##  1   Getting the dataset
#############################################################################
filename <- './data/household_power_consumption.txt'

# check if file already exists
if (!file.exists(filename)) {
  
  # check if folder exists and create data directory
  if(!file.exists("./data")){
    dir.create("./data")
  }
  
  filename_zip <- './data/ElectricPowerConsumption.zip'  
  # check if zip file already exists
  if (!file.exists(filename_zip)){
    fileURL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
    download.file(fileURL, filename_zip, method = "curl")
  }
  
  unzip(filename_zip, exdir='data')
}

#############################################################################
##  2   Read the file
##      We will only be using data from the dates 2007-02-01 and 2007-02-02. 
##      Read the data from just those dates
#############################################################################
if(!require("sqldf")){
  install.packages("sqldf")
  if(!require(sqldf)){
    stop("could not install sqldf")
  }
}

df <- read.csv.sql(filename
             , sql = "select * from file where Date in ('1/2/2007','2/2/2007')" 
             , header = TRUE, sep = ";" )

# convert date and time in correct format
require(lubridate)
df$datetime <- with(df, dmy(Date) + hms(Time))
df$Date = dmy(df$Date)
df$Time = hms(df$Time)


#############################################################################
##  3   Create plot1.png
##      a PNG file with a width of 480 pixels and a height of 480 pixels
#############################################################################
if(!file.exists("./myplot")){
  dir.create("./myplot")
}

png(file="./myplot/plot1.png", width=480, height=480)
hist(df$Global_active_power, col='red'
     , main = 'Global Active Power'
     , xlab = 'Global Active Power (Kilovatts)')
dev.off()

