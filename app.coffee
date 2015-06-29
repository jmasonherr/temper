@ACTIONS =  _.map ['temper', 'pause', 'run', 'hold', 'done', 'new'], (i) ->
            name: i

@Runs = new Mongo.Collection 'runs'
@Machines = new Mongo.Collection 'machines'

Router.configure
    layoutTemplate: 'layout',
    notFoundTemplate: 'notFound'

Router.map ->

  @route '/',
    where: 'client'
    action: ->
      Router.go 'dashboard'

  @route '/dashboard',
    where: 'client'
    name: 'dashboard'
    template: 'dashboard'
    subscriptions: ->
      Meteor.subscribe 'machines'

  @route '/archive',
    where: 'client'
    name: 'archive'
    template: 'archive'


Runs.allow
  insert: (userId, run) ->
    !!userId
  update: (userId, run) ->
    run.user == userId
  remove: (userId, run) ->
    false


Machines.allow
  insert: (userId, run) ->
    !!userId
  update: (userId, run) ->
    run.user == userId
  remove: (userId, run) ->
    false
