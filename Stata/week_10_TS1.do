capture log close
log using "week_10_TS1", smcl replace
//_1
cd "/Users/Sam/Desktop/Econ 645/Data/Wooldridge"
//_2
use phillips.dta, clear
//_3
tsset year, yearly
//_4
reg inf unem if year < 1997
//_5
twoway line inf year, title("Annual Inflation Rate")
graph export "week_10_inf_line.png", replace
//_6
use intdef.dta, clear
//_7
tsset year
//_8
reg i3 inf def if year < 2004
//_9
use prminwge, clear
//_10
tsset year
//_11
reg lprepop lmincov lusgnp if year < 1988
//_12
use barium.dta, clear
//_13
tsset t, monthly
//_14
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6
//_15
display (exp(-.565)-1)*100
//_16
use fertil3.dta, clear
//_17
tsset year, yearly
//_18
reg gfr pe i.ww2 i.pill if year < 1985
//_19
reg gfr pe pe_1 pe_2 i.ww2 i.pill if year < 1985
//_20
test pe pe_1 pe_2
test pe_1 pe_2
//_21
gen pe_1_1 = pe_1 - pe
gen pe_2_1 = pe_2 - pe
//_22
reg gfr pe pe_1_1 pe_2_1 i.ww2 i.pill
//_23
use hseinv.dta, clear
//_24
tsset year, yearly
//_25
reg linvpc lprice
//_26
reg linvpc lprice t
//_27
predict u
reg u l.u, noconst
drop u
//_28
use fertil3.dta, clear
//_29
tsset year, yearly
//_30
reg gfr pe i.ww2 i.pill t if year < 1985
//_31
reg gfr pe i.ww2 i.pill c.t##c.t if year < 1985
//_32
use prminwge, clear
//_33
tsset year, yearly
//_34
reg lprepop lmincov lusgnp t
//_35
use barium.dta, clear
//_36
tsset t, monthly
//_37
reg lchnimp lchempi lgas lrtwex befile6 affile6 afdec6 feb mar apr may ///
    jun jul aug sep oct nov dec
//_38
test feb mar apr may jun jul aug sep oct nov dec
//_39
use nyse, clear
//_40
tsset t, weekly
//_41
reg return l.return
//_42
reg return return_1
predict u
reg u l.u, noconst
drop u
//_43
use phillips.dta, clear
//_44
tsset year
//_45
reg cinf unem if year < 1997
//_46
reg d.inf unem if year < 1997
//_47
display 3.03/.5425
//_48
twoway line cinf year || line unem year, lpattern(dash) ///
legend(order(1 "Difference in Inflation" 2 "Unemployment Rate")) ///
title("Augmented Phillips Curve") ytitle(Percentage) xtitle(year)
//_49
graph export "week_10_augmented_phillips.png", replace
//_^
log close
