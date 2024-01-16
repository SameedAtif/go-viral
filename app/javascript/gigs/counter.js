// JavaScript logic to handle the counter
document.addEventListener('DOMContentLoaded', function () {
    const counterElement = document.getElementById('counter');
    const decrementButton = document.getElementById('decrement');
    const incrementButton = document.getElementById('increment');
    let gigPrice = document.getElementById('gig-price').textContent;
    const totalGigsPrice = document.getElementById('total-gigs-price');

    let counterValue = 1;

    // Function to update the counter value and display
    const updateCounter = () => {
        counterElement.textContent = counterValue;
    };

    const updateTotalPrice = () => {
        let totalPrice = gigPrice * counterValue
        totalGigsPrice.textContent = totalPrice;
    }

    // Event listener for the decrement button
    decrementButton.addEventListener('click', () => {
        if (counterValue > 1) {
            counterValue -= 1;
            updateCounter();
            updateTotalPrice();
        }
    });

    // Event listener for the increment button
    incrementButton.addEventListener('click', () => {
        if (counterValue < 10) {
            counterValue += 1;
            updateCounter();
            updateTotalPrice();
        }
    });

    const project_overview_drawer_buttons = document.querySelectorAll(".package-overview-selector")
    project_overview_drawer_buttons.forEach(project_overview_drawer_button => {
        project_overview_drawer_button.addEventListener('click', function handleClick(event) {
            const selected_package = $('#myTab [role="tab"][aria-selected="true"]').attr("id");

            const price = document.getElementById(`${selected_package}-price`).textContent;
            const title = document.getElementById(`${selected_package}-title`).textContent;
            const tab_title = document.getElementById(`${selected_package}`).textContent;

            gigPrice = document.getElementById('gig-price').textContent = price;
            document.getElementById("selected-gig-title").textContent = title
            document.getElementById("selected-gig-tab-title").textContent = tab_title

            counterElement.textContent = counterValue = 1
            updateTotalPrice();
        });
    });
});