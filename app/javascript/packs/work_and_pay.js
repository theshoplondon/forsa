import $ from 'jquery'

function currentValue() {
  return $('input[name="membership_application[pay_unit]"]:checked').val();
}

function setHoursPerWeekVisibility() {
  $('.hours-per-week').toggleClass('hide', currentValue() !== 'hour')
}

$(document).on('turbolinks:load', function() {
  $('input[name="membership_application[pay_unit]"]').change(function () {
    setHoursPerWeekVisibility()
  })

  setHoursPerWeekVisibility()
})
