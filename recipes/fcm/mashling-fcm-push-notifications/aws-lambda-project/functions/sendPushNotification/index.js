'use strict';

exports.handler = (e, ctx, cb) => {
    ctx.callbackWaitsForEmptyEventLoop = false;

    const notificationMessage = e['message'];

    var admin = require('firebase-admin');
    admin.initializeApp({
        credential: admin.credential.cert({
            projectId: 'TO_BE_UPDATED_BY_RECIPE_USER',
            clientEmail: 'TO_BE_UPDATED_BY_RECIPE_USER',
            privateKey: 'TO_BE_UPDATED_BY_RECIPE_USER'
        }),
        databaseURL: 'TO_BE_UPDATED_BY_RECIPE_USER'
    });

    admin.database().ref('/mashlingfollowers').once('value', function (snapshot) {
        //get all mashling followers user ids
        if (!snapshot.hasChildren()) {
            admin.app('[DEFAULT]').delete();
            console.log("{There are no mashling followers.}");
            var response = {"Status":"There are no mashling followers"};
            cb(null, response);
        } else {
            //list mashling follower user ids.
            const mashlingFllowersUids = [];
            Object.keys(snapshot.val()).forEach((k) => {
                if (snapshot.val()[k]) {
                    mashlingFllowersUids.push(k);
                }
            });
            console.log("mashlingFllowersUids: " + JSON.stringify(mashlingFllowersUids));

            //read mashling followers user details from mashlingusers table
            const mashlingFllowersPromises = [];
            mashlingFllowersUids.forEach((uid, index) => {
                const mashlingFllowersPromise = admin.database().ref(`/mashlingusers/${uid}`).once('value');
                mashlingFllowersPromises.push(mashlingFllowersPromise);
            });
            
            Promise.all(mashlingFllowersPromises).then((mfSnapshots) => {
                
                const mashlingFollowerClientTokens = [];
                mfSnapshots.forEach((mfSnapshot, index) => {
                    if (mfSnapshot.hasChildren()) {
                        const mashlingFollowerClientToken = mfSnapshot.val().clientToken;
                        mashlingFollowerClientTokens.push(mashlingFollowerClientToken);
                    }
                });

                console.log("mashlingFollowerClientTokens: " + JSON.stringify(mashlingFollowerClientTokens));

                if (mashlingFollowerClientTokens.length > 0) {
                    //send push notification
                    const payload = {
                        notification: {
                            title: "Mashling Notification",
                            body: `${notificationMessage}`,
                            icon: 'mashling.png',
                        },
                    };
                    admin.messaging().sendToDevice(mashlingFollowerClientTokens, payload)
                        .then(function (fcmResp) {
                            admin.app('[DEFAULT]').delete();
                            var response = {"Status":"Push notification sent successfully"};
                            cb(null, response);
                        })
                        .catch(function (fcmError) {
                            admin.app('[DEFAULT]').delete();
                            var response = {"Status":"error while sending push notification"};
                            cb(null, response);
                        });
                } else {
                    admin.app('[DEFAULT]').delete();
                    var response = {"Status":"There are no mashling followers"};
                    cb(null, response);
                }
            });
        }
    });
}