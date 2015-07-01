later = Npm.require('later')

SyncedCron.add
  name: 'testlogging'
  schedule: (parser) ->
    # parser is a later.parse object
    later.parse.recur().on(2).second()
  job: () ->
    console.log(this)
    console.log(this.name)

SyncedCron.start()




if process.env.USER == 'pi'
    sensor = require('ds18x20');
    MAX_TEMP = 72.2
    MIN_TEMP = 26.9
    TEMPER_MAX = 90.5
    TEMPER_HOLD_MIN = 31.7

    driverLoad = () ->
        if not sensor.isDriverLoaded()
            sensor.loadDriver()
            console.log('driver is loaded')

else
    sensor = {
        list: () -> ['sensor1', 'sensor2']
        get: () -> MOCK_TEMP || 30.0
    }
    driverLoad = () -> console.log 'Driver load on non-pi'



Meteor.methods
    initSensors: () ->
        driverLoad()
        Meteor.call('getOrCreateMachine', s) for s in sensor.list()

    saveTemp: (runId) ->
        run = Runs.findOne
            _id: runId
            user: this.userId

        temp = sensor.get(run.machine)
        if temp == 85.0
            console.log '185 temp for machien ' + run.machine
            return

        # Safety third!
        if temp >= MAX_TEMP
            console.log 'OVER TEMP: ' + run.machine
            Meteor.call 'stopMachine', run.machine
        if temp <= MIN_TEMP
            console.log 'UNDER TEMP: ' + run.machine
            Meteor.call 'stopMachine', run.machine

        Runs.update runId,
            $push:
                temps:
                    temp
                times:
                    new Date()

    runMachine: (_id) ->
        machine = Machines.findOne _id
        if not machine
            throw new Meteor.Error("machine-not-found", "Can't find machine " + _id)
        if not machine.pin
            throw new Meteor.Error("require-pin", "Need to add pin for " + _id)


