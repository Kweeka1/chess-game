import { roomChannel } from "./channels/rooms_channel";

const input = document.getElementById("chat_input")
const sendButton = document.getElementById("btn_send")

const types = {
    msg: "TEXT_MESSAGE",
    command: "TEXT_COMMAND"
}

function checkType(text = "") {
    return text.at(0) === "!" ? types.command : types.msg
}

function sendMessage() {
    const text = input.value
    const type = checkType(text)

    if (text.length !== 0) {
        roomChannel.send({
            message_type: type,
            text: text.trim()
        })
    }

    input.value = ""
}

sendButton.addEventListener("mousedown", () => sendMessage())

input.addEventListener("keypress", function (event) {
    if (event.key === "Enter") {
        sendMessage()
        input.value = ""
    }
})