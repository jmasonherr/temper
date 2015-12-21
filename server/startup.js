Meteor.startup(function() {
  var black, tilting1, white;
  var user = Meteor.users.findOne({'emails.address': 'jmasonherr@gmail.com'});
  if(user) {
    if (!Machines.findOne('28-000006893209')) {
      tilting1 = Machines.insert({
        _id: '28-000006893209',
        pin: 15,
        name: 'Xochiquetzal',
        active: true,
        user: user._id
      });
      Meteor.call('startRun', '28-000006893209');
    }
    if (!Machines.findOne('28-00000651dea5')) {
      console.log('NO MACHINES AT STARTUP');
      white = Machines.insert({
        _id: '28-00000651dea5',
        pin: 18,
        name: 'Xochipilli',
        active: true,
        user: user._id
      });
      // black = Machines.insert({
      //   _id: '28-00000688662f',
      //   pin: 15,
      //   name: 'Xochiquetzal',
      //   user: 'dy8TuaSZxqH6CoYsE'
      // });
    }
  }
});
