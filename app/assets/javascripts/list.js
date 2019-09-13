


givershop.list = {

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

            $("#list_edit_form").submit(function(event)
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
               $("#list_edit_form").submit();
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

      list_id:   undefined,
      vendor_id: undefined,
      add_path:  undefined,
      list_path: undefined,

      init: function(args)
      {
         init_header(args);
         this.list_id   = args.list_id;
         this.vendor_id = args.vendor_id;
         this.add_path  = args.add_path;
         this.list_path = args.list_path;

         $("#select_vendor").change(function(event) {
            content.change_vendor(content.list_path, $(event.target).val());
         });

         $("#hide_checked_items").click(function(event) {
            var $checkbox = $(event.target);

            toggle_checked($checkbox);
            $("#items_list").find(".checked").each(function(i, element) {
               $(element).parents(".list-row").toggle(!is_checked($checkbox));
            });
         });

         $("#hide_misc_items").click(function(event) {
            var $checkbox = $(event.target);

            toggle_checked($checkbox);
            $("#items_list .list-heading").each(function(i, element) {
               if ($(element).attr("data-heading-text") == "Miscellaneous") {
                  $(element).toggle(!is_checked($checkbox))
                            .nextUntil(".list-heading").toggle(!is_checked($checkbox));
                  return false;
               }
            });
         });

         $("#items_list").on("click", ".checkbox", function(event) {
            var $checkbox = $(event.target);

            toggle_checked($checkbox);
            hide_errors();
            // PATCH not working in BB10 browser:
            $.ajax({
               url:    $checkbox.attr("data-update-checked-url"),
               method: "put",
               data: {
                  item: { checked: is_checked($checkbox) }
               },
               error: function(xhr, status, error) {
                  toggle_checked($checkbox);
                  show_error(xhr.responseText != null? xhr.responseText : xhr.status + ": " + xhr.statusText);
               }
            });
         });

         $("#items_list").on("click", ".list-row-link", function(event) {
            content.toggle_quick_edit($(event.target).attr("data-item-id"),
                                      $(event.target).attr("data-item-url"), true, null);
         });

         $("#items_list").on("click", ".item_quantity", function(event) {
            var quantity = parseInt($(event.target).text());

            if (isNaN(quantity)) {
               quantity = "";
            }
            $(event.target).hide();
            $(event.target).next().show()
                                  .children(".item_quantity_text_field").val(quantity)
                                                                        .attr("data-initial-value", quantity)
                                                                        .select();
         });

         $("#items_list").on("blur", ".item_quantity_text_field", function(event) {
            if ((!isNaN($(event.target).val())) && ($(event.target).attr("data-initial-value") != $(event.target).val())) {
               $(event.target).parent().submit();
            }
            else {
               $(event.target).parent().hide()
                                       .prev().show();
            }
         });
      },

      callback: function(action, data)
      {
         switch (action) {

            case "jump":
               $("#items_list #" + data).prev(".list-heading").show();
               $("#items_list #" + data).show();
               jump_to_row(data);
               break;

            case "jump_heading":
               $("#items_list").children().each(function(i, element) {
                  if ($(element).attr("data-heading-text") == data) {
                     $(element).show();
                     jump_to_element($(element));
                     return false;
                  }
               });
               break;

            case "add":
            case "submit":
               $.ajax({
                  url:    this.add_path,
                  method: "post",
                  data: {
                     vendor_id:  this.vendor_id,
                     product_id: (action == "add"    ? data : null),
                     add_text:   (action == "submit" ? data : null)
                  },
                  error: ajax_error_handler
               });
               break;

            // create handled by item#create JS partial item/_create.js.erb

            case "update":
               var quantity = $("#items_list #list_row_" + data + " .item_quantity_form").hide()
                                                                                         .children(".item_quantity_text_field").val();
               $("#items_list #list_row_" + data + " .item_quantity").toggleClass("disabled", quantity <= 0)
                                                                     .html(quantity > 0 ? quantity : "&ndash;")
                                                                     .show();
               break;

            case "destroy":
               content.toggle_quick_edit(null, null, true);
               delete_list_row(data.item_id);
               datalist_set_row_state(data.product_id, false, null);
               clear_giver_box();
               update_clear_button();
               update_giver_button();
               if ($("#items_list").children().length == 0) {
                  $("#items_list").remove();
                  $("#items_list #empty_list").show();
               }
               break;

            default:
               show_error(current_action + " callback: unhandled action \"" + action + "\"");
               break;
         }
      },

      populate_datalist_callback: function()
      {
         $("#items_list").children(".list-heading").each(function(i, element) {
            add_heading_to_datalist($(element));
         });
      },

      change_vendor: function(list_url, vendor_id)
      {
         hide_errors();
         load_content(list_url + "?vendor_id=" + vendor_id, null, null);
      },

      row_id_expanded: null,
      prev_scrollpos:  null,

      toggle_quick_edit: function(row_id, url, animate, callback)
      {
         var $item_quick_edit = $("#item_quick_edit_" + row_id);

         if (content.row_id_expanded !== null) {
            hide_errors();
            highlight_row(content.row_id_expanded, false);
            $("#item_quick_edit_" + content.row_id_expanded).addClass("hidden");
            $("#item_quick_edit_" + content.row_id_expanded).html("");
            if (row_id == content.row_id_expanded) {
               row_id = null;
            }
            content.row_id_expanded = null;
            if ((row_id === null) && (content.prev_scrollpos !== null)) {
               scroll_to(content.prev_scrollpos, animate, callback);
               content.prev_scrollpos = null;
            }
         }
         if (row_id !== null) {
            content.prev_scrollpos = get_scroll_pos();
            var load_indicator = setTimeout(function() {
               hide_errors();
               $item_quick_edit.html("<div class=\"table-cell\"><p class=\"h3\">Loading...</p></div>");
               $item_quick_edit.removeClass("hidden");
               content.row_id_expanded = row_id;
            }, 250);
            $item_quick_edit.load(url, function() {
               clearTimeout(load_indicator);
               hide_errors();
               highlight_row(row_id, true);
               $item_quick_edit.removeClass("hidden");
               content.row_id_expanded = row_id;
               scroll_to_row(row_id, false, animate, callback);
            });
/*
            $.ajax({
               url:     url,
               cache:   false,
               success: function(data) {
                  clearTimeout(load_indicator);
                  hide_errors();
                  $item_quick_edit.html(data);
                  highlight_row(row_id, true);
                  $item_quick_edit.removeClass("hidden");
                  content.row_id_expanded = row_id;
                  scroll_to_row(row_id, false, animate, callback);
               },
               error: ajax_error_handler
            });
*/
         }
      }
   }
};



