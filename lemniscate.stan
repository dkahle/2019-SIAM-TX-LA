data {
  real<lower=0> si;
}
      
parameters {
  real x;
  real y;
} 
      
transformed parameters {
  real g = x^4+2*x^2*y^2-2*x^2+y^4+2*y^2;
  real ndg = sqrt(16*x^6+48*x^4*y^2-32*x^4+48*x^2*y^4+16*x^2+16*y^6+32*y^4+16*y^2);
} 
      
model {
  target += normal_lpdf(0.00 | g, ndg*si);
}
