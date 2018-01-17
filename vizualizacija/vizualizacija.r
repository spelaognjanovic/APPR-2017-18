# 3. faza: Vizualizacija podatkov


#Graf 1 najboljših 10 igralcev z največ zmagami na Grand Slam turnirjih.
top10 <- ggplot(zmagovalci %>% group_by(Zmagovalec) %>% summarise(stevilo = n()) %>%
                  arrange(desc(stevilo)) %>% top_n(10),
                aes(x = reorder(Zmagovalec, -stevilo), y = stevilo)) +
  geom_col(fill="blue") + xlab("Igralec") + ylab("Število zmag na") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
  ggtitle("Razvrstitev po številu zmag na Grand Slam turnirjih")

plot(top10)

#Graf 2 hitrost serve
serva <- ggplot(hitrosti.serve, aes(x = Razvrstitev, y = Hitrost, color = Spol)) +
  geom_line(size = 0.75) + geom_point(size = 1.5) +
  xlab("Razporeditev") + ylab("Km/s") + ggtitle("Hitrost serve")

plot(serva)

#Graf 3, prikaz dominantne starosti
leto <- ggplot(tenisaci, aes(x = Sezona, y = Prevladujoca_starost)) + geom_line() + geom_point() +
  xlab("Leto") + ylab("Starost") + ggtitle("Prevladujoča starost igralcev v posamezni sezoni") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) 
plot(leto)

# Uvozimo zemljevid.

svet <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                        "ne_50m_admin_0_countries", encoding = "UTF-8") %>%
  pretvori.zemljevid() %>% filter(lat > -60)

ponovitev <- zmagovalci %>% group_by(Drzava) %>% summarise(stevilo = n()) %>% arrange(desc(stevilo))  
ponovitev <- ponovitev %>% filter(Drzava != "NA")
ponovitev$Drzava <- gsub("United States", "United States of America", ponovitev$Drzava)
ponovitev$Drzava <- gsub("Serbia", "Republic of Serbia", ponovitev$Drzava)
ponovitev$Drzava <- gsub("Czech Republic", "Czechia", ponovitev$Drzava)
zemljevid.drzav <- ggplot() +
  geom_polygon(data = ponovitev %>% 
                 mutate(SOVEREIGNT = parse_factor(Drzava, levels(svet$SOVEREIGNT))) %>%
                 right_join(svet),
               aes(x = long, y = lat, group = group, fill = stevilo))

print(zemljevid.drzav)

