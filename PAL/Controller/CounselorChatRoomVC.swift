//
//  CounselorChatRoomVC.swift
//  PAL
//
//  Created by admin on 7/19/18.
//  Copyright © 2018 NJCU. All rights reserved.
//
/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import MessageKit
import MapKit

internal class CounselorChatRoomVC: MessagesViewController {
    
    let refreshControl = UIRefreshControl()
    let sender = Sender(id: "any_unique_id", displayName: "You")
    var messages: [MessageType] = []
    var tempString: String = ""
    
    
    var timer = Timer()
    
    var oppSender = Sender(id: "different", displayName: "Robert Maloy")
    
    var isTyping = false
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("ConversationViewController is called")
        
        navigationItem.title = "Chat Room \(chat_id!)"
        
        let leftBarButton = UIBarButtonItem(title: "< Back", style: UIBarButtonItemStyle.plain, target: self, action: #selector(toStudentList))
        self.navigationItem.leftBarButtonItem = leftBarButton
        
        //Start with X amount of messages already created
        
        //        DispatchQueue.global(qos: .userInitiated).async {
        //            SampleData.shared.getMessages(count: messagesToFetch) { messages in
        //                DispatchQueue.main.async {
        //                    self.messageList = messages
        //                    self.messagesCollectionView.reloadData()
        //                    self.messagesCollectionView.scrollToBottom()
        //                }
        //            }
        //        }
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        scrollsToBottomOnKeybordBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        messagesCollectionView.addSubview(refreshControl)
        
        
        scheduledTimeWithTimeInterval()
        
    }
    
    @objc func toStudentList() {
        //Stop Timer Updating
        timer.invalidate()
//        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//        let vc : UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "CounselorActivities")
//        self.present(vc, animated: true, completion: nil)
        self.navigationController?.pushViewController(CounselorActivitiesVC(), animated: true)
    }
    
    func scheduledTimeWithTimeInterval() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(getData), userInfo: nil, repeats: true)
    }
    
    @objc func handleTyping() {
        
        defer {
            isTyping = !isTyping
        }
        
        if isTyping {
            
            messageInputBar.topStackView.arrangedSubviews.first?.removeFromSuperview()
            messageInputBar.topStackViewPadding = .zero
            
        } else {
            
            let label = UILabel()
            label.text = "nathan.tannar is typing..."
            label.font = UIFont.boldSystemFont(ofSize: 16)
            messageInputBar.topStackView.addArrangedSubview(label)
            messageInputBar.topStackViewPadding.top = 6
            messageInputBar.topStackViewPadding.left = 12
            
            // The backgroundView doesn't include the topStackView. This is so things in the topStackView can have transparent backgrounds if you need it that way or another color all together
            messageInputBar.backgroundColor = messageInputBar.backgroundView.backgroundColor
            
        }
        
    }
    
    // MARK: - Keyboard Style
    
    func slack() {
        //defaultStyle()
        messageInputBar.backgroundView.backgroundColor = .blue
        messageInputBar.isTranslucent = false
        messageInputBar.inputTextView.backgroundColor = .red
        messageInputBar.inputTextView.layer.borderWidth = 0
        let items = [
            //            makeButton(named: "ic_camera").onTextViewDidChange { button, textView in
            //                button.isEnabled = textView.text.isEmpty
            //            },
            //            makeButton(named: "ic_at").onSelected {
            //                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            //            },
            //            makeButton(named: "ic_hashtag").onSelected {
            //                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            //            },
            //            .flexibleSpace,
            //            makeButton(named: "ic_library").onTextViewDidChange { button, textView in
            //                button.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            //                button.isEnabled = textView.text.isEmpty
            //            },
            messageInputBar.sendButton
                .configure {
                    $0.layer.cornerRadius = 8
                    $0.layer.borderWidth = 1.5
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.setTitleColor(.white, for: .normal)
                    $0.setTitleColor(.white, for: .highlighted)
                    $0.setSize(CGSize(width: 52, height: 30), animated: true)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.backgroundColor = .white
                }.onEnabled {
                    $0.backgroundColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
                    $0.layer.borderColor = UIColor.clear.cgColor
                }.onSelected {
                    // We use a transform becuase changing the size would cause the other views to relayout
                    $0.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
                }.onDeselected {
                    $0.transform = CGAffineTransform.identity
            }
        ]
        items.forEach { $0.tintColor = .lightGray }
        
        // We can change the container insets if we want
        messageInputBar.inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        messageInputBar.inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 5, bottom: 8, right: 5)
        
        // Since we moved the send button to the bottom stack lets set the right stack width to 0
        messageInputBar.setRightStackViewWidthConstant(to: 0, animated: true)
        
        // Finally set the items
        messageInputBar.setStackViewItems(items, forStack: .bottom, animated: true)
    }
    
    // MARK: - Helpers
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: true)
            }.onSelected {
                $0.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { _ in
                print("Item Tapped")
        }
    }
}

