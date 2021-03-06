// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

require("@rails/ujs").start()
require("jquery")
require("turbolinks").start()
require("packs/polyfills/NodeList.forEach")

import {Foundation} from 'foundation-sites/js/foundation.core'
import {Dropdown} from 'foundation-sites/js/foundation.dropdown'
import {AddressAutocomplete} from "packs/address_autocomplete"
// IE11 support - gets use 'fetch' which uses Promise
import 'promise-polyfill/src/polyfill'
import 'whatwg-fetch'

Foundation.addToJquery($)
Foundation.plugin(Dropdown, 'Dropdown')
$(document).foundation()

// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

$(document).on('turbolinks:load', function() {
  $(document).foundation()
  AddressAutocomplete.setup('.address-autocomplete')
})

require('packs/your_subscription_rate')
