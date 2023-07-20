import { Controller } from "@hotwired/stimulus";
import Inputmask from 'inputmask';


// Connects to data-controller="phone-mask"
export default class extends Controller {
  connect() {
    console.log('phonemaskcontroller')
    Inputmask({ mask: '(99) 99999-9999' }).mask(this.element);
  }
}
