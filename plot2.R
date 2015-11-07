library(data.table)

# download data file if not present

if(!file.exists("household_power_consumption.txt")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "d.zip")
  unzip("d.zip")
  file.remove("d.zip")
}

# read data from file (just lines with dates 2007-02-01 and 2007-02-02)

colNames <- colnames(read.table("household_power_consumption.txt", sep=";", header=TRUE, nrows=1))
dt <- read.table("household_power_consumption.txt", sep=";", skip=66637, nrows=2880, col.names=colNames)

# compute new datatime feature

dd <- data.table(dt)
#dd[, e:=paste(dd$Date , dd$Time, sep=" ")]                          # concatenate
#dd[, ee:=as.POSIXct(strptime(dd$e, format="%d/%m/%Y %H:%M:%S"))]    # get rid of C-structure
dd[, ee:= { tmp <-paste(dd$Date , dd$Time, sep=" "); as.POSIXct(strptime(tmp, format="%d/%m/%Y %H:%M:%S")) }] 

# plot
with(dd, plot(ee, Global_active_power, type="l", xlab="", ylab="Global Active Power (kilowatts)"))

# save the graph to file
dev.copy(png, file="plot2.png", width=480, height=480)
dev.off()
