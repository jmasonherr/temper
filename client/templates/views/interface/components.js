Template.components.onRendered(function(){

    // Initialize tooltips
    $('.tooltip-demo').tooltip({
        selector: "[data-toggle=tooltip]"
    })

    // Initialize popover
    $("[data-toggle=popover]").popover({
        trigger: 'focus'
    });

    // Initialize star rating
    $("#input-1").rating();

});