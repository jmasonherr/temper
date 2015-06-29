Template.header.events({

    'click .hide-menu': function(event){

        event.preventDefault();

        if ($(window).width() < 769) {
            $("body").toggleClass("show-sidebar");
        } else {
            $("body").toggleClass("hide-sidebar");
        }
    }

});