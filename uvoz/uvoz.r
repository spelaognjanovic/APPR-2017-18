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
  tabela <- bind_rows(tabele)
  tabela$Speed <- parse_number(tabela$Speed)
  
  for (i in 1:ncol(tabela)) {
    if (is.character(tabela[[i]])) {
      Encoding(tabela[[i]]) <- "UTF-8"
    }
  }
  colnames(tabela) <- c("obcina", "povrsina", "prebivalci", "gostota", "naselja",
                        "ustanovitev", "pokrajina", "regija", "odcepitev")
  tabela$obcina <- gsub("Slovenskih", "Slov.", tabela$obcina)
  tabela$obcina[tabela$obcina == "Kanal ob Soči"] <- "Kanal"
  tabela$obcina[tabela$obcina == "Loški potok"] <- "Loški Potok"
  for (col in c("povrsina", "prebivalci", "gostota", "naselja", "ustanovitev")) {
    tabela[[col]] <- parse_number(tabela[[col]], na = "-", locale = sl)
  }
  for (col in c("obcina", "pokrajina", "regija")) {
    tabela[[col]] <- factor(tabela[[col]])
  }
  return(tabela)
}

# Funkcija, ki uvozi podatke iz datoteke druzine.csv
uvozi.druzine <- function(obcine) {
  data <- read_csv2("podatki/druzine.csv", col_names = c("obcina", 1:4),
                    locale = locale(encoding = "Windows-1250"))
  data$obcina <- data$obcina %>% strapplyc("^([^/]*)") %>% unlist() %>%
    strapplyc("([^ ]+)") %>% sapply(paste, collapse = " ") %>% unlist()
  data$obcina[data$obcina == "Sveti Jurij"] <- "Sveti Jurij ob Ščavnici"
  data <- data %>% melt(id.vars = "obcina", variable.name = "velikost.druzine",
                        value.name = "stevilo.druzin")
  data$velikost.druzine <- parse_number(data$velikost.druzine)
  data$obcina <- factor(data$obcina, levels = obcine)
  return(data)
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
