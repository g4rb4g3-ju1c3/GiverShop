


function refresh_list(row_id)
{
   load_content(window.location.href, null, function() {
      clear_giver_box();
      update_clear_button();
      update_giver_button();
      hide_datalist();
      hide_errors();
      scroll_to_row(row_id, true, true);
      highlight_row(row_id, true, true);
   });
}

function delete_list_row(row_id)
{
   var $list_row = $("#list_row_" + row_id);

   $("#item_quick_edit_" + row_id).remove();

   var $list_row_prev = $list_row.prev();
   var $list_row_next = $list_row.next();

   if ($list_row_prev.hasClass("list-heading") &&
       (($list_row_next.length == 0) || $list_row_next.hasClass("list-heading")) ) {
      $list_row_prev.remove();
   }
   $list_row.remove();
}



