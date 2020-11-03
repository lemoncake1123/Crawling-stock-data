library(httr)
library(rvest)
library(car)
library(stringr)
library(readr)
library(magrittr) 
library(dplyr)



gen_otp_url = 'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'


gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = biz_day, # 최근영업일로 변경
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')

otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()


down_url = 'http://file.krx.co.kr/download.jspx'

down_ind = POST(down_url, query = list(code = otp),
                add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()


write.csv(down_ind, 'data/krx_ind.csv')












