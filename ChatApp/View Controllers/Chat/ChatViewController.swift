//
//  ChatViewController.swift
//  Akhdmny
//
//  Created by Umer Jabbar on 10/09/2018.
//  Copyright © 2018 ZotionApps. All rights reserved.
//

import UIKit
import MessageKit
import MapKit
import AVKit
import FirebaseDatabase
import FirebaseStorage
import SwiftyJSON
//import IQKeyboardManagerSwift
import IQMediaPickerController
import Gallery
import Lightbox
import AVKit
//import SwiftMessages
//import AlamofireImage
import Kingfisher

internal class ChatViewController: MessagesViewController {
    
    let viewModel = ChatViewModel()
    
    var themeColor = UIColor(red: 98/225, green: 194/225, blue: 238/225, alpha: 1.0)
    var mediaController = IQMediaPickerController()
    var gallery : GalleryController!
    var imagesArray = [UIImage]()
    let refreshControl = UIRefreshControl()
    var isTyping = false
    
    lazy var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Chat"
        
        self.slack()
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messagesCollectionView.messageCellDelegate = self
        messageInputBar.delegate = self
        
        messageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        scrollsToBottomOnKeybordBeginsEditing = true // default false
        maintainPositionOnKeyboardFrameChanged = true // default false
        
        self.messagesCollectionView.backgroundColor = #colorLiteral(red: 0.9281727137, green: 0.9281727137, blue: 0.9281727137, alpha: 1)
        
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "genre"), style: .plain, target: self, action: #selector(closeButtonAction))
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        
        self.viewModel.delegate = self
        self.viewModel.setup()
        self.viewModel.observeNewMessage()
        
        if let vi = self.view.viewWithTag(12) {
            self.view.addSubview(vi)
            messagesCollectionView.contentInset = UIEdgeInsets(top: vi.frame.height, left: 0, bottom: inputAccessoryView?.frame.height ?? 0, right: 0)
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.resignFirstResponder()
        self.view.endEditing(true)
        self.viewModel.killAllObservers()
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @objc func closeButtonAction() {
        self.dismiss(animated: true, completion: nil)
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
            label.text = "is typing..."
            label.font = UIFont.systemFont(ofSize: 12)
            messageInputBar.topStackView.addArrangedSubview(label)
            messageInputBar.topStackViewPadding.top = 6
            messageInputBar.topStackViewPadding.left = 12
            messageInputBar.backgroundColor = messageInputBar.backgroundView.backgroundColor
        }
    }
    
    @objc func loadMoreMessages() {
        
    }
    
    // MARK: - Keyboard Style
    
    func slack() {
        //        defaultStyle()
        messageInputBar.backgroundView.backgroundColor = .white
        messageInputBar.isTranslucent = false
        messageInputBar.inputTextView.backgroundColor = .clear
        messageInputBar.inputTextView.layer.borderWidth = 0
        messageInputBar.inputTextView.textAlignment = .natural

        messageInputBar.inputTextView.placeholder = "New Message"
        
        let items = [
            makeButton(named: "icons8-add_camera").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
                }.configure({ (button) in
                    button.setTitle("image", for: .normal)
                    button.setTitleColor(UIColor.clear, for: .normal)
                    button.setTitleColor(UIColor.clear, for: .highlighted)
                    button.setTitleColor(UIColor.clear, for: .disabled)
                }),
            makeButton(named: "icons8-microphone2").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
                }.configure({ (button) in
                    button.setTitle("audio", for: .normal)
                    button.setTitleColor(UIColor.clear, for: .normal)
                    button.setTitleColor(UIColor.clear, for: .highlighted)
                    button.setTitleColor(UIColor.clear, for: .disabled)
                }),
            makeButton(named: "icons8-marker").onTextViewDidChange { button, textView in
                button.isEnabled = textView.text.isEmpty
                }.configure({ (button) in
                    button.setTitle("location", for: .normal)
                    button.setTitleColor(UIColor.clear, for: .normal)
                    button.setTitleColor(UIColor.clear, for: .highlighted)
                    button.setTitleColor(UIColor.clear, for: .disabled)
                }),
            .flexibleSpace,
            
            messageInputBar.sendButton
                .configure {
                    $0.layer.cornerRadius = 8
                    $0.layer.borderWidth = 1.5
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.setTitleColor(.white, for: .normal)
                    $0.setTitleColor(.white, for: .highlighted)
                    $0.setTitle("Send", for: .normal)
                    $0.setSize(CGSize(width: 60, height: 30), animated: true)
                }.onDisabled {
                    $0.layer.borderColor = $0.titleColor(for: .disabled)?.cgColor
                    $0.backgroundColor = .white
                }.onEnabled {
                    $0.backgroundColor = self.themeColor
                    $0.layer.borderColor = UIColor.clear.cgColor
                }.onSelected {
                    // We use a transform becuase changing the size would cause the other views to relayout
                    $0.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
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
    
    func defaultStyle() {
        let newMessageInputBar = MessageInputBar()
        newMessageInputBar.sendButton.tintColor = UIColor(red: 69/255, green: 193/255, blue: 89/255, alpha: 1)
        newMessageInputBar.delegate = self
        messageInputBar = newMessageInputBar
        
        reloadInputViews()
    }
    
    // MARK: - Helpers
    
    func makeButton(named: String) -> InputBarButtonItem {
        return InputBarButtonItem()
            .configure {
                $0.spacing = .fixed(10)
                $0.image = UIImage(named: named)?.withRenderingMode(.alwaysTemplate)
                $0.setSize(CGSize(width: 30, height: 30), animated: true)
            }.onSelected {
                $0.tintColor = self.themeColor
            }.onDeselected {
                $0.tintColor = UIColor.lightGray
            }.onTouchUpInside { item in
                print("Item Tapped \(item.title ?? "no name")")
                if item.title == "location" {
                    
                }else if item.title == "image" {
                    
//                    self.gallery = GalleryController()
//                    Config.Camera.recordLocation = false
//                    Config.Camera.imageLimit = 10
//                    Config.tabsToShow = [.imageTab, .cameraTab]
//                    self.gallery.delegate = self
//                    self.present(self.gallery, animated: true, completion: nil)
                    
                }else if item.title == "audio" {
                    
//                    self.mediaController = IQMediaPickerController()
//                    self.mediaController.delegate = self
//                    self.mediaController.audioMaximumDuration = 120
//                    self.mediaController.allowsPickingMultipleItems = false
//                    self.mediaController.sourceType = .cameraMicrophone
//                    self.mediaController.mediaTypes = [3]
//                    self.present(self.mediaController, animated: true, completion: {
//                        self.mediaController.startAudioCapture()
//                    })
                }
        }
    }
}

