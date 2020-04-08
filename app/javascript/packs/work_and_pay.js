import $ from 'jquery'
import Rails from '@rails/ujs'

function payUnitValue() {
  return $('input[name="membership_application[pay_unit]"]:checked').val()
}

const payValue = (name) => $(`input[name="membership_application[${name}]"]`).val()

function setHoursPerWeekVisibility() {
  $('.hours-per-week').toggleClass('hide', payUnitValue() !== 'hour')
}

function getMonthlyEstimate() {
  fetch(`/subscription-rate?pay_unit=${payUnitValue()}&pay_rate=${payValue('pay_rate')}&hours_per_week=${payValue('hours_per_week')}`, {
    method: 'get',
    headers: {
      'Accept': 'application/json',
      'X-CSRF-Token': Rails.csrfToken()
    },
    credentials: 'same-origin'
  }).then(function(response) {
    console.log(response);

    if (response.ok) {
      return response.json()
    }
  }).then(function(data){
    monthlyEstimateArrived(data['monthly_estimate'])
  }).catch((err) => console.log(err))
}

let timer = null

function showSpinner(value) {
  $('.spinner-overlay').toggleClass('hide', !value)
}

function monthlyEstimateArrived(value) {
  $('#monthly-estimate-value').text(value)
  $('.monthly-estimate').removeClass('hide')
  showSpinner(false)
}

function estimateInputChanged(interval = 1500) {
  clearTimeout(timer)
  showSpinner(true)
  timer = setTimeout(getMonthlyEstimate, interval)
}

$(document).on('turbolinks:load', function() {
  $('input[name="membership_application[pay_unit]"]').change(function () {
    setHoursPerWeekVisibility()
    estimateInputChanged(1) // Instant when we change unit
  })

  $('input[name="membership_application[pay_rate]"]').on('change keyup', () => estimateInputChanged())
  $('input[name="membership_application[hours_per_week]"]').on('change keyup', () => estimateInputChanged())

  setHoursPerWeekVisibility()
})
