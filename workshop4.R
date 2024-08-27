library(tidyverse)


ggplot(data = penguin) +
  geom_point(mapping = aes(x = displ, y = hwy))
# begin a plot with the funciton ggplot().
# this creates a coordinate system that you add layers to using +
# geom_point adds a layer of points on top of the blank graph ggplot(data = ...)
# each geom funciton takes a mapping funciton argument as well
# this defines how the data is mapped to visual properties.
# the mapping argument is always paired with aes().
# aes takes x and y arguments that tell which variables to map to the x and y axes.
# ggplot will look for the mapped variables in the data provided by data = ...

# the basic format of a ggplot() call is
# ggplot(data = <DATA>) + <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))
ggplot()
# a blank coordinate system
ggplot(data = penguin)
# a blank coordinate system now attached to the mpg dataset
?facet_wrap
ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy))

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth(data = filter(mpg, class == "subcompact"), se = FALSE)

# remaking a plot ####
# plot caption
# this plot shows the components of metabolites in Arabidopsis accessions for two different amounts of darkness exposure.
#Issues:
# Overlapping dots make the data a little hard to understand
# Differing levels of transparency make the plot look cluttered
# Dots of different groups overlap further confusing the visual representation

# data loading
df0d <- read.csv("0d.csv", header = FALSE)
df0d_col <- read.csv("0d-Col-O.csv", header = FALSE)
df0d_Ex <- read.csv("0d-ExQC.csv", header = FALSE)
df6d <- read.csv("6d.csv", header = FALSE)
df6d_Col <- read.csv("6d-Col-O.csv", header = FALSE)
df6d_Ex <- read.csv("6d-ExQC.csv", header = FALSE)
# data managing
df <- bind_rows(df0d, df0d_col, df0d_Ex, df6d, df6d_Col, df6d_Ex, .id = "id")
names(df)[2] <- "x"
names(df)[3] <- "y"
# great looks alright now time for new plotting
install.packages('ggthemes', dependencies = TRUE)
library(ggthemes)

ggplot(data = df, mapping = aes(x = x, y = y)) +
  geom_point(mapping = aes(color = id), position = "jitter") +
  labs(title = "Metabolite Levels Scores Plot", x = "PC 1 (77.5%)", y = "PC 2 (6.4%)", color = "Legend") +
  scale_color_hue(labels = c("0d", "0d-Col-O", "0d-ExQC", "6d", "6d-Col-O", "6d-ExQC")) +
  theme_clean() +
  theme(axis.text.x = element_text(size = 14), axis.title.x = element_text(size = 14),
        axis.text.y = element_text(size = 14), axis.title.y = element_text(size = 14),
        plot.title = element_text(size = 20, face = "bold"))