// MARK: - MessagesDataSource

extension ChatViewController: MessagesDataSource {
    
    func currentSender() -> Sender {
        return Sender(id: "\(self.viewModel.currentUser.id!)", displayName: "\(self.viewModel.currentUser.name!)")
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return self.viewModel.messageList.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return self.viewModel.messageList[indexPath.section]
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return NSAttributedString(string: self.viewModel.messageList[indexPath.section].sentDate.getString(to: "h:mm a"), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 12), NSAttributedString.Key.foregroundColor: UIColor.lightGray])
    }
    
    func messageTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if !isFromCurrentSender(message: message){
        let name = message.sender.displayName
            return NSAttributedString(string: name, attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption1)])
        }else{
            return NSAttributedString(string: "")
        }
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        
//        let dateString = formatter.string(from: message.sentDate)
        if self.isFromCurrentSender(message: message){
//            let status = message.status
//            if status.isRead{
//                let attachment = NSTextAttachment()
//                attachment.image = #imageLiteral(resourceName: "read")
//                attachment.bounds = CGRect(x: 0, y: -5, width: 16, height: 16)
////                attributedString.append(NSAttributedString(attachment: attachment))
//                return NSAttributedString(attachment: attachment)
//            }else if status.isDelivered{
////                var attributedString = NSAttributedString(string: )
//                let attachment = NSTextAttachment()
//                attachment.image = #imageLiteral(resourceName: "sent")
//                attachment.bounds = CGRect(x: 0, y: -5, width: 16, height: 16)
////                attributedString.append(NSAttributedString(attachment: attachment))
//                return NSAttributedString(attachment: attachment)
//            }
        }
        return NSAttributedString(string: "", attributes: [NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .caption2)])
    }
    
}

// MARK: - MessagesDisplayDelegate

extension ChatViewController: MessagesDisplayDelegate {
    
