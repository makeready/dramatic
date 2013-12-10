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
  $('.profile_card').mouseenter(function () {
    $('.profile_card').css('background-color','rgba(255,255,255,0.9)');
    $('.profile_text').html("<a href='/signout'class='profile_sign_out'>Sign Out</a>");
  })
 
 $('.profile_card').mouseleave(function () {
    $('.profile_card').css('background-color','rgba(255,255,255,0.8)');
   $('.profile_text').html(username);
 })


  // fold.oriDomi('reveal', 80);
  // setTimeout(function(){
  //   fold.oriDomi('foldUp');
  // },3000);

  // var fold = $('h1').oriDomi({
  //   speed: 1000,
  //   shadingIntensity: 0
  // });


});