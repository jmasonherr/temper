Template.compositionModal.onRendered ->
    @$('.modal').modal()
    runId = Session.get('modal')._id


Template.compositionModal.helpers
    run: ->
        return Runs.findOne(Session.get('modal')._id)


Template.compositionModal.events
    'click [data-dismiss="modal"]': (e, tmpl) ->
        Meteor.setTimeout ->
            Session.set 'modal', null
        , 600

    'click button.btn-primary': (e, tmpl) ->
        cleanData = _.map tmpl.$('form').serializeObject(), (d) ->
            name: d.name, qty: parseInt(d.value || 0)
        Runs.update Session.get('modal')._id,
            $set:
                components: cleanData

        Meteor.setTimeout ->
            tmpl.$('[data-dismiss="modal"]').click()
        , 600


