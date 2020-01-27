* JPM-Grameen Survey

* The survey was funded by the J.P. Morgan group & the Grameen Foundation, India
* The survey was conducted between May, 2016 & November, 2016.
* The survey covered 34 villages, 3450 households & 18,396 individuals in the Indian state of Uttar Pradesh, one of the country's poorest states.

* Author - PARIJAT MAITRA

* Version - 14

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

* using member level data on savings & investment profiles

use SAVING_06_1_A
ren Q06_1_A_01 savinvest_opt
tab savinvest_opt

* Cleaning the data-entry errors

replace savinvest_opt = subinstr( savinvest_opt , ".","", .)
replace savinvest_opt = subinstr( savinvest_opt , "*","", .)
replace savinvest_opt = subinstr( savinvest_opt , "/","", .)
replace savinvest_opt = subinstr( savinvest_opt , "]","", .)
replace savinvest_opt = subinstr( savinvest_opt , " ","", .)
replace savinvest_opt = subinstr( savinvest_opt , "  ","", .)
replace savinvest_opt = "20" if savinvest_opt =="020"
replace savinvest_opt = "3" if savinvest_opt == "30" | savinvest_opt == "39"
replace savinvest_opt = "5" if savinvest_opt =="59"
replace savinvest_opt ="7A" if savinvest_opt == "7a"

drop  if savinvest_opt == ""
drop Q06_1_A_03 - Q06_1_A_17

* this dataset is shaped in the following manner:
* column savinvest_opt(renmamed) represents the 30 odd saving/investment instruments(codes),
* while the corresponding rows in the neighbouring columns(5 in number) represents the investment by a particular member of a given household.
* so, if the members of a household uses 'n' such schemes in total, there will be 'n' different values in column savinvest_opt for that hh.
* I wanted to shape the data in such a way so that for a particular member of a hh, I've their saving/investment profile in the wide format
* Thus in the desired format, each row represents an individual.
* So I reshaped the dataset twice - wide to long, followed by long to wide.
* Also, the mem id in this dataset is not the true Id, but the column number.
* The original member id was in another dataset - formatted the same way where the true member details corresponds to the member column number.
* So post-reshape, I created ids for each member using the column numbers
* similarly, in the member id dataset, I created ids for each members using their column numbers
* And then I merged the two datasets - the member id dataset was considered the master file.
* So any non-matches were dropped.
* Post-matching, I dropped the old ids & created new ids using the true member ids.
* the following algorithm was used 


ren savinvest_opt source
replace source = "7_1" if source == "7A"
ren ( Q06_1_A_18 Q06_1_A_19 Q06_1_A_20 Q06_1_A_21 Q06_1_A_22) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
drop if new_memid1 ==. & new_memid2 == . & new_memid3 ==. & new_memid4 ==. & new_memid5 ==.

* trimming the outliers
foreach k of varlist new_memid1 - new_memid5{
winsor2 `k' , replace cuts(1 99.9)
}
reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string


ren ( new_memid1 new_memid2 new_memid3 new_memid5 new_memid7 new_memid7_1 new_memid8 new_memid9 new_memid10 ///
new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 new_memid18 new_memid19 ///
new_memid20 new_memid22 new_memid23 new_memid24 new_memid25 new_memid26 new_memid27 new_memid28 new_memid29) ///
(InvGovtBond InvGovUndTkBond InvDebPvtComp InvMutFund InvPOSavScheme InvPPF InvLICPension InvPvtBankPension ///
InvLICInsurance InvPvtCompInsurance DepoPSUBank DepoPvtBank DepoCoopBank DepoRRB InvLifeInsurance InvHealth ///
InvAccidentInsurance InvCropInsurance InvEnterpInsurance InvMachineInsurance InvLivStock InvCommFuture InvRealEstate///
InvBusiness InvPvtFunds InvJewel InvArt)

foreach var of varlist InvGovtBond - InvPvtBankPension{
replace `var' = 0 if `var' == .
}
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
gen double id = real( ID)
order id, a(ID)
format id %13.0f
duplicates report ID
save 61A
clear

use SAVING_06_1_A_MEMID
drop M03 - M17
ren ( M18 M19 M20 M21 M22) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
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
save 61AMem
clear

use 61A
merge 1:1 id using 61AMem
drop if _merge ! = 3
drop _merge ID id mem_id mem
gen str2  mem =  string( new_memid , "%02.0f")
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem new_memid
duplicates report ID
bys ID: drop if ID == ID[_n+1]
gen double id = real( ID)
order id, a(ID)
format %13.0f id

save 61A, replace


* using income shock & portfolio choice data

use SAVING_06_1_A_1
ren Q06_1_A_SLNO savinvest_opt
tab savinvest_opt

* cleaning the data-entry errors 

replace savinvest_opt = subinstr( savinvest_opt , ".","", .)
replace savinvest_opt = subinstr( savinvest_opt , "/","", .)
replace savinvest_opt = subinstr( savinvest_opt , " ","", .)
replace savinvest_opt ="7A" if savinvest_opt == "7a"
replace savinvest_opt = "10" if savinvest_opt == "00"
replace savinvest_opt = "10" if savinvest_opt == "102"
replace savinvest_opt = "11" if savinvest_opt == "113"
replace savinvest_opt = "26" if savinvest_opt == "265"
replace savinvest_opt = "7A" if savinvest_opt == "74"
replace savinvest_opt = "7_1" if savinvest_opt == "7A"
replace savinvest_opt = "3" if savinvest_opt == "33"
drop if savinvest_opt == ""

ren savinvest_opt source

