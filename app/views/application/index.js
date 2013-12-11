$('.tweet_container').fadeOut('fast', function () {
  $(this).html('<%=j render partial: "tweets" %>').fadeIn('fast');
});

