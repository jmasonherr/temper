Template.transitionOverview.events({

    'click .runAnimation': function(){

        // Store old and new selected effect
        var oldEffect = $('.setEffect').attr('data-effect');
        var newEffect = $(".animation-select").val();

        // Store html to "refresh it" - remove and append
        var panels = $('#acontainer').html();

        // Simple replace all effect
        var panelsNewEffect = panels.replace(new RegExp(oldEffect, 'g'),newEffect )

        // Remove old code with old effect
        $('.runIt').remove();

        // Append new code with new effect
        setTimeout(function(){
            $('#acontainer').append(panelsNewEffect);
        })
    }

});