library(tidyverse)
#install.packages('ggthemes', dependencies = TRUE)
library(ggthemes)
library(viridis)
library(viridisLite)
library(hexbin)
# ggplot basics ####
ggplot(data = penguin) +
  geom_point(mapping = aes(x = displ, y = hwy))
# begin a plot with the function ggplot().
# this creates a coordinate system that you add layers to using +
# geom_point adds a layer of points on top of the blank graph ggplot(data = ...)
# each geom function takes a mapping function argument as well
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

ggplot(data = df, mapping = aes(x = x, y = y)) +
  geom_point(mapping = aes(color = id), position = "jitter") +
  labs(title = "Metabolite Levels Scores Plot", 
       x = "PC 1 (77.5%)", 
       y = "PC 2 (6.4%)", 
       color = "Legend") +
  scale_color_hue(labels = c("0d", "0d-Col-O", "0d-ExQC", "6d", "6d-Col-O", "6d-ExQC")) +
  theme_clean() +
  theme(axis.text.x = element_text(size = 14), 
        axis.title.x = element_text(size = 14),
        axis.text.y = element_text(size = 14), 
        axis.title.y = element_text(size = 14),
        plot.title = element_text(size = 20, face = "bold"))

# Labels ####
# the labs() function adds labels to a ggplot() function
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(title = "Fuel Efficiency decreases with engine size")
# can also use 'subtitle =' which creates a subtitle and 'caption ='
# which creates a small blurb of text in the bottom right
ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) +
  geom_point(mapping = aes(color = class)) +
  geom_smooth(se = FALSE) +
  labs(
    title = "Fuel Efficiency decreases with engine size",
    subtitle = "Two seaters (sports cars) are an exception because of their light weight",
    caption = "Data from fueleconomy.gov")
# et voila
# labs() can also create/replace x and y axis labels
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class)) +
  geom_smooth(se = FALSE) +
  labs(
    x = "Engine displacement (L)",
    y = "Highway fuel economy (mpg)",
    colour = "Car type"
  )
# can technically omit 'data =', 'mapping =' , and explicitly saying the x and y stuff like above
# i don't really like this and  I don't think I'll do it

# Annotations ####
# you can add specific labels to data with the geom_text() function.
# you need to filter the data tho
# here we label the best in class fuel economy car
best_in_class <- mpg %>%
  group_by(class) %>%
  filter(row_number(desc(hwy)) == 1)
# this was the filtering step now we do the plotting
ggplot(data = mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  geom_text(aes(label = model), data = best_in_class)
# issues with overlapping but you could fix this with nudge() or other textwrapping

# scales ####
# you can set custom scales besides the ones that ggplot automatically determines
# you do this by specifying them as limits with a character vector 
# limits = c(xmin,xmax) is the usual format
ggplot(mpg, aes(x = displ, y = hwy)) +
  geom_point(aes(color = class)) +
  scale_x_continuous(limits = c(0,12)) +
  scale_y_continuous() +
  scale_color_discrete()
# not a good idea in this case but something you can do nonetheless
# Axis ticks ####
# you can also change the tick marks on an axis, you can do this with seq()
# seq(xmin, xmax, by = n) will count from xmin to xmax in increments of n
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_y_continuous(breaks = seq(15, 40, by = 5))
# you can also get rid of labels by using the NULL option
ggplot(mpg, aes(displ, hwy)) +
  geom_point() +
  scale_x_continuous(labels = NULL) +
  scale_y_continuous(labels = NULL)
# legends and color schemes ####
# to change the position of the legend using ggplot() you must use a theme function
# inside theme() you put 'legend.position =' and where you'd like the legend to be
# legend.position = "right" is the default
base <- ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(colour = class))
base + theme(legend.position = "left")
base + theme(legend.position = "top")
base + theme(legend.position = "bottom")
base + theme(legend.position = "right")
# Replacing a scale ####
# you can also replace the scale of a plot with a transformed version
# in the case of the diamonds data a log transform is best
ggplot(diamonds, aes(carat, price)) +
  geom_bin2d() +
  scale_x_log10() +
  scale_y_log10()
# you can also change the color scale to a different one
ggplot(mpg, aes(displ,hwy)) +
  geom_point(aes(color = drv))
# and now we change it to "Set1"
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv)) +
  scale_color_brewer(palette = "Set1")
# can also use shapes if your plot will be in black and white
ggplot(mpg, aes(displ, hwy)) +
  geom_point(aes(color = drv, shape = drv)) +
  scale_colour_brewer(palette = "Set1")
# scale_color_manual allows you to input your own colors that you want
presidential %>%
  mutate(id = 33 + row_number()) %>%
  ggplot(aes(start, id, colour = party)) +
  geom_point() +
  geom_segment(aes(xend = end, yend = id)) +
  scale_colour_manual(values = c(Republican = "red", Democratic = "blue"))
# here we have colored democratic presidents blue and republicans red
# viridis is one of the most popular color palettes to use
#install.packages('viridis')
#install.packages('hexbin')
# we'll make a fake dataset to plot here
dfake <-df <- tibble(
  x = rnorm(10000),
  y = rnorm(10000))
# geom_hex makes hex cells, counts them, and maps them
ggplot(dfake, aes(x,y)) +
  geom_hex() +
  coord_fixed()

ggplot(dfake, aes(x,y)) +
  geom_hex() +
  viridis::scale_fill_viridis() +
  coord_fixed()

# Themes ####
# ggplot has 8 themes to start out with but there's a plethora available online
# you can also create your own theme by setting the arguments of theme() yourself
theme (panel.border = element_blank(),
       panel.grid.minor.x = element_blank(),
       panel.grid.minor.y = element_blank(),
       legend.position="right",
       legend.title=element_blank(),
       legend.text=element_text(size=10),
       panel.grid.major = element_blank(),
       legend.key = element_blank(),
       legend.background = element_blank(),
       axis.text.y=element_text(colour="black"),
       axis.text.x=element_text(colour="black"),
       text=element_text(family="Georgia")) 
# Saving and exporting ####
# you can use the ggsave() function to save a plot you made.
# the format is ggsave("file-name.pdf")
ggsave("hex-plot-inclass.pdf")
