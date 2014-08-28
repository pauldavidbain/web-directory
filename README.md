[![Build Status](https://travis-ci.org/biola/web-directory.svg?branch=master)](https://travis-ci.org/biola/web-directory)
[![Code Climate](https://codeclimate.com/github/biola/web-directory.png)](https://codeclimate.com/github/biola/web-directory)

README
==

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


Please feel free to use a different markup language if you do not plan to run
<tt>rake doc:app</tt>.


For recreating photo versions

    Department.each {|d| d.gallery_photos.each {|m| m.photo.recreate_versions!}}
    ProfilePhoto.each {|m| m.photo.recreate_versions!}
