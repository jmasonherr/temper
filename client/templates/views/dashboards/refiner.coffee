Template.refiner.onCreated ->
    @subscribe 'latest', @data._id # -> # onReady

Template.refiner.helpers
    runs: (machineId) ->
        Runs.find machine: machineId,
            sort:
                createdAt: -1
            limit: 1
