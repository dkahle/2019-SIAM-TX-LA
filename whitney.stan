data {
  real<lower=0> si;
}
      
parameters {
  real<lower=-5,upper=5> x;
  real<lower=-5,upper=5> y;
  real<lower=-5,upper=5> z;
} 
      
transformed parameters {
  real g = x^2-y^2*z;
  real ndg = sqrt(4*x^2+4*y^2*z^2+y^4);
} 
      
model {
  target += normal_lpdf(0.00 | g/ndg, si);
}
