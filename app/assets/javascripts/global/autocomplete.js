


function autocomplete($textbox, text)
{
   $textbox.val(select_next_word($textbox.val(), text));
   cursor_at_eol(document.getElementById($textbox.attr("id")));
}

function select_next_word(existing_text, search_text)
{
   var new_text        = existing_text;
   var subtext_index   = 0;
   var subtext         = "";
   var next_word_index = 0;

   existing_text = existing_text.trim();
   search_text   = search_text.trim() + " ";
   subtext_index = existing_text.length;
   if (existing_text != search_text.substr(0, subtext_index)) {
      subtext_index = 0;
   }
   subtext = search_text.substr(subtext_index);
   next_word_index = subtext.search(/\S/);
   if (next_word_index != -1) {
      new_text = search_text.substring(0, subtext_index + next_word_index + subtext.substr(next_word_index).search(/\s/)) + " ";
   }

   return new_text;
}



