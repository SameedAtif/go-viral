// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@nathanvda/cocoon"
import 'flowbite';
import 'flowbite-datepicker';
import "jquery";
import "select2";
import "trix"
import "@rails/actiontext"
import "./channels/index"

$(document).ready(function () {
    var divs = document.querySelectorAll('.dropdownNavbarLink');

    function handleDivClick(event) {
        // Access the "data-dropdownToggle" attribute of the clicked div
        var dropdownToggleValue = event.currentTarget.getAttribute('data-dropdownToggle');

        // Toggle the view of dropdown
        if ($(`#${dropdownToggleValue}`).hasClass('hidden'))
            $(`#${dropdownToggleValue}`).removeClass('hidden')
        else
            $(`#${dropdownToggleValue}`).addClass('hidden')
    }

    // Add a click event listener to each div
    divs.forEach(function (div) {
        div.addEventListener('click', handleDivClick);
    });
    // For the Filters sidebar end

    // script to show dropdowns and hide when clicked outside the scope start
    const dropdownButtons = document.querySelectorAll('.dropdown-button');
    const dropdownMenus = document.querySelectorAll('.dropdown-menu');

    dropdownButtons.forEach((button, index) => {
        button.addEventListener('click', () => {
            const isExpanded = button.getAttribute('aria-expanded') === 'true';
            button.setAttribute('aria-expanded', !isExpanded);
            dropdownMenus[index].style.display = isExpanded ? 'none' : 'block';
        });

        // Close the menu when clicking outside of it
        document.addEventListener('click', (event) => {
            if (dropdownMenus[index].contains(event.target) || button.contains(event.target)) {
                return;
            }
            button.setAttribute('aria-expanded', 'false');
            dropdownMenus[index].style.display = 'none';
        });
    });
    // script to show dropdowns and hide when clicked outside the scope end

});
