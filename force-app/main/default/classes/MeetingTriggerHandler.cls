/**
 * Created by AntonAntoniuk on 09.10.2019.
 */

public with sharing class MeetingTriggerHandler {
    public MeetingTriggerHandler() {
    }

    public void checkIsDateAndTimeAreFree(List<Meeting__c> newMeetings) {
        Set<Date> meetingsDays = new Set<Date>();

        for (Meeting__c newMeeting : newMeetings) {
            if (!meetingsDays.contains(newMeeting.When__c)) {
                meetingsDays.add(newMeeting.When__c);
            }
        }

        List<Meeting__c> existMeetings = [
                SELECT Starts_at__c, Ends_at__c, When__c
                FROM Meeting__c
                WHERE When__c = :meetingsDays
        ];

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
                    if (newMeeting.Starts_at__c < existMeeting.Ends_at__c) {
                        throw new MeetingException('You should choose another time cause it`s busy!');
                    } else if (newMeeting.Ends_at__c > existMeeting.Starts_at__c) {
                        throw new MeetingException('You should choose another time cause it`s busy!');
                    } else if (newMeeting.Starts_at__c > existMeeting.Starts_at__c
                            && newMeeting.Ends_at__c < existMeeting.Ends_at__c) {
                        throw new MeetingException('You should choose another time cause it`s busy!');
                    } else if (newMeeting.Starts_at__c < existMeeting.Starts_at__c
                            && newMeeting.Ends_at__c > existMeeting.Ends_at__c) {
                        throw new MeetingException('You should choose another time cause it`s busy!');
                    }
                }
            }
        }
    }

    class MeetingException extends Exception {
    }
}