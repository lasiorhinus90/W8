#For this assignment I have created a function to help me importing,cropping and masking
#my raster layers. 



###Reading raster layers

library(raster)
library(dplyr)
library(sf)

# First when I read the annual_mean_temperature_layer and plot it. We can see that there are 2 regions. These regions are te Nullarbor Plains and the Eyre Peninsula. 

annual_mean_temperature_layer<- raster("layers/Annual_Mean_Temperature_mask.tif",package="raster")#example of raster layer
 plot(annual_mean_temperature_layer)

 
# Then I load a mask of the Nullarbor area because my purpose is to have only environmental varaibles of this region.
#In order to achieve this  I would need to crop the area with a mask shapefile of the Nullabor Plains, so that is why I read the mask of Nullarbor
 
 
mask_nullarbor<-st_read("Nullarbor_shp/Nullarbor.shp") #this is one of the masks I use to crop and mask the rasters
plot(mask_nullarbor)


### For the cropping I just use the crop function in the raster package, after that we can see that we only have the area that we want to keep

annual_mean_temperature_crop<- crop(annual_mean_temperature_layer,extent(mask_nullarbor))

plot(annual_mean_temperature_crop)

# Finally we need to mask the layer to create a new Raster* object that has the same values as x, except for the cells that are NA. I have done this to have the same NA values across the raster layers
annual_mean_temperature_mask<-mask(annual_mean_temperature_crop,mask_nullarbor)
plot(annual_mean_temperature_mask)

## The "problem" is that I need to repeat this proccess with each one of the environmental variables(located in the layer folder) so I was aiming to save some time and fin a fnction that coud make the it faster.
# In addition, after all the environmental variables are cropped and mask I need to stack them in a raster stack so I can add them to my model.
# There is a raster function called stack that allows this and you can put all your environmental years to create a RasterStack object. It works this way:

stack<-stack( annual_mean_temperature_mask, rainfall_mask)# code only works after testing the function and  having the rainfall_mask as well

plot(stack)

#So, I was wondering if it is possible to design a function that would crop and mask each of the environmental raster layers (from a list maybe?) and then stack them.
# The function would do this:

#1.read first layer in the folder
#2.crop first layer in the folder
#3. mask first layer in the folder
#4.read second layer in the folder
#5.crop second layer in the folder
#6.mask second layer in the folder
#7. Final step: stack all the layers

###Reorganizing code

annual_mean_temperature<- raster("layers/Annual_mean_temperature_mask.tif",package="raster")%>%
  crop(extent(mask_nullarbor))%>%
  mask(mask_nullarbor)

###Creating a function

masking_environmental_layers<-function(raster,mask){
  raster(raster,package="raster")%>%
    crop(extent(mask))%>%
    mask(mask)
}
 ## add %>%stack(all_masks)???

### Function testing (without stacking)

rainfall_mask<-masking_environmental_layers("layers/Annual_Mean_rainfall_mask.tif", mask_nullarbor)
plot(rainfall)
