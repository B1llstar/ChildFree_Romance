const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const cors = require('cors');

const serviceAccount = require("./childfree-connection-firebase-adminsdk-bhabb-3828cb5e17.json");
admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const fcm = admin.messaging();

const app = express();

// Automatically allow cross-origin requests
app.use(cors({ origin: true }));



app.post('/sendPushNotification', async (req, res) => {
    try {
        const { userId, title, body, type, id } = req.body;
        if (!userId) {
            throw new Error('User ID is required.');
        }

        // Reference to the tokens collection for the specified user
        const tokensRef = admin.firestore().collection(`users/${userId}/tokens`);

        // Get all documents from the tokens collection
        const snapshot = await tokensRef.get();

        // Check if the snapshot is empty
        if (snapshot.empty) {
            return res.status(404).send('No tokens found for the user.');
        }

        // Extract registration tokens from documents
        const registrationTokens = snapshot.docs.map(doc => doc.id);

        // Construct the message to be sent
        const message = {
            data: {
                title: title,
                body: body,
                type: type,
                id: id
            }
        };

        // Iterate through each registration token and send a message
        registrationTokens.forEach((token) => {
            const tokenMessage = { ...message, token }; // Clone the message object and set the token
            fcm.send(tokenMessage)
                .then((response) => {
                    // Response is a message ID string.
                    console.log('Successfully sent message to token:', token, response);
                })
                .catch((error) => {
                    console.error('Error sending message to token:', token, error);
                });
        });

        res.status(200).send('Notifications sent successfully');
    } catch (error) {
        console.error('Error sending messages:', error);
        res.status(500).send('Error sending notification');
    }
});

// Expose Express API as a single Cloud Function:
exports.sendPushNotification = functions.https.onRequest(app);
