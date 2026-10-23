import QtQuick
import Quickshell
import Quickshell.Io
import qs.Commons
import qs.Ui

BarWidget {
  id: root
  moduleName: "jovibe.net-usage"

  property string sessionText: ""
  property string sessionTooltip: ""
  property string dailyText: "▦ 0.0 MB"
  property string dailyTooltip: "Daily network usage"

  function updateSession(raw) {
    var data = Util.parseModuleJson(raw)
    sessionText = data.text || ""
    sessionTooltip = data.tooltip || ""
  }

  function updateDaily(raw) {
    var data = Util.parseModuleJson(raw)
    dailyText = data.text || "▦ 0.0 MB"
    dailyTooltip = data.tooltip || "Daily network usage"
  }

  readonly property var runtimeDir: Quickshell.env("XDG_RUNTIME_DIR") || ("/run/user/" + Quickshell.env("UID"))
  readonly property string monitorPath: decodeURIComponent(
    Qt.resolvedUrl("bin/omarchy-net-monitor").toString().replace(/^file:\/\//, ""))

  // The widget owns the accounting daemon: it starts with the widget and is
  // stopped by Quickshell when the widget is disabled or the shell exits.
  Process {
    id: daemon
    command: ["python3", root.monitorPath]
    running: true

    onExited: function(exitCode) {
      if (exitCode === 0) return
      restartTimer.restart()
    }
  }

  Timer {
    id: restartTimer
    interval: 3000
    repeat: false
    onTriggered: if (!daemon.running) daemon.running = true
  }

  Process {
    id: sessionProc
    command: ["bash", "-c", "cat " + root.runtimeDir + "/omarchy-net/session.json 2>/dev/null || true"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateSession(text)
    }
  }

  Process {
    id: dailyProc
    command: ["bash", "-c", "cat " + root.runtimeDir + "/omarchy-net/daily.json 2>/dev/null || true"]
    stdout: StdioCollector {
      waitForEnd: true
      onStreamFinished: root.updateDaily(text)
    }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      if (!sessionProc.running) sessionProc.running = true
      if (!dailyProc.running) dailyProc.running = true
    }
  }

  implicitWidth: layout.implicitWidth
  implicitHeight: layout.implicitHeight

  Row {
    id: layout
    spacing: Style.space(2)
    anchors.verticalCenter: parent.verticalCenter

    WidgetButton {
      id: sessionBtn
      bar: root.bar
      visible: root.sessionText !== ""
      text: root.sessionText
      tooltipText: root.sessionTooltip
      horizontalMargin: 6
      verticalPadding: 4
      fontSize: 12
    }

    WidgetButton {
      id: dailyBtn
      bar: root.bar
      text: root.dailyText
      tooltipText: root.dailyTooltip
      horizontalMargin: 6
      verticalPadding: 4
      fontSize: 12
    }
  }
}
