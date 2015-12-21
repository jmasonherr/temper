Template.archive.onCreated(function() {
  return this.subscribe('archive');
});

Template.archive.helpers({
  runs: function() {
    return Runs.find();
  }
});
