importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.1/firebase-messaging-compat.js");

// Initialize Firebase with your project credentials
firebase.initializeApp({
    apiKey: "AIzaSyAbrmKayFPoqgvl5j00h4PizmhDa1D5XZE",
    authDomain: "family-bazar-4d8ff.firebaseapp.com",
    projectId: "family-bazar-4d8ff",
    storageBucket: "family-bazar-4d8ff.firebasestorage.app",
    messagingSenderId: "635861356182",
    appId: "1:635861356182:web:090ad6eb13720d89a57cb7",
});

const messaging = firebase.messaging();

// Handle background messages
messaging.onBackgroundMessage(function(payload) {
    console.log('[firebase-messaging-sw.js] Received background message: ', payload);

    const notificationTitle = (payload.notification && payload.notification.title) ||
                            (payload.data && payload.data.title) ||
                            "Family Bazar";

    const notificationOptions = {
        body: (payload.notification && payload.notification.body) ||
              (payload.data && payload.data.body) ||
              "You have a new update.",
        icon: (payload.notification && payload.notification.icon) ||
              (payload.data && payload.data.icon) ||
              "/icons/Icon-192.png", 
        data: payload.data 
    };

    return self.registration.showNotification(notificationTitle, notificationOptions);
});

// Optional: Handle what happens when a user clicks the background notification
self.addEventListener('notificationclick', function(event) {
    event.notification.close();

    event.waitUntil(
        clients.matchAll({ type: 'window', includeUncontrolled: true }).then(function(clientList) {
            for (let i = 0; i < clientList.length; i++) {
                let client = clientList[i];
                if (client.url === '/' && 'focus' in client) {
                    return client.focus();
                }
            }
            if (clients.openWindow) {
                return clients.openWindow('/');
            }
        })
    );
});