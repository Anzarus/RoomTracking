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
}