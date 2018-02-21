# Mashling Push Notifications using FCM

This recipe demonstrates how **Mashling** can laverage FCM cloud function, realtime databe & messaging services to send push notifications to its registred users.

Pictorial representation of the recipe solution.
![Screenshot](mashling_fcm.png)

## Installation
### Prerequisites
* Node.js SDK [npm, node](https://nodejs.org/en/download/)
* Firebase account [fcm](https://firebase.google.com/)

## Getting Started
### Source code
    git clone https://github.com/TIBCOSoftware/mashling-recipes
	cd mashling-recipes/recipes/fcm/mashling-fcm-push-notifications
### Deploy FCM cloud functions
npm install
create firebase project
enable google authentication
firebase login
firebase use --add
firebase deploy

### Buil Mashling gateway

## testing
curl -X POST localhost:9096/notification -d '{"message":"how are you?"}'

## License
mashling is licensed under a BSD-type license. See TIBCO LICENSE.txt for license text.

fcm/fcm-project is licenced under Apache-2.0 license.