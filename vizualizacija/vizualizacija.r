# 3. faza: Vizualizacija podatkov

#Graf 1 najboljših 10 igralcev z največ zmagami na Grand Slam turnirjih.
top10 <- ggplot(zmagovalci %>% group_by(DRZAVA) %>% summarise(stevilo = n()) %>%
                  arrange(desc(stevilo)) %>% top_n(10),
                aes(x = reorder(DRZAVA, -stevilo), y = stevilo)) + geom_col() +
  xlab("Država") + ylab("Število uvrstitev") +
  theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


#Graf 2 hitrost serve
library(ggplot2)

x = as.array(1:50 / 10)
y = apply(x,1,function (x) x**2)
z = apply(x,1,function (x) x*log(x))
D = data.frame(x=x, y=y, z=z)

ggp = ggplot(data=D) 
ggp = ggp + geom_line(aes(x = x, y = y), color="red")
ggp = ggp + geom_line(aes(x = x, y = z), color="blue")
ggp = ggp + xlab("x-os") + ylab("km/s") + ggtitle("Hitrost serve")

print(ggp)

#Ne
#tocke <- ggplot(hitrosti.serve, aes(x =reorder(Player, -Speed), y = Speed)) + geom_col() +
 # xlab("Leto") + ylab("Hitrost serve") +
  #theme(axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1))


#Graf 3 gostota točk, prikaz dominantne starosti
library(ggplot2)
library(gridExtra)

ggp = ggplot(data)
ggp = ggp + geom_point(aes(x=Petal.Length, y=Petal.Width, color=Species))
ggp = ggp + geom_smooth(aes(x=Petal.Length, y=Petal.Width))
print(ggp)

# Primer prikazovanja gostote toÄŤk.
rand_x =rnorm(10**4)
rand_y =rnorm(10**4)
D = data.frame(x=rand_x, y=rand_y)

ggp1 = ggplot(data=D)
ggp1 = ggp1 + geom_point(aes(x=x, y=y))

ggp2 = ggplot(data=D)
ggp2 = ggp2 + geom_hex(aes(x=x, y=y))
ggp2 = ggp2 + guides(fill=guide_legend("# of points"))

grid.arrange(ggp1, ggp2, ncol=2)

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
