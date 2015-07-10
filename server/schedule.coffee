

Meteor.startup ->

    allMachines = Machines.find().fetch()
    console.log 'STARTUP MACHINES FOUND'
    console.log(_.pluck(allMachines, '_id'))


# mongo url gotten by meteor mongo --url
#[ WHITE:'28-00000651dea5', BLACK:'28-00000688662f' ]
if process.env.USER == 'pi' or process.env.USER == 'root'
    console.log 'STARTING AS PI'

    driverLoad = () ->

        RPI.destroy ->
            RPI.setMode(RPI.MODE_BCM)
            RPI.setup(15, RPI.DIR_OUT)
            RPI.setup(18, RPI.DIR_OUT)

            if not ThermSensor.isDriverLoaded()
                ThermSensor.loadDriver()
                console.log('STARTUP DRIVER LOADED')

                _.each ThermSensor.list(), (id) ->
                    machine = Machines.findOne id
                    if machine
                        if machine.pin
                            RPI.setup machine.pin, RPI.DIR_OUT, (err) ->
                                if err
                                    console.log 'ERRROR SETTING UP PIN # ' + machine.pin
                                    console.log err
                        else
                            console.log 'NO PIN FOR MACHINE ' + id
                    else
                        console.log 'NO MACHINE FOR ID ' + id

    Meteor.startup ->
        if not Machines.findOne
            console.log 'NO MACHINES AT STARTUP'
            white = Machines.insert # Original machine
                _id: '28-00000651dea5'
                pin: 18
                name: 'Xochipilli'
            black = Machines.insert # New machine
                _id: '28-00000688662f'
                pin: 15
                name: 'Xochiquetzal'

        setCourse = (runId, course) ->
            run = Runs.findOne runId
            if course == 'done'
                console.log 'Run finished for machine : ' + run.machine
                return
            if CRON_ACTIONS[course]
                console.log 'Setting course ' + course + ' for machine : ' + run.machine
                res = CRON_ACTIONS[course](run.machine)
                if res
                  SyncedCron.add(res)
            else
                console.log 'COURSE ' + course + ' NOT PRESENT IN CRON ACTIONS'

        driverLoad()
        allMachines = Machines.find().fetch()

        Runs.find
            machine:
                $in:
                    _.pluck allMachines, '_id'
        .observeChanges
            changed: (id, fields) ->
                if fields.status
                    setCourse(id, fields.status)

        _.each allMachines, (m) ->
            run = Runs.findOne machine: m._id,
                sort:
                    createdAt: -1
                limit: 1
            setCourse run._id, run.status

        SyncedCron.start()

    Meteor.methods
        initSensors: () ->
            driverLoad()
            Meteor.call('getOrCreateMachine', s) for s in ThermSensor.list()

        saveTemp: (machineId, temp) ->
            run = Runs.findOne machine: machineId,
                sort:
                    createdAt: -1
                limit: 1

            if temp == 85.0
                throw new Meteor.Error("invalid-temp", "Invalid temperature")

            # Safety third!
            if temp >= 77
                console.log 'ERROR ------  OVER TEMP: ' + run.machine
                Meteor.call 'stopMachine', run.machine
            if temp <= 26.7
                console.log 'ERROR ------  UNDER TEMP' + run.machine
                Meteor.call 'stopMachine', run.machine

            Runs.update run._id,
                $push:
                    temps:
                        temp
                    times:
                        new Date()

        saveAction: (machineId, action) ->
            run = Runs.findOne machine: machineId,
                sort:
                    createdAt: -1
                limit: 1

            Runs.update run._id,
                $push:
                    actionHistory:
                        action: action
                        at: new Date()

        spinMachine: (_id, temp) ->
            machine = Machines.findOne _id
            if not machine
                throw new Meteor.Error("machine-not-found", "Can't find machine " + _id)
            if not machine.pin
                throw new Meteor.Error("require-pin", "Need to add pin for " + _id)
            temp = temp || ThermSensor.get(_id)
            if temp >= 77
                console.log 'ERROR ------  OVER TEMP: ' + _id
                Meteor.call 'stopMachine', _id
                return
            if temp <= 26.7
                console.log 'ERROR ------  UNDER TEMP' + _id
                Meteor.call 'stopMachine', _id
                return

            RPI.read machine.pin, (err, isOn) ->
                if err
                    console.log 'Error reading pin: ' + machine.pin
                if not isOn
                    console.log "Starting machine: " + machine.name
                    RPI.write machine.pin, true, (err) ->
                        if err
                            console.log 'Eror running pin: ' + machine.pin
                            console.log err
                            RPI.setMode(RPI.MODE_BCM)
                            RPI.setup(machine.pin, RPI.DIR_OUT)



        stopMachine: (_id) ->
            machine = Machines.findOne _id
            if not machine
                throw new Meteor.Error("machine-not-found", "Can't find machine " + _id)
            if not machine.pin
                throw new Meteor.Error("require-pin", "Need to add pin for " + _id)
            console.log 'Stopping machine: ' + machine.name
            RPI.read machine.pin, (err, isOn) ->
                if err
                    console.log 'ERROR READING PIN' + machine.pin
                if isOn
                    RPI.write machine.pin, false, (err) ->
                        if err
                            console.log 'ERROR RUNNING PIN ' + machine.pin
                            console.log err
                            RPI.setMode(RPI.MODE_BCM)
                            RPI.setup(machine.pin, RPI.DIR_OUT)

        # shutdown: () ->
        #     RPI.destroy ->
        #         exec = Npm.require('child_process').exec
        #         exec('sudo shutdown -h now')

else
    console.log 'STARTING AS CLOUD'

    Meteor.methods
        initSensors: () ->
            console.log 'initSensors called in cloud'
        saveTemp: () ->
            console.log 'saveTemp called in cloud'
        saveAction: () ->
            console.log 'saveAction called in cloud'
        spinMachine: () ->
            console.log 'spinMachine called in cloud'
        stopMachine: () ->
            console.log 'stopMachine called in cloud'
        shutdown: () ->
            console.log 'stopMachine called in cloud'
