


function autosize_datalist()
{
   var $datalist = $("#header #datalist");

   if ($datalist.length > 0) {
      $datalist.css("max-height", ($(window).height() - $("#header").height()) / 2);
   }
}

function hide_datalist()
{
   $("#header #toolbar_giver_box").blur();
}

function update_datalist(filter_matches) {
   var giver_text               = "";
   var search_text              = "";
   var show_datalist_add_button = true;
   var datalist_match_id        = "";
   var $giver_button            = $("#header #toolbar_giver_button");
   var $datalist_add_button     = $("#header #datalist_add_button");

   if ($("#header #datalist").length > 0) {
      giver_text = $("#header #toolbar_giver_box").val().trim().toLowerCase();
      if ((giver_text == "") && filter_matches) {
         show_datalist_add_button = false;
         $("#header #datalist").children().each(function(i, element) {
            $(element).show();
         });
      }
      else {
         $("#header #datalist").children().each(function(i, element) {
            search_text = $(element).attr("data-search-text");
            if (giver_text == search_text) {
               show_datalist_add_button = false;
               datalist_match_id = $(element).attr("data-list-row-id");
               if (filter_matches) {
                  $(element).show();
               }
               else {
                  return false;
               }
            }
            else if (filter_matches) {
               $(element).toggle(search_text.search(giver_text) > -1);
            }
         });
      }
   }

   if ((datalist_match_id !== undefined) && (datalist_match_id != "")) {
      $giver_button.attr("data-list-row-id", datalist_match_id);
   }
   else {
      $giver_button.removeAttr("data-list-row-id");
   }
   if (filter_matches) {
      $datalist_add_button.toggle(show_datalist_add_button);
      $datalist_add_button.toggleClass("disabled", !show_datalist_add_button);
   }
}

function datalist_set_row_state(object_id, in_list, row_id)
{
   var $datalist_row = null;

   $("#header #datalist").children().each(function(i, element) {
      if ($(element).attr("data-object-id") == object_id) {
         $datalist_row = $(element);
         return false;
      }
   });
   if ($datalist_row !== null) {
      $datalist_row.toggleClass("datalist-add icon-add", (in_list === false));
      if (in_list) {
         $datalist_row.attr("id", "datalist_row_" + row_id);
         $datalist_row.attr("data-list-row-id", row_id);
      }
      else {
         $datalist_row.removeAttr("id");
         $datalist_row.removeAttr("data-list-row-id");
      }
   }
}

function datalist_delete_row(row_id, object_id)
{
   var $datalist_row = $("#header #datalist #datalist_row_" + row_id);

   if ($datalist_row.attr("data-object-id") == object_id) {
      datalist_set_row_state(object_id, false, row_id);
   }
   else {
      $datalist_row.remove();
   }
}

function add_heading_to_datalist($element)
{
   var heading_text = $element.attr("data-heading-text");

   $("#header #datalist").append(
      "      <div class=\"datalist-row datalist-heading link enable-hover\"" +
      "           data-heading-text=\"" + heading_text + "\"" +
      "           data-search-text=\"" + heading_text.toLowerCase() + "\"" +
      "         <font class=\"click-through h3\">" + heading_text + "</font>" +
      "      </div>"
   );
}

/*
function delete_location_row()
{
}
*/



