Template.layout.helpers
    getModalName: ->
        Session.get('modal').name

    modal: ->
        Session.get('modal')
