//
//  ChatView.swift
//  GeminiChatTemplate
//
//  Created by Jesus Daniel Medina Cruz on 30/06/24.
//

import SwiftUI

struct ChatView: View {
  private let chatAPIImpl: ChatAPIImpl = ChatAPIImpl()
  @State
  private var currentMessageBody: String = ""
  @State
  private var messages: [Message] = []
  
  var body: some View {
    NavigationSplitView {
      VStack {
        Spacer()
        ForEach(messages) { message in
          if message.author == "user" {
            UserBox(message)
          } else {
            ModelBox(message)
          }
        }
        HStack {
          TextField(text: $currentMessageBody) {
            Text("Message")
          }
          Button(action: {
            withAnimation {
              let userMessage = Message(id: messages.count + 1, author: "user", body: currentMessageBody)
              messages.append(userMessage)
              currentMessageBody = ""
            }
            Task {
              let responseMessage = try await chatAPIImpl.sendMessage(messages: messages)
              withAnimation {
                messages.append(responseMessage)
              }
            }
          }, label: {
            Text("Send")
          })
        }
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
      }
    } detail: {
      Text("Gemini Chat")
    }
  }
  
  private func UserBox(_ message: Message) -> some View {
    return HStack {
      Spacer()
      Text(message.body)
        .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
        .background(.blue)
        .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
        .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
    }
      
  }
  
  private func ModelBox(_ message: Message) -> some View {
    return HStack {
        Text(message.body)
          .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
          .background(.gray)
          .clipShape(RoundedRectangle(cornerSize: CGSize(width: 20, height: 10)))
          .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 20))
        Spacer()
      }
    }
}
