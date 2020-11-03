library(httr)
library(rvest)
library(car)
library(stringr)
library(readr)
library(magrittr) 
library(dplyr)

#krx_sector.csv, krx_ind.csv    creating


#Today!
url = 'https://finance.naver.com/sise/sise_index.nhn?code=KOSPI'


biz_day = GET(url) %>% 
  read_html(encoding = 'EUC-KR') %>% 
  html_nodes(xpath = '//*[@id="time"]') %>% 
  html_text() %>% 
  str_match(('[0-9]+.[0-9]+.[0-9]+')) %>% 
  str_replace_all('\\.','')



# Sector OTP generate
gen_otp_url =
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'


gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = biz_day, # today
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')


#gen otp
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()



# sector data download
down_url = 'http://file.krx.co.kr/download.jspx'
down_sector = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()


#create csv file
ifelse(dir.exists('data'), FALSE, dir.create('data'))
write.csv(down_sector, 'data/krx_sector.csv')





# individual OTP

gen_otp_url =
  'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'


gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = "MKD/13/1302/13020401/mkd13020401",
  market_gubun = 'ALL',
  gubun = '1',
  schdate = biz_day, # 최근영업일로 변경
  pagePath = "/contents/MKD/13/1302/13020401/MKD13020401.jsp")

#gen ind otp
otp = POST(gen_otp_url, query = gen_otp_data) %>%
  read_html() %>%
  html_text()


# ind data download
down_url = 'http://file.krx.co.kr/download.jspx'


down_ind = POST(down_url, query = list(code = otp),
                add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()


#create csv data
write.csv(down_ind, 'data/krx_ind.csv')


