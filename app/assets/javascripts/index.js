$(document).ready(function () {

  // init flowtype
  $('h1').flowtype();

  // bounce input button
  setTimeout(function () {
    $('.sign_in_button').effect({
      effect: "bounce",
    },500);
  },6000);

  // get username
  var username = $('.profile_text').html();

  // mouseover logout for profile box
  $('.profile_top').mouseenter(function () {
    $('.profile_text').html("<a href='/signout'class='profile_sign_out'>Sign Out</a>");
  });
  $('.profile_top').mouseleave(function () {
   $('.profile_text').html(username);
  });

  // var fold = $('.logged_in_section').oriDomi({
  //   speed: 1000
  // });

  // fold.oriDomi('reveal', 20);
  // setTimeout(function(){
  //   fold.oriDomi('foldUp');
  // },3000);

});