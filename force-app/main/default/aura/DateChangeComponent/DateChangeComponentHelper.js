/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  setTodayData: function(cmp, helper) {
    const today = new Date();
    const date = helper.stringDateFormat(today);
    cmp.find("dateInput").set("v.value", date);
    helper.fireChangeDateEvent(cmp);
  },

  setUpdatedData: function(cmp, helper, update) {
    const currentDate = cmp.find("dateInput").get("v.value");
    const newData = new Date(currentDate);
    const date = newData.setDate(newData.getDate() + update);
    cmp.find("dateInput").set("v.value", helper.stringDateFormat(date));
    helper.fireChangeDateEvent(cmp);
  },

  stringDateFormat: function(date) {
    const stringDate = new Date(date);
    return stringDate.getFullYear() +
      "-" + (stringDate.getMonth() + 1) +
      "-" + stringDate.getDate();
  },

  fireChangeDateEvent : function(cmp) {
    const cmpEvent = cmp.getEvent("currentDateEvent");
    cmpEvent.setParams({
      "currentDate": cmp.find("dateInput").get("v.value").toString()
    });
    cmpEvent.fire();
  }
});