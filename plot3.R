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
dd[, ee:= { tmp <-paste(dd$Date , dd$Time, sep=" "); as.POSIXct(strptime(tmp, format="%d/%m/%Y %H:%M:%S")) }] 

# plot

with(dd, plot(ee, Sub_metering_1, type="n", xlab="", ylab="Energy sub metering"))
with(dd, points(ee,Sub_metering_1, type="l", col="black"))
with(dd, points(ee,Sub_metering_2, type="l", col="red"))
with(dd, points(ee,Sub_metering_3, type="l", col="blue"))
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=1)

# save the graph to file
dev.copy(png, file="plot3.png", width=480, height=480)
dev.off()
