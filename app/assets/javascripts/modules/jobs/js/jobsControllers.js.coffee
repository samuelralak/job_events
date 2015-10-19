'use strict';

angular.module('mainApp.jobs.controllers', [])

CreateJobController = ($scope, $cookieStore, $http, $state, Event) -> 
	auth = $cookieStore.get('auth_headers')
	$scope.job = { }
	$scope.event = $cookieStore.get('event')
	$scope.services = []
	$scope.eventData = {
		event: {
			title: $scope.event.title
			event_date: $scope.event.event_date,
			venue: $scope.event.venue,
			event_type_id: $scope.event.event_type_id,
			contact_people_attributes: [$scope.event.contact_person],
			jobs_attributes: [$scope.job]
		}
	}

	console.log auth is undefined

	$scope.saveJob = () -> 
		if auth is undefined
			$cookieStore.remove('event')
			$cookieStore.put('event', $scope.eventData)
			$state.go('auth')
		else
			if auth.uid isnt undefined
				$http.post('http://api.lvh.me:3001/events', $scope.eventData).then(
					success = () -> 
						$cookieStore.remove('event')
						$state.go('dashboard')
					failure = () -> 
						alert("Oops. an error occured")
				)
			else
				$cookieStore.remove('event')
				$cookieStore.put('event', $scope.eventData)
				$state.go('auth')


	$http.get('http://api.lvh.me:3001/services').then(
		success = (response) ->
			$scope.services = response.data
		failure = (response) ->
			alert("Oops. an error occured")
	)

angular.module('mainApp.jobs.controllers')
	.controller('CreateJobController', ['$scope', '$cookieStore', '$http', '$state','Event', CreateJobController]);