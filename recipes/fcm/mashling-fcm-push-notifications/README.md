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
    * Web application for user to subscribe Mashling push notifications.
    * Cloud function to send push notifications to registered uses using FCM messaging service.
* gateway-project - Mashling gateway descriptor with one HTTP trigger & FCM cloud function invoke handler.

### Source code
    git clone https://github.com/TIBCOSoftware/mashling-recipes
	cd mashling-recipes/recipes/fcm/mashling-fcm-push-notifications

### Deploy FCM project

1. Create a Firebase Project using the [Firebase Console](https://console.firebase.google.com/).
2. Enable Google Provider in the Auth section (Firebase Console -> Authentication -> SIGN-IN METHOD).
3. Navigate to fcm-project directory by running: `cd fcm-project`.
4. You must have the Firebase CLI installed. If you don't have it install it with `npm install -g firebase-tools` and then configure it with `firebase login`.
5. Configure the CLI locally by using `firebase use --add` and select your project in the list.
6. Install dependencies locally by running: `cd functions; npm install; cd -`
7. Deploy your project using `firebase deploy`
8. Capture `Hosting URL` & cloud `Function URL` from the console.<br>
Screenshot for reference:
![Screenshot](cli_screenshot.png)


### Create Mashling gateway

1. Navigate to gateway-projct directory `cd ../gateway-project/`
2. Update `endPoint` value in gateway.json with cloud `Function URL` captured in previous secion.
3. Create Mashling gateway by running `mashling create -f gateway.json gateway`.

## testing

1. Open `Hosting URL` in Chrome browser.
2. Login with your google account.
3. Accept security confirmation to receive notifications.
4. Enable `Mashling gateway push notifications` preference.
5. Run the Mashling gateway app by using `cd gateway/bin; ./gateway`
6. Perform HTTP POST call using
`
curl -X POST localhost:9096/notification -d '{"message":"Message from gateway !!"}'
`
7. You should see desktop nofication when chrome browser window is minimized.<br>
Notification screenshot for reference:
![Screenshot](notification_screenshot.png)

## License
mashling is licensed under a BSD-type license. See TIBCO LICENSE.txt for license text.

fcm-project is licenced under Apache-2.0 license.