'use strict';

// Initializes the Demo.
function Demo() {
  document.addEventListener('DOMContentLoaded', function() {
    // Shortcuts to DOM Elements.
    this.signInButton = document.getElementById('demo-sign-in-button');
    this.signOutButton = document.getElementById('demo-sign-out-button');
    this.nameContainer = document.getElementById('demo-name-container');
    this.fcmErrorContainer = document.getElementById('demo-fcm-error-container');
    this.deleteButton = document.getElementById('demo-delete-button');
    this.signedOutCard = document.getElementById('demo-signed-out-card');
    this.signedInCard = document.getElementById('demo-signed-in-card');
    this.preferencesCard = document.getElementById('demo-mashling-preferences-card');
    this.snackbar = document.getElementById('demo-snackbar');

    // Bind events.
    this.signInButton.addEventListener('click', this.signIn.bind(this));
    this.signOutButton.addEventListener('click', this.signOut.bind(this));
    this.deleteButton.addEventListener('click', this.deleteAccount.bind(this));
    firebase.auth().onAuthStateChanged(this.onAuthStateChanged.bind(this));
    firebase.messaging().onMessage(this.onMessage.bind(this));
  }.bind(this));
}

// Triggered on Firebase auth state change.
Demo.prototype.onAuthStateChanged = function(user) {
  // If this is just an ID token refresh we exit.
  if (user && this.currentUid === user.uid) {
    return;
  }

  // Remove all Firebase realtime database listeners.
  if (this.listeners) {
    this.listeners.forEach(function(ref) {
      ref.off();
    });
  }
  this.listeners = [];

  // Adjust UI depending on user state.
  if (user) {
    this.currentUid = user.uid;
    this.nameContainer.innerText = user.displayName;
    this.signedOutCard.style.display = 'none';
    this.signedInCard.style.display = 'block';
    this.preferencesCard.style.display = 'block';
    firebase.database().ref(`mashlingusers/${user.uid}`).update({
      displayName: user.displayName,
      photoURL: user.photoURL
    });
    this.saveToken();
    this.displayPreferences();
  } else {
    this.signedOutCard.style.display = 'block';
    this.signedInCard.style.display = 'none';
    this.preferencesCard.style.display = 'none';
    this.currentUid = null;
  }
};

// Display preferences
Demo.prototype.displayPreferences = function() {
  // Activate the Material Design Lite Switch element.
  var prefsElement = document.getElementById('demo-all-mashling-preferences-list');
  var materialSwitchContainer = prefsElement.getElementsByClassName('mdl-switch')[0];
  if (componentHandler) {
    componentHandler.upgradeElement(materialSwitchContainer);
  }
  var switchElement = document.getElementById('demo-pref-push-notes-switch');

  //Set preference value to UI
  var followUserPrefRef = firebase.database().ref('/mashlingfollowers/' + this.currentUid);
  followUserPrefRef.on('value', function (prefSnapshot) {
    switchElement.checked = !!prefSnapshot.val();
    if (materialSwitchContainer.MaterialSwitch) {
      materialSwitchContainer.MaterialSwitch.checkDisabled();
      materialSwitchContainer.MaterialSwitch.checkToggleState();
    }
  });

  //Add switch even listener
  switchElement.addEventListener('change', function() {
    var followUserPrefRef = firebase.database().ref('/mashlingfollowers/' + this.currentUid);
    followUserPrefRef.set(!!switchElement.checked);
  }.bind(this));
}

// Initiates the sign-in flow using LinkedIn sign in in a popup.
Demo.prototype.signIn = function() {
  var google = new firebase.auth.GoogleAuthProvider();
  firebase.auth().signInWithPopup(google);
};

// Signs-out of Firebase.
Demo.prototype.signOut = function() {
  firebase.auth().signOut();
};

// Deletes the user's account.
Demo.prototype.deleteAccount = function() {
  firebase.database().ref('/mashlingfollowers/' + this.currentUid).remove();
  return firebase.database().ref('/mashlingusers/' + this.currentUid).remove().then(function() {
    return firebase.auth().currentUser.delete().then(function() {
      window.alert('Account deleted');
    }).catch(function(error) {
      if (error.code === 'auth/requires-recent-login') {
        window.alert('You need to have recently signed-in to delete your account. Please sign-in and try again.');
        firebase.auth().signOut();
      }
    });
  });
};

// Called when a notification is received while the app is in focus.
Demo.prototype.onMessage = function(payload) {
  console.log('Notifications received.', payload);

  // If we get a notification while focus on the app
  if (payload.notification) {
    let data = {
      message: payload.notification.body
    };
    this.snackbar.MaterialSnackbar.showSnackbar(data);
  }
};

// Saves the token to the database if available. If not request permissions.
Demo.prototype.saveToken = function() {
  firebase.messaging().getToken().then(function(currentToken) {
    if (currentToken) {
      firebase.database().ref('users/' + this.currentUid + '/notificationTokens/' + currentToken).set(true);
      firebase.database().ref('mashlingusers/' + this.currentUid).update({
        clientToken: currentToken
      });
      // firebase.database().ref('mashlingfollowers/' + this.currentUid).set(false);
    } else {
      this.requestPermission();
    }
  }.bind(this)).catch(function(err) {
    console.error('Unable to get messaging token.', err);
    if (err.code === 'messaging/permission-default') {
      this.fcmErrorContainer.innerText = 'You have not enabled notifications on this browser. To enable notifications reload the page and allow notifications using the permission dialog.';
    } else if (err.code === 'messaging/notifications-blocked') {
      this.fcmErrorContainer.innerHTML = 'You have blocked notifications on this browser. To enable notifications follow these instructions: <a href="https://support.google.com/chrome/answer/114662?visit_id=1-636150657126357237-2267048771&rd=1&co=GENIE.Platform%3DAndroid&oco=1">Android Chrome Instructions</a><a href="https://support.google.com/chrome/answer/6148059">Desktop Chrome Instructions</a>';
    }
  }.bind(this));
};

// Requests permission to send notifications on this browser.
Demo.prototype.requestPermission = function() {
  console.log('Requesting permission...');
  firebase.messaging().requestPermission().then(function() {
    console.log('Notification permission granted.');
    this.saveToken();
  }.bind(this)).catch(function(err) {
    console.error('Unable to get permission to notify.', err);
  });
};

// Load the demo.
window.demo = new Demo();
