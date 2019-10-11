/**
 * Created by AntonAntoniuk on 09.10.2019.
 */

trigger MeetingTrigger on Meeting__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            new MeetingTriggerHandler().checkIsDateAndTimeAreFreeOnInsert(Trigger.new);
        }
        if (Trigger.isUpdate) {
            new MeetingTriggerHandler().checkIsDateAndTimeAreFreeOnUpdate(Trigger.new);
        }
    }
}