angular = require 'angular'
ngSanitize = require 'angular-sanitize'
Remarkable = require 'remarkable'

window.app = angular.module('myFeed', ['ngSanitize'])
window.markdown = new Remarkable('commonmark')