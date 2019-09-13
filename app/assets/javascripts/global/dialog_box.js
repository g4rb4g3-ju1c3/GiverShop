


var dialog_args = null;



function show_dialog(message, args)
{
   dialog_args = args;
   $("#dialogbox #dialog_message").html(message);
   $("#dialogbox #ok_button")     .toggle((typeof args.ok_button      !== "undefined") && (args.ok_button      !== false));
   $("#dialogbox #cancel_button") .toggle((typeof args.cancel_button  !== "undefined") && (args.cancel_button  !== false));
   $("#dialogbox #close_button")  .toggle((typeof args.close_button   !== "undefined") && (args.close_button   !== false));
   $("#dialogbox #save_button")   .toggle((typeof args.save_button    !== "undefined") && (args.save_button    !== false));
   $("#dialogbox #delete_button") .toggle((typeof args.delete_button  !== "undefined") && (args.delete_button  !== false));
   $("#dialogbox #discard_button").toggle((typeof args.discard_button !== "undefined") && (args.discard_button !== false));
   $("#popup_shield").show();
   $("#dialogbox").show();
   $("#dialogbox").innerWidth(Math.min($("#dialog_content").outerWidth(), $(window).width() - 50));
   $("#dialogbox").innerHeight($("#dialog_content").outerHeight());
}

function hide_dialog($dialog_button)
{
   if ($("#dialogbox") != null) {
      $("#dialogbox").hide();
      $("#popup_shield").hide();
      $("#dialogbox #dialog_message").html("");
      if (dialog_args != null) {
         switch ($dialog_button.attr("id")) {
            case "ok_button":
               if (typeof dialog_args.ok_button === "function") {
                  dialog_args.ok_button();
               }
               break;
            case "cancel_button":
               if (typeof dialog_args.cancel_button === "function") {
                  dialog_args.cancel_button();
               }
               break;
            case "close_button":
               if (typeof dialog_args.close_button === "function") {
                  dialog_args.close_button();
               }
               break;
            case "save_button":
               if (typeof dialog_args.save_button === "function") {
                  dialog_args.save_button();
               }
               break;
            case "delete_button":
               if (typeof dialog_args.delete_button === "function") {
                  dialog_args.delete_button();
               }
               break;
            case "discard_button":
               if (typeof dialog_args.discard_button === "function") {
                  dialog_args.discard_button();
               }
               break;
//            case "dialog_close_button":
//               break;
         }
         dialog_args = null;
      }
   }
}



