library(tidyverse)

library(palmerpenguins)
# palmerpenguins package, which includes the penguins dataset containing body measurements for penguins on three islands in the Palmer Archipelago, and the ggthemes package, which offers a colorblind safe color palette.

#Do penguins with longer flippers weigh more or less than penguins with shorter flippers?

penguins
# In the tidyverse, we use special data frames called tibbles that you will learn more about soon.

glimpse(penguins)

#Among the variables in penguins are:
# species: a penguin’s species (Adelie, Chinstrap, or Gentoo).
# flipper_length_mm: length of a penguin’s flipper, in millimeters.
# body_mass_g: body mass of a penguin, in grams.



# To learn more about penguins, open its help page by running ?penguins.
?penguins

# 1.2.2 Ultimate goal
# Ultimate goal
# Our ultimate goal in this chapter is to recreate the following visualization displaying the relationship between flipper lengths and body masses of these penguins, taking into consideration the species of the penguin.


# 1.2.3 Creating a ggplot
ggplot(data = penguins)
# ggplot(data = penguins) creates an empty graph that is primed to display the penguins data, but since we haven’t told it how to visualize it yet, for now it’s empty.


# Next, we need to tell ggplot() how the information from our data will be visually represented. The mapping argument of the ggplot() function defines how variables in your dataset are mapped to visual properties (aesthetics) of your plot. The mapping argument is always defined in the aes() function, and the x and y arguments of aes() specify which variables to map to the x and y axes. For now, we will only map flipper length to the x aesthetic and body mass to the y aesthetic. ggplot2 looks for the mapped variables in the data argument, in this case, penguins.

ggplot(
  data = penguins,
  mapping = aes(x = flipper_length_mm, y=body_mass_g)
)






