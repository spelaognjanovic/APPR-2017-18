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
serva <- ggplot(hitrosti.serve, aes(x = Rank, y = Hitrost, color = Spol)) + geom_line(size = 0.75) + geom_point(size = 1.5) +
  xlab("Razporeditev") + ylab("Km/s") + ggtitle("Hitrost serve")

plot(serva)

#Graf 3, prikaz dominantne starosti
leto <- ggplot(tenisaci, aes(x = Sezona, y = Prevladujoca_starost)) + geom_line() + geom_point() +
  xlab("Leto") + ylab("Starost") + ggtitle("Prevladujoča starost igralcev v posamezni sezoni") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) 
"ka tto theme sploh pomeni"
plot(leto)

# Uvozimo zemljevid.

svet <- uvozi.zemljevid("http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/cultural/ne_50m_admin_0_countries.zip",
                        "ne_50m_admin_0_countries", encoding = "UTF-8")


zemljevid.drzav <- ggplot() +
  geom_polygon(data = drzave %>% summarise(stevilo = sum(Drzava)) %>% right_join(svet),
               aes(x = long, y = lat, group = group, fill = stevilo)) +
  coord_cartesian(xlim = c(-22, 40), ylim = c(30, 70))





zemljevid <- uvozi.zemljevid("http://baza.fmf.uni-lj.si/OB.zip",
                             "OB/OB", encoding = "Windows-1250")
levels(zemljevid$OB_UIME) <- levels(zemljevid$OB_UIME) %>%
  { gsub("Slovenskih", "Slov.", .) } %>% { gsub("-", " - ", .) }
zemljevid$OB_UIME <- factor(zemljevid$OB_UIME, levels = levels(obcine$obcina))
zemljevid <- pretvori.zemljevid(zemljevid)

# Izračunamo povprečno velikost družine
povprecja <- druzine %>% group_by(obcina) %>%
  summarise(povprecje = sum(velikost.druzine * stevilo.druzin) / sum(stevilo.druzin))
