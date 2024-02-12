class Activity {
    constructor(ActivityID, userID) {
        this.activityID = activityID,
        this.userID = userID
    }

    async getActivity(activityID) {

        results = {activityID: 1, userID: 1};

        const activity = new Activity(results.activityID, results.userID);
        return {error: "", activity: activity};
    }
}