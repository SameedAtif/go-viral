// JavaScript logic to handle the counter
document.addEventListener('DOMContentLoaded', function () {
    const counterElement = document.getElementById('counter');
    let gigPrice = document.getElementById('gig-price').textContent;
    const totalGigsPrice = document.getElementById('total-gigs-price');

    let counterValue = 1;

    const updateTotalPrice = () => {
        let totalPrice = gigPrice * counterValue
        totalGigsPrice.textContent = totalPrice;
    }

    const project_overview_drawer_buttons = document.querySelectorAll(".package-overview-selector")
    project_overview_drawer_buttons.forEach(project_overview_drawer_button => {
        project_overview_drawer_button.addEventListener('click', function handleClick(event) {
            const selected_package = $('#myTab [role="tab"][aria-selected="true"]').attr("id");

            const price = document.getElementById(`${selected_package}-price`).textContent;
            const title = document.getElementById(`${selected_package}-title`).textContent;
            const tab_title = document.getElementById(`${selected_package}`).textContent;
            const package_id = document.getElementById(`${selected_package}-system-id`).textContent;
            gigPrice = document.getElementById('gig-price').textContent = price;
            document.getElementById("selected-gig-title").textContent = title
            document.getElementById("selected-gig-tab-title").textContent = tab_title
            document.getElementById('buy-package').action = `/gig_packages/${package_id}/system_gig_transactions`;
            counterElement.textContent = counterValue = 1
            updateTotalPrice();
        });
    });
});
