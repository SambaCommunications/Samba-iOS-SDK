# Samba iOS SDK

## 1.1(9)

### Features
  * Add autoplay to default player
  * VPAID native

### Bug Fixes
  * Fix for ad end not being tracked correctly when switching between online-offline modes for youtube and vast content

### Refactoring
  * Updated project for Xcode 9.3 and Swift 4.1
  * Refactoring of presentation logic to remove the carousel product.

## 1.0(19)

### Features
  * Ad trailer in selector
  * No content screen displayed when there are no ads available
  * Error handling in selectors to give the user the possibility to choose between trying to view another ad or close the screen

### Bug Fixes
  * Crash fixes
  * Memory leaks fixes
  * Fix to ignore user taps in a selector if an ad is already being prepared for presentation
  * Restart video after the app is interrupted by incoming phone call
  * Fix for the splash logo screen not being displayed when the next ad for a user is a fallback ad

### Refactoring
  * JWPlayer and Post Play Action ported from UIWebView to WKWebView.
  
## 1.0(6)

Initial Samba iOS SDK preview
