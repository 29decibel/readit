Feature: Readability api access
  In order to fetch all informations of users' readability 
  As a api user
  I want full access information of readability

Scenario: create api client
  Given the user's access_token and the access_secret
  And set consumer_key and consumer_secret to Readit::Config  
  When call new of Readit
  Then get the api client

Scenario: config the Readit api
  Given set test_consumer_key and test_consumer_secret to Readit::Config 
  When get consumer_key and consumer_secret from Readit::Config
  Then get config values of test_consumer_key and test_consumer_secret








  