foreach var of varlist Q06_1_A_23- Q06_1_A_27 {
replace `var' = 50000 if `var'>50000 & `var' != .
replace `var' = 1000 if `var'<1000
}
foreach var of varlist Q06_1_A_33 - Q06_1_A_37 {
replace `var' = 500000 if `var'>500000 & `var' != .
replace `var' = 1000 if `var'<1000
}
foreach var of varlist Q06_1_A_43 - Q06_1_A_47 {
replace `var' = 1000000 if `var'>1000000 & `var' != .
replace `var' = 1000 if `var'<1000
}
foreach var of varlist Q06_1_A_28 - Q06_1_A_32 Q06_1_A_38 - Q06_1_A_42 Q06_1_A_48 - Q06_1_A_52{
replace `var' = 20 if `var'> 20 & `var'!=.
replace `var' = 1 if `var'<1
}
save 61A1


* this dataset is shaped in the following manner:
* column savinvest_opt(renmamed) represents the 30 odd saving/investment instruments(codes),
* while the corresponding rows in the neighbouring columns(10 in number) represent the investment by a particular member of a given household,
* given positive income shocks of Rs 50,000; Rs 5,00,000 & Rs 10,00,000 & the time frames(in yrs.) of these potential investments.
* if the members of a household uses 'n' such schemes in total, there will be 'n' different values in column savinvest_opt for that hh.
* So, for a paricular investment instrument - there are 30 columns - 3 income shocks * 10 columns - 5 columns for the investment value & 5 for the time frame
* I wanted to shape the data in such a way so that for a particular member of a hh, I've their saving/investment profile in the wide format,given a particular income shock.
* therefore the final dataset would be split into three parts  for 3 income shocks
* where for a paricular member(each row being a unique member), I've the investment profile & the corresponding time frames(of investment) side by side.

* So I reshaped the dataset twice - wide to long, followed by long to wide.
* However, beacuse I was dealing with two different categories of vars - investment value & time
* for each income shocks, I had to split the dataset into two parts - investment & time,
* post-split, I reshaped each individual datasets twice & then linked them using a common Id

* Also, the mem id in this merged dataset is not the true Id, but the column number.
* The original member id was in another dataset - formatted the same way where the true member details corresponds to the member column number.
* So post-reshape & merger, I created ids for each member using the column numbers
* similarly, in the member id dataset, I created ids for each members using their column numbers
* And then I merged the two datasets - So any non-matches were dropped.
* Post-matching, I dropped the old ids & created new ids using the true member ids.

* the following algorithm was used for each of the three income shock datasets



* income shock of Rs. 50,000

drop Q06_1_A_28 - Q06_1_A_52
ren ( Q06_1_A_23 Q06_1_A_24 Q06_1_A_25 Q06_1_A_26 Q06_1_A_27) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
drop  if new_memid1 == . & new_memid2 == . & new_memid3 == . & new_memid4 == . & new_memid5 == .

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid7_1 new_memid8///
new_memid9 new_memid10 new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 ///
new_memid18 new_memid19 new_memid20 new_memid21new_memid22 new_memid23 new_memid24 new_memid25 new_memid26 ///
new_memid27 new_memid28 new_memid29) (InvGovtBond InvGovUndTkBond InvDebPvtComp InvEquiPvtComp InvMutFund InvDeriv ///
InvPOSavScheme InvPPF InvLICPension InvPvtBankPension InvLICInsurance InvPvtCompInsurance DepoPSUBank DepoPvtBank ///
DepoCoopBank DepoRRB InvLifeInsurance InvHealth InvAccidentInsurance InvCropInsurance InvEnterpInsurance InvPropInsurance ///
InvMachineInsurance InvLivStock InvCommFuture InvRealEstate InvBusiness InvPvtFunds InvJewel InvArt)

foreach var of varlist InvGovtBond - InvPvtBankPension{
replace `var' = 0 if `var' == .
ren `var' `var'50k
} 
egen sum = rowtotal( InvGovtBond50k - InvPvtBankPension50k)
assert sum < = 50000
drop if sum>50000
drop  if sum == 0
drop sum

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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A150kInv
clear

use 61A1
drop Q06_1_A_23 - Q06_1_A_27 Q06_1_A_33 - Q06_1_A_52
ren ( Q06_1_A_28 Q06_1_A_29 Q06_1_A_30 Q06_1_A_31 Q06_1_A_32 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
drop  if new_memid1 == . & new_memid2 == . & new_memid3 == . & new_memid4 == . & new_memid5 == .

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid7_1 new_memid8 ///
new_memid9 new_memid10 new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 ///
new_memid18 new_memid19  new_memid21 new_memid22 new_memid23 new_memid24 new_memid25 new_memid26 new_memid27 ///
new_memid28 new_memid29)(InvGovtBond InvGovUndTkBond InvDebPvtComp InvEquiPvtComp InvMutFund InvDeriv InvPOSavScheme ///
InvPPF InvLICPension InvPvtBankPension InvLICInsurance InvPvtCompInsurance DepoPSUBank DepoPvtBank DepoCoopBank DepoRRB ///
InvLifeInsurance InvHealth InvAccidentInsurance InvCropInsurance InvPropInsurance InvMachineInsurance InvLivStock InvCommFuture///
InvRealEstate InvBusiness InvPvtFunds InvJewel InvArt)

foreach var of varlist InvGovtBond - InvPvtBankPension{
replace `var' = 0 if `var' == .
ren `var' Time`var'
}
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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A150kTime
clear

use 61A150kInv
merge 1:1 id using 61A150kTime
drop if _merge != 3
drop _merge

save 61A150kInv, replace
clear

use SAVING_06_1_A_1_MEMID
drop M28 - M52
ren ( M23 M24 M25 M26 M27 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)

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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A150kMem
clear

use 61A150kInv
merge 1:1 id using 61A150kMem
drop  if _merge != 3
drop ID id _merge mem
gen str2  mem =  string( new_memid , "%02.0f")
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem new_memid
duplicates report ID
bys ID: drop if ID == ID[_n+1]
gen double id = real( ID)
order id, a(ID)
format %13.0f id

