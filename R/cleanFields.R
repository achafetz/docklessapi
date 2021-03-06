#' Function to clean up the data frames so that they can be combined
#'
#' @param df dataframe to clean up
#'
#' @export
#' @importFrom dplyr %>%
#'


cleanFields <- function(df){

    #Vehicle Type
    #If else statement to separate lime's bikes & scooters from the rest of companies
    if("attributes.vehicle_type" %in% colnames(df)){
        df <-
            df %>%
            dplyr::rename(vehicletype = attributes.vehicle_type)
    } else{
        df <-
            df %>%
            dplyr::mutate(vehicletype = dplyr::case_when(
                company %in% c("jump") ~ "bike",
                TRUE                   ~ "scooter"))
    }

    #BikeID
    name_ID <-
        df %>%
        dplyr::select(dplyr::matches("bike_id|bikes.bike_id|attributes.plate_number")) %>%
        names()

    df <-
        df %>%
        dplyr::rename(bikeID = !!name_ID)

    #Longtitude & Latitude
    name_long <-
        df %>%
        dplyr::select(dplyr::matches("lon|lng")) %>%
        names()

    name_lat <-
        df %>%
        dplyr::select(dplyr::matches("lat|latitude")) %>%
        names()

    df <-
        df %>%
        dplyr::rename(lat = !!name_lat,
                      long = !!name_long) %>%
        dplyr::mutate(lat = as.numeric(lat),
                      long = as.numeric(long)) %>%
        dplyr::filter(lat > 37 & lat < 39,
                      long > -78 & long < -76) #Skip reports data nationally

    #Selecting fields we want
    df <-
        df %>%
        dplyr::select(company, vehicletype, bikeID, lat, long)

    return(df)

}
