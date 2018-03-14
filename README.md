# Samba SDK

## Requirements
The Samba SDK is compatible with iOS 9.0+ and uses certain Apple frameworks that should already be in your project:

* Foundation.framework
* UIKit.framework
* JavaScriptCore.framework
* SafariServices.framework
* AdSupport.framework
* MediaPlayer.framework
* CoreMedia.framework
* SystemConfiguration.framework

In addition to these, the following external frameworks are used:

* youtube_ios_player_helper.framework
* KissXML.framework
* Alamofire.framework

These three frameworks need to be included in your project. In order to do this please read the next section.

## Let's get started 


1. In order to connect to our system you will need a PublisherId and a SecretKey. Please contact your SambaNetworks Account Manager or contact us at sales@sambanetworks.com to get these.
2. Add the Samba SDK to your project in the following way:  
    a.  Download ```SambaSDK.framework```.  
    b.  Drag the ```SambaSDK.framework``` directory into Xcode under Frameworks.  
    c.  Now you should add ```Alamofire```, ```KissXML``` and ```youtube-ios-player-helper``` to your project. We recommend     using Cocoapods however you can also check each Framework's webpage for other ways to integrate. In order to add the frameworks through Cocoapods please add the following lines to the Podfile:  
                 ```pod 'Alamofire', '~> 4.6'``` <br/>
                 ```pod 'KissXML'``` <br />
                 ```pod 'youtube-ios-player-helper', '~> 0.1.4'``` <br />


## Let's get to the code


You now need to configure the SDK. We recommend doing this early in your application's lifecycle so it's ready when you want to load / show an ad. 

To do this you need to call the following method:

```
public static func configure(setup: SambaSetup, videoConfig: VideoConfig? = nil, target: Target? = nil)
```

There are 3 parameters you can configure however SambaSetup ```(params: userId, publisherId, secretKey)``` is the only one which is mandatory. ```userId``` is a String identifying each user in your app. It is good practice to use some kind of UUID, although another unique string will also work.  The ```publisherId``` and ```secretKey``` are obtained from Samba.

In addition you can configure Target ```(params: age, gender)``` which represents the target audience and VideoConfig ```(params: screenOrientation, soundEnabled, optimizeDownloadOnMobileData)``` which configures the video settings.

All parameters in the Target and VideoConfig objects are optional. 



## Sample code:

```
import SambaSDK

...

let sambaSetup = SambaSetup(userId: currentUserId, publisherId: 27, secretKey: "sampleSecretKey")

let adTarget = Target(age: 25, gender: Gender.female)

let videoConfig = VideoConfig(screenOrientation: .auto, soundEnabled: true)

Samba.configure(setup: sambaSetup, videoConfig: videoConfig, target: adTarget)
```


The SDK is now configured. Next you should add the following property in the ```UIViewController``` that you will use to present the ad:

```
import SambaSDK 

...

let adManager = AdManager?

...

self.adManager = Samba.adManager
```

Once this is done you will be able to load an ad.

```
self.adManager?.loadAd()
```

After the ad has loaded you can show it to the user however we recommend checking that the ad is ready before you do this. If you would like to make adjustments (e.g. disabling the sound or stopping certain timers) now is the best time to do so.

```
if self.adManager?.isReady {

     self.adManager?.showAd(from: self)

}
```


To be notified of different events that are triggered during the playing of an ad, like when the ad has successfully loaded or something went wrong, you should implement the AdManagerProtocol.
You need to set the delegate in order to receive these events:

```
self.adManager?.delegate = self
```

The ```AdManagerProtocol``` includes the following events:


| Method | Description |
| ----------- | ----------- |
| `func sambaAdDidLoad(_ adManager: AdManager)` | Called after an ad was successfully loaded. |
| `func sambaAd(_ adManager: AdManager, didFailToLoad error: SambaError)` | Called if an error occurred. |
| `func sambaAdDidAppear(_ adManager: AdManager)` | Called after the ad appeared on the screen. |
| `func sambaAdDidDisappear(_ adManager: AdManager)` | Called after the ad disappeared from the screen. This is a good place to reconfigure your app to its initial state (mute, restart the timers, etc). |
| `func sambaAd(_ adManager: AdManager, didReachEnd adCompleted: Bool)` | Called if the user watched the ad until the end. If you want to reward the user for watching an ad (adCompleted is true), or if you want to return to where you've left off in your app, you could do it here. |
| `func ageRestrictionNotMet(_ adManager: AdManager)` | Called if all the ads received were age restricted and the user is under-age. |

**All callback methods are optional.**


## You're all set

Now you're ready to show high quality video ads to your users. Welcome aboard!
