* JPM-Grameen Survey

* The survey was funded by the J.P. Morgan group & the Grameen Foundation, India
* The survey was conducted between May, 2016 & November, 2016.
* The survey covered 34 villages, 3450 households & 18,396 individuals in the Indian state of Uttar Pradesh, one of the country's poorest states.

* Author - PARIJAT MAITRA

clear
set more off

* using the household details/roster.

use HOUSEHOLD_DETAIL_02A

* Data check

tab state_id
tab dist_id
tab village_id
tab new_hhid
tab new_memid

* Generating unique member IDs

* Unique member ids can be broken up into the following individual components:
*(moving from right to left)
* Last 2 digits - member id of an individual belonging to a particular household.
* Last 4 digits - household listing no. or id(unique for each hh)
* Next 3 digits - village code.
* Next 2 digits - district code.
* First 2 digits - state code.
* So, a unique member id is a 13-digit number.

* This rule-of-thumb would be followed throughout, however,
* Certain portions of the survey is applicable only for households,
* In those cases, I generated the unique HH ID instead of the member ID
* Unique HHID - 11 digit no - doesn't contain the two-digit member ids.

tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
gen double id = real( ID)
order id, a(ID)
format id %13.0f

* Checking for duplicates

duplicates report id


label define maritalstat 1 "Married" 2 "Unmarried" 3 "Widow" 4 "Divorced" 5 "Separated" 6 "Widower"
label values marital_status maritalstat
ren ( Q2_1_COL_11 Q2_1_COL_12 Q2_1_COL_13 Q2_1_COL_14 Q2_1_COL_15 Q2_1_COL_16) ///
(involvedMigration14_15 SelfEmplAgri14_15 SelfEmplNonAgri14_15 AgriCasualLab14_15 NonAgriCasualLab14_15 SalaryWork14_15)

ren ( Q2_1_COL_17 Q2_1_COL_18 Q2_1_COL_19 Q2_1_COL_20 Q2_1_COL_21 Q2_1_COL_22 Q2_1_COL_23 Q2_1_COL_24)///
 (PrimOccuNCO SecOccuNCO PrimActvStatus SecActvStatus HighestClassCompl TotAmtSchool_past12mon TotAmtHealth_past12mon TypeNewspaperRead)
 
 
 foreach var of varlist involvedMigration14_15 - SalaryWork14_15{
label define `var'_1 1 "Yes" 2 "No"
label values `var' `var'_1
}
foreach var of varlist PrimActvStatus SecActvStatus {
label define `var'_1 1 "Self-Employed farming" 2 "Self-employed non-farming" 3 "Salary" 4 " Agri. wage labour" ///
5 " Non-agri wage labour" 6 "Agri. family workers" 7 "Non-agri. family workers" 8 "Pensioner" 9 "Dependent" 10 "Household work" 11 "Student" 12 "Beggar"
label values `var' `var'_1
}
label define edu 0 "Class 0" 1 "Class 1" 2 "Class 2" 3 "Class 3" 4 "Class 4" 5 "Class 5" 6 "Class 6" 7 "Class 7" 8 "Class 8" 9 "Class 9" ///
10 "Class 10" 11 "Class 11" 12 "Class 12"  13 "Graduation" 14" Post-Grad" 15 "Professional" 16 "Illiterate" 17 " Literate but no formal education"
label values HighestClassCompl edu

label define news 1 "National English Daily" 2 "National Hindi daily" 3 "Local newspapers" 4 "Can't read due to illiteracy"
label values TypeNewspaperRead news

label define rel 1 "Self" 2 "Spouse" 3 "Second spouse" 4 "Child" 5 "Grandchild" 6 "Father" 7 "Mother" 8 "Brother" 9 "Sister" 10 "Son-in-law" ///
11 "Daughter-in-law" 12 "Father-in-law" 13 "Mother-in-law" 14 "Grand daughter in law" 15 "Grandson-in-law" 16 "Brother-in-law" ///
17 "Sister-in-law" 18 "Relatives" 19 "No relative relationship"
label values RelationWithHHH rel

label define rea 1 "Father died and you inherited the household" 2 "Father died and you set up separate household" 3 "Husband's death" ///
4 "Set-up separate household (father alive)" 5 "Nominated as the head to prevent loss of property" 6 "Death of the previous head" ///
7 "Death of the older member" 8 "Older member migrated out" 9 "Death of grand parents" 10 "Ageing & incapacitation of the previous head"
label values reason_for_hhh rea

sum TotAmtSchool_past12mon
sum TotAmtHealth_past12mon


winsor2 TotAmtSchool_past12mon , replace cuts(1 99)
winsor2 TotAmtHealth_past12mon , replace cuts(1 99)

codebook height
codebook weight

* There were serious data entry errors in variables height & weight - primarily additional zeroes
* The following codes dealt with those errors.

replace height = height/10 if height>=10 & height & height <100
replace height = height/100 if height >100
replace height = . if height >6
replace height = .  if height <1
replace weight = weight/10 if height <2 & weight >10
replace weight = weight/10 if weight >100

winsor2 weight, replace cuts(0.04 99.96)
save 2Ahh
clear

