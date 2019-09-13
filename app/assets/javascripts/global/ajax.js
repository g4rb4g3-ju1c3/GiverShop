


/*
$.ajaxSetup ({
   cache: false
});
*/

$(document).ajaxError(function(event, xhr, settings, error)
{
//   show_error(xhr.responseText != null? xhr.responseText : xhr.status + ": " + xhr.statusText);
//   show_error(status + ": " + error + "<br><br>&bull; " + xhr.status + ": " + xhr.statusText + "<br><br>" + xhr.responseText);
   show_error("<b>ajaxError</b> &bull; event: " + event + " &bull; error: " + error +
              "<br>&bull; URL: " + settings.url +
              "<hr>" +
              xhr.status + ": " + xhr.statusText + "<br><br>" +
              "<font style=\"font-size: 66%;\">" + xhr.responseText + "</font>");
});

$(document).ready(function()
{
//   log("global: update_current_state");
   update_current_state();
});



function ajax_error_handler(xhr, status, error)
{
//   show_error(xhr.responseText != null? xhr.responseText : xhr.status + ": " + xhr.statusText);
   show_error(status + ": " + error + "<hr>" +
              xhr.status + ": " + xhr.statusText + "<hr>" +
              xhr.responseText);
}



$(document).on("click", "a", function(event)
{
   var $this = $(this);

   if ($this.attr("href").trim().substring(0, 10).toLowerCase() != "javascript") {
      event.preventDefault();
      if ($this.attr("navigate") != "false") {
         navigate_to($this.attr("href"));
      }
   }
});

$(window).on("popstate", function(event)
{
//   log("popstate: state: url = " + window.location.href + ", state.scrollpos = " + state.scrollpos);
   var state = event.originalEvent.state;

   event.preventDefault;
   clear_giver_box();
   hide_errors();
   if (state !== null) {
      load_content(window.location.href, state.scrollpos, null);
   }
});

function update_current_state(url)
{
   if (url === null) {
      url = window.location.href;
   }
//   log("update_current_state: replacestate: " + url + ", " + get_scroll_pos());
   history.replaceState({
      scrollpos: get_scroll_pos()
   }, "", url);
}

function load_content(url, scrollpos, callback)
{
//   log("load_content");
   var $content = $("#content");

   hide_popups();
   hide_datalist();
   var load_indicator = setTimeout(function() {
      $("#load_indicator").fadeIn(1000);
   }, 250);
//   log("load_content: loading...");
   $.ajax({
      url:    url,
      method: "get",
      cache:  false,

      success: function(data, status, xhr) {
         clearTimeout(load_indicator);
         $("#load_indicator").hide();
         $("#header #datalist").remove();
/*
         log("load_content: status: " + status + "\n" +
             "                 xhr:       status: " + xhr.status + "\n" +
             "                        statusText: " + xhr.statusText + "\n" +
             "                 url: " + url);
*/
         $("#header #datalist").remove();
         $content.html(data);
         if (scrollpos != null) {
            scroll_to(scrollpos, false, null);
         }
         if (typeof callback === "function") {
            callback();
         }
         $content.focus();
      },

      error: function(xhr, status, error) {
         clearTimeout(load_indicator);
         $("#load_indicator").hide();
/*
         log("load_content: status: " + status + "\n" +
             "               error: " + error + "\n" +
             "                 xhr:       status: " + xhr.status + "\n" +
             "                        statusText: " + xhr.statusText + "\n" +
             "                      responseText: " + xhr.responseText);
*/
//         show_error(xhr.responseText != null? xhr.responseText : xhr.status + ": " + xhr.statusText);
      }
   });
}

function refresh_content()
{
   load_content(window.location.href, get_scroll_pos(), null);
}

function navigate_to(url)
{
//   log("navigate_to: from " + window.location.href + " => " + url);
   clear_giver_box();
   hide_errors();
   if (typeof toggle_quick_edit === "function") {
      toggle_quick_edit(null, null, false, null);
   }
   load_content(url, 0, function() {
//      log("callback: pushstate: " + url);
      history.pushState({}, "", url);
   });
}

function delete_to(url, prompt)
{
//   log("delete_to: " + url);
//   if (confirm(prompt)) {
   show_dialog(prompt, {
      cancel_button: true,
      delete_button: function() {
         if (typeof toggle_quick_edit === "function") {
            toggle_quick_edit(null, null, false, null);
         }
         $.ajax({
            url:    url,
            method: "delete",

            error: function(xhr, status, error) {
//               show_error(xhr.responseText != null? xhr.responseText : xhr.status + ": " + xhr.statusText);
               show_error(status + ": " + error + "<br><br>&bull; " + xhr.status + ": " + xhr.statusText + "<br><br>" + xhr.responseText);
            }
         });
      }
   });
}



