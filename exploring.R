

# load libraries ------------------------------------------------------------

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

ggplot(samps, aes(x, y)) + geom_hex() + coord_equal()











# manual example ----------------------------------------------------------

p <- mp("(x^2 + y^2)^2 - 2 (x^2 - y^2)")

rvnorm(2000, p, sd = .1, code_only = TRUE)
# saved in lemniscate.stan

lemniscate_model <- rstan::stan_model("lemniscate.stan")

cores <- parallel::detectCores()
chains <- cores
warmup <- 500
n <- 2000




samples <- rstan::sampling(
  "object" = lemniscate_model,
  "data" = list("si" = .1),
  "chains" = chains, "iter" = n + warmup, "warmup" = warmup, "cores" = cores,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L)
)

str(samples, 2)

# samples as a data frame (matrix)
df <- as.data.frame(samples)
str(df)
head(df)

# graphics
ggplot(df, aes(x, y)) + geom_point() + coord_equal()
ggplot(as.data.frame(samples), aes(x, y)) + geom_hex() + coord_equal()



# smaller sigma
samples <- rstan::sampling(
  "object" = lemniscate_model,
  "data" = list("si" = .01),
  "chains" = chains, "iter" = n + warmup, "warmup" = warmup, "cores" = cores,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L)
)

# graphics
ggplot(as.data.frame(samples), aes(x, y)) + geom_point() + coord_equal()
ggplot(as.data.frame(samples), aes(x, y)) + geom_hex() + coord_equal()
ggplot(as.data.frame(samples), aes(x, y)) + geom_bin2d(bins = 100) + coord_equal()

ggplot(as.data.frame(samples), aes(x, y)) + 
  stat_density2d(
    aes(fill = stat(density)), h = c(.2, .2),
    contour = FALSE, geom = "raster", n = 251
  ) +
  coord_equal() +
  xlim(-2, 2) + ylim(-1, 1)

ggplot(as.data.frame(samples), aes(x, y)) + 
  stat_density2d(
    aes(fill = stat(density)), h = c(.2, .2),
    contour = FALSE, geom = "raster", n = 251
  ) +
  geom_point(color = "white", alpha = .2, size = .15) +
  coord_equal() +
  xlim(-2, 2) + ylim(-1, 1)






# torus -------------------------------------------------------------------

p <- mp("(x^2 + y^2 + z^2 + 2^2 - 1^2)^2 - 4 2^2 (x^2 + y^2)")

rvnorm(2000, p, sd = .1, code_only = TRUE)
# saved in torus.stan

torus_model <- rstan::stan_model("torus.stan")

samples <- rstan::sampling(
  "object" = torus_model,
  "data" = list("si" = .1),
  "chains" = chains, "iter" = n + warmup, "warmup" = warmup, "cores" = cores,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L)
)

library("plotly")

plot_ly(
  as.data.frame(samples), 
  x = ~x, y = ~y, z = ~z, 
  type = "scatter3d", mode = "markers",
  marker = list(size = 1, color = "black")
)





# smaller sigma
samples <- rstan::sampling(
  "object" = torus_model,
  "data" = list("si" = .01),
  "chains" = chains, "iter" = n + warmup, "warmup" = warmup, "cores" = cores,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L)
)

plot_ly(
  as.data.frame(samples), 
  x = ~x, y = ~y, z = ~z, 
  type = "scatter3d", mode = "markers",
  marker = list(size = 1, color = "black")
)








# whitney umbrella --------------------------------------------------------

p <- mp("x^2 - y^2 z")

rvnorm(2000, p, sd = .1, w = 5, code_only = TRUE)
# saved in whitney.stan

whitney_model <- rstan::stan_model("whitney.stan")

samples <- rstan::sampling(
  "object" = whitney_model,
  "data" = list("si" = .05),
  "chains" = chains, "iter" = n + warmup, "warmup" = warmup, "cores" = cores,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L)
)

plot_ly(
  as.data.frame(samples), 
  x = ~x, y = ~y, z = ~z, 
  type = "scatter3d", mode = "markers",
  marker = list(size = 1, color = "black")
)





# multi -------------------------------------------------------------------

p <- mp(c("x^2 + y^2 + z^2 - 1", "z"))

rvnorm(2000, p, sd = .1, code_only = TRUE)

multi_model <- rstan::stan_model("multi.stan")

samples <- rstan::sampling(
  "object" = multi_model,
  "data" = list("si" = .05),
  "chains" = chains, "iter" = n + warmup, "warmup" = warmup, "cores" = cores,
  "control" = list("adapt_delta" = .999, "max_treedepth" = 20L)
)

ggplot(as.data.frame(samples), aes(x, z)) +
  geom_point()

plot_ly(
  as.data.frame(samples), 
  x = ~x, y = ~y, z = ~z, 
  type = "scatter3d", mode = "markers",
  marker = list(size = 1, color = "black")
)