* using household details data on financial literacy.

use HOUSEHOLD_DETAIL_02B

* generating member ID

tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
gen double id = real( ID)
format id %13.0f
order id, a(ID)
duplicates report id

ren ( Q2_B1_COL_03 Q2_B1_COL_04 Q2_B1_COL_05 Q2_B1_COL_06) (AnalytLiteracy FuncLiteracy TechLiteracy InstiLiteracy)
foreach var of varlist AnalytLiteracy - InstiLiteracy {
label define `var'_1 1 "All incorrect" 2 "1 correct" 3 "2 correct" 4 "3 correct" 5 "4 correct" 6 "5 correct" 7 "All 6 correct"
label values `var' `var'_1
}
save 2Bhh
clear

* using member level income data

use INCOME_EXP_03_A

* The original dataset was shaped in the following way:
* Col Q_3A_COL_01 contained the codes for the income sources used by each household.
* while the corresponding rows contained the amount in rupees earned by each member of the household.
* So, for each household we had 'n' no. of rows where n is the no. of income sources used by all the family members in a given household

* For our purpose I wanted to shape the data in such a way so that for a given household, each row represents a single member(with unique ID)
* and the corresponding values in the neighbouring columns represent his/her income from that particular source with blanks representing 
* those sources from which the member didn't earn any income.
* The following algorithm was used to deal with this issue.

ren Q_3A_COL_01 income_sources
generate source = strofreal(income_sources)
replace source = "source" + subinstr(source,".","_",.)
order source, a( income_sources)
drop income_sources
ren ( Q_3A_COL_03 Q_3A_COL_04 Q_3A_COL_05 Q_3A_COL_06 Q_3A_COL_07 Q_3A_COL_08 Q_3A_COL_09 Q_3A_COL_10 Q_3A_COL_11 Q_3A_COL_12) ///
(new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid8 new_memid9 new_memid10)

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string
save 3Aexp

* renaming the income sources.

ren ( new_memidsource1 new_memidsource2 new_memidsource3 new_memidsource4 new_memidsource5 new_memidsource6 new_memidsource7 ///
new_memidsource8 new_memidsource9 new_memidsource101 new_memidsource102 new_memidsource103 new_memidsource11 new_memidsource12 ///
new_memidsource13 new_memidsource14)  (IncSalaryMonthly IncWages IncOwnCropProd IncLivStck IncPubWorkProg IncNonAgriLabour IncAgriLabour ///
IncConstMaint IncSelfEmploy IncTransfers IncPension IncOthSources IncSaleAssets IncSaleFinAssets IncInterestDivi IncSubsidies)

* generating unique member ID

tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( mem_id , "%02.0f")
order mem, a( mem_id )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
gen double id = real( ID)
format id %13.0f
order id, a(ID)

* Since only hh members above the age of 18 were interviewed in this part of the survey, I dropped all the under-age members.
* the idea being, for such members sum of the income from all sources would be zero.
* So, all members with zero total income were dropped.

foreach k of varlist IncSalaryMonthly - IncSelfEmploy{
replace `k' = 0 if `k' == .
}
gen total = IncSalaryMonthly+ IncTransfers+ IncPension+ IncOthSources+ IncSaleAssets+ IncSaleFinAssets+ IncInterestDivi+ IncSubsidies+ ///
IncWages+ IncOwnCropProd+ IncLivStck+ IncPubWorkProg+ IncNonAgriLabour+ IncAgriLabour+ IncConstMaint+ IncSelfEmploy

drop if total == 0
drop total
save "3Aexp.dta", replace
order village_name, b( village_id)
save 3Aexp, replace
clear

* using member level data on the mode of money transfer.

use INCOME_EXP_03B
ren ( Q_3B_COL_03 Q_3B_COL_04 Q_3B_COL_05 Q_3B_COL_06 Q_3B_COL_07 Q_3B_COL_08 Q_3B_COL_09 Q_3B_COL_10 Q_3B_COL_11 Q_3B_COL_12 ) ///
(new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid8 new_memid9 new_memid10)

ren Q_3B_COL_01 sou
generate source = strofreal(sou)
replace source = "source" + subinstr(source,".","_",.)
order source, a( sou)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string
reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
drop sou
ren new_memid ModeMoneyTransfer
tab ModeMoneyTransfer
label define trans 1 "Cash" 2 "Cheque"
label values ModeMoneyTransfer trans
drop if ModeMoneyTransfer == .

* generating member ID

tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( mem_id , "%02.0f")
order mem, a( mem_id )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 3Bexp
clear

* using household level consumption expenditure data.
* the dataset was split into two parts - C & D
* C contained the expenditure data on 30 items while D contained that on 17.
* at the first stage, I appended the datasets - total 47 items per households.

use INCOME_EXP_03_C
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
sort HHID item_no

drop Q_3C_COL_03 Q_3C_COL_04
ren Q_3C_COL_05 MonthlyExp

save 3Cexp
clear

use INCOME_EXP_03_D
replace item_no = item_no+30
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
sort HHID item_no

drop Q_3D_COL_03 Q_3D_COL_04
ren Q_3D_COL_05 MonthlyExp

