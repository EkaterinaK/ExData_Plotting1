library(data.table)

#----download data file if not present-------------

if(!file.exists("household_power_consumption.txt")) {
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(url, destfile = "d.zip")
  unzip("d.zip")
  file.remove("d.zip")
}

#----read data from file (just lines with dates 2007-02-01 and 2007-02-02)

colNames <- colnames(read.table("household_power_consumption.txt", sep=";", header=TRUE, nrows=1))
dt <- read.table("household_power_consumption.txt", sep=";", skip=66637, nrows=2880, col.names=colNames)

#----compute new datatime feature------

dd <- data.table(dt)
dd[, ee:= { tmp <-paste(dd$Date , dd$Time, sep=" "); as.POSIXct(strptime(tmp, format="%d/%m/%Y %H:%M:%S")) }] 

#----plot------------------------------

par(mfrow = c(2,2))
par(mar = c(4,4,2,2))
par(cex = 2/3)   # makes font smaller (it is very useful in legend)

with(dd, plot(ee, Global_active_power, type="l", xlab="", ylab="Global Active Power"))

with(dd, plot(ee, Voltage, type="l", xlab="datetime"))

with(dd, plot(ee, Sub_metering_1, type="n", xlab="", ylab="Energy sub metering"))
with(dd, points(ee,Sub_metering_1, type="l", col="black"))
with(dd, points(ee,Sub_metering_2, type="l", col="red"))
with(dd, points(ee,Sub_metering_3, type="l", col="blue"))
legend("topright", col = c("black", "red", "blue"), legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"), lwd=1, bty="n")
 
with(dd, plot(ee, Global_reactive_power, type="l", xlab="datetime"))

#---- save the graph to file-----------

dev.copy(png, file="plot4.png", width=480, height=480)
dev.off()
