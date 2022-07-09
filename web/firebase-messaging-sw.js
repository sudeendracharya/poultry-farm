importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.0/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyD3pgykkcZN9LmnUOjw-mU1Wz54soZEogg",
    authDomain: "poultry-farm-572bd.firebaseapp.com",
    projectId: "poultry-farm-572bd",
    storageBucket: "poultry-farm-572bd.appspot.com",
    messagingSenderId: "34824825747",
    appId: "1:34824825747:web:bf1ee87d4ed475ca5e5666"
});

const messaging = firebase.messaging();



// Optional:
// messaging.onBackgroundMessage((message) => {
//     console.log("onBackgroundMessage", message);
// });