save 3Dexp

use 3Cexp
append using 3Dexp
sort HHID item_no

* in the appended dataset, column item_no(renamed) represented the code for the consumption good - 47 goods per hh(47 rows/hh)
* while the column MonthlyExp(renmamed) represented the expenditure on each items with blanks for those items not consumed.
* So I reshaped the data so that each row represented a single hh with the corresponding columns representing the expenditure on the consumption goods.
* the following code was used for that.

tab item_no, mi
drop if item_no == .
reshape wide MonthlyExp , i( hhid ) j( item_no)
order HHID, first
order state_id dist_id village_id village_name new_hhid, a( hhid)


* renaming vars representing the consumption goods.

ren ( MonthlyExp1 MonthlyExp2 MonthlyExp3 MonthlyExp4 MonthlyExp5 MonthlyExp6 MonthlyExp7 MonthlyExp8 MonthlyExp9 MonthlyExp10 ///
MonthlyExp11 MonthlyExp12 MonthlyExp13 MonthlyExp14 MonthlyExp15 MonthlyExp16 MonthlyExp17 MonthlyExp18 MonthlyExp19 MonthlyExp20 ///
MonthlyExp21 MonthlyExp22 MonthlyExp23 MonthlyExp24 MonthlyExp25 MonthlyExp26 MonthlyExp27 MonthlyExp28 MonthlyExp29 MonthlyExp30 ///
MonthlyExp31 MonthlyExp32 MonthlyExp33 MonthlyExp34 MonthlyExp35 MonthlyExp36 MonthlyExp37 MonthlyExp38 MonthlyExp39 MonthlyExp40 ///
MonthlyExp41 MonthlyExp42 MonthlyExp43 MonthlyExp44 MonthlyExp45 MonthlyExp46 MonthlyExp47) ( ExpMonRicePDS ExpMonRiceOth ExpWheatPDS///
ExpWheatOth ExpMonCereals ExpMonCerealProd ExpMonPulses ExpMonSugarPDS ExpMonSugarOth ExpMonOthSweeten ExpMonEdiOils ExpMonMeatFish ///
ExpMonEggs ExpMonMilk ExpMonMilkProd ExpMonVeg ExpMonSaltSpices ExpMonOthFoods ExpMonTobacIntox ExpMonFruitsNuts ExpMonRestaurant ///
ExpMonFuelLight ExpMonEntertain ExpMonPersonalCare ExpMonToiletArt ExpMonHhItems ExpMonConveyance ExpMonHouseRent ExpMonMedOutPatient ///
ExpMonPhone ExpMonMedInPatient ExpMonSchoolTuition ExpMonBooks ExpMonClothing ExpMonFootwear ExpMonFurniture ExpMonCrockery ///
ExpMonCookAppliance ExpMonRecreationGoods ExpMonJewel ExpMonPersonalTransport ExpMonTherapeuticApp ExpMonOthPersonalGoods ///
ExpMonRepairMaintain ExpMonInsurancePrem ExpMonVacations ExpMonSocialFunc)

foreach k of varlist ExpMonRicePDS - ExpMonSocialFunc{
replace `k' = 0 if `k' == .
}
save 3CDexp

* using the datasets on social capital related to savings & borrowings - borrowing capacity from formal & informal sources.
* there are 19 sources of borrowings/hh
* in each household 5 members were asked about the maximum amt. of money they could borrow from a source today & 5 years ago.

* the dataset was set up in the following manner:
* for each household, there were 19 rows representing each source of borrowing.
* corresponding to each row, there were 5 columns(for 5 members) representing the maximum amt. of money they could borrow from the specific source today,
* and 5 other columns(for the same members)representing the maximum amt. of money they could borrow from the specific source 5 years ago.

* however the id in the member column is not the true member ID.
* for that there is another dataset containing the true IDs corresponding to those 5(total 10) member nos.

* I proceeded in the following manner:

