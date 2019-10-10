/**
 * Created by AntonAntoniuk on 09.10.2019.
 */

@IsTest
private class MeetingTriggerHandlerTest {
    @TestSetup
    static void createMeetingsAndRooms() {
        UnitOfWork unitOfWork = new UnitOfWork(new Set<SObjectType>{
                Room__c.SObjectType,
                Meeting__c.SObjectType
        });

        Room__c room;
        Time roomOpenTime = Time.newInstance(8, 0, 0, 0);
        Time roomCloseTime = Time.newInstance(18, 0, 0, 0);
        Meeting__c meeting;
        for (Integer i = 0; i < 10; i++) {
            room = new Room__c(Room_Opens_at__c = roomOpenTime, Room_Closes_at__c = roomCloseTime);
            unitOfWork.addToInsert(room);
            for (Integer j = 0; j < 5; j++) {
                meeting = new Meeting__c(
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(8 + j * 2, 0, 0, 0),
                        Ends_at__c = Time.newInstance(8 + j * 2, 30, 0, 0));
                unitOfWork.addToInsert(meeting, Meeting__c.Room__c, room);
            }
        }
        unitOfWork.commitWork();
    }

    @IsTest
    static void testCorrectSettingMeeting() {
        Room__c room = [
                SELECT Id
                FROM Room__c
                LIMIT 1
        ];

        List<Meeting__c> meetings = new List<Meeting__c>{
                new Meeting__c(
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(8, 30, 0, 0),
                        Ends_at__c = Time.newInstance(9, 0, 0, 0),
                        Room__c = room.Id
                ),

                new Meeting__c(
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(9, 0, 0, 0),
                        Ends_at__c = Time.newInstance(10, 0, 0, 0),
                        Room__c = room.Id
                ),

                new Meeting__c(
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(15, 0, 0, 0),
                        Ends_at__c = Time.newInstance(15, 30, 0, 0),
                        Room__c = room.Id
                )
        };
        insert meetings;

        System.assertEquals(53, [SELECT Id FROM Meeting__c WHERE When__c = :Date.today().addMonths(1)].size());
        System.assertEquals(8, [SELECT Id FROM Meeting__c WHERE Room__c = :room.Id].size());
    }

    @IsTest
    static void testSettingMeetingInsideExistMeetingTime() {
        Room__c room = [
                SELECT Id
                FROM Room__c
                LIMIT 1
        ];

        Meeting__c meeting = new Meeting__c
                (
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(8, 15, 0, 0),
                        Ends_at__c = Time.newInstance(8, 30, 0, 0),
                        Room__c = room.Id
                );
        Boolean dmlFail = false;
        try {
            insert meeting;
        } catch (DmlException e) {
            dmlFail = true;
        }
        System.assertEquals(true, dmlFail, 'You should choose another time cause it`s busy!');
    }

    @IsTest
    static void testSettingMeetingOutsideExistMeetingTime() {
        Room__c room = [
                SELECT Id
                FROM Room__c
                LIMIT 1
        ];

        Meeting__c meeting = new Meeting__c
                (
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(9, 45, 0, 0),
                        Ends_at__c = Time.newInstance(10, 45, 0, 0),
                        Room__c = room.Id
                );
        Boolean dmlFail = false;
        try {
            insert meeting;
        } catch (DmlException e) {
            dmlFail = true;
        }
        System.assertEquals(true, dmlFail, 'You should choose another time cause it`s busy!');
    }

    @IsTest
    static void testSettingMeetingWithEndCollisionWithExistMeetingTime() {
        Room__c room = [
                SELECT Id
                FROM Room__c
                LIMIT 1
        ];

        Meeting__c meeting = new Meeting__c
                (
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(9, 15, 0, 0),
                        Ends_at__c = Time.newInstance(10, 10, 0, 0),
                        Room__c = room.Id
                );
        Boolean dmlFail = false;
        try {
            insert meeting;
        } catch (DmlException e) {
            dmlFail = true;
        }
        System.assertEquals(true, dmlFail, 'You should choose another time cause it`s busy!');
    }

    @IsTest
    static void testSettingMeetingWithStartCollisionWithExistMeetingTime() {
        Room__c room = [
                SELECT Id
                FROM Room__c
                LIMIT 1
        ];

        Meeting__c meeting = new Meeting__c
                (
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(8, 15, 0, 0),
                        Ends_at__c = Time.newInstance(8, 45, 0, 0),
                        Room__c = room.Id
                );

        Boolean dmlFail = false;
        try {
            insert meeting;
        } catch (DmlException e) {
            dmlFail = true;
        }
        System.assertEquals(true, dmlFail, 'You should choose another time cause it`s busy!');
    }

    @IsTest
    static void testSettingMeetingAtTheSameExistMeetingTime() {
        Room__c room = [
                SELECT Id
                FROM Room__c
                LIMIT 1
        ];

        Meeting__c meeting = new Meeting__c
                (
                        When__c = Date.today().addMonths(1),
                        Starts_at__c = Time.newInstance(8, 0, 0, 0),
                        Ends_at__c = Time.newInstance(8, 30, 0, 0),
                        Room__c = room.Id
                );
        Boolean dmlFail = false;
        try {
            insert meeting;
        } catch (DmlException e) {
            dmlFail = true;
        }
        System.assertEquals(true, dmlFail, 'You should choose another time cause it`s busy!');
    }
}