## Bayonet [![Build Status](https://travis-ci.org/bayonetio/bayonet-ruby.svg)](https://travis-ci.org/bayonetio/bayonet-ruby)
Bayonet enables companies to feed and consult a global database about online consumers’ reputation, based on historic payments. Start making smarter business decisions today.

### Introduction
Bayonet’s API is organized around REST and exposes endpoints for HTTP requests. It is designed to have predictable, resource-oriented URLs and uses standard HTTP response codes to indicate the outcome of operations. Request and response payloads are formatted as JSON.

### About the service
Bayonet provides an Ecosystem of Trust and Protection where companies can colaborate with each other to combat online fraud together. We provide a secure platform to share and consult data to understand when a consumer is related to fraudulent activity or has a fraud-free record. Different technologies that run algorithms to link parameters seen in different transactions, fed by companies connected to the ecosystem are employed in order to build consumer profiles. By consulting Bayonet’s API, a response with data provided by companies themselves is available in real-time for your risk assesment process to analyze it and take better decisions.

### Bayonet's API details
The examples shown in this README are only for demonstration of the functionality of this SDK. For the detailed integration flow, and when to send which API call, please refer to the Bayonet [API documentation](https://bayonet.io/console/docs).

## Getting started
To use this SDK, please make sure:
  * You have Ruby 2.0 or superior installed on your system.
  * You have an API KEY (sandbox and/or live) generated on your Bayonet console.
  * Install the 'bayonet_client' package on your system
  
    ```sh
    gem install bayonet_client
    ```
    Or if you want to build the gem from source:
    
    ```sh
    gem build bayonet_client.gemspec
    ```
    If you are using Bundler, add this to your Gemfile:
    ```sh
    gem 'bayonet_client'
    ```
  * Require 'bayonet_client' in your file

    ```ruby
    require 'bayonet_client'
    ```
  * Set up your configuration, with parameters (api_key, api_version). The latest stable API version is '2'

    ```ruby
    BayonetClient.configure(api_key, api_version)
    ```
    
## Usage
Once you have Bayonet's SDK configured, you can call the APIs with the following syntax.Follow the guidelines specific to the product you are integrating:

* [Ecommerce](#ecommerce)

* [Lending](#lending)

### Ecommerce

* Consult API
  
    ```ruby
    BayonetClient::Ecommerce.consult({
        channel: 'ecommerce',
        email: 'example@bayonet.io',
        consumer_name: 'Example name',
        consumer_internal_id: '<your internal ID for this consumer>',
        cardholder_name: 'Example name',
        telephone: '1234567890',
        card_number: '4111111111111111',
        transaction_amount: 999.00,
        currency_code: 'MXN',
        shipping_address: {
            line_1: 'example line 1',
            line_2: 'example line 2',
            city: 'Mexico City',
            state: 'Mexico DF',
            country: 'MEX',
            zip_code: '64000'
        },
        billing_address: {
            line_1: 'example line 1',
            line_2: 'example line 2',
            city: 'Mexico City',
            state: 'Mexico DF',
            country: 'MEX',
            zip_code: '64000'
        },
        payment_method: 'card',
        order_id: '<your internal ID for this order (mandatory)>',
        transaction_id: '<your internal ID for this transaction (optional)>',
        payment_gateway: 'stripe',
        coupon: 'discount_buen_fin',
        expedited_shipping: true,
        products: [
           {
            "product_id": "1",
            "product_name": "product_1",
            "product_price": 500.00,
            "product_category":"example category"
           },
           {
            "product_id": "2",
            "product_name": "product_2",
            "product_price": 499.00,
            "product_category":"example category"
           }
        ],
        bayonet_fingerprint_token: '<token generated by Bayonet fingerprinting JS'
    })
    ```
* Update Transaction API
  
    ```ruby
    BayonetClient::Ecommerce.update-transaction({
        order_id: '<your internal ID for this order (as sent in the consult step)>',
        transaction_id: '<your internal ID for this transaction (as sent in the consult step)>',
        bayonet_tracking_id: '<tracking ID returned by the API in the consult step>',
        transaction_status: 'success',
        ...
    })
    # please note that you can use either one of 'order_id', 'transaction_id', or 'bayonet_tracking_id' to update the status of a transaction
    ```
* Feedback-historical API
  
    ```ruby
    BayonetClient::Ecommerce.feedback_historical({
        channel: 'ecommerce',
        email: 'example@bayonet.io',
        consumer_name: 'Example name',
        consumer_internal_id: '<your internal ID for this consumer>',
        cardholder_name: 'Example name',
        telephone: '1234567890',
        card_number: '4111111111111111',
        transaction_amount: 999.00,
        currency_code: 'MXN',
        shipping_address: {
            line_1: 'example line 1',
            line_2: 'example line 2',
            city: 'Mexico City',
            state: 'Mexico DF',
            country: 'MEX',
            zip_code: '64000'
        },
        billing_address: {
            line_1: 'example line 1',
            line_2: 'example line 2',
            city: 'Mexico City',
            state: 'Mexico DF',
            country: 'MEX',
            zip_code: '64000'
        },
        payment_method: 'card',
        transaction_time: 1476012879,
        payment_gateway: 'stripe',
        coupon: 'discount_buen_fin',
        expedited_shipping: true,
        products: [
           {
            "product_id": "1",
            "product_name": "product_1",
            "product_price": 500.00,
            "product_category":"example category"
           },
           {
            "product_id": "2",
            "product_name": "product_2",
            "product_price": 499.00,
            "product_category":"example category"
           }
        ],
        transaction_status: 'success',
        transaction_id: '<your internal ID for this transaction>'
    })
    ```
    
### Lending
* Report Transaction (Request for loan received)
  
    ```ruby
    BayonetClient::Lending.report_transaction({
        email: 'example@bayonet.io',
        consumer_name: 'Example name',
        consumer_internal_id: '<your internal ID for this consumer>',
        telephone_fixed: '1234567890',
        telephone_mobile: '1234567891',
        telephone_reference_1: '1234567892',
        telephone_reference_2: '1234567893',
        telephone_reference_3: '1234567894',
        rfc: 'Example RFC',
        curp: 'Example CURP',
        address: {
            line_1: 'example line 1',
            line_2: 'example line 2',
            city: 'Mexico City',
            state: 'Mexico DF',
            country: 'MEX',
            zip_code: '64000'
        },
        bayonet_fingerprint_token: '<token generated by Bayonet fingerprinting JS',
        transaction_category: 'p2p_lending',
        transaction_id: '<your internal ID for this transaction>',
        transaction_time: 1476012879
    })
    ```
    
* Report Transaction (Request for loan received) + Consult 

   This lets you report a transaction (solicitud) and consult Bayonet at the same time. The only difference from the above method (Report Transaction) is that this method will also return a consult response

    ```ruby
    BayonetClient::Lending.report_transaction_and_consult({
        email: 'example@bayonet.io',
        consumer_name: 'Example name',
        consumer_internal_id: '<your internal ID for this consumer>',
        telephone_fixed: '1234567890',
        telephone_mobile: '1234567891',
        telephone_reference_1: '1234567892',
        telephone_reference_2: '1234567893',
        telephone_reference_3: '1234567894',
        rfc: 'Example RFC',
        curp: 'Example CURP',
        address: {
            line_1: 'example line 1',
            line_2: 'example line 2',
            city: 'Mexico City',
            state: 'Mexico DF',
            country: 'MEX',
            zip_code: '64000'
        },
        bayonet_fingerprint_token: '<token generated by Bayonet fingerprinting JS',
        transaction_category: 'p2p_lending',
        transaction_id: '<your internal ID for this transaction>',
        transaction_time: 1476012879
    })
    ```
* Consult (consult the persona present in the transaction)
 
    ```ruby
    BayonetClient::Lending.consult({
        transaction_id: '<transaction ID that you used when reporting the transaction or solicitud>'
    })
    ```
* Feedback (send feedback regarding a transaction - raise alert or block the user)
 
   ```ruby
    BayonetClient::Lending.feedback({
        transaction_id: '<transaction ID that you used when reporting the transaction or solicitud>',
        actions: {
          alert: true,
          block: true
        }
    })
    ```
* Feedback historical (for reporting historical transactions that were not sent to Bayonet)
  
    ```ruby
    BayonetClient::Lending.feedback_historical({
        email: 'example@bayonet.io',
        consumer_name: 'Example name',
        consumer_internal_id: '<your internal ID for this consumer>',
        telephone_fixed: '1234567890',
        telephone_mobile: '1234567891',
        telephone_reference_1: '1234567892',
        telephone_reference_2: '1234567893',
        telephone_reference_3: '1234567894',
        rfc: 'Example RFC',
        curp: 'Example CURP',
        address: {
            line_1: 'example line 1',
            line_2: 'example line 2',
            city: 'Mexico City',
            state: 'Mexico DF',
            country: 'MEX',
            zip_code: '64000'
        },
        transaction_category: 'p2p_lending',
        transaction_id: '<your internal ID for this transaction>',
        transaction_time: 1476012879,
        actions: {
          alert: true,
          block: false
        }
    })
    ```
### Device Fingerprint
* Get-fingerprint-data API

   You can use this endpoint to get detailed information about a fingerprint generated by the Bayonet fingerprinting JS installed on your front-end
  
    ```ruby
    BayonetClient::DeviceFingerprint.get_fingerprint_data({
        bayonet_fingerprint_token: '<fingerprint-token-generated-by-JS-snippet>'
    })
    ``` 
 
## Error handling
Bayonet's SDK raises exceptions both when confguring the client object and executing functions:
```ruby
begin
    BayonetClient.configure(api_key, api_version)
rescue BayonetClient::BayonetError => e
  puts e.reason_code
  puts e.reason_message
end

begin
    BayonetClient::Ecommerce.consulting(params)
rescue BayonetClient::BayonetError => e
  puts e.reason_code
  puts e.reason_message
end
```

For a full list of error codes and their messages, please refer to the Bayonet [API documentation](https://bayonet.io/console/docs).

## Testing
You can run the test suite with the following command (Make sure you set `api_key` and `api_version` environment variables):
```sh
bundle exec rake
```
