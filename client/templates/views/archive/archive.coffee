
Template.archive.onCreated ->
    @subscribe 'archive'


Template.archive.helpers
    runs: ->
        Runs.find()




