
#black 15, white 18
Meteor.methods
    getOrCreateMachine: (sensorId) ->
        #if not this.userId
        #    throw new Meteor.Error "logged-out", "The user must be logged in to create a machine"
        machine = Machines.findOne sensorId
        if not machine
            machine = Machines.insert
              _id: sensorId
              #user: this.userId
        return sensorId

    setCourse: (runId, status) ->
        Runs.update runId,
            $set:
                status: status
                roger: false
            $push:
                actionHistory:
                      action: status
                      at: new Date

    addTemp: (machineId, temp) ->
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

    startRun: (machineId) ->
        if not this.userId
            throw new Meteor.Error "logged-out", "The user must be logged in to start a run"

        machine = Machines.findOne
            _id: machineId
            #user: this.userId

        # Make a new machine if it doesn't exist
        if not machine
            throw new Meteor.Error "no-machine", "NO MACHINE EXISTS by that ID"

        Runs.insert
            # New properties
            machine: machine._id
            user: this.userId
            createdAt: new Date()
            temps: ['Temperature']
            times: ['x']
            tastingNotes: [] # {tastedAt: ..., text: ''}
            actionHistory: [{action: 'Created', at: new Date()}] # {action: 'stop', at: ...}
            title: '' # Bean name
            roast: ''
            roger: false
            components: [
                name: 'beans'
                qty: 0,
                    name: 'sugar'
                    qty: 0,
                name: 'milk'
                qty: 0,
                    name: 'lecithin'
                    qty: 0,
                name: 'cocoa butter'
                qty: 0
            ]
            status: 'new'
