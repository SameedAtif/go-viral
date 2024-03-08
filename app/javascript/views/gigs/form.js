$(document).ready(function () {
  function updateStates() {
    const data = $('#select_targeted_geographic_audience').select2('data');
    const countryCodes = data.map((s) => s.id)
    $.ajax({
      url: '/addresses/fetch_states',
      method: 'GET',
      data: { country_codes: countryCodes },
      dataType: 'json',
      success: function(data) {
        if ($('#select_targeted_geographic_audience_city').data('select2')) {
          $('#select_targeted_geographic_audience_city').select2('val', '');
          $('#select_targeted_geographic_audience_city').select2('destroy');
          $("#select_targeted_geographic_audience_city").empty();
        }
        $("#select_targeted_geographic_audience_city").select2({
          data: data
        }).trigger("change");
      }
    });
  }

  $('#select_targeted_geographic_audience').select2();
  $('#select_targeted_geographic_audience_city').select2();
  $('#select_targeted_geographic_audience').on('select2:select', () => {
    updateStates();
  })
  $('#select_targeted_geographic_audience').on('select2:unselect', () => {
    updateStates();
  });
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
