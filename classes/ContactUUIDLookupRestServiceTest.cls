/**
 * Created by mmangal on 05.11.25.
 *
 * @description
 * Unit tests for ContactUUIDLookupRestService and its related helper classes:
 * - ContactLookupService
 * - RestResponseUtil
 */
@IsTest
public class ContactUUIDLookupRestServiceTest {

    /**
     * Helper method to set up a mock REST context.
     */
    private static void setupRestContext(String uri) {
        RestContext.request = new RestRequest();
        RestContext.response = new RestResponse();
        RestContext.request.requestURI = uri;
        RestContext.request.httpMethod = 'GET';
    }

    /**
     * Test case: Verify 200 OK response when a Contact is found.
     */
    @IsTest
    static void testSuccess() {
        List<Contact> cons = TestUtils.createContactWithUUID(1, null);
        insert cons;
        Contact c = cons[0];

        setupRestContext('/services/apexrest/contacts/byUUID/' + c.UUID__c);
        Test.startTest();
        ContactUUIDLookupRestService.getContactByUUID();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode);
        System.assert(RestContext.response.responseBody.toString().contains(c.UUID__c));
    }

    /**
    * Test case: Verify 400 Bad Request when UUID is missing from the URL.
    */
    @IsTest
    static void testMissingUUID() {
        setupRestContext('/services/apexrest/contacts/byUUID/');
        Test.startTest();
        ContactUUIDLookupRestService.getContactByUUID();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode);
    }

    /**
     * Test case: Verify 404 Not Found when no Contact matches the given UUID.
     */
    @IsTest
    static void testNotFound() {
        String uuid = TestUtils.getNonExistingUUID();
        setupRestContext('/services/apexrest/contacts/byUUID/' + uuid);
        Test.startTest();
        ContactUUIDLookupRestService.getContactByUUID();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode);
    }

    /**
     * Test case: Verify 500 Internal Server Error when unexpected exception occurs.
     */
    @IsTest
    static void testException() {
        RestContext.request = null;
        RestContext.response = new RestResponse();

        Test.startTest();
        ContactUUIDLookupRestService.getContactByUUID();
        Test.stopTest();

        System.assertEquals(500, RestContext.response.statusCode);
    }

    /**
     * Test case: Verify that ContactLookupService correctly finds a Contact by UUID.
     */
    @IsTest
    static void testFindByUUID() {
        List<Contact> cons = TestUtils.createContactWithUUID(1, null);
        insert cons;
        Contact c = cons[0];

        Test.startTest();
        Contact contactRec = ContactLookupService.findByUUID(c.UUID__c);
        Test.stopTest();

        System.assertEquals(c.Id, contactRec.Id);
    }

    /**
     * Test case: Verify ContactLookupService returns null when no Contact matches the UUID.
     */
    @IsTest
    static void testFindByUUID_NotFound() {
        Test.startTest();
        Contact contactRec = ContactLookupService.findByUUID(TestUtils.getNonExistingUUID());
        Test.stopTest();

        System.assertEquals(null, contactRec);
    }

    /**
 * Test case: Verify RestResponseUtil methods set response codes and bodies correctly.
 */
    @IsTest
    static void testRestResponseUtil() {
        RestResponse res = new RestResponse();

        RestResponseUtil.sendSuccess(res, new Map<String, Object>{
                'Name' => 'Test12345'
        }, 200);
        System.assertEquals(200, res.statusCode);

        RestResponseUtil.sendError(res, 400, 'Bad Request');
        System.assertEquals(400, res.statusCode);
    }

    /**
 * Test case: Verify bulk Contact creation and field override behavior in TestUtils.
 */
    @IsTest
    static void testBulkContactCreation() {
        Map<String, Object> extra = new Map<String, Object>{
                'Title' => 'Engineer'
        };
        List<Contact> cons = TestUtils.createContactWithUUID(3, extra);
        System.assertEquals(3, cons.size());
        System.assertEquals('Engineer', cons[0].get('Title'));
    }
}
