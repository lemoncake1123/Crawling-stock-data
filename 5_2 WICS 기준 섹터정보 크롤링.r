library(httr)
library(rvest)
library(car)
library(stringr)
library(readr)
library(magrittr) 
library(dplyr)
library(jsonlite)

#Today!
url = 'https://finance.naver.com/sise/sise_index.nhn?code=KOSPI'


biz_day = GET(url) %>% 
  read_html(encoding = 'EUC-KR') %>% 
  html_nodes(xpath = '//*[@id="time"]') %>% 
  html_text() %>% 
  str_match(('[0-9]+.[0-9]+.[0-9]+')) %>% 
  str_replace_all('\\.','')


sector_code = c('G25', 'G35', 'G50', 'G40', 'G10','G20', 'G55', 'G30', 'G15', 'G45')

data_sector = list()



for (i in sector_code) {
  
  url = paste0('http://www.wiseindex.com/Index/GetIndexComponets',
                '?ceil_yn=0&dt=',biz_day,  '&sec_cd=', i)
 
  data = fromJSON(url)
  
  data = data$list
  
  data_sector[[i]] = data
  
  
  Sys.sleep(1)
  
}


data_sector = do.call(rbind, data_sector)


write.csv(data_sector, 'data/KOR_sector.csv')

