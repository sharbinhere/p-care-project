/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */




// Start writing functions
// https://firebase.google.com/docs/functions/typescript

// export const helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
import * as functions from "firebase-functions/v2";
import * as admin from "firebase-admin";
import * as logger from "firebase-functions/logger";

admin.initializeApp();

export const deleteAuthUser = functions.firestore.onDocumentDeleted(
  "Patients/{patientId}",
  async (event) => {
    const snap = event.data;
    if (!snap) {
      logger.error("❌ No data found in the deleted document.");
      return;
    }

    const deletedPatient = snap.data() as { uid?: string };
    const userId = deletedPatient?.uid;

    if (userId) {
      try {
        await admin.auth().deleteUser(userId);
        logger.info(`✅ Successfully deleted user: ${userId}`);
      } catch (error) {
        logger.error(`❌ Error deleting user ${userId}:`, error);
      }
    }
  }
);

