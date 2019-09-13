


givershop.group = {

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
      },

      callback: function(action, data)
      {
         switch (action) {

            case "jump":
               jump_to_row(data);
               break;

            case "submit":
               $.ajax({
                  url:    this.add_path,
                  method: "post",
                  data: {
                     add_text: data
                  },
                  error: ajax_error_handler
               });
               break;

            case "create":
               refresh_list(data);
               break;

            case "destroy":
               delete_list_row(data);
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

         $(document).ready(function()
         {
            $("#users_list .checkbox").click(function(event) {
               toggle_checked($(event.target));
            });

            $("#select_all_admins").click(function(event) {
               toggle_checked($(event.target));
               check_all($(event.target), $("#users_list"), "admin");
            });

            $("#select_all_users").click(function(event) {
               toggle_checked($(event.target));
               check_all($(event.target), $("#users_list"), "user");
            });

            $("#list_edit_form").submit(function(event)
            {
               $("#admin_id_list").val(get_checked_id_list($("#users_list"), "admin", "user_id"));
               $("#user_id_list") .val(get_checked_id_list($("#users_list"), "user",  "user_id"));
            });
         });
      },

      callback: function(action, data)
      {
         switch (action) {

            case "submit":
               $("#group_edit_form").submit();
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

   }

};



