var numberOfMonths;
if (window.matchMedia && window.matchMedia('(max-device-width: 650px)').matches) {
  // smartphone
  numberOfMonths = 1;
} else {
  // pc
  numberOfMonths = 2;
}
$(function(){
  $(".datepicker").datepicker({
    numberOfMonths: numberOfMonths,
  });
});