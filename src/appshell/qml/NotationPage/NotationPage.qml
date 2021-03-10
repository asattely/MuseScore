import QtQuick 2.7
import QtQuick.Controls 2.2

import MuseScore.Ui 1.0
import MuseScore.Dock 1.0
import MuseScore.AppShell 1.0
import MuseScore.NotationScene 1.0
import MuseScore.Palette 1.0
import MuseScore.Inspector 1.0
import MuseScore.Instruments 1.0

DockPage {
    id: notationPage
    objectName: "Notation"

    property var color: ui.theme.backgroundPrimaryColor
    property var borderColor: ui.theme.strokeColor

    property NotationPageModel pageModel: NotationPageModel {}

    Component.onCompleted: {
        pageModel.isPalettePanelVisible = palettePanel.visible
        palettePanel.visible = Qt.binding(function() { return pageModel.isPalettePanelVisible })

        pageModel.isInstrumentsPanelVisible = instrumentsPanel.visible
        instrumentsPanel.visible = Qt.binding(function() { return pageModel.isInstrumentsPanelVisible })

        pageModel.isInspectorPanelVisible = inspectorPanel.visible
        inspectorPanel.visible = Qt.binding(function() { return pageModel.isInspectorPanelVisible })

        pageModel.isNoteInputBarVisible = notationNoteInputBar.visible
        notationNoteInputBar.visible = Qt.binding(function() { return pageModel.isNoteInputBarVisible })

        pageModel.init()
    }

    toolbar: DockToolBar {
        id: notationNoteInputBar
        objectName: "notationNoteInputBar"

        minimumWidth: orientation == Qt.Horizontal ? 900 : 96
        minimumHeight: orientation == Qt.Horizontal ? 48 : 0

        color: notationPage.color

        onVisibleEdited: {
            notationPage.pageModel.isNoteInputBarVisible = visible
        }

        content: NoteInputBar {
            color: notationNoteInputBar.color
            orientation: notationNoteInputBar.orientation
        }
    }

    readonly property int defaultPanelWidth: 272
    readonly property int minimumPanelWidth: 200

    panels: [
        DockPanel {
            id: palettePanel
            objectName: "palettePanel"

            title: qsTrc("appshell", "Palette")

            width: defaultPanelWidth
            minimumWidth: minimumPanelWidth

            color: notationPage.color
            borderColor: notationPage.borderColor

            floatable: true
            closable: true

            onVisibleEdited: {
                notationPage.pageModel.isPalettePanelVisible = visible
            }

            PalettesWidget {}
        },

        DockPanel {
            id: instrumentsPanel
            objectName: "instrumentsPanel"

            title: qsTrc("appshell", "Instruments")

            width: defaultPanelWidth
            minimumWidth: minimumPanelWidth

            color: notationPage.color
            borderColor: notationPage.borderColor

            tabifyObjectName: "palettePanel"

            floatable: true
            closable: true

            onVisibleEdited: {
                notationPage.pageModel.isInstrumentsPanelVisible = visible
            }

            InstrumentsPanel {
                anchors.fill: parent
            }
        },

        DockPanel {
            id: inspectorPanel
            objectName: "inspectorPanel"

            title: qsTrc("appshell", "Inspector")

            width: defaultPanelWidth
            minimumWidth: minimumPanelWidth

            color: notationPage.color
            borderColor: notationPage.borderColor

            tabifyObjectName: "instrumentsPanel"

            floatable: true
            closable: true

            onVisibleEdited: {
                notationPage.pageModel.isInspectorPanelVisible = visible
            }

            InspectorForm {
                anchors.fill: parent
            }
        },

        DockPanel {
            id: autobotPanel
            objectName: "autobotPanel"

            title: "Autobot"

            width: defaultPanelWidth
            minimumWidth: minimumPanelWidth

            color: notationPage.color
            borderColor: notationPage.borderColor

            tabifyObjectName: "autobotPanel"
            area: Qt.RightDockWidgetArea
            floatable: true
            closable: true

            Loader {
                anchors.fill: parent
                source: "qrc:/qml/DevTools/Autobot/AutobotPanel.qml"
            }
        }
    ]

    central: DockCentral {
        id: notationCentral
        objectName: "notationCentral"

        NotationView {
            id: notationView

            isNavigatorVisible: notationPage.pageModel.isNotationNavigatorVisible

            onTextEdittingStarted: {
                notationCentral.forceActiveFocus()
            }
        }
    }

    statusbar: DockStatusBar {
        id: notationStatusBar
        objectName: "notationStatusBar"

        width: notationPage.width
        color: notationPage.color

        visible: notationPage.pageModel.isStatusBarVisible

        NotationStatusBar {
            anchors.fill: parent
            color: notationStatusBar.color
        }
    }
}
