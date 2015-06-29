Meteor.publish 'machines', ->
    Machines.find user: this.userId


Meteor.publish 'latest', (machineId) ->
    Runs.find
        user: this.userId,
        machine: machineId,
            sort:
                createdAt: -1
            limit: 1

Meteor.publish 'archive', ->
  Runs.find
    user: this.userId
    status: 'done',
      sort:
        createdAt: -1


Meteor.methods
  mockData: ->
    console.log 'moching data'
    console.log this.userId
    if this.userId
      if not Machines.findOne()
        console.log 'not machines'
        Meteor.call 'getOrCreateMachine', 'machine1', ->
          console.log 'machine1 '
          Meteor.call 'startRun', 'machine1', ->
            _.each _.range(1,10), (i) ->
              Meteor.setTimeout ->
                Meteor.call 'addTemp', 'machine1', i
              , 2000 * i
        Meteor.call 'getOrCreateMachine', 'machine2', ->
          Meteor.call 'startRun', 'machine2', ->
            _.each _.range(1,10), (i) ->
              Meteor.setTimeout ->
                Meteor.call 'addTemp', 'machine2', i
              , 2000 * i

  getOrCreateMachine: (machineId) ->
      if not this.userId
          throw new Meteor.error "logged-out", "The user must be logged in to create a machine"
      fullId = machineId + '_' + this.userId
      machine = Machines.findOne
        _id: fullId
        user: this.userId
      if not machine
          machine = Machines.insert
            _id: fullId
            user: this.userId
      return fullId


  addTemp: (machineId, temp) ->
      if not this.userId
          throw new Meteor.error "logged-out", "The user must be logged in to start a run"
      fullId = machineId + '_' + this.userId
      latest = Runs.findOne
          machine: fullId
          user: this.userId,
              sort:
                  createdAt: -1
      Runs.update latest._id,
          $push:
              temps:
                  temp
              times:
                  new Date()
      latest._id

  startRun: (machineId) ->
      if not this.userId
          throw new Meteor.error "logged-out", "The user must be logged in to start a run"
      fullId = machineId + '_' + this.userId

      machine = Machines.findOne
          _id: fullId
          user: this.userId

      # Make a new machine if it doesn't exist
      if not machine
          throw new Meteor.error "no-machine", "NO MACHINE EXISTS by that ID"

      Runs.insert
        # New properties
        machine: machine._id
        user: machine.user
        createdAt: new Date
        temps: ['Temperature']
        times: ['x']
        tastingNotes: [] # {tastedAt: ..., text: ''}
        actionHistory: [] # {action: 'stop', at: ...}
        title: '' # Bean name
        roast: ''
        components: [
          name: 'beans'
          qty: 0,
            name: 'sugar'
            qty: 0,
          name: 'milk'
          qty: 0,
            name: 'lecithin'
            qty: 0
          ]
        status: 'running'
