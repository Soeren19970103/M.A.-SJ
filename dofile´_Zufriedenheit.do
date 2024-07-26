//Arbeitsverzeichnis festlegen
cd "D:\OneDrive\Studium\Master AWG\Masterarbeit\stata"
//Datensatz importieren
import excel "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\Daten\Datensatz_Zufriedenheit.xlsx", sheet("Tabelle1") firstrow

//Datensatz bearbeiten: interpolieren
bysort country_no: ipolate lifelad year, generate (lifelad1) epolate
drop lifelad
rename lifelad1 lifelad

bysort country_no: ipolate loggdp year, generate (loggdp1) epolate
drop loggdp
rename loggdp1 loggdp

bysort country_no: ipolate socsup year, generate (socsup1) epolate
drop socsup
rename socsup1 socsup

bysort country_no: ipolate healifeexp year, generate (healifeexp1) epolate
drop healifeexp
rename healifeexp1 healifeexp

bysort country_no: ipolate lifechoices year, generate (lifechoices1) epolate
drop lifechoices
rename lifechoices1 lifechoices

bysort country_no: ipolate gen year, generate (gen1) epolate
drop gen
rename gen1 gen

bysort country_no: ipolate corup year, generate (corup1) epolate
drop corup
rename corup1 corup

bysort country_no: ipolate posaff year, generate (posaff1) epolate
drop posaff
rename posaff1 posaff

bysort country_no: ipolate negaff year, generate (negaff1) epolate
drop negaff
rename negaff1 negaff

// Länder und Jahre mit großen Datenlücken löschen
drop if year == 2005
drop if country_no == 12 | country_no == 18

//dummy Variablen erstellen
generate donor_latin = inlist(country_no, 3, 5, 6, 19, 32, 33, 36, 37, 38, 39, 42)
generate donor_eastern_europe = inlist(country_no, 7, 9, 16, 17, 23, 24, 28, 11)
generate donor_both = inlist(country_no, 14, 18, 7, 28, 27)
generate donor_veryhighhdi = inlist(country_no, 8, 19, 12, 14, 18, 20, 21, 26, 30, 31, 34, 35, 40, 41)
generate donor_asia = inlist(country_no, 13, 27

//Datensatz als Paneldatensatz definieren
tsset country_no year 

// Datensatz ist fertig vorbereitet, balanced und kann abgespeichert werden
save Zufriedenheit, replace

//Durchführung der Schäzung 
//Regression China
 use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Zufriedenheit.dta"
 keep if country_no == 4 | donor == 1
allsynth lifelad loggdp socsup healifeexp lifechoices gen posaff negaff, bcorrect(merge) pvalues keep(gdpdata, replace) trunit(4) trperiod(2008) gapfigure(classic bcorrect)
// Regression Kanada
 use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Zufriedenheit.dta",clear
 keep if country_no == 2 | donor == 1
allsynth lifelad loggdp socsup healifeexp lifechoices corup gen posaff negaff, transform(lifelad, demean) bcorrect(merge) pvalues keep(gdpdata, replace) trunit(2) trperiod(2010) gapfigure(classic bcorrect) 
// Regression Südafrika 2010
 use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Zufriedenheit.dta",clear
 keep if country_no == 25 | donor == 1
allsynth lifelad loggdp socsup healifeexp lifechoices gen corup posaff negaff, transform(lifelad, demean) bcorrect(merge) pvalues keep(gdpdata, replace) trunit(25) trperiod(2010) gapfigure(classic bcorrect)
// Regression England
 use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Zufriedenheit.dta",clear
 keep if country_no == 29 | donor == 1
allsynth lifelad loggdp socsup healifeexp lifechoices gen corup posaff negaff, transform(lifelad, demean) bcorrect(merge) pvalues keep(gdpdata, replace) trunit(29) trperiod(2010) gapfigure(classic bcorrect)
//Regression Brasilien 
 use "C:\Users\soere\OneDrive\Studium\Master AWG\Masterarbeit\stata\Zufriedenheit.dta"
 keep if country_no == 1 | donor == 1
 // Treatment 2014
allsynth lifelad loggdp socsup healifeexp lifechoices gen corup posaff negaff, bcorrect(merge) pvalues keep(gdpdata, replace) trunit(1) trperiod(2014) gapfigure(classic bcorrect)
// Treatment 2016
allsynth lifelad loggdp socsup healifeexp lifechoices gen corup posaff negaff, transform (lifelad, demean) bcorrect(merge) pvalues keep(gdpdata, replace) trunit(1) trperiod(2016) gapfigure(classic bcorrect)