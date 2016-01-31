###Read the NEI and SCC data sets into R
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC<-readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

###Subset Baltimore from the NEI dataframe
Ravens <- NEI[which(NEI$"fips"=="24510"),]

###Find the aggregate sum of emissions by year
totalsdos<-aggregate(Emissions~year,Ravens,sum)

###Set the plot width and height & create the PNG file
png("./exdata-data-NEI_data/Plot2.png",width=480,height=480)

###Draw a bar plot with the new totals data frame
###Color the plot for fun, and for Ravens fans :-)
barplot(totalsdos$"Emissions",
        names.arg=totalsdos$"year",
        xlab="Year",
        ylab="PM2.5 Emissions - Tons",
        main="Total PM2.5 emissions by Year",
        sub="Emissions decreased overall, but did randomly increase in 2005",
        col="gold",
        col.main="midnightblue",
        col.sub="midnightblue",
        col.lab="midnightblue")

###draw a regression line to show the trend
###create a regression model
model2<- lm(totalsdos$"Emissions"~totalsdos$"year")

###predict the model to show the trend
prediction2 <- predict(model2)

###draw the regression line on the plot
lines(prediction2,col="midnightblue",lwd=4)

dev.off()