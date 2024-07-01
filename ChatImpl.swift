//
//  ChatImpl.swift
//  GeminiChatTemplate
//
//  Created by Jesus Daniel Medina Cruz on 30/06/24.
//

import Foundation
import GoogleGenerativeAI

struct Message: Identifiable {
  var id: Int
  
  var author: String
  var body: String
}

struct ChatReward : Decodable  {
  let id: Int
  let title: String
  let description: String
  let image: String
  let points: Int
}

struct ChatChallenge : Decodable {
  let id: Int
  let title: String
  let description: String
  let image: String
  let rewards: [ChatReward]
}

struct ChatBody : Decodable {
  let message: String
  let challenge: ChatChallenge?
}

class ChatAPIImpl {
  var json: JSONDecoder = JSONDecoder()
  
  // Access your API key from your on-demand resource .plist file (see "Set up your API key" above)
  let generativeModel = GenerativeModel(
    name: "gemini-1.5-flash",
    apiKey: APIKey.default,
    systemInstruction: ModelContent(role: "model", parts: [.text("")])
  )
  
  func sendMessage(messages: [Message]) async throws -> Message {
    let history: [ModelContent] = messages
      .map({ message in
        ModelContent(role: message.author, parts: [.text(message.body)])
      })
      .dropLast(1)
    let chat = generativeModel.startChat(
      history: history
    )
    let response = try await chat.sendMessage(
      messages.last?.body ?? "Empty message"
    )
    
    return Message(id: messages.count + 1, author: "model", body: response.text ?? "No response")
  }
}

