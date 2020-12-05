
dist=read.table('../treedist/chr1-all.tre.rfdist',sep = " ",skip = 1)
d=density(dist,na.rm = T)
d$y[d$x < 0] <- 0
plot(d)

n=216
f=function(z,n=216){
  result=(1/8)^(n-3-z/2)/factorial(n-3-z/2)*exp(-1/8)
  return(result)
  }
