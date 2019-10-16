/**
 * Created by AntonAntoniuk on 11.10.2019.
 */

({
  formScale: function(cmp, helper) {
    const startTime = cmp.get("v.startTime");
    const endTime = cmp.get("v.endTime");
    const size = cmp.get("v.size");

    let scaleDivisions = [];
    scaleDivisions.push(helper.msToTime(startTime));
    if (size > 1) {
      scaleDivisions.push("...");
    }
    scaleDivisions.push(helper.msToTime(endTime));

    cmp.set("v.TimeScaleDivisions", scaleDivisions);
  },

  msToTime: function(s) {
    const ms = s % 1000;
    s = (s - ms) / 1000;
    const secs = s % 60;
    s = (s - secs) / 60;
    const mins = s % 60;
    const hrs = (s - mins) / 60;

    let result = hrs + ":" + mins;
    if (mins === 0) {
      result += "0";
    }
    if (hrs < 10) {
      result = "0" + result;
    }
    return result;
  },

  getOwnerOfMeeting: function(cmp) {
    if (cmp.get("v.meeting") !== null) {
      const ownerId = cmp.get("v.meeting.CreatedById");
      const requestCmp = cmp.find("requestCmp");
      const toastCmp = cmp.find("toastCmp");

      requestCmp.requestPromise(
        "getOwnerInfo", { ownerId: ownerId }
      ).then(function(result) {
        cmp.set("v.owner", result);
      }).catch(function(errors) {
        let errorMessage = errors[0].message;
        toastCmp.showToast("Error", errorMessage, "error");
      });
    }
  },

  showRecord:function(recordId){
    const navigateEvent = $A.get("e.force:navigateToSObject");
    navigateEvent.setParams({
      "recordId":recordId
    });
    navigateEvent.fire();
  }
});