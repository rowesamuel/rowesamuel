#ACS API 
#Samuel Rowe
#Sept 1, 2018

rm(list=ls())

############
#Libraries
############
library(acs)
library(XML)
library(stringr)
library(tigris)
library(leaflet)
library(htmlwidgets)

############
#ACS KEY
############
#api.key.install("899aa9ac9d17a4d7451c9bcfcd105ed69329de79")
############
#ACS Geography
############
md<-geo.make(state="MD",county="*",tract="*")
#dccounties<-geo.make(state="DC",county="*",tract="*")
#mdcounties<-geo.make(state="MD",county=c(3,5,510,9,13,17,21,25,27,31,33,35),tract="*")
#vacounties<-geo.make(state="VA",county=c(13,43,47,59,61,107,153,157,177,179,187,510,600,610,630,683,685),tract="*")
#wvcounties<-geo.make(state="WV",county=c(37),tract="*")
#dmv<-dccounties+mdcounties+vacounties+wvcounties

##############
#ACS Lookups
##############
#Use Lookup Finder
#https://censusreporter.org/topics/table-codes/
#Income Lookup
lookup<-acs.lookup(endyear=2016,span=5,table.name="income",case.sensitive = F)
lookupframe<-data.frame(lookup@results)
unique(lookupframe$table.name)

#Race Lookup
lookuprace<-acs.lookup(endyear=2016,span=5,keyword = "race",case.sensitive = F)
lookupracedf<-data.frame(lookup@results)
unique(lookupracedf$table.name)

###############
#Table Calls
###############
#Transportation Pulls
#B08126
b08126<-acs.fetch(endyear=2016,span=5,geo=md,table.name="B08126",col.names="pretty")
b08126df<-data.frame(b08126@geography,b08126@estimate)
colnames(b08126df)
b08126df$publictrans<-(b08126df$MEANS.OF.TRANSPORTATION.TO.WORK.BY.INDUSTRY..Public.transportation..excluding.taxicab../
                         b08126df$MEANS.OF.TRANSPORTATION.TO.WORK.BY.INDUSTRY..Total.)*100
b08126df$state<-str_pad(b08126df$state,2,"left",pad=0)
b08126df$county<-str_pad(b08126df$county,3,"left",pad=0)
b08126df$tract<-str_pad(b08126df$tract,6,"left",pad=0)
b08126df$GEOID<-paste0(b08126df$state,b08126df$county,b08126df$tract)

#Race Pulls
c02003<-acs.fetch(endyear=2016,span=5,geo=md,table.name="C02003",col.names="pretty")
c02003df<-data.frame(c02003@geography,c02003@estimate)
colnames(c02003df)
c02003df$whtpct<-(c02003df$Detailed.Race..Population.of.one.race..White/c02003df$Detailed.Race..Total.)*100
c02003df$blkpct<-(c02003df$Detailed.Race..Population.of.one.race..Black.or.African.American/c02003df$Detailed.Race..Total.)*100
c02003df$asipct<-(c02003df$Detailed.Race..Population.of.one.race..Asian.alone/c02003df$Detailed.Race..Total.)*100
c02003df$othpct<-((c02003df$Detailed.Race..Population.of.one.race..American.Indian.and.Alaska.Native+
                  c02003df$Detailed.Race..Population.of.one.race..Native.Hawaiian.and.Other.Pacific.Islander+
                  c02003df$Detailed.Race..Population.of.one.race..Some.other.race+
                  c02003df$Detailed.Race..Population.of.two.or.more.races.)/
                  c02003df$Detailed.Race..Total.)*100
c02003df$state<-str_pad(c02003df$state,2,"left",pad=0)
c02003df$county<-str_pad(c02003df$county,3,"left",pad=0)
c02003df$tract<-str_pad(c02003df$tract,6,"left",pad=0)
c02003df$GEOID<-paste0(c02003df$state,c02003df$county,c02003df$tract)

