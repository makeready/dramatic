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

  // tweet card hover
  $('.tweet_card').mouseenter(function () {
    $(this).css('background-color','rgba(224, 238, 221,0.95)');
  });
  $('.tweet_card').mouseleave(function () {
    $(this).css('background-color','rgba(255,255,255,0.95)');
  });

  // tweet card paste to box
  $('.tweet_card').on('click', function (){
    var id = $(this).data('id');
    var user = $(this).data('user');
    $('.biginput').val('http://twitter.com/' + user + '/status/' + id);
  }); 

  // fold.oriDomi('reveal', 80);
  // setTimeout(function(){
  //   fold.oriDomi('foldUp');
  // },3000);

  // var fold = $('h1').oriDomi({
  //   speed: 1000,
  //   shadingIntensity: 0
  // });


});