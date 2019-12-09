
<!-- README.md is generated from README.Rmd. Please edit that file -->

# National Eutrophication Survey

[![DOI](https://img.shields.io/badge/DOI-10.5063/F1CZ35HF-blue.svg)](https://doi.org/10.5063/F1CZ35HF)

This respository contains a digitally transcribed copy
([nes\_data.csv](https://github.com/ReproducibleQM/NES/raw/master/nes_data.csv))
of the National Eutrophication Survey (NES) dataset. The original data
can be found in the `archival_pdfs` folder or by searching:
<https://www.epa.gov/nscep>

## Locations

![](06_images/points_trim.jpeg)

## Data

<!-- Do not edit this table without first updating METADATA.md -->

| variable name              | description                                                                                                                        | units                           |
| -------------------------- | ---------------------------------------------------------------------------------------------------------------------------------- | ------------------------------- |
| pdf                        | pdf identifier (474 - 477)                                                                                                         | integer                         |
| pagenum                    | page number of the pdf                                                                                                             | integer                         |
| storet\_code               | identifier which links measurement to coordinate locations                                                                         | character                       |
| state                      | state where the water body resides                                                                                                 | character                       |
| name                       | name of the water body                                                                                                             | character                       |
| county                     | county where the water body resides                                                                                                | character                       |
| lake\_type                 | natural or impoundment                                                                                                             | character                       |
| drainage\_area             | the total drainage area                                                                                                            | square kilometers               |
| surface\_area              | the area of the water surface                                                                                                      | sq km                           |
| mean\_depth                | the volume of the water body divided by the surface area in square meters                                                          | meters                          |
| total\_inflow              | the mean of the inflows of all tributaries and the immediate drainage                                                              | cubic meters per second         |
| retention\_time            | a mean value determined by dividing the lake volume, in cubic meters, by the mean annual outflow in cubic meters per unit cof time | years or days                   |
| retention\_time\_units     | the units of time for each retention entry                                                                                         | years or days                   |
| alkalinity                 | alkalinity                                                                                                                         | milligrams per liter            |
| conductivity               | conductivity                                                                                                                       | microohms                       |
| secchi                     | secchi                                                                                                                             | meters                          |
| tp                         | total phosphorus                                                                                                                   | milligrams per liter            |
| po4                        | orthophosphate                                                                                                                     | milligrams per liter            |
| tin                        | total inorganic nitrogen                                                                                                           | milligrams per liter            |
| tn                         | total nitrogen                                                                                                                     | milligrams per liter            |
| p\_pnt\_source\_muni       | municipal point source phosphorus loading                                                                                          | kilograms per year              |
| p\_pnt\_source\_industrial | industrial point source phosphorus loading                                                                                         | kilograms per year              |
| p\_pnt\_source\_septic     | septic point source phosphorus loading                                                                                             | kilograms per year              |
| p\_nonpnt\_source          | nonpoint source phosphorus loading                                                                                                 | kilograms per year              |
| p\_total                   | total phosphorus loading                                                                                                           | kilograms per year              |
| n\_pnt\_source\_muni       | municipal point source nitrogen loading                                                                                            | kilograms per year              |
| n\_pnt\_source\_industrial | industrial point source nitrogen loading                                                                                           | kilograms per year              |
| n\_pnt\_source\_septic     | septic point source nitrogen loading                                                                                               | kilograms per year              |
| n\_nonpnt\_source          | nonpoint source nitrogen loading                                                                                                   | kilograms per year              |
| n\_total                   | total nitrogen loading                                                                                                             | kilograms per year              |
| p\_total\_out              | total phosphorus outlet load                                                                                                       | kilograms per year              |
| p\_percent\_retention      | percent phosphorus retention                                                                                                       | percent                         |
| p\_surface\_area\_loading  | phosphorus surface area loading                                                                                                    | grams per square meter per year |
| n\_total\_out              | total nitrogen outlet load                                                                                                         | kilograms per year              |
| n\_percent\_retention      | percent nitrogen retention                                                                                                         | percent                         |
| n\_surface\_area\_loading  | nitrogen surface area loading                                                                                                      | grams per square meter per year |
| lat                        | latitude                                                                                                                           | decimal degrees                 |
| long                       | longitude                                                                                                                          | decimal degrees                 |

## Workflow

1.  Use the [nesR](https://github.com/jsta/nesR) package to generate the
    files in [/02\_raw\_data](/02_raw_data).

2.  Hand check the files in
    [/02\_raw\_data/merged\_data](/02_raw_data/merged_data) against the
    pdfs in [/01\_archival\_pdfs](/01_archival_pdfs).

3.  Combine files with
    [05\_analysis\_scripts/PDF\_Merge.R](05_analysis_scripts/PDF_Merge.R).

## Contributing

We’ve combed the data to try and find all the transciption errors but
it’s difficult to catch them all. If you find any errors please open
an [issue](https://github.com/ReproducibleQM/NES/issues/) or submit a
pull request against the files in [/03\_qa\_data](/03_qa_data).

## References

Stachelek, J., Ford, C., Kincaid, D., King, K., Miller, H. and
Nagelkirk, R., 2018. The National Eutrophication Survey: lake
characteristics and historical nutrient concentrations. Earth System
Science Data, 10(1), pp.81-86.
(<https://doi.org/10.5194/essd-10-81-2018>)

Stachelek, J. (2017). nesR: Scrape Data from National Eutrophication
Survey archival PDFs. R package version 0.1.
(<https://github.com/jsta/nesR>)
(<https://dx.doi.org/10.5281/zenodo.400258>)

Stachelek, J. (2017). nesRdata: National Eutrophication Survey Data
Package. R package version 0.1. <https://github.com/jsta/nesRdata>
