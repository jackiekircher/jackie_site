$('a.load-animation').click(function() {
  css = url.slice(0,-5) + ".css";
  $('style[name="animation"]').load(css);
  $('.animation-container').load(url + " #animation");
  $('.caption').load(url + " #caption");

  return false;
});
