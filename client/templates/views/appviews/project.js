Template.project.onRendered(function(){

    // Options for Line chart
    var lineData = {
        labels: ["January", "February", "March", "April"],
        datasets: [
            {
                label: "Example dataset",
                fillColor: "rgba(98,203,49,0.5)",
                strokeColor: "rgba(98,203,49,0.7)",
                pointColor: "rgba(98,203,49,1)",
                pointStrokeColor: "#fff",
                pointHighlightFill: "#fff",
                pointHighlightStroke: "rgba(26,179,148,1)",
                data: [17,21,19,24]
            }
        ]
    };

    var lineOptions = {
        scaleShowGridLines : true,
        scaleGridLineColor : "rgba(0,0,0,.05)",
        scaleGridLineWidth : 1,
        bezierCurve : false,
        pointDot : true,
        pointDotRadius : 3,
        pointDotStrokeWidth : 1,
        pointHitDetectionRadius : 20,
        datasetStroke : false,
        datasetStrokeWidth : 1,
        datasetFill : true,
        responsive: true,
        tooltipTemplate: "<%= value %>",
        showTooltips: true,
        onAnimationComplete: function()
        {
            this.showTooltip(this.datasets[0].points, true);
        },
        tooltipEvents: []
    };


    var ctx = document.getElementById("lineOptions").getContext("2d");
    var myNewChart = new Chart(ctx).Line(lineData, lineOptions);

});