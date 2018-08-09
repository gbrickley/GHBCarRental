# GHBCarRental
A simple app to find available rental cars near you.

## Installation
If running on a simulator, set a `Default Location` under `Scheme -> Edit Scheme -> Run -> Options` to test.  If running on a real device, `Default Location` can remain as none. If you have any questions or issues, please contact me.

## Features
- Retrieve rental options for a given date range and location.
- Filter options by rental company.
- Order options by price (highest to lowest, lowest to highest) and proximity.
- View a map of options.
- Tap a rental options for more details.
- Get navigation directions to the rental pickup location.

## Settings
- The [Constants.swift](GHBCarRental/Constants.swift) file contains several values that can be edited based on preference:
    - `DefaultSearchParameters.radius`: The default search radius around the chosen center point.
    - `DefaultDates.defaultPickupTimeHours`: The hour of the day that all requests will use in the `pickupDate`.
    - `DefaultDates.defaultPickupTimeMinutes`: The minute value that all requests will use in the `pickupDate`.
    - `DefaultDates.defaultDropoffTimeHours`: The hour of the day that all requests will use in the `dropoffDate`.
    - `DefaultDates.defaultDropoffTimeMinutes`: The minute value that all requests will use in the `dropoffDate`.
    - `Strings.locationPreAuthorizationMessage`: A message that is shown to the user prior to actually asking for permission to access their location.
  
## Testing
- Project includes very basic unit testing for API requests, Acriss decoding, unit conversion, date formatting, and location based calculations.

## TODO's / Future Addons
- Add to unit tests. 
