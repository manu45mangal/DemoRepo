/**
 * Created by mmangal on 03.11.25.
 *
 * @description
 * ShowProductInfoController Retrieves product information based on the product ID and home country.
 * @param productId The ID of the product for which information is needed.
 * @param homeCountry The home country associated with the product information.
 * @return The matching Product_Info__c record.
 */
public with sharing class ShowProductInfoController {

    @AuraEnabled
    public static Product_Info__c getProductInfo(String productId, String homeCountry) {
        if (String.isBlank(productId) || String.isBlank(homeCountry)) {
            throw new AuraHandledException('Product Id or Home Country cannot be blank.');
        }
        List<Product_Info__c> ProductInfos = new List<Product_Info__c>();

        //Check If Product_Info__c Object is Accessible
        if (Schema.sObjectType.Product_Info__c.isAccessible()) {
            ProductInfos = [
                    SELECT Id,
                            Name,
                            CostPerCalendarMonth__c,
                            Product__r.Name,
                            ATMFeeInOtherCurrencies__c,
                            CardReplacementCost__c,
                            HomeCountry__c
                    FROM Product_Info__c
                    WHERE Product__c = :productId
                    AND HomeCountry__c = :homeCountry
                    WITH SECURITY_ENFORCED
                    LIMIT 1
            ];
        } else {
            throw new AuraHandledException('Access to Product Info is restricted');
        }

        return (ProductInfos.isEmpty()) ? null : ProductInfos[0];
    }
}
