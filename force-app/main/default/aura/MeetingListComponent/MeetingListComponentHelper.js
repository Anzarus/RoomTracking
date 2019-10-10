/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  getRoomAndTodayMeetings: function(cmp) {
    const roomId = cmp.get("v.recordId");
    const requestCmp = cmp.find("requestCmp");

    requestCmp.requestPromise(
      "getCurrentRoom",
      { roomId }
    ).then(function(result) {
      cmp.set("v.Room", result);
    });
  }
});