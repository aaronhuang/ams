'use strict';

/* Controllers */

var amsAppControllers = angular.module('amsAppControllers', []);

amsAppControllers.controller('UserListCtrl', ['$scope', '$http',
  function PhoneListCtrl($scope, $http) {
    $http.get('/ams/rest/users').success(function(data) {
      $scope.users = data;
    });
    $scope.selectAllUserFlag = false;
    $scope.selection = {
            ids: {}
        };
    $scope.selectAllUser = function(selectAllUserFlag){
    	$scope.selection.ids={};
    	for(var i = 0; i < $scope.users.length; i++) {
    		$scope.selection.ids[$scope.users[i].id]=selectAllUserFlag;
    	}
    }
  }]);

amsAppControllers.controller('UserDetailCtrl', ['$scope', '$routeParams',
  function($scope, $routeParams) {
    $scope.phoneId = $routeParams.phoneId;
  }]);

amsAppControllers.controller('UserAddCtrl', ['$scope', '$http', '$location','$routeParams',
  function($scope, $http, $location, $routeParams) {
	$scope.user={};
	$scope.addUser = function () {
		$http({
            url: '/ams/rest/user/register',
            method: "POST",
            data: $scope.user,
            headers: {'Content-Type': 'application/json'}
        }).success(function (data, status, headers, config) {
                $scope.addedUser = data; // assign  $scope.persons here as promise is resolved here 
                if(data.success){
                	 $location.url('/');
                }else{
                	$scope.hasErrorMsg=true;
                	if(data.errorMsg == null) {
                		$scope.errorMsg=data.errors.join("\n");
                	}else {
                		$scope.errorMsg=data.errorMsg;
                	}
                	
                }
            }).error(function (data, status, headers, config) {
                $scope.status = status;
            });
	    
	};
	$scope.cancelSaveUser = function () {
	    $location.url('/');
	};
  }]);

var ModalDemoCtrl = function ($scope, $modal,  $log, $http , $location) {
	
		$scope.user={};

		$scope.open = function (templateUrl) {
		    var modalInstance = $modal.open({
		      templateUrl: templateUrl,
		      controller: ModalInstanceCtrl,
		      resolve: {
		        user: function () {
		          return $scope.user;
		        }
		      }
		    });

		    modalInstance.result.then(function (user) {
		      $scope.user = user;
		    }, function () {
		      $log.info('Modal dismissed at: ' + new Date());
		    });
	  	};
	  	
	  	$scope.editUser = function (userId, templateUrl) {
	  		for(var i in $scope.users) {
	            if($scope.users[i].id == userId) {
	                $scope.user = angular.copy($scope.users[i]);
	                break;
	            }
	        }
	  		
		    var modalInstance = $modal.open({
		      templateUrl: templateUrl,
		      controller: ModalInstanceCtrl,
		      resolve: {
		        user: function () {
		          return $scope.user;
		        }
		      }
		    });

		    modalInstance.result.then(function (user) {
		      $scope.user = user;
		    }, function () {
		      $log.info('Modal dismissed at: ' + new Date());
		    });
	  	};
	  	
	  	$scope.removeUser = function (userId) {
					$http({
			            url: '/ams/rest/user/' + userId ,
			            method: "DELETE",
			            headers: {'Content-Type': 'application/json'}
			        }).success(function (data, status, headers, config) {
			                if(data.success){
			                	$location.url('/');
			                }else{
			                	$scope.hasErrorMsg=true;
			                	if(data.errorMsg == null) {
			                		$scope.errorMsg=data.errors.join("\n");
			                	}else {
			                		$scope.errorMsg=data.errorMsg;
			                	}
			                }
			            }).error(function (data, status, headers, config) {
			                $scope.status = status;
			            });
				    
				};
		
	};

var ModalInstanceCtrl = function ($scope, $modalInstance, $http,$location, user) {
	$scope.user=user;

	$scope.ok = function () {
	    $modalInstance.close($scope.user);
	};
	  
	$scope.addUser = function (userId) {
		var url;
		if(userId > 0) {
			url = '/ams/rest/user/edit';
		}else {
			url = '/ams/rest/user/register';
		}
			$http({
	            url: url,
	            method: "POST",
	            data: $scope.user,
	            headers: {'Content-Type': 'application/json'}
	        }).success(function (data, status, headers, config) {
	                $scope.addedUser = data; // assign  $scope.persons here as promise is resolved here 
	                if(data.success){
	                	$modalInstance.close($scope.user);
	                	$location.url('/');
	                }else{
	                	$scope.hasErrorMsg=true;
	                	if(data.errorMsg == null) {
	                		$scope.errorMsg=data.errors.join("\n");
	                	}else {
	                		$scope.errorMsg=data.errorMsg;
	                	}
	                	
	                }
	            }).error(function (data, status, headers, config) {
	                $scope.status = status;
	            });
		    
		};

	$scope.cancel = function () {
		$modalInstance.dismiss('cancel');
	};
	$scope.exit = function() {              // only one close icon in show modal box
		$modalInstance.dismiss('cancel');
	};
};
