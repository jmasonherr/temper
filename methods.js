simplifyRun = function(run) {
  var outTimes = ['x'];
  var outTemps = ['Temperature'];
  var nTemps = run.temps.length;
  var xys = simplify(_.map(run.temps.slice(1, nTemps + 1), function(t, ix) {
    return [run.times[ix + 1].getTime(), t];
  }), 0.0001);
  _.each(xys, function(xy) {
    outTimes.push(new Date(xy[0]));
    outTemps.push(xy[1]);
  });
  Runs.update(run._id, {
    $set: {
      temps: outTemps,
      times: outTimes
    }
  });
};


var runNextActions = function(run) {
  console.log('running nexta actiona');
  if(!run.scheduledActions) {
    Runs.update(run._id, {$set: {scheduledActions: []}});
  }
  _.each(run.scheduledActions, function(obj){
    if(obj.at <= new Date()) {
      Runs.update(run._id, {
        $pull: {
          scheduledActions: obj
        }
      });
      // Set it on course
      Meteor.call('setCourse', run._id, obj.action);
    }
  });
};


Meteor.methods({
  getOrCreateMachine: function(sensorId) {
    var machine;
    machine = Machines.findOne(sensorId);
    if (!machine) {
      machine = Machines.insert({
        _id: sensorId
      });
    }
    return sensorId;
  },

  scheduleAction: function(runId, action, date) {
    Runs.update(runId, {
      $push: {
        scheduledActions: {action: action, at: date}
      }
    });
  },

  setCourse: function(runId, status) {
    return Runs.update(runId, {
      $set: {
        status: status,
        roger: false
      },
      $push: {
        actionHistory: {
          action: status,
          at: new Date()
        }
      }
    });
  },

  addTemp: function(machineId, temp) {
    var run;
    run = Runs.findOne({
      machine: machineId
    }, {
      sort: {
        createdAt: -1
      },
      limit: 1
    });
    if (temp === 85.0) {
      throw new Meteor.Error("invalid-temp", "Invalid temperature");
    }
    if (run.status === 'done') {
      // Don't record when stopped
      return run._id;
    }

    Runs.update(run._id, {
      $set: {
        roger: true
      },
      $push: {
        temps: temp,
        times: new Date()
      }
    });
    if(run.temps.length > 100) {
      simplifyRun(run);
    }
    // Check for scheduled action
    runNextActions(run);
    return run._id;
  },

  startRun: function(machineId) {
    console.log('@@@@@@@ ', machineId);
    if (!this.userId) {
      throw new Meteor.Error("logged-out", "The user must be logged in to start a run");
    }
    var machine = Machines.findOne(machineId);
    if (!machine) {
      throw new Meteor.Error("no-machine", "NO MACHINE EXISTS by that ID");
    }
    return Runs.insert({
      machine: machine._id,
      user: this.userId,
      title: '',
      roast: '',
      createdAt: new Date(),
      temps: ['Temperature'],
      times: ['x'],
      tastingNotes: [],
      roastNotes: [],
      actionHistory: [
        {
          action: 'Created',
          at: new Date()
        }
      ],
      roger: false, // Has the latest action been received?
      scheduledActions: [],
      components: [
        {
          name: 'beans',
          qty: 0
        }, {
          name: 'sugar',
          qty: 0
        }, {
          name: 'milk',
          qty: 0
        }, {
          name: 'lecithin',
          qty: 0
        }, {
          name: 'cocoa butter',
          qty: 0
        }
      ],
      status: 'run'
    });
  }
});


