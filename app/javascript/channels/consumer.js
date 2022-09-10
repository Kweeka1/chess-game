// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from "@rails/actioncable"

const id = window.location.pathname.split("/").at(-1)

export const createChessConsumer = createConsumer(`ws://192.168.1.15:3000/cable?room=${id}`)
export const createLobbyConsumer = createConsumer(`ws://192.168.1.15:3000/cable?room=global`)
//export default createConsumer()