    // MARK: - Text Messages
    
    func textColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .white : .darkGray
    }
    
    func detectorAttributes(for detector: DetectorType, and message: MessageType, at indexPath: IndexPath) -> [NSAttributedString.Key: Any] {
        return MessageLabel.defaultAttributes
    }
    
    func enabledDetectors(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> [DetectorType] {
        return [.url, .address, .phoneNumber, .date, .transitInformation]
    }
    
    // MARK: - All Messages
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
//        return isFromCurrentSender(message: message) ? themeColor : UIColor(red: 230/255, green: 230/255, blue: 230/255, alpha: 1)
        return isFromCurrentSender(message: message) ? themeColor : #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
//        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
//        return .bubbleTail(corner, .pointedEdge)
        return .custom({ (messageContainer) in
            messageContainer.cornerRadius = 6
            messageContainer.shadowColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
            messageContainer.shadowRadius = 2
            messageContainer.shadowOpacity = 0.3
            if self.isFromCurrentSender(message: message){
            }else{
                messageContainer.borderWidth = 2
                messageContainer.borderColor = self.themeColor
            }
        })
        //        let configurationClosure = { (view: MessageContainerView) in}
        //        return .custom(configurationClosure)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        let avatar = Avatar(initials: "\(message.sender.displayName.first ?? "A")")
        avatarView.set(avatar: avatar)
    }
    
    func configureMediaMessageImageView(_ imageView: UIImageView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        switch message.kind {
        case .photo(let media):
            if let url = media.url {
                imageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder-profile-sq"))
                imageView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
                imageView.layer.borderWidth = 1
            }
            break
        case .audio(_):

            break
        default:
            break
        }
    }
    
    
//    func avatarPosition(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> AvatarPosition {
//        return AvatarPosition(horizontal: .natural, vertical: .cellTop)
//    }
    
    
    
    // MARK: - Location Messages
    
    func annotationViewForLocation(message: MessageType, at indexPath: IndexPath, in messageCollectionView: MessagesCollectionView) -> MKAnnotationView? {
        let annotationView = MKAnnotationView(annotation: nil, reuseIdentifier: nil)
        let pinImage = #imageLiteral(resourceName: "icons8-order_on_the_way_filled")
        annotationView.image = pinImage
        annotationView.centerOffset = CGPoint(x: 0, y: -pinImage.size.height / 2)
        return annotationView
    }
    
    func animationBlockForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> ((UIImageView) -> Void)? {
        return { view in
            view.layer.transform = CATransform3DMakeScale(0, 0, 0)
            view.alpha = 0.0
            UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0, options: [], animations: {
                view.layer.transform = CATransform3DIdentity
                view.alpha = 1.0
            }, completion: nil)
        }
    }
    
    func snapshotOptionsForLocation(message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> LocationMessageSnapshotOptions {
        
        return LocationMessageSnapshotOptions()
    }
}

// MARK: - MessagesLayoutDelegate

extension ChatViewController: MessagesLayoutDelegate {
    
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 18
    }
    
    func messageTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if !isFromCurrentSender(message: message){
            return 16
        }else{
            return 0
        }
    }
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 16
    }
}

// MARK: - MessageCellDelegate
extension ChatViewController: MessageCellDelegate {
    
    func didTapAvatar(in cell: MessageCollectionViewCell) {
        print("Avatar tapped")
    }
    
