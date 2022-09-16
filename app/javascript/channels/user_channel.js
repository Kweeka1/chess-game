import { createUserConsumer, username } from "channels/consumer"
import {appendRoom, appendUser} from "../lobby";



const types = {
  currentUsers: "ONLINE_USERS",
  currentRooms: "ACTIVE_ROOMS",
  joinRequest: "JOIN_REQUEST",
  viewRequest: "VIEW_REQUEST"
}

export function requestToJoin(guest, host, room) {
  return  userChannel.send({
    type: types.joinRequest,
    data: {
      guest: guest,
      host: host,
      room: room
    }
  })
}

export function requestToView(guest, host, room) {
  return  userChannel.send({
    type: types.viewRequest,
    data: {
      guest: guest,
      host: host,
      room: room
    }
  })
}

export const userChannel = createUserConsumer.subscriptions.create({channel: "UserChannel", user: username}, {
  connected() {
    console.log("user connected")
  },

  disconnected() {

  },

  received(response) {
    console.log(response)
    switch (response.type) {
      case types.currentRooms:
        return  response.data.forEach(room => appendRoom(room))
      case types.currentUsers:
        return  response.data.forEach(user => appendUser(user))
      case types.joinRequest:
        return Snackbar.show({pos: 'bottom-right',
          duration: 5000, text: `${response.data.guest} requested to join room ${response.data.room}`})
      case types.viewRequest:
        return Snackbar.show({pos: 'bottom-right',
          duration: 5000, text: `${response.data.guest} requested to view room ${response.data.room}`})
    }
  }
});
