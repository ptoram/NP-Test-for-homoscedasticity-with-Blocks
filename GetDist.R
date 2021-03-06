#####################################################################################
#
#     RANDOM VARIATE GENERATOR
#
#     Author: Dr. VÃ­ctor G. Tercero GÃ³mez
#     Affiliation: Tecnologico de Monterrey
#
#     Date: April 17, 2018
#     VersiÃ³n: 2.1
#
#     DESCRIPTION
#
#     Random variates from several distributions are generated with user defined mean and variance.
#
#     getDist(n, dist, mu, stdev, par.location = 0, par.scale = 1, par.shape = 1)
#
#     n: is a scalar. Indicates how many random variates to be generated
#     dist: is a vector of characters. Choose one type:
#         "Normal": Normal distribution.
#         "Normal2": Normal-squared distribution from a N(0,1). Basically a Chi^2 with df = 1.
#         "DoubleExp": Double exponential distribution (also known as Laplace distribution).
#         "DoubleExp2": Double exponential squared distribution from a DoubleExp(0,1).
#         "LogNormal": Lognormal distribution.
#         "Gamma": Gamma distribution
#         "Weibull": Weibull distribution
#     mu: user defined expected value.
#     stdev: user defined standard deviation.
#     par.location: scalar, location parameter, by defaoult is 0**.
#     par.scale: scalar, scale parameter, by defaoult is 1**.
#     par.shape: scalar, shape parameter, by defaoult is 1.
#
#     **Note on par.location and par.scale:
#           par.location and par.scale are the location and scale parameters
#           of the distribution that generates the desired distribution. For lognormal,
#           par.location and par.scale correspond to the location and scale parameters of the normal
#           distribution that generales the lognormal. Hence, in this case they are the logmean and
#           the logsigma parameters. For Normal2 and DoubleExp2, par.location and par.scale correspond
#           correspond to the location and scale parameters of the normal and double exponential
#           that are used to generates their squared forms.


getDist <- function(n, dist, mu, stdev, par.location = 0, par.scale = 1, par.shape = 1){
  if(dist == "Normal"){
    a = par.location
    b = par.scale
    EX = a
    VarX = b^2
    z = (rnorm(n, mean = a, sd = b) - EX)/ VarX^(0.5)
    x = mu + stdev*z
  }
  if(dist == "Normal2"){
    a = par.location
    b = par.scale
    EX = a^2 + b^2
    VarX = 4*a^2*b^2 + 2*b^4
    z = ( (rnorm(n, mean = a, sd = b))^2 - EX) / VarX^(0.5)
    x = mu + stdev*z
  }
  if(dist == "DoubleExp"){
    a = par.location
    b = par.scale
    EX = a
    VarX = 2*b^2
    #xtemp = a - b * sign(U - 0.5) * log(1 - 2 * abs(U - 0.5)) #This one appeared in Wikipedia
    xtemp = log(runif(n)/runif(n))/2^(0.5) #this is the recommended method. Gives standard DE variates.
    
    z = (xtemp  - EX) / VarX^(0.5)
    x = mu + stdev*z
  }
  if(dist == "DoubleExp2"){
    a = par.location
    b = par.scale
    EX = 2*b^2 + a^2
    EY3 = 6*b^3 + 6*a*b^2 + 5*a^3 #Y is Laplace
    EY4 = 24*b^4 + 4*a*EY3 - 6*a^2*(2*b^2 + a^2) + 5*a^4 #Y is Laplace
    VarX = EY4 - EX^2
    xtemp = (log(runif(n)/runif(n)))^2
    z = (xtemp  - EX) / VarX^(0.5)
    x = mu + stdev*z
  }
  if(dist == "LogNormal"){
    a = par.location #logmean
    b = par.scale #logsigma
    EX = exp(a + b^2/2)
    VarX = exp(2*(a + b^2)) - exp(2*a + b^2)
    xtemp = rlnorm(n, meanlog = a, sdlog = b)
    z = (xtemp  - EX) / VarX^(0.5)
    x = mu + stdev*z
  }
  if(dist == "Gamma"){
    k = par.scale
    o = par.shape
    EX = k*o
    VarX = k*o^2
    xtemp = rgamma(n, shape = o, scale = k)
    z = (xtemp  - EX) / VarX^(0.5)
    x = mu + stdev*z
  }
  if(dist == "Weibull"){
    k = par.shape
    l = par.scale
    EX = l * gamma(1 + 1/k)
    VarX = l^2 * (gamma(1+2/k) - (gamma(1+1/k))^2)
    xtemp = rweibull(n, shape = k, scale = l)
    z = (xtemp  - EX) / VarX^(0.5)
    x = mu + stdev*z
  }
  return(x)
}