save 61A150kInv, replace

*income shock of Rs. 5 Lakh

use 61A1
drop Q06_1_A_23 -  Q06_1_A_32 Q06_1_A_38 - Q06_1_A_52
ren ( Q06_1_A_33 Q06_1_A_34 Q06_1_A_35 Q06_1_A_36 Q06_1_A_37 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
drop  if new_memid1 == . & new_memid2 == . & new_memid3 == . & new_memid4 == . & new_memid5 == .
reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid7_1 new_memid8///
new_memid9 new_memid10 new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 ///
new_memid18 new_memid19 new_memid20 new_memid21new_memid22 new_memid23 new_memid24 new_memid25 new_memid26 ///
new_memid27 new_memid28 new_memid29) (InvGovtBond InvGovUndTkBond InvDebPvtComp InvEquiPvtComp InvMutFund InvDeriv ///
InvPOSavScheme InvPPF InvLICPension InvPvtBankPension InvLICInsurance InvPvtCompInsurance DepoPSUBank DepoPvtBank ///
DepoCoopBank DepoRRB InvLifeInsurance InvHealth InvAccidentInsurance InvCropInsurance InvEnterpInsurance InvPropInsurance ///
InvMachineInsurance InvLivStock InvCommFuture InvRealEstate InvBusiness InvPvtFunds InvJewel InvArt)

foreach var of varlist InvGovtBond - InvPvtBankPension{
replace `var' = 0 if `var' == .
ren `var' `var'5Lakh
}
egen sum = rowtotal( InvGovtBond5Lakh - InvPvtBankPension5Lakh)
assert sum < = 500000
drop if sum>500000
drop  if sum == 0
drop sum

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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A15LakhInv

clear
use 61A1

drop Q06_1_A_23 - Q06_1_A_37 Q06_1_A_43 - Q06_1_A_52
ren ( Q06_1_A_38 Q06_1_A_39 Q06_1_A_40 Q06_1_A_41 Q06_1_A_42 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
drop  if new_memid1 == . & new_memid2 == . & new_memid3 == . & new_memid4 == . & new_memid5 == .

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid7_1 new_memid8///
new_memid9 new_memid10 new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 ///
new_memid18 new_memid19 new_memid20 new_memid21new_memid22 new_memid23 new_memid24 new_memid25 new_memid26 ///
new_memid27 new_memid28 new_memid29) (InvGovtBond InvGovUndTkBond InvDebPvtComp InvEquiPvtComp InvMutFund InvDeriv ///
InvPOSavScheme InvPPF InvLICPension InvPvtBankPension InvLICInsurance InvPvtCompInsurance DepoPSUBank DepoPvtBank ///
DepoCoopBank DepoRRB InvLifeInsurance InvHealth InvAccidentInsurance InvCropInsurance InvEnterpInsurance InvPropInsurance ///
InvMachineInsurance InvLivStock InvCommFuture InvRealEstate InvBusiness InvPvtFunds InvJewel InvArt)

foreach var of varlist InvGovtBond - InvPvtBankPension{
replace `var' = 0 if `var' == .
ren `var' Time`var'
}
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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A15LakhTime

use 61A15LakhInv
merge 1:1 id using 61A15LakhTime
drop if _merge != 3
drop _merge
save 61A15LakhInv, replace

