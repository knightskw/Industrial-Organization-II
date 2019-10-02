* Shai Knight-Winnig 2018
clear

import delimited "/Users/Shai/Documents/Stata/ps1data.csv"

////////////////////////////////////////////////////////////////////////////////////
/*1a Run Logit model using basic OLS*/
////////////////////////////////////////////////////////////////////////////////////


/*Create share of outside good and then take log */
by market, sort: egen s0temp = sum(sjn)
gen s0 = 1 - s0temp

gen lns0 = log(s0)

/*Take log of share of j*/
gen lnsj = log(sjn)

/* Create dependent variable for OLS */
gen y = lnsj - lns0


/* Do simple OLS */
 reg y pjn x1 x2
 
 /*Create fitted values for shares (not sure if this is correct)*/
 
 predict py
 
 gen fitshare = exp(py)*s0
 
 /*Save reg coeff*/
 mat beta=e(b)
 svmat double beta, names(matcol)
 gen alpha = betapjn[1]
 
/* Calculate the avg own price elasticity */
/*(NOT FITTED SHARE)*/
 gen ejtemp = alpha*pjn*(1-sjn)
 
 by prodid, sort: egen ej = mean(ejtemp)
 
/*Create cross price elasticity for product 3 */

 gen p3temp = pjn if prodid==3
 egen p3 = mean(p3temp)
 
 gen s3temp = sjn if prodid==3
 egen s3 = mean(s3temp)
 
 gen xe3 = alpha*s3*p3
 
 /* Calculate the avg own price elasticity  */
/*(USE FITTED SHARE)*/
 gen ejtempfit = alpha*pjn*(1-fitshare)
 
 by prodid, sort: egen ejfit = mean(ejtempfit)
 
/*Create cross price elasticity for product 3 */
 
 gen s3tempfit = fitshare if prodid==3
 egen s3fit = mean(s3tempfit)
 
 gen xe3fit = alpha*s3fit*p3
 
/////////////////////////////////////////////////////////////////////////
 /*1b Estimate same model with IV using supply side cost shifters*/ 
////////////////////////////////////////////////////////////////////////////

ivregress 2sls y x1 x2 (pjn = w1 w2), first

predict pyiv
 
gen fitshareiv = exp(pyiv)*s0
 
/*Store results from this regression to use in 1d*/
mat betaiv=e(b)
 svmat double betaiv, names(matcol)
 gen alphaiv = betaivpjn[1]


/*Test the joint significance of the instruments in first stage regression*/
reg pjn w1 w2 x1 x2
test w1 w2


/////////////////////////////////////////////////////////////////////////
 /*1c Estimate same model with IV*/ 
////////////////////////////////////////////////////////////////////////////

/*Create new instruments (sum of characteristics of other products in same market)*/


by market, sort: egen x1sumtemp = sum(x1)
gen x1sum = x1sumtemp-x1

by market, sort: egen x2sumtemp = sum(x2)
gen x2sum = x2sumtemp-x2

/*Run IV regression using these two new instruments*/

ivregress 2sls y x1 x2 (pjn = x1sum x2sum), first

/*Test the joint significance of the instruments in first stage regression*/
reg pjn x1sum x2sum x1 x2
test x1sum x2sum

/////////////////////////////////////////////////////////////////////////
 /*1d Calculate the elasticities as in a with results from 1b*/ 
////////////////////////////////////////////////////////////////////////////

/* Calculate the avg own price elasticity */
/*(NOT FITTED SHARE)*/
 gen ejtempiv = alphaiv*pjn*(1-sjn)
 
 by prodid, sort: egen ejiv = mean(ejtempiv)
 
/*Create cross price elasticity for product 3 */
 
 gen xe3iv = alphaiv*s3*p3
 
 /* Calculate the avg own price elasticity  */
/*(USE FITTED SHARE)*/
 gen ejtempfitiv = alphaiv*pjn*(1-fitshareiv)
 
 by prodid, sort: egen ejfitiv = mean(ejtempfitiv)
 
/*Create cross price elasticity for product 3 */
 
 gen s3tempfitiv = fitshareiv if prodid==3
 egen s3fitiv = mean(s3tempfitiv)
 
 gen xe3fitiv = alphaiv*s3fitiv*p3