#Race and Ethnicity Pulls
b03002<-acs.fetch(endyear=2016,span=5,geo=md,table.name="B03002",col.names="pretty")
b03002df<-data.frame(b03002@geography,b03002@estimate,b03002@currency.year)
colnames(b03002df)
b03002df$whtpct<-(b03002df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..White.alone/
                    b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$ltopct<-(b03002df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino./
                    b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$wltpct<-(b03002df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino..White.alone/
                    b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$oltpct<-((b03002df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino.-
                    b03002df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino..White.alone)/
                    b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$blkpct<-(b03002df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Black.or.African.American.alone/
                    b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$asipct<-(b03002df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Asian.alone/
                    b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$othpct<-((b03002df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..American.Indian.and.Alaska.Native.alone+
                     b03002df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Native.Hawaiian.and.Other.Pacific.Islander.alone+
                     b03002df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Some.other.race.alone)/
                     b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$twopct<-(b03002df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Two.or.more.races./
                    b03002df$Hispanic.or.Latino.by.Race..Total.)*100
b03002df$state<-str_pad(b03002df$state,2,"left",pad=0)
b03002df$county<-str_pad(b03002df$county,3,"left",pad=0)
b03002df$tract<-str_pad(b03002df$tract,6,"left",pad=0)
b03002df$GEOID<-paste0(b03002df$state,b03002df$county,b03002df$tract)

#Race and Ethnicity 2010
b03002_10<-acs.fetch(endyear=2010,span=5,geo=md,table.name="B03002",col.names="pretty")
b03002_10df<-data.frame(b03002_10@geography,b03002_10@estimate,b03002_10@currency.year)
colnames(b03002_10df)

b03002_10df$whtpct<-(b03002_10df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..White.alone/
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$ltopct<-(b03002_10df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino./
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$wltpct<-(b03002_10df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino..White.alone/
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$oltpct<-((b03002_10df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino.-
                     b03002_10df$Hispanic.or.Latino.by.Race..Hispanic.or.Latino..White.alone)/
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$blkpct<-(b03002_10df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Black.or.African.American.alone/
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$asipct<-(b03002_10df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Asian.alone/
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$othpct<-((b03002_10df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..American.Indian.and.Alaska.Native.alone+
                     b03002_10df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Native.Hawaiian.and.Other.Pacific.Islander.alone+
                     b03002_10df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Some.other.race.alone)/
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$twopct<-(b03002_10df$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..Two.or.more.races./
                    b03002_10df$Hispanic.or.Latino.by.Race..Total.)*100
b03002_10df$state<-str_pad(b03002_10df$state,2,"left",pad=0)
b03002_10df$county<-str_pad(b03002_10df$county,3,"left",pad=0)
b03002_10df$tract<-str_pad(b03002_10df$tract,6,"left",pad=0)
b03002_10df$GEOID<-paste0(b03002_10df$state,b03002_10df$county,b03002_10df$tract)

#Merge 2016 and 2010
b03_combined<-merge(b03002df,b03002_10df,by=c("GEOID","NAME","state","county","tract"))
b03_combined$whtdelta<-((b03_combined$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..White.alone.x/
                          b03_combined$Hispanic.or.Latino.by.Race..Not.Hispanic.or.Latino..White.alone.y)-1)*100
b03_combined$whtpctchange<-(b03_combined$whtpct.x-b03_combined$whtpct.y)
b03_combined$blkdelta<-((b03_combined$Hispanic.or.Latino.by.Race..Hispanic.or.Latino..Black.or.African.American.alone.x/
                           b03_combined$Hispanic.or.Latino.by.Race..Hispanic.or.Latino..Black.or.African.American.alone.y)-1)*100
b03_combined$blkpctchange<-(b03_combined$blkpct.x-b03_combined$blkpct.y)
b03_combined$whtdelta[is.infinite(b03_combined$whtdelta)]<-NA
b03_combined$blkdelta[is.infinite(b03_combined$blkdelta)]<-NA
#b03_combined<-b03_combined[,c(1:6,8,28,36,38,58,66:67)]

#Race and Ethnicity by Age
test<-acs.fetch(endyear=2016,span=5,geo=md,table.name="C01001",col.names="pretty")

#Median Income Pull
b19013<-acs.fetch(endyear=2016,span=5,geo=md,table.name="B19013",col.names="pretty")
b19013df<-data.frame(b19013@geography,b19013@estimate)

#Receipt of Benefits Pull
b09010<-acs.fetch(endyear=2016,span=5,geo=md,table.name="B09010",col.names="pretty")
b09010df<-data.frame(b09010@geography,b09010@estimate)

#Transportation - Percent using public transportation
industry<-acs.lookup(endyear=2016,span=5,table.name="industry",case.sensitive = F)
industryframe<-data.frame(industry@results)
#industryframe2<-industryframe[grepl("Total",industryframe$variable.name)==TRUE,]
b08126<-acs.fetch(endyear=2016,span=5,geo=md,table.name="B08126")
b08126df<-data.frame(b08126@geography,b08126@estimate)
b08126df<-b08126df[,c(1:5,49)]
b19013df<-b19013df[,c(1:5)]
b19013df[b19013df$medianincome==-666666666,]<-0
colnames(b19013df)[5]<-c("medianincome")
#b19013dfdf$pubtranspct<-(b19013dfdf$b19013df_045/b19013dfdf$B08126_001)*100
b19013df$state<-str_pad(b19013df$state,2,"left",pad="0")
b19013df$county<-str_pad(b19013df$county,3,"left",pad="0")
b19013df$tract<-str_pad(b19013df$tract,6,"left",pad="0")
b19013df$GEOID<-paste0(b19013df$state,b19013df$county,b19013df$tract)

#Median Housing Pull
b25077<-acs.fetch(endyear=2016,span=5,geo=md,table.name="B25077",col.names="pretty")
b25077df<-data.frame(b25077@geography,b25077@estimate)
b25077df$state<-str_pad(b25077df$state,2,"left",pad="0")
b25077df$county<-str_pad(b25077df$county,3,"left",pad="0")
b25077df$tract<-str_pad(b25077df$tract,6,"left",pad="0")
b25077df$GEOID<-paste0(b25077df$state,b25077df$county,b25077df$tract)
#Merge Median Housing and Median Income
median<-merge(b25077df,b19013df,by=c("GEOID","NAME","state","county","tract"))
colnames(median)[6]<-"median_house_price"
median$median_house_price[median$median_house_price==-666666666]<-NA
median$medianincome[median$medianincome==-666666666]<-NA
median$housing_income_ratio<-median$median_house_price/median$medianincome

#GEO Codes
counties<-c(510)
tracts<-tracts(state = 'MD', county = c(3,5,13,25,27,35,510), cb=TRUE)
dctracts<-tracts(state='DC',county=c(1),cb=TRUE)
mdtracts<-tracts(state='MD',county=c(3,5,510,9,13,17,21,25,27,31,33,35),cb=TRUE)
vatracts<-tracts(state='VA',county=c(13,43,47,59,61,107,153,157,177,179,187,510,600,610,630,683,685),cb=TRUE)
wvtracts<-tracts(state='WV',county=c(37),cb=TRUE)
dmvtracts<-rbind_tigris(dctracts,mdtracts,vatracts,wvtracts)

b08126df_merge<-geo_join(tracts,b08126df,"GEOID","GEOID")
b19013df_merge<-geo_join(tracts,b19013df,"GEOID","GEOID")
median_merge<-geo_join(tracts,median,"GEOID","GEOID")
race_merge<-geo_join(tracts,c02003df,"GEOID","GEOID")
race_merge2<-geo_join(tracts,b03002df,"GEOID","GEOID")
race_merge3<-geo_join(tracts,b03_combined,"GEOID","GEOID")

#############
#Maps
#############
#Income - Housing Ratio
popup <- paste0("Area: ", median_merge$NAME.1, "<br>", 
                "Median Income: $", round(median_merge$medianincome,2), "<br>",
                "Median Housing Price: $", round(median_merge$median_house_price,2), "<br>",
                "Ratio: ", round(median_merge$housing_income_ratio,2),"<br>",
                "Source: 2012-2016 ACS")
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = median_merge$median_house_price
)

map<-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = median_merge, 
              fillColor = ~pal(median_house_price), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = median_merge$median_house_price, 
            position = "bottomright", 
            title = "Median Income<br>
                     by Census Tract<br>
                     Baltimore MSA",
            labFormat = labelFormat(prefix = "$")) 
map
setwd('/Users/Sam/Desktop/R/rowesamuel/BytheNumbers')
saveWidget(map, file="MedianIncome.html", selfcontained=FALSE)

#Public Transportation
popup <- paste0("Area: ", b08126df_merge$NAME.1, "<br>", 
                "Public Transit %: ", round(b08126df_merge$publictrans), "<br>",
                "Public Transit: ", b08126df_merge$MEANS.OF.TRANSPORTATION.TO.WORK.BY.INDUSTRY..Public.transportation..excluding.taxicab.., "<br>",
                "Total Transit: ", b08126df_merge$MEANS.OF.TRANSPORTATION.TO.WORK.BY.INDUSTRY..Total.,"<br>",
                "Source: 2012-2016 ACS"
                
)
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = b08126df_merge$publictrans,
  na.color = NA
)
map2<-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = b08126df_merge, 
              fillColor = ~pal(publictrans), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = b08126df_merge$publictrans, 
            position = "bottomright", 
            title = "Public Transit to Work %",
            labFormat = labelFormat(prefix = "%")) 
map2
setwd('/Users/Sam/Desktop/R/rowesamuel/BytheNumbers')
saveWidget(map2, file="PublicTransportation.html", selfcontained=FALSE)

#Detailed Race
popup <- paste0("Area: ", race_merge$NAME.1, "<br>", 
                "White Alone %: ", round(race_merge$whtpct,2), "<br>",
                "Black Alone %: ", round(race_merge$blkpct,2), "<br>",
                "Asian Alone %: ", round(race_merge$asipct,2), "<br>",
                "Other %: ", round(race_merge$othpct)
                )
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = race_merge$whtpct
)

map2<-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = race_merge, 
              fillColor = ~pal(whtpct), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = race_merge$whtpct, 
            position = "bottomright", 
            title = "White Alone %",
            labFormat = labelFormat(prefix = "%")) 
map2

#Median Income
popup <- paste0("Area: ", b19013df_merge$NAME.1, "<br>", "Median Income: ", round(b19013df_merge$medianincome,2))
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = b19013df_merge$medianincome
)

map3<-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = b19013df_merge, 
              fillColor = ~pal(medianincome), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = b19013df_merge$medianincome, 
            position = "bottomright", 
            title = "Median Income of Tract",
            labFormat = labelFormat(prefix = "$")) 
map3

#Detailed Race and Ethnicity
popup <- paste0("Area: ", race_merge2$NAME.1, "<br>", 
                "White Alone %: ", round(race_merge2$whtpct,2), "<br>",
                "Latino %: ", round(race_merge2$ltopct,2), "<br>",
                "White Latino %: ", round(race_merge2$wltpct,2), "<br>",
                "Non-White Latino %: ", round(race_merge2$oltpct,2), "<br>",
                "Black Alone %: ", round(race_merge2$blkpct,2), "<br>",
                "Asian Alone %: ", round(race_merge2$asipct,2), "<br>",
                "Other %: ", round(race_merge2$othpct), "<br>",
                "Two or More %: ", round(race_merge2$twopct)
)
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = race_merge2$whtpct
)
map4<-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = race_merge2, 
              fillColor = ~pal(whtpct), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = race_merge2$whtpct, 
            position = "bottomright", 
            title = "White Alone %",
            labFormat = labelFormat(prefix = "%")) 
map4

#Map 5 Race Change 
popup <- paste0("Area: ", race_merge3$NAME.1, "<br>", 
                "White Alone 2016 %: ", round(race_merge3$blkpct.x,2), "<br>",
                "White Alone 2010 %: ", round(race_merge3$blkpct.y,2), "<br>",
                "White Delta: ", round(race_merge3$blkpctchange,2)

)
pal <- colorNumeric(
  palette = "YlGnBu",
  domain = race_merge3$blkpctchange,
  na.color = NA
)
map5<-leaflet() %>%
  addProviderTiles("CartoDB.Positron") %>%
  addPolygons(data = race_merge3, 
              fillColor = ~pal(blkpctchange), 
              color = "#b2aeae", # you need to use hex colors
              fillOpacity = 0.7, 
              weight = 1, 
              smoothFactor = 0.2,
              popup = popup) %>%
  addLegend(pal = pal, 
            values = race_merge3$blkpctchange, 
            position = "bottomright", 
            title = "White Alone Change %",
            labFormat = labelFormat(prefix = "%")) 
map5

