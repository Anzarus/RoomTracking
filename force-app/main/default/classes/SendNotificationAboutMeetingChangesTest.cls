/**
 * Created by AntonAntoniuk on 16.10.2019.
 */

@IsTest
private class SendNotificationAboutMeetingChangesTest {
    @TestSetup
    static void createTestData() {
        UnitOfWork unitOfWork = new UnitOfWork(new Set<SObjectType>{
                User.SObjectType,
                Room__c.SObjectType,
                Meeting__c.SObjectType
        });

        List<User> users = new List<User>();
        List<Meeting__c> meetings = new List<Meeting__c>();
        Profile profile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Standard User'
                LIMIT 1
        ];

        Time roomOpenTime = Time.newInstance(8, 0, 0, 0);
        Time roomCloseTime = Time.newInstance(18, 0, 0, 0);

        Room__c room = new Room__c(Room_Opens_at__c = roomOpenTime, Room_Closes_at__c = roomCloseTime);
        unitOfWork.addToInsert(room);

        for (Integer i = 0; i < 5; i++) {
            Meeting__c meeting = new Meeting__c(
                    When__c = Date.today().addMonths(1),
                    Starts_at__c = Time.newInstance(8 + i * 2, 0, 0, 0),
                    Ends_at__c = Time.newInstance(8 + i * 2, 30, 0, 0));
            meetings.add(meeting);
            unitOfWork.addToInsert(meeting, Meeting__c.Room__c, room);

            for (Integer j = 0; j < 2; j++) {
                User testUser = new User(FirstName = 'Carl', LastName = 'Robinson', Alias = 'Robi', Email = 'antonantonuk1999@gmail.com',
                        Username = 'testUserProject1@gmail.com' + Datetime.now().getTime() + i + j, CommunityNickname = 'testUser' + i + j,
                        EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                        TimeZoneSidKey = 'America/Los_Angeles'
                );
                users.add(testUser);
                unitOfWork.addToInsert(testUser);
            }
        }
        unitOfWork.commitWork();

        unitOfWork = new UnitOfWork(new Set<SObjectType>{
                Meeting_Participators_Log__c.SObjectType
        });
        for (Integer i = 0; i < users.size(); i++) {
            Meeting_Participators_Log__c participator = new Meeting_Participators_Log__c(
                    Meeting__c = meetings[Math.mod(i, 5)].Id,
                    User__c = users[i].Id,
                    IsDeleted__c = false
            );
            unitOfWork.addToInsert(participator);
        }
        unitOfWork.commitWork();
    }

    @IsTest
    private static void testBehaviourToSend() {
        List<Meeting__c> meetings = [SELECT Id FROM Meeting__c];
        Set<Id> meetingIds = new Set<Id>();
        for (Meeting__c meeting : meetings) {
            meetingIds.add(meeting.Id);
        }

        Test.startTest();

        SendNotificationAboutMeetingChanges.sendEmails(meetingIds);
        Integer invocations = Limits.getEmailInvocations();

        Test.stopTest();

        System.assertEquals(10, invocations, 'Emails have been sent!');//todo
    }
}
