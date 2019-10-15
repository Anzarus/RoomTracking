/**
 * Created by AntonAntoniuk on 15.10.2019.
 */

({
  fireEvent: function(cmp) {
    const cmpEvent = cmp.getEvent("deleteUserFromParticipators");
    cmpEvent.setParams({
      "userId": cmp.get("v.participator.Id")
    });
    cmpEvent.fire();
  }
});
