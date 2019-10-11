/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  formFreeAndBusyTime: function(cmp, helper) {
    const timeBegin = cmp.get("v.RoomOpensAt");
    const timeEnd = cmp.get("v.RoomClosesAt");
    const timeScaleDivision = 900000; //15 min
    const meetings = cmp.get("v.TodayMeetings");

    let partsOfScale = [];

    const meetingsByStartTime = helper.formMeetingsByStartTime(meetings);

    for (let i = timeBegin; i < timeEnd;) {
      let partOfScale = { isMeeting: false, size: 0, startTime: i };
      if (meetingsByStartTime.has(i)) {
        i = this.setMeetingCmp(i, meetingsByStartTime, timeScaleDivision, partOfScale);
      } else {
        i = this.setFreeTime(meetingsByStartTime, i, timeEnd, timeScaleDivision, partOfScale);
      }
      partsOfScale.push(partOfScale);
    }

    cmp.set("v.parts", partsOfScale);
  },

  formMeetingsByStartTime: function(meetings) {
    let meetingsByStartTime = new Map();
    for (let i = 0; i < meetings.length; i++) {
      meetingsByStartTime.set(meetings[i].Starts_at__c, meetings[i]);
    }
    return meetingsByStartTime;
  },

  setMeetingCmp: function(i, meetingsByStartTime, timeScaleDivision, partOfScale) {
    let counter = 0;
    let meetingStartAt = i;
    while (i < meetingsByStartTime.get(meetingStartAt).Ends_at__c) {
      counter++;
      i += timeScaleDivision;
    }
    partOfScale.isMeeting = true;
    partOfScale.size = counter;
    return i;
  },

  setFreeTime: function(meetingsByStartTime, i, timeEnd, timeScaleDivision, partOfScale) {
    let counter = 0;
    while (!meetingsByStartTime.has(i) && i < timeEnd) {
      counter++;
      i += timeScaleDivision;
    }
    partOfScale.isMeeting = false;
    partOfScale.size = counter;
    return i;
  }
});