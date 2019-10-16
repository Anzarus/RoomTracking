/**
 * Created by AntonAntoniuk on 16.10.2019.
 */

@IsTest
private class ParticipatorTriggerHandlerTest {
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
    }

    @IsTest
    static void testCorrectInsert() {
        List<User> users = [
                SELECT Id
                FROM User
                WHERE FirstName = 'Carl'
        ];

        Meeting__c meeting = [
                SELECT Id
                FROM Meeting__c
        ];

        List<Participator__c> participators = new List<Participator__c>();
        for (User user : users) {
            participators.add(new Participator__c(
                    Meeting__c = meeting.Id,
                    User__c = user.Id
            ));
        }
        insert participators;

        System.assertEquals(2, [SELECT Id FROM Participator__c].size());
    }

    @IsTest
    static void testExceptionOnExistRecord() {
        User user = [
                SELECT Id
                FROM User
                WHERE FirstName = 'Carl'
                LIMIT 1
        ];

        Meeting__c meeting = [
                SELECT Id
                FROM Meeting__c
        ];

        insert new Participator__c(
                Meeting__c = meeting.Id,
                User__c = user.Id
        );

        Boolean exceptionScope;
        try {
            insert new Participator__c(
                    Meeting__c = meeting.Id,
                    User__c = user.Id
            );
        } catch (Exception e) {
            exceptionScope = true;
        }
        System.assertEquals(true, exceptionScope);
    }

    @IsTest
    static void testBlockUpdate() {
        User user = [
                SELECT Id
                FROM User
                WHERE FirstName = 'Carl'
                LIMIT 1
        ];

        Meeting__c meeting = [
                SELECT Id
                FROM Meeting__c
        ];

        Participator__c participator = new Participator__c(
                Meeting__c = meeting.Id,
                User__c = user.Id
        );
        insert participator;

        participator.User__c = user.Id;
        Boolean exceptionScope;
        try {
            exceptionScope = false;
            update participator;
        } catch (Exception e) {
            exceptionScope = true;
        }
        System.assertEquals(true, exceptionScope);
    }

    @IsTest
    static void testDeletingParticipatorsAndLogThis() {
        testCorrectInsert();

        List<Participator__c> participators = [
                SELECT Id, User__c, Meeting__c
                FROM Participator__c
        ];

        List<Meeting_Participators_Log__c> meetingParticipatorsLogs = new List<Meeting_Participators_Log__c>();
        for (Participator__c participator : participators) {
            meetingParticipatorsLogs.add(new Meeting_Participators_Log__c(
                    User__c = participator.User__c,
                    Meeting__c = participator.Meeting__c
            ));
        }

        insert meetingParticipatorsLogs;

        delete participators;

        System.assertEquals(0, [SELECT Id FROM Participator__c].size());
        System.assertEquals(2, [
                SELECT Id
                FROM Meeting_Participators_Log__c
                WHERE IsDeleted__c = TRUE
        ].size());
    }
}