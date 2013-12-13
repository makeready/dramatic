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

  // enable submit button on input
  $('.biginput').keyup(function() {
   if($(this).val() !== '') {
    $('.submit_button').fadeIn();
  } else {
    $('.submit_button').fadeOut();
  }
  });

  // change button & fold dom after click
  $('.submit_button').on('click', function (event) {
    //event.preventDefault();
    $('.submit_button').val('Please wait...').animate({backgroundColor: '#c4835b'});

    window.setTimeout(function () {
      $('.submit_button').fadeOut(2000);
      }, 3000);

      var fold = new OriDomi('.logged_in_section',{
        speed: 3000
      });

      fold.foldUp(function () {
        $('.logged_in_section').slideUp();
      });
  });


});