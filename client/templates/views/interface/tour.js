Template.tour.onRendered(function(){


    // Flot charts line data and options
    var chartIncomeData = [
        {
            label: "line",
            data: [ [1, 10], [2, 26], [3, 16], [4, 36], [5, 32], [6, 51] ]
        }
    ];

    var chartIncomeOptions = {
        series: {
            lines: {
                show: true,
                lineWidth: 0,
                fill: true,
                fillColor: "#64cc34"

            }
        },
        colors: ["#62cb31"],
        grid: {
            show: false
        },
        legend: {
            show: false
        }
    };

    $.plot($("#flot-income-chart"), chartIncomeData, chartIncomeOptions);

});

Template.tour.events({

    'click .run-tour': function(){
        // Instance the tour
        var tour = new Tour({
            backdrop: true,
            onShown: function(tour) {

                // ISSUE    - https://github.com/sorich87/bootstrap-tour/issues/189
                // FIX      - https://github.com/sorich87/bootstrap-tour/issues/189#issuecomment-49007822

                // You have to write your used animated effect class
                // Standard animated class
                $('.animated').removeClass('fadeIn');
                // Animate class from animate-panel plugin
                $('.animated-panel').removeClass('zoomIn');

            },
            steps: [
                {
                    element: ".tour-1",
                    title: "Tour title",
                    content: "Add any components you want from the Homer theme - graphs, tables, calendars, lists, create your unique app view with Homer.",
                    placement: "top"

                },
                {
                    element: ".tour-2",
                    title: "Tour title",
                    content: "This is a 2 step on our tour. You can easy set a placement of tour tooltip.",
                    placement: "right"

                },
                {
                    element: ".tour-3",
                    title: "Tour title",
                    content: "In this 3 step is a description of how to use tour directive.",
                    placement: "left"

                }
            ]});

        // Initialize the tour
        tour.init();
        tour.restart();
    }

});