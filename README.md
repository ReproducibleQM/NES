# National Eutrophication Survey

This respository contains a digitally transcribed copy of the National Eutrophication Survey (NES) dataset. The original data can be found in the `archival_pdfs` folder or by searching: https://www.epa.gov/nscep

## Locations

![](06_images/points.jpeg)

## Data

| variable name | description              |units|
|---------------|--------------------------|-----|
|pdf|pdf identifier (474 - 477)| integer|
|pagenum | page number of the pdf|integer|
|storet_code     | identifier which links measurement to coordinate locations|character|
|state                | state where the water body resides |character|
|name               | name of the water body|character|
|county              | county where the water body resides |character|
|lake_type         | natural or impoundment |character|
|drainage_area | the total drainage area | square kilometers |
|surface_area   | the area of the water surface|sq km|
|mean_depth    | the volume of the water body divided by the surface area in square meters| cubic meters|
|total_inflow      | the mean of the inflows of all tributaries and the immediate drainage | cubic meters per second|
|retention_time | a mean value determined by dividing the lake volume, in cubic meters, by the mean annual outflow in cubic meters per unit cof time| years or days|
|retention_time_units | the units of time for each retention entry|years or days|
|alkalinity | |milligrams per liter|
|conductivity | |microohms|
|secchi | |meters|
|tp | total phosphorus| milligrams per liter|
|po4 | orthophosphate| milligrams per liter|
|tin | total inorganic nitrogen| milligrams per liter|
|tn | total nitrogen| milligrams per liter|
|p_pnt_source_muni | municipal point source phosphorus loading| kilograms per year|
|p_pnt_source_industrial | industrial point source phosphorus loading| kilograms per year|
|p_pnt_source_septic | septic point source phosphorus loading| kilograms per year|
|p_nonpnt_source | nonpoint source phosphorus loading| kilograms per year|
|p_total | total phosphorus loading| kilograms per year|
|n_pnt_source_muni | municipal point source nitrogen loading| kilograms per year|
|n_pnt_source_industrial | industrial point source nitrogen loading| kilograms per year|
|n_pnt_source_septic | septic point source nitrogen loading| kilograms per year|
|n_nonpnt_source | nonpoint source nitrogen loading| kilograms per year|
|n_total | total nitrogen loading| kilograms per year|
|p_total_out | total phosphorus outlet load| kilograms per year|
|p_percent_retention | percent phosphorus retention| percent|
|p_surface_area_loading | phosphorus surface area loading| grams per square meter per year|
|n_total_out | total nitrogen outlet load| kilograms per year|
|n_percent_retention | percent nitrogen retention|percent|
|n_surface_area_loading | nitrogen surface area loading| grams per square meter per year|
|lat | |decimal degrees|
|long | |decimal degrees|

## References

Stachelek, J., Ford, C., Kincaid, D., King, K., Miller, H., Nagelkirk, R. (_in prep_) The National Eutrophication Survey: lake characteristics and historical nutrient concentrations. 

Stachelek, J. (2017). nesR: Scrape Data from National Eutrophication Survey archival PDFs. R package version 0.1. (https://github.com/jsta/nesR) (https://dx.doi.org/10.5281/zenodo.400258)
