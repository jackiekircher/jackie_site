$(document).ready(function(){
    // add prettyprint class to all <pre><code></code></pre> blocks
    var prettify = false;
    $("pre code").parent().each(function() {
      $(this).addClass('prettyprint');
      prettify = true;
    });

    // if code blocks were found, bring in the prettifier ...
    if ( prettify ) {
      $.getScript("/javascript/prettify.js", function() { prettyPrint() });
    }
});


$("h1").fitText(0.8, { minFontSize: '20px', maxFontSize: '60px' });

$(window).on('resize', hideEmptyNav);


function hideEmptyNav() {
  $pageNav = $('ul.page-nav');
  if ($pageNav.html().trim()) { return; }

  if ($(this).width() < 720) {
    $pageNav.hide();
  } else {
    $pageNav.show();
  };
}
