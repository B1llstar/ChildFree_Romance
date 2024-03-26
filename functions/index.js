const functions = require("firebase-functions");
const admin = require("firebase-admin");
const serviceAccount = require("./childfree-connection-firebase-adminsdk-bhabb-3828cb5e17.json");

admin.initializeApp({
  credential: admin.credential.cert(serviceAccount),
});

const db = admin.firestore();
const fcm = admin.messaging();

exports.sendPushNotification = functions.https.onRequest(async (req, res) => {
    try {
        // Extract userId from request body
        const { userId, title, body, type, id} = req.body;
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

            notification: {
            priority: "high",
                title: title,
                body: body
            },
            data: {
                type: type,
                id: id
            },

        };

        // Send the message to each registration token
        const sendPromises = registrationTokens.map((token) => {
            return fcm.sendToDevice(token, message)
                .then((response) => {
                    // Handle successful response
                    console.log('Successfully sent message to token:', token, response);
                    return { token: token, success: true };
                })
                .catch((error) => {
                    // Handle error
                    console.error('Error sending message to token:', token, error);
                    return { token: token, success: false, error: error };
                });
        });

        // Wait for all messages to be sent
        await Promise.all(sendPromises);

        res.status(200).send('Notifications sent successfully');
    } catch (error) {
        console.error('Error sending messages:', error);
        res.status(500).send('Error sending notification');
    }
});
