import { createLobbyConsumer } from "channels/consumer"
import {appendUsers, removeUser, appendChatMessage} from "../lobby";

const globalChatInput = document.getElementById("global-chat-input")
const globalChatSend = document.getElementById("global-chat-send")
const username = document.getElementById("username").value

globalChatSend.addEventListener("mousedown", () => sendMessage())
globalChatInput.addEventListener("keypress", function (event) {
  if (event.key === "Enter") {
    sendMessage()
    globalChatInput.value = ""
  }
})

const messageTypes = {
  chat: "GLOBAL_CHAT_MESSAGE",
  user_sub: "USER_SUBSCRIBED",
  user_unsub: "USER_UNSUBSCRIBED",
  create_room: "ROOM_CREATE",
  delete_room: "ROOM_DELETE",
}

function sendMessage() {
  const text = globalChatInput.value

  if (text.length !== 0) {
    lobbyChannel.send({
      message_type: messageTypes.chat,
      data: {
        user: username,
        message: text.trim()
      }
    })
  }

  globalChatInput.value = ""
}

export const lobbyChannel = createLobbyConsumer.subscriptions.create({ channel: "LobbyChannel", room: "global" }, {
  connected() {
    console.log("connected")
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    this.perform('unsubscribed')
    //this.send({type: messageTypes.user_unsub, user: username})
    // Called when the subscription has been terminated by the server
  },

  received(response) {
    console.log(response)
    switch (response.type) {
      case messageTypes.user_sub:
        return appendUsers(response.users)
      case messageTypes.user_unsub:
        return removeUser(response.user)
      case messageTypes.chat:
        return appendChatMessage(response.data.user, response.data.message)
      default:
        console.log(response)
    }
    // Called when there's incoming data on the websocket for this channel
  }
});
