Feature: Get bookmarks infos
  In order to get bookmarks infos
  As a api user
  I want get and change bookmarks information
  
Background:
  Given the readit api client

Scenario: get top 20 bookmarks
  When call bookmarks
  Then got 20 bookmarks back

Scenario: get any number bookmarks with option
  When call bookmarks with option per_page 42
  Then got 42 bookmarks back

Scenario: get 20 bookmarks before date added on sometime
  When call bookmarks with option added_until 2011-12-12
  Then got the first bookmark's date should less than 2011-12-12

Scenario: get only favorite bookmarks
  When call bookmarks with option favorite 1
  Then got any number of bookmarks which marked favorite 

Scenario: get one bookmark by providing bookmark_id
  Given get latest bookmarks
  When call bookmarks with bookmark_id of the lastest one
  Then got one right bookmark with the same id

Scenario: update bookmark info
  Given the readit api client
  And call bookmarks
  When call update_bookmark latest bookmark_id with options favorite 1
  Then got bookmark's favorite set to true

Scenario: archive bookmark by id
  Given the readit api client
  When call archive with bookmark_id
  Then got bookmark's archive set to true

Scenario: user can add and delete bookmark
  Given the readit api client
  When add bookmark with url http://google.com
  Then got status ok
  When fetch the latest bookmark
  Then got the bookmark with url http://google.com
  When delete this new added bookmark
  And fetch the latest bookmark
  Then the latesed bookmark which url is not http://google.com







