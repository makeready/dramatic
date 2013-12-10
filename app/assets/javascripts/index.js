$(document).ready(function () {

  // init flowtype
  $('h1').flowtype();

  // bounce input button
  setTimeout(function () {
    $('.sign_in_button').effect({
      effect: "bounce",
    },500);
  },6000);


  // fold.oriDomi('reveal', 80);
  // setTimeout(function(){
  //   fold.oriDomi('foldUp');
  // },3000);

  // var fold = $('h1').oriDomi({
  //   speed: 1000,
  //   shadingIntensity: 0
  // });


});