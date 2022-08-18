$(document).ready(function() {

  // Display "hover" effect on table cell colors
  $("td")
    .mouseenter(function() {
      var color = $(this).attr("class");
      var hoverColor = "dark" + color;
      $(this).css("background-color", hoverColor);
    })
    .mouseleave(function() {
      var color = $(this).attr("class");
      $(this).css("background-color", color);
    });

  // Trigger "hover" event
  $("td").mouseenter(function(){
    var color = this.className;
    console.log("Hovered on color: ", color);

    $.ajax({
      type: "POST",
      url: "http://localhost:3000/v1/events",
      data: { action_color: { action_name: "hover", color_name: color } },
      beforeSend: function (xhr) {
        xhr.setRequestHeader("Authorization", "Token token=testing");
      }
    });
  });

  // Trigger "click" event
  $("td").click(function(){
    var color = this.className;
    console.log("Clicked on color: ", color);

    $.ajax({
      type: "POST",
      url: "http://localhost:3000/v1/events",
      data: { action_color: { action_name: "click", color_name: color } },
      beforeSend: function (xhr) {
        xhr.setRequestHeader("Authorization", "Token token=testing");
      }
    });
  });
});
