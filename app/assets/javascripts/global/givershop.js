


givershop = {

//   current_controller: undefined,
//   current_action:     undefined,

   init: function(args)
   {
      // application-wide code

//      this.current_controller = args.controller;
//      this.current_action     = args.action;
      content        = givershop[args.controller][args.action];
      current_action = args.controller + "#" + args.action;

      givershop[args.controller].init(args);
      givershop[args.controller][args.action].init(args);
   },

};

var content        = undefined;
var current_action = undefined;



$(window).resize(function(event)
{
   autosize_body();
   autosize_datalist();
});



function autosize_body()
{
   var window_height = $(window).height();
   var $body         = $("#body");
   var header_height = 0;
   var footer_height = 0;

   if (window_height < 250) {
      var $titlebar = $("#header #titlebar");
      if ($titlebar.is(":visible")) {
         $titlebar.hide();
      }
   }
   else {
      var $titlebar = $("#header #titlebar");
      if (!$titlebar.is(":visible")) {
         $titlebar.show();
      }
   }
   header_height = $("#header").height();

   if (window_height < 350) {
      var $footer = $("#footer");
      if ($footer.is(":visible")) {
         $footer.hide();
      }
   }
   else {
      var $footer = $("#footer");
      if (!$footer.is(":visible")) {
         $footer.show();
      }
      footer_height = $footer.height();
   }
//   log("autosize_body: " + header_height + ", " + footer_height);

   if ($body.css("top") != header_height) {
      $body.css("top", header_height);
   }
   if ($body.css("bottom") != footer_height) {
      $body.css("bottom", footer_height);
   }

   $("#content_pad").height((window_height - header_height - footer_height) / 2);
}

function body_height()
{
   return ($(window).height() - $("#header").height() - $("#footer").height());
}



/*
function alphanumeric(text)
{
   return text.replace(/\W/g, "");
}
*/

function cursor_at_eol(element)
{
   element.selectionStart = element.selectionEnd = element.value.length;
}



/*
function get_offset_rect(element)
{
   var box = element.getBoundingClientRect();

   var body    = document.body;
   var docElem = document.documentElement;

   var scrollTop  = window.pageYOffset || docElem.scrollTop  || body.scrollTop;
   var scrollLeft = window.pageXOffset || docElem.scrollLeft || body.scrollLeft;

   var clientTop  = docElem.clientTop  || body.clientTop  || 0;
   var clientLeft = docElem.clientLeft || body.clientLeft || 0;

   var top  = box.top  + scrollTop  - clientTop;
   var left = box.left + scrollLeft - clientLeft;

   return { top: Math.round(top), left: Math.round(left) };
}
*/



