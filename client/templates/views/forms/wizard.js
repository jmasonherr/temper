Template.wizard.onRendered(function(){

    // Initialize iCheck plugin
    $('.i-checks').iCheck({
        checkboxClass: 'icheckbox_square-green',
        radioClass: 'iradio_square-green'
    });

    $('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
        $('a[data-toggle="tab"]').removeClass('btn-primary');
        $('a[data-toggle="tab"]').addClass('btn-default');
        $(this).removeClass('btn-default');
        $(this).addClass('btn-primary');
    })

});

Template.wizard.events({

    'click .next': function(event){
        var nextId = $(event.target).parents('.tab-pane').next().attr("id");
        $('[href=#'+nextId+']').tab('show');
    },
    'click .prev': function(event){
        var prevId = $(event.target).parents('.tab-pane').prev().attr("id");
        $('[href=#'+prevId+']').tab('show');
    },
    'click .submitWizard': function(){
        var approve = $(".approveCheck").is(':checked');
        if(approve) {
            // Got to step 1
            $('[href=#step1]').tab('show');

            // Serialize data to post method
            var datastring = $("#simpleForm").serialize();

            // Show notification
            swal({
                title: "Thank you!",
                text: "You approved our example form!",
                type: "success"
            });
        } else {
            // Show notification
            swal({
                title: "Error!",
                text: "You have to approve form checkbox.",
                type: "error"
            });
        }
    }


});