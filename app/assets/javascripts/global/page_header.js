


   function init_header(args)
   {
//      log("init_header");
      var page_title = "Give'rShop";
      var show_toolbar_giver_bar      = (args.search_bar === true);
      var show_toolbar_form_controls  = (args.edit_form  === true);
      var show_toolbar_view_controls  = (typeof args.save_path === "string");

      if (typeof args.page_title === "string") {
         page_title += ": " + args.page_title;
      }
      else if (typeof args.title === "string") {
         page_title += ": " + args.title;
      }
      document.title = page_title;

      $("#header #title")   .html(typeof args.title    === "string" ? args.title    : "");
      $("#header #subtitle").html(typeof args.subtitle === "string" ? args.subtitle : "");

      if (show_toolbar_giver_bar) {
         $("#header #toolbar_giver_box").attr("placeholder", (typeof args.placeholder === "string" ? args.placeholder : ""));
         update_clear_button();
         update_giver_button();
      }
      $("#header #toolbar_giver_bar").toggle(show_toolbar_giver_bar);

      $("#header #toolbar_form_buttons").toggle(show_toolbar_form_controls);

//      $("#header #save_button").attr("save_path", (show_toolbar_view_controls ? args.save_path : ""));
//      $("#header #toolbar_view_buttons").toggle(show_toolbar_view_controls);

      autosize_body();
   }

   $(document).ready(function()
   {
      var $menu       = $("#hamburger_menu");
      var $crapulator = $("#crapulator");

      $("#popup_shield").hide();

      $menu          .addClass("popup-flag");
      $menu.find("*").addClass("popup-flag");
      $menu.find("a").removeClass("popup-flag");

      $n1 = $("#crapulator #numerator1"  );
      $d1 = $("#crapulator #denominator1");
      $n2 = $("#crapulator #numerator2"  );
      $d2 = $("#crapulator #denominator2");
      $crapulator          .addClass("popup-flag");
      $crapulator.find("*").addClass("popup-flag");



      $("#header #titlebar").click(function(event)
      {
         if ($("#header #main_toolbar").is(":visible")) {
            hide_datalist();
            $("#header #main_toolbar").hide();
            clear_giver_box();
            update_clear_button();
            update_giver_button();
         }
         else {
            $("#header #main_toolbar").show();
         }
         autosize_body();
      });

      $("#header #hamburger_button").click(function(event)
      {
         $("#popup_shield").show();
         $("#header #hamburger_menu").show();
         event.stopPropagation();
      });

      $("#popup_shield").click(function(event)
      {
         if (!$("#dialogbox").is(":visible")) {
            hide_popups();
         }
         event.stopPropagation();
      });

      $("#header #toolbar_giver_box").on("input", function(event) {
         var typing_timeout = null;

         update_clear_button();
         if ($("#datalist").length != 0) {
            clearTimeout(typing_timeout);
            typing_timeout = setTimeout(function() {
               update_datalist(true);
               update_giver_button();
            }, 250);
         }
      })
      .focus(function(event)
      {
         update_datalist(true);
         $("#header #datalist").show();
      })
      .blur(function(event)
      {
         $("#header #datalist").hide();
      });

      $("#header #toolbar_clear_button").mousedown(function(event)
      {
         event.preventDefault();
      });

      $("#header .toolbar-button").click(function(event)
      {
         if (!$(event.target).hasClass("disabled") && (typeof content.callback === "function")) {
            switch ($(event.target).attr("id")) {

               case "toolbar_giver_button":
                  var list_row_id = $(event.target).attr("data-list-row-id");

                  if ((list_row_id !== undefined) && (list_row_id != "")) {
                     content.callback("jump", list_row_id);
                  }
                  else {
                     content.callback("submit", $("#header #toolbar_giver_box").val());
                  }
                  break;

               case "toolbar_clear_button":
                  clear_giver_box();
                  update_datalist(true);
                  update_clear_button();
                  update_giver_button();
                  break;

               case "toolbar_form_ok_button":
                  content.callback("submit", null);
                  break;

               case "toolbar_form_cancel_button":
                  content.callback("cancel", null);
                  break;

/*
               case "toolbar_form_close_button":
                  content.callback("close", null);
                  break;

               case "toolbar_form_save_button":
                  content.callback("save", null);
                  break;
*/
            }
         }
      });

      $("#header #toolbar_giver_form").submit(function(event)
      {
         $("#header #toolbar_giver_button").click();
         event.preventDefault();
         return false;
      });

      $(".dialog-button").click(function(event)
      {
         hide_dialog($(event.target));
      });
   });

/*
   $(document).click(function(event)
   {
      if ($(event.target).is("#popup_shield")) {
         hide_popups();
      }
      if ($(event.target).is(".hamburger_button")) {
         $("#popup_shield")  .show();
         $("#hamburger_menu").show();
      }
      else if (!$(event.target).hasClass("popup-flag")) {
         hide_popups();
      }
   });
*/



   function toggle_crapulator()
   {
      var $crapulator = $("#crapulator");

      if ($crapulator.is(":visible")) {
         $crapulator       .hide();
         $("#popup_shield").hide();
      }
      else {
         $crapulator       .show();
         $("#popup_shield").show();
      }
   }

   var $n1, $d1, $n2, $d2;

   function crapulate()
   {
      $n2.val( ( ( parseFloat($n1.val()) * parseFloat($d2.val()) ) / parseFloat($d1.val()) ).toFixed(2) );
   }



   function hide_popups()
   {
      $("#hamburger_menu").hide();
      $("#crapulator")    .hide();
      $("#popup_shield")  .hide();
   }



   function clear_giver_box()
   {
      $("#header #toolbar_giver_box").val("");
      $("#header #toolbar_giver_button").removeAttr("data-list-row-id");
   }

   function update_clear_button()
   {
      $("#header #toolbar_clear_button").toggleClass("disabled", ($("#header #toolbar_giver_box").val() == ""));
   }

   function update_giver_button()
   {
      var $toolbar_giver_button = $("#header #toolbar_giver_button");

      if ($("#header #toolbar_giver_box").val().trim() == "") {
         $toolbar_giver_button.addClass("disabled");
         $toolbar_giver_button.addClass("icon-giver");
         $toolbar_giver_button.removeClass("icon-add");
         $toolbar_giver_button.removeClass("icon-go");
         $("#header #datalist_add_button").addClass("disabled");
      }
      else {
         $toolbar_giver_button.removeClass("disabled");
         $toolbar_giver_button.removeClass("icon-giver");
         if (typeof $toolbar_giver_button.attr("data-list-row-id") === "string") {
            $toolbar_giver_button.removeClass("icon-add");
            $toolbar_giver_button.   addClass("icon-go");
         }
         else {
            $toolbar_giver_button.removeClass("icon-go");
            $toolbar_giver_button.   addClass("icon-add");
         }
         $("#header #datalist_add_button").removeClass("disabled");
      }
   }



