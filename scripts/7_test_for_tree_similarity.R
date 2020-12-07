# Read the arguments
args = (commandArgs(trailingOnly=TRUE))
if(length(args) == 1){
  # Number of strains
  n = as.numeric(args[1])
} else {
  cat('usage: Rscript 7_test_for_tree_similarity.R <strain number>\n', file=stderr())
  stop()
}

# 7(a)
# Read the result in "treedist/"
dist=read.table('./treedist/chr1-all.tre.rfdist',sep = " ",skip = 1)
# Data cleaning
na_len=sum(is.na(dist[1,]))
len=length(dist[1,])
dist=dist[,c((na_len+2):len)]

# Get the distance vector of randomly chosen blocks
d=c()
for (i in 1:length(dist[1,])) {
  for (j in 1:length(dist[1,])) {
    if (i!=j){
      d=c(d,dist[i,j])}
    
  }
}


# Calculate S=n-3-D/2
s=n-3-d/2
# Generate a series of poison(1/8) random number, the same length as S
rp=rpois(length(s),1/8)
# Output image
png(filename="./images/7a.png", 500,500)
# Histogram of S
h=hist(s,freq = F,breaks = c(0:max(s+1)),col = rgb(0,0,1,0.5),ylim = c(0,1),
       main='Distance of Randomly Chosen Blocks and Poison Distribution')
# Poison(1/8) distribution
hist(rp,freq = F,add=T,breaks = c(0:max(s+1)),ylim = c(0,1),col=rgb(1,0,0,0.5))
# Add a vertical line indicating the mean of S
abline(v=mean(s),col = rgb(0,0,1,0.5),lty=2,lwd=3) 
# Add a vertical line indicating the mean of Poison(1/8)
abline(v=mean(rp),col=rgb(1,0,0,0.5),lty=2,lwd=3)
legend("topright", 
       legend = c("Randomly Chosen", "Poisson Distribution"), 
       fill = c(rgb(0,0,1,0.5),rgb(1,0,0,0.5)))
dev.off()

#------------------------------------------------------#
#7(b)
#result in 6(b)
dist2=t(read.table('./treedist/chr1-all.adj.tre.rfdist',sep = " ",skip = 1))
#remove na
dist2=dist2[!is.na(dist2)& dist2!=0]
d2=dist2
s2=n-3-d2/2

png(filename="./images/7b.png", 500,500)
h=hist(s,freq = F,breaks = c(0:max(max(s),max(s2))),col = rgb(0,0,1,0.5),ylim = c(0,0.4),main='Distance of Randomly Chosen Blocks and Consecutive Blocks')
h=hist(s2,freq = F,breaks = c(0:max(max(s),max(s2))),col=rgb(0,1,0,0.5),add=T)
#add vertical mean lines
abline(v=mean(s),col = rgb(0,0,1,0.5),lty=2,lwd=3)
abline(v=mean(s2),col=rgb(0,1,0,0.5),lty=2,lwd=3)

legend("topright", 
       legend = c("Randomly Chosen", "Consecutive"), 
       fill = c(rgb(0,0,1,0.5),rgb(0,1,0,0.5)))
dev.off()




