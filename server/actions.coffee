@CRON_ACTIONS =
    run: (machineId, temp, hours) ->
        console.log 'cron action run'
        temp = temp || 77
        hours = hours || 20
        startTime = new Date()
        temperTime = moment(new Date()).add(20, 'hours')
        SyncedCron.remove(machineId)
        Meteor.call 'saveAction', machineId, 'Running'
        x =
            name: machineId
            schedule: (parser) ->
                parser.text('every 20 seconds')
            job: () ->
                console.log 'in run job for ' + machineId
                currentTemp = ThermSensor.get(machineId)
                Meteor.call 'saveTemp', machineId, currentTemp
                if new Date() > temperTime
                    SyncedCron.add(CRON_ACTIONS['temper'](machineId))
                if currentTemp < temp
                    PHYS.spinMachine machineId
        return x

    pause: () ->
        console.log 'cron action pause'

        SyncedCron.pause()

    stop: (machineId) ->
        console.log 'cron action stop' + machineId

        SyncedCron.remove(machineId)

    temper: (machineId) ->
        console.log 'cron action temper' + machineId

        Meteor.call 'saveAction', machineId, 'Starting temper'
        return CRON_ACTIONS['temperMelt'](machineId)

    temperMelt: (machineId, temp) ->
        console.log 'cron action tempermelt' + machineId

        temp = temp || 37.7
        SyncedCron.remove(machineId)
        x =
            name: machineId
            schedule: (parser) ->
                parser.text('every 20 seconds')
            job: () ->
                console.log 'in tempermelt job for ' + machineId

                currentTemp = ThermSensor.get(machineId)
                Meteor.call 'saveTemp', machineId, currentTemp
                if currentTemp >= temp
                    SyncedCron.add(CRON_ACTIONS['temperCool'](machineId))
                else
                    PHYS.spinMachine machineId
        return x

    temperCool: (machineId, temp) ->
        temp = temp || 27.7
        SyncedCron.remove(machineId)
        x =
            name: machineId
            schedule: (parser) ->
                parser.text('every 2 minutes')
            job: () ->
                PHYS.spinMachine machineId
                Meteor.setTimeout () ->
                    PHYS.stopMachine machineId
                    currentTemp = ThermSensor.get(machineId)
                    Meteor.call 'saveTemp', machineId, currentTemp
                    if currentTemp <= temp
                        SyncedCron.add(CRON_ACTIONS['temperHold'](machineId))
                , 2000
        return x

    temperHold: (machineId, minTemp, maxTemp) ->
        minTemp = minTemp || 31.9
        maxTemp = maxTemp || 32.5
        midTemp = (minTemp + maxTemp) / 2.0
        SyncedCron.remove(machineId)
        Meteor.call 'saveAction', machineId, 'Holding temper'
        x =
            name: machineId
            schedule: (parser) ->
                parser.text('every 30 seconds')
            job: () ->
                currentTemp = ThermSensor.get(machineId)
                Meteor.call 'saveTemp', machineId, currentTemp
                if currentTemp > midTemp
                    PHYS.stopMachine machineId
                if currentTemp < midTemp
                    PHYS.spinMachine machineId
        return x
