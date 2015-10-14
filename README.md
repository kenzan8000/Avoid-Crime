# Avoid Crime SF


## Avoid Crime SF

Map app to avoid crime

<img src="https://github.com/kenzan8000/Avoid-Crime/blob/master/Destination%20Alarm/Resources/Screenshots/1-667h@2x.png?raw=true" alt="" style="width: 375px;"/>
<img src="https://github.com/kenzan8000/Avoid-Crime/blob/master/Destination%20Alarm/Resources/Screenshots/2-667h@2x.png?raw=true" alt="" style="width: 375px;"/>
<img src="https://github.com/kenzan8000/Avoid-Crime/blob/master/Destination%20Alarm/Resources/Screenshots/3-667h@2x.png?raw=true" alt="" style="width: 375px;"/>
<img src="https://github.com/kenzan8000/Avoid-Crime/blob/master/Destination%20Alarm/Resources/Screenshots/4-667h@2x.png?raw=true" alt="" style="width: 375px;"/>


## Installation

##### 1. Clone and install Pods

```
git clone https://github.com/kenzan8000/Avoid-Crime.git
cd Avoid-Crime
pod install
```

##### 2. Register Google Developer Console

https://console.developers.google.com/

- Request credential
 - browser key
 - ios key

- Enable APIs
 - Directions API
 - Distance Matrix API
 - Elevation API
 - Geocoding API
 - Google Maps Engine API
 - Google Maps SDK for iOS
 - Google Places API for iOS
 - Google Places API Web Service
 - Time Zone API

- Check your api keys
 - browser key
 - iOS key

##### 3. Add /Destination Alarm/Classes/DAConstant-Private.swift

```swift
/// Google Map API key
let kDAGoogleMapAPIKey =                 "YOUR_GOOGLE_MAP_IOS_APP_API_KEY"
let kDAGoogleMapBrowserAPIKey =          "YOUR_GOOGLE_MAP_BROWSER_APP_API_KEY"
```
