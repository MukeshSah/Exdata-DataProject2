###Read the NEI and SCC data sets into R
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC<-readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

###Find the aggregate sum of emissions by year
totals<-aggregate(Emissions~year,NEI,sum)

###Set the plot width and height & create the PNG file
png("./exdata-data-NEI_data/plot1.png",width=480,height=480)

###Draw a bar plot with the new totals data frame
###Color the plot for fun :-)
barplot(totals$"Emissions"/1000000,
        names.arg=totals$"year",
        xlab="Year",
        ylab="PM2.5 Emissions - Millions of Tons",
        main="Total PM2.5 emissions by Year",
        sub="Emissions have decreased since 1999",
        col="deepskyblue",
        col.main="blue4",
        col.sub="blue4",
        col.lab="blue4")

###draw a regression line to show the trend
###createa regression model
model1<- lm(totals$"Emissions"/1000000~totals$"year")

###predict the model to show the trend
prediction1 <- predict(model1)

###draw the regression line on the plot
lines(prediction1,col="blue4",lwd=4)

dev.off()