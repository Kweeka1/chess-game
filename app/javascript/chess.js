import {getPossibleMoves, clearPossibleMoves} from "./chess_helpers/getPossibleMoves";
import {validateMoveSv} from "./channels/rooms_channel";

const board = document.querySelector("#board_container")
const territories = document.querySelectorAll(".cube")

let map = []
territories.forEach((key, _) => map.push(key.getAttribute("team")))

let turn = "Blue"

const blueQueenSpace = []
const redQueenSpace = []

let source = null
let sourcePieceType = ""

function selectOtherPiece(currentPiece) {
    source.classList.remove("selected")
    source = currentPiece
    source.classList.add("selected")
    sourcePieceType = currentPiece.getAttribute("piece")
}

export function movePieceToNewPos(start, end, isValidMove) {
    if (!isValidMove) {
        source.classList.remove("selected")
        source = null
        return;
    }

    source = territories[(parseInt(start[0]) * 8) + parseInt(start[1])]
    let destination = territories[(parseInt(end[0]) * 8) + parseInt(end[1])]

    source.classList.remove("selected")

    destination.innerHTML = source.innerHTML
    destination.setAttribute("team", source.getAttribute("team"))
    destination.setAttribute("piece", source.getAttribute("piece"))

    source.innerHTML = ""
    source.setAttribute("team", "")
    source.setAttribute("piece", "")
    source = null
}

function selectSource(targetPiece) {
    source = targetPiece
    sourcePieceType = targetPiece.getAttribute("piece")
    targetPiece.classList.add("selected")
}

board.addEventListener("mousedown", function (ev) {
    let targetPiece = ev.target

    // Reselect parent DIV element (Cube) if IMG tag (Piece image) is selected
    if (targetPiece.nodeName === "IMG"|| targetPiece.nodeName === "SPAN") {
        targetPiece = targetPiece.parentElement
    }

    let targetPieceTeam = targetPiece.getAttribute("team")
    let targetPieceType = targetPiece.getAttribute("piece")

    let sourcePieceTeam = source?.getAttribute("team")

    // Select a new Piece of the player's team (Red or Blue) if no piece is selected (if source is null)
    if (source === null && targetPieceTeam === turn) {
        selectSource(targetPiece)
        getPossibleMoves(targetPieceType, source, territories, turn)
        return;
    }

    // Move selected piece to an empty territory or enemy territory. Condition fails if selected piece is an ally
    if (source !== targetPiece && source !== null && targetPieceTeam !== turn) {
        clearPossibleMoves(territories, turn)
        validateMoveSv(sourcePieceType, source, targetPiece, targetPieceTeam, turn, map)
        return;
    }

    // Select a new ally piece if previously selected piece is an ally (not the same as source)
    if (targetPiece !== source && sourcePieceTeam === targetPieceTeam) {
        selectOtherPiece(targetPiece)
        clearPossibleMoves(territories, turn)
        getPossibleMoves(targetPieceType, source, territories, turn)
    }
})
