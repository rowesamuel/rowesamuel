*Test
clear

set obs 1
input id y1 y2 e1 e2
1 0 0 . .
expand 50

replace id=_n
replace y1=.
replace y2=.
replace y1=0 if _n==1
replace y2=0 if _n==1

tsset id

replace e1 = rnormal(0,1)
replace e2 = rnormal(0,1)

replace y1=l.y1 + e1 if _n>1
replace y2=l.y2 + e2 if _n>1

graph twoway (line y1 id) || (line y2 id), yline(0) ///
             title("Two realizations of the random walk") ///
			 subtitle("y_t=y_t-1+e_t with y_0 = 0, e_t~N(0,1), n=50")

gen a = 4.56
gen y3=.
replace y3=0 if _n==1
gen e3 = rnormal(0,5)
replace y3 = a+l.y3+e3 if _n>1
gen aline = .
replace aline = 0 if _n==1
replace aline = l.aline + a if _n>1

graph twoway (line y3 id) || (line aline id, lpattern(dash)), ///
             title("A realization of a random walk with a drift") ///
			 subtitle("y_t=4.56+y_t-1+e_t, y_0=0, e~N(0,5), and n=50")
