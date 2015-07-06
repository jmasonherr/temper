Meteor.startup ->

    allMachines = Machines.find().fetch()
    console.log(_.pluck(allMachines, '_id'))

    Runs.find
        machine:
            $in:
                _.pluck allMachines, '_id'
    .observeChanges
        changed: (id, fields) ->
            console.log 'CHANGED'
            console.log id
            console.log fields
            if fields.status
                console.log 'SETTING COURSE ' + fields.status
                #setCourse(id, fields.status)
# mongo url gotten by meteor mongo --url
#mongodb://client-a3915a53:b082910a-3ca3-690d-993d-f7cee307c94f@production-db-a2.meteor.io:27017/temper_meteor_com
#[ WHITE:'28-00000651dea5', BLACK:'28-00000688662f' ]
if process.env.USER == 'pi' or process.env.USER == 'root'
    console.log 'STARTING AS PI'

    driverLoad = () ->

        RPI.destroy ->
            RPI.setMode(RPI.MODE_BCM)
            if not ThermSensor.isDriverLoaded()
                ThermSensor.loadDriver()
                console.log('driver is loaded')

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
                return
            if CRON_ACTIONS[course]
                SyncedCron.add(CRON_ACTIONS[course](run.machine))
            else
                console.log 'COURSE ' + course + ' NOT PRESENT IN CRON ACTIONS'

        driverLoad()
        allMachines = Machines.find().fetch()
        console.log(_.pluck(allMachines, '_id'))

        Runs.find
            machine:
                $in:
                    _.pluck allMachines, '_id'
        .observeChanges
            changed: (id, fields) ->
                if fields.status
                    setCourse(id, fields.status)

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
            if temp >= MAX_TEMP
                console.log 'OVER TEMP: ' + run.machine
                Meteor.call 'stopMachine', run.machine
            if temp <= MIN_TEMP
                console.log 'UNDER TEMP: ' + run.machine
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

        spinMachine: (_id) ->
            machine = Machines.findOne _id
            if not machine
                throw new Meteor.Error("machine-not-found", "Can't find machine " + _id)
            if not machine.pin
                throw new Meteor.Error("require-pin", "Need to add pin for " + _id)
            RPI.write machine.pin, true, (err) ->
                if err
                    console.log 'ERROR RUNNING PIN ' + machine.pin
                    console.log err



        stopMachine: (_id) ->
            machine = Machines.findOne _id
            if not machine
                throw new Meteor.Error("machine-not-found", "Can't find machine " + _id)
            if not machine.pin
                throw new Meteor.Error("require-pin", "Need to add pin for " + _id)
            RPI.write machine.pin, true, (err) ->
                if err
                    console.log 'ERROR RUNNING PIN ' + machine.pin
                    console.log err

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
