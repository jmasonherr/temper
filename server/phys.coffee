if process.env.USER == 'pi' or process.env.USER == 'root'


    @PHYS =
        initSensors: () ->
            driverLoad()
            Meteor.call('getOrCreateMachine', s) for s in ThermSensor.list()

        saveTemp: (machineId, temp) ->
            console.log 'saving temp'
            run = Runs.findOne machine: machineId,
                sort:
                    createdAt: -1
                limit: 1

            if temp == 85.0
                throw new Meteor.Error("invalid-temp", "Invalid temperature")

            # Safety third!
            if temp >= 77
                console.log 'OVER TEMP: ' + run.machine
                @stopMachine run.machine
            if temp <= 26.7
                console.log 'UNDER TEMP: ' + run.machine
                @stopMachine run.machine

            Runs.update run._id,
                $push:
                    temps:
                        temp
                    times:
                        new Date()

        saveAction: (machineId, action) ->
            console.log 'savingaction'
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
            console.log 'spinning machine ' + _id
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
            console.log 'stopping machine ' + _id
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

    @PHYS =
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
