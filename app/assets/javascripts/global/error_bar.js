


function show_error(message)
{
   var $errorbar = $("#errorbar");
   var $error_message = $("#errorbar #error_message");
   var current_message = $error_message.html();

   message = "<p>&bull; " + message + "</p>";
   if (current_message != "") {
      message = message + "<hr><hr><hr>" + current_message;
   }
   $error_message.html(message);

   if (!$errorbar.is(":visible")) {
      $errorbar.css("max-height", $("#body").height() / 2);
      $errorbar.show();
      autosize_body();
   }
   $errorbar.scrollTop(0);
}

function hide_errors()
{
   if ($("#footer #errorbar").is(":visible")) {
      $("#footer #errorbar").hide();
      $("#footer #errorbar #error_message").html("");
      autosize_body();
   }
}



