import {createCircle} from "./mapElements";

let possibleMoves = []

function getKnightMoves(startingPosition, territories, turn) {
    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])

    const up = [
        (startingRowPos - 2), (startingColPos - 1),
        (startingRowPos - 2), (startingColPos + 1)
    ]
    const right = [
        (startingRowPos - 1), (startingColPos + 2),
        (startingRowPos + 1), (startingColPos + 2)
    ]
    const down = [
        (startingRowPos + 2), (startingColPos - 1),
        (startingRowPos + 2), (startingColPos + 1)
    ]
    const left = [
        (startingRowPos - 1), (startingColPos - 2),
        (startingRowPos + 1), (startingColPos - 2)
    ]

    const allMoves = [up, right, down, left].flat().map(num => num < 0 || num > 7 ? undefined : num)

    for (let i = 0; i < allMoves.length; i += 2) {
        const territory = territories[(allMoves[i] * 8) + allMoves[i + 1]]
        if (territory !== undefined && territory?.getAttribute("team") === "") {
            territory.appendChild(createCircle())
            possibleMoves.push((allMoves[i] * 8) + allMoves[i + 1])
        } else if (territory !== undefined && territory?.getAttribute("team") !== turn) {
            territory?.classList?.add("enemy")
            possibleMoves.push((allMoves[i] * 8) + allMoves[i + 1])
        }
    }
}

function getBishopMoves(startingPosition, territories, turn) {
    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])

    function isPossibleMove(row, i) {
        const territory = territories[(row * 8) + i]
        if (territory !== undefined && territory?.getAttribute("team") !== turn) {
            if (territory.getAttribute("team") !== "Red") {
                territory.appendChild(createCircle())
                possibleMoves.push((row * 8) + i)
                return true
            } else {
                territory.classList.add("enemy")
                possibleMoves.push((row * 8) + i)
                return false
            }
        }

        return false
    }

    function getUpMoves() {
        let row = startingRowPos
        for (let i = startingColPos - 1; i >= 0; i--) {
            row--
            if (!isPossibleMove(row, i)) break;
        }
        row = startingRowPos
        for (let i = startingColPos + 1; i <= 7; i++) {
            row--
            if (!isPossibleMove(row, i)) break;
        }
    }

    function getDownMoves() {
        let row = startingRowPos
        for (let i = startingColPos - 1; i >= 0; i--) {
            row++
            if (!isPossibleMove(row, i)) break;
        }
        row = startingRowPos
        for (let i = startingColPos + 1; i <= 7; i++) {
            row++
            if (!isPossibleMove(row, i)) break;
        }
    }

    getDownMoves()
    getUpMoves()
}

function getRockMoves(startingPosition, territories, turn) {
    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])

    function isPossibleMove(row, col) {
        const territory = territories[(row * 8) + col]
        if (territory !== undefined && territory?.getAttribute("team") !== turn) {
            if (territory.getAttribute("team") !== "Red") {
                territory.appendChild(createCircle())
                possibleMoves.push((row * 8) + col)
                return true
            } else {
                territory.classList.add("enemy")
                possibleMoves.push((row * 8) + col)
                return false
            }
        }

        return false
    }

    function getHorizontalMoves() {
        for (let col = startingColPos - 1; col >= 0; col--) {
            if (!isPossibleMove(startingRowPos, col)) break;
        }
        for (let col = startingColPos + 1; col <= 7; col++) {
            if (!isPossibleMove(startingRowPos, col)) break;
        }
    }

    function getVerticalMoves() {
        for (let row = startingRowPos - 1; row >= 0; row--) {
            if (!isPossibleMove(row, startingColPos)) break;
        }
        for (let row = startingRowPos + 1; row <= 7; row++) {
            if (!isPossibleMove(row, startingColPos)) break;
        }
    }

    getHorizontalMoves()
    getVerticalMoves()
}

