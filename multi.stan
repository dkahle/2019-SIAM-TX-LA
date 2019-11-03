data {
  real<lower=0> si;
}
      
parameters {
  real x;
  real y;
  real z;
} 
        
transformed parameters {
  vector[2] g = [x^2+y^2+z^2-1, z]';
  matrix[2,3] J = [
      [2*x, 2*y, 2*z], 
      [0, 0, 1]
    ];
} 
        
model {
  target += normal_lpdf(0.00 | J' * ((J*J') \ g), si);
}
