#7(a)
#result in 6(a)
dist=read.table('../treedist/chr1-all.tre.rfdist',sep = " ",skip = 1)
#remove na
na_len=sum(is.na(dist[1,]))
len=length(dist[1,])
dist=dist[,c((na_len+2):len)]

#get the distance vector of each 2 different trees
d=c()
for (i in 1:length(dist[1,])) {
  for (j in 1:length(dist[1,])) {
    if (i!=j){
      d=c(d,dist[i,j])}
    
  }
}

#n is the number of strains
n=216
#calculate S=n-3-D/2
s=n-3-d/2
rp=rpois(length(s),1/8)
png(filename="../images/7a.png")
h=hist(s,freq = F,breaks = c(0:max(s+1)),col = rgb(0,0,1,0.5),ylim = c(0,1),
       main='Distance of Randomly Chosen Blocks and Poison Distribution')
hist(rp,freq = F,add=T,breaks = c(0:max(s+1)),ylim = c(0,1),col=rgb(1,0,0,0.5))

# S=dpois(x=c(0:max(s)),lambda=1/8)
# barplot(S,add = T,col=rgb(1,0,0,0.5))
abline(v=mean(s),col = rgb(0,0,1,0.5),lty=2,lwd=2)
abline(v=mean(rp),col=rgb(1,0,0,0.5),lty=2,lwd=2)
legend("topright", 
       legend = c("Randomly Chosen", "Poisson Distribution"), 
       fill = c(rgb(0,0,1,0.5),rgb(1,0,0,0.5)))
dev.off()
# png(filename="../images/7a.png")
# #blue stands for 6a
# barplot(h$density,col = rgb(0,0,1,0.5),main='Distance of Randomly Chosen Blocks and Poison Distribution',names.arg=c(min(s):max(s+1)),ylim =c(0,0.5))
# #red stands for the poisson dist
# barplot(S,add = T,col=rgb(1,0,0,0.5))
# legend("topright", 
#        legend = c("Randomly Chosen", "Poisson Distribution"), 
#        fill = c(rgb(0,0,1,0.5),rgb(1,0,0,0.5)))
# dev.off()

#------------------------------------------------------#
#7(b)
#result in 6(b)
dist2=t(read.table('../treedist/chr1-all.adj.tre.rfdist',sep = " ",skip = 1))
#remove na
dist2=dist2[!is.na(dist2)& dist2!=0]
d2=dist2
s2=n-3-d2/2
#h2=hist(s2,freq = F,breaks = c(0:max(s2)),col = 'blue')

# png(filename="../images/7b.png")
# #blue stands for 6a
# barplot(h$density,col = rgb(0,0,1,0.5),main='Compare Results of 6(a) and 6(b)',names.arg=c(0:max(s)),ylim=c(0,1))
# #green stands for 6b
# barplot(h2$density,add = T,col=rgb(0,1,0,0.5))
# legend("topright", 
#        legend = c("6(a)", "6(b)"), 
#        fill = c(rgb(0,0,1,0.5),rgb(0,1,0,0.5)))
# dev.off()
png(filename="../images/7b.png")
h=hist(s,freq = F,breaks = c(0:max(max(s),max(s2))),col = rgb(0,0,1,0.5),ylim = c(0,0.4),main='Distance of Randomly Chosen Blocks and Consecutive Blocks')
h=hist(s2,freq = F,breaks = c(0:max(max(s),max(s2))),col=rgb(0,1,0,0.5),add=T)
#add vertival mean line
abline(v=mean(s),col = rgb(0,0,1,0.5),lty=2,lwd=2)
abline(v=mean(s2),col=rgb(0,1,0,0.5),lty=2,lwd=2)

legend("topright", 
       legend = c("Randomly Chosen", "Consecutive"), 
       fill = c(rgb(0,0,1,0.5),rgb(0,1,0,0.5)))
dev.off()




