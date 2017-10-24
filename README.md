## ARKit + Twilio Video Data Tracks Demo

The project demonstrates how to use Twilio's Programmable Video SDK and new Data Tracks API to create an interactive AR experience on a Twilio Video stream.


[ ![Download](https://img.shields.io/badge/Download-iOS%20SDK-blue.svg) ](https://www.twilio.com/docs/api/video/download-video-sdks#ios-sdk)
[![Docs](https://img.shields.io/badge/iOS%20Docs-OK-blue.svg)](https://media.twiliocdn.com/sdk/ios/video/latest/docs/index.html)


> NOTE: This sample application uses the Twilio Video 2.0.0-preview APIs. Previous versions of the Twilio Video API do not feature data tracks, and this sample code will not run.

Get started with Video on iOS:

- [Setup](#setup) - Get set up
- [Sample App](#sample-app) - Run the sample app
- [Set up an Access Token Server](#setup-an-access-token-server) - Set up an access token server
- [More Documentation](#more-documentation) - More documentation related to the iOS Video SDK
- [Issues & Support](#issues-and-support) - Filing issues and general support
- [License](#license)

## Setup 

This project uses Apple's Swift 4.0 programming language for iOS. 

If you haven't used Twilio before, welcome! You'll need to [Sign up for a Twilio account](https://www.twilio.com/try-twilio) first. It's free!

Note: if your app uses Objective-C see [video-quickstart-objective-c](https://github.com/twilio/video-quickstart-objc/).

### CocoaPods 

1. Install [CocoaPods 1.0.0+](https://guides.cocoapods.org/using/getting-started.html). 

1. Run `pod install` from the root directory of this project. CocoaPods will install `TwilioVideo.framework` and then set up an `xcworkspace`.

1. Open `DesignConsult.xcworkspace`.

Note: You may need to update the CocoaPods [Master Spec Repo](https://github.com/CocoaPods/Specs) by running `pod repo update master` in order to fetch the latest specs for TwilioVideo.

### Manual Integration

You can integrate `TwilioVideo.framework` manually by following these [install instructions](https://www.twilio.com/docs/api/video/download-video-sdks#manual). You will need to use version 2.0.0-preview5 or higher in order to take advantage of the DataTrack API.

## Sample App

### Running the Sample App

To get started with the sample application follow these steps:

1. Open this `DesignConsult.xcworkspace` in Xcode

2. Type in an identity and click on "Generate Access Token" from the [Testing Tools page](https://www.twilio.com/console/video/runtime/testing-tools).

Note: Ideally, you want to implement and deploy an Access Token server to generate tokens. You can read more about setting up your own Access Token Server in this [section](#setup-an-access-token-server). Read this [tutorial](https://www.twilio.com/docs/api/video/user-identity-access-tokens) to learn more about Access Tokens.

3. Paste the token you generated in the earlier step in `ClientViewController.swift`.

4. Run the app on your iOS device and/or simulator. Tap "I'm a customer" to run the app as a client.

5. As in Step 3, generate a new Token for another identity (such as "Bob"). Copy and paste the access token into `DesignerViewController.swift` (replacing the one you used earlier). Build and run the app on a second physical device if you have one, or the iPhone simulator, and tap "I'm a designer" to run the app as the designer in the consultation.

6. Once you have both apps running, you'll be prompted for mic and camera access on the physical device. Once you've connected from both devices, you should see the client's video on both devices. You'll also be able to share audio across both devices.

7. As the client, aim your camera at the physical space around you, following the direction of the designer on the other device. As the designer, direct the client to hold the camera still when you would like to place an object into the scene (this works best when you see many yellow dots, or feature points, indicating a physical plane for the object to be placed upon). Tap on the item that you would like to place, and then tap where you would like to place it. If successfully placed, the object should appear on both devices, and exist "in" the room the client is in. If you would like to move an item, simply select that type of item and place it elsewhere in the space (in this sample, only one of each type of item is allowed in the scene).


### Using a Simulator

You can use the iOS Simulator that comes with XCode to simulate the designer-side part of this sample app, but the client side must be accessed from a physical device (local video cannot be shared via Simulator because it cannot access a camera). 

Note: If you have an iOS device, you can now run apps from Xcode on your device without a paid developer account.

## Setup an Access Token Server

Using Twilio's Video client within your applications requires an access token. Access Tokens are short-lived credentials that are signed with a Twilio API Key Secret and contain grants which govern the actions the client holding the token is permitted to perform. 

### Configuring the Access Token Server

If you want to be a little closer to a real environment, you can download one of the video Quickstart server applications - for instance, [Video Quickstart: PHP](https://github.com/TwilioDevEd/video-quickstart-php) and either run it locally, or install it on a server. You can review a detailed [tutorial](https://www.twilio.com/docs/api/video/user-identity-access-tokens#generating-access-tokens). 

You'll need to gather a couple of configuration options from the Twilio developer console before running it, so read the directions on the Quickstart. You'll copy the config.example.php file to a config.php file, and then add in these credentials:
 
 Credential | Description
---------- | -----------
Twilio Account SID | Your main Twilio account identifier - [find it on your dashboard](https://www.twilio.com/console).
API Key | Used to authenticate - [generate one here](https://www.twilio.com/console/video/runtime/api-keys).
API Secret | Used to authenticate - [just like the above, you'll get one here](https://www.twilio.com/console/video/runtime/api-keys).

Use whatever clever username you would like for the identity. If you enter the Room Name, then you can restrict this users access to the specified Room only. Read this [tutorial](https://www.twilio.com/docs/api/video/user-identity-access-tokens) for more information on Access Tokens. 

#### A Note on API Keys

When you generate an API key pair at the URLs above, your API Secret will only
be shown once - make sure to save this in a secure location.

## More Documentation

You can find more documentation on getting started with Twilio Video as well as our latest Docs below:

* [Getting Started](https://www.twilio.com/docs/api/video/getting-started)
* [Docs](https://media.twiliocdn.com/sdk/ios/video/latest/docs)

## Issues and Support

Please file any issues you find here on Github.

For general inquiries related to the Video SDK you can file a [support ticket](https://support.twilio.com/hc/en-us/requests/new).

## License

[MIT License](https://github.com/twilio/video-shared-arkit-sample/blob/master/LICENSE)
