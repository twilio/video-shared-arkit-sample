//
//  ClientViewController.swift
//  DesignConsult
//
//  Created by Jennifer Aprahamian on 10/20/17.
//  Copyright © 2017 Twilio. All rights reserved.
//

import UIKit
import SceneKit
import ARKit
import TwilioVideo

class ClientViewController: UIViewController, ARSCNViewDelegate {
    
    @IBOutlet var sceneView: ARSCNView!
    var accessToken = "TWILIO_ACCESS_TOKEN"
    var room: TVIRoom?
    weak var consumer: TVIVideoCaptureConsumer?
    var frame: TVIVideoFrame?
    var displayLink: CADisplayLink?
    
    var videoTrack: TVILocalVideoTrack?
    var audioTrack: TVILocalAudioTrack?
    var dataTrack: TVIRemoteDataTrack?
    var switchView = UISwitch()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = false
        sceneView.preferredFramesPerSecond = 30
        sceneView.contentScaleFactor = 1.0
        
        // Create a new scene and set it to the view
        let scene = SCNScene()
        self.sceneView.scene = scene
        
        self.videoTrack = TVILocalVideoTrack.init(capturer: self)
        self.audioTrack = TVILocalAudioTrack.init()
        let localDataTrack = TVILocalDataTrack()
        let connectOptions = TVIConnectOptions(token: accessToken, block: {(_ builder: TVIConnectOptionsBuilder) -> Void in
            builder.videoTracks = [self.videoTrack!]
            builder.roomName = "DesignConsult"
            builder.dataTracks = [localDataTrack!]
            builder.preferredVideoCodecs = [TVIVideoCodec.H264.rawValue]
        })
        // Connect to the room
        self.room = TwilioVideo.connect(with: connectOptions, delegate: self)
        
        switchView.addTarget(self, action: #selector(ClientViewController.showFeaturePointsValueChanged(sender:)), for: UIControlEvents.valueChanged)

        self.sceneView.addSubview(switchView)
    }
    
    override func viewWillLayoutSubviews() {
        switchView.frame = CGRect(x: self.view.frame.width - 60, y:20, width: 40, height:20)
    }
    
    @objc func showFeaturePointsValueChanged(sender: UISwitch!) {
        if sender.isOn {
            sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        } else {
            sceneView.debugOptions = []
        }
    }
    