* Step 1: using the member id dataset, I split the data into 2 parts (today's borrowings + past borowings)
* Step 2: I reshaped the member id datasets(both parts), so that for a given household I've the members aligned in long format, 
* with the corresponding row containing the original member ids.
* Step 3: for each of the member id datasets(today's borrowings + past borowings) I generated a unique member id using the member's column no,
* the idea being since the original dataset has these same member's column nos, 
* any ids using these nos. would allow me to match the true member id to each individual.
* Step 4: using the social capital(borrowings) dataset - I split it into two parts - (today's borrowings + past borowings)
* Step 5 : I reshaped the twice - wide to long & then long to wide - 
* so that corresponding to every member column no - i have the borrowing details for all the 19 sources.
* Step 6 : following Step 3, i once again created the unique ids using member column nos.(both for today's borrowings + past borowings)
* Step 7: I merged using the unique ids - today's borrowing details with the member id dataset + past borrowing details with the member id dataset.
* Step 8: I dropped the unique ids - Now using the true member ids in the merged data, I created the true unique ids.
* Step 9: Using the true unique ids I merged the spilt datasets(today's borrowings + past borowings) so that 
* corresponding to each individual I've today's & past borrowing details in the same row.

* the following algorithm was used to deal with these issues:

use SOCIAL_CAPITAL_04_1_A_MEMID
drop Q04_1_M03 - Q04_1_M07 Q04_1_M13- Q04_1_M17
save 41ASocmem

drop Q04_1_M18  - Q04_1_M22
ren ( Q04_1_M08 Q04_1_M09 Q04_1_M10 Q04_1_M11 Q04_1_M12 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)

reshape long new_memid, i(state_id dist_id village_id new_hhid ) j(mem_id)
drop if new_memid == .
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( mem_id , "%02.0f")
order mem, a( mem_id )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
duplicates report ID
gen double id = real( ID)
order id, a(ID)
format %13.0g id
format %13.0f id
save  41ASocmem1

use 41ASocmem
drop Q04_1_M08 - Q04_1_M12
ren ( Q04_1_M18 Q04_1_M19 Q04_1_M20 Q04_1_M21 Q04_1_M22 ) (new_memid1 new_memid2 new_memid3new_memid4 new_memid5)
reshape long new_memid, i(state_id dist_id village_id new_hhid ) j(mem_id)
drop if new_memid == .
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( mem_id , "%02.0f")
order mem, a( mem_id )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
duplicates report ID

gen double id = real( ID)
order id, a(ID)
format %13.0f id
save 41ASocmem2

use SOCIAL_CAPITAL_04_1_A
drop old_hhid
drop Q_4_1A_COL_3 - Q_4_1A_COL_7 Q_4_1A_COL_13 - Q_4_1A_COL_17
ren sl_no IncSource
drop  if IncSource == .
generate source = strofreal( IncSource)
order source, a( IncSource)
drop IncSource
save 41ASoc

drop Q_4_1A_COL_18 - Q_4_1A_COL_22
ren ( Q_4_1A_COL_8 Q_4_1A_COL_9 Q_4_1A_COL_10 Q_4_1A_COL_11 Q_4_1A_COL_12) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
save 41ASoc1

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid8 new_memid9 new_memid10 ///
new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 new_memid18 new_memid19) ///
(BorrowMaxChild16 BorrowMaxParents16 BorrowMaxOthRelSameVil16 BorrowMaxOthRelOutVil16 BorrowMaxpPvtMonLend16 BorrowMaxLandlord16 ///
BorrowMaxEmployer16 BorrowMaxSHG16 BorrowMaxCoopSoc16 BorrowMaxShopkeeper16 BorrowMaxAgriInpTrader16 BorrowMaxNatlBank16 /// 
BorrowMaxPvtBank16 BorrowMaxGrameenBank16 BorrowMaxLandMortBank16 BorrowMaxGovtScheme16 BorrowMaxKisanCredit16 BorrowMaxLIC16 BorrowMaxMFI16)

foreach k of varlist BorrowMaxChild16 - BorrowMaxCoopSoc16{
replace `k' = 0 if `k' == .
}
gen tot = BorrowMaxChild16+ BorrowMaxShopkeeper16+ BorrowMaxAgriInpTrader16+ BorrowMaxNatlBank16+ BorrowMaxPvtBank16+ ///
BorrowMaxGrameenBank16+ BorrowMaxLandMortBank16+ BorrowMaxGovtScheme16+ BorrowMaxKisanCredit16+ BorrowMaxLIC16+ BorrowMaxMFI16+ ///
BorrowMaxParents16+ BorrowMaxOthRelSameVil16+ BorrowMaxOthRelOutVil16+ BorrowMaxpPvtMonLend16+ BorrowMaxLandlord16+ ///
BorrowMaxEmployer16+ BorrowMaxSHG16+ BorrowMaxCoopSoc16

drop if tot == 0
drop  tot
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( mem_id , "%02.0f")
order mem, a( mem_id )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
duplicates report ID
gen double id = real( ID)
order id, a(ID)
format %13.0f id
save  41ASoc1
clear

use 41ASoc
drop Q_4_1A_COL_8 - Q_4_1A_COL_12
ren ( Q_4_1A_COL_18 Q_4_1A_COL_19 Q_4_1A_COL_20 Q_4_1A_COL_21 Q_4_1A_COL_22 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid8 new_memid9 new_memid10 new_memid11///
 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 new_memid18 new_memid19) (BorrowMaxChild11 BorrowMaxParents11 ///
 BorrowMaxOthRelSameVil11 BorrowMaxOthRelOutVil11 BorrowMaxpPvtMonLend11 BorrowMaxLandlord11 BorrowMaxEmployer11 BorrowMaxSHG11 ///
 BorrowMaxCoopSoc11 BorrowMaxShopkeeper11 BorrowMaxAgriInpTrader11BorrowMaxNatlBank11 BorrowMaxPvtBank11 BorrowMaxGrameenBank11 ///
 BorrowMaxLandMortBank11 BorrowMaxGovtScheme11 BorrowMaxKisanCredit11 BorrowMaxLIC11 BorrowMaxMFI11)

 foreach k of varlist BorrowMaxChild11 - BorrowMaxCoopSoc11{
 replace `k' = 0 if `k' == .
 }
gen tot = BorrowMaxChild11+ BorrowMaxShopkeeper11+ BorrowMaxAgriInpTrader11+ BorrowMaxNatlBank11+ BorrowMaxPvtBank11+ BorrowMaxGrameenBank11+ ///
BorrowMaxLandMortBank11+ BorrowMaxGovtScheme11+ BorrowMaxKisanCredit11+ BorrowMaxLIC11+ BorrowMaxMFI11+ BorrowMaxParents11+ ///
BorrowMaxOthRelSameVil11+ BorrowMaxOthRelOutVil11+ BorrowMaxpPvtMonLend11+ BorrowMaxLandlord11+ BorrowMaxEmployer11+ BorrowMaxSHG11+ BorrowMaxCoopSoc11

drop if tot == 0
drop  tot
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( mem_id , "%02.0f")
order mem, a( mem_id )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
duplicates report ID
gen double id = real( ID)
order id, a(ID)
format %13.0f id
save  41ASoc2

use 41ASoc1
merge 1:1 id using 41ASocmem1
drop  if _merge != 3
drop _merge
save 41ASoc1.dta, replace

use 41ASoc2
merge 1:1 id using 41ASocmem2
drop  if _merge != 3
drop _merge
save 41ASoc2, replace

use 41ASoc1
merge 1:1 id using 41ASoc2
drop if _merge != 3

drop _merge
drop  ID id mem_id
order village_name new_memid, a( new_hhid)

tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
duplicates report ID

bys ID: drop if ID == ID[_n+1]
gen double id = real( ID)
order id, a(ID)
format %13.0f id
save 41ASocCap
clear

* using social capital data - members ability to borrow.

use SOCIAL_CAPITAL_04_1_B
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
duplicates report ID
gen double id = real( ID)
order id, a(ID)
format %13.0f id

ren Q04_1_B_STITUATION AbilityBorrow10K
label define ability 1 "Extremely easy" 2 "Very likely from someone from own caste within the village" 3 "Not easy(only after significant delay)" ///
4 "Very difficult" 5 "Impossible"
label values AbilityBorrow10K ability

save 41BSocCap.dta
clear


* using social capital 4.1 C, 4.1 D & 4.1 E
* 4.1 C - for each members(age>18) identify 4 persons in the village from whom they can borrow Rs 10,000 during the time of emergency.
* 4.1 D - for each members(age>18) identify 4 persons in the village from whom they can seek info. on institutions for savings.
* 4.1 E - for each members(age>18) identify 4 persons in the village from whom they can seek info. on institutions for borrowings.
* Similar steps were followed for all the three datasets.
* Step 1: I created the indivdual member id.
* Step 2: using a loop, i created the ids of the four preferred individuals.
* Step 3: However, in multiple cases, either the hh id or mem id of the preferred individuals were missing.
* Therefore, any ids with less than 13 characters were dropped.


use SOCIAL_CAPITAL_04_1_C
drop Q4_1C_COL_02 Q4_1C_COL_05 Q4_1C_COL_08 Q4_1C_COL_11
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
duplicates report ID
gen double id = real( ID)
order id, a(ID)
format %13.0f id
drop hh mem

foreach k of varlist Q4_1C_COL_03 Q4_1C_COL_06 Q4_1C_COL_09 Q4_1C_COL_12{
gen str4 hh`k' =  string( `k' , "%04.0f") if `k' !=.
order hh`k', a(`k')
}
drop Q4_1C_COL_03 Q4_1C_COL_06 Q4_1C_COL_09 Q4_1C_COL_12

foreach k of varlist Q4_1C_COL_04 Q4_1C_COL_07 Q4_1C_COL_10 Q4_1C_COL_13{
gen str2 mem`k' = string( `k' , "%02.0f") if `k' !=.
order mem`k', a(`k')
}
drop Q4_1C_COL_04 Q4_1C_COL_07 Q4_1C_COL_10 Q4_1C_COL_13

gen id1 = stateid+ distid+ villid+ hhQ4_1C_COL_03+ memQ4_1C_COL_04
gen id2 = stateid+ distid+ villid+ hhQ4_1C_COL_06+ memQ4_1C_COL_07
gen id3 = stateid+ distid+ villid+ hhQ4_1C_COL_09+ memQ4_1C_COL_10
gen id4 = stateid+ distid+ villid+ hhQ4_1C_COL_12+ memQ4_1C_COL_13
drop hhQ4_1C_COL_03 - memQ4_1C_COL_13

foreach k of varlist id1 - id4{
gen l`k' = length(`k')
order l`k', a(`k')
replace `k' = "" if l`k' < 13
}
drop lid1 lid2 lid3 lid4

foreach k of varlist id1 - id4{
destring `k', ge(mem`k')
format %13.0f mem`k'
}
drop id1 id2 id3 id4

save 41CSocCap
clear

use SOCIAL_CAPITAL_04_1_D
drop Q4_1D_COL_02 Q4_1D_COL_05 Q4_1D_COL_08 Q4_1D_COL_11
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
duplicates report ID

gen double id = real( ID)
order id, a(ID)
format %13.0f id
drop hh mem

foreach k of varlist Q4_1D_COL_03 Q4_1D_COL_06 Q4_1D_COL_09 Q4_1D_COL_12 {
gen str4 hh`k' =  string( `k' , "%04.0f") if `k' !=.
order hh`k', a(`k')
}
drop Q4_1D_COL_03 Q4_1D_COL_06 Q4_1D_COL_09 Q4_1D_COL_12

foreach k of varlist Q4_1D_COL_04 Q4_1D_COL_07 Q4_1D_COL_10 Q4_1D_COL_13 {
gen str2 mem`k' = string( `k' , "%02.0f") if `k' !=.
order mem`k', a(`k')
}
drop Q4_1D_COL_04 Q4_1D_COL_07 Q4_1D_COL_10 Q4_1D_COL_13

gen id1 = stateid+ distid+ villid+ hhQ4_1D_COL_03+ memQ4_1D_COL_04
gen id2 = stateid+ distid+ villid+ hhQ4_1D_COL_06+ memQ4_1D_COL_07
gen id3 = stateid+ distid+ villid+ hhQ4_1D_COL_09+ memQ4_1D_COL_10
gen id4 = stateid+ distid+ villid+ hhQ4_1D_COL_12+ memQ4_1D_COL_13

drop hhQ4_1D_COL_03 - memQ4_1D_COL_13

foreach k of varlist id1 - id4{
gen l`k' = length(`k')
order l`k', a(`k')
replace `k' = "" if l`k' < 13
}
drop lid1 lid2 lid3 lid4


foreach k of varlist id1 - id4{
destring `k', ge(mem`k')
format %13.0f mem`k'
}
drop id1 id2 id3 id4
save 41DSocCap.dta
clear

use SOCIAL_CAPITAL_04_1_E
drop Q4_1E_COL_02 Q4_1E_COL_05 Q4_1E_COL_08 Q4_1E_COL_11
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
duplicates report ID
gen double id = real( ID)
order id, a(ID)
format %13.0f id
drop hh mem

foreach k of varlist Q4_1E_COL_03 Q4_1E_COL_06 Q4_1E_COL_09 Q4_1E_COL_12 {
gen str4 hh`k' =  string( `k' , "%04.0f") if `k' !=.
order hh`k', a(`k')
}
drop Q4_1E_COL_03 Q4_1E_COL_06 Q4_1E_COL_09 Q4_1E_COL_12

