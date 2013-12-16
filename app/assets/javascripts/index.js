$(document).ready(function () {

  // init flowtype
  $('h1').flowtype();

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
  $('.biginput').keyup(function() {
   if($(this).val() !== '') {
    $('.submit_button').fadeIn();
  } else {
    $('.submit_button').fadeOut();
  }
  });

  // AJAX
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
            $('.submit_button').fadeOut(1000);
        });
      },

      complete: function () {
        console.log("AJAX complete");
        NProgress.done();
      }

    }).done(function(data){
      console.log("AJAX success");
      render_view(data);
    }).fail(function () {
      console.log("AJAX failed");
      $('#results').append("AJAX failed, please try again.");
    });
  });

  function render_view(data){
    var origTweet = "<h3>" + data[0]['user']['name'] + "</h3><p>" + data[0]['text'] + "</p>";
    $('.orig').append(origTweet);
    $('.orig').fadeIn();
    switch (data.length) {
    case 1:
      $('#results').append("No relevant tweets, please try another");
      break;
    case 2:
      make_tweet(data[1]);
      break;
    case 3:
      make_tweet(data[1]);
      make_tweet(data[2]);
      break;
    default:
      $('#results').append("Data Error, please try again");
      break;
    }
  }

  function make_tweet(data) {
    var answerCard = "<div class='answercard empty'><div class='answer_img_section'></div><div class='answer_title_section'></div><div class='answer_text_section'></div></div>";
    var title = data[0]['user']['screen_name'];
    var text = data[0]['text'];
    var img = "<img class='tweet_card_img' src='" + data[0]['user']['profile_image_url'] + "'>";
    $('#results').append(answerCard);
    var target = $('.answercard.empty');
    target.find('.answer_img_section').append(img);
    target.find('.answer_title_section').append(title);
    target.find('.answer_text_section').append(text);
    $('.empty').removeClass('empty');
  }


});





