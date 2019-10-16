/**
 * Created by AntonAntoniuk on 16.10.2019.
 */

public with sharing class SendNotificationAboutMeetingChanges {

    @Future
    public static void sendEmails(Set<Id> meetingIds) {
        List<Meeting__c> meetings = [
                SELECT CreatedBy.Name
                FROM Meeting__c
                WHERE Id IN :meetingIds
        ];

        Map<Id, List<Meeting_Participators_Log__c>> participatorsLogsByMeetingIds = getParticipatorsLogsByMeetingIds(meetingIds);

        EmailTemplate emailTemplate = [SELECT Id FROM EmailTemplate WHERE Name = 'Notification about changing' LIMIT 1];

        List<Messaging.SingleEmailMessage> emailMessages = new List<Messaging.SingleEmailMessage >();
        for (Meeting__c meeting : meetings) {
            if (participatorsLogsByMeetingIds.get(meeting.Id) == null
                    || participatorsLogsByMeetingIds.get(meeting.Id).isEmpty()) {
                continue;
            }

            for (Meeting_Participators_Log__c meetingParticipatorsLog : participatorsLogsByMeetingIds.get(meeting.Id)) {
                Messaging.SingleEmailMessage emailMessage = Messaging.renderStoredEmailTemplate(
                        emailTemplate.Id, meetingParticipatorsLog.User__c, meeting.Id
                );

                emailMessage.setSenderDisplayName(meeting.CreatedBy.Name);
                emailMessage.setSaveAsActivity(false);
                emailMessages.add(emailMessage);

                System.debug(emailMessage);
            }
        }
        if (!emailMessages.isEmpty()) {
            Messaging.sendEmail(emailMessages);
        }
    }

    private static Map<Id, List<Meeting_Participators_Log__c>> getParticipatorsLogsByMeetingIds(Set<Id> meetingIds) {
        List<Meeting_Participators_Log__c> meetingParticipatorsLogs = [
                SELECT User__c, Meeting__c
                FROM Meeting_Participators_Log__c
                WHERE Meeting__c IN :meetingIds AND IsDeleted__c = FALSE
        ];

        Map<Id, List<Meeting_Participators_Log__c>> participatorsLogsByMeetingIds = new Map<Id, List<Meeting_Participators_Log__c>>();

        for (Meeting_Participators_Log__c meetingParticipatorsLog : meetingParticipatorsLogs) {
            if (!participatorsLogsByMeetingIds.containsKey(meetingParticipatorsLog.Meeting__c)) {
                participatorsLogsByMeetingIds.put(
                        meetingParticipatorsLog.Meeting__c,
                        new List<Meeting_Participators_Log__c>()
                );
            }
            participatorsLogsByMeetingIds.get(meetingParticipatorsLog.Meeting__c).add(meetingParticipatorsLog);
        }
        return participatorsLogsByMeetingIds;
    }
}