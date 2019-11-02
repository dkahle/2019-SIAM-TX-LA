data {
  real<lower=0> si;
}
      
parameters {
  real x;
  real y;
  real z;
} 
      
transformed parameters {
  real g = x^4+2*x^2*y^2+2*x^2*z^2-10*x^2+y^4+2*y^2*z^2-10*y^2+z^4+6*z^2+9;
  real ndg = sqrt(16*x^6+48*x^4*y^2+48*x^4*z^2-160*x^4+48*x^2*y^4+96*x^2*y^2*z^2-320*x^2*y^2+48*x^2*z^4-64*x^2*z^2+400*x^2+16*y^6+48*y^4*z^2-160*y^4+48*y^2*z^4-64*y^2*z^2+400*y^2+16*z^6+96*z^4+144*z^2);
} 
      
model {
  target += normal_lpdf(0.00 | g, ndg*si);
}