foreach k of varlist Q4_1E_COL_04 Q4_1E_COL_07 Q4_1E_COL_10 Q4_1E_COL_13 {
gen str2 mem`k' = string( `k' , "%02.0f") if `k' !=.
order mem`k', a(`k')
}
drop Q4_1E_COL_04 Q4_1E_COL_07 Q4_1E_COL_10 Q4_1E_COL_13

gen id1 = stateid+ distid+ villid+ hhQ4_1E_COL_03+ memQ4_1E_COL_04
gen id2 = stateid+ distid+ villid+ hhQ4_1E_COL_06+ memQ4_1E_COL_07
gen id3 = stateid+ distid+ villid+ hhQ4_1E_COL_09+ memQ4_1E_COL_10
gen id4 = stateid+ distid+ villid+ hhQ4_1E_COL_12+ memQ4_1E_COL_13

drop hhQ4_1E_COL_03 - memQ4_1E_COL_13

foreach k of varlist id1 - id4{
gen l`k' = length(`k')
order l`k', a(`k')
replace `k' = "" if l`k' < 13
}
drop lid1 lid2 lid3 lid4

foreach k of varlist id1 - id4{
destring `k', ge(mem`k')
format %13.0f mem`k'
}
drop id1 id2 id3 id4
save 41ESocCap
clear


* using social capital data - use of intermediaries.

use SOCIAL_CAPITAL_04_1_F
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( new_memid , "%02.0f")
order mem, a( new_memid )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
duplicates report ID
gen double id = real( ID)
order id, a(ID)
format %13.0f id
drop hh mem stateid distid villid

ren Q4_1F_Q01 DepMoneyBankIntermed
ren Q4_1F_Q02 IntermedID
tab IntermedID
replace IntermedID = . if IntermedID == 8 | IntermedID == 9
label define inter 1 "Yes" 2 "No"
label values DepMoneyBankIntermed inter
label define interid 1 "Kirana store owner" 2 "E-Gov centre" 3 "MFI Loan officer" 4 "Representative officer from local bank" ///
5 "PRI representatives" 6 "Govt. officials" 7 "None"
label values IntermedID interid

save 41FSocCap
clear

* using ownership(household level) of financial & non- financial assets data - 5.1, 5.2, 5.3, 5.4 & 5.6
* the datasets are set up in the following way -
* for a particular household, there are n rows where n is the no. of asset types owned by the specific household & the
* corresponding columns contain the household level asset ownership information.
* I wanted to set up the data in the wide format so that each household is represented by a single row & 
* the corresponding columns have asset 1 characteristics, followed by asset 2 characteristics & so on.
* So for each datasets, i split the data into n parts, where n is the total asset types.
* I created unique hh ID for each split datasets & then using those IDs merged them to get the desired format.
* The following algorithm was used to deal with this.

use OWNERSHIP_5_1
ren ( Q5_1_COL_03 Q5_1_COL_04 Q5_1_COL_05 Q5_1_COL_06 Q5_1_COL_07 Q5_1_COL_08 Q5_1_COL_09) ///
(TotValOwn  Purchased ModePurchase ModePay Sold GiftsGiven GiftsRcvd)
save OWNERSHIP_5_1

tab asset_type
forvalues i=1/2 {
keep if asset_type == `i'
foreach var of varlist TotValOwn - GiftsRcvd{
ren `var' Ast`i'`var'
}
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
drop asset_type
save 51Own`i'
clear
use OWNERSHIP_5_1
}
use 51Own1
merge 1:1 hhid using 51Own2
drop _merge
renvars Ast1TotValOwn - Ast1GiftsRcvd, presub(Ast1 LivStck)
renvars Ast2TotValOwn - Ast2GiftsRcvd, presub(Ast2 Poultry)
duplicates list hhid
foreach var of varlist LivStckModePurchase PoultryModePurchase{
label define purch`var' 1 "Hire purchase" 2 "Credit/Installments" 3 "Cash"
label values `var' purch`var'
}
foreach var of varlist LivStckModePay PoultryModePay{
label define pay`var' 1 "Cash" 2 "Cheque" 3 "Draft" 4 "Installment/Credit" 5 "Mobile wallet/ payment through internet"
label values `var' pay`var'
}
save 51Own.dta
clear

