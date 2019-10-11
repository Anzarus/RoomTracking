/**
 * Created by AntonAntoniuk on 11.10.2019.
 */

({
  formScale: function(cmp, helper) {
    const startTime = cmp.get("v.startTime");
    const size = cmp.get("v.size");
    const timeScaleDivision = 900000; //15 min

    let scaleDivisions = [];
    for (let i = 0; i < size; i++) {
      if (i % 2 === 0) {
        scaleDivisions.push(helper.msToTime(startTime + timeScaleDivision * i));
      } else {
        scaleDivisions.push("");
      }
    }
    cmp.set("v.TimeScaleDivisions", scaleDivisions);
  },

  msToTime: function(s) {
    const ms = s % 1000;
    s = (s - ms) / 1000;
    const secs = s % 60;
    s = (s - secs) / 60;
    const mins = s % 60;
    const hrs = (s - mins) / 60;

    let result = hrs + ":" + mins;
    if (mins === 0) {
      result += "0";
    }
    if (hrs < 10) {
      result = "0" + result;
    }
    return result;
  }
});