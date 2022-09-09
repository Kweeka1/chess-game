const table = document.getElementById("rooms-table")
const sunIcon = document.getElementById("icon__sun")
const moonIcon = document.getElementById("icon__moon")
const userContainer = document.getElementById("users-container")
const onlineUsers = document.getElementById("users-online")
const globalChat = document.getElementById("global-chat")

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

function generateRandomColor() {
    var color = '#';
    for (var i = 0; i < 6; i++) {
        color += Math.floor(Math.random() * 8);
    }
    return color;
}

export function appendUsers(users) {
    userContainer.innerHTML = ""

    users.forEach(userString => {
        const user = userString.split(":")
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
    }
}

const userColor = generateRandomColor()

export function appendChatMessage(user, text) {
    const wrapper = document.createElement("div")

    const username = document.createElement("span")
    username.textContent = `${user}: `
    username.style.color = userColor

    const message = document.createElement("p")
    message.style.display = "inline"
    message.textContent = text

    wrapper.appendChild(username)
    wrapper.appendChild(message)

    globalChat.appendChild(wrapper)
}