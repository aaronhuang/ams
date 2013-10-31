'use strict';

/* App Module */

var amsApp = angular.module('amsApp', [
  'ngRoute',
  'amsAppControllers',
  'ui.bootstrap'
]);

amsApp.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/users', {
        templateUrl: '/ams/web/html/user/UserList.html',
        controller: 'UserListCtrl'
      }).
      when('/activity', {
          templateUrl: '/ams/web/html/activity/List.html',
          controller: 'ActivityCtrl'
        }).
      when('/user/:phoneId', {
        templateUrl: '/ams/web/html/user/UserDetail.html',
        controller: 'UserDetailCtrl'
      }).
      when('/adduser', {
          templateUrl: '/ams/web/html/user/AddUser.html',
          controller: 'UserAddCtrl'
        }).
      otherwise({
        redirectTo: '/users'
      });
  }]);
