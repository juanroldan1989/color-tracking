$(document).ready(function() {
  var rows = 10;
  var columns = 10;
  var table = $("<table>");

  for (var i = 0; i < columns; i++) {
    table.append("<tr>");

    for (var j = 0; j < rows; j++) {
      var colors = ["blue", "green", "red", "yellow"];
      var random = Math.floor(Math.random() * colors.length);
      table.append("<td class='" + colors[random] + "'></td>");
    };

    table.append("</tr>");
  };

  table.append("</table>");

  $("#table_colors").append(table);
});
