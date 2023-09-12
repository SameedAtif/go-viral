// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"
import "@nathanvda/cocoon"

document.addEventListener('turbo:load', () => {
    // Code to be executed when the DOM is ready
    console.log("CHal ja bhai!!!")
});

$(document).ready(function(){

    var divs = document.querySelectorAll('.dropdownNavbarLink');

    function handleDivClick(event) {
        // Access the "data-dropdownToggle" attribute of the clicked div
        var dropdownToggleValue = event.currentTarget.getAttribute('data-dropdownToggle');

        // Toggle the view of dropdown
        if($(`#${dropdownToggleValue}`).hasClass('hidden'))
            $(`#${dropdownToggleValue}`).removeClass('hidden')
        else
            $(`#${dropdownToggleValue}`).addClass('hidden')
    }
    
    // Add a click event listener to each div
    divs.forEach(function(div) {
        div.addEventListener('click', handleDivClick);
    });

})