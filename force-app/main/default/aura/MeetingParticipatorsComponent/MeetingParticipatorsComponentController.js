/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

({
  doInit: function(cmp, event, helper) {
    helper.getParticipators(cmp);
  },

  logParticipators:function(cmp, event, helper) {
    helper.sendMeetingIdToLogPartitions(cmp);
  },

  clear:function(cmp, event, helper) {
    helper.deleteAllParticipators(cmp);
  },

  handleEvent:function(cmp, event, helper) {
    helper.handleDeleteEvent(cmp, event, helper);
  }
});