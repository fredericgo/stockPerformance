library(quantmod)
library("Quandl")
library(PortfolioAnalytics)
Quandl.auth("SPJZa7oprpqBpxpySYaM")

stocks <- read.table('aaa.txt',
           col.names = c("name",
                         "quantity_yest",
                         "bought_price",
                         "sold_price",
                         "quantity1",
                         "quantity2",
                         "quantity3",
                         "avgprice",
                         "amount",
                         "current_price","","","","",""))
stocks[,1] <- gsub("\\[(\\d*)\\]", "\\1", stocks[,1])

names <- paste(stocks[,1], "TW", sep=".")
vars <- paste("s", names, sep="")
#Quandl(names)
names <- names[c(-12,-31, -32, -34, -35, -36)]
stocks <- new.env()

lapply(names, function(n) {
  var <- paste("s", n, sep="")
  stocks[[var]] <- getSymbols(n, auto.assign=FALSE)
})

a <- eapply(stocks, function(x) {
     x[,4]
})

a <- do.call(cbind, a)
a <- na.omit(a)
r <- Return.calculate(a)
charts.PerformanceSummary(r)
chart.RiskReturnScatter(r)
chart.Boxplot(r[,1:3])
chart.RelativePerformance(r[,1:3])
chart.RollingPerformance(r[,1:4])
chart.BarVaR(r)
