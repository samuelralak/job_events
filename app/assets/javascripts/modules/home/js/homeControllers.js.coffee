'use strict';

angular.module('mainApp.home.controllers', []);

IndexController =  ($scope, $cookieStore, $http) -> 
	$scope.dashText = "THis is the dashboard"

DashboardController = ($scope, $http, $cookieStore) -> 
	$scope.events = []
	eventData = $cookieStore.get('event')
	console.log(JSON.stringify(eventData))
	
	if eventData isnt undefined
		$http.post('http://api.lvh.me:3001/events', eventData).then(
			success = () -> 
				$cookieStore.remove('event')
			failure = (resp) -> 
				console.log JSON.stringify(resp)
		)

	$http.get('http://api.lvh.me:3001/events').then(
		success = (response) -> 
			console.log JSON.stringify(response.data)
			$scope.events = response.data
		failure = (resp) -> 
			console.log JSON.stringify(resp)
		)	

angular.module('mainApp.home.controllers')
	.controller('IndexController', ['$scope', '$cookieStore', '$http', IndexController])
	.controller('DashboardController', ['$scope', '$http', '$cookieStore', DashboardController]);
