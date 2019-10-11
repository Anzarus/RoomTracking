/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  getRoom: function(cmp) {
    const roomId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "getCurrentRoom",
      { Id: roomId }
    ).then(function(result) {
      cmp.set("v.Room", result);
      cmp.set("v.renderScale", true);
    });
  },

  getMeetingsForCurrentDate: function(cmp, event) {
    if (cmp.get("v.renderScale") === true) {
      cmp.set("v.renderScale", false);
    }
    const currDate = event.getParam("currentDate");
    cmp.set("v.currentDate", currDate);

    const roomId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "getCurrentDayMeetings",
      { currDate: currDate, roomId: roomId }
    ).then(function(result) {
      cmp.set("v.TodayMeetings", result);
      if (cmp.get("v.renderScale") === false) {
        cmp.set("v.renderScale", true);
      }
    });
  }
});