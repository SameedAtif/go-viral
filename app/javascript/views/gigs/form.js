$(document).ready(function () {
  $('#select_targeted_geographic_audience').select2();

  $('#package')
    .on('cocoon:after-insert', function (e, insertedItem, originalEvent) {
      actionOn = insertedItem[0].querySelectorAll('[id^="accordion-collapse-heading-"]')[0];
      resultOn = insertedItem[0].querySelectorAll('[id^="accordion-collapse-body-"]')[0];

      actionOn.addEventListener('click', function () {
        resultOn.classList.toggle('hidden');
      });

    })

  $('#faq')
    .on('cocoon:after-insert', function (e, insertedItem, originalEvent) {
      actionOn = insertedItem[0].querySelectorAll('[id^="accordion-collapse-heading-"]')[0];
      resultOn = insertedItem[0].querySelectorAll('[id^="accordion-collapse-body-"]')[0];

      actionOn.addEventListener('click', function () {
        resultOn.classList.toggle('hidden');
      });

    })
});
function validateForm() {
  let tabs = document.querySelectorAll('.tab-content');
  let isValid = true;

  for (let i = 0; i < tabs.length; i++) {
    let inputs = tabs[i].querySelectorAll('input[required][id]');

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
