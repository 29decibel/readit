Feature: Get article contents
  
Background:
  Given the readit api client

Scenario: get article infos
  Given fetch the latest bookmark
  When get article info of the latest bookmark
  Then get article's except and content info
