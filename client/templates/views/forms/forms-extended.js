Template.formsExtended.onRendered(function(){

    // Datapicker options

    $('#datepicker').datepicker();
    $('#datapicker2').datepicker();
    $('.input-group.date').datepicker();
    $('.input-daterange').datepicker();

    // TouchSpin options

    $("#demo1").TouchSpin({
        min: 0,
        max: 100,
        step: 0.1,
        decimals: 2,
        boostat: 5,
        maxboostedstep: 10
    });

    $("#demo2").TouchSpin({
        verticalbuttons: true
    });

    $("#demo3").TouchSpin({
        postfix: '%'
    });

    $("#demo4").TouchSpin({
        postfix: "a button",
        postfix_extraclass: "btn btn-default"
    });

    // Select2 initialize
    $(".js-source-states").select2();
    $(".js-source-states-2").select2();

    // X-editable initialize

    // Turn to inline mode
    $.fn.editable.defaults.mode = 'inline';

    // Defaults
    $.fn.editable.defaults.url = '#';

    $('#username').editable({
        url: '#',
        type: 'text',
        pk: 1,
        name: 'username',
        title: 'Enter username'
    });

    $('#firstname').editable({
        validate: function(value) {
            if($.trim(value) == '') return 'This field is required';
        }
    });

    $('#sex').editable({
        prepend: "not selected",
        source: [
            {value: 1, text: 'Male'},
            {value: 2, text: 'Female'}
        ],
        display: function(value, sourceData) {
            var colors = {"": "gray", 1: "green", 2: "blue"},
                elem = $.grep(sourceData, function(o){return o.value == value;});

            if(elem.length) {
                $(this).text(elem[0].text).css("color", colors[value]);
            } else {
                $(this).empty();
            }
        }
    });

    $('#dob').editable();

    $('#event').editable({
        placement: 'right',
        combodate: {
            firstItem: 'name'
        }
    });

    $('#comments').editable({
        showbuttons: 'bottom'
    });

    $('#fruits').editable({
        pk: 1,
        limit: 3,
        source: [
            {value: 1, text: 'banana'},
            {value: 2, text: 'peach'},
            {value: 3, text: 'apple'},
            {value: 4, text: 'watermelon'},
            {value: 5, text: 'orange'}
        ]
    });

    $('#user .editable').on('hidden', function(e, reason){
        if(reason === 'save' || reason === 'nochange') {
            var $next = $(this).closest('tr').next().find('.editable');
            if($('#autoopen').is(':checked')) {
                setTimeout(function() {
                    $next.editable('show');
                }, 300);
            } else {
                $next.focus();
            }
        }
    });

});