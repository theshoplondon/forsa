import $ from 'jquery'
import Rails from '@rails/ujs'

const KEY_EURO = 8364
const KEY_POUND = 163
const KEY_COMMA = 44

const PREVENT_KEYS = [KEY_COMMA, KEY_EURO, KEY_POUND]

function payUnitValue() {
  return $('input[name="membership_application[pay_unit]"]:checked').val()
}

const payValue = (name) => $(`input[name="membership_application[${name}]"]`).val()

function setHoursPerWeekVisibility() {
  $('.hours-per-week').toggleClass('hide', payUnitValue() !== 'hour')
}

function clericalRateValue() {
  return $('input[name="membership_application[technical_grade]"]').val() === 'clerical'
}

function getMonthlyEstimate() {
  fetch(
    `/subscription-rate?pay_unit=${payUnitValue()}&pay_rate=${payValue('pay_rate')}&hours_per_week=${payValue('hours_per_week')}&clerical_rate=${clericalRateValue()}`,
    {
      method: 'get',
      headers: {
        'Accept': 'application/json',
        'X-CSRF-Token': Rails.csrfToken()
    },
    credentials: 'same-origin'
  }).then(function(response) {
    if(response.ok) {
      response.json().then(data => monthlyEstimateArrived(data))
    } else {
      response.json().then(data => monthlyEstimateErrored(data.error))
    }
  })
}

let timer = null

function showSpinner(value) {
  $('.spinner-overlay').toggleClass('hide', !value)
}

function monthlyEstimateErrored(error) {
  $('.monthly-estimate').addClass('hide')
  showSpinner(false)
  console.log(`Error getting monthly estimate: ${error}`)
}

function monthlyEstimateArrived(data) {
  $('#monthly-estimate-value').text(data.monthly_estimate)
  $('#subscription-rate').text(data.percentage)
  $('#membership_application_applicant_saw_monthly_estimate').val(data.monthly_estimate)
  $('.monthly-estimate').removeClass('hide')
  showSpinner(false)
}

function weHaveEnoughFields() {
  return (payValue('pay_rate') && (payUnitValue() === 'hour') && payValue('hours_per_week')) ||
    ((payValue('pay_rate')) && payUnitValue());
}

function estimateInputChanged(interval = 1500) {
  if(weHaveEnoughFields()) {
    clearTimeout(timer)
    showSpinner(true)
    timer = setTimeout(getMonthlyEstimate, interval)
  }
}

$(document).on('turbolinks:load', function() {
  $('input[name="membership_application[pay_unit]"]').change(function () {
    setHoursPerWeekVisibility()
    estimateInputChanged(1) // Instant when we change unit
  })

  $('input[name="membership_application[pay_rate]"]').on('change keypress', function(event) {
    if (PREVENT_KEYS.includes(event.keyCode)) {
      event.preventDefault()
      return
    }
    estimateInputChanged()
  })
  $('input[name="membership_application[hours_per_week]"]').on('change keypress', () => estimateInputChanged())

  setHoursPerWeekVisibility()
})
