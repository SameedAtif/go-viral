import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
    initialize() {
        var slider = $('#rangeSlider');

        var gig_targeted_demographic_start_age = document.getElementById("gig_targeted_demographic_start_age");
        var gig_targeted_demographic_end_age = document.getElementById("gig_targeted_demographic_end_age")


        slider.noUiSlider(slider, {
            start: [20, 80],
            connect: true,
            step: 1,
            range: {
                'min': 0,
                'max': 100
            },
            tooltips: [true, true]
        });

        // Function to update the displayed values
        function updateValues() {
            var values = slider.noUiSlider.get();

            gig_targeted_demographic_start_age.value = values[0]
            gig_targeted_demographic_end_age.value = values[1]

        }

        // Listen for changes and update the values
        slider.noUiSlider.on('update', function () {
            updateValues();
        });

        // Initial update
        updateValues();
    }
}


