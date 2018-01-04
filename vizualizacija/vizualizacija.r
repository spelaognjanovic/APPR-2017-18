# 3. faza: Vizualizacija podatkov

#Graf najboljših 10 igralcev z največ zmagami na Grand Slam turnirjih.
top10 <- ggplot(zmagovalci %>% group_by(DRZAVA) %>% summarise(stevilo = n()) %>%
                  arrange(desc(stevilo)) %>% top_n(10),
                aes(x = reorder(DRZAVA, -stevilo), y = stevilo)) + geom_col() +
  xlab("Država") + ylab("Število uvrstitev") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


#Graf hitrost serve
tocke <- ggplot(hitrosti.serve, aes(x =reorder(Player, -Speed), y = Speed)) + geom_col() +
  xlab("Leto") + ylab("Hitrost serve") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))



# Uvozimo zemljevid.

svet <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                        "ne_50m_admin_0_countries", encoding = "UTF-8")




zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
zemljevid <- pretvori.zemljevid(zemljevid)

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
