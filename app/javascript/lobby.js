import {requestToJoin, requestToView} from "./channels/user_channel";
import {username} from "./channels/consumer";

const table = document.getElementById("rooms-table")
const sunIcon = document.getElementById("icon__sun")
const moonIcon = document.getElementById("icon__moon")
const userContainer = document.getElementById("users-container")
const onlineUsers = document.getElementById("users-online")
const activeGames = document.getElementById("games-count")
const globalChat = document.getElementById("global-chat")
const closeIcon = document.getElementById("create-room-close-icon")
const openButton = document.getElementById("create-room-button")
const createRoomContainer = document.getElementById("create-room-container")
const createRoomWrapper = document.getElementById("create-room-wrapper")
const roomsList = document.getElementById("rooms-list")
const roomForm = document.getElementById("room-form")
const roomTitle = document.getElementById("room-title")
const playersDatalist = document.querySelector(".players__datalist")
const roomOpponentInput = document.querySelector(".room_opponent")


let currentPlayers = []
function randomHsl() {
    const hue = Math.floor(Math.random() * 360);
    const saturation = Math.floor(Math.random() * (100 + 1)) + "%";
    const lightness = Math.floor(Math.random() * (50 + 1)) + "%";
    return "hsl(" + hue + ", " + saturation + ", " + lightness + ")";
}
const userColor = randomHsl()
localStorage.setItem("userColor", userColor)

if (window.matchMedia && window.matchMedia('(prefers-color-scheme: dark)').matches) {
    localStorage.setItem("theme", "dark")
    table.classList.remove("table-light")
    table.classList.add("table-dark")
    sunIcon.style.display = "none"
    moonIcon.style.display = "block"
} else {
    localStorage.setItem("theme", "light")
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
        localStorage.setItem("theme", "dark")
    } else {
        table.classList.remove("table-dark")
        table.classList.add("table-light")
        moonIcon.style.display = "none"
        sunIcon.style.display = "block"
        localStorage.setItem("theme", "light")
    }
});

sunIcon.addEventListener('mousedown', function () {
    console.log(document.documentElement)
    document.documentElement.classList.add("dark-mode")
    document.documentElement.classList.remove("light-mode")
})

moonIcon.addEventListener('mousedown', function () {
    document.documentElement.classList.add("light-mode")
    document.documentElement.classList.remove("dark-mode")
})

export function appendUser(userStr) {
    const user = userStr.split(":")
    currentPlayers.push([user[0], user[1]])
    const userEl = document.createElement("p")
    userEl.className = user[1]
    userEl.textContent = user[1]
    userContainer.appendChild(userEl)

    onlineUsers.textContent = userContainer.children.length.toString()
}

export function removeUser(user) {
    user = userContainer.querySelector(`.${user}`)
    if (user) {
        user.remove()
        onlineUsers.textContent = userContainer.children.length.toString()
        const index = currentPlayers.indexOf(user)
        currentPlayers.slice(index, index + 1)
    }
}

export function appendChatMessage(user, text, color) {
    let theme = localStorage.getItem("theme")
    let textColor = ""

    if (theme === "light") textColor = "black"
    else textColor = "white"

    const html = `
        <div>
            <span style="color: ${color}; font-weight: 600;">${user}:</span>
            <p style="display: inline; color: ${textColor}">${text}</p>
        </div>
    `

    globalChat.insertAdjacentHTML("beforeend", html)
}

openButton.addEventListener("mousedown", function () {
    createRoomWrapper.style.display = "block"
    createRoomContainer.style.display = "block"
    currentPlayers.forEach(player => {
        const option = document.createElement("option")
        option.textContent = player[1]
        option.id = player[0]
        playersDatalist.appendChild(option)
    })
})

export function appendRoom(data) {
    const row = `
        <tr class="room_row">
            <td style="width: 10rem;">${data.room_name}</td>
            <td style="width: 10rem;">${data.room_host}</td>
            <td>${data.room_description}</td>
            <td>
                <iframe style="width: 10px;height: 10px;border-radius: 1.625rem;background-color: red;border: 1px solid #464545"></iframe>
            </td>
            <td class="room-btn-container">
                <div class="grp-buttons">
                    <button id="${data.room_id}_play" type="button" class="btn btn-primary">Play</button>
                    <button id="${data.room_id}_view" type="button" class="btn btn-secondary">View</button>
                </div>
            </td>
        </tr>
    `

    roomsList.insertAdjacentHTML("beforeend", row)
    activeGames.textContent = roomsList.children.length.toString()
}

roomsList.addEventListener("mousedown", function (ev) {
    const element = ev.target
    if (element.nodeName !== "BUTTON") return;

    const host = element.parentElement.parentElement.parentElement.children.item(1).textContent
    const roomName = element.parentElement.parentElement.parentElement.children.item(0).textContent

    if (element.id.includes("play")) return requestToJoin(username, host, roomName)
    if (element.id.includes("view")) return requestToView(username, host, roomName)
})

closeIcon.addEventListener("mousedown", function () {
    createRoomWrapper.style.display = "none"
    createRoomContainer.style.display = "none"
})

createRoomWrapper.addEventListener("mousedown", function () {
    createRoomWrapper.style.display = "none"
    createRoomContainer.style.display = "none"
})

roomOpponentInput.addEventListener("mousedown", function () {
    this.value = ""
})

roomForm.addEventListener("submit", function (event) {
    if (roomTitle.value.length === 0) {
        roomTitle.value = roomTitle.placeholder
    }
    if (roomOpponentInput.value === "Free to join") {
        roomOpponentInput.value = ""
    }
})

activeGames.textContent = "0"