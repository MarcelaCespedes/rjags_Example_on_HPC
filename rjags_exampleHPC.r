###############################################
# rjags example to run on HPC
# 13.5.2016
# same Bayesian model as BUG_exampleHPC.R

# code (to run simple BUG example) taken from
# http://rstudio-pubs-static.s3.amazonaws.com/1935_652d6fb17d7941c4b91bbbc5a22d4494.html


library(rjags)
library(ggplot2)
library(coda)
library(reshape2)

# generate data
linedata <- list(Y = c(1, 3, 3, 3, 5), x = c(1, 2, 3, 4, 5), N = 5, xbar = 3)
lineinits <- function() {
  list(alpha = 1, beta = 1, tau = 1)
}

# run model
lineout <- jags.model('rjags_exampleHPC.txt', data = linedata, n.chains = 2, n.adapt = 100)
n.iter <- 10000; burn.in<- n.iter/2  # no thinning and same burnin as BUG_exampleHPC.R

update(lineout, n.iter)  # standard to run this for 200K

lout<- coda.samples(lineout,  c("alpha", "beta", "sigma"), n.iter = n.iter, start = burn.in, thin = 1)

#summary(lout)

# want to save the summary of the output (parameter estimates, etc)
# into a text file
#out<- capture.output(summary(lout))
#cat(out, file= "modelSummary.txt", sep="\n", append=TRUE)

#cat(as.character("Effective sample size"), file = "modelSummary.txt", sep = "\n", append = TRUE)

#out2.b<- capture.output(effectiveSize(lout))
#cat(out2, file = "modelSummary.txt", sep = "\n", append = TRUE)

mcmc<-lout
for (j in 1:2) { 
  mcmc[[j]] <- as.data.frame(mcmc[[j]])
  n <- dim(mcmc[[j]])[1]
  mcmc[[j]][,"id"] <- 1:n
  mcmc[[j]][,"chain"] <- rep(j,n)
}

mcmcs <- rbind(mcmc[[1]], mcmc[[2]])
save(mcmcs, file = "mcmcs.Rdata")

chains<- melt(mcmcs, id.vars=c(4,5))  
no.param<- 3

dim(chains)
chains$chain <- factor(chains$chain)
this <- 1:dim(chains)[1]

#                       #### diagnostics ######
# TRACE PLOTS
trace.p<- ggplot(aes(x=id, y=value, colour=chain), data=chains[this,]) +      
  geom_line() +                   
  facet_wrap(~variable, ncol=2, scales = "free") +
  theme(legend.position="top") +  
  labs(x="MCMC iteration", y="Simulation from parameter's marginal posterior")
ggsave(file = "TracePlot.pdf", plot = trace.p)
dev.off()

# AUTOCORRELATION, for each parameter estimate
pdf("autocorrelation.pdf")
par(mfrow=c(2,2))
for (v in 1:no.param) { 
  acf.df <- acf(mcmcs[,v], plot=F) # $acf[,,1] 
  plot(acf.df, ask=T, xlab=dimnames(mcmcs)[[2]][v], main="", ylim=range(0,1))
}
dev.off()

# DENSITY
density.p<- ggplot(aes(x=value, colour=chain), # separate box for each chain
                   data=chains) +                 # data must be in long format
  geom_density() +               # use density geometry
  facet_wrap(~variable, ncol=2,  # do a separate boxplot for each variable
             scales = "free")
ggsave(filename="densityPlot.pdf", plot = density.p)
dev.off()

# this is how we save a plot in qq-environment
#getwd()
#ggsave(filename=  "E:/PINKMEMSTIK/SpatioTemporal_attemp3/plot1.pdf", plot = p1)
