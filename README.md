# Samba SDK

## Requirements
The Samba SDK is compatible with iOS 9.0+.

The SDK uses some Apple frameworks that should already be in your project:

* Foundation.framework
* UIKit.framework
* JavaScriptCore.framework
* SafariServices.framework
* AdSupport.framework
* MediaPlayer.framework
* CoreMedia.framework
* SystemConfiguration.framework

Beside these, other external frameworks are used:

* youtube_ios_player_helper.framework
* KissXML.framework
* Alamofire.framework

These three frameworks have to be included in your project. In order to do this, please check the next section.

## Let's get started 


1. In order to connect to our system you will need a PublisherId and a SecretKey. Please contact your SambaNetworks Account Manager or contact us at sales@sambanetworks.com in order to receive these.
2. Add the Samba SDK to your project in the following way:  
    a.  Download ```SambaSDK.framework```.  
    b.  Drag the ```SambaSDK.framework``` directory into Xcode under Frameworks.  
    c.  Now you should add ```Alamofire```, ```KissXML``` and ```youtube-ios-player-helper``` to your project. We recommend           you to include them by using Cocoapods, but you can also check each Framework's page to find more ways to integrate. In order to add the frameworks through Cocoapods please add the following lines to the Podfile:  
                 ```pod 'Alamofire', '~> 4.6'``` <br/>
                 ```pod 'KissXML'``` <br />
                 ```pod 'youtube-ios-player-helper', '~> 0.1.4'``` <br />


## Let's get to code


You need to configure the SDK. We recommend you to do this sometime early in your application's lifecycle, so you will have it all set when you want to load / show an ad. 

To do this, you have to call the following method:

```
public static func configure(setup: SambaSetup, videoConfig: VideoConfig? = nil, target: Target? = nil)
```

There are 3 parameters that you can configure. SambaSetup ```(params: userId, publisherId, secretKey)``` is the only one which is required. ```userId``` is an unique String identifying each user in your app. It is a good practice to use some kind of a UUID, but other unique string will work as well.  ```publisherId``` and ```secretKey``` are received from Samba.

If you would like to go further with the configuration, you can configure Target ```(params: age, gender)``` which represents the target audience and VideoConfig ```(params: screenOrientation, soundEnabled, optimizeDownloadOnMobileData)```.

All the parameters in Target and VideoConfig objects are optionals. 



## Sample code:

```
import SambaSDK

...

let sambaSetup = SambaSetup(userId: currentUserId, publisherId: 27, secretKey: "sampleSecretKey")

let adTarget = Target(age: 25, gender: Gender.female)

let videoConfig = VideoConfig(screenOrientation: .auto, soundEnabled: true)

Samba.configure(setup: sambaSetup, videoConfig: videoConfig, target: adTarget)
```


Now the SDK is configured. Next, you should add the following property in the ```UIViewController``` that you will use to present the ad:

```
import SambaSDK 

...

let adManager = AdManager?

...

self.adManager = Samba.adManager
```

Once this is done, you will be able to load an ad.

```
self.adManager?.loadAd()
```

After the ad is loaded, you can show it. However, we recommend you to check if the ad is ready before you try to do this. If you would like to make some adjustments (for example disabling the sound or stopping some timers) here might be a good place to do so.

```
if self.adManager?.isReady {

     self.adManager?.showAd(from: self)

}
```


In order to be notified about different events that might be triggered during the playing of an ad, such as when the ad has successfully been loaded and is ready to be shown or something went wrong, you should implement the AdManagerProtocol.
Set the delegate in order to receive those events:

```
self.adManager?.delegate = self
```

The ```AdManagerProtocol``` includes the following events:


| Method | Description |
| ----------- | ----------- |
| `func sambaAdDidLoad(_ adManager: AdManager)` | Called after an ad was succesfully loaded. |
| `func sambaAd(_ adManager: AdManager, didFailToLoad error: SambaError)` | Called if an error occured. |
| `func sambaAdDidAppear(_ adManager: AdManager)` | Called after the ad appeared on the screen. |
| `func sambaAdDidDisappear(_ adManager: AdManager)` | Called after the ad disappeared from the screen. This is a good place to reconfigure your app to the initial state (mute, restart the timers etc). |
| `func sambaAd(_ adManager: AdManager, didReachEnd adCompleted: Bool)` | Called if the user watched the ad until the end. If you want to reward the user for watching an ad (adCompleted is true), or you want to return to where you've left off in your app, you could do it here. |
| `func ageRestrictionNotMet(_ adManager: AdManager)` | If all the ads received were age restricted and the user did not qualify, this method is called. |

**All callback methods are optional.**


## You're all set

Now you are ready to present high quality and engaging ads to your users! Welcome aboard!
