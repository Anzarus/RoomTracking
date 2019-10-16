/**
 * Created by AntonAntoniuk on 16.10.2019.
 */

@IsTest
private class MeetingParticipatorsComponentTest {
    @TestSetup
    static void createSetupData() {
        UnitOfWork unitOfWork = new UnitOfWork(new Set<SObjectType>{
                User.SObjectType,
                Room__c.SObjectType,
                Meeting__c.SObjectType,
                Participator__c.SObjectType
        });

        Profile profile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Standard User'
                LIMIT 1
        ];
        List<User> users = new List<User>();
        for (Integer i = 0; i < 2; i++) {
            User testUser = new User(FirstName = 'Carl', LastName = 'Robinson', Alias = 'Robi', Email = 'antonantonuk1999@gmail.com',
                    Username = 'testUserProject1@gmail.com' + Datetime.now().getTime(), CommunityNickname = 'testUser' + i,
                    EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                    TimeZoneSidKey = 'America/Los_Angeles'
            );
            users.add(testUser);
            unitOfWork.addToInsert(testUser);
        }
        Room__c room = new Room__c(
                Room_Opens_at__c = Time.newInstance(8, 0, 0, 0),
                Room_Closes_at__c = Time.newInstance(19, 0, 0, 0)
        );
        unitOfWork.addToInsert(room);

        Meeting__c meeting = new Meeting__c(
                Starts_at__c = Time.newInstance(9, 0, 0, 0),
                Ends_at__c = Time.newInstance(10, 0, 0, 0),
                When__c = Date.today().addMonths(1)
        );
        unitOfWork.addToInsert(meeting, Meeting__c.Room__c, room);
        unitOfWork.commitWork();

        unitOfWork = new UnitOfWork(new Set<SObjectType>{
                Participator__c.SObjectType
        });
        for (Integer i = 0; i < 2; i++) {
            Participator__c participator = new Participator__c(
                    Meeting__c = meeting.Id,
                    User__c = users[i].Id
            );
            unitOfWork.addToInsert(participator);
        }
        unitOfWork.commitWork();
    }

    @IsTest
    static void testGetParticipators() {
        List<Participator__c> participators = [
                SELECT User__c
                FROM Participator__c
        ];
        Map<Id, Participator__c> participatorsByUser = new Map<Id, Participator__c>();
        for (Participator__c participator : participators) {
            participatorsByUser.put(participator.User__c, participator);
        }

        List<User> expectedUsers = [
                SELECT Id, LastName, FirstName
                FROM User
                WHERE Id IN :participatorsByUser.keySet()
        ];

        Meeting__c meeting = [
                SELECT Id
                FROM Meeting__c
        ];
        List<User> resultUsers = MeetingParticipatorsComponentController.getParticipators(meeting.Id);

        System.assertEquals(expectedUsers, resultUsers);
    }

    @IsTest
    static void testCreateLogParticipators() {
        Meeting__c meeting = [
                SELECT Id
                FROM Meeting__c
        ];
        MeetingParticipatorsComponentController.createLogParticipators(meeting.Id);

        System.assertEquals(
                [SELECT Id FROM Participator__c].size(),
                [SELECT Id FROM Meeting_Participators_Log__c].size()
        );
    }

    @IsTest
    static void testDeleteAllParticipators() {
        Meeting__c meeting = [SELECT Id FROM Meeting__c];
        MeetingParticipatorsComponentController.deleteAllParticipators(meeting.Id);

        System.assertEquals(0, [SELECT Id FROM Participator__c].size());
    }

    @IsTest
    static void testDeleteParticipator() {
        Participator__c participator = [
                SELECT User__c
                FROM Participator__c
                LIMIT 1
        ];
        User user = [
                SELECT Id
                FROM User
                WHERE Id = :participator.User__c
        ];

        Meeting__c meeting = [SELECT Id FROM Meeting__c];
        MeetingParticipatorsComponentController.deleteParticipator(user.Id, meeting.Id);

        System.assertEquals(1, [SELECT Id FROM Participator__c].size());
    }
}