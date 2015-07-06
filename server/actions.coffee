@CRON_ACTIONS =
    run: (machineId, temp, hours) ->
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
                currentTemp = ThermSensor.get(machineId)
                Meteor.call 'saveTemp', machineId, currentTemp
                if new Date() > temperTime
                    SyncedCron.add(CRON_ACTIONS['temper'](machineId))
                if currentTemp < temp
                    Meteor.call 'spinMachine', machineId
        return x

    pause: () ->
        SyncedCron.pause()

    stop: (machineId) ->
        SyncedCron.remove(machineId)

    temper: (machineId) ->
        Meteor.call 'saveAction', machineId, 'Starting temper'
        return CRON_ACTIONS['temperMelt'](machineId)

    temperMelt: (machineId, temp) ->
        temp = temp || 37.7
        SyncedCron.remove(machineId)
        x =
            name: machineId
            schedule: (parser) ->
                parser.text('every 20 seconds')
            job: () ->
                currentTemp = ThermSensor.get(machineId)
                Meteor.call 'saveTemp', machineId, currentTemp
                if currentTemp >= temp
                    SyncedCron.add(CRON_ACTIONS['temperCool'](machineId))
                else
                    Meteor.call 'spinMachine', machineId
        return x

    temperCool: (machineId, temp) ->
        temp = temp || 27.7
        SyncedCron.remove(machineId)
        x =
            name: machineId
            schedule: (parser) ->
                parser.text('every 2 minutes')
            job: () ->
                Meteor.call 'spinMachine', machineId
                Meteor.setTimeout () ->
                    Meteor.call 'stopMachine', machineId
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
                    Meteor.call 'stopMachine', machineId
                if currentTemp < midTemp
                    Meteor.call 'spinMachine', machineId
        return x
