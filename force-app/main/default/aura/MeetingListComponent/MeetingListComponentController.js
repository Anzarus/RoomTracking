/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  doInit: function(cmp, event, helper) {
    helper.getRoom(cmp);
  },

  handleDateEvent:function(cmp, event, helper) {
    helper.getMeetingsForCurrentDate(cmp, event);
  }
});