'use strict';

/* Controllers */

function RegisterCtrl($scope , $http , $window) {
	$scope.user={};
	$scope.addUser = function () {
		if (!$scope.signup_form.$valid) {
			$scope.signup_form.submitted = true;
			return ;
		} 
		
		$http({
            url: '/ams/rest/user/register',
            method: "POST",
            data: $scope.user,
            headers: {'Content-Type': 'application/json'}
        }).success(function (data, status, headers, config) {
                $scope.addedUser = data; 
                if(data.success){
                	$window.location = '/ams/web/index';
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
	$scope.cancelUser = function () {
		$window.location = '/ams/web/auth/login';
	};  
}
 
