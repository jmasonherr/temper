
INGREDIENT_COLORS =
    milk: 'white'
    beans: 'brown'
    lecithin: 'yellow'

DONUT_OPTS =
    segmentShowStroke: true
    segmentStrokeColor: "#fff"
    segmentStrokeWidth: 2
    percentageInnerCutout: 45
    animationSteps: 100
    animationEasing: "easeOutBounce"
    animateRotate: true
    animateScale: false
    responsive: true

Template.run.onRendered ->
    self = @
    @$('.bean')
        .editable({autotext: 'never', emptytext: 'Bean name'})
        .on 'save', (e, params) ->
            #$(@).setValue('').hide()
            #setParams = {}
            #setParams[$(e.currentTarget).data('attr')] = params.newValue
            Runs.update self.data._id,
                $set: #setParams
                    title: params.newValue

    @$('.machine-name')
        .editable({autotext: 'never', emptytext: 'Machine name'})
        .on 'save', (e, params) ->
            Machines.update self.machine,
                $set:
                    name: params.newValue

    lineChart = null
    donutChart = null

    Runs.find(@data._id).observeChanges
        changed: (id, fields) ->
            if fields.components
                buildDonut()
            if fields.times or fields.temps
                buildLine()

    buildDonut = ->
        console.log 'observing donut'
        run = Runs.findOne self.data._id


        donutData = _.map run.components, (c) ->
            value: c.qty
            label: c.name
            color: INGREDIENT_COLORS[c.name] || '#62cb31'
            highlight: "#57b32c"


        donut = self.find('canvas.donut')
        donutChart = new Chart(donut.getContext("2d")).Doughnut(donutData,DONUT_OPTS)

    buildLine = ->
        console.log 'observing line'
        run = Runs.findOne self.data._id

        lineElem = self.find('.flot-line-chart')

        chartParams =
            bindto: lineElem
            data:
                x: 'x'
                columns: [
                    run.times
                    run.temps
                ]
            axis:
                x:
                    type: 'timeseries'
                    tick:
                        format: (t) -> moment(t).format('h:mm a')


        if lineChart # update chart
            lineChart.load
                columns: [
                    run.times
                    run.temps
                ]
        else  # load data
            lineChart = c3.generate chartParams
    Meteor.setTimeout ->
        buildLine()
        buildDonut()
    , 200


Template.run.helpers
    getPercentage: ->
        ingredients = Template.currentData().components
        total = 0
        cocoaContent = 0
        _.each ingredients, (i) ->
            if i.name == 'beans' or i.name == 'cocoa butter'
                cocoaContent += i.qty
            total += i.qty
        if total == 0
            return ''
        return ((cocoaContent / total) * 100).toFixed(1)

    cleanId: ->
        Template.currentData().machine

    machineName: ->
        Template.parentData(1).name || Template.parentData(1)._id

    actions: (status) ->
        ACTIONS

    lastTemp: ->
        temps = Template.currentData().temps
        _tmp = temps[temps.length - 1]
        if _tmp == 'Temperature'
            return ''
        _tmp

    lastTime: ->
        times = Template.currentData().times
        _tme = times[times.length - 1]
        if _tme == 'x'
            return ''
        moment(_tme).calendar()

    isStatus: (statusName) ->
        statusName == Template.currentData().status

    isRogered: ->
        Template.currentData().roger

Template.run.events
    'click ul.action-menu a': (e, tmpl) ->
        Meteor.call 'setCourse', Template.currentData()._id, @name
        # Runs.update Template.currentData()._id,
        #     $set:
        #         status: @name
        #         roger: false
        #     $push:
        #         actionHistory:
        #               action: @name
        #               at: new Date

    'click .donut': (e, tmpl) ->
        console.log 'clicked donut'
        run = Template.currentData()
        Session.set 'modal', {name: 'compositionModal', _id: run._id}
