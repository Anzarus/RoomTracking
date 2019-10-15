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

    public void logDeleting(List<Participator__c> deletedParticipators) {
        Set<Id> meetingIds = new Set<Id>();
        Set<Id> userIds = new Set<Id>();

        for (Participator__c participator : deletedParticipators) {
            meetingIds.add(participator.Meeting__c);
            userIds.add(participator.User__c);
        }

        List<Meeting_Participators_Log__c> participatorsLogs = [
                SELECT Id, IsDeleted__c
                FROM Meeting_Participators_Log__c
                WHERE User__c = :userIds AND Meeting__c = :meetingIds
        ];

        for (Meeting_Participators_Log__c meetingParticipatorsLog : participatorsLogs) {
            meetingParticipatorsLog.IsDeleted__c = true;
        }

        update participatorsLogs;
    }

    private class ParticipatorTriggerHandlerException extends Exception {
    }
}