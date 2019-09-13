


givershop.user = {

   init: function(args)
   {
      // controller-wide code
   },



   index: {

      add_path: undefined,

      init: function(args)
      {
         init_header(args);
         this.add_path = args.add_path;

         $(window).resize(this.update_list_width);
         this.update_list_width();
      },

      callback: function(action, data)
      {
         switch (action) {

            case "jump":
               jump_to_element(data);
               break;

            case "submit":
               navigate_to(this.add_path + "?username=" + data);
/*
               $.ajax({
                  url:    this.add_path,
                  method: "get",
                  data: {
                     add_text: data
                  },
                  error: ajax_error_handler
               });
*/
               break;

            case "destroy":
               delete_list_row(data);
               break;

            default:
               show_error(current_action + " callback: unhandled action \"" + action + "\"");
               break;
         }
      },

      update_list_width: function()
      {
         $("#user_list").find(".user_info").each(function(i, element) {
            var $this           = $("#user_list #" + element.getAttribute("id"));
            var this_width      = $this.width();
            var $username       = $this.children("#username");
            var username_width  = $username.width();
            var username_height = $username.height();
            var $name           = $this.children("#name");
            var name_width      = $name.width();

            if (username_width + name_width > this_width) {
               $this.height(username_height + $name.height());
               $name.css("left", "0");
               $name.css("top",  username_height);
            }
            else {
               $this.height(username_height);
               $name.css("left", username_width);
               $name.css("top",  "1em");
            }
            if (this_width < username_width) {
               $username.css("width", this_width);
            }
            else {
               $username.css("width", "auto");
            }
            if (this_width < name_width) {
               $name.css("width", this_width);
            }
            else {
               $name.css("width", "auto");
            }
         });
      }

   },



   new: {

      init: function(args)
      {
         init_header(args);
      },

      callback: function(action, data)
      {
         switch (action) {

            case "submit":
               $("#user_edit_form").submit();
               break;

            case "create":
            case "cancel":
               history.back();
               break;

            default:
               show_error(current_action + " callback: unhandled action \"" + action + "\"");
               break;
         }
      }

   },



   edit: {

      init: function(args)
      {
         init_header(args);
      },

      callback: function(action, data)
      {
         switch (action) {

            case "submit":
               $("#user_edit_form").submit();
               break;

            case "update":
            case "cancel":
               history.back();
               break;

            default:
               show_error(current_action + " callback: unhandled action \"" + action + "\"");
               break;
         }
      }

   },



   show: {

      update_settings_path: undefined,

      init: function(args)
      {
         init_header(args);
         this.update_settings_path = args.update_settings_path;

         $(document).ready(function()
         {
            $("#show_advanced").click(function(event) {
               toggle_checked($(event.target));
//               set_setting("show_advanced", is_checked($(this)));
               $.post({
                  url:  content.update_settings_path,
                  data: { show_advanced: is_checked($(this)) }
               });
            });
         });
      },

      callback: function(action, data)
      {
         switch (action) {

            case "submit":
               break;

            case "update":
            case "cancel":
               history.back();
               break;

            case "update_settings":
               break;

            default:
               show_error(current_action + " callback: unhandled action \"" + action + "\"");
               break;
         }
      }

   }

};



