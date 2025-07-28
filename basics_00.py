# Tutorial: Introduction to Python for Scientific Analysis
# =====
#
# This exercise introduces some core Python programming concepts:
# - Importing useful libraries
# - Performing basic mathematical operations
# - Writing for-loops
# - Creating a simple map using Cartopy
#
# By the end of this activity, you should be comfortable with basic syntax and plotting capabilities for spatial data.

# + [markdown]
# ### 1. Importing Python Libraries
#
# Python uses **libraries** (also called *packages*) to extend its capabilities. Rather than writing every function from scratch, we import code written by others.
#
# In this example:
# - `numpy` is used for maths (like cosine or exponents)
# - `matplotlib.pyplot` is used for plotting graphs
# - `cartopy.crs` is used to create geospatial map projections
#
# These are imported using the `import` keyword.
# -

# + tags=["empty-cell"]
# Import the required libraries
# import numpy as np
# import matplotlib.pyplot as plt
# import cartopy.crs as ccrs
# -

# + tags=["solution"]
import numpy as np
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
# -

# + [markdown]
# ### 2. Basic Mathematical Operations
#
# Python can perform mathematical operations like addition, multiplication, and exponents. You can assign values to variables using `=`, then reuse them in expressions.
#
# Let's define a variable `x`, and compute a simple linear equation `y = 2x + 1`.
# -

# + tags=["empty-cell"]
# Define x
# Compute y using a linear expression
# Print the result
# -

# + tags=["solution"]
x = 1
y = 2 * x + 1
print("y =", y)
# -

# + [markdown]
# You can continue calculations using existing variables. Python follows the usual order of operations (e.g., `**` for exponents, `/` for division).
# -

# + tags=["empty-cell"]
# Modify y by adding x squared and dividing by 10
# Print the result
# -

# + tags=["solution"]
y = y + x**2
y = y / 10
print("y =", y)
# -

# + [markdown]
# ### 3. Formatted Output
#
# Python allows you to format numbers when printing them. For example, `%7.2f` formats a number as:
# - 7 characters wide
# - 2 digits after the decimal point
#
# This is useful when printing aligned tables or controlling decimal precision in scientific output.
# -

# + tags=["empty-cell"]
# Format y with 2 decimal places using % formatting
# -

# + tags=["solution"]
print("y = %7.2f" % y)
# -

# + [markdown]
# ### 4. For Loops
#
# A `for` loop repeats a block of code multiple times. The syntax is:
#
# ```python
# for i in range(n):
#     # do something
# ```
#
# `range(5)` generates numbers from 0 to 4. In each loop, you can perform calculations, print results, or update counters.
# -

# + tags=["empty-cell"]
# Write a for-loop that:
# - Iterates 5 times
# - Prints i and cos(pi + i * 10)
# - Increments a counter
# After the loop, print the final counter value
# -

# + tags=["solution"]
counter = 0
for i in range(5):
    print("i =", i, "cos(pi + i*10) =", np.cos(np.pi + i * 10.))
    counter += 1
print("End of for loop. Counter =", counter)
# -

# + [markdown]
# ### 5. Map Plotting with Cartopy
#
# Cartopy is a mapping library that allows you to create geographic visualisations. It supports many **map projections** — ways to represent the Earth's curved surface on a 2D plot.
#
# A simple starting point is `PlateCarree`, which uses latitude and longitude directly. Below, we create a map and plot coastlines.
# -

# + tags=["empty-cell"]
# Create a basic map using Cartopy:
# - Use PlateCarree projection
# - Add coastlines
# - Set a title
# -

# + tags=["solution"]
plt.figure(figsize=(10, 5))
ax = plt.axes(projection=ccrs.PlateCarree())
ax.coastlines()
ax.set_title('Simple World Map with Cartopy')
plt.show()
# -

# + [markdown]
# ### Summary
#
# This notebook introduced:
# - Importing external libraries for maths and plotting
# - Variable assignment and mathematical expressions
# - Output formatting using `%` styles
# - `for` loops for iteration
# - Creating a simple map using `cartopy`
#
# These concepts are foundational for data analysis and spatial visualisation in Python. In future tutorials, we'll build on them to handle data files, automate workflows, and create more advanced maps.