# SambaSDK

## Requirements
SambaSDK is compatible with iOS 9.0+.



SambaSDK uses some Apple frameworks. These frameworks should already be in your project:

* Foundation.framework
* UIKit.framework
* JavaScriptCore.framework
* SafariServices.framework
* AdSupport.framework
* MediaPlayer.framework
* CoreMedia.framework
* SystemConfiguration.framework

Beside these, other external frameworks were used:

* youtube_ios_player_helper.framework
* KissXML.framework
* Alamofire.framework

These three frameworks have to be included in your project. In order to do this, please check the next section.

## Let's get started 


First of all, you need to create an account.. ( TODO: needs to be completed when the signing in procedure is defined). Here you will get your publisherId and secretKey. You need to use this later in your code.
Add SambaSDK in your project in the following way: 
Download ```SambaSDK.framework```.
Drag ```SambaSDK.framework``` directory into Xcode under Frameworks.
Now you should add ```Alamofire```, ```KissXML``` and ```youtube-ios-player-helper``` in your project. We recommend you to include them by using Cocoapods, but you can check each Framework's page to find more ways to do this. For adding them through Cocoapods, add in Podfile, the next lines:  
                 ```pod 'Alamofire', '~> 4.6'``` <br/>
                 ```pod 'KissXML'``` <br />
                 ```pod 'youtube-ios-player-helper', '~> 0.1.4'``` <br />


## Let's get to code


You need to configure the SDK. We recommend you to do this sometime early, so you will have it all set when you want to load / show an ad. 

To do this, you have to call this method:

```
public static func configure(setup: SambaSetup, videoConfig: VideoConfig? = nil, target: Target? = nil)
```

There are 3 parameters that you can configure. SambaSetup ```(params: userId, publisherId, secretKey)``` is the only one which is required. ```userId``` is an unique String, which you will get from your app (make sure it is unique for each user). ```publisherId``` and ```secretKey``` are received from Samba.

If you would like to go further with the configuration, you can configure Target ```(params: age, gender)``` which represents the target audience and VideoConfig ```(params: screenOrientation, soundEnabled, downloadOnWifiOnly, allowPrecaching)```.

All the parameters in Target and VideoConfig are optionals. 



## Sample code:

```
import SambaSDK

...

let sambaSetup = SambaSetup(userId: currentUserId, publisherId: 27, secretKey: "sampleSecretKey")

let adTarget = Target(age: 25, gender: Gender.female)

let videoConfig = VideoConfig(screenOrientation: .auto, soundEnabled: true)

Samba.configure(setup: sambaSetup, videoConfig: videoConfig, target: adTarget)
```


Now, the SDK is configured. Next, you should add the following property, in the ```UIViewController``` that you will use to present the ad:

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

After the ad is loaded, you can show it. However, we recommend you to check if the ad is ready before you try to do this. If you would like to make some configurations to your app (for example disabling the sound or stopping some timers), here might be a good place to do it.

```
if self.adManager?.isReady {

     self.adManager?.showAd(from: self)

}
```


In order to be notified about different events that might be triggered during the playing of an ad, such as when the ad has successfully been loaded and is ready to be shown or something went wrong, you should implement AdManagerProtocol.
Set delegate in order to receive those events:

```
self.adManager?.delegate = self
```

These are the methods included in ```AdManagerProtocol```:



After an ad is successfully loaded, this callback method is called:

```
@objc optional func sambaAdDidLoad(_ adManager: AdManager)
```


If an error occurs, this callback method is called:

```
@objc optional func sambaAd(_ adManager: AdManager, didFailToLoad error: SambaError)
```


When the ad is shown, this callback method is called:

```
@objc optional func sambaAdDidAppear(_ adManager: AdManager)
```


When the ad is dismissed, this callback method is called. Here might be the place to reconfigure your app to the initial state (play the sound, restart the timers etc). 

```
@objc optional func sambaAdDidDisappear(_ adManager: AdManager)
```


If the user watched the ad until the end, this callback method is called. If you want to reward the user for watching an ad (adCompleted is true), you could do it here.

```
@objc optional func sambaAd(_ adManager: AdManager, didReachEnd adCompleted: Bool)
```

If all the ads received were age restricted and the user's age was under 18, this callback method is called. 

```
@objc optional func ageRestrictionNotMet(_ adManager: AdManager)
```
