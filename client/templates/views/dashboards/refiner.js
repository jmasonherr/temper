Template.refiner.onCreated(function() {
  this.subscribe('latest', this.data._id);
  this.subscribe('machineSchedule', this.data._id);
});

Template.refiner.helpers({
  runs: function(machineId) {
    return Runs.find({
      machine: machineId
    }, {
      sort: {
        createdAt: -1
      },
      limit: 1
    });
  }
});
