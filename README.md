# Polymaker
Polymaker is an application that can create polygon locations dynamically in mobile apps and save the data into SQFlite to be permanent.

## Installing
- git clone https://github.com/yusriltakeuchi/polymaker.git
- flutter packages get
- flutter run

# Billing
You must enable some API in google cloud to use this features
- Google Maps for Android/iOS

## Setup
Please fill API KEY with your Google Cloud APIKEY
1. android/app/src/main/AndroidManifest.xml
```xml
<meta-data android:name="com.google.android.geo.API_KEY"
            android:value="<YOUR API KEY>"/>
```

2. ios/Runner/AppDelegate.swift
```swift
GMSServices.provideAPIKey("YOUR API KEY")
```

### Screenshots
- ![PolyMaker](https://i.ibb.co/QnztNLw/Whats-App-Image-2020-04-02-at-17-52-36.jpg)
