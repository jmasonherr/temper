// Router.configure({
//     layoutTemplate: 'layout',
//     notFoundTemplate: 'notFound'
// });

// //
// // Dashboard route
// //

// # Router.map ->
// #   config =
// #     loadingTemplate: 'loading'
// #     notFoundTemplate: 'notFound'
// #     layoutTemplate: 'layout'

// #   @route '/',
// #     where: 'client'
// #     name: 'home'
// #     template: 'home'

// Router.route('/', function () {
//     Router.go('dashboard');
// });

// Router.route('/dashboard', function () {
//     this.render('dashboard');
// });

// Router.route('/oldruns', function () {
//     this.render('oldruns');
// });

// //
// // Analytics route
// //

// Router.route('/analytics', function () {
//     this.render('analytics');
// });

// //
// // Interface route
// //

// Router.route('/panels', function () {
//     this.render('panels');
// });
// Router.route('/typography', function () {
//     this.render('typography');
// });
// Router.route('/buttons', function () {
//     this.render('buttons');
// });
// Router.route('/components', function () {
//     this.render('components');
// });
// Router.route('/alerts', function () {
//     this.render('alerts');
// });
// Router.route('/modals', function () {
//     this.render('modals');
// });
// Router.route('/draggable', function () {
//     this.render('draggable');
// });
// Router.route('/nestableList', function () {
//     this.render('nestableList');
// });
// Router.route('/tour', function () {
//     this.render('tour');
// });
// Router.route('/icons', function () {
//     this.render('icons');
// });

// //
// // App views route
// //

// Router.route('/contacts', function () {
//     this.render('contacts');
// });
// Router.route('/projects', function () {
//     this.render('projects');
// });
// Router.route('/project', function () {
//     this.render('project');
// });
// Router.route('/socialBoard', function () {
//     this.render('socialBoard');
// });
// Router.route('/timeline', function () {
//     this.render('timeline');
// });
// Router.route('/profile', function () {
//     this.render('profile');
// });
// Router.route('/mailbox', function () {
//     this.render('mailbox');
// });
// Router.route('/blog', function () {
//     this.render('blog');
// });
// Router.route('/blogDetails', function () {
//     this.render('blogDetails');
// });
// Router.route('/forum', function () {
//     this.render('forum');
// });
// Router.route('/forumDetails', function () {
//     this.render('forumDetails');
// });
// Router.route('/gallery', function () {
//     this.render('gallery');
// });
// Router.route('/calendar', function () {
//     this.render('calendar');
// });


// //
// // Charts route
// //

// Router.route('/chartJs', function () {
//     this.render('chartJs');
// });
// Router.route('/flot', function () {
//     this.render('flot');
// });
// Router.route('/inlineGraphs', function () {
//     this.render('inlineGraphs');
// });


// //
// // Box transitions route
// //

// Router.route('/transitionOverview', function () {
//     this.render('transitionOverview');
// });
// Router.route('/transitionOne', function () {
//     this.render('transitionOne');
// });
// Router.route('/transitionTwo', function () {
//     this.render('transitionTwo');
// });
// Router.route('/transitionThree', function () {
//     this.render('transitionThree');
// });
// Router.route('/transitionFour', function () {
//     this.render('transitionFour');
// });
// Router.route('/transitionFive', function () {
//     this.render('transitionFive');
// });

// //
// // Common views route
// //

// Router.route('/login', function () {
//     this.render('login');
//     this.layout('blankLayout');
// });
// Router.route('/register', function () {
//     this.render('register');
//     this.layout('blankLayout');
// });
// Router.route('/errorOne', function () {
//     this.render('errorOne');
//     this.layout('blankLayout');
// });
// Router.route('/errorTwo', function () {
//     this.render('errorTwo');
//     this.layout('blankLayout');
// });
// Router.route('/lock', function () {
//     this.render('lock');
//     this.layout('blankLayout');
// });

// //
// // Tables route
// //

// Router.route('/tablesDesign', function () {
//     this.render('tablesDesign');
// });

// Router.route('/dataTables', function () {
//     this.render('dataTables');
// });

// //
// // Widgets route
// //

// Router.route('/widgets', function () {
//     this.render('widgets');
// });

// //
// // Forms route
// //

// Router.route('/formsElements', function () {
//     this.render('formsElements');
// });
// Router.route('/formsExtended', function () {
//     this.render('formsExtended');
// });
// Router.route('/textEditor', function () {
//     this.render('textEditor');
// });
// Router.route('/wizard', function () {
//     this.render('wizard');
// });

// //
// // Grid system route
// //

// Router.route('/gridSystem', function () {
//     this.render('gridSystem');
// });

// //
// // Landing page route
// //

// Router.route('/landingPage', function () {
//     this.render('landingPage');
//     this.layout('landingLayout');
// });

// //
// // Global - Remove splash screen after after rendered layout
// //

// Router.onAfterAction(function()
// {
//     setTimeout(function()
//     {
//         $('.splash').css('display', 'none')
//     })
// });
