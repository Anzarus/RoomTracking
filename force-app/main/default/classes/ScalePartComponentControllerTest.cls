/**
 * Created by AntonAntoniuk on 16.10.2019.
 */

@IsTest
private class ScalePartComponentControllerTest {
    @IsTest
    static void testBehavior() {
        Profile profile = [
                SELECT Id
                FROM Profile
                WHERE Name = 'Standard User'
                LIMIT 1
        ];
        User testUser = new User(FirstName = 'Carl', LastName = 'Robinson', Alias = 'Robi', Email = 'antonantonuk1999@gmail.com',
                Username = 'testUserProject1@gmail.com' + Datetime.now().getTime(), CommunityNickname = 'testUser',
                EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                TimeZoneSidKey = 'America/Los_Angeles'
        );
        insert testUser;

        User result = ScalePartComponentController.getOwnerInfo(testUser.Id);

        System.assertEquals(testUser.FirstName, result.FirstName);
        System.assertEquals(testUser.LastName, result.LastName);
    }
}