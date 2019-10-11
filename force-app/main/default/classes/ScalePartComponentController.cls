/**
 * Created by AntonAntoniuk on 11.10.2019.
 */

public with sharing class ScalePartComponentController {

    @AuraEnabled
    public static User getOwnerInfo(String ownerId) {
        return [
                SELECT LastName,
                        FirstName
                FROM User
                WHERE Id = :ownerId
        ];
    }
}