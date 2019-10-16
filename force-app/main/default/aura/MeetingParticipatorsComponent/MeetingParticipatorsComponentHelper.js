/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

({
  getParticipators: function(cmp) {
    const meetingId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");
    const toastCmp = cmp.find("toastCmp");

    requestCmp.requestPromise(
      "getParticipators",
      { meetingId: meetingId }
    ).then(function(result) {
      cmp.set("v.Participators", result);
      if (result.length !== 0)
        cmp.set("v.isNotEmpty", true);
    }).catch(function(errors) {
      let errorMessage = errors[0].message;
      toastCmp.showToast("Error", errorMessage, "error");
    });
  },

  sendMeetingIdToLogPartitions: function(cmp) {
    const meetingId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");
    const toastCmp = cmp.find("toastCmp");

    requestCmp.requestPromise(
      "createLogParticipators",
      { meetingId: meetingId }
    ).then(function() {
      toastCmp.showToast("Success", "Emails have been sent!", "success");
    }).catch(function(errors) {
      let errorMessage = errors[0].message;
      toastCmp.showToast("Error", errorMessage, "error");
    });
  },

  deleteAllParticipators: function(cmp) {
    const meetingId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");
    const toastCmp = cmp.find("toastCmp");

    requestCmp.requestPromise(
      "deleteAllParticipators",
      { meetingId: meetingId }
    ).then(function() {
      $A.get("e.force:refreshView").fire();
      cmp.set("v.isNotEmpty", false);
    }).catch(function(errors) {
      let errorMessage = errors[0].message;
      toastCmp.showToast("Error", errorMessage, "error");
    });
  },

  handleDeleteEvent: function(cmp, event, helper) {
    const userId = event.getParam("userId");
    const meetingId = cmp.get("v.recordId");

    helper.deleteUser(cmp, userId, meetingId);
  },

  deleteUser: function(cmp, userId, meetingId) {
    const requestCmp = cmp.find("requestCmp");
    const toastCmp = cmp.find("toastCmp");

    requestCmp.requestPromise(
      "deleteParticipator",
      { userId: userId, meetingId: meetingId }
    ).then(function() {
      $A.get("e.force:refreshView").fire();
      cmp.set("v.isNotEmpty", false);
    }).catch(function(errors) {
      let errorMessage = errors[0].message;
      toastCmp.showToast("Error", errorMessage, "error");
    });
  }
});