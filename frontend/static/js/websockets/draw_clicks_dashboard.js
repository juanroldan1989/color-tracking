$(document).ready(function() {
  var cable = ActionCable.createConsumer('ws://localhost:3000/v1/events/cable')

  cable.subscriptions.create("ClicksChannel", {
    connected: function() {
      console.log("You've subscribed to the Clicks Channel");
    },
    disconnected: function() {
      console.log("You've disconnected from the Clicks Channel");
    },
    received: function (data) {
      console.log("Received data: ", data);

      var results = data.results;
      console.log("Received results: ", results);

      var colors = [];
      var colorsAndAmounts = {};

      $.each(results, function( key, val ) {
        colors.push(val.color);
        colorsAndAmounts[val.color] = parseInt(val.amount);
      });

      console.log(colors);
      console.log(colorsAndAmounts);

      // set the dimensions and margins of the graph
      var width = 350
          height = 350
          margin = 40

      // The radius of the pieplot is half the width or half the height (smallest one). I subtract a bit of margin.
      var radius = Math.min(width, height) / 2 - margin

      // remove old graph to allow new graph to be rendered
      $("#clicks_dashboard").html("");

      // append the svg object to the div called 'clicks_dashboard'
      var svg = d3.select("#clicks_dashboard")
        .append("svg")
          .attr("width", width)
          .attr("height", height)
        .append("g")
          .attr("transform", "translate(" + width / 2 + "," + height / 2 + ")");

      var data = {
        a: colorsAndAmounts["blue"],
        b: colorsAndAmounts["green"],
        c: colorsAndAmounts["red"],
        d: colorsAndAmounts["yellow"]
      }

      console.log(data);

      // set the color scale
      var color = d3.scaleOrdinal()
        .domain(data)
        .range(colors)

      // Compute the position of each group on the pie:
      var pie = d3.pie()
        .value(function(d) {return d.value; })
      var data_ready = pie(d3.entries(data))

      // shape helper to build arcs:
      var arcGenerator = d3.arc()
        .innerRadius(50)
        .outerRadius(radius)

      // Build the pie chart: Basically, each part of the pie is a path that we build using the arc function.
      svg
        .selectAll("whatever")
        .data(data_ready)
        .enter()
        .append("path")
        .attr("d", d3.arc()
          .innerRadius(50)         // This is the size of the donut hole
          .outerRadius(radius)
        )
        .attr("fill", function(d){ return(color(d.data.key)) })
        .attr("stroke", "grey")
        .style("stroke-width", "5px")
        .style("opacity", 0.7)

      // Adding numbers inside each piece of the pie chart
      svg
        .selectAll("whatever")
        .data(data_ready)
        .enter()
        .append("text")
        .text(function(d){ return d.data.value })
        .attr("transform", function(d) { return "translate(" + arcGenerator.centroid(d) + ")";  })
        .style("text-anchor", "middle")
        .style("font-size", 30)

      // Adding "Clicks" title inside pie chart
      svg.append("text")
         .attr("text-anchor", "middle")
         .style("font-size", 25)
         .text("Clicks");
    }
  });
});
