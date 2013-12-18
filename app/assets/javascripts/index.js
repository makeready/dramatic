$(document).ready(function () {

  // init flowtype
  $('h1').flowtype();

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
   if($(this).val() !== '') {
    if (submitted === false) {
      $('.submit_button').fadeIn();
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

    $.ajax({
      method: 'POST',
      dataType: 'script',
      data: {tweet: {url: url}},
      url: '/tweets',

      beforeSend: function () {
        NProgress.start();
        $('.submit_button').val('Contacting Twitter, please wait...').animate({backgroundColor: '#ff6626', color: '#ffffff'});
        if ( $('.logged_in_section').length > 0 ) {
          var fold = new OriDomi('.logged_in_section',{speed: 3000});
          fold.foldUp(function () {
            $('.logged_in_section').slideUp();
          });
        }
      },

      complete: function () {
        NProgress.done();
      }

    });
  });
}


// adds highlight span to matching words
function match_keywords(textArray, words) {
  var returnArray = [];
  for ( i=0 ; i < textArray.length ; i++ ) {
    var single = textArray[i].replace(/[^a-zA-Z0-9]/g,'');
    var answer = $.inArray(single,words);
    if ( answer === -1 ) {
      returnArray.push(textArray[i]);
    } else {
      returnArray.push("<span class='highlight'>" + textArray[i] + "</span>");
    }
  }
  return returnArray.join(" ");
}


// bind mouseover and onclick events to new objects
function bind_events() {
  console.log('binding events');
  $('.biginput').val('');
  $('.reply').fadeIn();
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

  // tweet card paste to box
  $('.answercard').on('click', function (){
    var id = $(this).data('id');
    var user = $(this).data('user');
    $('.biginput').val('http://twitter.com/' + user + '/status/' + id);
    $('.biginput').keyup();
  });

  // fade in new submit button
  var submitted = false;
  $('.biginput').keyup(function() {
   if($(this).val() !== '') {
    if (submitted === false) {
      $('.submit_button').fadeIn();
        }
  } else {
    $('.submit_button').fadeOut();
  }
  });

  //add ajax functionality
  set_ajax();
}


