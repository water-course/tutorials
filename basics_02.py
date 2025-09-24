# Exercise: Latitude-Longitude Area Corrections
# =====
#
# It is common that geospatial data is stored in grid format with longitude and latitudes. When dealing with longitude and latitude data, it is so easy to forget that different datapoints represent different areas at the surface of the Earth.
# **This is critical for satellite data analysis!**
#
# By the end of this activity, you should be comfortable with:
# - Understanding why grid cell areas vary with latitude
# - Calculating exact grid cell areas using spherical geometry
# - Applying area corrections to real satellite data (CSR GRACE)
#
# A bit of math
# =====
# The surface area of a grid cell on a sphere, bounded by latitudes
# $\phi_1, \phi_2$ and longitudes $\lambda_1, \lambda_2$, can be derived
# from the spherical surface element.
#
# On a sphere of radius $R$, the infinitesimal surface area is:
#
# $$ dA = R^2 \cos\phi \, d\phi \, d\lambda $$
#
# Now let's do integration over latitude and longitude. Integrating over latitude we have:
#
# $$ \int_{\phi_1}^{\phi_2} \cos\phi \, d\phi = \sin\phi_2 - \sin\phi_1 $$
#
# Integrating over longitude we get:
#
# $$ \int_{\lambda_1}^{\lambda_2} d\lambda = \Delta\lambda $$
#
# Therefore, the area of the grid cell is:
#
# $$ A = R^2 \, \big| \sin\phi_2 - \sin\phi_1 \big| \, \big| \Delta\lambda \big| $$
#
# where all angles are in radians.
#
# Small-Cell Approximation
# =========================
#
# For very small cells, the area can be approximated by:
#
# $$ A \approx R^2 \, \Delta\phi \, \Delta\lambda \, \cos\bar{\phi} $$
#
# with $\Delta\phi = \phi_2 - \phi_1$, $\Delta\lambda = \lambda_2 - \lambda_1$,
# and $\bar{\phi} = \tfrac{1}{2}(\phi_1 + \phi_2)$ is the mean latitude of the cell.
#
# **Key insight:** The exact formula accounts for the curvature of Earth, while the approximation
# works well for small grid cells where $\cos\bar{\phi}$ doesn't change much across the cell.
#
# Let's begin by loading the CSR GRACE solution file and calculating grid cell areas.

# + tags=["empty-cell"]
# Import the required libraries
# import xarray as xr
# from pathlib import Path
# import numpy as np
# import matplotlib.pyplot as plt
# -

# + tags=["solution"]
import xarray as xr
import numpy as np

# Load the CSR GRACE dataset
filename = "./CSR_GRACE_GRACE-FO_RL0603_Mascons_all-corrections.nc"
ds = xr.open_dataset(filename)
print("Dataset overview:")
print(ds)
# -

# + [markdown]
# ## Calculate Grid Cell Areas Using Exact Formula
#
# Now we'll extract the coordinate arrays and calculate the area of each grid cell using the exact spherical formula.
# The CSR GRACE data has a grid spacing of approximately 0.25 × 0.25.
# -
# + tags=["empty-cell"]
# Extract coordinates and calculate grid cell areas using exact formula
# lons =
# lats =
# lons_x, lats_x =
#
# # Earth's radius in meters
# Rearth =
#
# # Calculate areas using exact formula: A = R^2 |sin(\phi_2) - sin(\phi_1)| |\Delta \lambda|
# areas =
# -

# + tags=["solution"]
lons = ds["lon"].values
lats = ds["lat"].values
lons_x, lats_x = np.meshgrid(lons, lats)

Rearth = 6370e3  # Radius of the Earth in meters
areas = Rearth ** 2 * abs(np.sin(np.radians(lats_x[1:, :])) - np.sin(np.radians(lats_x[:-1, :]))) * np.radians(0.25)

area_min = areas.min()
area_max = areas.max()
print(
    "Grid cell areas range from "
    f"{area_min:,.0f} m^2 ({area_min / 1e6:.2f} km^2) "
    "to "
    f"{area_max:,.0f} m^2 ({area_max / 1e6:.2f} km^2)"
)

# -
