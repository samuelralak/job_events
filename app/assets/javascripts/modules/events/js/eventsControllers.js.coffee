'use strict';

angular.module('mainApp.events.controllers', []);

CreateEventController =  ($scope, $http, $cookieStore, $state) -> 
	$scope.event_types = []
	$scope.event = {
		contact_person: {}
	}

	$http.get('http://api.lvh.me:3001/event_types').then(
		success = (response) ->
			$scope.event_types = response.data
		failure = (response) ->
			alert("Oops. an error occured")
	)

	$scope.saveEvent = 	() -> 
		$cookieStore.put('event', $scope.event)
		$state.go('create_job')


angular.module('mainApp.events.controllers')
	.controller('CreateEventController', ['$scope', '$http', '$cookieStore', '$state', CreateEventController]);