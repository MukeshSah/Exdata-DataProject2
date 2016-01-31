###Read the NEI and SCC data sets into R
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC<-readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

###Merge the SCC & NEI Data Sets
NEI_SCC <- merge(NEI,SCC,by="SCC")

###Find all matches with vehicle in the SCC.Level.Two variable
###Easiest way to subset motor vehicles
vehicle<-grep("vehicle",NEI_SCC$SCC.Level.Two,ignore.case=TRUE)

###subset vehicles from the NEI_SCC data frame
mvNEI_SCC <- NEI_SCC[vehicle,]

###subset Baltimore from the mvNEI_SCC data frame
RavensMV <- mvNEI_SCC[which(mvNEI_SCC$"fips"=="24510"),]

###Find the aggregate sum of emissions by year
totalsquatro<-aggregate(Emissions~year,RavensMV,sum)

###Set the plot width and height & create the PNG file
png("./exdata-data-NEI_data/Plot5.png",width=480,height=480)

###Draw a bar plot with the new totalsquatro data frame
###Color the plot for fun, and for Ravens fans :-)
barplot(totalsquatro$"Emissions",
        names.arg=totalsquatro$"year",
        xlab="Year",
        ylab="PM2.5 Emissions - Tons",
        main="Total Motor Vehicle PM2.5 emissions by Year",
        sub="Emissions have decreased since 1999",
        col="gold",
        col.main="midnightblue",
        col.sub="midnightblue",
        col.lab="midnightblue")

###draw a regression line to show the trend
###create a regression model
model4<- lm(totalsquatro$"Emissions"~totalsquatro$"year")

###predict the model to show the trend
prediction4 <- predict(model4)

###draw the regression line on the plot
lines(prediction4,col="midnightblue",lwd=4)
dev.off()
