'use strict';

/* App Module */

var amsActivity = angular.module('amsActivity', [
  'ngRoute',
  'amsActivityControllers',
  'ui.bootstrap'
]);

amsActivity.config(['$routeProvider',
  function($routeProvider) {
    $routeProvider.
      when('/activities', {
        templateUrl: '/ams/html/activity/List.html',
        controller: 'ActivityListCtrl'
      }).
      otherwise({
        redirectTo: '/activities'
      });
  }]);
