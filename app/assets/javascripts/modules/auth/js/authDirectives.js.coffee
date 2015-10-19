'use strict';

angular.module('mainApp.auth.directives', []);

validatePasswordCharacters = () ->
	REQUIRED_PATTERNS = [/\d+/, /[a-z]+/, /[A-Z]+/, /\W+/, /^\S+$/]

	return {
    	require : 'ngModel',
    	link : ($scope, element, attrs, ngModel) -> 
    		ngModel.$validators.passwordCharacters = (value) -> 
    			status = true
    			angular.forEach(REQUIRED_PATTERNS, (pattern) -> 
    				status = status && pattern.test(value)
    				console.log(status, pattern)
    			)

    			return status
    }

emailAvailableValidator = ($http) -> 
	return {
		require: 'ngModel',
		link: ($scope, element, attrs, ngModel) -> 
			ngModel.$asyncValidators.usernameAvailable = (email) -> 
				return $http.get('http://api.lvh.me:3001/user_email?email='+ email)
	}

compareToValidator = () -> 
	return {
		require: 'ngModel',
		link: (scope, element, attrs, ngModel) -> 
			scope.$watch(attrs.compareToValidator, () -> 
				ngModel.$validate()
			)
			ngModel.$validators.compareTo = () -> 
				other = scope.$eval(attrs.compareToValidator)
				return !value || !other || value == other
	}

angular.module('mainApp.auth.directives')
	.directive('validatePasswordCharacters', [validatePasswordCharacters])
	.directive('emailAvailableValidator', ['$http', emailAvailableValidator])
	.directive('compareToValidator', [compareToValidator])
