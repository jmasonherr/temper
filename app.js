this.MOCK_TEMP = 30.1;

this.ACTIONS = _.map(['temper', 'run', 'stop', 'done'], function(i) {
  return {
    name: i
  };
});

this.Runs = new Mongo.Collection('runs');

this.Machines = new Mongo.Collection('machines');

this.Beans = new Mongo.Collection('beans');

this.Roasts = new Mongo.Collection('roasts');


Router.configure({
  layoutTemplate: 'layout',
  notFoundTemplate: 'notFound'
});

Router.map(function() {
  this.route('/', {
    where: 'client',
    action: function() {
      return Router.go('dashboard');
    }
  });

  this.route('/dashboard', {
    where: 'client',
    name: 'dashboard',
    template: 'dashboard',
    subscriptions: function() {
      return Meteor.subscribe('machines');
    }
  });


  this.route('/beans', {
    where: 'client',
    name: 'beans',
    template: 'beans',
    subscriptions: function() {
      return Meteor.subscribe('beans');
    }
  });


  this.route('/roasts', {
    where: 'client',
    name: 'roasts',
    template: 'roasts',
    subscriptions: function() {
      return Meteor.subscribe('roasts');
    }
  });

  this.route('/archive', {
    where: 'client',
    name: 'archive',
    template: 'archive'
  });

  this.route('/temp', {
    where: 'server',
    name: 'temp',
    action: function() {
      var _id, machineId;
      if (this.request.body.secret === 'iridemybicycle') {
        machineId = this.request.body.sensorId;
        _id = Meteor.call('addTemp', machineId, this.request.body.temp);
        this.response.writeHead(200, {
          'Content-Type': 'application/json'
        });
        return this.response.end(JSON.stringify(Runs.findOne(_id)));
      } else {
        return console.log('ERROR BAD SECRET');
      }
    }
  });
});

Runs.allow({
  insert: function(userId, run) {
    return !!userId;
  },
  update: function(userId, run) {
    return run.user === userId;
  },
  remove: function(userId, run) {
    return false;
  }
});

Machines.allow({
  insert: function(userId, machine) {
    return !!userId;
  },
  update: function(userId, machine) {
    return machine.user === userId;
  },
  remove: function(userId, machine) {
    return false;
  }
});
