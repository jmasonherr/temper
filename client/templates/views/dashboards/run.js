var DONUT_OPTS, INGREDIENT_COLORS;

INGREDIENT_COLORS = {
  milk: 'white',
  beans: 'brown',
  lecithin: 'yellow'
};

DONUT_OPTS = {
  segmentShowStroke: true,
  segmentStrokeColor: "#fff",
  segmentStrokeWidth: 2,
  percentageInnerCutout: 45,
  animationSteps: 100,
  animationEasing: "easeOutBounce",
  animateRotate: true,
  animateScale: false,
  responsive: true
};

Template.run.onRendered(function() {
  var buildDonut, buildLine, donutChart, lineChart, self = this;

  this.$('.bean').editable({
    autotext: 'never',
    emptytext: 'Bean name'
  }).on('save', function(e, params) {
    return Runs.update(self.data._id, {
      $set: {
        title: params.newValue
      }
    });
  });
  this.$('.machine-name').editable({
    autotext: 'never',
    emptytext: 'Machine name'
  }).on('save', function(e, params) {
    return Machines.update(self.machine, {
      $set: {
        name: params.newValue
      }
    });
  });
  lineChart = null;
  donutChart = null;
  Runs.find(this.data._id).observeChanges({
    changed: function(id, fields) {
      if (fields.components) {
        buildDonut();
      }
      if (fields.times || fields.temps) {
        return buildLine();
      }
    }
  });
  buildDonut = function() {
    var donut, donutData, run;
    console.log('observing donut');
    run = Runs.findOne(self.data._id);
    donutData = _.map(run.components, function(c) {
      return {
        value: c.qty,
        label: c.name,
        color: INGREDIENT_COLORS[c.name] || '#62cb31',
        highlight: "#57b32c"
      };
    });
    donut = self.find('canvas.donut');
    donutChart = new Chart(donut.getContext("2d")).Doughnut(donutData, DONUT_OPTS);
  };
  buildLine = function() {
    var chartParams, lineElem, run;
    console.log('observing line');
    run = Runs.findOne(self.data._id);
    lineElem = self.find('.flot-line-chart');
    chartParams = {
      bindto: lineElem,
      data: {
        x: 'x',
        columns: [run.times, run.temps]
      },
      axis: {
        x: {
          type: 'timeseries',
          tick: {
            format: function(t) {
              return moment(t).format('h:mm a');
            }
          }
        }
      }
    };
    if (lineChart) {
      lineChart.load({
        columns: [run.times, run.temps]
      });
    } else {
      lineChart = c3.generate(chartParams);
    }
  };
  return Meteor.setTimeout(function() {
    buildLine();
    buildDonut();
  }, 200);
});

Template.run.helpers({
  calendar: function(d) {
    return moment(d).calendar();
  },
  getPercentage: function() {
    var cocoaContent, ingredients, total;
    ingredients = Template.currentData().components;
    total = 0;
    cocoaContent = 0;
    _.each(ingredients, function(i) {
      if (i.name === 'beans' || i.name === 'cocoa butter') {
        cocoaContent += i.qty;
      }
      return total += i.qty;
    });
    if (total === 0) {
      return '';
    }
    return ((cocoaContent / total) * 100).toFixed(1);
  },
  cleanId: function() {
    return Template.currentData().machine;
  },
  machineName: function() {
    return Template.parentData(1).name || Template.parentData(1)._id;
  },
  actions: function(status) {
    return ACTIONS;
  },
  lastTemp: function() {
    var _tmp, temps;
    temps = Template.currentData().temps;
    _tmp = temps[temps.length - 1];
    if (_tmp === 'Temperature') {
      return '';
    }
    return _tmp;
  },
  lastTime: function() {
    var _tme, times;
    times = Template.currentData().times;
    _tme = times[times.length - 1];
    if (_tme === 'x') {
      return '';
    }
    return moment(_tme).calendar();
  },
  isStatus: function(statusName) {
    return statusName === Template.currentData().status;
  },
  isRogered: function() {
    return Template.currentData().roger;
  }
});

Template.run.events({
  'click .new-run': function(e, tmpl) {
    return Meteor.call('startRun', this.machine);
  },
  'click ul.action-menu a': function(e, tmpl) {
    var $tgt = $(e.currentTarget);
    if($tgt.hasClass('schedule')) {
      run = Template.currentData();
      return Session.set('modal', {
        name: 'scheduleModal',
        _id: run._id
      });
    } else {
      return Meteor.call('setCourse', Template.currentData()._id, this.name);
    }
  },
  'click .donut': function(e, tmpl) {
    var run;
    console.log('clicked donut');
    run = Template.currentData();
    return Session.set('modal', {
      name: 'compositionModal',
      _id: run._id
    });
  },
  'click a.closebox': function(e, tmpl) {
    console.log(this);
    console.log(e);
    console.log(tmpl);
    Runs.update(tmpl.data._id, {
      $pull: {
        scheduledActions: this
      }
    });
  }
});
