//Arbeitsverzeichnis festlegen
cd "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata"
//Datensatz importieren
 import excel "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\Daten\Datensatz_Einkommen_Ungleichheit_Armut.xlsx", sheet("Datensatz") firstrow

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

//dummy Variablen für den donor pool erstellen
generate donor_latin = inlist(country_no, 3, 5, 6, 19, 32, 33, 36, 37, 38, 39, 42)
generate donor_eastern_europe = inlist(country_no, 7, 9, 16, 17, 23, 24, 28, 11)
generate donor_both = inlist(country_no, 14, 18, 7, 28, 27)
generate donor_veryhighhdi = inlist(country_no, 8, 19, 12, 14, 18, 20, 21, 26, 30, 31, 34, 35, 40, 41)
generate donor_asia = inlist(country_no, 13, 27

//Datensatz als Paneldatensatz definieren
tsset country_no year 

//Datensatz ist balanced, fertig vorbereitet und kann abspeichert werden
save income_hdi_ginidata_erweitert, replace

//Regression China
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Einkommen_Armut_Ungleichheit.dta",clear
keep if donor_east == 1 | donor_latin == 1 | donor_both ==1 | donor_asia == 1 | country_no == 4
allsynth gdpc con cap emp trade,  bcorrect(merge) pvalue keep(gdpdata_china2, replace) trunit(4) trperiod(2001) gapfigure(placebos bcorrect, save(grafik_gdpc_china2, replace) ytitle(Treatmenteffekt) xtitle(Jahre) scheme(tufte) yscale(range (-20000 20000)) ylabel(-20000(5000)20000)) 
allsynth gnipc con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalue keep(gnipcdata_china2, replace) trunit(4) trperiod(2001) gapfigure(placebos bcorrect, save(grafik_gnipc_china2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-20000 20000)) ylabel(-20000(5000)20000)) 

//Regression Ereignis
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_china_ereignis2, replace) trunit(4) trperiod(2008) gapfigure(placebos bcorrect, save(grafik_gdpc_china_Ereignis2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000)) 
allsynth gnipc  con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_china_ereignis2, replace) trunit(4) trperiod(2008) gapfigure(placebos bcorrect, save(grafik_gnipc_china_Ereignis2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000)) 
//Regression Canada 
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Einkommen_Armut_Ungleichheit.dta",clear
keep if donor_westernworld == 1 |country_no == 2
keep if year > 1992
keep if year > 1997
//Treatment mit Vergabe
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_canada2, replace) trunit(2) trperiod(2003) gapfigure(placebos bcorrect, save(grafik_gdpc_canada2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
allsynth gnipc  con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipc_canada2, replace) trunit(2) trperiod(2003) gapfigure(placebos bcorrect, save(grafik_gnipc_canada2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))

//Treatment mit Ereignis
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_canada_ereignis2, replace) trunit(2) trperiod(2010) gapfigure(placebos bcorrect, save(grafik_gdpc_canada_Ereignis2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
allsynth gnipc con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_canada_ereignis2, replace) trunit(2) trperiod(2010) gapfigure(placebos bcorrect, save(grafik_gnipc_canada_Ereignis2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))

//Treatment Südafrika
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Einkommen_Armut_Ungleichheit.dta",clear
keep if donor_latin == 1 | donor_east == 1 |donor_asia == 1 | donor_both == 1 | country_no == 25
keep if year > 1993
keep if year > 1998
//Treatment mit Vergabe
allsynth gdpc  con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_southafrica2, replace) trunit(25) trperiod(2004)gapfigure(placebos bcorrect, save(grafik_gdpc_Südafrika2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000)) 
allsynth gnipc  con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_southafrica2, replace) trunit(25) trperiod(2004) gapfigure(placebos bcorrect, save(grafik_gnipc_Südafrika2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
//Treatment mit Ereignis
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_southafrica_ereignis2, replace) trunit(25) trperiod(2010) gapfigure(placebos bcorrect, save(grafik_gdpc_Südafrika_Ereignis2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
allsynth gnipc con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_southafrica_ereignis2, replace) trunit(25) trperiod(2010) gapfigure(placebos bcorrect, save(grafik_gnipc_Südafrika_Ereignis2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))

//Regression UK
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Einkommen_Armut_Ungleichheit.dta",clear
keep if donor_westernworld == 1 |country_no == 29
keep if year > 1994
keep if year > 1999
//Treatment mit Vergabe
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_UK2, replace) trunit(29) trperiod(2005) gapfigure(placebos bcorrect, save(grafik_gdpc_UK2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
allsynth gnipc con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_UK2, replace) trunit(29) trperiod(2005) gapfigure(placebos bcorrect, save(grafik_gnipc_UK2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))

//Treatment mit Ereingis
keep if year > 2002
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_UK_ereignis2, replace) trunit(29) trperiod(2012) gapfigure(placebos bcorrect, save(grafik_gdpc_UK_Ereignis2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
allsynth gnipc con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_UK_ereignis2, replace) trunit(29) trperiod(2012) gapfigure(placebos bcorrect, save(grafik_gnipc_UK_Ereignis2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))

//Regression Brasilien
use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\income_hdi_ginidata_erweitert.dta",clear
keep if donor_latin == 1 | country_no == 1
keep if year > 1996
//Treatment mit Vergabe
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_Brasil2, replace) trunit(1) trperiod(2007) gapfigure(placebos bcorrect, save(grafik_gdpc_Brasil2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000)) //bcorrect sehr gut beides insignifikant
allsynth gnipc con cap emp trade, transform (gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_Brasil2, replace) trunit(1) trperiod(2007) gapfigure(placebos bcorrect, save(grafik_gnipc_Brasil2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
//Treatment WM
keep if year > 2003
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_Brasil_WM2, replace) trunit(1) trperiod(2014) gapfigure(placebos bcorrect, save(grafik_gdpc_Brasil_WM_Ereignis2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
allsynth gnipc con cap emp trade, transform(gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_Brasil_WM2, replace) trunit(1) trperiod(2014)gapfigure(placebos bcorrect, save(grafik_gnipc_Brasil_WM_Ereignis2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
//Treatment Olympia
keep if year > 2005
allsynth gdpc con cap emp trade, transform (gdpc, demean) bcorrect(merge) pvalues keep(gdpdata_Brasil_OSS2, replace) trunit(1) trperiod(2016) gapfigure(placebos bcorrect, save(grafik_gdpc_Brasil_OSS2, replace) ytitle(Treatment effect (BIP/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))
allsynth gnipc con cap emp trade, transform(gnipc, demean) bcorrect(merge) pvalues keep(gnipcdata_Brasil_OSS2, replace) trunit(1) trperiod(2016) gapfigure(placebos bcorrect, save(grafik_gnipc_Brasil_OSS2, replace) ytitle(Treatment effect (BNE/Kopf)) xtitle(Jahre) scheme(tufte) yscale(range (-10000 10000)) ylabel(-10000(5000)10000))