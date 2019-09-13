


givershop.note = {

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
            $("#user_permissions").hide();

            $("#autosave_enabled").click(function(event) {
               toggle_checked($(event.target));
               if (!is_checked($(event.target))) {
                  clearInterval(content.autosave_timer);
                  $("#autosave_timeout").text("");
               }
            });

            $("#note_edit_form :input").on("input", function(event) {
               if ($("#autosave_enabled").hasClass("checked")) {
                  content.start_autosave_timer();
               }
            });

            $("#users_list .checkbox").click(function(event) {
               toggle_checked($(event.target));
            });

            $("#note_edit_form").submit(function(event)
            {
/*
               $("#admin_id_list").val(get_checked_id_list($("#users_list"), "admin", "user_id"));
               $("#user_id_list") .val(get_checked_id_list($("#users_list"), "user",  "user_id"));
*/
            });
         });
      },

      callback: function(action, data)
      {
         switch (action) {

            case "submit":
               clearInterval(this.autosave_timer);
               $("#note_edit_form #update_action").val("back");
               $("#note_edit_form").submit();
               break;

            case "cancel":
               clearInterval(this.autosave_timer);
               history.back();
               break;

            case "update":
               if (data === "back") {
                  history.back();
               }
               else if (data === "autosave") {
                  $("#autosave_timeout").text("saved");
               }
               break;

            default:
               show_error(current_action + " callback: unhandled action \"" + action + "\"");
               break;
         }
      },

      autosave_timer: null,

      start_autosave_timer: function()
      {
         var autosave_countdown = null;
         var $autosave_timeout  = $("#autosave_timeout");

         if (this.autosave_timer != null) {
            clearInterval(this.autosave_timer);
         }
         autosave_countdown = 2;
         $autosave_timeout.text("in " + autosave_countdown + " minutes");
         this.autosave_timer = setInterval(function() {
            autosave_countdown--;
            $autosave_timeout.text("in " + autosave_countdown + " minutes");
            if (autosave_countdown == 0) {
               clearInterval(content.autosave_timer);
               content.autosave_timer = null;
               $("#autosave_timeout").text("saving...");
               $("#note_edit_form #update_action").val("autosave");
               $("#note_edit_form").submit();
            }
         }, 1000 * 60);
      }

   }

};



