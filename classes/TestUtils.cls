/**
 * Created by mmangal on 05.11.25.
 * Test Utils Class
 */
@IsTest
public with sharing class TestUtils {

    /**
     * Creates a Contact record for test Data
     */
    public static List<Contact> createContactWithUUID(
            Integer count,
            Map<String, Object> additionalFields
    ) {
        if (count == null || count <= 0) {
            count = 1;
        }

        List<Contact> contactList = new List<Contact>();

        for (Integer i = 0; i < count; i++) {
            Contact con = new Contact(
                    FirstName = 'TestFirst' + i,
                    LastName = 'TestLast' + i,
                    Email = 'test' + i + '@example.com',
                    Phone = '123456789' + i,
                    UUID__c = 'UUID-' + String.valueOf(Crypto.getRandomInteger())
            );

            // Apply any additional field values dynamically
            if (additionalFields != null && !additionalFields.isEmpty()) {
                for (String fieldName : additionalFields.keySet()) {
                    try {
                        con.put(fieldName, additionalFields.get(fieldName));
                    } catch (Exception e) {
                        System.debug('Skipping invalid field: ' + fieldName + ' (' + e.getMessage() + ')');
                    }
                }
            }

            contactList.add(con);
        }

        return contactList;
    }

    /**
 * Creates a Product_Info__c record for test Data
 */
    public static List<Product_Info__c> createProductInfo(
            Integer count,
            Map<String, Object> additionalFields
    ) {
        if (count == null || count <= 0) {
            count = 1;
        }

        List<Product_Info__c> productInfoList = new List<Product_Info__c>();

        for (Integer i = 0; i < count; i++) {
            // Retrieve productId and homeCountry from the additional fields map
            Id productId = (Id) additionalFields.get('productId');
            String homeCountry = (String) additionalFields.get('homeCountry');

            if (productId == null || homeCountry == null) {
                throw new IllegalArgumentException('productId and homeCountry must be provided in the additionalFields map.');
            }

            Product_Info__c productInfo = new Product_Info__c(
                    Product__c = productId,
                    HomeCountry__c = homeCountry,
                    Name = 'Test Product Info ' + i,
                    CostPerCalendarMonth__c = 10.0,
                    ATMFeeInOtherCurrencies__c = 5.0,
                    CardReplacementCost__c = 20.0
            );

            // Apply any additional field values dynamically
            if (additionalFields != null && !additionalFields.isEmpty()) {
                for (String fieldName : additionalFields.keySet()) {
                    if (fieldName != 'productId' && fieldName != 'homeCountry') { // Skip already processed fields
                        try {
                            productInfo.put(fieldName, additionalFields.get(fieldName));
                        } catch (Exception e) {
                            System.debug('Skipping invalid field: ' + fieldName + ' (' + e.getMessage() + ')');
                        }
                    }
                }
            }

            productInfoList.add(productInfo);
        }

        return productInfoList;
    }

    /**
* Creates a Product2 record for test Data
*/
    public static Product2 createProduct(String name, Map<String, Object> additionalFields) {
        Product2 product = new Product2(Name = name);

        // Apply any additional field values dynamically
        if (additionalFields != null && !additionalFields.isEmpty()) {
            for (String fieldName : additionalFields.keySet()) {
                try {
                    product.put(fieldName, additionalFields.get(fieldName));
                } catch (Exception e) {
                    System.debug('Skipping invalid field: ' + fieldName + ' (' + e.getMessage() + ')');
                }
            }
        }

        // Return the created Product2 record (not inserted)
        return product;
    }

    /**
     * Utility to return a random UUID that does not exist
     */
    public static String getNonExistingUUID() {
        return 'UUID-' + String.valueOf(Crypto.getRandomInteger());
    }
}