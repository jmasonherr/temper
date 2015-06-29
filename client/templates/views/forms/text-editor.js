Template.textEditor.onRendered(function(){

    // Initialize summernote plugin

    $('.summernote').summernote();

    $('.summernote1').summernote({
        toolbar: [
            ['headline', ['style']],
            ['style', ['bold', 'italic', 'underline', 'superscript', 'subscript', 'strikethrough', 'clear']],
            ['textsize', ['fontsize']],
            ['alignment', ['ul', 'ol', 'paragraph', 'lineheight']]
        ]
    });

    $('.summernote2').summernote({
        airMode: true
    });

});