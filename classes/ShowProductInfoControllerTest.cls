/**
 * Test class for ShowProductInfoController
 *
 * Created by mmangal on 05.11.25.
 */
@IsTest
public with sharing class ShowProductInfoControllerTest {

    @TestSetup
    static void setupTestData() {
        // Create a Contact record
        Contact contact = TestUtils.createContactWithUUID(1, new Map<String, Object>{
        })[0];
        insert contact;

        // Create a Product record (Product2)
        Product2 product = TestUtils.createProduct('Test Product', new Map<String, Object>{
                'ProductCode' => '12345'
        });
        insert product;

        // Create Product_Info__c record using TestUtils, passing productId and homeCountry in the map
        Map<String, Object> additionalFields = new Map<String, Object>{
                'productId' => product.Id,
                'homeCountry' => 'DE',
                'CostPerCalendarMonth__c' => 12.0
        };
        List<Product_Info__c> productInfos = TestUtils.createProductInfo(1, additionalFields);
        insert productInfos;

        // Create a Case record and associate it with the Contact and Product
        Case testCase = new Case(
                ContactId = contact.Id,
                Status = 'New',
                Product__c = product.Id
        );
        insert testCase;
    }

    /**
     * Test case: valid case where product info is found
     */
    @IsTest
    static void testGetProductInfo_ValidData() {
        Product2 product = [SELECT Id, Name FROM Product2 WHERE ProductCode = '12345' LIMIT 1];

        Test.startTest();
        Product_Info__c result = ShowProductInfoController.getProductInfo(product.Id, 'DE');
        Test.stopTest();

        // Assertions
        System.assertNotEquals(null, result, 'Product info should be returned');
        System.assertEquals('Test Product Info 0', result.Name, 'Product Info name should match');
        System.assertEquals(12.0, result.CostPerCalendarMonth__c, 'CostPerCalendarMonth__c should be correct');
    }

    /**
     * Test when no matching product info is found
     */
    @IsTest
    static void testGetProductInfo_NoMatchingData() {
        // Create a product (but no Product_Info__c record) in @TestSetup
        Product2 product = [SELECT Id, Name FROM Product2 WHERE ProductCode = '12345' LIMIT 1];

        // Call the Apex method
        Test.startTest();
        Product_Info__c result = ShowProductInfoController.getProductInfo(product.Id, 'USA');
        Test.stopTest();

        // Assert that no product info was found (result should be null)
        System.assertEquals(null, result, 'Expected no product info to be found');
    }
}
