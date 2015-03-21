# Download data
# download archive
if ( !file.exists("./NEIdata.zip")) {
        download.file("https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip", 
                      method="curl", destfile="./NEIdata.zip")
}

# unzip archive
if ( !file.exists("./summarySCC_PM25.rds")) {
        unzip("./NEIdata.zip", overwrite=TRUE)
}

# load data
nei <- readRDS("summarySCC_PM25.rds")
scc <- readRDS("Source_Classification_Code.rds")
head(nei)

# disable scientific notation
options(scipen = 999)

# Aggregates
emissions <- setNames(aggregate(nei[, "Emissions"], by=list(nei$year), FUN=sum),
                      c("year", "PM2.5"))
emissions$PM2.5 <- round(emissions[, 2] / 1000000, 2)

png(filename = "plot1.png")
plot <- barplot(emissions$PM2.5, names.arg = emissions$year, 
        main = expression("Total Emission of PM"[2.5]), 
        xlab = 'Year', ylab = expression(paste("PM", ""[2.5], " in Megatons")))
text(x=plot, y=(emissions$PM2.5/2), labels=as.character(emissions$PM2.5), xpd=TRUE)
dev.off()