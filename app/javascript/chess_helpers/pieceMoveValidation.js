const RedTeam = "Red"
const BlueTeam = "Blue"

function validateKnightMove(startingPosition, endPosition) {

    let rowMove = Math.abs(parseInt(startingPosition[0]) - parseInt(endPosition[0]))
    let colMove = Math.abs(parseInt(startingPosition[1]) - parseInt(endPosition[1]))

    return rowMove + colMove === 3
}

function validateBishopMove(startingPosition, endPosition, territories) {

    const rowMove = Math.abs(parseInt(startingPosition[0]) - parseInt(endPosition[0]))
    const colMove = Math.abs(parseInt(startingPosition[1]) - parseInt(endPosition[1]))

    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])

    const endingRowPos = parseInt(endPosition[0])
    const endingColPos = parseInt(endPosition[1])

    const isBlocked = function () {
        let col = startingColPos

        if (startingRowPos > endingRowPos) {
            for (let i = startingRowPos - 1; i > endingRowPos; i--) {
                if (endingColPos > startingColPos) {
                    col++
                    if (territories[(i * 8) + col].getAttribute("team") !== "") return true
                } else {
                    col--
                    if (territories[(i * 8) + col].getAttribute("team") !== "") return true
                }
            }
        } else {
            for (let i = startingRowPos + 1; i < endingRowPos; i++) {
                if (endingColPos > startingColPos) {
                    col++
                    if (territories[(i * 8) + col].getAttribute("team") !== "") return true
                } else {
                    col--
                    if (territories[(i * 8) + col].getAttribute("team") !== "") return true
                }
            }
        }

        return false
    }

    return rowMove === colMove && !isBlocked()
}

function validateRockMove(startingPosition, endPosition, territories) {

    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])

    const endingRowPos = parseInt(endPosition[0])
    const endingColPos = parseInt(endPosition[1])

    const rowMove = startingRowPos !== endingRowPos && startingColPos === endingColPos
    const colMove = startingRowPos === endingRowPos && startingColPos !== endingColPos

    function isBlocked() {
        if (endingRowPos > startingRowPos) {
            for (let i = startingRowPos + 1; i < endingRowPos; i++) {
                if (territories[(i * 8) + startingColPos].getAttribute("team") !== "") return true
            }

            return false
        }
        else if (startingRowPos > endingRowPos) {
            for (let i = startingRowPos - 1; i > endingRowPos; i--) {
                if (territories[(i * 8) + startingColPos].getAttribute("team") !== "") return true
            }

            return false
        }
        else if (endingColPos > startingColPos) {
            for (let i = startingColPos + 1; i < endingColPos; i++) {
                if (territories[(startingRowPos * 8) + i].getAttribute("team") !== "") return true

            }

            return false
        } else {
            for (let i = startingColPos - 1; i > endingColPos; i--) {
                if (territories[(startingRowPos * 8) + i].getAttribute("team") !== "") return true
            }

            return false
        }
    }

    return !isBlocked() && (rowMove || colMove)
}

function validateKingMove(startingPosition, endPosition, territories) {
    if (startingPosition[0] === endPosition[0] || startingPosition[1] === endPosition[1])
        return validateRockMove(startingPosition, endPosition, territories)

    else return validateBishopMove(startingPosition, endPosition, territories)
}

function validateQueenMove(startingPosition, endPosition) {
    const rowMove = Math.abs(parseInt(startingPosition[0]) - parseInt(endPosition[0]))
    const colMove = Math.abs(parseInt(startingPosition[1]) - parseInt(endPosition[1]))

    return (rowMove === 0 || rowMove === 1) && (colMove === 0 || colMove === 1)
}

function validatePawnMove(startingPosition, endPosition, isSelectedTerritoryTeam, turn) {

    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])
    const endingRowPos = parseInt(endPosition[0])
    const endingColPos = parseInt(endPosition[1])

    const rowMove = Math.abs(startingRowPos - endingRowPos)
    const colMove = Math.abs(startingColPos - endingColPos)

    if (turn === "Blue") {

        if (endingRowPos < startingRowPos) return false
        if (colMove === 1 && rowMove === 1) return isSelectedTerritoryTeam === RedTeam
        if (startingRowPos === 1) {
            return colMove === 0 && isSelectedTerritoryTeam !== RedTeam && rowMove === 1 || rowMove === 2
        }
        return colMove === 0 && isSelectedTerritoryTeam !== RedTeam && rowMove === 1

    } else {

        if (endingRowPos > startingRowPos) return false
        if (colMove === 1 && rowMove === 1) return isSelectedTerritoryTeam === BlueTeam
        if (startingRowPos === 6 && colMove === 0) {
            return isSelectedTerritoryTeam !== BlueTeam && rowMove === 1 || rowMove === 2
        }
        return colMove === 0 && isSelectedTerritoryTeam !== BlueTeam && rowMove === 1

    }
}

export default function validateMove(lastPiece, lastPieceSelected, currentPieceSelected, isSelectedTerritoryTeam, territories, turn) {
    const startingPosition = lastPieceSelected.getAttribute("coordination").split(":")
    const endPosition = currentPieceSelected.getAttribute("coordination").split(":")

    switch (lastPiece) {
        case "Knight":
            return validateKnightMove(startingPosition, endPosition)
        case "Bishop":
            return validateBishopMove(startingPosition, endPosition, territories)
        case "Rock":
            return validateRockMove(startingPosition, endPosition, territories)
        case "King":
            return validateKingMove(startingPosition, endPosition, territories)
        case "Pawn":
            return validatePawnMove(startingPosition, endPosition, isSelectedTerritoryTeam, turn)
        case "Queen":
            return validateQueenMove(startingPosition, endPosition)
    }
}