function getPawnMoves(startingPosition, territories, turn) {
    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])

    let allMoves = [
        [
            startingRowPos - 1, startingColPos, // up
            startingRowPos - 1, startingColPos + 1, // up right
            startingRowPos - 1, startingColPos - 1 // up left
        ],
        [
            startingRowPos + 1, startingColPos, // down
            startingRowPos + 1, startingColPos + 1, // down right
            startingRowPos + 1, startingColPos - 1 // down left
        ]
    ]

    turn === "Blue" ? allMoves = allMoves[1].map(num => num < 0 || num > 7 ? undefined : num)
                    : allMoves = allMoves[0].map(num => num < 0 || num > 7 ? undefined : num)

    function getDiagonalMoves(row, col) {
        const territory = territories[(row * 8) + col]
        if (!territory) return

        if (territories[(row * 8) + col].getAttribute("team") === "Red") {
            territory.classList.add("enemy")
            possibleMoves.push((row * 8) + col)
        }
    }

    function getVerticalMove(row, col) {
        if (startingRowPos === 1 || startingRowPos === 6) {
            const extraMove = turn === "Blue" ? row + 1 : row - 1;
            const moves = [((row * 8) + col), ((extraMove * 8) + col)]

            for (let i = 0; i <= moves.length; i++) {
                const territory = territories[moves[i]]
                if (!territory || territory.getAttribute("team") !== "") break;
                territory.appendChild(createCircle())
                possibleMoves.push(moves[i])
            }

            return;
        }

        const territory = territories[(row * 8) + col]
        if (!territory) return

        if (territory.getAttribute("team") === "") {
            territory.appendChild(createCircle())
            possibleMoves.push((row * 8) + col)
        }
    }

    getDiagonalMoves(allMoves[2], allMoves[2 + 1])
    getDiagonalMoves(allMoves[4], allMoves[4 + 1])
    getVerticalMove(allMoves[0], allMoves[1])
}

function getQueenMoves(startingPosition, territories, turn) {
    const startingRowPos = parseInt(startingPosition[0])
    const startingColPos = parseInt(startingPosition[1])

    const allMoves = [
        startingRowPos - 1, startingColPos, // up
        startingRowPos + 1, startingColPos, // down
        startingRowPos, startingColPos - 1, // left
        startingRowPos, startingColPos + 1, // right
        startingRowPos - 1, startingColPos + 1, // up right
        startingRowPos - 1, startingColPos - 1, // up left
        startingRowPos + 1, startingColPos + 1, // down right
        startingRowPos + 1, startingColPos - 1, // down left
    ].map(num => num < 0 || num > 7 ? undefined : num)

    for (let i = 0; i < allMoves.length; i += 2) {
        const territory = territories[(allMoves[i] * 8) + allMoves[i + 1]]
        if (territory !== undefined && territory?.getAttribute("team") !== turn) {
            if (territory.getAttribute("team") !== "Red") {
                territory.appendChild(createCircle())
                possibleMoves.push((allMoves[i] * 8) + allMoves[i + 1])
            } else {
                territory.classList.add("enemy")
                possibleMoves.push((allMoves[i] * 8) + allMoves[i + 1])
            }
        }
    }
}

function getKingMoves(startingPosition, territories, turn) {
    getRockMoves(startingPosition, territories, turn)
    getBishopMoves(startingPosition, territories, turn)
}

export function clearPossibleMoves(territories) {
    while (possibleMoves.length !== 0) {
        let item = possibleMoves.shift()
        if (territories[item]?.firstElementChild?.nodeName === "SPAN") {
            territories[item].innerHTML = ""
        } else {
            territories[item].classList.remove("enemy")
        }
    }
}

export function getPossibleMoves(currentPiece, lastPieceSelected, territories, turn) {
    const startingPosition = lastPieceSelected.getAttribute("coordination").split(":")

    switch (currentPiece) {
        case "Knight":
            return getKnightMoves(startingPosition, territories, turn)
        case "Bishop":
            return getBishopMoves(startingPosition, territories, turn)
        case "Rock":
            return getRockMoves(startingPosition, territories, turn)
        case "King":
            return getKingMoves(startingPosition, territories, turn)
        case "Queen":
            return getQueenMoves(startingPosition, territories, turn)
        case "Pawn":
            return getPawnMoves(startingPosition, territories, turn)
        default:
            return []
    }
}