import { createLobbyConsumer } from "channels/consumer"

export const lobbyChannel = createLobbyConsumer.subscriptions.create({ channel: "LobbyChannel", room: "global" }, {
  connected() {
    console.log("connected")
    this.send({msg: 'hello'})
    // Called when the subscription is ready for use on the server
  },

  disconnected() {
    console.log("disconnected")
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    console.log(data)
    // Called when there's incoming data on the websocket for this channel
  }
});
