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
    submitted = true;
    url = $('.biginput').val();

    $.ajax({
      method: 'POST',
      dataType: 'json',
      data: {tweet: {url: url}},
      url: '/tweets',

      beforeSend: function () {
        NProgress.start();
        $('.submit_button').val('Contacting Twitter, please wait...').animate({backgroundColor: '#ff6626'});
          var fold = new OriDomi('.logged_in_section',{speed: 3000});
          fold.foldUp(function () {
            $('.logged_in_section').slideUp();
        });
      },

      complete: function () {
        console.log("AJAX complete");
        NProgress.done();
      }

    }).done(function(data){
      console.log("AJAX success");
      $('.submit_button').fadeOut(1000);
      $('.biginput').fadeOut(1000);
      render_view(data);
    }).fail(function () {
      console.log("AJAX failed");
      $('#results').append("AJAX failed, please try again.");
    });
  });
}

// for data object [0] = orig tweet, [1] = array of returned tweets, [2] = array of matched keywords
function render_view(data){
  var origTweet = "<h3>" + data[0]['user']['name'] + "</h3><p>" + data[0]['text'] + "</p>";
  $('.orig').append(origTweet);
  $('.orig').fadeIn();
  switch (data[1].length) {
  case 0:
    $('#results').append("No relevant tweets, please try another");
    break;
  case 1:
    make_tweet(data[1][0],'center', data[2]);
    break;
  case 2:
    make_tweet(data[1][1],'left', data[2]);
    make_tweet(data[1][0],'right', data[2]);
    break;
  default:
    $('#results').append("Data Error, please try again");
    break;
  }
  add_recursive_elements();
  bind_events();
}

//creates tweet card replay
function make_tweet(data, place, words) {
  var answerCard = "<div class='answercard empty " + place + "'><div class='answer_img_section'></div><div class='answer_title_section'></div><div class='answer_text_section'></div></div>";
  var title = "@" + data[0]['user']['screen_name'] + " <span class='highlight'>(" + data[1] + ")</span>";
  var text = data[0]['text'];
  var textArray = text.toLowerCase().split(" ");
  text = match_keywords(textArray, words);
  var img = "<img class='tweet_card_img' src='" + data[0]['user']['profile_image_url'] + "'>";
  $('#results').append(answerCard);
  var target = $('.answercard.empty');
  target.find('.answer_img_section').append(img);
  target.find('.answer_title_section').append(title);
  target.find('.answer_text_section').append(text);
  $('.empty').removeClass('empty');
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

// adds new search box and button for recursive searching while removing old elements
function add_recursive_elements() {
  $('.biginput').remove();
  $('.logged_in_section').remove();
  $('.submit_button').remove();
  var array = $('.answercard');
  var element = array[array.length - 1];
  var button = "<input class='submit_button' type='submit' value='Contextualize' style='display:none'>";
  var search = "<input class='biginput show_twitter_icon' type='text'>";
  $(element).after(button).after(search);
}

// bind mouseover and onclick events to new objects
function bind_events() {
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
  $('.answer').on('click', function (){
    var id = $(this).data('id');
    var user = $(this).data('user');
    $('.biginput').val('http://twitter.com/' + user + '/status/' + id);
    $('.biginput').keyup();
  });
}


