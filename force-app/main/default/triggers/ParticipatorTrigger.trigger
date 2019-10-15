/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

trigger ParticipatorTrigger on Participator__c (before insert, before update) {
    if (Trigger.isBefore) {
        if (Trigger.isInsert) {
            new ParticipatorTriggerHandler().checkUnique(Trigger.new);
        }
        if (Trigger.isUpdate) {
            new ParticipatorTriggerHandler().blockUpdate();
        }
    }

}