use SAVING_06_1_A_1_MEMID
drop M23 - M32 M38 - M52
ren ( M33 M34 M35 M36 M37 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A15LakhMem
clear

use 61A15LakhInv
merge 1:1 id using 61A15LakhMem
drop  if _merge != 3
drop ID id _merge mem
gen str2  mem =  string( new_memid , "%02.0f")
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem new_memid
duplicates report ID
bys ID: drop if ID == ID[_n+1]
gen double id = real( ID)
order id, a(ID)
format %13.0f id
save 61A15LakhInv, replace
clear

* income shock of Rs. 10 Lakh

use 61A1
drop Q06_1_A_23 -  Q06_1_A_42 Q06_1_A_48 - Q06_1_A_52
ren ( Q06_1_A_43 Q06_1_A_44 Q06_1_A_45 Q06_1_A_46 Q06_1_A_47 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
drop  if new_memid1 == . & new_memid2 == . & new_memid3 == . & new_memid4 == . & new_memid5 == .

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid7_1 new_memid8///
new_memid9 new_memid10 new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 ///
new_memid18 new_memid19 new_memid20 new_memid21new_memid22 new_memid23 new_memid24 new_memid25 new_memid26 ///
new_memid27 new_memid28 new_memid29) (InvGovtBond InvGovUndTkBond InvDebPvtComp InvEquiPvtComp InvMutFund InvDeriv ///
InvPOSavScheme InvPPF InvLICPension InvPvtBankPension InvLICInsurance InvPvtCompInsurance DepoPSUBank DepoPvtBank ///
DepoCoopBank DepoRRB InvLifeInsurance InvHealth InvAccidentInsurance InvCropInsurance InvEnterpInsurance InvPropInsurance ///
InvMachineInsurance InvLivStock InvCommFuture InvRealEstate InvBusiness InvPvtFunds InvJewel InvArt)

foreach var of varlist InvGovtBond - InvPvtBankPension{
replace `var' = 0 if `var' == .
ren `var' `var'10Lakh
}
egen sum = rowtotal( InvGovtBond10Lakh - InvPvtBankPension10Lakh)
assert sum < = 1000000
drop if sum>1000000
drop  if sum == 0
drop sum

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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A110LakhInv
clear

use 61A1
drop Q06_1_A_23 - Q06_1_A_47
ren ( Q06_1_A_48 Q06_1_A_49 Q06_1_A_50 Q06_1_A_51 Q06_1_A_52 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
drop  if new_memid1 == . & new_memid2 == . & new_memid3 == . & new_memid4 == . & new_memid5 == .

reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string

ren ( new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6 new_memid7 new_memid7_1 new_memid8///
new_memid9 new_memid10 new_memid11 new_memid12 new_memid13 new_memid14 new_memid15 new_memid16 new_memid17 ///
new_memid18 new_memid19 new_memid20 new_memid21new_memid22 new_memid23 new_memid24 new_memid25 new_memid26 ///
new_memid27 new_memid28 new_memid29) (InvGovtBond InvGovUndTkBond InvDebPvtComp InvEquiPvtComp InvMutFund InvDeriv ///
InvPOSavScheme InvPPF InvLICPension InvPvtBankPension InvLICInsurance InvPvtCompInsurance DepoPSUBank DepoPvtBank ///
DepoCoopBank DepoRRB InvLifeInsurance InvHealth InvAccidentInsurance InvCropInsurance InvEnterpInsurance InvPropInsurance ///
InvMachineInsurance InvLivStock InvCommFuture InvRealEstate InvBusiness InvPvtFunds InvJewel InvArt)

foreach var of varlist InvGovtBond - InvPvtBankPension{
replace `var' = 0 if `var' == .
ren `var' Time`var'
}

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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A110LakhTime
clear

use 61A110LakhInv
merge 1:1 id using 61A110LakhTime
drop if _merge != 3
drop _merge
save 61A110LakhInv, replace

use SAVING_06_1_A_1_MEMID
drop M23 - M42 M48 - M52
ren ( M43 M44 M45 M46 M47 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5)
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
duplicates report ID
gen double id = real( ID)
format id %13.0f
order id, a(ID)

save 61A110LakhMem
clear

use 61A110LakhInv
merge 1:1 id using 61A110LakhMem
drop  if _merge != 3
drop ID id _merge mem
gen str2  mem =  string( new_memid , "%02.0f")
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem new_memid
duplicates report ID
bys ID: drop if ID == ID[_n+1]
gen double id = real( ID)
order id, a(ID)
format %13.0f id
save 61A110LakhInv, replace
clear

* using data on parents' perception of their child's school

* the data is shaped in the following manner:
* the column Source(renamed)represents the different criteria used to assess the quality of the schools(10 criteria in all)
* corresponding to each criteria, there were 12 columns(6 for mother & 6 for father) where the parents individually assess the school quality of each child.
* I wanted to shape the data in such a way so that each row represented one parent
* the dummy var mother - 1 for mother, 0 for father was used to differentiate the parents.
* and the columns represented the ten set of criteria.
* the ids for the individual child was provided in a separate file.
* So, I split the data into two parts - mother & father.
* reshaped it twice - wide to long & long to wide.
* split the child id data - for mother & father
* matched the ids with the parents' data individually(mother & father)
* & appended the father's portion of the data to the mother's portion.
* the following algorithm was used.

use EDUCATION_7_1
drop Q07_1_09 - Q07_1_14
ren Q07_1_01 Source
ren ( Q07_1_03 Q07_1_04 Q07_1_05 Q07_1_06 Q07_1_07 Q07_1_08) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6)
generate source = strofreal(Source)
drop if Source == .
replace source = "source" + subinstr(source,".","_",.)
drop Source
reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string
ren ( new_memidsource1 new_memidsource2 new_memidsource3 new_memidsource4 new_memidsource5 new_memidsource6 ///
new_memidsource7 new_memidsource8 new_memidsource9 new_memidsource10) (SchoolEaseAccess SchoolRightCat ///
SchoolEduQuality SchoolFacilityAvl SchoolNoonMeal SchoolPrestige SchoolMedInstrOfChoice SchoolReligInstr ///
SchoolOthStuCasteRelig SchoolAfford)

foreach var of varlist SchoolEaseAccess - SchoolOthStuCasteRelig{
label define `var'criteria 1 "Yes" 2 "No"
label values `var' `var'criteria
}
gen mother = 1
order mother, a( new_hhid)

foreach var of varlist SchoolEaseAccess - SchoolOthStuCasteRelig{
replace `var' = 0 if `var' == .
}
egen sum = rowtotal( SchoolEaseAccess - SchoolOthStuCasteRelig)
drop if sum == 0
drop sum
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
save 71EduMother
clear

use EDUCATION_7_1
drop Q07_1_03 - Q07_1_08
ren Q07_1_01 Source
ren ( Q07_1_09 Q07_1_10 Q07_1_11 Q07_1_12 Q07_1_13 Q07_1_14 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6)
generate source = strofreal(Source)
drop if Source == .
replace source = "source" + subinstr(source,".","_",.)
drop Source
reshape long new_memid, i(state_id dist_id village_id new_hhid source) j(mem_id)
reshape wide new_memid, i(state_id dist_id village_id new_hhid mem_id) j(source) string
ren ( new_memidsource1 new_memidsource2 new_memidsource3 new_memidsource4 new_memidsource5 new_memidsource6 new_memidsource7 ///
new_memidsource8 new_memidsource9 new_memidsource10) (SchoolEaseAccess SchoolRightCat SchoolEduQuality SchoolFacilityAvl ///
SchoolNoonMeal SchoolPrestige SchoolMedInstrOfChoice SchoolReligInstr SchoolOthStuCasteRelig SchoolAfford)
foreach var of varlist SchoolEaseAccess - SchoolOthStuCasteRelig{
label define `var'criteria 1 "Yes" 2 "No"
label values `var' `var'criteria
}
gen mother = 0
order mother, a( new_hhid)
foreach var of varlist SchoolEaseAccess - SchoolOthStuCasteRelig{
replace `var' = 0 if `var' == .
}
egen sum = rowtotal( SchoolEaseAccess - SchoolOthStuCasteRelig)
drop if sum == 0
drop sum
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
save 71EduFather
clear

use EDUCATION_7_1_MEMID
drop CH_ID09 - CH_ID14
ren ( CH_ID03 CH_ID04 CH_ID05 CH_ID06 CH_ID07 CH_ID08) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6)
reshape long new_memid, i(state_id dist_id village_id new_hhid ) j(mem_id)
drop  if new_memid == .
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
save 71EduMemMother
clear

