###library(ggplot2)
library(ggplot2)
###Read the NEI and SCC data sets into R
NEI <- readRDS("./exdata-data-NEI_data/summarySCC_PM25.rds")
SCC<-readRDS("./exdata-data-NEI_data/Source_Classification_Code.rds")

###Subset Baltimore from the NEI dataframe
Ravens <- NEI[which(NEI$"fips"=="24510"),]

###Find the aggregate sum of emissions by year and type
totalsdos<-aggregate(Emissions~year+type,Ravens,sum)

###Set the plot width and height & create the PNG file
png("./exdata-data-NEI_data/Plot3.png",width=640,height=480)

###Plot the data with lines placing different colors on type
plot<- ggplot(totalsdos,aes(year,Emissions,color=type))
plot <- plot + geom_line(lwd=3) +
  xlab("Year") +
  ylab("Total PM2.5 Emissions") +
  ###Add the title and answer the question
  ggtitle(expression(atop("Total Emissions in Baltimore City",
                          atop(italic("All variables have seen decreases, Point has seen an increase"),""))))+
  ###Increase the font size of the title
  theme(plot.title=element_text(size=rel(2)))
###Print the plot
print(plot)
dev.off()