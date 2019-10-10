/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  setToday: function(cmp, event, helper) {
    helper.setTodayData(cmp, helper);
  },

  setTomorrow: function(cmp, event, helper) {
    helper.setUpdatedData(cmp, helper, 1);
  },

  setYesterday: function(cmp, event, helper) {
    helper.setUpdatedData(cmp, helper, -1);
  },

  fireSendDateEvent: function(cmp, event, helper) {
    helper.fireChangeDateEvent(cmp);
  }
});