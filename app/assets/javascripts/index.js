$(document).ready(function () {

  // init AJAX
  set_ajax();

  // init nprogress options
  NProgress.configure({
    minimum: 0.2,
    trickleSpeed: 400
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
  var submitted = false;

  $('.biginput').keyup(function() {
    if($(this).val() !== '' && submitted === false ) {
      var input = $('.biginput').val();
      if ( input.indexOf("twitter.com/") !== -1 ) {
        $('.submit_button').fadeIn();
          } else {
            $('.submit_button').fadeOut();
          }
    } else {
      $('.submit_button').fadeOut();
    }
  });

});

// DEFINED FUNCTIONS

// hooks AJAX loop onto submit button
function set_ajax() {
  $('.submit_button').on('click', function (event) {
    event.preventDefault();
    $('.submit_button').attr("disabled", true);
    submitted = true;
    url = $('.biginput').val();
    ajax(url);
  });
}

// ajax itself
function ajax(url) {
  $.ajax({
    method: 'POST',
    dataType: 'script',
    data: {tweet: {url: url}},
    url: '/tweets',

    beforeSend: function () {
      NProgress.start();
      $('.submit_button').val('Demystifying...').animate({backgroundColor: '#ff6626', color: '#ffffff'});
      if ( $('.logged_in_section').length > 0 ) {
        var fold = new OriDomi('.logged_in_section',{speed: 2000});
        fold.foldUp(function () {
          $('.logged_in_section').slideUp();
        });
      }
    },

    error: function () {
      alert("Something went wrong :/ please try the same tweet again");
      ajax(url);
    },

    complete: function () {
      NProgress.done();
    }

  });
}


// bind mouseover and onclick events to new objects
function bind_events() {
  console.log('binding events');
  $('.reply').fadeIn();
  // hover events
  $('.answercard').mouseenter(function () {
    $(this).css('background-color','#616161');
    $(this).css('color', '#ffffff');
    $(this).find('.answer_title_section').css('color','#000000');
    $(this).find('.blue_twitter_link').css('visibility','visible');
  });
  $('.answercard').mouseleave(function () {
    $(this).css('background-color','rgba(255,255,255,0.8)');
    $(this).css('color','#494949');
    $(this).find('.answer_title_section').css('color','#6d6d6d');
    $(this).find('.tweet_card_header').css('color','rgba(0,0,0,0.1)');
    $(this).find('.blue_twitter_link').css('visibility','hidden');
  });
  // twitter card title hover & click
  $('.answer_title_section').mouseenter(function () {
    $(this).css('background-color','rgba(0,0,0,0.2)');
  });
  $('.answer_title_section').mouseleave(function () {
    $(this).css('background-color','rgba(0,0,0,0.1)');
  });
  $('.answer_title_section').on('click', function (){
    var user = $(this).parent().data('user');
    var url = "http://twitter.com/" + user;
    window.open(url , '_blank');
  });
  // tweet card paste to box
  var clicked = false;
  $('.answercard').on('click', function (){
    if ( clicked == false ) {
      clicked = true;
      var id = $(this).data('id');
      var user = $(this).data('user');
      var url = 'http://twitter.com/' + user + '/status/' + id;
      ajax(url);
    }
  });

  //add ajax functionality
  set_ajax();
}


