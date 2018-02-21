# Mashling Push Notifications using FCM

This recipe demonstrates how **Mashling** can laverage FCM cloud function, realtime databe & messaging services to send push notifications to its registred users.

Pictorial representation of the recipe solution.
![Screenshot](mashling_fcm.png)

## Installation
### Prerequisites
* Node.js SDK [npm, node](https://nodejs.org/en/download/)
* Firebase account [fcm](https://firebase.google.com/)

## Getting Started
Solution consists of two projects.
* fcm-project
* gateway

### Source code
    git clone https://github.com/TIBCOSoftware/mashling-recipes
	cd mashling-recipes/recipes/fcm/mashling-fcm-push-notifications
### Deploy FCM cloud functions

* Create a Firebase Project using the Firebase Console.
* Enable Google Provider in the Auth section
* Navigate to fcm-project directory.
* You must have the Firebase CLI installed. If you don't have it install it with npm install -g firebase-tools and then configure it with firebase login.
* Configure the CLI locally by using firebase use --add and select your project in the list.
* Install dependencies locally by running: cd functions; npm install; cd -
* Deploy your project using firebase deploy
* Open the app using firebase open hosting:site, this will open a browser.

### Buil Mashling gateway

## testing
curl -X POST localhost:9096/notification -d '{"message":"how are you?"}'

## License
mashling is licensed under a BSD-type license. See TIBCO LICENSE.txt for license text.

fcm/fcm-project is licenced under Apache-2.0 license.