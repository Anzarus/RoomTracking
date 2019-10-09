/**
 * Created by AntonAntoniuk on 09.10.2019.
 */

trigger MeetingTrigger on Meeting__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            new MeetingTriggerHandler().checkIsDateAndTimeAreFree(Trigger.new);
        }
    }
}