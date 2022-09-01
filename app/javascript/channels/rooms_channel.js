import consumer from "channels/consumer"
import {movePieceToNewPos} from "../chess";
const chat = document.getElementById("chat-display")

const serverTypes = {
  rxMsg: "TEXT_MESSAGE_RECEIVED",
  moveValidation: "MOVE_VALIDATION_RECEIVED",
}

function displayMessage(message) {
  const messageEl = document.createElement("p")
  messageEl.textContent = message
  chat.appendChild(messageEl)
}

let pieceMoveState = {}

function moveValidationResult(pieceMoveState, data) {
  const start = pieceMoveState.start === data.move.start.join(":")
  const end = pieceMoveState.end === data.move.end.join(":")

  if (data.move.isValid && start && end) {
    movePieceToNewPos(pieceMoveState.currentPieceEl, pieceMoveState.team, pieceMoveState.lastPieceEl, pieceMoveState.isValid)
  }

  movePieceToNewPos(pieceMoveState.currentPieceEl, pieceMoveState.team, pieceMoveState.lastPieceEl, false)
}

export function validateMoveSv(lastPiece, lastPieceSelected, currentPieceSelected, currentPieceTeam, turn) {
  const start = lastPieceSelected.getAttribute("coordination")
  const end = currentPieceSelected.getAttribute("coordination")

  roomChannel.send({
    message_type: "MOVE_VALIDATION",
    details: {
      last_piece: lastPiece,
      starting_position: start,
      ending_position: end,
      occupier: currentPieceTeam,
      turn: turn
    }
  })

  pieceMoveState["piece"] = lastPiece
  pieceMoveState["lastPieceEl"] = lastPieceSelected
  pieceMoveState["currentPieceEl"] = currentPieceSelected
  pieceMoveState["team"] = turn
  pieceMoveState["start"] = start
  pieceMoveState["end"] = end
}


export const roomChannel = consumer.subscriptions.create("RoomsChannel", {
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
      case serverTypes.rxMsg:
        displayMessage(data["data"])
        break;
      case serverTypes.moveValidation:
        moveValidationResult(pieceMoveState, data)
        break;
    }
  }
});