// MARK: - MessagesDataSource

extension CounselorChatRoomVC: MessagesDataSource {
    
    func currentSender() -> Sender {
        return sender
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if indexPath.section % 3 == 0 {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedStringKey.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        let name = message.sender.displayName
        return NSAttributedString(string: name, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption1)])
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
        let dateString = formatter.string(from: message.sentDate)
        return NSAttributedString(string: dateString, attributes: [NSAttributedStringKey.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessagesDisplayDelegate

extension CounselorChatRoomVC: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .red : .darkText
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedStringKey: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1) : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
        //        let configurationClosure = { (view: MessageContainerView) in}
        //        return .custom(configurationClosure)
    }
    
    //    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
    //        let avatar = SampleData.shared.getAvatarFor(sender: message.sender)
    //        avatarView.set(avatar: avatar)
    //    }
    
    // MARK: - Location Messages
    
}

// MARK: - MessagesLayoutDelegate

extension CounselorChatRoomVC: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if indexPath.section % 3 == 0 {
            return 10
        }
        return 0
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
    
}

// MARK: - MessageCellDelegate

extension CounselorChatRoomVC: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        print("Message tapped")
    }
    
    func didTapCellTopLabel(in cell: MessageCollectionViewCell) {
        print("Top cell label tapped")
    }
    
    func didTapMessageTopLabel(in cell: MessageCollectionViewCell) {
        print("Top message label tapped")
    }
    
    func didTapMessageBottomLabel(in cell: MessageCollectionViewCell) {
        print("Bottom label tapped")
    }
    
}

// MARK: - MessageLabelDelegate

extension CounselorChatRoomVC: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
}

// MARK: - MessageInputBarDelegate

extension CounselorChatRoomVC: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
        print(Date()) //Date() gives compelete date: 2018-07-17 22:08:20 +0000
        
        let studID = UserDefaults.standard.integer(forKey: "student_id")
        let params: [String: Any] = ["message": text, "chat_id": chat_id!, "student_id": studID, "counselor_id": counselor_id!, "role": role!]
        
        sendData(params: params)
        
        for component in inputBar.inputTextView.components {
            
            if let text = component as? String {
                
                let attributedText = NSAttributedString(string: text, attributes: [.font: UIFont.systemFont(ofSize: 15), .foregroundColor: UIColor.black])
                
                let message = MockMessage(attributedText: attributedText, sender: currentSender(), messageId: UUID().uuidString, date: Date())
                messages.append(message)
                messagesCollectionView.insertSections([messages.count - 1])
            }
            
        }
        //this is annoying
        inputBar.inputTextView.text = String()
        messagesCollectionView.scrollToBottom()
    }
    
    func sendData(params: [String: Any]) {
        Service().sendMessage(parameters: params) { (response) in
            print(response)
        }
    }
    
    @objc func getData() {
        Service().getMessage(chat_id: chat_id!) { (response) in
            let last_message = response["message_last"].stringValue
            let updated_at = response["updated_at"].stringValue
            let studentID = response["student_id"].intValue
            
            self.oppSender = Sender(id: "Student", displayName: "Student")
            print("The tempString is: \(self.tempString)")
            print("The updated_at is: \(updated_at)")
            if self.tempString != updated_at {
                if studentID < 0 {
                    let retrieveMessage = MockMessage(text: last_message, sender: self.oppSender, messageId: UUID().uuidString, date: Date())
                    self.messages.append(retrieveMessage)
                    self.messagesCollectionView.insertSections([self.messages.count - 1])
                }
            }
            self.tempString = updated_at
        }
    }
}



