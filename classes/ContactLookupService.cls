/**
 * Created by mmangal on 03.11.25.
 *
 * @description
 * Service class to look up a Contact record by its custom UUID__c field.
 * Provides a method to query the Contact object and return the matching record.
 */
public with sharing class ContactLookupService {

    /**
     * @description
     * Finds a Contact record based on the provided UUID__c field.
     *
     * @param uuid The UUID value to search for in the Contact's UUID__c field.
     * @return Contact The Contact record that matches the provided UUID, or null if no match is found.
     */
    public static Contact findByUUID(String uuid) {
        if (String.isBlank(uuid)) return null;

        List<Contact> contacts = new List<Contact>();

        //Check If Contact Object is Accessible
        if (Schema.sObjectType.Contact.isAccessible()) {
            //Query Contact By UUID
            contacts = [
                    SELECT Id, FirstName, LastName, Email, Phone, UUID__c
                    FROM Contact
                    WHERE UUID__c = :uuid
                    WITH SECURITY_ENFORCED
                    LIMIT 1
            ];
        }

        //Returns Contact If Found
        return contacts.isEmpty() ? null : contacts[0];
    }
}
