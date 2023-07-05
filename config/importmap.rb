# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "stimulus.min.js", preload: true
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "@nathanvda/cocoon", to: "https://ga.jspm.io/npm:@nathanvda/cocoon@1.2.14/cocoon.js"
pin "flowbite", to: "https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.7.0/flowbite.turbo.min.js"
pin "flowbite-datepicker", to: "https://cdnjs.cloudflare.com/ajax/libs/flowbite/1.7.0/datepicker.turbo.min.js"