use EDUCATION_7_1_MEMID
drop CH_ID03 - CH_ID08
ren ( CH_ID09 CH_ID10 CH_ID11 CH_ID12 CH_ID13 CH_ID14 ) (new_memid1 new_memid2 new_memid3 new_memid4 new_memid5 new_memid6)
reshape long new_memid, i(state_id dist_id village_id new_hhid ) j(mem_id)
drop  if new_memid == .
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
save 71EduMemFather
clear

use 71EduMother
merge 1:1 hhid mem_id using 71EduMemMother
drop if _merge != 3
drop _merge
drop HHID hhid
drop mem_id
order new_memid, a( new_hhid)
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
save 71EduMother, replace
clear

use 71EduFather
merge 1:1 hhid mem_id using 71EduMemFather
drop if _merge != 3
drop _merge
drop HHID hhid
drop mem_id
order new_memid, a( new_hhid)
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
save 71EduFather, replace
clear

use 71EduMother
append using 71EduFather
sort id
tab mother
save 71EduSchool
clear

* using data on student's perception of school performance

use PERFORMANCE_7_2

ren ( Q07_2_02 Q07_2_03 Q07_2_04 Q07_2_05 Q07_2_06 Q07_2_07 Q07_2_08 Q07_2_09 Q07_2_10 Q07_2_11 Q07_2_12 Q07_2_13 ///
Q07_2_14 Q07_2_15 Q07_2_16 Q07_2_17 Q07_2_18) (SchoolID Class SchoolModeTransport NoOfTeachers TeachersAbsentPerMonth ///
NoonMealProg NoStudentsClass AdequateSpaceSit SepRoomEachStandards ClassSitArrange IsThereBlackBoard TeacherTakeTimeExplain ///
TeacherUpsetAskQues ToiletAvailability ToiletFunctioning PlayGround DrinkingWaterFacility)

foreach var of varlist NoonMealProg AdequateSpaceSit SepRoomEachStandards IsThereBlackBoard TeacherTakeTimeExplain TeacherUpsetAskQues ///
ToiletAvailability PlayGround ToiletFunctioning DrinkingWaterFacility{
label define `var'perf 1 "Yes" 2 "No"
label values `var' `var'perf
}
foreach var of varlist NoonMealProg AdequateSpaceSit SepRoomEachStandards IsThereBlackBoard TeacherTakeTimeExplain TeacherUpsetAskQues ///
ToiletAvailability PlayGround ToiletFunctioning DrinkingWaterFacility{
replace `var' = . if `var'>2 | `var' <1
}
tab Class, mi
tab NoOfTeachers, mi
winsor2 NoOfTeachers, cuts(0.1 99)
replace NoOfTeachers = NoOfTeachers_w
drop NoOfTeachers_w
tab TeachersAbsentPerMonth, mi
tab NoStudentsClass, mi
winsor2 NoStudentsClass, cuts(0.1 99)
replace NoStudentsClass = NoStudentsClass_w
drop NoStudentsClass_w
label define transp 1 "Cycle rickshaw" 2 "Auto rickshaw" 3 "Taxi/Tempo" 4 "Bus/Train" 5 "Bullock cart" 6 "Bicycle" 7 "Two-wheeler" 8 "On foot"
label values SchoolModeTransport transp
label define sit 1 "On bench & chairs" 2 "Sit on the ground" 3 "Sitting under a tree"
label values ClassSitArrange sit
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
save 72SchoolPerf
clear

* using data on parent's participation in village education committee(VEC)/School management committee(SMC) meetings.

use VILLAGE_EDUCATION_7_3

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
order id, a(ID)
format %13.0f id
sort id sl_no
ren sl_no MeetingNo
ren ( Q07_3_03 Q07_3_04 Q07_3_05 Q07_3_06 Q07_3_07 Q07_3_08 Q07_3_09 Q07_3_10 Q07_3_11 Q07_3_12 Q07_3_13 Q07_3_14 Q07_3_15_1 Q07_3_15_2 ///
Q07_3_15_3 Q07_3_15_4) (VECorSMCmember WhetherAttended Year Month HowLongMeetLast Issue1Disc Issue2Disc Issue3Disc WereIssuesRelevant ///
ParticipatedHow WhetherIssueResolved ReasonsNotAttending Roles1 Roles2 Roles3 Roles4)
tab WhetherIssueResolved
foreach var of varlist WhetherAttended WereIssuesRelevant WhetherIssueResolved{
label define `var'cat 1 "Yes" 2 "No"
label values `var' `var'cat
}
label define member 1 "Yes" 2 "No" 3 "Don't Know"
label values VECorSMCmember member


foreach var of varlist Issue1Disc - Issue3Disc{
label define `var'issue 1 "Maintenance & upkeep/upgradation/construction of school buildings" 2 "Improvement of school environment" 3 ///
"Monitoring the attendance & performance of teachers" 4 "Discussing various complaints made by parents of children enrolled in school" ///
5 "Sanitation facilities in school premises" 6 "Drinking water facilities in school premises" 7 "Non-enrollment & issues of drop-outs" ///
8 "Improving schooling habits of children"
label values `var' `var'issue
}
label define part 1" Presented issue"  2 "raised questions" 3"discussed" 4"protested" 5 "observed only"
label values ParticipatedHow part

