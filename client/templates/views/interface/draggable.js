Template.draggable.onRendered(function(){

    var element = "[class*=col]";
    var handle = ".panel-body";
    var connect = "[class*=col]";
    $(element).sortable(
        {
            handle: handle,
            connectWith: connect,
            tolerance: 'pointer',
            forcePlaceholderSize: true,
            opacity: 0.8
        })
        .disableSelection();

});