/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

public with sharing class ParticipatorTriggerHandler {

    public ParticipatorTriggerHandler() {
    }

    public void checkUnique(List<Participator__c> newParticipators) {
        Set<Id> meetingIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();

        for (Participator__c participator : newParticipators) {
            meetingIds.add(participator.Meeting__c);
            userIds.add(participator.User__c);
        }

        List<Participator__c> existParticipators = [
                SELECT Id
                FROM Participator__c
                WHERE Meeting__c IN :meetingIds
                AND User__c IN :userIds
        ];
        if (!existParticipators.isEmpty()) {
            throw new ParticipatorTriggerHandlerException('This record exists!');
        }
    }

    public void blockUpdate() {
        throw new ParticipatorTriggerHandlerException('You could not update this record!');
    }

    private class ParticipatorTriggerHandlerException extends Exception {
    }
}