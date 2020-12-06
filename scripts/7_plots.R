#7(a)
#result in 6(a)
dist=read.table('../treedist/chr1-all.tre.rfdist',sep = " ",skip = 1)
#remove na
na_len=sum(is.na(dist[1,]))
len=length(dist[1,])
dist=dist[,c((len-na_len+2):len)]

#get the distance vector of each 2 different trees
d=c()
for (i in 1:length(dist[1,])) {
  for (j in 1:length(dist[1,])) {
    if (i!=j){
      d=c(d,dist[i,j])}
    
  }
}


n=length(dist[,1])
#n=5
#calculate S=n-3-D/2
s=n-3-d/2
h=hist(s,freq = F,breaks = c(0:max(s+1)),col = 'blue')


#D=c(f(0,n),f(1,n),f(2,n),f(3,n))
S=dpois(x=0:max(s),lambda=1/8)

png(filename="7a.png")
#blue stands for 6a
barplot(h$density,col = rgb(0,0,1,0.5),main='Compare Results of 6(a) and the Poisson Dist of S',names.arg=c(0:max(s)),ylim =c(0,1) )
#red stands for the poisson dist
barplot(S,add = T,col=rgb(1,0,0,0.5))
legend("topright", 
       legend = c("6(a)", "Poisson of S"), 
       fill = c(rgb(0,0,1,0.5),rgb(1,0,0,0.5)))
dev.off()

#------------------------------------------------------#
#7(b)
#result in 6(b)
dist2=t(read.table('../treedist/chr1-all.adj.tre.rfdist',sep = " ",skip = 1))
#remove na
dist2=dist2[!is.na(dist2)]
d2=dist2
s2=n-3-d2/2
h2=hist(s2,freq = F,breaks = c(0:max(s2)),col = 'blue')

png(filename="7b.png")
#blue stands for 6a
barplot(h$density,col = rgb(0,0,1,0.5),main='Compare Results of 6(a) and 6(b)',names.arg=c(0:max(s)),ylim=c(0,1))
#green stands for 6b
barplot(h2$density,add = T,col=rgb(0,1,0,0.5))
legend("topright", 
       legend = c("6(a)", "6(b)"), 
       fill = c(rgb(0,0,1,0.5),rgb(0,1,0,0.5)))
dev.off()








