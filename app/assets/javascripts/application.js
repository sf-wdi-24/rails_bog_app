// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require motion-ui.js
//= require foundation
//= require turbolinks
//= require_tree .

$(function(){ $(document).foundation(); 
  console.log('meow')

  //flash message fade out after 3 secs
  $('#flashMsg').delay(3000).fadeOut('slow')

  // $animate = $("#animate-this");
  //   MotionUI.animateOut($animate, 'fade-out', function() {
  //     console.log('Transition done!');
  // });
});