    func didTapMessage(in cell: MessageCollectionViewCell) {
        if let cell = cell as? MediaMessageCell {
            switch cell.kind {
                
            case .photo(_)?:
                var images = [LightboxImage]()
                if let image = cell.imageView.image{
                    images.append(LightboxImage(image : image))
                }else{
                    if let audioUrl = cell.url {
                        images.append(LightboxImage(imageURL: audioUrl))
                    }else{
                        break
                    }
                }
                DispatchQueue.main.async {
                    let lightbox = LightboxController(images: images, startIndex: 0)
                    lightbox.dismissalDelegate = self
                    lightbox.dynamicBackground = true
                    self.present(lightbox, animated: true, completion: nil)
                }
                break
            case .audio(_)?:
                if let url = cell.url{
                    let vc = AVPlayerViewController()
                    vc.player = AVPlayer(url: url)
                    self.present(vc, animated: true, completion: {
                        vc.player?.play()
                    })
                    print("Media Message Tapped \(String(describing:  url))")
                }
                break
            default:
                break
            }
            
        }else if let cd = cell as? LocationMessageCell {
            print("Media Message Tapped \( cell)")
            
//            guard let coordinates = cd.location?.coordinate else{return}
//
//            if let url = URL(string: "comgooglemaps://?saddr=&daddr=\(coordinates.latitude),\(coordinates.longitude)&directionsmode=driving") {
//                UIApplication.shared.open(url, options: [:])
//            }
        }
    
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

extension ChatViewController: MessageLabelDelegate {
    
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

extension ChatViewController: MessageInputBarDelegate {
    
    
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        
        // Each NSTextAttachment that contains an image will count as one empty character in the text: String
       
        
        for component in inputBar.inputTextView.components {
            if let text = component as? String {
                
                self.viewModel.sendMessage(body: text, type: 1)
            }
        }
        
        inputBar.inputTextView.text = String()
        self.messagesCollectionView.scrollToBottom()
        
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
        print("asdasd")
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        var visibleRect = CGRect()
        
        visibleRect.origin = self.messagesCollectionView.contentOffset
        visibleRect.size = self.messagesCollectionView.bounds.size
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        
        guard let indexPath = self.messagesCollectionView.indexPathForItem(at: visiblePoint) else { return }
        
        print(" \(indexPath)")
        if indexPath.section == 3 {
            self.viewModel.onLoadEarlier()
        }
    }
    
    
//    func notifyUser(message : Message, currentOrder : OrderRequest){
//        var id = 0
//        if AppDefaults.appType == .driver{
//            id = currentOrder.userInfo.id
//        }else{
//            id = currentOrder.driver?.id ?? 0
//        }
//
//        switch message.type {
//
//        case 1:
//            let urlParams = [ "userId": "\(id)", "order_id" : "Chat", "title": "Message from \(self.currentSender().displayName.capitalized)", "body" : "\(message.body ?? "n/a")"] as [String : Any]
//            UserNotificationHandler.shared.sendNotification(userInfo: urlParams, success: { (success) in
//                print(success)
//            })
//            break
//        case 2:
//            let urlParams = [ "userId": "\(id)", "order_id" : "Chat", "title": "Message from \(self.currentSender().displayName.capitalized)", "body" : "has sent a location"] as [String : Any]
//            UserNotificationHandler.shared.sendNotification(userInfo: urlParams, success: { (success) in
//
//            })
//            break
//        case 3:
//            let urlParams = [ "userId": "\(id)", "order_id" : "Chat", "title": "Message from \(self.currentSender().displayName.capitalized)", "body" : "has sent an image"] as [String : Any]
//            UserNotificationHandler.shared.sendNotification(userInfo: urlParams, success: { (success) in
//
//            })
//            break
//        case 4:
//            let urlParams = [ "userId": "\(id)", "order_id" : "Chat", "title": "Message from \(self.currentSender().displayName.capitalized)", "body" : "has sent an audio"] as [String : Any]
//            UserNotificationHandler.shared.sendNotification(userInfo: urlParams, success: { (success) in
//
//            })
//            break
//        default:
//            break
//        }
//    }
    
    func setMessageReadStatus (message : Message){
//        if message.senderId != "\(AppStateManager.sharedInstance.loggedInUser.id)" {
//            Database.database().reference().child("Chat").child("\(currentOrder.orderId ?? -99)").child("messages").child(message.id).child("isRead").setValue(true)
//        }
    }
    
}


//
//extension ChatViewController : GMSPlacePickerViewControllerDelegate {
//
//    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
//
//        let body = "\(place.coordinate.latitude),\(place.coordinate.longitude)"
//        self.sendMessage(body: body, type: 2)
//        self.messagesCollectionView.scrollToBottom()
//        self.dismiss(animated: true, completion: nil)
//        self.messagesCollectionView.reloadData()
//    }
//
//    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
//        self.dismiss(animated: true, completion: nil)
//        self.messagesCollectionView.reloadData()
//    }
//}


extension ChatViewController : GalleryControllerDelegate {
    
    func galleryController(_ controller: GalleryController, didSelectImages images: [Gallery.Image]) {
        _ = images.map{
            $0.resolve(completion: { (image) in
                if let image = image{
                    self.imagesArray.append(image)
                    DispatchQueue.main.async {
                        if let data = image.jpegData(compressionQuality: 0.6){
                            let ref = Database.database().reference()
                            let key = "\(ref.childByAutoId().key ?? "random").jpg"
                            let refStorage = Storage.storage().reference().child("Orders").child("asd").child("images").child(key)
                            refStorage.putData(data, metadata: nil, completion: { (snapShot, error) in
                                    refStorage.downloadURL(completion: { (url, error) in
                                        if let downloadUrl = url {
                                            self.viewModel.sendMessage(body: downloadUrl.absoluteString, type: 3)
                                        }
                                        if let err = error {
                                            self.showErrorWith(message: err.localizedDescription)
                                        }
                                    })
                                if let err = error {
                                    self.showErrorWith(message: err.localizedDescription)
                                }
                            })
                        }
                    }
                    
                }
            })
        }
        controller.dismiss(animated: true)
    }
    
    func galleryController(_ controller: GalleryController, didSelectVideo video: Video) {
        
    }
    
    func galleryController(_ controller: GalleryController, requestLightbox images: [Gallery.Image]) {
        Image.resolve(images: images, completion: { [weak self] resolvedImages in
            self?.showLightbox(images: resolvedImages.compactMap({ $0 }))
        })
    }
    
    func galleryControllerDidCancel(_ controller: GalleryController) {
        controller.dismiss(animated: true)
    }
    
    func showLightbox(images: [UIImage]) {
        guard images.count > 0 else {
            return
        }
        
        let lightboxImages = images.map({ LightboxImage(image: $0) })
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        lightbox.dismissalDelegate = self
        lightbox.dynamicBackground = true
        gallery.present(lightbox, animated: true, completion: nil)
    }
}

extension ChatViewController : LightboxControllerDismissalDelegate {
    func lightboxControllerWillDismiss(_ controller: LightboxController) { }
}


extension ChatViewController : IQMediaPickerControllerDelegate {
    
    func mediaPickerController(_ controller: IQMediaPickerController, didFinishMedias selection: IQMediaPickerSelection) {
        DispatchQueue.main.async {
            guard let url = selection.selectedAssetsURL.first else{return}
            guard let data = try? Data(contentsOf: url) else{return}
            let ref = Database.database().reference()
            let key = "\(ref.childByAutoId().key ?? "random").mp3"
            let refStorage = Storage.storage().reference().child("Orders").child("asd").child("audios").child(key)
            refStorage.putData(data, metadata: nil, completion: { (snapShot, error) in
                refStorage.downloadURL(completion: { (url, error) in
                    if let downloadUrl = url {
                        self.viewModel.sendMessage(body: downloadUrl.absoluteString, type: 4)
                    }
                    if let err = error {
                        self.showErrorWith(message: err.localizedDescription)
                    }
                })
                if let err = error {
                    self.showErrorWith(message: err.localizedDescription)
                }
            })
        }
    }
    
    func mediaPickerControllerDidCancel(_ controller: IQMediaPickerController) {
        self.mediaController.stopAudioCapture()
    }
}


extension ChatViewController : ChatResponseDelegate {
    
    func previousDataReceived() {
        DispatchQueue.main.async {
            self.messagesCollectionView.reloadDataAndKeepOffset()
        }
    }
    
    func newMessageReceived(message : MyMessage) {
        DispatchQueue.main.async {
            self.viewModel.messageList.append(message)
//            self.messagesCollectionView.insertSections([self.viewModel.messageList.count - 1])
            self.messagesCollectionView.reloadData()
            self.messagesCollectionView.scrollToBottom(animated: true)
        }
    }
    
    func messageSent() {
        print("Message Sent")
    }
    

}



extension ChatViewController {
    
    func showErrorWith(message: String){
//        var config = SwiftMessages.Config()
//        config.presentationStyle = .top
//        let error = MessageView.viewFromNib(layout: .tabView)
//        error.configureContent(title: "Error", body: message)
//        let iconStyle:IconStyle = .default
//        let iconImage = iconStyle.image(theme: .error)
//        error.configureTheme(backgroundColor: UIColor("BC4C46"), foregroundColor: .white, iconImage: iconImage)
//        error.button?.isHidden = true
//        SwiftMessages.show(config: config, view: error)
    }
    
}