label define absent 1"Didn't know about the meeting in time" 2 "The issues were not important to me" 3"I've no influence anyway" ///
4"I don't understand the issues discussed" 5"I feel embarrassed" 6"I had a bad experience going in the past" 7"Sickness" 8"Old age" ///
9" Lack of privacy for women" 10"Meeting held at an inconvenient place" 11"Have to sit with men" 12"Have to sit with women" ///
13"Have to sit with person of other caste/religion" 14"Dislike for current VEC/SMC members" 15"Dislike for current Gram Pradhan" ///
16"Not allowed by the head of the household"
label values ReasonsNotAttending absent

foreach var of varlist Roles1 - Roles4{
label define `var'role 1"Monitoring the overall performance of school authorities regarding running of the school" ///
2"Conducting awareness programs on girl child education" 3"Maintenance & upkeep/upgradation/construction of school buildings" ///
4"Improvement of school environment" 5"Monitoring the attendance & performance of teachers" ///
6"Discussing various complaints made by parents of children enrolled in school" 7"Ensuring proper sanitation facilities in school premises" ///
8"Ensuring adequate drinking water facilities in school premises" 9"Addressing issues related to non-enrollment & drop-outs" ///
10"Taking measures to improve the schooling habits of children" 11"No idea at all"
label values `var' `var'role
}
save 73VillageEdu
clear


* using individual level data on health events, treatment & expenditure

use HEALTH_CARE_8_1
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

ren ( Q08_1_02 Q08_1_03 Q08_1_04 Q08_1_05 Q08_1_06 Q08_1_07 Q08_1_08 Q08_1_09 Q08_1_10 Q08_1_11 Q08_1_12 Q08_1_13 ///
Q08_1_14 Q08_1_15 Q08_1_16 Q08_1_17 Q08_1_18 Q08_1_19) (PhysicChallenged WorkDaysMissedIllness SeekMedHelp HealthIssue1 ///
TreatChoiceReason1 HealthIssue2 TreatChoiceReason2 HealthIssue3 TreatChoiceReason3 TreatmentCost TreatModePay DoctorFee ///
DocModePay MedicineCost MedModePay HospitalCharge HostModePay ContriMedInsurance)

label define pc 1"Yes" 2"No"
label values PhysicChallenged pc

label define med 1"Yes" 2"No"
label values SeekMedHelp med

foreach var of varlist HealthIssue1 HealthIssue2 HealthIssue3{
label define `var'health 1"Birth or pre/post natal care" 2"Accident/disability" 3"Vision" 4"Respiratory problem" 5"Hearing problem" ///
6"Digestive problem" 7"Mental problem" 8"Malaria" 9"Muscular pain" 10"Influenza/other fever" 11"Sexual disease/HIV" 12"TB" 13"Cholera"///
 14"Epilepsy" 15"Regular health check up" 16"Cough & cold" 17"Contagious disease" 18"Epidemics" 19"Heart problem" 20"Cancer" 21"Blood pressure" ///
 22"Dengue" 23"Bird flu" 24"Polio" 25"Diabetes" 26"Kidney ailments" 27"Hydrosil" 28"Anaemia" 29"Diarrhoea" 30"Blood pressure related problems"
label values `var' `var'health
}
foreach var of varlist TreatChoiceReason1 TreatChoiceReason2 TreatChoiceReason3 {
label define `var'treat 1"Cheap service" 2"Better service" 3"Was referred by Medical practitioner" 4"Was referred by friend/ relative" ///
5"Near to the house" 6"Only place that has treatment for this ailment" 7 "Only place that was open on that day"
label values `var' `var'treat
}
foreach var of varlist TreatModePay DocModePay MedModePay HostModePay{
label define `var'mode 1"Cash" 2"Cheque" 3"Draft" 4"Installment/Credit" 5"Mobile wallet"
label values `var' `var'mode
}
foreach var of varlist TreatmentCost DoctorFee MedicineCost HospitalCharge ContriMedInsurance{
winsor2 `var', cuts(1, 99)
}
foreach var of varlist TreatmentCost DoctorFee MedicineCost HospitalCharge ContriMedInsurance{
replace `var' = `var'_w
drop `var'_w
}
save 81Health
clear

use GOVERNACE_10_1_A

* Using individual level data on voting patterns

use GOVERNACE_10_1_A
ren Q10_1A_01 Representative
label define rep 1"Panchayat president" 2"Ward member/representative" 3"MLA" 4"MP"
label values Representative rep
tab Representative, mi
replace Representative = . if Representative>4

ren ( Q10_1A_04 Q10_1A_05 Q10_1A_06 Q10_1A_07 Q10_1A_08 Q10_1A_09 Q10_1A_10 Q10_1A_11 Q10_1A_12 Q10_1A_13 Q10_1A_14 Q10_1A_15 Q10_1A_16 ///
Q10_1A_17 Q10_1A_18) (Voted ChosenCandiContestLastElec VoteSameCandLastTime VoteWinner ReasonsNotVote SocStatusCand CasteCand ReligionCand ///
TechQualificaCand KnowLocProbCand KnowNatlProbCand HonestyCand FamilyFriendCand AbilityRepVillProbGovt OthReasons)

foreach var of varlist Voted ChosenCandiContestLastElec VoteSameCandLastTime VoteWinner SocStatusCand CasteCand ReligionCand TechQualificaCand ///
KnowLocProbCand KnowNatlProbCand HonestyCand FamilyFriendCand AbilityRepVillProbGovt{
replace `var' = . if  `var'>2 | `var' <1
label define `var'cat 1"Yes" 2"No"
label values `var' `var'cat
}

label define reason 1"Only one candidate" 2"Elections are not important in the household" 3"Indirect Election" 4"Not aware of elections" ///
5"To protest" 6"Didn't like any of the candidates" 7"Indifference" 8"Not allowed to vote by elders" 9"Don't have voter id card" ///
10"Don't have name in the voter list" 11"Prevented from voting through muscle power" 12"Not at home"
label values ReasonsNotVote reason

