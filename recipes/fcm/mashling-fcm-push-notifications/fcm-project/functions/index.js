'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);

/**
 * Sends push notifications to all mashling followers.
 */
exports.sendPushNotification = functions.https.onRequest((req, res) => {
  const notificationMessage = req.body.message;
  return admin.database().ref('/mashlingfollowers').once('value', function(snapshot){
    //get all mashling followers user ids
    if(!snapshot.hasChildren()) {
      return console.log('There are no mashling followers.');
    }
    //list mashling follower user ids.
    const mashlingFllowersUids = [];
    Object.keys(snapshot.val()).forEach((k) => {
      if(snapshot.val()[k]) {
        mashlingFllowersUids.push(k);
      }
    });
    
    //read mashling followers user details from mashlingusers table
    const mashlingFllowersPromises = [];
    mashlingFllowersUids.forEach((uid, index) => {
      const mashlingFllowersPromise = admin.database().ref(`/mashlingusers/${uid}`).once('value');
      mashlingFllowersPromises.push(mashlingFllowersPromise);
    });
    Promise.all(mashlingFllowersPromises).then((mfSnapshots) => {
      mfSnapshots.forEach((mfSnapshot, index) => {
        if (mfSnapshot.hasChildren()) {
          const mashlingFollowerClientToken = mfSnapshot.val().clientToken;
          const mashlingFollowerClientName = mfSnapshot.val().displayName;
          console.log("sending push notification to - ", mashlingFollowerClientName);
          //create notification payload
          const payload = {
            notification: {
              title: `Hello - ${mashlingFollowerClientName} !!`,
              body: `${notificationMessage}`,
              icon: 'mashling.png',
            },
          };
          admin.messaging().sendToDevice(mashlingFollowerClientToken, payload);
        }
      });
    });
    res.status(200).send({ "status": "200" });
  });
});