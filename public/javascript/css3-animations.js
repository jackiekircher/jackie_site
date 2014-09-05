$('a.load-animation').click(function() {
  url = $(this).attr('href');
  css = url.slice(0,-5) + ".css";
  $('style[name="animation"]').load(css);
  $('.animation-container').load(url + " #animation");

  return false;
});
