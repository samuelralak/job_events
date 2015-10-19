'use strict';

angular.module('mainApp.auth.controllers', []);

AuthenticationController =  ($scope, $auth, $state) -> 
	$scope.registrationForm = {}
	console.log $scope.email

	$scope.register = () -> 
		$auth.submitRegistration($scope.registrationForm)
			.then(
				success = (resp) ->
					console.log "### SUCCESS RESPONSE: " + JSON.stringify(resp)
					$state.go('dashboard', {}, {
						reload: true
					})
			).catch(
				failure = (resp) ->
					console.log "### FAILURE RESPONSE: " + JSON.stringify(resp)
			);

	$scope.login = () -> 
		$auth.submitLogin($scope.registrationForm).then(
				success = (resp) ->
					$state.go('dashboard', {}, {
						reload: true
					})
			).catch(
				failure = (resp) ->
					console.log "### FAILURE RESPONSE: " + JSON.stringify(resp)
			);

angular.module('mainApp.auth.controllers')
	.controller('AuthenticationController', ['$scope', '$auth', '$state', AuthenticationController]);
