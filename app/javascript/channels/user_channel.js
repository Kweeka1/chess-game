import { createUserConsumer, username } from "channels/consumer"
import {appendRoom, appendUser} from "../lobby";



const types = {
  currentUsers: "ONLINE_USERS",
  currentRooms: "ACTIVE_ROOMS",
  joinRequest: "JOIN_REQUEST",
  viewRequest: "VIEW_REQUEST"
}

export function requestToJoin(guest, host) {
  userChannel.send({
    type: types.joinRequest,
    data: {
      guest: guest,
      host: host
    }
  })
}

export function requestToView() {
  console.log("view")
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
        return
      case types.viewRequest:
        return
    }
  }
});
