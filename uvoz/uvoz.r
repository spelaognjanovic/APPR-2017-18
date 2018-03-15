# 2. faza: Uvoz podatkov

# sl <- locale("sl", decimal_mark = ",", grouping_mark = ".")

# Funkcija, ki uvozi hitrost serve iz Wikipedije
uvozi.hitrost.serve <- function() {
  link <- "https://en.wikipedia.org/wiki/Fastest_recorded_tennis_serves"
  stran <- html_session(link) %>% read_html()
  tabele <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>% lapply(html_table, fill = TRUE)
  Spoli <- c("Moski", "Zenske")
  tabele[[1]] <- tabele[[1]][1:4]
  tabele[[1]]$Spol <- factor("Moski", levels = Spoli)
  tabele[[2]]$Spol <- factor("Zenske", levels = Spoli)
  colnames(tabele[[2]]) <- colnames(tabele[[1]])
  tabela1 <- bind_rows(tabele) %>% mutate(Speed = parse_number(Speed),
                                             Event = parse_number(Event),
                                             Player = Player %>% strapplyc("^([^[]*)") %>%
                                               unlist()) %>% filter(Rank <= 9)

  colnames(tabela1) <- c("Razvrstitev", "Igralec", "Hitrost", "Leto","Spol")
  return(tabela1)
}
hitrosti.serve <- uvozi.hitrost.serve()   

# Funkcija, ki uvozi zmagovalce Grand Slam turnirja
uvozi.zmagovalce <- function() {
  link <- "https://sl.wikipedia.org/wiki/Seznam_zmagovalcev_turnirjev_za_Grand_Slam_-_mo%C5%A1ki_posami%C4%8Dno"
  stran <- html_session(link) %>% read_html()
  html_tabela <- stran %>% html_nodes(xpath="//table[@class='wikitable']") %>% .[[1]]
  zmagovalci <- html_tabela %>% html_table(fill = TRUE)
  drzave <- html_tabela %>% html_nodes(xpath=".//tr") %>% .[-1] %>%
    sapply(. %>% html_nodes(xpath="./td") %>%
             lapply(. %>% html_nodes(xpath="./a[@class='image']") %>% html_attr("href") %>%
                      sapply(. %>% { gsub("US_.*_Flag", "Flag_of_the_United_States", .) } %>%
                               strapplyc("Flag_of_(.*)\\.svg") %>%
                               { gsub("_", " ", gsub("_\\(.*", "", gsub("^the_", "", .))) }) %>%
                      .[1]) %>% { ifelse(sapply(., is.list), NA, .) %>%
                          c(rep(NA, 5 - length(.)))} %>%
             unlist()) %>% t() %>% data.frame()
  colnames(drzave) <- colnames(html_tabela)
  colnames(drzave) <- c("A","Avstralija", "Francija","Anglija","ZDA")
  drzave <- drzave[-c(51,52),]
 
  drzave <- drzave[,-c(1)]
  zmagovalci <- zmagovalci[-c(51,52),]
  drzave$Leto <- zmagovalci$Leto <- parse_number(zmagovalci$Leto)
  drzave.tidy <- melt(drzave, id.vars = "Leto", variable.name = "Prvenstvo", value.name = "Drzava")
  
  zmagovalci.tidy <- melt(zmagovalci, id.vars = "Leto", variable.name = "Prvenstvo",
                          value.name = "Zmagovalec") %>% inner_join(drzave.tidy) %>%
    mutate(Zmagovalec = Zmagovalec %>% strapplyc("^([^(]*)") %>% unlist() %>%
             trimws()) %>% filter(Leto >= 1950)
  
  return(zmagovalci.tidy)
  
}

zmagovalci <- uvozi.zmagovalce()

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
  data<-data[,-c(2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,21,23,25,26,27,29)]
  colnames(data)=c("Sezona", "Na_prostem", "V_dvorani",
                   "Prevladujoca_starost", "Igralec", "Drzava")
  return(data)
}
tenisaci <- uvozi.tenisaci()



# Če bi imeli več funkcij za uvoz in nekaterih npr. še ne bi
# potrebovali v 3. fazi, bi bilo smiselno funkcije dati v svojo
# datoteko, tukaj pa bi klicali tiste, ki jih potrebujemo v
# 2. fazi. Seveda bi morali ustrezno datoteko uvoziti v prihodnjih
# fazah.

