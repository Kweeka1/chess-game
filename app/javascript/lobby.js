import { lobbyChannel } from "./channels/lobby_channel";

console.log("lobby script")

const table = document.getElementById("rooms-table")
const sunIcon = document.getElementById("icon__sun")
const moonIcon = document.getElementById("icon__moon")

if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    table.classList.remove("table-light")
    table.classList.add("table-dark")
    sunIcon.style.display = "none"
    moonIcon.style.display = "block"
} else {
    table.classList.remove("table-dark")
    table.classList.add("table-light")
    moonIcon.style.display = "none"
    sunIcon.style.display = "block"
}

window.matchMedia('(prefers-color-scheme: dark)').addEventListener('change', event => {
    const newColorScheme = event.matches ? "dark" : "light";

    if (newColorScheme === "dark") {
        table.classList.remove("table-light")
        table.classList.add("table-dark")
        sunIcon.style.display = "none"
        moonIcon.style.display = "block"
    } else {
        table.classList.remove("table-dark")
        table.classList.add("table-light")
        moonIcon.style.display = "none"
        sunIcon.style.display = "block"
    }
});

sunIcon.addEventListener('mousedown', function () {
    console.log(document.documentElement)
    document.documentElement.classList.add("dark-mode")
    document.documentElement.classList.remove("light-mode")
})

moonIcon.addEventListener('mousedown', function () {
    console.log("moon")
    document.documentElement.classList.add("light-mode")
    document.documentElement.classList.remove("dark-mode")
})