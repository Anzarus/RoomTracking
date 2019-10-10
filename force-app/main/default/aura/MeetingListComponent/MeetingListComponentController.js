/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  doInit: function(cmp, event, helper) {
    helper.getRoomAndTodayMeetings(cmp);
  },

  handleDateEvent:function(cmp, event) {
    const currentDate = event.getParam("currentDate");
    cmp.set("v.currentDate", currentDate);
  }
});