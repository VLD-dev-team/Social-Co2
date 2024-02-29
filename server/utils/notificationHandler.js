const { executeQuery } = require('./utils/database.js');

const handleNewNotification = async (io, notificationData) => {
    const { userID, notificationContent } = notificationData;

    // On émet la notification à l'utilisateur concerné via Socket.io
    io.to(userID).emit('newNotification', { notificationContent });

    // Mettre à jour le statut de la notification dans la base de données
    const updateNotificationQuery = `UPDATE notifications SET notificationStatus = 'send' WHERE userID = ? AND notificationContent = ?`;
    await executeQuery(updateNotificationQuery, [userID, notificationContent]);
};

const watchNotifications = async (io) => {
    const notificationWatcherQuery = `SELECT * FROM notifications WHERE notificationStatus = 'unread'`;

    const watcher = executeQuery(notificationWatcherQuery);

    watcher.on('result', async (result) => {
        // Chaque fois qu'il y a une nouvelle notification non lue, on gère la notification
        const notificationData = {
            userID: result.userID,
            notificationContent: result.notificationContent
        };
        handleNewNotification(io, notificationData);
    });
};

module.exports = {
    handleNewNotification,
    watchNotifications
};
