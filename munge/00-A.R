# checkpoint("2015-01-15") ## or any date in YYYY-MM-DD format after 2014-09-17  https://tinyurl.com/yddh54gn
collegeinfo<-collegeinfo[,which(unlist(lapply(collegeinfo, function(x)!all(is.na(x))))),with=F]     # https://tinyurl.com/y8nzfuv4

enroll <- data.table(inner_join(collegeinfo, enrollment))                                           # https://tinyurl.com/y79adk6w
enroll[is.na(enroll) ] <- 0                                                                         # replace na's with 0         
names(enroll)[5:10] <- substring(names(enroll)[5:10],2)                                             # remove 1st char from column name      https://tinyurl.com/ycamjal3

enroll_length <- select(enroll,4:10)
enroll_type <- select(enroll,3, 5:10)
enroll_length_type <- enroll[, lapply(.SD, sum, na.rm=TRUE), by=list(Type,Length), .SDcols=c(5:10) ] 

col_hdr_yr <- substr(colnames(enroll_length[-1]),2, 5)[-1]

chart_enroll_by_length <- enroll[, lapply(.SD, sum, na.rm=TRUE), by=Length, .SDcols=c(5:10) ]       # https://tinyurl.com/y7rvrayq

enroll_length_yoy_2yr <-
  gather(chart_enroll_by_length, "year", "n", 2:7) %>%
  rename_at( 3, ~"enrollment" ) %>%
  filter(str_detect(Length, "^T")) %>%
  arrange(year, desc(Length)) %>%
  mutate(enrollment_pct = enrollment/ sum(enrollment)) %>%
  mutate(YOY=(enrollment-lag(enrollment,1))/lag(enrollment,1)*100) %>%
  mutate_all(.funs = funs(ifelse(is.na(.), 0, .))) %>%
  data.table(.)

enroll_length_yoy_4yr <-
  gather(chart_enroll_by_length, "year", "n", 2:7) %>%
  rename_at( 3, ~"enrollment" ) %>%
  filter(str_detect(Length, "^F")) %>%
  arrange(year, desc(Length)) %>%
  mutate(enrollment_pct = enrollment/ sum(enrollment)) %>%
  mutate(YOY=(enrollment-lag(enrollment,1))/lag(enrollment,1)*100) %>%
  mutate_all(.funs = funs(ifelse(is.na(.), 0, .))) %>%
  data.table(.)

enroll_length_yoy <- inner_join(enroll_length_yoy_2yr, enroll_length_yoy_4yr, by='year')

#
chart_enroll_by_type <- enroll[, lapply(.SD, sum, na.rm=TRUE), by=Type, .SDcols=c(5:10) ]           # https://tinyurl.com/y7rvrayq

enroll_type_yoy_public <-
  gather(chart_enroll_by_type, "year", "n", 2:7) %>%
  rename_at( 3, ~"enrollment" ) %>%
  filter(str_detect(Type, "^P")) %>%
  arrange(year, desc(Type)) %>%
  mutate(enrollment_pct = enrollment/ sum(enrollment)) %>%
  mutate(YOY=(enrollment-lag(enrollment,1))/lag(enrollment,1)*100) %>%
  mutate_all(.funs = funs(ifelse(is.na(.), 0, .))) %>%
  data.table(.)

enroll_type_yoy_ind <-
  gather(chart_enroll_by_type, "year", "n", 2:7) %>%
  rename_at( 3, ~"enrollment" ) %>%
  filter(str_detect(Type, "^I")) %>%
  arrange(year, desc(Type)) %>%
  mutate(enrollment_pct = enrollment/ sum(enrollment)) %>% 
  mutate(YOY=(enrollment-lag(enrollment,1))/lag(enrollment,1)*100) %>%
  mutate_all(.funs = funs(ifelse(is.na(.), 0, .))) %>%
  data.table(.)

enroll_type_yoy <- inner_join(enroll_type_yoy_public, enroll_type_yoy_ind, by='year')

enroll_yoy <-  inner_join(enroll_length_yoy, enroll_type_yoy, by='year')

dt <- enroll[, 3:5]
names(dt) <- c("type", "length", "enrollment")  
dt[, Mean:=mean(enrollment), by=list(type, length)]
dt<-dt[, -3]
enroll_distinct<- dt %>% distinct(type, length, Mean)