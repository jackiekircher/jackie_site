$('a.load-animation').click(function() {
  $link = $(this);

  url = $link.attr('href');
  css = url.slice(0,-5) + ".css";
  $('style[name="animation"]').load(css);
  $('.animation-container').load(url + " #animation");
  $('figcaption').load(url + " #caption");

  $('a.load-animation').removeClass("loaded");
  $link.addClass("loaded");

  return false;
});
