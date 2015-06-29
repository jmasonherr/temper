Template.alerts.onRendered(function(){
    toastr.options = {
        "debug": false,
        "newestOnTop": false,
        "positionClass": "toast-top-center",
        "closeButton": true,
        "debug": false,
        "toastClass": "animated fadeInDown"
    };

});

Template.alerts.events({

    'click .demo1': function () {
        swal({
            title: "Welcome in Alerts",
            text: "Lorem Ipsum is simply dummy text of the printing and typesetting industry."
        });
    },
    'click .demo2': function () {
        swal({
            title: "Good job!",
            text: "You clicked the button!",
            type: "success"
        });
    },
    'click .demo3': function () {
        swal({
                title: "Are you sure?",
                text: "Your will not be able to recover this imaginary file!",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, delete it!"
            },
            function () {
                swal("Booyah!");
            });
    },
    'click .demo4': function () {
        swal({
                title: "Are you sure?",
                text: "Your will not be able to recover this imaginary file!",
                type: "warning",
                showCancelButton: true,
                confirmButtonColor: "#DD6B55",
                confirmButtonText: "Yes, delete it!",
                cancelButtonText: "No, cancel plx!",
                closeOnConfirm: false,
                closeOnCancel: false
            },
            function (isConfirm) {
                if (isConfirm) {
                    swal("Deleted!", "Your imaginary file has been deleted.", "success");
                } else {
                    swal("Cancelled", "Your imaginary file is safe :)", "error");
                }
            });
    },


    'click .homerDemo1':function(){
        toastr.info('Info - This is a custom Homer info notification');
    },
    'click .homerDemo2':function(){
        toastr.success('Success - This is a Homer success notification');
    },
    'click .homerDemo3':function(){
        toastr.warning('Warning - This is a Homer warning notification');
    },
    'click .homerDemo4':function(){
        toastr.error('Error - This is a Homer error notification');
    }

});