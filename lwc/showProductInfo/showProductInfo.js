/**
 * Created by mmangal on 03.11.25.
 * ShowProductInfo Component
 * This component displays product information based on the product ID and home country from a record page.
 *
 */
import {LightningElement, api, wire} from 'lwc';
import {getRecord} from 'lightning/uiRecordApi';
import getProductInfo from '@salesforce/apex/ShowProductInfoController.getProductInfo';

// Cross-object field references
const FIELDS = [
    'Case.Contact.Product__c',
    'Case.Contact.Home_Country__c'
];

export default class ShowProductInfo extends LightningElement {
    //Global recordId from Record Page
    @api recordId;

    //Local Variables
    isLoading = true;
    error = false;
    productInfoId = false;
    homeCountry = '';
    ProductName = '';

    /*Getters start*/

    /*Creating the Lightning Card Heading With Product Name and Country*/
    get ProductInfoHeading() {
        if (this.productInfoId) {
            return `Product Info (${this.ProductName || ''}${this.homeCountry ? ' - ' + this.homeCountry : ''})`;
        }
        return 'Product Info';
    }

    /*Getters End*/

    /* Standard getRecord Function to Get ProductId and HomeCountry Saving Apex Call
    *
    * */
    @wire(getRecord, {recordId: '$recordId', fields: FIELDS})
    wiredCase({data, error}) {
        if (data) {
            const productId = data?.fields?.Contact?.value?.fields?.Product__c?.value;
            this.homeCountry = data?.fields?.Contact?.value?.fields?.Home_Country__c?.value;

            //Get ProductInfo From ProductId and HomeCountry
            this.loadProductInfo(productId);
        } else if (error) {
            this.error = 'Error Fetching Product Or Home Country';
            console.error('Error in wiredCase:', error);
            this.homeCountry = false;
            this.isLoading = false;
        }
    }

    /* Async loadProductInfo to get the Product Info From Apex Explicit Calling
    *
    * */
    async loadProductInfo(productId) {
        if (!productId || !this.homeCountry) {
            this.error = 'Missing product or home country.';
            this.isLoading = false;
            return;
        }

        let result;
        try {
            result = await getProductInfo({
                productId,
                homeCountry: this.homeCountry
            });

            this.productInfoId = result.Id;
            this.ProductName = result.Product__r.Name;
            this.error = undefined;
        } catch (error) {
            this.error = 'Error fetching product info';
            console.error('Error in loadProductInfo:', error);
        } finally {
            if (!result) {
                this.error = 'No product data found.';
            }
            this.isLoading = false;
        }
    }
}