/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

({
  getParticipators: function(cmp) {
    const meetingId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "getParticipators",
      { meetingId: meetingId }
    ).then(function(result) {
      cmp.set("v.Participators", result);
      if (result.length !== 0)
        cmp.set("v.isNotEmpty", true);
    });
  },

  sendMeetingIdToLogPartitions: function(cmp) {
    const meetingId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "createLogParticipators",
      { meetingId: meetingId }
    ).then(function() {
      const toastCmp = cmp.find("toastCmp");
      toastCmp.showToast("Success", "Emails have been sent!", "success");
    });
  },

  deleteAllParticipators: function(cmp) {
    const meetingId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "deleteAllParticipators",
      { meetingId: meetingId }
    ).then(function() {
      $A.get("e.force:refreshView").fire();
      cmp.set("v.isNotEmpty", false);
    });
  },

  handleDeleteEvent: function(cmp, event, helper) {
    const userId = event.getParam("userId");
    const meetingId = cmp.get("v.recordId");

    helper.deleteUser(cmp, userId, meetingId);
  },

  deleteUser: function(cmp, userId, meetingId) {
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "deleteParticipator",
      { userId: userId, meetingId: meetingId }
    ).then(function() {
      $A.get("e.force:refreshView").fire();
      cmp.set("v.isNotEmpty", false);
    });
  }
});