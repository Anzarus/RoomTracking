/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

@IsTest
private class MeetingListComponentControllerTest {
    @TestSetup
    static void createMeetingsAndRooms() {
        UnitOfWork unitOfWork = new UnitOfWork(new Set<SObjectType>{
                Room__c.SObjectType,
                Meeting__c.SObjectType
        });

        Time roomOpenTime = Time.newInstance(8, 0, 0, 0);
        Time roomCloseTime = Time.newInstance(18, 0, 0, 0);

        Room__c room = new Room__c(Room_Opens_at__c = roomOpenTime, Room_Closes_at__c = roomCloseTime);
        unitOfWork.addToInsert(room);
        Meeting__c meeting;
        for (Integer j = 0; j < 5; j++) {
            meeting = new Meeting__c(
                    When__c = Date.today().addMonths(1),
                    Starts_at__c = Time.newInstance(8 + j * 2, 0, 0, 0),
                    Ends_at__c = Time.newInstance(8 + j * 2, 30, 0, 0));
            unitOfWork.addToInsert(meeting, Meeting__c.Room__c, room);
        }

        unitOfWork.commitWork();
    }

    @IsTest
    static void testBehaviorGettingRoomAndMeetings() {
        Room__c room = [
                SELECT Room_Closes_at__c,
                        Room_Opens_at__c
                FROM Room__c
        ];

        System.assertEquals(room, MeetingListComponentController.getCurrentRoom(room.Id));

        Date testDate = Date.today().addMonths(1);
        String testDateInString = testDate.year()
                + '-' + testDate.month()
                + '-' + testDate.day();

        List<Meeting__c> meetings = MeetingListComponentController.getCurrentDayMeetings(testDateInString, room.Id);
        System.assertEquals(5, meetings.size());
    }
}