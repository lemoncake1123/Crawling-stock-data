library(httr)
library(rvest)
library(car)
library(stringr)
library(readr)
library(magrittr) 
library(dplyr)


# First row is stringsAsFactors, because it is names of each column
down_sector = read.csv('data/krx_sector.csv', row.names = 1,
                       stringsAsFactors = FALSE)
down_ind = read.csv('data/krx_ind.csv',  row.names = 1,
                    stringsAsFactors = FALSE)


#same names of column
intersect(names(down_sector), names(down_ind))


#companies that are only in the sector or the ind
setdiff(down_sector[, '종목명'], down_ind[ ,'종목명'])


#combine the sector and the ind
KOR_ticker = merge(down_sector, down_ind,
                   by = intersect(names(down_sector), names(down_ind)),
                   all = FALSE) #FALSE = return intersection


# order by market capitalization
KOR_ticker = KOR_ticker[order(-KOR_ticker['시가총액.원.']), ]



#스팩: 기업의 실체는 존재하지 않는 서류상 회사(페이퍼컴퍼니)
KOR_ticker = KOR_ticker[!grepl('스팩', KOR_ticker[, '종목명']), ]  


#종목코드 끝이 0이 아닌 우선주: 보통주에 비해서 특정한 우선권을 부여한 주식
#str_sub will recycle all arguments to be the same length as the longest argument
KOR_ticker = KOR_ticker[str_sub(KOR_ticker[, '종목코드'], -1, -1) == 0, ]


rownames(KOR_ticker) = NULL  #행 이름을 초기화
write.csv(KOR_ticker, 'data/KOR_ticker.csv')

