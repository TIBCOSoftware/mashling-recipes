'use strict';

exports.handle = (e, ctx, cb) => {
    ctx.callbackWaitsForEmptyEventLoop = false;

    var eventJsonBody = e['body-json'];
    const notificationMessage = eventJsonBody.message;

    var admin = require('firebase-admin');
    admin.initializeApp({
        credential: admin.credential.cert({
            projectId: 'test-8cdf6',
            clientEmail: 'firebase-adminsdk-zcbpe@test-8cdf6.iam.gserviceaccount.com',
            privateKey: '-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDLAIAfk7X6Boyx\nbERxMM5ZQR1OfSsnAJD7O8od+wpaWInvRSIKFqvnJ5XHAj5FEqMKb3m5LqEmN/VW\nS13p1RN8I7+f+sC/jZSaWWr8awZ4nRKVCZiyuuC9Bwtby9vxPJ61WxC/grzIDA3S\nbS8SF9YVzYbeW4regaZe4y8jNmE4k17lKOLhPhqeJfPPGxTI1X3/dK3kZ7k7iQM7\ncOMq5IW9Aqa/2THJ8zFiIjqRvVc0ToH7VHH2V5LkSuZV8q20HwXTvgC2zoLVwJ9s\nqXYJ+d6Mh7b/6Hm179ex6fvWlYEXnXiPbHwf60o6VPnR1SAT9SfAdD2uCccIFqBr\nHkapnOmBAgMBAAECggEAAR7v+39Rb8zo/8AJePSa4rvmU2EOK7YFZui2/7SWPhwA\nlMz6uxKSLomdumfXE+LZD6aVy0hQUMLkyzN0HwWA2PnaIzzOAy9pwBLWhr15H2cn\nyOGWSZrYllyaCG7IcyqZX6aYrHkGeDDhA5MxdsdBn1Snc2tO7wtz1uYTLshm+nor\nJWVLgJcs+Zd7Vln3NZ2TuXGkXt0GQZNX/lveTnE3H/HsBYevpQ0E6RihcHNK1iti\nqGJK0yIyzzuOQ8ym+cn/v4cfzjACbAGcMzR2/+kWlXmI5F9IjdCRGKWeOil5jHLJ\npXg+H5ufgwmrxKtj3on0VB/H7BP6ZBRbZyXDWrjJ0QKBgQDlJX0ea/y0NsovTh7G\nMjowX6+3y5u6eK/GMPp7BvU1DSMeP2rB/HXhGaC48lTjNvtdYL7qLbephUGnJouF\nnlESfRIqB7xKIsx7lDzBqE7fkUfscuBFs5FnjXKODHfaHB6LH1qY4fr7U9jcw7TU\nwX+ACM+rSpnPVC55Tyhu9Q+IUQKBgQDiyqnopj1UeAtFCro0RCGkxm+A9oPHRajN\nPFGXCnchhukBJON1OJlcDTn0DqQLuV5oZ2MUMdgQGEgUnlel8B7IJjnvucymbwsp\n4vMRLWpTYEYtzz9oiwBkpGzn6NYQVNsNYvE76eomqs9v5cMd7qtW7AzzDrcLuL4d\nd31G68QyMQKBgGpqDX/qQFHku+JaEhqSyskaNr1RFgHz+BU/O6OUqJ05e5yZcNej\niY6+2w/oohleuD82JZMVJhzYoJOiZ9rmmdnPMXdJXlzDaljdj5WTtwVGL7OT6akU\n6iq/2nozOhmVQ23yYp1rHKZI2wYy8LB5J9/qt55hp6pL+sUlSK62qb7xAoGBAIXU\nE9lup8g9omDWiLSo87V5R3kxfufLamXZz0ey7EPDiaGcNAELKixQvb8QGKu2ckhn\noebb1uUAfyBzo8MO5As1y4B0Api/9DV+b/LV+uVCbYdAwekeBVheUsmy8wbmG/FV\nTocNbJfuucQNMEtseH0thCK1rzxigwV+alW8cKUxAoGBAIUSs48CfSl0XytsPwxk\n3fe7TchCyvrlceab17tM2O4PqIuHKZF7PKLVv+vJ96+0e2K6SgZSBpYs/XR6q+zb\nCBLmz+Iv611kEYE0G5mcL4neskrbNaStiKi3CtHefZEZHsXQkITi1Ls8a8l60qz6\nVT2uhRt2BNBeimCJnMrkdq/r\n-----END PRIVATE KEY-----\n'
        }),
        databaseURL: 'https://test-8cdf6.firebaseio.com'
    });

    admin.database().ref('/mashlingfollowers').once('value', function (snapshot) {
        //get all mashling followers user ids
        if (!snapshot.hasChildren()) {
            admin.app('[DEFAULT]').delete();
            console.log("{There are no mashling followers.}");
            cb(null, "{There are no mashling followers.}");
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
                            cb(null, "{Push notification sent successfully}");
                        })
                        .catch(function (fcmError) {
                            admin.app('[DEFAULT]').delete();
                            cb(null, "{error while sending push notification}");
                        });
                } else {
                    admin.app('[DEFAULT]').delete();
                    cb(null, "{There are no mashling followers.}");
                }
            });
        }
    });
}