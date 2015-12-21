Template.layout.helpers({
  getModalName: function() {
    return Session.get('modal').name;
  },
  modal: function() {
    return Session.get('modal');
  }
});