label define other 1"Told to do so by spouse" 2"Threatened by political party" 3"Offered monetary inducement" 4"Offered other inducements" ///
5"Voted for the party not the candidate"
label values OthReasons other

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
order id, a(ID)
format %13.0f id
save 101AGovernance
clear

use GOVERNANCE_10_2

*using household level data on participation in local groups.

label define group 1"SHG for women" 2"Mother's Committee" 3"Other SHGs" 4"NGOs" 5"Religious groups" 6"Political Parties" ///
7"Caste Association" 8"Village Development Committee" 9"Village Tribal Development Agency" 10"Village Education Committee" ///
11"Committee on Irrigation" 12"Self-employed schemes" 13" Co-operatives" 14"Business Associations" 15"Caste Panchayat" ///
16"Benefits rcvd from SHG for women" 17"Benefits rcvd. from other SHG"
label values Q10_2_01 group
ren (Q10_2_01 Q10_2_03 Q10_2_04 Q10_2_05 Q10_2_06 Q10_2_07 Q10_2_08 Q10_2_09 Q10_2_10) (NameOfGroup GroupExistInVillage ///
PrefGroupForHelp WhetherMemberParticipates MemID1 MemID2 MemID3 MemID4 MemID5)
label define part 1" Yes" 2"No"
label values WhetherMemberParticipates part
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)

* for those members in the hh who participate in these groups, their ids were provided.
* I created an unique 13-digit ids for these individuals so that, if required, they can be matched wuth the hh roster.

gen str2 `var'_s = string(`var' , "%02.0f")
foreach var of varlist MemID1 - MemID5{
gen str2 `var'_s = string(`var' , "%02.0f")
}
drop MemID1 - MemID5
ren( MemID1_s MemID2_s MemID3_s MemID4_s MemID5_s)(ID1 ID2 ID3 ID4 ID5)
foreach var of varlist ID1 - ID5{
replace `var' = stateid+ distid+ villid+ hh+`var' if `var' != "."
}
save 102Governance
clear


use GOVERNANCE_10_3_A_I

* using household level data on participation in different welfare programs in the village - beneficiaries targeted at the household level.

tab Q10_3A_01
label define prog 1"BPL card - Antodya" 2"BPL card - less poor" 3"Other ration card" 4"Housing Support Scheme" 5"Sanitation Support Scheme" ///
6"Indira Awas Yojana" 7"Accelerated Rural Water Supply Program" 8"Targeted Public Distribution System" 9"Annapurna" ///
10"Total Sanitation Campaign/NBA/SBM" 11"Swajaldhara/NRDWP" 12"Samagra Awaas Yojana" 13"Fasal Bima Yojana"
label values Q10_3A_01 prog

ren ( Q10_3A_01 Q10_3A_03 Q10_3A_04 Q10_3A_05 Q10_3A_06 Q10_3A_07 Q10_3A_08 Q10_3A_09 Q10_3A_10 Q10_3A_11 Q10_3A_12 Q10_3A_13 ) ///
(ProgramName PanchayatCode AwareProgExistVillage IsHouseHoldBeneficiary DidHhGetAllBenefits RcvdPercentBenefitEntitled ExtraMoneyGetBenefits ///
BribeAmt DelayGetBenefits DelayInDays TargetBeneficiaryTransparent AmtRcvdProgram)


foreach var of varlist AwareProgExistVillage IsHouseHoldBeneficiary DidHhGetAllBenefits ExtraMoneyGetBenefits DelayGetBenefits{
replace `var' = . if `var' >2 | `var' <1
label define `var'cat 1"Yes" 2"No"
label values `var' `var'cat
}
tab BribeAmt
replace BribeAmt = 40 if BribeAmt<40
winsor2 AmtRcvdProgram, cuts(1 99.5)
tab AmtRcvdProgram_w
replace AmtRcvdProgram = AmtRcvdProgram_w
drop AmtRcvdProgram_w
label define trans 1"Very transparent" 2"Somewhat transparent" 3"Not transparent"
label values TargetBeneficiaryTransparent trans
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen HHID = stateid+ distid+ villid+ hh
order HHID, first
gen double hhid = real( HHID)
format hhid %11.0f
order hhid, a(HHID)
save 103AGovernance
clear


use GOVERNANCE_10_3_A_II

* using individual level data on participation in different welfare programs in the village - beneficiaries targeted at the individual level.

label define prog 1"SGRY" 2"SGSY/NRLM" 3"ICDS" 4"Social Security Pension" 5"Mid-day meal program" 6"Business Support Program" ///
7"Food for work program" 8"PMGY" 9"MGNREGA" 10"Credit cum Subsidy scheme" 11"Women centric program" 12"Scholarships" 13"PMJDY" 14"Atal Pension Yojana"
label values Q10_3AII_01 prog

ren ( Q10_3AII_01 Q10_3AII_03 Q10_3AII_04 Q10_3AII_05 Q10_3AII_06 Q10_3AII_07 Q10_3AII_08 Q10_3AII_09 Q10_3AII_10 Q10_3AII_11 ///
Q10_3AII_12 Q10_3AII_13) (ProgramName PanchayatCode Beneficiary MemID GotAllBenefits GotPercentBenEntitled ExtraMoneyGetBenefits ///
BribeAmt DelayRcvBenefits DelayInDays WasTargetTransparent AmtRcvdProgram)

