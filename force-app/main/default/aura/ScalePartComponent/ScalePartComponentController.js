/**
 * Created by AntonAntoniuk on 11.10.2019.
 */

({
  doInit: function(cmp, event, helper) {
    helper.formScale(cmp, helper);
    helper.getOwnerOfMeeting(cmp, helper);
  },

  showMeeting:function(cmp, event, helper) {
    helper.showRecord(cmp.get("v.meeting.Id"));
  },

  showOwner:function(cmp, event, helper) {
    helper.showRecord(cmp.get("v.owner.Id"));
  },

  link:function(cmp, event, helper) {

  }
});