use OWNERSHIP_5_2

ren ( Q5_2_COL_03 Q5_2_COL_04 Q5_2_COL_05 Q5_2_COL_06 Q5_2_COL_07 Q5_2_COL_08 Q5_2_COL_09 )///
(TotValOwn  Purchased ModePurchase ModePay Sold GiftsGiven GiftsRcvd)

save OWNERSHIP_5_2

tab asset_type
forvalues i=1/4 {
keep if asset_type == `i'
foreach var of varlist TotValOwn - GiftsRcvd{
ren `var' Ast`i'`var'
}
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
drop asset_type
save 52Own`i'
clear
use OWNERSHIP_5_2
}
use 52Own1
merge 1:1 hhid using 52Own2
drop _merge
merge 1:1 hhid using 52Own3
drop _merge
merge 1:1 hhid using 52Own4
drop _merge 

renvars Ast1TotValOwn - Ast1GiftsRcvd, presub(Ast1 AgriLand)
renvars Ast2TotValOwn - Ast2GiftsRcvd, presub(Ast2 TracHarv)
renvars Ast3TotValOwn - Ast3GiftsRcvd, presub(Ast3 FarmHH)
renvars Ast4TotValOwn - Ast4GiftsRcvd, presub(Ast4 FarmWareHH)

duplicates list hhid

