# Bathymetric representation of Costa Rica through the Rayshader package.
# Elevation model used: ALOS World 3D - 30m (AW3D30) (downloaded from Google Earth Engine)
# Author: Jorge Daniel García Girón
# Source: https://www.rayshader.com/#mapping-with-rayshader

# Packages
library(rayshader)
require(cptcity)
require(raster)
library(rgl)
library(magick)

# Input DEM
cr_dem <- raster("C:/Users/jorge/Downloads/cr.tif")

# DEM to matrix conversion
cr = raster_to_matrix(cr_dem)

# Derive ambient occlusion shadow grid
cr_amb_shade <- ambient_shade(cr, zscale = 75)

# Shading grid is derived from a ray trace
cr_ray_shade <- ray_shade(cr, sunangle = 35, zscale = 75, )

# 3D visualization of the elevation model with hillshading
cr %>% 
  height_shade(texture = cpt(pal = "vh_Caribbean")) %>%
  add_shadow(cr_amb_shade, 0) %>% 
  add_shadow(cr_ray_shade, 0.5) %>%
  plot_3d(heightmap = cr, 
          zscale = 75, 
          fov = 90,
          lineantialias = TRUE,
          theta = 0,
          phi = 30,
          zoom = 0.6,
          water = TRUE,  
          watercolor = "turquoise4", 
          waterlinecolor = "white", 
          waterlinealpha = 0.5,
          windowsize = c(200, 200, 1000, 800))
render_snapshot()

# 3D visualization animation
play3d(spin3d(axis = c(0, 1, 0), rpm = 20), duration = 5)

# Export animation in GIF format
movie3d(
  movie="cr", 
  spin3d(axis = c(0, 1, 0), rpm = 10),
  duration = 6, 
  dir = "~/",
  type = "gif", 
  clean = TRUE
)

# End Code