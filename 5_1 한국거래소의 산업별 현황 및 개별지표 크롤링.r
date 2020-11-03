library(httr)
library(rvest)
library(car)
library(stringr)
library(readr)
library(magrittr) 
library(dplyr)

#gen_otp_url에 gen_otp_data를 보내면 OTP를 받음. 
# 그 OTP를 down_url에 제출하면 download.jspx를 다운받는다.
gen_otp_url = 'http://marketdata.krx.co.kr/contents/COM/GenerateOTP.jspx'


#what to send to get otp
gen_otp_data = list(
  name = 'fileDown',
  filetype = 'csv',
  url = 'MKD/03/0303/03030103/mkd03030103',
  tp_cd = 'ALL',
  date = '20190607',
  lang = 'ko',
  pagePath = '/contents/MKD/03/0303/03030103/MKD03030103.jsp')


#getting the OTP only
otp = POST(gen_otp_url, query=gen_otp_data) %>% 
  read_html() %>% 
  html_text()


#where to send
down_url = 'http://file.krx.co.kr/download.jspx'


#send, download, referer=the path
down_sector = POST(down_url, query = list(code = otp),
                   add_headers(referer = gen_otp_url)) %>%
  read_html() %>%
  html_text() %>%
  read_csv()


#generate csv
ifelse(dir.exists('data'), FALSE, dir.create('data'))
write.csv(down_sector, 'data/krx_sector.csv')

