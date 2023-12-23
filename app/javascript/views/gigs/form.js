$(document).ready(function () {
  $('#select_targeted_geographic_audience').select2();
});
function validateForm() {
  let tabs = document.querySelectorAll('.tab-content');
  let isValid = true;

  for (let i = 0; i < tabs.length; i++) {
    let inputs = tabs[i].querySelectorAll('input[required]');

    for (let j = 0; j < inputs.length; j++) {
      if (!inputs[j].value) {
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      // Show the tab with the first invalid field
      $(tabs).removeClass('active');
      $(tabs).addClass('hidden');
      tabs[i].classList.add('active');
      tabs[i].classList.remove('hidden');

      break;
    }
  }

  if (isValid) {
    // Continue with form submission
    document.getElementById('myForm').submit();
  }
}
