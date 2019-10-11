/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  getRoomAndTodayMeetings: function(cmp) {
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
    const currDate = event.getParam("currentDate");
    cmp.set("v.currentDate", currDate);

    const roomId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "getCurrentDayMeetings",
      { currDate: currDate, roomId: roomId }
    ).then(function(result) {
      cmp.set("v.TodayMeetings", result);
    });
  }
});