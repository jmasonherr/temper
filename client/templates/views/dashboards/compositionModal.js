Template.compositionModal.onRendered(function() {
  this.$('.modal').modal();
});


Template.compositionModal.helpers({
  run: function() {
    return Runs.findOne(Session.get('modal')._id);
  }
});

Template.compositionModal.events({
  'click [data-dismiss="modal"]': function(e, tmpl) {
    Meteor.setTimeout(function() {
      Session.set('modal', null);
    }, 600);
  },
  'click button.btn-primary': function(e, tmpl) {
    var cleanData;
    cleanData = _.map(tmpl.$('form').serializeObject(), function(d) {
      return {
        name: d.name,
        qty: parseInt(d.value || 0)
      };
    });
    Runs.update(Session.get('modal')._id, {
      $set: {
        components: cleanData
      }
    });
    Meteor.setTimeout(function() {
      tmpl.$('[data-dismiss="modal"]').click();
    }, 600);
  }
});



Template.scheduleModal.onCreated(function() {
  this.action = new ReactiveVar();
  this.action.set('temper');
});
Template.scheduleModal.onRendered(function() {
  this.$('.modal').modal();
  this.$('.datetimepicker').datetimepicker();
});


Template.scheduleModal.helpers({
  run: function() {
    return Runs.findOne(Session.get('modal')._id);
  },
  actions: function(status) {
    return ACTIONS;
  },
  chosenAction: function() {
    return Template.instance().action.get();
  }
});


Template.scheduleModal.events({
  'click [data-dismiss="modal"]': function(e, tmpl) {
    Meteor.setTimeout(function() {
      Session.set('modal', null);
    }, 600);
  },

  'click ul.action-menu a': function(e, tmpl) {
      tmpl.action.set(this.name);
  },

  'click button.btn-primary': function(e, tmpl) {
    run = Runs.findOne(Session.get('modal')._id);
    if(tmpl.$('.datetimepicker').val()) {
      Meteor.call('scheduleAction', run._id, tmpl.action.get(), new Date(tmpl.$('.datetimepicker').val()), function(err, data) {
        if(err){console.log(err);}
        tmpl.$('[data-dismiss="modal"]').click();
      });
    }
  },

});