foreach var of varlist AgriLandModePurchase TracHarvModePurchase FarmHHModePurchase FarmWareHHModePurchase{
label define purch`var' 1 "Hire purchase" 2 "Credit/Installments" 3 "Cash"
label values `var' purch`var'
}
foreach var of varlist AgriLandModePay TracHarvModePay FarmHHModePay FarmWareHHModePay{
label define pay`var' 1 "Cash" 2 "Cheque" 3 "Draft" 4 "Installment/Credit" 5 "Mobile wallet/ payment through internet"
label values `var' pay`var'
}
save 52Own
clear

use OWNERSHIP_5_3
tab asset_type
ren ( Q5_3_COL_03 Q5_3_COL_04 Q5_3_COL_05 Q5_3_COL_06 Q5_3_COL_07 Q5_3_COL_08 Q5_3_COL_09 )///
(TotValOwn  Purchased ModePurchase ModePay Sold GiftsGiven GiftsRcvd)
save OWNERSHIP_5_3

forvalues i=1/3 {
keep if asset_type == `i'
foreach var of varlist TotValOwn - GiftsRcvd{
ren `var' Ast`i'`var'
}
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
drop asset_type
save 53Own`i'
clear
use OWNERSHIP_5_3
}
use 53Own1
merge 1:1 hhid using 53Own2
drop _merge
merge 1:1 hhid using 53Own3
drop _merge
renvars Ast1TotValOwn - Ast1GiftsRcvd, presub(Ast1 ResidLand)
renvars Ast2TotValOwn - Ast2GiftsRcvd, presub(Ast2 ResiHhFlats)
renvars Ast3TotValOwn - Ast3GiftsRcvd, presub(Ast3 CommProp)
duplicates list hhid

foreach var of varlist ResidLandModePurchase ResiHhFlatsModePurchase CommPropModePurchase {
label define purch`var' 1 "Hire purchase" 2 "Credit/Installments" 3 "Cash"
label values `var' purch`var'
}
foreach var of varlist ResidLandModePay ResiHhFlatsModePay CommPropModePay {
label define pay`var' 1 "Cash" 2 "Cheque" 3 "Draft" 4 "Installment/Credit" 5 "Mobile wallet/ payment through internet"
label values `var' pay`var'
}
save 53Own
clear

