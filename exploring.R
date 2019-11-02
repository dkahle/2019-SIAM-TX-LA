

# load libraries ------------------------------------------------------------

library("parallel"); options(mc.cores = detectCores())
library("rstan"); rstan_options(auto_write = TRUE)
library("algstat")


?rvnorm # see examples on bottom of this




# circle example ----------------------------------------------------------

p <- mp("x^2 + y^2 - 1")
samps <- rvnorm(2000, p, sd = .1)
head(samps)
plot(samps, asp = 1)





# circle example with tidyverse -------------------------------------------

library("tidyverse"); theme_set(theme_minimal())

(samps <- rvnorm(2000, p, sd = .1, output = "tibble"))

ggplot(samps, aes(x, y)) + geom_point(size = .5) + coord_equal()

ggplot(samps, aes(x, y, color = g)) +
  geom_point(size = .5) +
  scale_color_gradient2() +
  coord_equal()



# manual example ----------------------------------------------------------

p <- mp("(x^2 + y^2)^2 - 2 (x^2 - y^2)")

rvnorm(2000, p, sd = .1, code_only = TRUE)
# saved in lemniscate.stan

compiled_model <- rstan::stan_model("lemniscate.stan")

cores <- parallel::detectCores()
chains <- cores * 2
warmup <- 500
n <- 2000




samples <- rstan::sampling(
  "object" = compiled_model,
  "data" = list("si" = .1),
  "chains" = 8L,
  "iter" = n + warmup,
  "warmup" = warmup,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L),
  "cores" = cores
)

str(samples, 2)

# samples as a data frame (matrix)
df <- as.data.frame(samples)
str(df)
head(df)

# graphics
ggplot(df, aes(x, y)) + geom_point()




samples <- rstan::sampling(
  "object" = compiled_model,
  "data" = list("si" = .02),
  "chains" = 8L,
  "iter" = n + warmup,
  "warmup" = warmup,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L),
  "cores" = cores
)

# graphics
ggplot(as.data.frame(samples), aes(x, y)) + geom_point() + coord_equal()
ggplot(as.data.frame(samples), aes(x, y)) + geom_hex() + coord_equal()











