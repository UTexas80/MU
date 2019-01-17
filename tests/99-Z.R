# checkpoint("2015-01-15") ## or any date in YYYY-MM-DD format after 2014-09-17  https://tinyurl.com/yddh54gn

## DIAGNOSTIC PAGE
s.info = sessionInfo()
diagnostic = data.frame("Version","Date")
diagnostic[,1]=as.character(diagnostic[,1])
diagnostic[,2]=as.character(diagnostic[,2])
diagnostic.names = NULL

## MAGIC NUMBER ## Strings have not member names - Depends on sessionInfo()
ver =strsplit(s.info[["R.version"]][["version.string"]][1]," ")[[1]][3]
dat = as.character(substr( strsplit(s.info[["R.version"]][["version.string"]][1]," ")[[1]][4],2,11))
diagnostic = rbind(diagnostic,c(ver,dat))

ver = s.info[["platform"]][1]
dat = ""
diagnostic = rbind(diagnostic,c(ver,dat))

diagnostic.names = c(diagnostic.names,"R Version","platform")


if (length(s.info[["otherPkgs"]])> 0){
  for(i in 1:length(s.info[["otherPkgs"]])){
    ver = s.info[["otherPkgs"]][[i]]$Version
    dat = as.character(s.info[["otherPkgs"]][[i]]$Date)
    if(length(dat)==0){dat = " "}
    diagnostic = rbind(diagnostic,c(ver,dat))
    
    diagnostic.names = c(diagnostic.names,s.info[["otherPkgs"]][[i]]$Package)
  }
}

if (length(s.info[["loadedOnly"]])> 0){
  for(i in 1:length(s.info[["loadedOnly"]])){
    ver = s.info[["loadedOnly"]][[i]]$Version
    dat = as.character(s.info[["loadedOnly"]][[i]]$Date)
    if(length(dat)==0){dat = " "}
    diagnostic = rbind(diagnostic,c(ver,dat))
    
    diagnostic.names = c(diagnostic.names,s.info[["loadedOnly"]][[i]]$Package)
  }
}

#Add code diagnostic information
diagnostic = rbind(diagnostic,c(code.version,as.character(code.ModDate)))
diagnostic = rbind(diagnostic,c(performance.version,as.character(performance.ModDate)))
diagnostic = rbind(diagnostic,c(fixedincome.version,as.character(fixedincome.ModDate)))
diagnostic = rbind(diagnostic,c(equity.version,as.character(equity.ModDate)))
diagnostic.names = c(diagnostic.names,"Base Code","Performance Code","Fixed Code","Equity Code")

diagnostic = diagnostic[-1,]
colnames(diagnostic) = c("Version","Date")
rownames(diagnostic) = diagnostic.names

last.diagnostic = 1
diagnostic.rows = 19   #MAGIC NUMBER - TRIAL & ERROR

while (last.diagnostic <= nrow(diagnostic)){
  tmp.diagnostic = diagnostic[last.diagnostic:min(nrow(diagnostic),last.diagnostic+diagnostic.rows),]
  layout(c(1,1))
  textplot(cbind(tmp.diagnostic),valign="top")
  p = captureplot()
  
  if(PPT & chart["SD1"]){
    
    addSlideFunction(doc = mydoc, slideType="Title and Content",
                     slideTitle = "System Diagnostics ", 
                     slideVisual = p,
                     addType = "plot")   
  }
  
  last.diagnostic = last.diagnostic + diagnostic.rows + 1
}

if (PPT) {
  #Add TOC
  toc = toc[-1] # Remove 1st empty entry
  
  #Number of rows that show in a column
  TOC.rows = 19  #MAGIC NUMBER - TRIAL & ERROR
  lasttoc = 1
  
  toc.pages = ceiling(ceiling(length(toc)/(TOC.rows+1))/2)
  #if there is more than 1 TOC page, change page #s
  if (toc.pages > 1){
    x = substr(toc,0,38)
    y = substr(toc,39,99)
    y = as.numeric(y)
    y = y + toc.pages - 1
    y = as.character(y)
    y[is.na(y)] = ""
    toc = paste(x,y)
  }
  
  while (lasttoc <= length(toc)){
    
    toc1 = toc[lasttoc:min(lasttoc+TOC.rows,length(toc))]
    textplot(toc1,halign="left",valign="top",cex=1.5)
    p = captureplot()
    
    lasttoc = lasttoc + TOC.rows + 1
    addSlideFunction(doc = mydoc, slideType="Title and Content",
                     slideTitle = "Table of Contents ", 
                     slideVisual = p,
                     addType = "plot")   
    
    if (lasttoc <= length(toc)) {
      toc1 = toc[lasttoc:min(lasttoc+TOC.rows,length(toc))]
      textplot(toc1,halign="left",valign="top",cex=1.5)
      p = captureplot()
      
      lasttoc = lasttoc + TOC.rows + 1
      addSlideFunction(doc = mydoc, slideType="Title and Content",
                       slideTitle = "Table of Contents ", 
                       slideVisual = p,
                       addType = "plot")   
    }
    
  }
  
  #Save File
  if (SAVE.FILE){
    filename = paste(strftime(max(index(performance)),format="%Y.%m.%d"),"-",client[1,"Short Name"],sep = "")
    
    writeDoc(mydoc, paste(filename, ".pptx", sep=""))
    
  }
  
  #Close Powerpoint
  rm(mydoc)
  PPT = FALSE
}

finish.time = Sys.time()
time = finish.time = start.time

# VERSION HISTORY
# 2019.01.05 - v.1.0.0
# 1st release