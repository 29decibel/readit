Feature: Readability api access
  In order to fetch all informations of users' readability 
  As a api user
  I want full access information of readability


Scenario: create api client
  Given the user's access_token and the access_secret
  And set consumer_key and consumer_secret to Readit::Config  
  When call new of Readit
  Then get the api client


Scenario: get top 20 bookmarks
  Given the readit api client
  When call bookmarks
  Then got 20 bookmarks back

Scenario: get any number bookmarks with option
  Given the readit api client
  When call bookmarks with option per_page 42
  Then got 42 bookmarks back




  
