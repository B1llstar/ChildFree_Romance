const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

exports.sendNotificationOnMessage = functions.firestore
    .document('matches/{matchId}')
    .onUpdate(async (change, context) => {
        const matchId = context.params.matchId;
        const before = change.before.data();
        const after = change.after.data();

        // Check if the messages property is not null and has been added or updated
        if (after.messages && (!before.messages || before.messages.length < after.messages.length)) {
            const latestMessage = after.messages[after.messages.length - 1];
            const senderId = latestMessage.userId;
            const otherUserId = after.userIdSwipedFirst !== senderId ? after.userIdSwipedFirst : after.userIdSwipedSecond;

            try {
                const tokensSnapshot = await db.collection('users').doc(otherUserId).collection('tokens').get();
                const tokens = tokensSnapshot.docs.map(doc => doc.id);

                const payload = {
                    notification: {
                        title: 'New Message!',
                        body: `You have a new message from ${senderId}.`,
                        // Add more properties to the notification payload as needed
                    }
                };

                return fcm.sendToDevice(tokens, payload);
            } catch (error) {
                console.error('Error sending notification:', error);
                throw new Error('Error sending notification');
            }
        }

        return null;
    });