use OWNERSHIP_5_4
tab asset_type
drop  if asset_type == 3 | asset_type == 4 |asset_type == 5 | asset_type == 6
ren ( Q5_4_COL_03 Q5_4_COL_04 Q5_4_COL_05 Q5_4_COL_06 Q5_4_COL_07 Q5_4_COL_08 Q5_4_COL_09 )///
(TotValOwn  Purchased ModePurchase ModePay Sold GiftsGiven GiftsRcvd)
save OWNERSHIP_5_4

forvalues i=1/2 {
keep if asset_type == `i'
foreach var of varlist TotValOwn - GiftsRcvd{
ren `var' Ast`i'`var'
}
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
drop asset_type
save 54Own`i'
clear
use OWNERSHIP_5_4
}
use 54Own1
merge 1:1 hhid using 54Own2
drop _merge
renvars Ast1TotValOwn - Ast1GiftsRcvd, presub(Ast1 Gold)
renvars Ast2TotValOwn - Ast2GiftsRcvd, presub(Ast2 PrecStone)
duplicates list hhid

foreach var of varlist GoldModePurchase PrecStoneModePurchase {
label define purch`var' 1 "Hire purchase" 2 "Credit/Installments" 3 "Cash"
label values `var' purch`var'
}
foreach var of varlist GoldModePay PrecStoneModePay {
label define pay`var' 1 "Cash" 2 "Cheque" 3 "Draft" 4 "Installment/Credit" 5 "Mobile wallet/ payment through internet"
label values `var' pay`var'
}
save 54Own
clear

use OWNERSHIP_5_5.dta
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
ren cash_in_hand AvgMonthCashInHand
duplicates list hhid

save 55Own
clear

use OWNERSHIP_5_6
ren ( Q5_5_COL_03 Q5_5_COL_04 Q5_5_COL_05 Q5_5_COL_06 Q5_5_COL_07 Q5_5_COL_08 Q5_5_COL_09 )///
(TotValOwn  Purchased ModePurchase ModePay Sold GiftsGiven GiftsRcvd)
tab asset
save OWNERSHIP_5_6
forvalues i=1/16 {
keep if asset == `i'
foreach var of varlist TotValOwn - GiftsRcvd{
ren `var' Ast`i'`var'
}
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
drop stateid distid villid hh
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
drop asset
save 56Own`i'
clear
use OWNERSHIP_5_6
}
use 56Own1

forvalues i=2/16{
merge 1:1 hhid using 56Own`i'
drop _merge
}
duplicates list hhid

renvars Ast1TotValOwn - Ast1GiftsRcvd, presub(Ast1 AutoMob)
renvars Ast2TotValOwn - Ast2GiftsRcvd, presub(Ast2 TwoWheel)
renvars Ast3TotValOwn - Ast3GiftsRcvd, presub(Ast3 TV)
renvars Ast4TotValOwn - Ast4GiftsRcvd, presub(Ast4 WashMach)
renvars Ast5TotValOwn - Ast5GiftsRcvd, presub(Ast5 Fridge)
renvars Ast6TotValOwn - Ast6GiftsRcvd, presub(Ast6 MicWaveOven)
renvars Ast7TotValOwn - Ast7GiftsRcvd, presub(Ast7 AC)
renvars Ast8TotValOwn - Ast8GiftsRcvd, presub(Ast8 PressCook)
renvars Ast9TotValOwn - Ast9GiftsRcvd, presub(Ast9 ElecFan)
renvars Ast10TotValOwn - Ast10GiftsRcvd, presub(Ast10 GasBurner)
renvars Ast11TotValOwn - Ast11GiftsRcvd, presub(Ast11 Laptop)
renvars Ast12TotValOwn - Ast12GiftsRcvd, presub(Ast12 Desktop)
renvars Ast13TotValOwn - Ast13GiftsRcvd, presub(Ast13 Tablet)
renvars Ast14TotValOwn - Ast14GiftsRcvd, presub(Ast14 OrdCellPh)
renvars Ast15TotValOwn - Ast15GiftsRcvd, presub(Ast15 SmartPhone)
renvars Ast16TotValOwn - Ast16GiftsRcvd, presub(Ast16 DataCards)

foreach var of varlist AutoMobModePurchase TwoWheelModePurchase TVModePurchase WashMachModePurchase FridgeModePurchase ///
MicWaveOvenModePurchase ACModePurchase PressCookModePurchase ElecFanModePurchase GasBurnerModePurchase LaptopModePurchase ///
DesktopModePurchase TabletModePurchase OrdCellPhModePurchase SmartPhoneModePurchase DataCardsModePurchase{
label define purch`var' 1 "Hire purchase" 2 "Credit/Installments" 3 "Cash"
label values `var' purch`var'
}
foreach var of varlist AutoMobModePay TwoWheelModePay TVModePay WashMachModePay FridgeModePay MicWaveOvenModePay ACModePay ///
PressCookModePay ElecFanModePay GasBurnerModePay LaptopModePay DesktopModePay TabletModePay OrdCellPhModePay SmartPhoneModePay ///
DataCardsModePay{
label define pay`var' 1 "Cash" 2 "Cheque" 3 "Draft" 4 "Installment/Credit" 5 "Mobile wallet/ payment through internet"
label values `var' pay`var'
}
save 56Own
clear

* Work in progress...
