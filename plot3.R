# Create a directory called "data" in the present working directory
# Download data and save the date of the download time.
if (!file.exists("data")){
  dir.create("data")
}
url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url, destfile="./data/household_power_consumption.zip")
dateDownloaded <- date()
#
# unzip the downloaded file locally using unzip command
# First line of the file has headers
# The separator is ";"
# Missing data is recorded as "?"
# So use these options while reading the file: header=T, sep=";",na.strings="?"
#
pow <- read.csv2(unzip("./data/household_power_consumption.zip"),header=T, sep=";",na.strings="?")
#
# Use head, tail, str, summary to summarize the data frame.
# The Data and Time columns are characters. 
# Create another column "datetime" by "paste"ing the two columns.
# Use "strptime" to convert the "datetime" values to POSIXct type
# Finally subset the data between 2007-02-01 and 2007-02-02
pow$datetime <- paste(pow$Date,pow$Time)
pow$datetime <- strptime(pow$datetime,format="%d/%m/%Y %H:%M:%S")
pow <- subset(pow, as.Date(datetime) >= as.Date("2007-02-01") & as.Date(datetime) <= as.Date("2007-02-02"))
##
# There is no need to keep "date" and "time" column. So, subset again removing first two columns.
pow <- pow[,3:10]
##
# Open device "png" with resolution width=480, height=480
# draw the histogram and close the device
##
png("plot3.png",width=480,height=480)
plot(pow$datetime, as.numeric(as.character(pow$Sub_metering_1)),type="l",xlab="",ylab="Energy sub metering")
lines(pow$datetime, as.numeric(as.character(pow$Sub_metering_2)),col="red")
lines(pow$datetime, as.numeric(as.character(pow$Sub_metering_3)),col="blue")
legend("topright", legend= c("Sub_metering_1","Sub_metering_2","Sub_metering_3"), col=c("black","red","blue"),lty=c(1,1,1),lwd=c(2.5,2.5,2.5))
dev.off()