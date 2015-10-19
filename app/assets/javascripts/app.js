'use strict';

var mainApp = angular.module('mainApp',[
	'ui.router',
	'ngResource',
	'ngAnimate',
	'ngCookies',
	'ng-token-auth',
	'mainApp.auth',
	'mainApp.events',
	'mainApp.jobs',
	'mainApp.home',
]);

function mainAppConfig ($httpProvider, $stateProvider, $authProvider) {
	// the following shows the default values. values passed to this method
    // will extend the defaults using angular.extend

    $authProvider.configure({
    	apiUrl:                  'http://api.lvh.me:3001',
    	tokenValidationPath:     '/auth/validate_token',
    	signOutUrl:              '/auth/sign_out',
    	emailRegistrationPath:   '/auth',
    	accountUpdatePath:       '/auth',
    	accountDeletePath:       '/auth',
    	// confirmationSuccessUrl:  window.location.href,
    	passwordResetPath:       '/auth/password',
    	passwordUpdatePath:      '/auth/password',
    	// passwordResetSuccessUrl: window.location.href,
    	emailSignInPath:         '/auth/sign_in',
    	storage:                 'cookies',
    	forceValidateToken:      false,
    	validateOnPageLoad:      true,
    	proxyIf:                 function() { return false; },
    	proxyUrl:                '/proxy',
    	// omniauthWindowType:      'sameWindow',
    	// authProviderPaths: {
    	// 	github:   '/auth/github',
    	// 	facebook: '/auth/facebook',
    	// 	google:   '/auth/google'
    	// },
    	tokenFormat: {
    		"access-token": "{{ token }}",
    		"token-type":   "Bearer",
    		"client":       "{{ clientId }}",
    		"expiry":       "{{ expiry }}",
    		"uid":          "{{ uid }}"
    	},
    	parseExpiry: function(headers) {
    		// convert from UTC ruby (seconds) to UTC js (milliseconds)
    		return (parseInt(headers['expiry']) * 1000) || null;
    	},
    	handleLoginResponse: function(response) {
    		return response.data;
    	},
    	handleAccountUpdateResponse: function(response) {
    		return response.data;
    	},
    	handleTokenValidationResponse: function(response) {
    		return response.data;
    	}
    });

	$stateProvider.state('auth', {
        cache: false,
		url: '/auth',
		templateUrl: 'assets/modules/auth/views/auth.html',
		controller: 'AuthenticationController'
	});

	$stateProvider.state('home', {
        cache: false,
		url: '/home',
		templateUrl: 'assets/modules/home/views/home.html',
		controller: 'IndexController'
	});

	$stateProvider.state('create_event', {
		url: '/create_event',
		templateUrl: 'assets/modules/events/views/create_event.html',
		controller: 'CreateEventController'
	});

    $stateProvider.state('create_job', {
        url: '/create_job',
        templateUrl: 'assets/modules/jobs/views/create_job.html',
        controller: 'CreateJobController'
    });

    $stateProvider.state('dashboard', {
        url: '/dashboard',
        templateUrl: 'assets/modules/home/views/dashboard.html',
        controller: 'DashboardController',
        resolve: {
            auth: function($auth) {
                return $auth.validateUser();
            }
        }
    });
}

mainApp.value('version','V1.0');

mainApp.run(['$state', '$rootScope', '$cookieStore', function($state, $rootScope, $cookieStore) {
    if ($cookieStore.get('auth_headers') !== undefined) {
        $rootScope.auth = $cookieStore.get('auth_headers');
        $state.go('dashboard', {}, {
            reload: true
        });
    }

    if ($cookieStore.get('auth_headers') === undefined) {
        $state.go('home');
    }


    $rootScope.handleSignOutBtnClick = function() {
        $auth.signOut().then(function(resp) {
            $state.current.reload;

        }).catch(function(resp) {
            alert('An error occured');
        });
    };
}]);

mainApp.config(['$httpProvider', '$stateProvider', '$authProvider', mainAppConfig]);