    func placeObjectAtLocation(objectAndLocation: String) {
        // takes pair of object name and location coordinates from Bob's data track
        let objectName = objectAndLocation.components(separatedBy: " ").first
        let range = objectAndLocation.range(of: objectName!)
        
        // trim coordinates into something that can be converted to a CGPoint
        let coordinates = objectAndLocation.substring(from: (range?.upperBound)!)
        let location = coordinates.dropLast().dropFirst().dropFirst()
        let locationPoint: CGPoint = CGPointFromString("{\(location)}")
        let hitResult = self.sceneView.hitTest(locationPoint, types: [.existingPlaneUsingExtent, .estimatedHorizontalPlane])
        if hitResult.count > 0 {
            guard let hitTestResult = hitResult.first else  {
                return
            }
    
            // place chair. refactor this later.
            if objectName == "chair" {
                print("placing chair")
                for childNode in sceneView.scene.rootNode.childNodes {
                    if childNode.name == objectName {
                        childNode.removeFromParentNode()
                    }
                }
                let scene = SCNScene(named: "Models.scnassets/chair/chair.scn")
                let node = scene?.rootNode.childNode(withName: "chair", recursively: false)
                sceneView.scene.lightingEnvironment.contents = scene?.lightingEnvironment.contents
                let worldPosition = hitTestResult.worldTransform
                node?.position = SCNVector3(worldPosition.columns.3.x, worldPosition.columns.3.y, worldPosition.columns.3.z)
                sceneView.scene.rootNode.addChildNode(node!)
            }
            
            // place lamp. refactor this later.
            if objectName == "lamp" {
                print("placing lamp")
                for childNode in sceneView.scene.rootNode.childNodes {
                    if childNode.name == objectName {
                        childNode.removeFromParentNode()
                    }
                }
                let scene = SCNScene(named: "Models.scnassets/lamp/lamp.scn")
                let node = scene?.rootNode.childNode(withName: "lamp", recursively: false)
                sceneView.scene.lightingEnvironment.contents = scene?.lightingEnvironment.contents
                let worldPosition = hitTestResult.worldTransform
                node?.position = SCNVector3(worldPosition.columns.3.x, worldPosition.columns.3.y, worldPosition.columns.3.z)
                sceneView.scene.rootNode.addChildNode(node!)
            }
            
            // place lamp. refactor this later.
            if objectName == "vase" {
                print("placing vase")
                for childNode in sceneView.scene.rootNode.childNodes {
                    if childNode.name == objectName {
                        childNode.removeFromParentNode()
                    }
                }
                let scene = SCNScene(named: "Models.scnassets/vase/vase.scn")
                let node = scene?.rootNode.childNode(withName: "vase", recursively: false)
                sceneView.scene.lightingEnvironment.contents = scene?.lightingEnvironment.contents
                let worldPosition = hitTestResult.worldTransform
                node?.position = SCNVector3(worldPosition.columns.3.x, worldPosition.columns.3.y, worldPosition.columns.3.z)
                sceneView.scene.rootNode.addChildNode(node!)
            }
            
            // place eames. refactor this later.
            if objectName == "eames" {
                print("placing eames")
                for childNode in sceneView.scene.rootNode.childNodes {
                    if childNode.name == objectName {
                        childNode.removeFromParentNode()
                    }
                }
                let scene = SCNScene(named: "Models.scnassets/eames.scn")
                let node = scene?.rootNode.childNode(withName: "eames", recursively: false)
                sceneView.scene.lightingEnvironment.contents = scene?.lightingEnvironment.contents
                let worldPosition = hitTestResult.worldTransform
                node?.position = SCNVector3(worldPosition.columns.3.x, worldPosition.columns.3.y, worldPosition.columns.3.z)
                sceneView.scene.rootNode.addChildNode(node!)
            }
            
        }
        
    }
    
    func startCapture(format: TVIVideoFormat, consumer: TVIVideoCaptureConsumer) {
        self.consumer = consumer
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkDidFire))
        self.displayLink?.preferredFramesPerSecond = self.sceneView.preferredFramesPerSecond
        // Set to half of screen refresh, which should be 30fps.
        //[_displayLink set:30];
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        consumer.captureDidStart(true)
    }
    
    @objc func displayLinkDidFire() {
        // Our capturer polls the ARSCNView's snapshot for processed AR video content, and then copies the result into a CVPixelBuffer.
        // This process is not ideal, but it is the most straightforward way to capture the output of SceneKit.
        let myImage = self.sceneView.snapshot
        
        guard let imageRef = myImage().cgImage else {
            return
        }
        
        // As a TVIVideoCapturer, we must deliver CVPixelBuffers and not CGImages to the consumer.
        if let pixelBuffer = self.copyPixelbufferFromCGImageProvider(image: imageRef) {
            self.frame = TVIVideoFrame(timestamp: Int64((displayLink?.timestamp)! * 1000000),
                                       buffer: pixelBuffer,
                                       orientation: TVIVideoOrientation.up)
            self.consumer?.consumeCapturedFrame(self.frame!)
        }
    }
    
    /**
     * Copying the pixel buffer took ~0.026 - 0.048 msec (iPhone 7 Plus).
     * This pretty fast but still wasteful, it would be nicer to wrap the CGImage and use its CGDataProvider directly.
     **/
    func copyPixelbufferFromCGImageProvider(image: CGImage) -> CVPixelBuffer? {
        let dataProvider: CGDataProvider? = image.dataProvider
        let data: CFData? = dataProvider?.data
        let baseAddress = CFDataGetBytePtr(data!)
        
        /**
         * We own the copied CFData which will back the CVPixelBuffer, thus the data's lifetime is bound to the buffer.
         * We will use a CVPixelBufferReleaseBytesCallback callback in order to release the CFData when the buffer dies.
         **/
        let unmanagedData = Unmanaged<CFData>.passRetained(data!)
        var pixelBuffer: CVPixelBuffer? = nil
        let status = CVPixelBufferCreateWithBytes(nil,
                                                  image.width,
                                                  image.height,
                                                  TVIPixelFormat.format32BGRA.rawValue,
                                                  UnsafeMutableRawPointer( mutating: baseAddress!),
                                                  image.bytesPerRow,
                                                  { releaseContext, baseAddress in
                                                    let contextData = Unmanaged<CFData>.fromOpaque(releaseContext!)
                                                    contextData.release() },
                                                  unmanagedData.toOpaque(),
                                                  nil,
                                                  &pixelBuffer)
        
        if (status != kCVReturnSuccess) {
            return nil;
        }
        
        return pixelBuffer
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }
    
    // MARK: - ARSCNViewDelegate
    
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
        
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
}

