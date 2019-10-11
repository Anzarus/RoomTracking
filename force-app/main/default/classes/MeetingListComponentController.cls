/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

public with sharing class MeetingListComponentController {

    @AuraEnabled
    public static Room__c getCurrentRoom(String Id) {
        return [
                SELECT Room_Closes_at__c,
                        Room_Opens_at__c
                FROM Room__c
                WHERE Id = :Id
        ];
    }

    @AuraEnabled
    public static List<Meeting__c> getCurrentDayMeetings(String currDate, String roomId) {
        return [
                SELECT Name,
                        Starts_at__c,
                        Ends_at__c,
                        CreatedById
                FROM Meeting__c
                WHERE When__c = :Date.valueOf(currDate) AND Room__c = :roomId
                ORDER BY Starts_at__c
        ];
    }
}