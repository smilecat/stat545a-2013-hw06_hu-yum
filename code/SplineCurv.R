setwd("~/Statistics/stat545A/Final Project")

#### spline function ####
my.spline = function(x,y)
{
  ## INPUT:
  ## x = real vector. It's values should be sorted in increasing order (explanatory variable)
  ## y = real vector  (the values of the response variable)
  
  ## OTPUT: 
  ## curvatre
  n=length(x)  
  Delta = x[2:n]-x[1:(n-1)]
  R = matrix(0,(n-2),(n-2))
  for(i in 1:(n-2)){
    if(i ==1) {R[i,i] = 2*(Delta[i]+Delta[i+1]); R[i,i+1]=Delta[i+1]}
    if(i >1 & i < n-2){ 
      R[i,i-1] = Delta[i-1];
      R[i,i]   = 2*(Delta[i-1] + Delta[i]);
      R[i,i+1] = Delta[i]
    }
    if(i == (n-2)) {R[i,i-1] = Delta[i-1]; R[i,i] = 2*(Delta[i-1] + Delta[i])}
    
  }
  R=(1/6)*R
  
  
  Q = matrix(0,(n-2),n)
  Delta_inv=1/Delta
  for(i in 1:(n-2)){
    Q[i,i] = Delta_inv[i];Q[i,i+1] = -(Delta_inv[i]+Delta_inv[i+1]); Q[i,i+2]=Delta_inv[i+1]  		    						    
  }  
  curv = t(y)%*%t(Q)%*%solve(R)%*%Q%*%y
  return(curv)
}
