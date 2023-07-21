import { Controller } from "@hotwired/stimulus";
import Inputmask from "inputmask";
// import Inputmask from 'inputmask';


// Connects to data-controller="phone-mask"
export default class extends Controller {
  connect() {
    console.log('phonemaskcontroller')
    // Get the input element
    const input = this.element;

    // Apply the input mask
    const inputMask = new Inputmask("(99)9999-99999");
    inputMask.mask(input);
    // Inputmask({ mask: '(99) 99999-9999' }).mask(this.element);
  }
}
