# barplot(colSums(enroll_length[-1]), names.arg = col_hdr_yr, ylab = "Total Enrollment")
# barplot(colSums(enroll_length[-1]), names.arg = col_hdr_yr, xlab = "Year", ylab = "Total Enrollment", main = "Maryville U", font.main = 4, col.main = "Red", cex.main = 1.5, sub = "Enrollment Trends", font.sub = 4, col.sub = "Red", cex.sub = 1.5)  

viz_bar_enroll_by_yr <- plot_ly(enroll.tot.by.yr, x = ~year, y = ~enrollment, type = 'bar', name = 'Enrollment by Year')
saveRDS(viz_bar_enroll_by_yr, file="viz_bar_enroll_by_yr.rds")

names(enroll.delta.type.length)[3:8] <- substring(names(enroll.delta.type.length)[3:8],2)
saveRDS(enroll.delta.type.length, file="enroll.delta.type.length.rds")

delta.college<-data.table(enroll.delta.college[, c(3:5,2)])
delta.college[is.na(delta.college) ] <- 0

delta.college.top <- delta.college %>%
arrange(desc(itd_delta)) %>% 
slice(1:10) 


delta.college<-data.table(enroll.delta.college[, c(3:5,2)])
delta.college[is.na(delta.college) ] <- 0

delta.college.top <- delta.college %>%
arrange(desc(itd_delta)) %>% 
slice(1:10) 

delta.college.bottom <- delta.college %>%
arrange(itd_delta) %>% 
slice(1:10) 

delta.college.top <-data.table(delta.college.top)
delta.college.bottom <-data.table(delta.college.bottom)

delta.college.rank<-merge(delta.college.top, delta.college.bottom, all = TRUE )
delta.college.rank <-data.table(delta.college.rank)
delta.college.rank<-delta.college.rank[order(InstitutionName)]
 
viz.bar.college.rank <- plot_ly(delta.college.rank, x = ~itd_delta, y = ~InstitutionName, type = 'bar', orientation = 'h', name = 'Enrollment by Year')
saveRDS(viz.bar.college.rank, file="viz.bar.college.rank")

viz.line.type.ind <- ggplotly(ggplot(data=enroll_type_yoy_ind[,c(1:3)], aes(x=year, y=enrollment, group=Type)) + geom_line() + geom_point())
viz.line.type.public <- ggplotly(ggplot(data=enroll_type_yoy_public[,c(1:3)], aes(x=year, y=enrollment, group=Type)) + geom_line() + geom_point())
viz.line.length.yoy2 <- ggplotly(ggplot(data=enroll_length_yoy_2yr[,c(1:3)], aes(x=year, y=enrollment, group=Length)) + geom_line() + geom_point())
viz.line.length.yoy4 <- ggplotly(ggplot(data=enroll_length_yoy_4yr[,c(1:3)], aes(x=year, y=enrollment, group=Length)) + geom_line() + geom_point())

saveRDS(viz.line.type.ind, file="viz.line.type.ind.rds")
saveRDS(viz.line.type.public, file="viz.line.type.public.rds")
saveRDS(viz.line.length.yoy2, file="viz.line.length.yoy2.rds")
saveRDS(viz.line.length.yoy4, file="viz.line.length.yoy4.rds")