$(document).ready(function () {

    // Stick Filters bar to the top start
    var navbar = document.getElementById("filters_nav_bar");
    var sticky = navbar?.offsetTop;

    function stickNavBarToTop() {
        if (window.pageYOffset >= sticky) {
            navbar.classList.add('fixed', 'w-full', 'top-0', 'z-10')
        } else {
            navbar.classList.remove('fixed', 'w-full', 'top-0', 'z-10');
        }
    }

    $(window).scroll(function () {
        stickNavBarToTop();
    });
    // Stick Filters bar to the top start
});
