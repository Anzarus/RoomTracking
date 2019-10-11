/**
 * Created by AntonAntoniuk on 10.10.2019.
 */

({
  formScale: function(cmp, helper) {
    const timeBegin = cmp.get("v.RoomOpensAt");
    const timeEnd = cmp.get("v.RoomClosesAt");
    const timeScaleDivision = 900000; //15 min
    const meetings = cmp.get("v.TodayMeetings");

    let partsOfScale = [];

    const meetingsByStartTime = helper.formMeetingsByStartTime(meetings);

    for (let i = timeBegin; i < timeEnd;) {
      console.log(i);
      let partOfScale = { isMeeting: false, size: 0 };
      if (meetingsByStartTime.has(i)) {
        let counter = 0;
        let meetingStartAt = i;
        while (i < meetingsByStartTime.get(meetingStartAt).Ends_at__c) {
          counter++;
          i += timeScaleDivision;
        }
        partOfScale.isMeeting = true;
        partOfScale.size = counter;
      } else {
        let counter = 0;
        while (!meetingsByStartTime.has(i) && i < timeEnd) {
          counter++;
          i += timeScaleDivision;
          console.log(counter + ":" + i);
        }
        console.log(i);
        partOfScale.isMeeting = false;
        partOfScale.size = counter;
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
  }
});