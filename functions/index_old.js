const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./childfree-connection-firebase-adminsdk-bhabb-3828cb5e17.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const fcm = admin.messaging();
const messaging = admin.messaging(); // Fixed typo here

exports.sendPushNotification = functions.https.onRequest(async (req, res) => {
    try {
        // Extract userId from request body
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

        const notification = {
            title: title,
            body: body,
            image: 'https://firebasestorage.googleapis.com/v0/b/childfree-connection.appspot.com/o/FCMImages%2Fcfc_logo.png?alt=media&token=099593e8-c462-40f2-b0b0-a1941de77a9e'
        };

        const messages = [];
        registrationTokens.forEach((child) => {
            console.log(child);
            messages.push({ token: child, notification: notification });
        });

        // Send messages and handle responses
        const sendPromises = messages.map((message) => {
            const payload = {
                token: message.token,
                notification: message.notification
            };
            return fcm.send(payload).then((response) => {
                console.log("Successfully sent message: " + message.token, response);
                return { success: true };
            });
        });

        // Wait for all messages to be sent
        await Promise.all(sendPromises);

        console.log("All messages sent successfully.");
        return res.status(200).send('Messages sent successfully.');

    } catch (error) {
        console.error('Error sending messages:', error);
        res.status(500).send('Error sending notification');
    }
});
