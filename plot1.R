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

# plot

with(dt, hist(Global_active_power, col="red", xlab="Global Active Power (kilowatts)", main="Global Active Power"))

# save the graph to file
dev.copy(png, file="plot1.png", width=480, height=480)
dev.off()
