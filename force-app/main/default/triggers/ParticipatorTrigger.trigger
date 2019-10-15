/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

trigger ParticipatorTrigger on Participator__c (before insert, before update, after delete) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            new ParticipatorTriggerHandler().checkUnique(Trigger.new);
        }
        if (Trigger.isUpdate) {
            new ParticipatorTriggerHandler().blockUpdate();
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isDelete) {
            new ParticipatorTriggerHandler().logDeleting(Trigger.old);
        }
    }
}