library(httr)
library(rvest)

Sys.setlocale("LC_ALL", "English")

url='https://kind.krx.co.kr/disclosure/todaydisclosure.do'
data=POST(url, body = 
            list(
              method = 'searchTodayDisclosureSub',
              currentPageSize= '15',
              pageIndex= '1',
              orderMode= '0',
              orderStat= 'D',
              forward= 'todaydisclosure_sub',
              chose= 'S',
              todayFlag= 'N',
              selDate= '2020-10-30'
            ))
data=read_html(data) %>% 
  html_table(fill=TRUE) %>% 
  .[[1]]    #first line is the name of companies

Sys.setlocale("LC_ALL", "Korean")