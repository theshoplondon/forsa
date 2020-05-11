class AddressAutocomplete {
  constructor(textarea) {
    this.textarea = textarea
  }

  attachPlacesAutocomplete() {
    this.autocomplete = new google.maps.places.Autocomplete(
      this.textarea,
      {
        types: ['geocode'], // don't use anything else on a textarea, will break with invalid HTMLInput
        componentRestrictions: { country: 'ie' }
      }
    )
    google.maps.event.addListener(this.autocomplete, 'place_changed', this.placeChanged.bind(this));
  }

  reformatAddress() {
    this.textarea.value = this.textarea.value.replace(/, /g, ",\r\n")
  }

  placeChanged() {
    this.reformatAddress()
  }

  static create(textarea) {
    let autocomplete = new AddressAutocomplete(textarea)
    autocomplete.attachPlacesAutocomplete()
  }

  static setup() {
    google.maps.event.addDomListener(window, 'load', function () {
      document.querySelectorAll('.address-autocomplete')
        .forEach(element => AddressAutocomplete.create(element))
    });
  }
}

export { AddressAutocomplete }
