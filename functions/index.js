const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.checkEmailAndSendReset = functions.https.onCall(async (data, context) => {
  const email = data.email;

  // Check if email exists in Firestore
  const snapshot = await admin.firestore().collection('CareTakers')
    .where('email', '==', email).get();

  if (snapshot.empty) {
    throw new functions.https.HttpsError('not-found', 'Email not found');
  }

  // Generate password reset link
  await admin.auth().generatePasswordResetLink(email);

  return { success: true };
});
