Skip to content
This repository  
Search
Pull requests
Issues
Gist
 @MukeshSah
 Watch 1
  Star 0
  Fork 0 jlow2499/EPA-PM2.5-Emission-Data-Analysis
 Code  Issues 0  Pull requests 0  Wiki  Pulse  Graphs
Branch: master Find file Copy pathEPA-PM2.5-Emission-Data-Analysis/plot6_project2.R
168017d  on Jun 17, 2015
@jlow2499 jlow2499 first commit
1 contributor
RawBlameHistory     55 lines (42 sloc)  1.86 KB
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

###Subset Los Angeles fomr the mvNEI_SCC data frame
LakersMV <- mvNEI_SCC[which(mvNEI_SCC$"fips"=="06037"),]

###Find the aggregate sum of emissions by year for Baltimore
totalsRavens <- aggregate(Emissions~year+fips,RavensMV,sum)

###Find the aggregate sum of emissions by year for Los Angeles
totalsLakers <- aggregate(Emissions~year+fips,LakersMV,sum)

###Bind Lakers & Ravens
totalscinco <- rbind(totalsRavens,totalsLakers)

###Rename fips with the city names
library(plyr)
cities <- revalue(totalscinco$"fips",c("24510"="Baltimore","06037"="Los Angeles"))

###Bind the new cities vector 
totalscinco <- cbind(totalscinco,cities)

###Drop fips from the data frame
totalscinco <- totalscinco[,-2]

###Set the plot width and height & create the PNG file
png("./exdata-data-NEI_data/Plot6.png",width=800,height=480)

###Draw a bar plot with the new totalscinco data frame
library(ggplot2)
plot <- ggplot(totalscinco,aes(x=factor(year),Emissions))+
  facet_grid(. ~ cities)+
  geom_bar(stat="identity",fill="green4")+
  xlab("Year")+
  ylab("Total PM2.5 Emissions")+
  ggtitle(expression(atop("Total Emissions from Motor Vehicles - Baltimore & Los Angeles",
                          atop(italic("Baltimore has seen the largest change since 1999"),""))))+
  ###Increase the font size of the title
  theme(plot.title=element_text(size=rel(2)))
print(plot)
dev.off()  
