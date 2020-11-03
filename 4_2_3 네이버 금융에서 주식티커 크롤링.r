library(httr)
library(rvest)
library(car)
library(stringr)


data=list()

#i=0 is kospi, i=1 is kosdaq
for (i in 0:1) {
  
  ticker=list()
  
  url=paste0('https://finance.naver.com/sise/','sise_market_sum.nhn?sosok=',i,'&page=1')
  
  down_table=GET(url)
  
  
  
  navi.final=read_html(down_table, encoding = 'EUC-KR') %>% 
    html_nodes(., '.pgRR') %>% 
    html_nodes(., 'a') %>% 
    html_attr(., 'href') %>% 
    strsplit(., '=') %>% 
    unlist() %>% 
    tail(., 1) %>% 
    as.numeric()
  
  
  
  
for (j in 1:navi.final) {
  url=paste0('https://finance.naver.com/sise/','sise_market_sum.nhn?sosok='
             ,i,'&page=', j)
    down_table=GET(url)
  
    
    
  Sys.setlocale("LC_ALL", "English")
  
  table=read_html(down_table, encoding = "EUC-KR") %>% 
    html_table(fill=TRUE)
  table=table[[2]]
  
  Sys.setlocale("LC_ALL", "Korean")
  
  
  
  
  table[, ncol(table)]=NULL     #select the column that has no value
  table=na.omit(table)
  

  
  symbol=read_html(down_table, encoding = 'EUC-KR') %>% 
    html_nodes(., 'tbody') %>% 
    html_nodes(., 'td') %>% 
    html_nodes(., 'a') %>% 
    html_attr(., 'href')
  
  
  symbol=sapply(symbol, function(x){
    str_sub(x, -6, -1)  
    })
  symbol=unique(symbol)   #delete the same tickers
  
  
  
  
  table$N=symbol
  colnames(table)[1]="종목코드"
  
  rownames(table)=NULL    #reset row names
  ticker[[j]]=table       #write tickers
  
  
  
  Sys.sleep(0.5)
}
  
  
  ticker=do.call(rbind, ticker)
  data[[i+1]]=ticker
}

data=do.call(rbind, data)




write.csv(data, "C:/Users/steam/Documents/data/table.csv")
