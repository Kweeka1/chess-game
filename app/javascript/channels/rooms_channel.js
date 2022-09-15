import { createChessConsumer } from "channels/consumer"
import {movePieceToNewPos} from "../chess";

const chat = document.getElementById("chat-display")

const types = {
  textMessage: "TEXT_MESSAGE",
  moveValidation: "MOVE_VALIDATION",
}

function displayMessage(message) {
  const messageEl = `<p>${message}</p>`
  chat.insertAdjacentHTML("beforeend", messageEl)
}

function moveValidationResult(data) {
  if (data.isValid) {
    return movePieceToNewPos(data.start, data.end, true)
  }
  movePieceToNewPos(data.start, data.end, false)
}

export function validateMoveSv(sourcePieceType, sourceEl, destinationEl) {
  const start = sourceEl.getAttribute("coordination")
  const end = destinationEl.getAttribute("coordination")

  roomChannel.send({
    type: types.moveValidation,
    data: {
      source_piece: sourcePieceType,
      source_str: start,
      destination_str: end
    }
  })
}

const id = window.location.pathname.split("/").at(-1)

export const roomChannel = createChessConsumer.subscriptions.create({channel: "RoomsChannel", room: id}, {
  connected() {
    // Called when the subscription is ready for use on the server
    console.log("Connected")
  },

  disconnected() {
    // Called when the subscription has been terminated by the server
  },

  received(data) {
    // Called when there's incoming data on the websocket for this channel
    console.log(data)
    switch (data["message_type"]) {
      case types.textMessage:
        return displayMessage(data["data"])
      case types.moveValidation:
        return moveValidationResult(data["move"])
    }
  }
});
