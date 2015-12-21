Template.bean.helpers({
    beanString: function(bean) {
        return 'bean name';
    }
});


Template.beans.helpers({
    beans: function() {
        return Beans.find();
    }
});
