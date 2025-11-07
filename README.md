# ShowProductInfo LWC and ContactUUIDLookupRestService

This project is an integration of **Lightning Web Component (LWC)** and **Apex REST Service** on Salesforce. The `ShowProductInfo` LWC is used to display detailed product information on a **Case record page**. It fetches the relevant product details (like cost, fees, and currency) related to the **Contact** associated with the case. Additionally, the **ContactUUIDLookupRestService** class is a REST service that retrieves contact records based on a given **UUID**.

## Features

- **ShowProductInfo LWC**: Displays product-related information (cost per calendar month, ATM fee, card replacement cost, and other currencies) on the case record page.
- **ContactUUIDLookupRestService**: An Apex REST service to retrieve contacts associated with a given UUID.
- **Integration**: Fetches the **Product Info** related to the **Product** and **Home Country** associated with the **Contact** on the case record.

## Architecture

1. **ShowProductInfo LWC**:
   - Retrieves the **Contact** associated with the Case record.
   - From the Contact, it retrieves the **Product at Home Country**.
   - Fetches the related **Product Info** records based on the **Home Country** and **Product**.
   - Displays the following product-related information:
     - Cost per calendar month
     - ATM fee
     - Card replacement cost
     - Other currencies
     
2. **ContactUUIDLookupRestService**:
   - A REST service in Apex that takes a **UUID** as a parameter.
   - It retrieves the **Contacts** associated with the provided UUID and returns relevant data.

## Installation

### Prerequisites

- A **Salesforce** developer account or sandbox instance.
- Basic understanding of **Salesforce LWC** and **Apex**.

### Steps

1. **Clone the repository**:
   git clone https://github.com/manu45mangal/DemoRepo.git
   cd DemoRepo
