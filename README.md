# TwitterClient

## Notes:
* SDK

As per iOS 11 there is no more Accounts functionality for social integrations - all of them must be implemented via different SDK. 
TwitterKit for Twitter ¯\_(ツ)_/¯ 
There are some related issues in functionality because of that.

* RAC
Rac v2.5 has some issues with latest Xcode version so I had to make adjustments in code: 
removed `_Pragma("clang diagnostic ignored \"-Wreceiver-is-weak\"") \` in NSObject+RACPropertySubscribing.h:52
Also I had to turn off Xcode 9 warnings of strict prototypes.