order MemID, a( new_hhid)
foreach var of varlist GotAllBenefits ExtraMoneyGetBenefits DelayRcvBenefits{
replace `var' = . if `var' >2 | `var' <1
label define `var'cat 1"Yes" 2"No"
label values `var' `var'cat
}
tab BribeAmt
replace BribeAmt = 100 if BribeAmt<100
label define trans 1"Very transparent" 2"Somewhat transparent" 3"Not transparent"
label values WasTargetTransparent trans
tab AmtRcvdProgram
winsor2 AmtRcvdProgram, cuts(6 99.5)
tab AmtRcvdProgram_w
replace AmtRcvdProgram = AmtRcvdProgram_w
drop AmtRcvdProgram_w
tostring state, ge(stateid)
tostring dist_id , ge(distid)
gen str3  villid =  string( village_id , "%03.0f")
order villid, a( village_id )
gen str4  hh =  string( new_hhid , "%04.0f")
order hh, a( new_hhid )
gen str2  mem =  string( MemID , "%02.0f")
order mem, a( MemID )
gen ID = stateid+ distid+ villid+ hh+ mem
order ID, first
drop stateid distid villid hh mem
gen double id = real( ID)
order id, a(ID)
format %13.0f id
save 103AIIGovernance
clear

use GOVERNANCE_10_4
ren ( Q10_4_01 Q10_4_03 Q10_4_04 Q10_4_05 Q10_4_06 Q10_4_07 Q10_4_08 Q10_4_09 Q10_4_10 Q10_4_11 Q10_4_12) ///
(SlNo HowManyGSMeetHeld IssuesDiscussed AttendNoOfMeets ActiveParticipationMeet HowLongMeetLasts NoticePeriodGSMeets ///
KnowledgeOfIssuesB4Hand AreMinutesMade CanAccessMinutes HaveAccessedMinutes)
foreach var of varlist ActiveParticipationMeet CanAccessMinutes HaveAccessedMinutes{
replace `var' = . if `var' >2 | `var' <1
label define `var'cat 1"Yes" 2"No"
label values `var' `var'cat
}
label define issue 1"Drinking water" 2"Sanitation & sewage" 3"Roads & transportation" 4"Irrigation canals, ponds, wells" ///
5"Electrification" 6"Street lighting" 7"Credit & input subsidies" 8"Communication" 9"School & education" 10"Health facilities" ///
11"Natural Resource management" 12"Employment schemes/food for work" 13"Social issues & ceremonies" 14"Women empowerment" ///
15"Housing scheme" 16"Don't know/can't say"
label values IssuesDiscussed issue

label define notice 1"More than two weeks before meeting" 2"Between one & two weeks before meeting" ///
3"From one day to a week before a meeting" 4"Only on the same day of meeting" 5"After the meeting is held" 6"Don't know/Can't say"
label values NoticePeriodGSMeets notice

label define minute 1"Always" 2"Sometimes" 3"Never" 4"Don't know/can't say"
label values AreMinutesMade minute

label define meet 1"Yes, often" 2"Yes, a few times" 3"Rarely" 4"No, never"
label values KnowledgeOfIssuesB4Hand meet

tab HowLongMeetLasts
winsor2 HowLongMeetLasts, cuts(1 99)
replace HowLongMeetLasts = HowLongMeetLasts_w
drop HowLongMeetLasts_w

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
order id, a(ID)
format %13.0f id
save 104Governance
clear


use GOVERNANCE_10_5

*using individual level data on participation in local governance.

ren ( Q10_5_01 Q10_5_03 Q10_5_04 Q10_5_05 Q10_5_06 Q10_5_07 Q10_5_08 Q10_5_09 Q10_5_10 Q10_5_11 Q10_5_12 Q10_5_13 ///
Q10_5_14 Q10_5_15 Q10_5_16 Q10_5_17 Q10_5_18 Q10_5_19 Q10_5_20) (MeetingNo AttendedMeet Year Month MeetDuration ///
IssueDisc1 IssueDisc2 IssueDisc3 IssuesRelevant ParticipationMode DidNotAttendWhy AttendIfDealtBeneficiarySelec ///
AttendIfDealtDrinkWater AttendIfDealtIrrigation AttendIfDealtEduc AttendIfDealtHealth AttendIfDealtSanitation ///
AttendIfDealtRoads AttendIfDealtFestivalArrange)

foreach var of varlist AttendedMeet IssuesRelevant AttendIfDealtBeneficiarySelec - AttendIfDealtFestivalArrange{
replace `var' = . if `var' >2 | `var' <1
label define `var'cat 1"Yes" 2"No"
label values `var' `var'cat
}
foreach var of varlist IssueDisc1 - IssueDisc3{
label define `var'issue 1"Drinking water" 2"Sewage/Sanitation" 3"Roads/transportation" 4"Irrigation canals, ponds, wells"///
 5"Electrification" 6"Street lighting" 7"Credit & input subsidies" 8"Communication" 9"School & education" 10"Health facilities" ///
 11"Natural Resource management" 12"Employment schemes/food for work" 13"Social issues & ceremonies" 14"Women empowerment" ///
 15"Housing scheme" 16"Don't know/can't say"
label values `var' `var'issue
}
label define abs 1"Didn't know about the meeting in time" 2"The issues were not important to me" 3"I have no influence anyway" ///
4"I don't understand the issues discussed" 5"I feel embarrassed" 6"I had a bad experience in the past" 7"Sickness" 8"Old age" ///
9"Lack of privacy for women" 10"Meeting held at an inconvenient place" 11"Have to sit with men" 12"Have to sit with women" ///
13"Have to sit with person of other caste/religion" 14"Dislike for current pradhan" 15"Dislike for current GP members" ///
16"Not allowed by the head of the household"
label values DidNotAttendWhy abs

label define part 1"Presented issue" 2"Raised questions" 3"Discussed" 4"Protested" 5"Observed only"
label values ParticipationMode part

tab Year
replace Year = 2016 if Year == 216 | Year == 3016
replace Year = 2014 if Year == 2041
replace Year = . if Year<2000

tab MeetDuration
replace MeetDuration = 4 if MeetDuration>4 & MeetDuration != .

use 105Governance
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
order id, a(ID)
format %13.0f id
save 105Governance
clear

* The End!

