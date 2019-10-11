/**
 * Created by AntonAntoniuk on 09.10.2019.
 */

public with sharing class MeetingTriggerHandler {
    public MeetingTriggerHandler() {
    }

    public void checkIsDateAndTimeAreFreeOnInsert(List<Meeting__c> newMeetings) {
        List<Meeting__c> existMeetings = getExistMeetings(newMeetings);

        Map<Date, List<Meeting__c>> existMeetingsByDates = new Map<Date, List<Meeting__c>>();
        for (Meeting__c existMeeting : existMeetings) {
            if (!existMeetingsByDates.containsKey(existMeeting.When__c)) {
                existMeetingsByDates.put(existMeeting.When__c, new List<Meeting__c>());
            }
            existMeetingsByDates.get(existMeeting.When__c).add(existMeeting);
        }

        for (Meeting__c newMeeting : newMeetings) {
            if (existMeetingsByDates.containsKey(newMeeting.When__c)) {
                for (Meeting__c existMeeting : existMeetingsByDates.get(newMeeting.When__c)) {
                    checkCollision(newMeeting, existMeeting);
                }
            }
        }
    }

    public void checkIsDateAndTimeAreFreeOnUpdate(List<Meeting__c> newMeetings) {
        List<Meeting__c> existMeetings = getExistMeetings(newMeetings);

        Map<Id, Meeting__c> newMeetingsByIds = new Map<Id, Meeting__c>(newMeetings);
        Map<Date, List<Meeting__c>> existMeetingsByDates = new Map<Date, List<Meeting__c>>();

        for (Meeting__c existMeeting : existMeetings) {
            if (newMeetingsByIds.containsKey(existMeeting.Id)) continue;
            if (!existMeetingsByDates.containsKey(existMeeting.When__c)) {
                existMeetingsByDates.put(existMeeting.When__c, new List<Meeting__c>());
            }
            existMeetingsByDates.get(existMeeting.When__c).add(existMeeting);
        }

        for (Meeting__c newMeeting : newMeetings) {
            if (existMeetingsByDates.containsKey(newMeeting.When__c)) {
                for (Meeting__c existMeeting : existMeetingsByDates.get(newMeeting.When__c)) {
                    if (newMeeting.Room__c == existMeeting.Room__c) {
                        checkCollision(newMeeting, existMeeting);
                    }
                }
            }
        }
    }

    private List<Meeting__c> getExistMeetings(List<Meeting__c> newMeetings) {
        Set<Date> meetingsDays = new Set<Date>();
        Set<Id> rooms = new Set<Id>();

        for (Meeting__c newMeeting : newMeetings) {
            meetingsDays.add(newMeeting.When__c);
            rooms.add(newMeeting.Room__c);
        }

        List<Meeting__c> existMeetings = [
                SELECT Starts_at__c, Ends_at__c, When__c, Room__c
                FROM Meeting__c
                WHERE When__c = :meetingsDays
                AND Room__c = :rooms
        ];
        return existMeetings;
    }

    private void checkCollision(Meeting__c newMeeting, Meeting__c existMeeting) {
        if (newMeeting.Starts_at__c < existMeeting.Starts_at__c
                && newMeeting.Ends_at__c > existMeeting.Starts_at__c) {
            throw new MeetingException('You should choose another time cause it`s busy!');
        } else if (newMeeting.Starts_at__c < existMeeting.Ends_at__c
                && newMeeting.Ends_at__c > existMeeting.Ends_at__c) {
            throw new MeetingException('You should choose another time cause it`s busy!');
        } else if (newMeeting.Starts_at__c >= existMeeting.Starts_at__c
                && newMeeting.Ends_at__c <= existMeeting.Ends_at__c) {
            throw new MeetingException('You should choose another time cause it`s busy!');
        }
    }

    @TestVisible
    class MeetingException extends Exception {
    }
}