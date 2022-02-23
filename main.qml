import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import AdvancedVisionQtItem 1.0
import QtMultimedia 5.15
import QtGraphicalEffects 1.12
import JD.CFD.QmlGuidelines 1.0
import "qrc:/application/IconContainer"
import JD.CFD.NotificationBanner 1.0

Window {
    id: mainWindow
    objectName: "MainWindow"
    visible: true

    width: 800
    height: 480
    color: "black"

    property bool rearCamMode: false
    property bool frontCamMode: false

    SwipeView
    {
        id: view
        currentIndex: 0
        anchors.fill: parent
        clip: true

        Item {
            id: arodsRear
            objectName: "arodsRear"
            width: mainWindow.rearCamMode ? 800 : 400
            height: 480
            x: mainWindow.rearCamMode ? 0 : 200
            y: 0
            clip: true

            Image {
                id: arodsCameraRear
                source: "qrc:/ux-ngpd/Images/ARODSImageTex.png"
                width: advancedvision.rodsCamWidth
                height: advancedvision.rodsCamHeight
                visible: false
            }

            BrightnessContrast {
                id: arodsElementRear
                source: arodsCameraRear
                width: arodsCameraRear.width
                height: arodsCameraRear.height
                visible: !advancedvision.arodsStreamLost
                property real adjustedScaleX: arodsRear.width / advancedvision.rodsCamWidth
                property real adjustedScaleY: arodsRear.height / advancedvision.rodsCamHeight
                transformOrigin: Item.Center
                rotation: advancedvision.rotationAngle[2]

                transform: [
                    Scale{
                        origin.x: arodsCameraRear.width/2.0;
                        origin.y: arodsCameraRear.height/2.0;
                        xScale: advancedvision.rearMirrorCmd[0] ? -arodsElementRear.adjustedScaleX : arodsElementRear.adjustedScaleX
                        yScale: advancedvision.rearMirrorCmd[1] ? -arodsElementRear.adjustedScaleY : arodsElementRear.adjustedScaleY
                    },
                    Translate{
                        x: (arodsRear.width - arodsCameraRear.width)/2.0
                        y: (arodsRear.height - arodsCameraRear.height)/2.0
                    }
                ]

                brightness: (advancedvision.exposure[0] / 50.0) - 1
                contrast: (advancedvision.contrast[0] / 50.0) - 1
            }

            Item{
                id: guidelinesContainerRear
                width:parent.width
                height:parent.height
                visible: advancedvision.guidelineVisibility
                
                QmlGuidelines{
                    id: guidelinesRear
                    opacity: 0.8
                    width:parent.width
                    height:parent.height
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left

                    Component.onCompleted:{
                        iconContainerRear.tightSpaceClicked.connect(guidelinesRear.updateTightSpaceMode)
                    }

                    alertLevel: advancedvision.alertLevel
                    trajectoryPgnData: advancedvision.trajectoryPgnData
                    // my params

                    lineStart: -3.0
                    lineDistance1: 0.2
                    lineDistance2: 3
                    lineDistance3: 5.5
                    lineDistance4: 8
                    strokeWidth: 3
                    bufferWidth: 0.5
                    aspectTweak:1.00
                    centerLineStrokeWidth1: 4 //bottom yellow line
                    centerLineStrokeWidth2: 2 //top grey line

                    //redistortion parameters
                    cameraFocalLengthX: 0.33308391375
                    cameraFocalLengthY: 0.4416696739583333
                    cameraOpticalCenterX: 0.5013520625
                    cameraOpticalCenterY: 0.5003183385416667
                    redistortionScale: 1.2
                    redistortionCoeff: 6.2

                    //old params (from 844L)
                    cameraTranslationX:4.32800007
                    cameraTranslationY:0.0
                    cameraTranslationZ:-2.35800004
                    cameraRotationY:0.46

                    originToBumper:4.512
                    originToRearAxle:1.85
                    // end old params
                    
                    
                    // verticalFovDegrees: 90.0

                }
            }

            TapHandler{
                acceptedDevices: PointerDevice.Mouse
                
                onTapped: {
                    mainWindow.rearCamMode = !mainWindow.rearCamMode
                    advancedvision.setExpandedViewCamResolution(mainWindow.rearCamMode)
                }
            }

            Button {
                id: menuButtonRear
                width: 100
                height: 66
                anchors.right: parent.right
                anchors.top: parent.top
                background: Image {
                    source: "qrc:/ux-ngpd/Images/arods_icon_container_menu_background.png"
                }
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:parent.verticalCenter
                    source: "qrc:/ux-ngpd/Images/menu.png"
                }
            }

            IconContainer {
                id: iconContainerRear
                anchors.right: menuButtonRear.left
                anchors.top: menuButtonRear.top
            }

            Item{
                id: statusIndicatorRear
                width: 85; height: 67
                visible : false
                Image {
                    id: statusIconRear
                    anchors {
                        left: parent.left
                        leftMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                    source: "qrc:/ux-ngpd/Images/rod_on.png"
                }
            }
        }

        Item {
            id: arodsFront
            objectName: "arodsFront"
            width: mainWindow.frontCamMode ? 800 : 400
            height: 480
            x: mainWindow.frontCamMode ? 0 : 200
            y: 0
            clip: true

            Image {
                id: arodsCameraFront
                source: "qrc:/ux-ngpd/Images/ARODSImageTex.png"
                width: advancedvision.rodsCamWidth
                height: advancedvision.rodsCamHeight
                visible: false
            }

            BrightnessContrast {
                id: arodsElementFront
                source: arodsCameraFront
                width: arodsCameraFront.width
                height: arodsCameraFront.height
                visible: !advancedvision.arodsStreamLost
                property real adjustedScaleX: arodsFront.width / advancedvision.rodsCamWidth
                property real adjustedScaleY: arodsFront.height / advancedvision.rodsCamHeight
                transformOrigin: Item.Center
                rotation: advancedvision.rotationAngle[2]

                transform: [
                    Scale{
                        origin.x: arodsCameraFront.width/2.0;
                        origin.y: arodsCameraFront.height/2.0;
                        xScale: advancedvision.rearMirrorCmd[0] ? -arodsElementFront.adjustedScaleX : arodsElementFront.adjustedScaleX
                        yScale: advancedvision.rearMirrorCmd[1] ? -arodsElementFront.adjustedScaleY : arodsElementFront.adjustedScaleY
                    },
                    Translate{
                        x: (arodsFront.width - arodsCameraFront.width)/2.0
                        y: (arodsFront.height - arodsCameraFront.height)/2.0
                    }
                ]

                brightness: (advancedvision.exposure[0] / 50.0) - 1
                contrast: (advancedvision.contrast[0] / 50.0) - 1
            }

            Item{
                id: guidelinesContainerFront
                width:parent.width
                height:parent.height
                visible: advancedvision.guidelineVisibility
                
                QmlGuidelines{
                    id: guidelinesFront
                    opacity: 0.8
                    width:parent.width
                    height:parent.height
                    anchors.bottom: parent.bottom
                    anchors.left: parent.left

                    Component.onCompleted:{
                        iconContainerFront.tightSpaceClicked.connect(guidelinesFront.updateTightSpaceMode)
                    }

                    alertLevel: advancedvision.alertLevel
                    trajectoryPgnData: advancedvision.trajectoryPgnData
                    // my params

                    lineStart: -3.0
                    lineDistance1: 0.2
                    lineDistance2: 3
                    lineDistance3: 5.5
                    lineDistance4: 8
                    strokeWidth: 3
                    bufferWidth: 0.5
                    aspectTweak:1.00
                    centerLineStrokeWidth1: 4 //bottom yellow line
                    centerLineStrokeWidth2: 2 //top grey line

                    //redistortion parameters
                    cameraFocalLengthX: 0.33308391375
                    cameraFocalLengthY: 0.4416696739583333
                    cameraOpticalCenterX: 0.5013520625
                    cameraOpticalCenterY: 0.5003183385416667
                    redistortionScale: 1.2
                    redistortionCoeff: 6.2

                    //old params (from 844L)
                    cameraTranslationX:4.32800007
                    cameraTranslationY:0.0
                    cameraTranslationZ:-2.35800004
                    cameraRotationY:0.46

                    originToBumper:4.512
                    originToRearAxle:1.85
                    // end old params
                    
                    
                    // verticalFovDegrees: 90.0

                }
            }

            TapHandler{
                acceptedDevices: PointerDevice.Mouse
                
                onTapped: {
                    mainWindow.frontCamMode = !mainWindow.frontCamMode
                    advancedvision.setExpandedViewCamResolution(mainWindow.frontCamMode)
                }
            }

            Button {
                id: menuButtonFront
                width: 100
                height: 66
                anchors.right: parent.right
                anchors.top: parent.top
                background: Image {
                    source: "qrc:/ux-ngpd/Images/arods_icon_container_menu_background.png"
                }
                Image {
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter:parent.verticalCenter
                    source: "qrc:/ux-ngpd/Images/menu.png"
                }
            }

            IconContainer {
                id: iconContainerFront
                anchors.right: menuButtonFront.left
                anchors.top: menuButtonFront.top
            }

            Item{
                id: statusIndicatorFront
                width: 85; height: 67
                visible : false
                Image {
                    id: statusIconFront
                    anchors {
                        left: parent.left
                        leftMargin: 5
                        verticalCenter: parent.verticalCenter
                    }
                    source: "qrc:/ux-ngpd/Images/rod_on.png"
                }
            }
        }
    }
    PageIndicator 
    {
        id: indicator

        count: view.count
        currentIndex: view.currentIndex

        anchors.bottom: view.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }

    Item {
        id: vml
        objectName: "vml"
        width: 200
        height: 480
        x: 0
        y: 0
        clip: true
        visible: !mainWindow.rearCamMode
        
	    Image {
            id: vmlCamera
            source: advancedvision.vmCamMountedFlat ? "Res/Images/VMLImageTexFlat.png" : "Res/Images/VMLImageTex.png"
            width: advancedvision.mirrorCamWidth
            height: advancedvision.mirrorCamHeight
            visible: false
        }

        BrightnessContrast {
            id: vmlElement
            source: vmlCamera
            width: vmlCamera.width
            height: vmlCamera.height
            visible: !advancedvision.vmlStreamLost
            property real adjustedScale: advancedvision.zoomVal[0] * vml.height / (advancedvision.vmCamMountedFlat ? advancedvision.mirrorCamHeight : advancedvision.mirrorCamWidth)
            property real widthDif: vml.width - (advancedvision.vmCamMountedFlat ? advancedvision.mirrorCamWidth : advancedvision.mirrorCamHeight)*adjustedScale
            property real heightDif: vml.height - (advancedvision.vmCamMountedFlat ? advancedvision.mirrorCamHeight : advancedvision.mirrorCamWidth)*adjustedScale

            property real xShiftIncrement: widthDif/(2*advancedvision.numShiftIncrements)
            property real yShiftIncrement: heightDif/(2*advancedvision.numShiftIncrements)
            
            transformOrigin: Item.Center
            rotation: advancedvision.rotationAngle[0]

            transform: [
                Rotation{
                    origin.x: (mainWindow.rearCamMode == true) ? arodsCameraRear.width/2.0 : arodsCameraFront.width/2.0;
                    origin.y: (mainWindow.rearCamMode == true) ? arodsCameraRear.height/2.0 : arodsCameraFront.height/2.0;
                    angle: advancedvision.vmCamMountedFlat ? 0 : 90
                },
                Scale{
                    origin.x: vmlCamera.width/2.0;
                    origin.y: vmlCamera.height/2.0;
                    xScale: advancedvision.leftMirrorCmd[0] ? -vmlElement.adjustedScale : vmlElement.adjustedScale
                    yScale: advancedvision.leftMirrorCmd[1] ? -vmlElement.adjustedScale : vmlElement.adjustedScale
                },
                Translate{
                    x: (vml.width - vmlCamera.width)/2.0 + advancedvision.leftShiftPos[1]*vmlElement.xShiftIncrement
                    y: (vml.height - vmlCamera.height)/2.0 - advancedvision.leftShiftPos[0]*vmlElement.yShiftIncrement
                }
            ]

            brightness: (advancedvision.exposure[1] / 50.0) - 1
            contrast: (advancedvision.contrast[1] / 50.0) - 1
        }

        Rectangle {
            id :circle_indicator
            height : 70 ;width : 70
            opacity: 0.7
            radius : width/2
            visible : false 
            
            Timer {
                id: circle_indicator_timer
                interval : 1000
                running: false
                repeat : true
                triggeredOnStart : true
                onTriggered: circle_indicator.opacity = (!circle_indicator.opacity)?0.7:0
            }
        }

        Rectangle {
            id :border_indicator_rect
            width: parent.width
            height: parent.height
            color : "transparent"
            opacity: 0.7
            border.width : 10
            visible : false

            Timer {
                id: border_indicator_timer
                interval : 1000
                running: false
                repeat : true
                triggeredOnStart: true
                onTriggered: border_indicator_rect.opacity = (!border_indicator_rect.opacity)?0.7:0
            }
        }
    }

    Item {
        id: vmr
        objectName: "vmr"
        width: 200
        height: 480
        x: 600
        y: 0
        clip: true
        visible: !mainWindow.rearCamMode

        Image {
            id: vmrCamera
            source: advancedvision.vmCamMountedFlat ? "Res/Images/VMRImageTexFlat.png" : "Res/Images/VMRImageTex.png"
            width: advancedvision.mirrorCamWidth
            height: advancedvision.mirrorCamHeight
            visible: false
        }

        BrightnessContrast {
            id: vmrElement
            source: vmrCamera
            width: vmrCamera.width
            height: vmrCamera.height
            visible: !advancedvision.vmrStreamLost
            property real adjustedScale: advancedvision.zoomVal[1] * vmr.height / (advancedvision.vmCamMountedFlat ? advancedvision.mirrorCamHeight : advancedvision.mirrorCamWidth)
            property real widthDif: vmr.width - (advancedvision.vmCamMountedFlat ? advancedvision.mirrorCamWidth : advancedvision.mirrorCamHeight)*adjustedScale
            property real heightDif: vmr.height - (advancedvision.vmCamMountedFlat ? advancedvision.mirrorCamHeight : advancedvision.mirrorCamWidth)*adjustedScale

            property real xShiftIncrement: widthDif/(2*advancedvision.numShiftIncrements)
            property real yShiftIncrement: heightDif/(2*advancedvision.numShiftIncrements)
            
            transformOrigin: Item.Center
            rotation: advancedvision.rotationAngle[1]

            transform: [
                Rotation{
                    origin.x: (mainWindow.rearCamMode == true) ? arodsCameraRear.width/2.0 : arodsCameraFront.width/2.0;
                    origin.y: (mainWindow.rearCamMode == true) ? arodsCameraRear.height/2.0 : arodsCameraFront.height/2.0;
                    angle: advancedvision.vmCamMountedFlat ? 0 : 90
                },
                Scale{
                    origin.x: vmrCamera.width/2.0;
                    origin.y: vmrCamera.height/2.0;
                    xScale: advancedvision.rightMirrorCmd[0] ? -vmrElement.adjustedScale : vmrElement.adjustedScale
                    yScale: advancedvision.rightMirrorCmd[1] ? -vmrElement.adjustedScale : vmrElement.adjustedScale
                },
                Translate{
                    x: (vmr.width - vmrCamera.width)/2.0 + advancedvision.rightShiftPos[1]*vmrElement.xShiftIncrement
                    y: (vmr.height - vmrCamera.height)/2.0 - advancedvision.rightShiftPos[0]*vmrElement.yShiftIncrement
                }
            ]

            brightness: (advancedvision.exposure[2] / 50.0) - 1
            contrast: (advancedvision.contrast[2] / 50.0) - 1
        }
    }

    Rectangle{
        id: verticallDividerOne
        width: 5
        height: 480
        color: "black"
        x:200 - (width/2)
        y:0
        visible: !mainWindow.rearCamMode
    }

    Rectangle{
        id: verticallDividerTwo
        width: 5
        height: 480
        color: "black"
        x:600 - (width/2)
        y:0
        visible: !mainWindow.rearCamMode
    }
    
    AdvancedVisionQtItem{
        id: advancedvision
        
        Component.onCompleted:{
            if(mainWindow.rearCamMode == true)
            {
                iconContainerRear.tightSpaceClicked.connect(advancedvision.updateTightSpaceMode);
                iconContainerRear.muteClicked.connect(advancedvision.updateMuteMode);
            }
            else if(mainWindow.frontCamMode == true)
            {
                iconContainerFront.tightSpaceClicked.connect(advancedvision.updateTightSpaceMode);
                iconContainerFront.muteClicked.connect(advancedvision.updateMuteMode);
            }
        }
        
        onLanguageChanged:{
            console.log("Current language: "+advancedvision.language)
        }
        
        onColorBlindAssistModeChanged: {
            border_indicator_rect.border.color = (colorBlindAssistMode) ? "#9BB4FF" : "#FFFF00";
            circle_indicator.color = (colorBlindAssistMode) ? "#9BB4FF" : "#FFFF00";
        }

        onSetIndicatorStatus: {
            if (side != "None")
            {
                if(indicatorTypeBorder)
                {
                    border_indicator_rect.border.color = (colorBlindAssistMode) ? "#9BB4FF" : "#FFFF00";
                    border_indicator_rect.visible = true;
                    if(flashingActive) {border_indicator_timer.start();border_indicator_timer.running  = true;};
                }
                else
                {
                    if(side == "left")
                    {
                        circle_indicator.transformOrigin = Item.TopRight;
                        circle_indicator.x = 700; circle_indicator.y = 40;
                        circle_indicator.visible = true;
                        circle_indicator.color = (colorBlindAssistMode) ? "#9BB4FF" : "#FFFF00";
                        if(flashingActive) {circle_indicator_timer.start();circle_indicator_timer.running = true;};
                    }
                    else
                    {
                        circle_indicator.transformOrigin = Item.BottomRight;
                        circle_indicator.x = 700; circle_indicator.y = 360;
                        circle_indicator.color = (colorBlindAssistMode) ? "#9BB4FF" : "#FFFF00";
                        circle_indicator.visible = true;
                        if(flashingActive) {circle_indicator_timer.start();circle_indicator_timer.running = true;};
                    }
                }
            }
            else
            {
                border_indicator_rect.visible = false;
                border_indicator_timer.running  = false;
                circle_indicator.visible = false;
                circle_indicator_timer.running  = false;
            }
        }

        onUpdateStatusIcon: {
            // Temporary implementation which will later be changed to show appropriate status icon similar to AdvancedRODS implementation
            if(mainWindow.rearCamMode == true)
            {
                statusIndicatorRear.visible = iconState
            }
            else if (mainWindow.frontCamMode == true)
            {
                statusIndicatorFront.visible = iconState
            }
        }
    }
    
    NotificationStack {
        id: notificationstack
        transformOrigin: Item.TopLeft
        scale: 0.85
    }
}
