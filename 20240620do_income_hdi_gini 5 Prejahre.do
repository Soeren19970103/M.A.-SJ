//Arbeitsverzeichnis festlegen
cd "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata"
cd "D:\OneDrive\Studium\Master AWG\Masterarbeit\stata"
//Datensatz importieren
import excel "D:\OneDrive\Studium\Daten\20240610Datensatz erweitert.xlsx", sheet("Datensatz") firstrow
 import excel "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\Daten\20240610Datensatz erweitert.xlsx", sheet("Datensatz") firstrow
//Datensatz bearbeiten: interpolierenbysort country_no: ipolate gdpc year, generate (gdpc1) epolate
bysort country_no: ipolate gdpc year, generate (gdpc1) epolate
drop gdpc 
rename gdpc1 gdpc 

bysort country_no: ipolate popgr year, generate (popgr1) epolate
drop popgr 
rename popgr1 popgr

bysort country_no: ipolate trade year, generate (trade1) epolate
drop trade
rename trade1 trade

bysort country_no: ipolate emp year, generate (emp1) epolate
drop emp
rename emp1 emp

bysort country_no: ipolate ind year, generate (ind1) epolate
drop ind
rename ind1 ind

bysort country_no: ipolate con year, generate (con1) epolate
drop con
rename con1 con

bysort country_no: ipolate cap year, generate (cap1) epolate
drop cap
rename cap1 cap

bysort country_no: ipolate povhead year, generate (povhead1) epolate
drop povhead
rename povhead1 povhead

bysort country_no: ipolate exp year, generate (exp1) epolate
drop exp
rename exp1 exp 

bysort country_no: ipolate inf year, generate (inf1) epolate
drop inf
rename inf1 inf

bysort country_no: ipolate Uemp year, generate (Uemp1) epolate
drop Uemp
rename Uemp1 Unemp

bysort country_no: ipolate Mortinfant year, generate (Mortinfant1) epolate
drop Mortinfant
rename Mortinfant1 Mortinfant

bysort country_no: ipolate hdi year, generate (hdi1) epolate
drop hdi
rename hdi1 hdi

bysort country_no: ipolate lifexp year, generate (lifexp1) epolate
drop lifexp
rename lifexp1 lifeexp

bysort country_no: ipolate expsy year, generate (expsy1) epolate
drop expsy
rename expsy1 expsy

bysort country_no: ipolate msy year, generate (msy1) epolate
drop msy
rename msy1 msy

bysort country_no: ipolate gnipc year, generate (gnipc1) epolate
drop gnipc
rename gnipc1 gnipc

bysort country_no: ipolate gini year, generate (gini1) epolate
drop gini
rename gini1 gini
//dummy Variablen erstellen
generate donor_latin = inlist(country_no, 3, 5, 6, 19, 32, 33, 36, 37, 38, 39, 42)
generate donor_east = inlist(country_no, 7, 9, 16, 17, 23, 24, 28, 11)
generate donor_both = inlist(country_no, 14, 18, 7, 28, 27)
generate donor_westernworld = inlist(country_no, 8, 19, 12, 14, 18, 20, 21, 26, 30, 31, 34, 35, 40, 41)
generate donor_asia = inlist(country_no, 13, 27)

// frühstes Treatment ist 1991 damit Jahr 1990 entfernen
drop if year == 1990 

//Datensatz als Paneldatensatz definieren
tsset country_no year 

//Datensatz ist balanced fertig vorbereitet und kann abspeichert werden
save income_hdi_ginidata_erweitert, replace


