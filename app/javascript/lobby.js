const table = document.getElementById("rooms-table")
const sunIcon = document.getElementById("icon__sun")
const moonIcon = document.getElementById("icon__moon")
const userContainer = document.getElementById("users-container")
const onlineUsers = document.getElementById("users-online")
const globalChat = document.getElementById("global-chat")
const closeIcon = document.getElementById("create-room-close-icon")
const openButton = document.getElementById("create-room-button")
const createRoomContainer = document.getElementById("create-room-container")
const createRoomWrapper = document.getElementById("create-room-wrapper")
const roomsList = document.getElementById("rooms-list")
const playersDatalist = document.querySelector(".players__datalist")
const roomOpponentInput = document.querySelector(".room_opponent")

let currentPlayers = []
function randomHsl() {
    return  'rgb(' +
    (Math.floor(Math.random()*56)+120) + ', ' +
    (Math.floor(Math.random()*56)+120) + ', ' +
    (Math.floor(Math.random()*56)+120) +
    ')';
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
    console.log("moon")
    document.documentElement.classList.add("light-mode")
    document.documentElement.classList.remove("dark-mode")
})

function generateRandomColor() {
    let theme = localStorage.getItem("theme")
    let color = '#';

    if (theme === "light") {
        for (let i = 0; i < 6; i++) {
            color += Math.floor(Math.random() * 8);
        }
        return color;
    }
    const letters = '0123456789ABCDEF';
    for (let i = 0; i < 6; i++) {
        color += letters[Math.floor(Math.random() * 16)];
    }
    console.log(color)
    return color;
}

export function appendUsers(users) {
    userContainer.innerHTML = ""

    users.forEach(userString => {
        const user = userString.split(":")
        currentPlayers.push([user[0], user[1]])
        const userEl = document.createElement("p")
        userEl.className = user[1]
        userEl.textContent = user[1]
        userContainer.appendChild(userEl)
    })

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
    const wrapper = document.createElement("div")

    const username = document.createElement("span")
    username.textContent = `${user}: `
    username.style.color = color
    username.style.fontWeight = "600"

    const message = document.createElement("p")
    message.style.display = "inline"
    message.textContent = text

    if (theme === "light") {
        message.style.color = "black"
    } else {
        message.style.color = "white"
    }

    wrapper.appendChild(username)
    wrapper.appendChild(message)

    globalChat.appendChild(wrapper)
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
    const row = document.createElement("tr")

    const title = document.createElement("td")
    title.textContent = data.title
    const host = document.createElement("td")
    host.textContent = data.host
    const players = document.createElement("td")
    players.textContent = data.players_count
    players.colSpan = 2
    const viewers = document.createElement("td")
    viewers.textContent = data.viewers_count
    viewers.colSpan = 3
    const description = document.createElement("td")
    description.textContent = data.description
    const buttonGroup = document.createElement("div")
    buttonGroup.className = "grp-buttons"

    const playButton = document.createElement("button")
    playButton.type = "button"
    playButton.className = "btn btn-primary"
    playButton.textContent = "Play"

    const viewButton = document.createElement("button")
    viewButton.type = "button"
    viewButton.className = "btn btn-primary"
    viewButton.textContent = "View"

    buttonGroup.append(playButton, viewButton)
    row.append(title, host, players, viewers, description, buttonGroup)
    roomsList.appendChild(row)
}

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