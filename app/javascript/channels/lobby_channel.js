import { createLobbyConsumer } from "channels/consumer"
import { userChannel } from "./user_channel";
import {appendUser, removeUser, appendChatMessage, appendRoom} from "../lobby";
import {username} from "./consumer";

const globalChatInput = document.getElementById("global-chat-input")
const globalChatSend = document.getElementById("global-chat-send")

globalChatSend.addEventListener("mousedown", () => sendMessage())
globalChatInput.addEventListener("keypress", function (event) {
  if (event.key === "Enter") {
    sendMessage()
    globalChatInput.value = ""
  }
})

const color = localStorage.getItem("userColor")

const types = {
  chat: "GLOBAL_CHAT_MESSAGE",
  user_sub: "USER_SUBSCRIBED",
  user_unsub: "USER_UNSUBSCRIBED",
  create_room: "ROOM_CREATED",
  delete_room: "ROOM_DELETED",
}

function sendMessage() {
  const text = globalChatInput.value

  if (text.length !== 0) {
    lobbyChannel.send({
      message_type: types.chat,
      data: {
        user: username,
        message: text.trim(),
        color: color
      }
    })
  }

  globalChatInput.value = ""
}

export const lobbyChannel = createLobbyConsumer.subscriptions.create({ channel: "LobbyChannel", room: "global" }, {
  connected() {
    console.log("lobby connected")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    this.perform('unsubscribed')
    //this.send({type: types.user_unsub, user: username})
    // Called when the subscription has been terminated by the server
  },

  received(response) {
    console.log(response)
    switch (response.type) {
      case types.user_sub:
        return appendUser(response.user)
      case types.user_unsub:
        return removeUser(response.user)
      case types.chat:
        return appendChatMessage(response.data.user, response.data.message, response.data.color)
      case types.create_room:
        return appendRoom(response.data)
    }
  }
});
