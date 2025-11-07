/**
 * Created by mmangal on 03.11.25.
 *
 * REST service to look up a Contact record by its custom UUID__c field.
 * Endpoint: /services/apexrest/contacts/byUUID/{uuid}
 */
@RestResource(urlMapping='/contacts/byUUID/*')
global with sharing class ContactUUIDLookupRestService {

    /**
         * @description
         * HTTP GET method to retrieve a Contact record by UUID__c.
         *
         * Example usage:
         *   GET /services/apexrest/contacts/byUUID/1234
         *
         * Expected behavior:
         *   - Returns 400 if the UUID is missing.
         *   - Returns 404 if no Contact is found for the given UUID.
         *   - Returns 200 with Contact data if found.
         *   - Returns 500 if an unexpected server error occurs.
         */
    @HttpGet
    global static void getContactByUUID() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;

        try {
            // Extract UUID from the URL path (everything after the last '/')
            String uuid = req?.requestURI?.substringAfterLast('/');

            // Validate input and ensure uuid is not Blank
            if (String.isBlank(uuid)) {
                RestResponseUtil.sendError(res, 400, 'Missing UUID parameter.');
                return;
            }

            //santize Input
            String sanitizedUUId = uuid.escapeHtml4().trim();

            //Call the Service Class to find Contact
            Contact foundContact = ContactLookupService.findByUUID(sanitizedUUId);

            //Return 404 when no Contact Found
            if (foundContact == null) {
                RestResponseUtil.sendError(res, 404, 'No contact found for the provided UUID.');
                return;
            }

            //Send Success response along with Contact
            RestResponseUtil.sendSuccess(res, foundContact, 200);

        } catch (Exception e) {
            //In case any other exception occurs
            RestResponseUtil.sendError(res, 500, 'Unexpected error: ' + e.getMessage());
        }
    }
}
