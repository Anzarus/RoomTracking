/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

public with sharing class MeetingParticipatorsComponentController {

    @AuraEnabled
    public static List<User> getParticipators(String meetingId) {
        List<Participator__c> participators = [
                SELECT User__r.Id, User__r.LastName, User__r.FirstName
                FROM Participator__c
                WHERE Meeting__c = :meetingId
        ];

        List<User> resultUsers = new List<User>();
        for (Participator__c participator : participators) {
            resultUsers.add(new User(
                    Id = participator.User__r.Id,
                    LastName = participator.User__r.LastName,
                    FirstName = participator.User__r.FirstName));
        }
        return resultUsers;
    }

    @AuraEnabled
    public static void createLogParticipators(String meetingId) {
        List<Participator__c> participators = [
                SELECT User__c, Meeting__c
                FROM Participator__c
                WHERE Meeting__c = :meetingId
        ];

        List<Meeting_Participators_Log__c> participatorsLogs = new List<Meeting_Participators_Log__c>();
        for (Participator__c participator : participators) {
            participatorsLogs.add(new Meeting_Participators_Log__c(
                    Meeting__c = participator.Meeting__c,
                    User__c = participator.User__c,
                    IsDeleted__c = false
            ));
        }
        System.debug(participatorsLogs);
        insert participatorsLogs;
        System.debug([
                SELECT User__c, Meeting__c, IsDeleted__c
                FROM Meeting_Participators_Log__c
                WHERE Meeting__c = :meetingId
        ]);
    }

    @AuraEnabled
    public static void deleteAllParticipators(String meetingId) {
        delete [
                SELECT User__c
                FROM Participator__c
                WHERE Meeting__c = :meetingId
        ];
    }

    @AuraEnabled
    public static void deleteParticipator(String userId, String meetingId) {
        delete [
                SELECT Id
                FROM Participator__c
                WHERE Meeting__c = :meetingId AND User__c = :userId
        ];
    }
}