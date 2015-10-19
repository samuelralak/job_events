'use strict';

angular.module('mainApp.events.services', []);

eventFactory = ($resource) -> 
	return $resource('http://api.lvh.me:3001/events/:id', { id: '@id'}, {
		update: {
			method: 'PUT'
		}
	})

angular.module('mainApp.events.services').factory('Event', ['$resource', eventFactory]);