//Regression China
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\income_hdi_ginidata_erweitert.dta",clear
keep if donor_east == 1 | donor_latin == 1 | donor_both ==1 | donor_asia == 1 | country_no == 4
//Treatment mit Vergabe 2001
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform(hdi,demean) bcorrect(merge) pvalues keep(HDIdata_china, replace) trunit(4) trperiod(2001) gapfigure(placebos bcorrect, save(grafik_hdi_china, replace) ytitle(Treatment effect (HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2) xscale(range(1991 2018)))
allsynth gini lifeexp expsy msy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_china, replace) trunit(4) trperiod(2001) gapfigure(placebos bcorrect, save(grafik_gini_china, replace) ytitle(Treatment effect (Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2) xscale(range(1991 2018))) 

//Treatment mit Ereignis 2008
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform (hdi, demean) bcorrect(merge) pvalues keep(HDIdata_china_ereignis, replace) trunit(4) trperiod(2008) gapfigure(placebos bcorrect,  save(grafik_hdi_china_Ereignis, replace) ytitle(Treatment effect (HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2) xscale(range(1991 2018))) 
allsynth gini lifeexp expsy msy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_china_ereignis, replace) trunit(4) trperiod(2008) gapfigure(placebos bcorrect, save(grafik_gini_china_Ereignis, replace) ytitle(Treatment effect (Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2) xscale(range(1991 2018)))

//Regression Canada 
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\income_hdi_ginidata_erweitert.dta",clear
keep if donor_westernworld == 1 |country_no == 2

//Treatment mit Vergabe 2003
keep if year > 1992
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform (hdi,demean) bcorrect(merge) pvalues keep(HDIdata_canada, replace) trunit(2) trperiod(2003)gapfigure(placebos bcorrect, save(grafik_hdi_canada, replace) ytitle(Treatment effect (HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))  
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, bcorrect(merge) pvalues keep(ginidata_canada, replace) trunit(2) trperiod(2003) gapfigure(bcorrect placebos, save(grafik_GINI_canada, replace) ytitle(Treatment effect (Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))

//Treatment mit Ereignis
keep if year > 1992
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform (hdi gnipc,demean) bcorrect(merge) pvalues keep(HDIdata_canada_ereignis, replace) trunit(2) trperiod(2010) gapfigure(placebos bcorrect, save(grafik_hdi_canada_Ereignis, replace) ytitle(Treatment effect (HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)) 
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, bcorrect(merge) pvalues keep(ginidata_canada_ereignis, replace) trunit(2) trperiod(2010) gapfigure(bcorrect placebos, save(grafik_GINI_canada_ereignis, replace) ytitle(Treatment effect (Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))

//Regression Südafrika
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\income_hdi_ginidata_erweitert",clear
keep if donor_latin == 1 | donor_east == 1 |donor_asia == 1 | donor_both == 1 | country_no == 25

//Treatment mit Vergabe
keep if year > 1993
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform(hdi, demean) bcorrect(merge) pvalues keep(HDIdata_southafrica, replace) trunit(25) trperiod(2004) gapfigure(placebos bcorrect, save(grafik_hdi_southafrica, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)))
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_southafrica, replace) trunit(25) trperiod(2004) gapfigure(placebos bcorrect, save(grafik_Gini_southafrica, replace) ytitle(Treatment effect(Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))´

//Spezifikation HDI mit nur 5 Pre-Teratmenteinheiten
keep if year > 1998
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform(hdi, demean) bcorrect(merge) pvalues keep(HDIdata_southafrica_kurzpre, replace) trunit(25) trperiod(2004)gapfigure(placebos bcorrect, save(grafik_hdi_southafrica_kurzpre, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)))


//Treatment mit Ereignis
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform(hdi, demean) bcorrect(merge) pvalues keep(HDIdata_southafrica_ereignis_kurzpre, replace) trunit(25) trperiod(2010) gapfigure(placebos bcorrect, save(grafik_HDI_southafrica_Ereignis_kurzpre, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_southafrica_ereignis, replace) trunit(25) trperiod(2010) gapfigure(placebos bcorrect, save(grafik_Gini_southafrica_Ereignis, replace) ytitle(Treatment effect(Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)) 

//Spezifikation HDI mit weniger Pre-Teratmenteinheiten
keep if year > 1998
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform(hdi, demean) bcorrect(merge) pvalues keep(HDIdata_southafrica_kurzpre_Ereignis, replace) trunit(25) trperiod(2010)gapfigure(placebos bcorrect, save(grafik_hdi_southafrica_kurzpre_Ereignis, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)))

//Regression UK
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\income_hdi_ginidata_erweitert",clear
keep if donor_westernworld == 1 |country_no == 29
//Treatment mit Vergabe
keep if year > 1994
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade,transform(hdi, demean) bcorrect(merge) pvalues keep(HDIdata_UK, replace) trunit(29) trperiod(2005) gapfigure(placebos bcorrect, save(grafik_HDI_UK, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))  
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_UK, replace) trunit(29) trperiod(2005) gapfigure(placebos bcorrect, save(grafik_GINI_UK, replace) ytitle(Treatment effect(Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)) 

//Treatment mit Ereingis
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, transform(hdi, demean) bcorrect(merge) pvalues keep(HDIdata_UK_ereignis, replace) trunit(29) trperiod(2012) gapfigure(placebos bcorrect, save(grafik_HDI_UK_Ereignis, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_UK_ereignis, replace) trunit(29) trperiod(2012) gapfigure(placebos bcorrect, save(grafik_GINI_UK_Ereignis, replace) ytitle(Treatment effect(Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))

//Regression Brasilien
use "D:\OneDrive\Studium\Master AWG\Masterarbeit\stata\income_hdi_ginidata_erweitert.dta",clear
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\income_hdi_ginidata_erweitert.dta",clear
keep if donor_latin == 1 | country_no == 1
//Treatment mit Vergabe
keep if year > 1996
allsynth hdi gnipc lifeexp expsy msy gdpc Unemp trade, transform(hdi, demean) bcorrect(merge) pvalues keep(HDIdata_Brasil, replace) trunit(1) trperiod(2007) gapfigure(placebos bcorrect, save(grafik_HDI_Brasil, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))  
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_Brasil2, replace) trunit(1) trperiod(2007) gapfigure(placebos bcorrect, save(grafik_GINI_Brasil2, replace) ytitle(Treatment effect(Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)

//Treatment WM
keep if year > 1996
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, bcorrect(merge) pvalues keep(HDIdata_Brasil_WM2, replace) trunit(1) trperiod(2014) gapfigure(placebos bcorrect, save(grafik_HDI_Brasil_WM2, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_Brasil_WM2, replace) trunit(1) trperiod(2014) gapfigure(placebos bcorrect, save(grafik_GINI_Brasil_WM2, replace) ytitle(Treatment effect(Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2)) 

//Treatment Olympia
keep if year > 1996
allsynth hdi lifeexp expsy msy gnipc gdpc Unemp trade, bcorrect(merge) pvalues keep(HDIdata_Brasil_OSS2, replace) trunit(1) trperiod(2016) gapfigure(placebos bcorrect, save(grafik_HDI_Brasil_OSS2, replace) ytitle(Treatment effect(HDI)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))
allsynth gini lifeexp msy expsy gnipc gdpc Unemp trade, transform (gini, demean) bcorrect(merge) pvalues keep(ginidata_Brasil_OSS2, replace) trunit(1) trperiod(2016) gapfigure(placebos bcorrect, save(grafik_GINI_Brasil_OSS2, replace) ytitle(Treatment effect(Gini-Koeffizient)) xtitle(Jahre) scheme(tufte) yscale(range (-.2 .2)) ylabel(-.2(.1).2))

