# Example preprocessing script.
enroll_length_by_year<-gather(enroll_length, "year", "n", 2:7)

dt<- enroll[, 3:5]
names(dt) <- c("type", "length", "enrollment")  
dt[, Mean:=mean(enrollment), by=list(type, length)]
dt<-dt[, -3]
dt %>% distinct(type, length, Mean)
enroll_unique <- dt


enroll.delta.type.length<-formatPercentage(enroll.delta.type.length, 9, digits = 0)


enroll.delta.type.length[-5,c(1:2,8)]
ggplot(enroll.delta.type.length[-5,c(1:2,8)], aes(area = gdp_mil_usd, fill = hdi, label = country)) +
  geom_treemap() +
  geom_treemap_text(fontface = "italic", colour = "white", place = "centre",
                    grow = TRUE)


# https://stackoverflow.com/questions/29253844/r-treemap-how-to-add-multiple-labels
ggplot(x, aes(area = 2016, fill = itd_delta, label = Type,
                subgroup = Length)) +
  geom_treemap() +
  geom_treemap_subgroup_border() +
  geom_treemap_subgroup_text(place = "centre", grow = T, alpha = 0.5, colour =
                             "black", fontface = "italic", min.size = 0) +
  geom_treemap_text(colour = "white", place = "topleft", reflow = T)                    

ggplot(x, aes(area = 2016, fill = itd_delta)) +
  geom_treemap()  


  x<-enroll.delta.type.length[-5,c(1:2,8:9)]
  x$label <- paste(x$Type, x$Length, sep = "\n")
  treemap(x,
    index=c("label"),
    vSize="population",
    vColor="2016",
    type="value")