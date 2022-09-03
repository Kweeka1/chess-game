// Action Cable provides the framework to deal with WebSockets in Rails.
// You can generate new channels where WebSocket features live using the `bin/rails generate channel` command.

import { createConsumer } from "@rails/actioncable"

const id = window.location.pathname.split("/").at(-1)
console.log(id)
export default createConsumer(`ws://127.0.0.1:3000/cable?board=${id}`)
//export default createConsumer()
