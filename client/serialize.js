$.fn.serializeObject = function() {
  var a, o;
  o = {};
  a = this.serializeArray();
  return $.each(a, function() {
    if (o[this.name] !== void 0) {
      if (!o[this.name].push) {
        o[this.name] = [o[this.name]];
      }
      o[this.name].push(this.value || '');
    } else {
      o[this.name] = this.value || '';
    }
    return o;
  });
};
