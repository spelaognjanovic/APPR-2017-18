# 2. faza: Uvoz podatkov

sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi hitrost serve iz Wikipedije
uvozi.hitrost.serve <- function() {
  link <- "https://en.wikipedia.org/wiki/Fastest_recorded_tennis_serves"
  stran <- html_session(link) %>% read_html()
  tabele <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>% lapply(html_table)
  spoli <- c("moski", "zenske")
  tabele[[1]]$spol <- factor("moski", levels = spoli)
  tabele[[2]]$spol <- factor("zenske", levels = spoli)
  colnames(tabele[[2]]) <- colnames(tabele[[1]])
  tabela1 <- bind_rows(tabele)
  tabela1$Speed <- parse_number(tabela$Speed)
  
  
  return(tabela1)
}

# Funkcija, ki uvozi zmagovalce Grand Slam turnirja
uvozi.zmagovalce <- function() {
  link <- "https://sl.wikipedia.org/wiki/Seznam_zmagovalcev_turnirjev_za_Grand_Slam_-_mo%C5%A1ki_posami%C4%8Dno"
  stran <- html_session(link) %>% read_html()
  zmagovalci <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>% .[[1]] %>% html_table(fill = TRUE)
    .[[1]] %>% html_table(dec = ",")
  
      
  html_tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>% .[[1]]
  tabela <- html_tabela %>% html_table(fill = TRUE)
  drzave <- html_tabela %>% html_nodes(xpath=".//tr") %>% .[-1] %>%
    sapply(. %>% html_nodes(xpath="./td") %>%
             lapply(. %>% html_nodes(xpath="./a[@class='image']") %>% html_attr("href") %>%
                      sapply(. %>% { gsub("US_.*_Flag", "Flag_of_the_United_States", .) } %>%
                               strapplyc("Flag_of_(.*)\\.svg") %>%
                               { gsub("_", " ", gsub("_\\(.*", "", gsub("^the_", "", .))) }) %>%
                      .[1]) %>% { ifelse(sapply(., is.list), NA, .) %>%
                          c(rep(NA, 5 - length(.)))} %>%
             unlist()) %>% t() %>% data.frame()
  colnames(drzave) <- colnames(tabela)

  return(tabela)
  
}
drzave <- drzave[-c(51,52),]
drzave <- drzave[-c(71:143),]
zmagovalci <- zmagovalci[-c(51,52),]
zmagovalci <- zmagovalci[-c(71:143),]

# Funkcija, ki uvozi podatke o tenisačih (sezona, št. tekem, ime, starost)
uvozi.tenisaci <- function() {
  link <- paste0("http://www.ultimatetennisstatistics.com/seasonsTable?current=1&rowCount=20&sort[season]=desc&searchPhrase=&_=",
                 as.numeric(Sys.time()))
  data <- content(GET(link))$rows %>% lapply(function(x) {
    country <- x$bestPlayer$country$name
    x$bestPlayer <- c(x$bestPlayer$country, x$bestPlayer)
    x$bestPlayer$country <- country
    x <- c(x, x$bestPlayer)
    x$bestPlayer <- NULL
    return(x)
  }) %>% bind_rows()
  data<-data[,-c(2,3,4,5,6,7,9,10,11,12,13,14,15,16,17,18,23,25,26,27)]
}


# Zapišimo podatke v razpredelnico obcine
obcine <- uvozi.obcine()

# Zapišimo podatke v razpredelnico druzine.
druzine <- uvozi.druzine(levels(obcine$obcina))

# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.
