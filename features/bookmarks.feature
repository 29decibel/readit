Feature: Get bookmarks infos
  In order to get bookmarks infos
  As a api user
  I want get and change bookmarks information
  
Scenario: get top 20 bookmarks
  Given the readit api client
  When call bookmarks
  Then got 20 bookmarks back

Scenario: get any number bookmarks with option
  Given the readit api client
  When call bookmarks with option per_page 42
  Then got 42 bookmarks back

Scenario: get 20 bookmarks before date added on sometime
  Given the readit api client
  When call bookmarks with option added_until 2011-12-12
  Then got the first bookmark's date should less than 2011-12-12

