import {getPossibleMoves, clearPossibleMoves} from "./chess_helpers/getPossibleMoves";
import {validateMoveSv} from "./channels/rooms_channel";

const board = document.querySelector("#board_container")
const territories = document.querySelectorAll(".cube")

let turn = "Blue"

const blueQueenSpace = []
const redQueenSpace = []

let lastPieceSelected = null
let lastPiece = ""

function selectOtherPiece(currentPiece) {
    lastPieceSelected.classList.remove("selected")
    lastPieceSelected = currentPiece
    lastPieceSelected.classList.add("selected")
    lastPiece = currentPiece.getAttribute("piece")
}

export function movePieceToNewPos(currentPiece, lastPieceTeam, lastPiece, isValidMove) {
    if (isValidMove) {
        lastPieceSelected.classList.remove("selected")

        currentPiece.innerHTML = lastPieceSelected.innerHTML
        currentPiece.setAttribute("team", lastPieceTeam)
        currentPiece.setAttribute("piece", lastPiece)

        lastPieceSelected.innerHTML = ""
        lastPieceSelected.setAttribute("team", "")
        lastPieceSelected.setAttribute("piece", "")
        lastPieceSelected = null
    }
    else {
        lastPieceSelected.classList.remove("selected")
        lastPieceSelected = null
    }
}

function selectPiece(currentPiece) {
    lastPieceSelected = currentPiece
    lastPiece = currentPiece.getAttribute("piece")
    currentPiece.classList.add("selected")
}

board.addEventListener("mousedown", function (ev) {
    //console.log(ev)
    let currentPieceSelected = ev.target

    // Reselect parent DIV element (Cube) if IMG tag (Piece image) is selected
    if (currentPieceSelected.nodeName === "IMG"|| currentPieceSelected.nodeName === "SPAN") {
        currentPieceSelected = currentPieceSelected.parentElement
    }

    let currentPieceTeam = currentPieceSelected.getAttribute("team")
    let lastPieceTeam = lastPieceSelected?.getAttribute("team")

    let currentPiece = currentPieceSelected.getAttribute("piece")

    // Select a new Piece of the player's team (Red or Blue) if no piece is selected (if lastPieceSelected is null)
    if (lastPieceSelected === null && currentPieceTeam === turn) {
        selectPiece(currentPieceSelected)
        getPossibleMoves(currentPiece, lastPieceSelected, territories, turn)
    }

    // Move selected piece to an empty territory or enemy territory. Condition fails if selected piece is an ally
    if (lastPieceSelected !== currentPieceSelected && lastPieceSelected !== null && currentPieceTeam !== turn) {
        clearPossibleMoves(territories, turn)
        validateMoveSv(lastPiece, lastPieceSelected, currentPieceSelected, currentPieceTeam, turn)
    }

    // Select a new ally piece if previously selected piece is an ally (not the same as lastPieceSelected)
    if (currentPieceSelected !== lastPieceSelected && lastPieceTeam === currentPieceTeam) {
        selectOtherPiece(currentPieceSelected)
        clearPossibleMoves(territories, turn)
        getPossibleMoves(currentPiece, lastPieceSelected, territories, turn)
    }
})
