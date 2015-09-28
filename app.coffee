@MOCK_TEMP = 30.1 # Allow us to change and play with a fake teperature
@ACTIONS =  _.map ['temper', 'run', 'stop'], (i) ->
            name: i

@Runs = new Mongo.Collection 'runs'
@Machines = new Mongo.Collection 'machines'

Router.configure
    layoutTemplate: 'layout',
    notFoundTemplate: 'notFound'

Router.map ->

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

  @route '/temp',
    where: 'server'
    name: 'temp'
    action: ->
      if @request.body.secret == 'iridemybicycle'
        machineId = @request.body.sensorId
        _id = Meteor.call 'addTemp', machineId, @request.body.temp
        @response.writeHead(200, {'Content-Type': 'application/json'})
        @response.end(JSON.stringify(Runs.findOne(_id)))
      else
        console.log 'ERROR BAD SECRET'

  @route '/',
    where: 'client'
    action: ->
      Router.go 'dashboard'


Runs.allow
  insert: (userId, run) ->
    !!userId
  update: (userId, run) ->
    run.user == userId
  remove: (userId, run) ->
    false


Machines.allow
  insert: (userId, machine) ->
    !!userId
  update: (userId, machine) ->
    machine.user == userId
  remove: (userId, machine) ->
    false
