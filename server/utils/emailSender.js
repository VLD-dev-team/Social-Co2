const notificationHandler = require('../utils/notificationHandler.js');
const socketManager = require('../websocketHandler/socketManager.js');
const { executeQuery } = require('../utils/database.js');

const emailSender = async(userID) => {
    // Insertion de la notification dans la table notifications
    const notificationContent = `Avez-vous pensé à vider votre boîte mail ?`;
    const notificationTitle = 'Et votre boîte mail ?';
    const notificationStatus = 'unread';

    await executeQuery(`INSERT INTO notifications (userID, notificationContent, notificationTitle, notificationStatus) VALUES (?, ?, ?, ?) ;`, [userID, notificationContent, notificationTitle, notificationStatus]);

    // Émission de la notification via Socket.io
    const io = socketManager.getIO();
    notificationHandler.handleNewNotification(io, { userID: userID, notificationContent });
};

// Fonction pour envoyer une notification toutes les 24 heures
const sendNotificationDaily = (userID) => {
    emailSender(userID);

    setInterval(() => {
        emailSender(userID);
    }, 24 * 60 * 60 * 1000); // 24 heures en millisecondes
};

module.exports = sendNotificationDaily;
