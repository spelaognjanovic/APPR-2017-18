# Analiza podatkov s programom R, 2017/18

Repozitorij z gradivi pri predmetu APPR v študijskem letu 2017/18

## Tematika

Analizirala bom Grand Slam turnirje v tenisu za moške in ženske. 
Podatke bom dobila na povezavi: https://en.wikipedia.org/wiki/List_of_Grand_Slam_men%27s_singles_champions, 
s pomočjo katerih bom oblikovala prvo tabelo, kjer bodo vrstice predstavljale leto tekmovanja, stolpci pa eno od turnirjev Grand Slama (Odprto prvenstvo Avstralije, Anglije, ZDA in Francije).

Primerjala bom tudi turnirje med sabo, kdo je največkrat zmagal na enem izmed turnirjev. Nato bom še primerjala igralce po številu zmag. 

https://en.wikipedia.org/wiki/Grand_Slam_(tennis) 
Na povezavi se nahajajo podatki, s pomočjo katerih bi lahko oblikovala tabale po najuspešnejših igralcih in pri katerih letih so prvič osvojili enega izmed Grand Slam turnirjev.

Morda bom vključila še statistiko najboljših 10 igralcev in jih primerjala med sabo. http://www.atpworldtour.com/en/stats/leaderboard?boardType=pressure&timeFrame=52Week&surface=all&versusRank=all&formerNo1=false 

## Program

Glavni program in poročilo se nahajata v datoteki `projekt.Rmd`. Ko ga prevedemo,
se izvedejo programi, ki ustrezajo drugi, tretji in četrti fazi projekta:

* obdelava, uvoz in čiščenje podatkov: `uvoz/uvoz.r`
* analiza in vizualizacija podatkov: `vizualizacija/vizualizacija.r`
* napredna analiza podatkov: `analiza/analiza.r`

Vnaprej pripravljene funkcije se nahajajo v datotekah v mapi `lib/`. Podatkovni
viri so v mapi `podatki/`. Zemljevidi v obliki SHP, ki jih program pobere, se
shranijo v mapo `../zemljevidi/` (torej izven mape projekta).

## Potrebni paketi za R

Za zagon tega vzorca je potrebno namestiti sledeče pakete za R:

* `knitr` - za izdelovanje poročila
* `rmarkdown` - za prevajanje poročila v obliki RMarkdown
* `shiny` - za prikaz spletnega vmesnika
* `DT` - za prikaz interaktivne tabele
* `maptools` - za uvoz zemljevidov
* `sp` - za delo z zemljevidi
* `digest` - za zgoščevalne funkcije (uporabljajo se za shranjevanje zemljevidov)
* `readr` - za branje podatkov
* `rvest` - za pobiranje spletnih strani
* `reshape2` - za preoblikovanje podatkov v obliko *tidy data*
* `dplyr` - za delo s podatki
* `gsubfn` - za delo z nizi (čiščenje podatkov)
* `ggplot2` - za izrisovanje grafov
* `extrafont` - za pravilen prikaz šumnikov (neobvezno)
