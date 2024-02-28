$(document).ready(function() {
  $('.all-gigs > input[type=checkbox]').on('change', (e) => {
    const isChecked = e.target.checked;
    const status = e.target.dataset['status'];

    $(`.gig-table > .checkbox-column > .checkbox-div[data-status=${status}] > input[type=checkbox]`).prop("checked", isChecked);
    $(".gig-table").trigger("change");
  });
  $(`.gig-table > .checkbox-column > .checkbox-div > input[type=checkbox]`).on('change', (e) => {
    const status = e.target.dataset['status'];
    // if all of them are unselected, unselect .all-gigs
    const checkboxes = $(`.gig-table > .checkbox-column > .checkbox-div[data-status=${status}] > input[type=checkbox]`);
    const checkedChecboxes = $(`.gig-table > .checkbox-column > .checkbox-div[data-status=${status}] > input[type=checkbox]:checked`)
    const uncheckedChecboxes = $(`.gig-table > .checkbox-column > .checkbox-div[data-status=${status}] > input[type=checkbox]:not(:checked)`)

    if (checkboxes.length === checkedChecboxes.length) {
      $('.all-gigs > input[type=checkbox]').prop("checked", true);
    }
    if (checkboxes.length === uncheckedChecboxes.length) {
      $('.all-gigs > input[type=checkbox]').prop("checked", false);
    }
    if (checkedChecboxes.length >= 1) {
      $(`.delete-button[data-status=${status}] > input[type=submit]`).removeAttr('disabled');
    } else {
      $(`.delete-button[data-status=${status}] > input[type=submit]`).attr('disabled','disabled');
    }
    $(".gig-table").trigger("change");
  })
});
