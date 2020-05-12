/*
  From a given textarea, insert an input[type=text] before it and
  wire it up to a Google places autocomplete to search for address_components
  in country 'ie' only.

  Looks for a data-type attr which is passed directly to
  google.maps.places.Autocomplete types. Used to target only establishments
  when searching workplace address.
 */
class AddressAutocomplete {
  constructor(textarea) {
    this.textarea = textarea
  }

  get input() {
    if(this._input) {
      return this._input
    }

    const input = document.createElement('input');
    input.setAttribute('type', 'text');
    this.textarea.parentNode.insertBefore(input, this.textarea);

    input.addEventListener('keydown', function(event){
      if(event.keyCode === 13) {
        event.preventDefault()
        return false
      }
    })

    this._input = input
    return input
  }

  attachPlacesAutocomplete() {
    this.autocomplete = new google.maps.places.Autocomplete(
      this.input,
      {
        types: this.types,
        componentRestrictions: { country: 'ie' }
      }
    )
    this.autocomplete.setFields(['address_components'])
    google.maps.event.addListener(this.autocomplete, 'place_changed', this.placeChanged.bind(this));

    if(!this.textarea.value) { // Only hide when the value is blank so as not to hide real data
      this.textarea.style.display = 'none'
    }
  }

  get types() {
    if(this.textarea.dataset.type) {
      return this.textarea.dataset.type
    }

    return ['geocode'];
  }

  placeChanged() {
    this.textarea.value = this.input.value.replace(/, /g, ",\r\n")
    this.textarea.style.display = 'block'
    this.input.value = null
    this.textarea.focus()
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
