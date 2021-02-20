import QtQuick 2.7

import MuseScore.Dock 1.0
import MuseScore.Ui 1.0
import MuseScore.Playback 1.0
import MuseScore.NotationScene 1.0
import MuseScore.AppMenu 1.0
import MuseScore.Shortcuts 1.0

import "./HomePage"
import "./NotationPage"
import "./Settings"
import "./DevTools"

DockWindow {
    id: dockWindow

    title: qsTrc("appshell", "MuseScore 4")

    color: ui.theme.backgroundPrimaryColor
    borderColor: ui.theme.strokeColor

    Component.onCompleted: {
        shortcutsModel.load()
        appMenuModel.load()
        api.launcher.open(homePage.uri)
    }

    property var provider: InteractiveProvider {
        topParent: dockWindow
        onRequestedDockPage: {
            dockWindow.currentPageUri = uri
        }
    }

    readonly property int toolbarHeight: 48
    property bool isNotationPage: currentPageUri === notationPage.uri

    property ShortcutsInstanceModel shortcutsModel: ShortcutsInstanceModel {}
    property AppMenuModel appMenuModel: AppMenuModel {}

    menuBar: DockMenuBar {
        objectName: "mainMenuBar"

        items: appMenuModel.items

        onActionTringgered: {
            appMenuModel.handleAction(actionCode, actionIndex)
        }
    }

    toolbars: [
        DockToolBar {
            objectName: "mainToolBar"
            minimumWidth: 282
            minimumHeight: dockWindow.toolbarHeight

            color: dockWindow.color
            allowedAreas: Qt.TopToolBarArea

            content: MainToolBar {
                color: dockWindow.color
                currentUri: dockWindow.currentPageUri

                onSelected: {
                    api.launcher.open(uri)
                }
            }
        },

        DockToolBar {
            id: notationToolBar
            objectName: "notationToolBar"
            minimumWidth: 192
            minimumHeight: dockWindow.toolbarHeight

            color: dockWindow.color
            allowedAreas: Qt.TopToolBarArea

            content: NotationToolBar {
                id: notationToolBarContent
                color: dockWindow.color

                Connections {
                    target: notationToolBar

                    Component.onCompleted: {
                        notationToolBarContent.isToolBarVisible = notationToolBar.visible
                        notationToolBar.visible = Qt.binding(function() { return dockWindow.isNotationPage && notationToolBarContent.isToolBarVisible})

                        notationToolBarContent.load()
                    }

                    function onVisibleEdited(visible) {
                        notationToolBarContent.isToolBarVisible = visible
                    }
                }
            }
        },

        DockToolBar {
            id: playbackToolBar

            objectName: "playbackToolBar"
            minimumWidth: floating ? 508 : 430
            minimumHeight: floating ? 76 : dockWindow.toolbarHeight

            color: dockWindow.color
            allowedAreas: Qt.TopToolBarArea

            content: PlaybackToolBar {
                id: playbackToolBarContent
                color: dockWindow.color
                floating: playbackToolBar.floating

                Connections {
                    target: playbackToolBar

                    Component.onCompleted: {
                        playbackToolBarContent.isToolBarVisible = playbackToolBar.visible
                        playbackToolBar.visible = Qt.binding(function() { return dockWindow.isNotationPage && playbackToolBarContent.isToolBarVisible})

                        playbackToolBarContent.load()
                    }

                    function onVisibleEdited(visible) {
                        playbackToolBarContent.isToolBarVisible = visible
                    }
                }
            }
        },

        DockToolBar	{
            id:undoRedoToolBar
            objectName: "undoRedoToolBar"

            minimumWidth: 72
            minimumHeight: dockWindow.toolbarHeight

            color: dockWindow.color
            floatable: false
            movable: false

            content: UndoRedoToolBar {
                id: undoRedoToolBarContent
                color: dockWindow.color

                Connections {
                    target: undoRedoToolBar

                    Component.onCompleted: {
                        undoRedoToolBarContent.isToolBarVisible = undoRedoToolBar.visible
                        undoRedoToolBar.visible = Qt.binding(function() { return dockWindow.isNotationPage && undoRedoToolBarContent.isToolBarVisible})

                        undoRedoToolBarContent.load()
                    }

                    function onVisibleEdited(visible) {
                        undoRedoToolBarContent.isToolBarVisible = visible
                    }
                }
            }
        }
    ]

    HomePage {
        id: homePage

        uri: "musescore://home"
    }

    NotationPage {
        id: notationPage

        uri: "musescore://notation"
    }

    SequencerPage {
        uri: "musescore://sequencer"
    }

    PublishPage {
        uri: "musescore://publish"
    }

    DevToolsPage {
        uri: "musescore://devtools"
    }
}
