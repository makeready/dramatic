$('.biginput').remove();
$('.submit_button').remove();
$('#results').after("<%= j render partial: 'reply1' %>").remove();