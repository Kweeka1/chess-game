console.log("lobby script")

const table = document.getElementById("rooms-table")

if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    table.classList.remove("table-light")
    table.classList.add("table-dark")
} else {
    table.classList.remove("table-dark")
    table.classList.add("table-light")
}

window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
    const newColorScheme = event.matches ? "dark" : "light";

    if (newColorScheme === "dark") {
        table.classList.remove("table-light")
        table.classList.add("table-dark")
    } else {
        table.classList.remove("table-dark")
        table.classList.add("table-light")
    }
});