#Twitter client with offline mode.

- As a user I can login to Twitter
- As a user I see my twitter name in the navigation bar
- As a user I can view my Twitter feed (fail plan: display error)
- As a user I can refresh my feed using pull-to-refresh (fail plan: display error)
- As a user I can view my Twitter feed without internet connection
- As a user I expect that feed will be automatically updated when network connection is available
- As a user I can tap on system compose button on the right of navigation bar and get to post new tweet screen
- As a user I can post new tweet (fail plan: display error)

#Technical requirements

- Feel free to use Accounts and Social frameworks - no explicit need to integrate twitter SDK
- iOS deployment target - 8.0+
- CocoaPods used as dependency manager
- App is built using MVVM approach, view is bound to view-model using [RAC v2.5](https://github.com/ReactiveCocoa/ReactiveCocoa/releases/tag/v2.5)
- Unit tests required, use [Kiwi](https://github.com/kiwi-bdd/Kiwi)
- CoreData used as a backing storage