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
        console.log '###############'
        _id = _saveTemp @request.body.sensorId, @request.body.temp
        console.log @request.body.temp
        console.log @request.body.sensorId

        @response.writeHead(200, {'Content-Type': 'application/json'})
        @response.end(JSON.stringify(Runs.findOne(_id)))
      else
        console.log 'ERROR BAD SECRET'

  @route '/',
    where: 'client'
    action: ->
      Router.go 'dashboard'


_saveTemp = (machineId, temp) ->
  run = Runs.findOne machine: machineId,
      sort:
        createdAt: -1
      limit: 1

  if temp == 85.0
    throw new Meteor.Error("invalid-temp", "Invalid temperature")

  Runs.update run._id,
    $set:
      roger: true
    $push:
      temps:
        temp
      times:
        new Date()

  return run._id

_saveAction = (machineId, action) ->
  run = Runs.findOne machine: machineId,
    sort:
      createdAt: -1
    limit: 1

  Runs.update run._id,
    $push:
      actionHistory:
        action: action
        at: new Date()

  return run._id


# Meteor.methods
  # saveTemp: (machineId, temp) ->
  #   return _saveTemp(machineId, temp)

  # saveAction: (machineId, action) ->
  #   return _saveAction(machineId, action)



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
