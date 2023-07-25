import { Controller } from "@hotwired/stimulus";
import Inputmask from "inputmask";
// import Inputmask from 'inputmask';


// Connects to data-controller="phone-mask"
export default class extends Controller {
  connect() {
    // Get the input element
    const input = this.element;

    // Apply the input mask with custom options
    const inputMask = new Inputmask({
      mask: "(99) 99999-9999",
      removeMaskOnSubmit: true,
      showMaskOnHover: false,
    });
    inputMask.mask(input);

    // Attach an event listener to handle user input
    input.addEventListener("input", () => {
      this.handleInputError(input);
    });
    // Handle errors
    // const errorContainer = document.querySelector("#cellphone-number-errors");
    // if (errorContainer) {
    //   const hasError = input.classList.contains("fields-with-errors");
    //   const isInvalid = input.value.replace(/\D/g, "").length < 11; // Remove non-digits and check if length is less than 11
    //   errorContainer.innerHTML = hasError ? input.dataset.error : isInvalid ? "Telefone inválido" : "";
    // }
  }
}