// MARK: TVIRoomDelegate
extension ClientViewController : TVIRoomDelegate {
    func didConnect(to room: TVIRoom) {
        if (room.remoteParticipants.count > 0) {
            let remoteParticipant = room.remoteParticipants[0]
            remoteParticipant.delegate = self
        }
    }
    
    func room(_ room: TVIRoom, participantDidConnect participant: TVIRemoteParticipant) {
        participant.delegate = self
    }
}

// MARK: TVIRemoteParticipantDelegate
extension ClientViewController : TVIRemoteParticipantDelegate {
    // Participant has published data track
    func remoteParticipant(_ participant: TVIRemoteParticipant, publishedDataTrack publication: TVIRemoteDataTrackPublication) {
        print("remote participant published data track")
        
        if let remoteTrack = publication.remoteTrack {
            remoteTrack.delegate = self
        }
    }
    
    // Participant has unpublished data track
    func remoteParticipant(_ participant: TVIRemoteParticipant, unpublishedDataTrack publication: TVIRemoteDataTrackPublication) {
        print("unpublished data track exists")
    }
    
    // Data track has been subscribed to and messages can be observed.
    func subscribed(to dataTrack: TVIRemoteDataTrack, publication: TVIRemoteDataTrackPublication, for participant: TVIRemoteParticipant) {
        print("data track has been subscribed and messages can be observed")
        dataTrack.delegate = self
    }
    
    // Data track has been unsubsubscribed from and messages cannot be observed.
    func unsubscribed(from dataTrack: TVIRemoteDataTrack, publication: TVIRemoteDataTrackPublication, for participant: TVIRemoteParticipant) {
        print("unsubscribed from the data track")
    }
}

// MARK : TVIRemoteDataTrackDelegate
extension ClientViewController : TVIRemoteDataTrackDelegate {
    func remoteDataTrack(_ remoteDataTrack: TVIRemoteDataTrack, didReceive message: String) {
        // Do whatever you want with your received message string
        placeObjectAtLocation(objectAndLocation: message)
    }
    
    func remoteDataTrack(_ remoteDataTrack: TVIRemoteDataTrack, didReceive message: Data) {
        // Do whatever you want with your received message data
    }
}

// MARK: TVIVideoCapturer
extension ClientViewController : TVIVideoCapturer {
    var isScreencast: Bool {
        // We want fluid AR content, maintaining the original frame rate.
        return false
    }
    
    var supportedFormats: [TVIVideoFormat] {
        // We only support the single capture format that ARSession provides, and we rasterize the AR scene at 1x.
        // Don't set any specific capture dimensions.
        let format = TVIVideoFormat.init()
        format.frameRate = UInt(sceneView.preferredFramesPerSecond)
        format.pixelFormat = TVIPixelFormat.format32BGRA
        return [format]
    }
    
    func startCapture(_ format: TVIVideoFormat, consumer: TVIVideoCaptureConsumer) {
        self.consumer = consumer
        
        // Starting capture is a two step process. We need to start the ARSession and schedule the CADisplayLinkTimer.
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
        
        self.displayLink = CADisplayLink(target: self, selector: #selector(self.displayLinkDidFire))
        self.displayLink?.preferredFramesPerSecond = self.sceneView.preferredFramesPerSecond
        
        displayLink?.add(to: RunLoop.main, forMode: RunLoopMode.commonModes)
        consumer.captureDidStart(true)
    }
    
    func stopCapture() {
        self.consumer = nil
        self.displayLink?.invalidate()
        self.sceneView.session.pause()
    }
}

