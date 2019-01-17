# checkpoint("2015-01-15") ## or any date in YYYY-MM-DD format after 2014-09-17  https://tinyurl.com/yddh54gn

# how-to-import-most-recent-csv-file-into-rstudio
# https://tinyurl.com/ydgy9pfs

# data_files <- file.info(Sys.glob("O:/IT/Access Files/*.csv"))
# # data_files <- file.info(Sys.glob(filedir))
# access_file_old <-read.csv(row.names(data_files)[which.max(data_files[["ctime"]])])
# files = lapply(row.names(data_files), read.csv, header=F, stringsAsFactors = F)
# files = do.call(rbind,files)
# colnames(files) <- files[1,]                                                    # use 1st row as column name
# files <- files[-1,]                                                             # https://tinyurl.com/ya3v4edm
# files <- 
#   files %>% 
#     filter(grepl("^8", UGAID))
# files[files == '#NA'] <- ""    