Kadira.connect('mggXXtiNMT7Nzm9m7', '8f7af99a-a215-462e-b34a-303e656cadbf');

Meteor.publish('machines', function() {
  return Machines.find({
    active: true
  });
});


Meteor.publish('latest', function(machineId) {
  return Runs.find({
    machine: machineId
  }, {
    sort: {
      createdAt: -1
    },
    limit: 1
  });
});

Meteor.publish('archive', function() {
  return Runs.find({
    user: this.userId
  }, {
    sort: {
      createdAt: -1
    },
    limit: 20
  });
});

Meteor.publish('beans', function() {
  return Beans.find();
});

Meteor.publish('roasts', function() {
  return Roasts.find();
});
