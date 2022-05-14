
  //definizione dei dati per le funzioni
  data {
  int<lower=0> N;
  vector[N] y;
  vector[N] x;
  real mu_alpha;
  real sigma_alpha;
  real mu_beta;
  real sigma_beta;
  real LOCATION;
  real SCALE;
}
//Standardizzazione dei dati
transformed data {
  vector[N] x_std;
  vector[N] y_std;
  x_std = (x - mean(x)) / sd(x);
  y_std = (y - mean(y)) / sd(y);
}
//Parametri del modello utilizzati per il campionamento 
parameters {
  real alpha_std;
  real beta_std;
  real<lower=0> sigma_std;
}
//Modello con cui sono distribuiti i dati 
model {
  alpha_std ~ normal(mu_alpha, sigma_alpha); 
  beta_std ~ normal(mu_beta, sigma_beta);
  sigma_std ~ cauchy(LOCATION, SCALE);
  y_std ~ normal(alpha_std + beta_std * x_std, sigma_std);
}
// Calcolo valori d’interesse
generated quantities {
  real alpha;
  real beta;
  real<lower=0> sigma;
  real cohen_d;
  alpha = sd(y) * (alpha_std - beta_std * mean(x) / sd(x)) + mean(y);
  beta = beta_std * sd(y) / sd(x);
  sigma = sd(y) * sigma_std;
  cohen_d = beta / sigma; 
}

