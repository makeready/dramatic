$(document).ready(function () {

  // init flowtype
  $('h1').flowtype();

  // init nprogress options
  NProgress.configure({
    minimum: 0.2,
    trickleSpeed: 3000
  });

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
    event.preventDefault();
    url = $('.biginput').val();
    $.ajax({
      method: 'POST',
      dataType: 'json',
      data: {tweet: {url: url}},
      url: '/tweets',
      beforeSend: function () {
        NProgress.start();
        $('.submit_button').val('Contacting Twitter, please wait...').animate({backgroundColor: '#c4835b'});
          var fold = new OriDomi('.logged_in_section',{speed: 3000});
          fold.foldUp(function () {
            $('.logged_in_section').slideUp();
        });
      },
      complete: function () {
        console.log("AJAX complete");
        NProgress.done();
        $('.submit_button').fadeOut(2000);
      }
    }).done(function(data){
      console.log("AJAX success");
      $('#results').append(data);
    }).fail(function () {
      console.log("AJAX failed");
      $('#results').append("AJAX failed, please try again.");
    });
  });


});





