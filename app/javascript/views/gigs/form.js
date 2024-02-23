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

function findParentByIdStartingWithAvoidCertainClass(element, idStart, avoidClass) {
  while (element && element.parentElement) {
    element = element.parentElement;
    
    if (element.classList.contains(avoidClass)) {
      return null;
    }
    
    if (element.id && element.id.startsWith(idStart)) {
      return element;
    }
  }
  return null;
}

function validateForm(event) {
  let tabs = document.querySelectorAll('.tab-content');
  let isValid = true;

  for (let i = 0; i < tabs.length; i++) {
    let inputs = tabs[i].querySelectorAll('input[required][id]');
    let parentElement = null;
    for (let j = 0; j < inputs.length; j++) {
      if (inputs[j].required && !inputs[j].value) {
        if(tabs[i].classList.contains('contains_nested_fields')){
          tabs[i].querySelectorAll('[id^="accordion-collapse-body-"]').forEach(element => {
            if(!element.classList.contains("hidden")){
              element.classList.add("hidden");
            }
          });

          parentElement = findParentByIdStartingWithAvoidCertainClass(inputs[j], "accordion-collapse-body-", "nested-fields")
          parentElement.classList.remove("hidden");
          event.preventDefault();
        }
        isValid = false;
        break;
      }
    }

    if (!isValid) {
      $(tabs).removeClass('active');
      $(tabs).prop('aria-selected', 'false');
      $(tabs).addClass('hidden');
      
      tabs[i].classList.remove('hidden');
      tabs[i].classList.add('active');
      tabs[i].setAttribute('aria-selected', 'true');

      break;
    }
  }
}
